# Register map

Created with [Corsair](https://github.com/esynr3z/corsair) v1.0.4.

## Conventions

| Access mode | Description               |
| :---------- | :------------------------ |
| rw          | Read and Write            |
| rw1c        | Read and Write 1 to Clear |
| rw1s        | Read and Write 1 to Set   |
| ro          | Read Only                 |
| roc         | Read Only to Clear        |
| roll        | Read Only / Latch Low     |
| rolh        | Read Only / Latch High    |
| wo          | Write only                |
| wosc        | Write Only / Self Clear   |

## Register map summary

Base address: 0x00000000

| Name                     | Address    | Description |
| :---                     | :---       | :---        |
| [ip_ver](#ip_ver)        | 0x00       | IP version |
| [kill](#kill)            | 0x04       | Synchronous reset register |
| [test_point](#test_point) | 0x08       | Test point control register |
| [channel](#channel)      | 0x0c       | Output channel control register |
| [mult0](#mult0)          | 0x10       | Multiplication value for ch0 |
| [mult1](#mult1)          | 0x14       | Multiplication value for ch1 |
| [mult2](#mult2)          | 0x18       | Multiplication value for ch2 |
| [mult4](#mult4)          | 0x20       | Multiplication value for ch4 |
| [mult5](#mult5)          | 0x24       | Multiplication value for ch5 |
| [mult6](#mult6)          | 0x28       | Multiplication value for ch6 |
| [mult7](#mult7)          | 0x2c       | Multiplication value for ch7 |

## ip_ver

IP version

Address offset: 0x00

Reset value: 0x00000000

![ip_ver](md_img/ip_ver.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| maj_ver          | 31:16  | ro              | 0x0000     | Major IP version |
| min_ver          | 15:0   | ro              | 0x0000     | Minor IP version |

Back to [Register map](#register-map-summary).

## kill

Synchronous reset register

Address offset: 0x04

Reset value: 0x00000000

![kill](md_img/kill.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:1   | -               | 0x0000000  | Reserved |
| kill             | 0      | rw              | 0x0        | Kill |

Back to [Register map](#register-map-summary).

## test_point

Test point control register

Address offset: 0x08

Reset value: 0x00000000

![test_point](md_img/test_point.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| test_point       | 2:0    | rw              | 0x0        | Test point |

Back to [Register map](#register-map-summary).

## channel

Output channel control register

Address offset: 0x0c

Reset value: 0x00000000

![channel](md_img/channel.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| test_point       | 2:0    | rw              | 0x0        | Test point |

Back to [Register map](#register-map-summary).

## mult0

Multiplication value for ch0

Address offset: 0x10

Reset value: 0x00000000

![mult0](md_img/mult0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult0            | 15:0   | rw              | 0x0000     | Multiplication value for ch0 |

Back to [Register map](#register-map-summary).

## mult1

Multiplication value for ch1

Address offset: 0x14

Reset value: 0x00000000

![mult1](md_img/mult1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult1            | 15:0   | rw              | 0x0000     | Multiplication value for ch1 |

Back to [Register map](#register-map-summary).

## mult2

Multiplication value for ch2

Address offset: 0x18

Reset value: 0x00000000

![mult2](md_img/mult2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult2            | 15:0   | rw              | 0x0000     | Multiplication value for ch2 |

Back to [Register map](#register-map-summary).

## mult4

Multiplication value for ch4

Address offset: 0x20

Reset value: 0x00000000

![mult4](md_img/mult4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult4            | 15:0   | rw              | 0x0000     | Multiplication value for ch4 |

Back to [Register map](#register-map-summary).

## mult5

Multiplication value for ch5

Address offset: 0x24

Reset value: 0x00000000

![mult5](md_img/mult5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult5            | 15:0   | rw              | 0x0000     | Multiplication value for ch5 |

Back to [Register map](#register-map-summary).

## mult6

Multiplication value for ch6

Address offset: 0x28

Reset value: 0x00000000

![mult6](md_img/mult6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult6            | 15:0   | rw              | 0x0000     | Multiplication value for ch6 |

Back to [Register map](#register-map-summary).

## mult7

Multiplication value for ch7

Address offset: 0x2c

Reset value: 0x00000000

![mult7](md_img/mult7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult7            | 15:0   | rw              | 0x0000     | Multiplication value for ch7 |

Back to [Register map](#register-map-summary).
