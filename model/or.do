#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom ./OR_16.vhd;
vsim -quiet work.or_16;

add wave -noupdate -radix hexadecimal /or_16/a
add wave -noupdate -radix hexadecimal /or_16/b
add wave -noupdate -radix hexadecimal /or_16/q
# add wave -noupdate /microrom/clock
# add wave -noupdate -radix hexadecimal /microrom/address

force sim:/or_16/a 2#0000000000001001
force sim:/or_16/b 2#0000000000000011

set result 0


proc check_signal { signal taddr } {
    # puts "$signal [examine -radix binary $signal] (test $taddr)"
    return [expr [string compare [examine -radix binary $signal] $taddr] != 0]
}

run

set result [expr $result + [check_signal /or_16/q 0000000000001011]]

puts "$result"

quit

