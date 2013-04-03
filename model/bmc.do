#MEMORY TEST HEX

onerror { exit }

vlib work;

vcom const0.vhd mux21.vhd reg16.vhd inc16.vhd MicroROMHolder.vhd MicroROM.vhd;
vcom counter8.vhd mux16to1x1bit.vhd;
vcom ./BMC.vhd;

vsim -quiet work.BMC;

add wave -noupdate -radix hexadecimal /bmc/curraddr
add wave -noupdate /bmc/clock
add wave -noupdate /bmc/reset
add wave -noupdate -radix hexadecimal /bmc/control
add wave -noupdate -radix hexadecimal sim:/bmc/b2v_delay_counter/q

force -freeze sim:/bmc/clock 1 0, 0 {50 ps} -r 100
force sim:/bmc/reset 1

proc check_signal { signal taddr } {
    # puts "$signal: [examine -radix hexadecimal $signal] (test $taddr)"
    return [expr [string compare [examine -radix hexadecimal $signal] $taddr] != 0]
}

proc do_cycle { count } {
    for { set i 0 } { $i <= $count } { incr i } {
        # puts -nonewline [examine -radix decimal sim:/bmc/b2v_delay_counter/q]
        run
    }
    # puts ""
}

set result 0

#reset is 1
run
set result [expr $result + [check_signal /bmc/curraddr 0000]]
run
set result [expr $result + [check_signal /bmc/curraddr 0000]]
run
set result [expr $result + [check_signal /bmc/curraddr 0000]]
run
set result [expr $result + [check_signal /bmc/curraddr 0000]]
run
set result [expr $result + [check_signal /bmc/curraddr 0000]]
run
set result [expr $result + [check_signal /bmc/curraddr 0000]]
run
set result [expr $result + [check_signal /bmc/curraddr 0000]]


#turn on
force sim:/bmc/reset 0


for { set i 1 } { $i <= 5 } { incr i } {
    set result [expr $result + [check_signal sim:/bmc/b2v_delay_counter/q 03]]
    set result [expr $result + [check_signal /bmc/curraddr 0000]]
    
    do_cycle 3
    set result [expr $result + [check_signal /bmc/curraddr 0001]]
    set result [expr $result + [check_signal sim:/bmc/b2v_delay_counter/q 03]]
    
    do_cycle 3
    set result [expr $result + [check_signal /bmc/curraddr 0002]]
    set result [expr $result + [check_signal sim:/bmc/b2v_delay_counter/q 03]]

    do_cycle 3
    set result [expr $result + [check_signal /bmc/curraddr 000F]]
    set result [expr $result + [check_signal sim:/bmc/b2v_delay_counter/q 03]]

    do_cycle 3
    set result [expr $result + [check_signal /bmc/curraddr 0010]]
    set result [expr $result + [check_signal sim:/bmc/b2v_delay_counter/q 03]]

    do_cycle 3
    set result [expr $result + [check_signal /bmc/curraddr 0011]]
    set result [expr $result + [check_signal sim:/bmc/b2v_delay_counter/q 03]]

    do_cycle 3
    set result [expr $result + [check_signal /bmc/curraddr 0012]]
    set result [expr $result + [check_signal sim:/bmc/b2v_delay_counter/q 03]]
    do_cycle 3
}

puts "$result"

quit
