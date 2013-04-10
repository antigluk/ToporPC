#MEMORY TEST HEX

onerror { exit }

vlib work;

vcom *.vhd;

vsim -quiet work.CPU;

add wave -noupdate -radix hexadecimal /cpu/reset
add wave -noupdate -radix hexadecimal /cpu/clock
add wave -noupdate -radix hexadecimal /cpu/b2v_BMC/control
add wave -noupdate -radix hexadecimal /cpu/cmd
add wave -noupdate -radix unsigned /cpu/op1
add wave -noupdate -radix unsigned /cpu/op2
add wave -noupdate -radix unsigned /cpu/ext
add wave -noupdate -radix unsigned /cpu/b2v_BMC/last_tick
add wave -noupdate -radix unsigned /cpu/out_data
add wave -noupdate -radix unsigned /cpu/b2v_ALU/out_data
add wave -noupdate -radix unsigned /cpu/b2v_ALU/port_out
add wave -noupdate -radix unsigned /cpu/p0_out
add wave -noupdate -radix unsigned /cpu/p1_out
add wave -noupdate -radix unsigned /cpu/p0_in
add wave -noupdate -radix unsigned /cpu/p1_in
add wave -noupdate -radix unsigned /cpu/port_input
add wave -noupdate -radix unsigned /cpu/b2v_ALU/flags_enable

force -freeze sim:/cpu/clock 1 0, 0 {50 ps} -r 100
force sim:/cpu/reset 1

proc check_signal { signal taddr } {
    # puts "$signal [examine -radix unsigned $signal] (test $taddr)"
    return [expr [string compare [examine -radix unsigned $signal] $taddr] != 0]
}

proc do_cycle { count } {
    for { set i 0 } { $i <= $count } { incr i } {
        #puts -nonewline [examine -radix unsigned sim:/bmc/b2v_delay_counter/q]
        run
    }
    #puts ""
}

set result 0
set wait_num 7
#reset is 1
do_cycle  4
force sim:/cpu/reset 0
force sim:/cpu/p1_in 10#50
set result [expr $result + [check_signal /cpu/p0_out 0]]
do_cycle  8
set result [expr $result + [check_signal /cpu/p0_out 50]]
do_cycle  [expr 4*$wait_num]
set result [expr $result + [check_signal /cpu/p0_out 51]]
do_cycle  [expr 4*$wait_num]
set result [expr $result + [check_signal /cpu/p0_out 52]]
do_cycle  [expr 4*$wait_num]
set result [expr $result + [check_signal /cpu/p0_out 53]]
do_cycle  [expr 4*$wait_num]
set result [expr $result + [check_signal /cpu/p0_out 54]]
do_cycle  [expr 4*$wait_num]
set result [expr $result + [check_signal /cpu/p0_out 55]]
do_cycle  [expr 4*$wait_num]
set result [expr $result + [check_signal /cpu/p0_out 55]]
do_cycle  [expr 4*$wait_num]
set result [expr $result + [check_signal /cpu/p0_out 55]]

puts "$result"

quit
