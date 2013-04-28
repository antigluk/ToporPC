#MEMORY TEST HEX

onerror { exit }

vlib work;
vcom reg16.vhd ./RAMHolder.vhd;
vsim -quiet work.RAMHolder;


add wave -position end  sim:/ramholder/clock
force -freeze sim:/ramholder/clock 1 0, 0 {50 ps} -r 100
add wave -position end  -radix hexadecimal sim:/ramholder/addr
add wave -position end  -radix hexadecimal sim:/ramholder/read
add wave -position end  -radix hexadecimal sim:/ramholder/write
add wave -position end  -radix hexadecimal  sim:/ramholder/indata
add wave -position end  -radix hexadecimal  sim:/ramholder/data

add wave -position end -radix hexadecimal  sim:/ramholder/b2v_keeper/data
add wave -position end -radix hexadecimal  sim:/ramholder/b2v_keeper/q


force -freeze sim:/ramholder/read 1
force -freeze sim:/ramholder/write 0

proc check_addr {addr data} {
    force -freeze sim:/ramholder/addr 10#$addr 0
    run 10 ns

    #uncomment to see data
    # puts [examine -radix hexadecimal sim:/ramholder/data]
    return [expr [string compare [examine -radix hexadecimal sim:/ramholder/data] $data] != 0]
}

set result 0
set result [expr $result + [check_addr 0 "0000"]]
set result [expr $result + [check_addr 1 "1441"]]
set result [expr $result + [check_addr 2 "3000"]]
set result [expr $result + [check_addr 3 "0422"]]

#write test
force -freeze sim:/ramholder/indata 16#ABAB
force -freeze sim:/ramholder/write 1
force -freeze sim:/ramholder/addr 10#305
run 10 ns
set result [expr $result + [check_addr 305 "ABAB"]]



puts "$result"

quit
