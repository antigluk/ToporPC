#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom reg16.vhd ./RAM.vhd;
vsim -quiet work.RAM;


add wave -position end  sim:/ram/clock
force -freeze sim:/ram/clock 1 0, 0 {50 ps} -r 100
add wave -noupdate -radix hexadecimal /ram/q
add wave -noupdate /ram/clock
add wave -noupdate -radix hexadecimal /ram/address


proc check_addr {addr data} {
    force -freeze sim:/ram/address 10#$addr 0
    run 10 ns

    #uncomment to see data
    # puts [examine -radix hexadecimal sim:/ram/q]
    return [expr [string compare [examine -radix hexadecimal sim:/ram/q] $data] != 0]
}

set result 0
set result [expr $result + [check_addr 0 "0000"]]
set result [expr $result + [check_addr 1 "1441"]]
set result [expr $result + [check_addr 2 "3000"]]
set result [expr $result + [check_addr 3 "0422"]]

puts "$result"

quit
