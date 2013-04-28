#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom reg16.vhd RAM.vhd CPU.vhd ALU.vhd;
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
    puts "$signal [examine -radix hex $signal] (test $taddr)"
    return [expr [string compare [examine -radix hex $signal] $taddr] != 0]
}

proc do_cycle { count } {
    for { set i 0 } { $i <= $count } { incr i } {
        #puts -nonewline [examine -radix unsigned sim:/bmc/b2v_delay_counter/q]
        run
    }
    #puts ""
}

set result 0
force sim:/cpu/reset 0
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_sp_reg/q 00FF]]
do_cycle 3
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r1_reg/q 0400]]
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r2_reg/q 1441]]
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r3_reg/q 0400]]
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r3_reg/q 0001]]

do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r4_reg/q 0001]]
do_cycle 3
do_cycle 3
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r5_reg/q 003F]]

do_cycle 3
do_cycle 3
do_cycle 3
do_cycle 3
do_cycle 3


set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r1_reg/q 3000]]
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r2_reg/q 0422]]
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r3_reg/q 3000]]
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r3_reg/q 000C]]
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r3_reg/q 000C]]


do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r3_reg/q 000C]]
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r3_reg/q 000C]]

do_cycle 3
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r4_reg/q 0000]]
do_cycle 3
do_cycle 3
set result [expr $result + [check_signal /cpu/b2v_alu/b2v_r5_reg/q 007A]]

puts "$result"

quit
