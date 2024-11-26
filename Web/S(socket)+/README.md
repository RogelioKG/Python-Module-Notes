# socket

### References
+ 🔗 [**Socket Programming in Python (Guide)**](https://realpython.com/python-sockets/)
+ 🔗 [](https://ithelp.ithome.com.tw/m/articles/10217260)

### Function
| 函式                                           | 說明                                             |
| ---------------------------------------------- | ------------------------------------------------ |
| `socket.socket()`                              | 創建一個新的 socket 物件。                       |
| `socket.bind(address)`                         | 將 socket 綁定到指定的地址和端口。               |
| `socket.listen(backlog)`                       | 開始監聽連接請求 (可指定 queue size！)。                               |
| `socket.accept()`                              | 接受一個連接並返回新的 socket 物件和客戶端地址。 |
| `socket.connect(address)`                      | 連接到指定的地址和端口。                         |
| `socket.send(data)`                            | 發送數據到已連接的 socket。                      |
| `socket.recv(bufsize)`                         | 接收來自 socket 的數據。                         |
| `socket.close()`                               | 關閉 socket。                                    |
| `socket.settimeout(timeout)`                   | 設置 socket 的超時時間。                         |
| `socket.getsockname()`                         | 獲取 socket 的本地地址。                         |
| `socket.getpeername()`                         | 獲取 socket 的遠端地址。                         |
| `socket.recvfrom(bufsize)`                     | 接收數據和地址，適用於無連接的 socket。          |
| `socket.sendto(data, address)`                 | 發送數據到指定地址，適用於無連接的 socket。      |
| `socket.setsockopt(level, option_name, value)` | 設置 socket 選項。                               |

### Example

+ TCP (`send()` / `recv()`)
  注意：要 `listen()` 和 `accept()`

  + `server.py`
      ```py
      import socket

      # Create a TCP/IP socket
      server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

      # Bind the server to an address and port
      server_address = ('localhost', 65432)
      server_socket.bind(server_address)

      # Start listening for incoming connections
      server_socket.listen(1)
      print('Waiting for a connection...')

      # Wait for a client to connect
      connection, client_address = server_socket.accept()

      try:
          print(f'Connected to: {client_address}')

          # Continuously receive data until the client closes the connection
          while True:
              data = connection.recv(1024)
              if data:
                  print(f'Received: {data.decode()}')
                  # Echo the same data back to the client
                  connection.sendall(data)
              else:
                  print('Client disconnected')
                  break
      finally:
          connection.close()

      # Waiting for a connection...
      # Connected to: ('127.0.0.1', 53683)
      # Received: Hello, Server!
      # Client disconnected
      ```

  + `client.py`
      ```py
      import socket

      # Create a TCP/IP socket
      client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

      # Connect to the server
      server_address = ('localhost', 65432)
      client_socket.connect(server_address)

      try:
          # Send data to the server
          message = 'Hello, Server!'
          print(f'Sending message: {message}')
          client_socket.sendall(message.encode())

          # Receive the server's response
          data = client_socket.recv(1024)
          print(f'Received response: {data.decode()}')

      finally:
          client_socket.close()

      # Sending message: Hello, Server!
      # Received response: Hello, Server!
      ```
+ UDP (`sendto()` / `recvfrom()`)

  + `server.py`
    ```py
    import socket

    # Create a UDP Socket
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Bind to a specific IP and port
    server_address = ('localhost', 12345)  # You can change this to the desired IP and port
    server_socket.bind(server_address)

    print(f"Server is up and listening on {server_address[0]}:{server_address[1]}")

    while True:
        # Receive data
        data, client_address = server_socket.recvfrom(4096)
        print(f"Received data from {client_address}: {data.decode()}")

        # Send a response
        response = f"Server received: {data.decode()}"
        server_socket.sendto(response.encode(), client_address)

    # Server is up and listening on localhost:12345
    # Received data from ('127.0.0.1', 63040): Hello, Server!
    ```

  + `client.py`

    ```py
    import socket

    # Create a UDP Socket
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Define the server's address
    server_address = ('localhost', 12345)  # Server's IP and port

    try:
        # Send data
        message = "Hello, Server!"
        print(f"Sending data to {server_address[0]}:{server_address[1]}: {message}")
        sent = client_socket.sendto(message.encode(), server_address)

        # Receive a response
        data, server = client_socket.recvfrom(4096)
        print(f"Received response from server: {data.decode()}")

    finally:
        print("Closing client socket")
        client_socket.close()

    # Sending data to localhost:12345: Hello, Server!
    # Received response from server: Server received: Hello, Server!
    # Closing client socket
    ```

### Socket

+ **說明**
  > 應用層與傳輸層之間的接口，它讓應用程式能夠直接使用傳輸層協議（如 TCP 或 UDP）來傳輸數據。

+ **注意**
  + 每個 host 都有 port number 0 ~ 65535 可以使用
  + port number 0 ~ 1023 是 well-known port number，留給使用 well-known protocol 的 server process。
  + 一個 process 可有多個 Socket
  + 一個 Socket 都可以對應到一個 port number
  + 一個 port number 可以對應到多個 Socket (看情況)
  + 在寫 well-known protocol 的 server 程序時，開啟的 Socket 就一定要是對應的 well-known port number

+ **UDP**

  + 2-tuple (UDP Socket 的 ID)

    `(destination port number, destination IP)`

    > 根據封包的這些資訊，送到對應的 Socket。
    > 至於 IP 會由網路層的 IP 協議負責提供。
    > 如上可知，只要 destination 相同，不管 source 哪來，都會被送到同一個 Socket。

  + UDP 可雙向通訊，但同個 port number 同時負責發送和接收資料，會有混淆風險。通常會將原連線的兩 port number 顛倒，作為另一個連線，這樣可以更清晰地分隔發送和接收資料流，減少了混淆風險。

+ **TCP**

  + 4-tuple (TCP Socket 的 ID)

    `(source port number, source IP, destination port number, destination IP)`

    > 根據封包的這些資訊，送到對應的 Socket。
    > 至於 IP 會由網路層的 IP 協議負責提供。
    > 如上可知，不同的 source，即便是相同的 destination，也會被送到不同的 Socket。

  + welcoming Socket (port number 12000)

    > TCP 的 server process 有一個聽在 port number 12000 上的 welcoming Socket，等待 TCP client 送來建立連線的請求

  + 創建一個專屬於 client 的新 Socket
  
    > 假如 client 想建立 HTTP 連線，那就開一個綁定到 port number 80 的 Socket，當然，由於 4-tuple 的緣故，我們可以知道這個 Socket 是專屬於這個 client 的。

+ **多工** (multiplexing)
  > 在 sender 端，收集多個 Sockets 的 data chunks，並加上 header，成為 Transport Layer 封包。

+ **解多工** (demultiplexing)
  > 在 receiver 端，將收到的 Transport Layer 封包，送到正確的 Socket。

![TCP/UDP segment](https://i.imgur.com/OGYWVcb_d.webp?maxwidth=600&fidelity=grand)


### household analogy
```
12 kids in Ann’s house sending letters to 
12 kids in Bill’s house:
+ hosts = houses
+ processes = kids
+ app messages = letters in envelopes
+ transport protocol = Ann and Bill who demux to in-house siblings
+ network-layer protocol = postal service
```

### TCP Socket Flow
![TCP Socket Flow](https://realpython.com/cdn-cgi/image/width=600,format=auto/https://files.realpython.com/media/sockets-tcp-flow.1da426797e37.jpg)