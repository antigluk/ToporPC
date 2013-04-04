
all: micro firmware

micro:
	tpcasm firmware/micro.asm micro.hex
	cp *.hex simulation/modelsim/


firmware:
	tpcasm firmware/firmware.asm firmware.hex
	cp *.hex simulation/modelsim/

test: test_bmc

stest1:
	tpcasm -q firmware/test1.asm micro.hex
	cp *.hex simulation/modelsim/

stest2:
	tpcasm -q firmware/test2.asm micro.hex
	cp *.hex simulation/modelsim/


test_rom: stest1
	tpcasm -q firmware/test1.asm micro.hex
	cp *.hex simulation/modelsim/
	./model/domodel.sh model/rom.do

test_rom_holder: stest1 test_rom
	./model/domodel.sh model/rom_holder.do

test_bmc: test_rom_holder stest2
	tpcasm -q firmware/test2.asm micro.hex
	cp *.hex simulation/modelsim/
	./model/domodel.sh model/bmc.do
