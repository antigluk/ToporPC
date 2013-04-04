CONVERT := quartus_map --read_settings_files=on --write_settings_files=off ToporPC -c ToporPC \
	--convert_bdf_to_vhdl=/home/roma/KPI/arch/s2/Topor/


all: micro firmware

micro:
	tpcasm firmware/micro.asm micro.hex
	cp *.hex simulation/modelsim/


firmware:
	tpcasm firmware/firmware.asm firmware.hex
	cp *.hex simulation/modelsim/


convert: CalcU.vhd OPSELECT.vhd BMC.vhd ALU.vhd

CalcU.vhd: CalcU.bdf
	$(CONVERT)CalcU.bdf

OPSELECT.vhd: OPSELECT.bdf
	$(CONVERT)OPSELECT.bdf

BMC.vhd: BMC.bdf
	$(CONVERT)BMC.bdf

ALU.vhd: ALU.bdf
	$(CONVERT)ALU.bdf


test: convert test_bmc test_alu

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

test_calcu: test_or test_and test_xor
	./model/domodel.sh model/calcu.do

test_or:
	./model/domodel.sh model/or.do

test_and:
	./model/domodel.sh model/and.do

test_xor:
	./model/domodel.sh model/xor.do

test_alu: convert test_calcu
	./model/domodel.sh model/alu.do