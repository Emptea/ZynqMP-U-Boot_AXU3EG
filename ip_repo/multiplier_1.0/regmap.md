# AXI Multiplier

| Address Space Offset | Name | Bits | Fields | Access Type | Description |
| - | - | - | - | - | - |
| 0x00 | ip_ver | 32 | [31:16] - major version, [15:0] - minor version | Read Only | IP version |
| 0x04 | kill | 0 | [0:0] - kill | Read/Write | Reset Active High |
| 0x08 | test_point | 3 | [2:0] - test point | Read/Write | Set Test Point from 0 to 7 |
| 0x0C | channel | 3 | [2:0] - channel | Read/Write | Channel from 0 to 7 |
| 0x10 | mult0 | 16 | [15:0] - mult0 | Read/Write | Multiplication value for ch0 |
| 0x14 | mult1 | 16 | [15:0] - mult1 | Read/Write | Multiplication value for ch1 |
