# pyyaml

## References
+ :link: [**MyApollo - 使用 `safe_load`**](https://myapollo.com.tw/blog/python-pyyaml-safe-load/)

## Note
| 函式 | 用途 |
| --- | --- |
| `yaml.load(stream, Loader=yaml.UnsafeLoader)` | 讀取 YAML (:radioactive: [Dangerous](#Dangerous)) |
| `yaml.safe_load(stream)` | 讀取 YAML |
| `yaml.safe_load_all(stream)` | 讀取多 document YAML |
| `yaml.dump(data)` | 序列化 YAML (:radioactive: [Dangerous](#Dangerous)) |
| `yaml.safe_dump(data)` | 序列化 YAML |
| `yaml.safe_dump_all(documents, stream)` | 序列化多 document YAML |

## Dangerous
| :radioactive: <span class="warn">WARNING</span>|
| :------------------------------------- |
| PyYAML 的 parser 使用自定義標籤，使得它 <mark>能夠 serialize / deserialize Python 物件</mark>，<br>也能夠 parse 期間<mark>執行內部嵌入的任何 Python 腳本</mark>。 |

```py
import yaml

yaml_data = """
!!python/object/apply:eval
  args: ['print(":skull_crossbones: Hello")']
"""

parsed_data = yaml.load(yaml_data, Loader=yaml.UnsafeLoader)
# :skull_crossbones: Hello
```