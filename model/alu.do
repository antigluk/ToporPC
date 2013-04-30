#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom mux16to1x16bit.vhd mux16to1x1bit.vhd reg16.vhd mux21.vhd dc16x1.vhd mux32to1x16bit.vhd OPSELECT.vhd ALU.vhd;
vsim -quiet work.alu;

add wave -noupdate -radix unsigned /alu/op1
add wave -noupdate -radix unsigned /alu/op2
add wave -noupdate -radix unsigned /alu/a
add wave -noupdate -radix unsigned /alu/b
add wave -noupdate -radix unsigned /alu/sp
add wave -noupdate -radix unsigned /alu/write
add wave -noupdate -radix unsigned /alu/clock
add wave -noupdate -radix binary /alu/FLAGS
# add wave -noupdate /alu/clock
# add wave -noupdate -radix hexaunsigned /microrom/address

force -freeze sim:/alu/clock 1 0, 0 {50 ps} -r 100
force sim:/alu/write 0

proc check_signal { signal taddr } {
    # puts "$signal [examine -radix unsigned $signal] (test $taddr)"
    return [expr [string compare [examine -radix unsigned $signal] $taddr] != 0]
}

set result 0
force sim:/alu/flags_enable 0
# mmov SP,#150
force sim:/alu/cmd 10#0
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#150
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 150]]

# madd SP,#70  (150+70=220)
force sim:/alu/cmd 10#3
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#70
run
set result [expr $result + [check_signal /alu/a 150]]
set result [expr $result + [check_signal /alu/b 70]]
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 220]]



# msub SP,#50  (220-50=170)
force sim:/alu/cmd 10#4
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#50
run
set result [expr $result + [check_signal /alu/a 220]]
set result [expr $result + [check_signal /alu/b 50]]
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 170]]



# mmov R0,#10
force sim:/alu/cmd 10#0
force sim:/alu/op1 10#4
force sim:/alu/op2 10#20
force sim:/alu/ext 10#10
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/r0 10]]


# madd SP,R0 (170 + 10 = 180)
force sim:/alu/cmd 10#3
force sim:/alu/op1 10#1
force sim:/alu/op2 10#4
force sim:/alu/ext 10#0
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 180]]


# mor SP,#15 (180 | 15 = 191)
force sim:/alu/cmd 10#5
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#15
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 191]]


# mxor SP,#52 (191 | 52 = 139)
force sim:/alu/cmd 10#6
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#52
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 139]]


# mand SP,#140 (139 & 140 = 136)
force sim:/alu/cmd 10#7
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#140
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 136]]

# mshr SP,#2 (139 >> 2 = 34)
force sim:/alu/cmd 10#9
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#2
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 34]]


# mshl SP,#3 (34 << 3 = 272)
force sim:/alu/cmd 10#8
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#3
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 272]]


# msub SP,#272  (272-272=0)
force sim:/alu/cmd 10#4
force sim:/alu/op1 10#1
force sim:/alu/op2 10#20
force sim:/alu/ext 10#272
force sim:/alu/flags_enable 1
run
force sim:/alu/write 1
run
force sim:/alu/write 0
set result [expr $result + [check_signal /alu/sp 0]]

puts "$result"

quit
