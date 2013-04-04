#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom ./XOR_16.vhd;
vsim -quiet work.xor_16;

add wave -noupdate -radix hexadecimal /xor_16/a
add wave -noupdate -radix hexadecimal /xor_16/b
add wave -noupdate -radix hexadecimal /xor_16/q
# add wave -noupdate /microrom/clock
# add wave -noupdate -radix hexadecimal /microrom/address

force sim:/xor_16/a 2#0000000000001001
force sim:/xor_16/b 2#0000000000000011

set result 0


proc check_signal { signal taddr } {
    # puts "$signal [examine -radix binary $signal] (test $taddr)"
    return [expr [string compare [examine -radix binary $signal] $taddr] != 0]
}

run

set result [expr $result + [check_signal /xor_16/q 0000000000001010]]

puts "$result"

quit

