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



Reset value: 0x00000000

![ip_ver](md_img/ip_ver.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| maj_ver          | 31:16  | ro              | 0x0000     | Major IP version |
| min_ver          | 15:0   | ro              | 0x0000     | Minor IP version |

Back to [Register map](#register-map-summary).

## reset



Address offset: 0x14

Reset value: 0x00000001

![reset](md_img/reset.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:1   | -               | 0x0000000  | Reserved |
| reset            | 0      | rw              | 0x1        | Sends reset pulse on access |

Back to [Register map](#register-map-summary).

## compensation_mode



Address offset: 0x18

Reset value: 0x00000000

![compensation_mode](md_img/compensation_mode.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| mode             | 31:0   | rw              | 0x00000000 | Compensation mode |

Back to [Register map](#register-map-summary).

## manual_compensation_0



Address offset: 0x1c

Reset value: 0x00000000

![manual_compensation_0](md_img/manual_compensation_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## manual_compensation_1



Address offset: 0x20

Reset value: 0x00000000

![manual_compensation_1](md_img/manual_compensation_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## manual_compensation_2



Address offset: 0x24

Reset value: 0x00000000

![manual_compensation_2](md_img/manual_compensation_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## manual_compensation_3



Address offset: 0x28

Reset value: 0x00000000

![manual_compensation_3](md_img/manual_compensation_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| mult2            | 15:0   | rw              | 0x0000     | Multiplication value for ch2 |

Back to [Register map](#register-map-summary).

## manual_compensation_4



Address offset: 0x2c

Reset value: 0x00000000

![manual_compensation_4](md_img/manual_compensation_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## manual_compensation_5



Address offset: 0x30

Reset value: 0x00000000

![manual_compensation_5](md_img/manual_compensation_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## manual_compensation_6



Address offset: 0x34

Reset value: 0x00000000

![manual_compensation_6](md_img/manual_compensation_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## manual_compensation_7



Address offset: 0x38

Reset value: 0x00000000

![manual_compensation_7](md_img/manual_compensation_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_0



Address offset: 0x3c

Reset value: 0x00000000

![diagram_0_0](md_img/diagram_0_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_1



Address offset: 0x40

Reset value: 0x00000000

![diagram_0_1](md_img/diagram_0_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_2



Address offset: 0x44

Reset value: 0x00000000

![diagram_0_2](md_img/diagram_0_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_3



Address offset: 0x48

Reset value: 0x00000000

![diagram_0_3](md_img/diagram_0_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_4



Address offset: 0x4c

Reset value: 0x00000000

![diagram_0_4](md_img/diagram_0_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_5



Address offset: 0x50

Reset value: 0x00000000

![diagram_0_5](md_img/diagram_0_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_6



Address offset: 0x54

Reset value: 0x00000000

![diagram_0_6](md_img/diagram_0_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_0_7



Address offset: 0x58

Reset value: 0x00000000

![diagram_0_7](md_img/diagram_0_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_0



Address offset: 0x5c

Reset value: 0x00000000

![diagram_1_0](md_img/diagram_1_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_1



Address offset: 0x60

Reset value: 0x00000000

![diagram_1_1](md_img/diagram_1_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_2



Address offset: 0x64

Reset value: 0x00000000

![diagram_1_2](md_img/diagram_1_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_3



Address offset: 0x68

Reset value: 0x00000000

![diagram_1_3](md_img/diagram_1_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_4



Address offset: 0x6c

Reset value: 0x00000000

![diagram_1_4](md_img/diagram_1_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_5



Address offset: 0x70

Reset value: 0x00000000

![diagram_1_5](md_img/diagram_1_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_6



Address offset: 0x74

Reset value: 0x00000000

![diagram_1_6](md_img/diagram_1_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_1_7



Address offset: 0x78

Reset value: 0x00000000

![diagram_1_7](md_img/diagram_1_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_0



Address offset: 0x7c

Reset value: 0x00000000

![diagram_2_0](md_img/diagram_2_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_1



Address offset: 0x80

Reset value: 0x00000000

![diagram_2_1](md_img/diagram_2_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_2



Address offset: 0x84

Reset value: 0x00000000

![diagram_2_2](md_img/diagram_2_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_3



Address offset: 0x88

Reset value: 0x00000000

![diagram_2_3](md_img/diagram_2_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_4



Address offset: 0x8c

Reset value: 0x00000000

![diagram_2_4](md_img/diagram_2_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_5



Address offset: 0x90

Reset value: 0x00000000

![diagram_2_5](md_img/diagram_2_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_6



Address offset: 0x94

Reset value: 0x00000000

![diagram_2_6](md_img/diagram_2_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_2_7



Address offset: 0x98

Reset value: 0x00000000

![diagram_2_7](md_img/diagram_2_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_0



Address offset: 0x9c

Reset value: 0x00000000

![diagram_3_0](md_img/diagram_3_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_1



Address offset: 0xa0

Reset value: 0x00000000

![diagram_3_1](md_img/diagram_3_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_2



Address offset: 0xa4

Reset value: 0x00000000

![diagram_3_2](md_img/diagram_3_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_3



Address offset: 0xa8

Reset value: 0x00000000

![diagram_3_3](md_img/diagram_3_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_4



Address offset: 0xac

Reset value: 0x00000000

![diagram_3_4](md_img/diagram_3_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_5



Address offset: 0xb0

Reset value: 0x00000000

![diagram_3_5](md_img/diagram_3_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_6



Address offset: 0xb4

Reset value: 0x00000000

![diagram_3_6](md_img/diagram_3_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_3_7



Address offset: 0xb8

Reset value: 0x00000000

![diagram_3_7](md_img/diagram_3_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_0



Address offset: 0xbc

Reset value: 0x00000000

![diagram_4_0](md_img/diagram_4_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_1



Address offset: 0xc0

Reset value: 0x00000000

![diagram_4_1](md_img/diagram_4_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_2



Address offset: 0xc4

Reset value: 0x00000000

![diagram_4_2](md_img/diagram_4_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_3



Address offset: 0xc8

Reset value: 0x00000000

![diagram_4_3](md_img/diagram_4_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_4



Address offset: 0xcc

Reset value: 0x00000000

![diagram_4_4](md_img/diagram_4_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_5



Address offset: 0xd0

Reset value: 0x00000000

![diagram_4_5](md_img/diagram_4_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_6



Address offset: 0xd4

Reset value: 0x00000000

![diagram_4_6](md_img/diagram_4_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_4_7



Address offset: 0xd8

Reset value: 0x00000000

![diagram_4_7](md_img/diagram_4_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_0



Address offset: 0xdc

Reset value: 0x00000000

![diagram_5_0](md_img/diagram_5_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_1



Address offset: 0xe0

Reset value: 0x00000000

![diagram_5_1](md_img/diagram_5_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_2



Address offset: 0xe4

Reset value: 0x00000000

![diagram_5_2](md_img/diagram_5_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_3



Address offset: 0xe8

Reset value: 0x00000000

![diagram_5_3](md_img/diagram_5_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_4



Address offset: 0xec

Reset value: 0x00000000

![diagram_5_4](md_img/diagram_5_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_5



Address offset: 0xf0

Reset value: 0x00000000

![diagram_5_5](md_img/diagram_5_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_6



Address offset: 0xf4

Reset value: 0x00000000

![diagram_5_6](md_img/diagram_5_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_5_7



Address offset: 0xf8

Reset value: 0x00000000

![diagram_5_7](md_img/diagram_5_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_0



Address offset: 0xfc

Reset value: 0x00000000

![diagram_6_0](md_img/diagram_6_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_1



Address offset: 0x100

Reset value: 0x00000000

![diagram_6_1](md_img/diagram_6_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_2



Address offset: 0x104

Reset value: 0x00000000

![diagram_6_2](md_img/diagram_6_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_3



Address offset: 0x108

Reset value: 0x00000000

![diagram_6_3](md_img/diagram_6_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_4



Address offset: 0x10c

Reset value: 0x00000000

![diagram_6_4](md_img/diagram_6_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_5



Address offset: 0x110

Reset value: 0x00000000

![diagram_6_5](md_img/diagram_6_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_6



Address offset: 0x114

Reset value: 0x00000000

![diagram_6_6](md_img/diagram_6_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_6_7



Address offset: 0x118

Reset value: 0x00000000

![diagram_6_7](md_img/diagram_6_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_0



Address offset: 0x11c

Reset value: 0x00000000

![diagram_7_0](md_img/diagram_7_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_1



Address offset: 0x120

Reset value: 0x00000000

![diagram_7_1](md_img/diagram_7_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_2



Address offset: 0x124

Reset value: 0x00000000

![diagram_7_2](md_img/diagram_7_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_3



Address offset: 0x128

Reset value: 0x00000000

![diagram_7_3](md_img/diagram_7_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_4



Address offset: 0x12c

Reset value: 0x00000000

![diagram_7_4](md_img/diagram_7_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_5



Address offset: 0x130

Reset value: 0x00000000

![diagram_7_5](md_img/diagram_7_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_6



Address offset: 0x134

Reset value: 0x00000000

![diagram_7_6](md_img/diagram_7_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## diagram_7_7



Address offset: 0x138

Reset value: 0x00000000

![diagram_7_7](md_img/diagram_7_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| imag             | 31:16  | rw              | 0x0000     | Imaginary part, signed 2s complement, 2**14 = 1.0 |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## motion_selector



Address offset: 0x13c

Reset value: 0x00000000

![motion_selector](md_img/motion_selector.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:9   | -               | 0x00000    | Reserved |
| onoff            | 8      | rw              | 0x0        | Motion selector on/off |
| filter           | 7:0    | rw              | 0x00       | Motion selector filter control |

Back to [Register map](#register-map-summary).

## diagram_angle_0



Address offset: 0x140

Reset value: 0x00000000

![diagram_angle_0](md_img/diagram_angle_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## diagram_angle_1



Address offset: 0x144

Reset value: 0x00000000

![diagram_angle_1](md_img/diagram_angle_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## diagram_angle_2



Address offset: 0x148

Reset value: 0x00000000

![diagram_angle_2](md_img/diagram_angle_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## diagram_angle_3



Address offset: 0x14c

Reset value: 0x00000000

![diagram_angle_3](md_img/diagram_angle_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## diagram_angle_4



Address offset: 0x150

Reset value: 0x00000000

![diagram_angle_4](md_img/diagram_angle_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## diagram_angle_5



Address offset: 0x154

Reset value: 0x00000000

![diagram_angle_5](md_img/diagram_angle_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## diagram_angle_6



Address offset: 0x158

Reset value: 0x00000000

![diagram_angle_6](md_img/diagram_angle_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## diagram_angle_7



Address offset: 0x15c

Reset value: 0x00000000

![diagram_angle_7](md_img/diagram_angle_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## output_source



Address offset: 0x160

Reset value: 0x00000000

![output_source](md_img/output_source.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| source_channel   | 31:16  | rw              | 0x0000     | Source channel for output data (if exists) |
| source           | 15:0   | rw              | 0x0000     | Source for output data |

Back to [Register map](#register-map-summary).

## apu_rank



Address offset: 0x164

Reset value: 0x00000000

![apu_rank](md_img/apu_rank.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| window           | 15:8   | rw              | 0x00       | window length |
| rank             | 7:0    | rw              | 0x00       | rank for APU |

Back to [Register map](#register-map-summary).

## detector_level_0



Address offset: 0x168

Reset value: 0x00000000

![detector_level_0](md_img/detector_level_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| level            | 31:0   | rw              | 0x00000000 | detector comparation level |

Back to [Register map](#register-map-summary).

## detector_level_1



Address offset: 0x16c

Reset value: 0x00000000

![detector_level_1](md_img/detector_level_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| level            | 31:0   | rw              | 0x00000000 | detector comparation level |

Back to [Register map](#register-map-summary).

## azimuth_angle



Address offset: 0x170

Reset value: 0x00000000

![azimuth_angle](md_img/azimuth_angle.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| angle            | 31:0   | rw              | 0x00000000 | 2**32 = 2 pi |

Back to [Register map](#register-map-summary).

## apply



Address offset: 0x174

Reset value: 0x00000000

![apply](md_img/apply.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:1   | -               | 0x0000000  | Reserved |
| apply            | 0      | rw              | 0x0        | XOR to apply reg changes |

Back to [Register map](#register-map-summary).

## compensation_reference



Address offset: 0x178

Reset value: 0x00000000

![compensation_reference](md_img/compensation_reference.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| real             | 15:0   | rw              | 0x0000     | Real part, signed 2s complement, 2**14 = 1.0 |

Back to [Register map](#register-map-summary).

## channel_mask



Address offset: 0x17c

Reset value: 0x000000ff

![channel_mask](md_img/channel_mask.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| channel_mask_enable | 7:0    | rw              | 0xff       | enable channels by mask, "1" - enabled, lsb - channel 1 |

Back to [Register map](#register-map-summary).
