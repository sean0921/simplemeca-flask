# Simple Focal Mechanism Generator based on PyGMT

![](docs/demo.webp)

- based on previous work: <https://github.com/sean0921/workshop_demo_20210805>
- idea: <http://qcntw.earth.sinica.edu.tw/beachball/>

## Requirements
- Python 3.8 ~ 3.10
- Generic Mapping Tools (GMT, >= 6.3.0)
- Pipenv 2021.11.23
- PyGMT 0.5.0
- Flask 2.0.2

## Create Virtual Environment
- `make init`

## Run the Web Application
- `make run`

## Test the Web Application
- check payload in `example_payload.json`
- `cp example_payload.json payload.json`
- `sh test.sh`

## Method
- **URL**: POST `/simplemeca`
- **Header**:
    | Key | Value | Required |
    | ----| ------| -------- |
    | Content-Type | application/json | **`Required`** |

- **Body Json Parameters**: (*All Required*)
    - **strike**<br>
      `float`
    - **dip**<br>
      `float`
    - **rake**<br>
      `float`
    - **color_r**<br>
      `float`<br>
      R in RGB colors
    - **color_g**<br>
      `float`<br>
      G in RGB colors
    - **color_b**<br>
      `float`<br>
      B in RGB colors
    - **title**<br>
      `string`
- **Response**
```javascript
{'image_url': 'http://127.0.0.1:5000/static/<uuid-4-format>.png'}
```

## Examples
- `example_payload.json`
- `test.sh` (a `curl` command)

## TODO
- use PIL to convert output format to webp (or convince GMT developers to support webp output)
