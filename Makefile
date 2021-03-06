CONVERT := quartus_map --read_settings_files=on --write_settings_files=off ToporPC -c ToporPC \
	--convert_bdf_to_vhdl=/home/roma/KPI/arch/s2/Topor/

BDFS := $(wildcard *.bdf)
TO_CONVERT := $(patsubst %.bdf,%.vhd,$(BDFS))
VHDS := $(sort $(patsubst %.bdf,%.vhd,$(BDFS)) $(wildcard *.vhd))

TESTS := $(notdir $(patsubst %.do,%,$(wildcard ./model/*.do)))

all: micro firmware

micro:
	tpcasm firmware/micro..masm micro.hex
	cp *.hex simulation/modelsim/


firmware:
	tpcasm firmware/firmware.masm firmware.hex
	cp *.hex simulation/modelsim/


convert: $(TO_CONVERT)

$(TO_CONVERT): %.vhd: %.bdf
	$(CONVERT)$<

test: $(TESTS)
# convert test_bmc test_alu

$(TESTS): %: test_%

test1.masm test2.masm test3.masm test4.masm:
	tpcasm -q firmware/$@ micro.hex
	cp *.hex simulation/modelsim/

test1.asm test2.asm:
	tpcasm -q firmware/$@ firmware.hex
	cp *.hex simulation/modelsim/

test_rom: convert test1.masm
	tpcasm -q firmware/test1.masm micro.hex
	cp *.hex simulation/modelsim/
	./model/domodel.sh model/rom.do

test_rom_holder: convert test1.masm test_rom
	./model/domodel.sh model/rom_holder.do

test_ram: convert test1.asm
	./model/domodel.sh model/ram.do

test_ram_holder: convert test_ram test1.asm
	./model/domodel.sh model/ram_holder.do

test_bmc: convert test_rom_holder test2.masm
	tpcasm -q firmware/test2.masm micro.hex
	cp *.hex simulation/modelsim/
	./model/domodel.sh model/bmc.do

test_calcu: convert test_or test_and test_xor
	./model/domodel.sh model/calcu.do

test_or: convert
	./model/domodel.sh model/or.do

test_and: convert
	./model/domodel.sh model/and.do

test_xor: convert
	./model/domodel.sh model/xor.do

test_alu: convert test_calcu
	./model/domodel.sh model/alu.do

test_cpu: convert test3.masm
	./model/domodel.sh model/cpu.do

test_cpu_ram: convert test4.masm test2.asm
	./model/domodel.sh model/cpu_ram.do

