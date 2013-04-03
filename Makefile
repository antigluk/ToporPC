
all: micro firmware

micro:
	tpcasm firmware/micro.asm micro.hex
	cp *.hex simulation/modelsim/


firmware:
	tpcasm firmware/firmware.asm firmware.hex
	cp *.hex simulation/modelsim/

test: testrom

testrom:
	tpcasm firmware/test1.asm micro.hex
	./model/domodel.sh model/rom.do
