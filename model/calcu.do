#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom adder16.vhd substractor16.vhd shr16.vhd shl16.vhd CalcU.vhd;
vsim -quiet work.calcu;

add wave -noupdate -radix hexadecimal /calcu/A
add wave -noupdate -radix hexadecimal /calcu/B
add wave -noupdate -radix hexadecimal /calcu/AorB
# add wave -noupdate /microrom/clock
# add wave -noupdate -radix hexadecimal /microrom/address

# force -freeze sim:/microrom/clock 1 0, 0 {50 ps} -r 100

force sim:/calcu/a 10#10
force sim:/calcu/b 10#7

# # step

proc check_signal { signal taddr } {
    # puts "$signal [examine -radix decimal $signal] (test $taddr)"
    return [expr [string compare [examine -radix decimal $signal] $taddr] != 0]
}

set result 0

run

set result [expr $result + [check_signal /calcu/AaddB 17]]
set result [expr $result + [check_signal /calcu/AsubB 3]]
set result [expr $result + [check_signal /calcu/AandB 2]]
set result [expr $result + [check_signal /calcu/AorB 15]]
set result [expr $result + [check_signal /calcu/AxorB 13]]

puts "$result"

quit
