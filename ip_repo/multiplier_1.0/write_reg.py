START_ADDRESS = 16
ADDRESS_SIZE = 4

COMPLEX = \
'''
    -   name: IMAG
        description: Imaginary part, signed 2s complement, 2**14 = 1.0
        reset: 0
        width: 16
        lsb: 16
        access: rw
        hardware: o
        enums: []
    -   name: REAL
        description: Real part, signed 2s complement, 2**14 = 1.0
        reset: 0
        width: 16
        lsb: 0
        access: rw
        hardware: o
        enums: []
'''

COMPENSATION_REFERENCE_LAYOUT = \
'''
    -   name: REAL
        description: Real part, signed 2s complement, 2**14 = 1.0
        reset: 0
        width: 16
        lsb: 0
        access: rw
        hardware: o
        enums: []
'''

COMPENSATION_MODE = \
'''
    -   name: MODE
        description: Compensation mode
        reset: 0
        width: 32
        lsb: 0
        access: rw
        hardware: o
        enums: []
'''

MOTION_SELECTOR = \
'''
    -   name: FILTER
        description: Motion selector filter control
        reset: 0
        width: 8
        lsb: 0
        access: rw
        hardware: o
        enums: []
    -   name: ONOFF
        description: Motion selector on/off
        reset: 0
        width: 1
        lsb: 8
        access: rw
        hardware: o
        enums: []
'''

OUTPUT_SOURCE = \
'''
    -   name: SOURCE
        description: Source for output data
        reset: 0
        width: 16
        lsb: 0
        access: rw
        hardware: o
        enums: []
    -   name: SOURCE_CHANNEL
        description: Source channel for output data (if exists)
        reset: 0
        width: 16
        lsb: 16
        access: rw
        hardware: o
        enums: []

'''

ANGLE = \
'''
    -   name: ANGLE
        description: 2**32 = 2 pi
        reset: 0
        width: 32
        lsb: 0
        access: rw
        hardware: o
        enums: []
'''

APU_RANK = \
'''
    -   name: RANK
        description: rank for APU
        reset: 0
        width: 8
        lsb: 0
        access: rw
        hardware: o
        enums: []
    -   name: WINDOW
        description: window length
        reset: 0
        width: 8
        lsb: 8
        access: rw
        hardware: o
        enums: []
'''

DETECTOR_LEVEL = \
'''
    -   name: LEVEL
        description: detector comparation level
        reset: 0
        width: 32
        lsb: 0
        access: rw
        hardware: o
        enums: []
'''

APPLY = \
'''
    -   name: APPLY
        description: XOR to apply reg changes
        reset: 0
        width: 1
        lsb: 0
        access: rw
        hardware: o
        enums: []
'''

regs_template = [
	{"name": "COMPENSATION_MODE", "bits": COMPENSATION_MODE},
	{"name": "MANUAL_COMPENSATION", "length": 8, "bits": COMPLEX},	
	*[{"name": f"DIAGRAM_{i}", "length": 8, "bits": COMPLEX} for i in range(8)],	
	{"name": "MOTION_SELECTOR", "bits": MOTION_SELECTOR},
	{"name": "DIAGRAM_ANGLE", "length": 8, "bits": ANGLE},
	{"name": "OUTPUT_SOURCE", "bits": OUTPUT_SOURCE},
	{"name": "APU_RANK", "bits": APU_RANK},
	{"name": "DETECTOR_LEVEL", "length": 2, "bits": DETECTOR_LEVEL},
	{"name": "AZIMUTH_ANGLE", "bits": ANGLE},
	{"name": "APPLY", "bits": APPLY},
    {"name": "COMPENSATION_REFERENCE", "bits": COMPENSATION_REFERENCE_LAYOUT},
]

text = ""

address = START_ADDRESS

REG_DATA = \
'''-   name: {name}
    description: ""
    address: {address}
    bitfields:
{bit_fields}'''

for reg in regs_template:
	if "length" in reg:
		for i in range(reg["length"]):
			name = reg["name"] + "_" + str(i)

			text += REG_DATA.format(name=name, bit_fields=reg["bits"], address=address)

			address += ADDRESS_SIZE

	else:
		text += REG_DATA.format(name=reg["name"], bit_fields=reg["bits"], address=address)

		address += ADDRESS_SIZE


with open("write", "w") as f:
	f.write(text)			
