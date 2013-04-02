
all: micro firmware

micro:
	tpcasm firmware/micro.asm micro.hex

firmware:
	tpcasm firmware/firmware.asm firmware.hex
