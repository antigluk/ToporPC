#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom ./MicroROM.vhd;
vsim -quiet work.MicroROM;

add wave -noupdate -radix hexadecimal /microrom/q
add wave -noupdate /microrom/clock
add wave -noupdate -radix hexadecimal /microrom/address

force -freeze sim:/microrom/clock 1 0, 0 {50 ps} -r 100


# step

proc check_addr {addr data} {
    force -freeze sim:/microrom/address 10#$addr 0
    run 10 ns

    #uncomment to see data
    # puts [examine -radix hexadecimal /MicroROM/q]
    return [expr [string compare [examine -radix hexadecimal /MicroROM/q] $data] != 0]
}

set result 0
set result [expr $result + [check_addr 0 "FE0600000016"]]
set result [expr $result + [check_addr 1 "FE0600078005"]]
set result [expr $result + [check_addr 16 "FE0600000005"]]

puts "$result"

quit
