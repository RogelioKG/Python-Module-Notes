# pyee

[![RogelioKG/pyee](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pyee)

## References
+ 🔗 [**六小編 Editor Leon - 從 pyee 認識觀察者模式**](https://editor.leonh.space/2024/ee/)

## Brief
+ Observer Pattern 的實作
+ 仿照 Node.js 中的 event emitter

## Example

### `EventEmitter`
```py
from pyee import EventEmitter

ee = EventEmitter()


@ee.once("system_init")
def on_init(version: str):
    print(f"System initializing... Version: {version}")


@ee.on("message")
def on_message(msg: str, **kwargs):
    sender = kwargs.get("sender", "Anonymous")
    priority = kwargs.get("priority", "Normal")
    print(f"Message from {sender} [{priority}]: {msg}")


if __name__ == "__main__":
    print("--- First Batch ---")
    ee.emit("system_init", "v1.0.0")
    ee.emit("message", "Hello World", sender="Bob", priority="High")
    # --- First Batch ---
    # System initializing... Version: v1.0.0
    # Message from Bob [High]: Hello World

    print("\n--- Second Batch ---")
    ee.emit("system_init", "v1.0.1")
    ee.emit("message", "Keep it simple", sender="Charlie")
    # --- Second Batch ---
    # Message from Charlie [Normal]: Keep it simple
```

### `AsyncIOEventEmitter`
```py
import asyncio

from pyee.asyncio import AsyncIOEventEmitter

ee = AsyncIOEventEmitter()


@ee.on("upload_file")
async def handle_upload(filename: str):
    print(f"Starting upload for: {filename}...")
    await asyncio.sleep(5)
    print(f"Upload complete: {filename}")


@ee.on("error")
async def log_error(err: Exception):
    print(f"Error caught: {str(err)}")


async def main():
    print("--- Async Task Started ---")
    ee.emit("upload_file", "photo.jpg")
    ee.emit("upload_file", "data.csv")
    print("Events emitted. Doing other work while waiting...")
    await asyncio.sleep(1.0)
    print("--- Async Task Finished ---")


if __name__ == "__main__":
    asyncio.run(main())
    # --- Async Task Started ---
    # Events emitted. Doing other work while waiting...
    # Starting upload for: photo.jpg...
    # Starting upload for: data.csv...
    # --- Async Task Finished ---
```

## Implementation

> 實作真的很簡單，放上來看一遍就懂了

```py
from asyncio import AbstractEventLoop, Future, ensure_future, iscoroutine, wait
from collections import OrderedDict
from collections.abc import Callable, Mapping
from threading import Lock
from typing import (
    Any,
    TypeVar,
    cast,
    overload,
)


class PyeeError(Exception):
    """An error internal to pyee."""


Handler = TypeVar("Handler", bound=Callable)


class EventEmitter:
    def __init__(self) -> None:
        self._events: dict[
            str,
            OrderedDict[Callable, Callable],
        ] = {}
        self._lock: Lock = Lock()

    def __getstate__(self) -> Mapping[str, Any]:
        state = self.__dict__.copy()
        del state["_lock"]
        return state

    def __setstate__(self, state: Mapping[str, Any]) -> None:
        self.__dict__.update(state)
        self._lock = Lock()

    @overload
    def on(self, event: str) -> Callable[[Handler], Handler]: ...

    @overload
    def on(self, event: str, f: Handler) -> Handler: ...

    def on(self, event: str, f: Handler | None = None) -> Handler | Callable[[Handler], Handler]:
        if f is None:
            return self.listens_to(event)
        else:
            return self.add_listener(event, f)

    def listens_to(self, event: str) -> Callable[[Handler], Handler]:
        def on(f: Handler) -> Handler:
            self._add_event_handler(event, f, f)
            return f

        return on

    def add_listener(self, event: str, f: Handler) -> Handler:
        self._add_event_handler(event, f, f)
        return f

    def _add_event_handler(self, event: str, k: Callable, v: Callable):
        self.emit("new_listener", event, k)
        with self._lock:
            if event not in self._events:
                self._events[event] = OrderedDict()
            self._events[event][k] = v

    def _emit_run(
        self,
        f: Callable,
        args: tuple[Any, ...],
        kwargs: dict[str, Any],
    ) -> None:
        f(*args, **kwargs)

    def event_names(self) -> set[str]:
        return set(self._events.keys())

    def _emit_handle_potential_error(self, event: str, error: Any) -> None:
        if event == "error":
            if isinstance(error, Exception):
                raise error
            else:
                raise PyeeError(f"Uncaught, unspecified 'error' event: {error}")

    def _call_handlers(
        self,
        event: str,
        args: tuple[Any, ...],
        kwargs: dict[str, Any],
    ) -> bool:
        handled = False

        with self._lock:
            funcs = list(self._events.get(event, OrderedDict()).values())
        for f in funcs:
            self._emit_run(f, args, kwargs)
            handled = True

        return handled

    def emit(
        self,
        event: str,
        *args: Any,
        **kwargs: Any,
    ) -> bool:
        handled = self._call_handlers(event, args, kwargs)

        if not handled:
            self._emit_handle_potential_error(event, args[0] if args else None)

        return handled

    def once(
        self,
        event: str,
        f: Callable | None = None,
    ) -> Callable:
        def _wrapper(f: Callable) -> Callable:
            def g(
                *args: Any,
                **kwargs: Any,
            ) -> Any:
                with self._lock:
                    if event in self._events and f in self._events[event]:
                        self._remove_listener(event, f)
                    else:
                        return None
                return f(*args, **kwargs)

            self._add_event_handler(event, f, g)
            return f

        if f is None:
            return _wrapper
        else:
            return _wrapper(f)

    def _remove_listener(self, event: str, f: Callable) -> None:
        self._events[event].pop(f)
        if not len(self._events[event]):
            del self._events[event]

    def remove_listener(self, event: str, f: Callable) -> None:
        with self._lock:
            self._remove_listener(event, f)

    def remove_all_listeners(self, event: str | None = None) -> None:
        with self._lock:
            if event is not None:
                self._events[event] = OrderedDict()
            else:
                self._events = {}

    def listeners(self, event: str) -> list[Callable]:
        return list(self._events.get(event, OrderedDict()).keys())


class AsyncIOEventEmitter(EventEmitter):
    def __init__(self, loop: AbstractEventLoop | None = None) -> None:
        super().__init__()
        self._loop: AbstractEventLoop | None = loop
        self._waiting: set[Future] = set()

    def emit(
        self,
        event: str,
        *args: Any,
        **kwargs: Any,
    ) -> bool:
        return super().emit(event, *args, **kwargs)

    def _emit_run(
        self,
        f: Callable,
        args: tuple[Any, ...],
        kwargs: dict[str, Any],
    ) -> None:
        try:
            coro: Any = f(*args, **kwargs)
        except Exception as exc:
            self.emit("error", exc)
        else:
            if iscoroutine(coro):
                if self._loop:
                    fut: Any = ensure_future(cast(Any, coro), loop=self._loop)
                else:
                    fut = ensure_future(cast(Any, coro))

            elif isinstance(coro, Future):
                fut = cast(Any, coro)
            else:
                return

            def callback(f: Future) -> None:
                self._waiting.discard(f)

                if f.cancelled():
                    return

                exc: BaseException | None = f.exception()
                if exc:
                    self.emit("error", exc)

            fut.add_done_callback(callback)
            self._waiting.add(fut)

    async def wait_for_complete(self) -> None:
        if self._waiting:
            await wait(self._waiting)

    def cancel(self) -> None:
        for fut in self._waiting:
            if not fut.done() and not fut.cancelled():
                fut.cancel()
        self._waiting.clear()

    @property
    def complete(self) -> bool:
        return not self._waiting

```