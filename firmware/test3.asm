mmov R1,P1
mmov P0,R1

loop:

madd R1,#1
mmov P0,R1
mmov R2,R1
msub R2,#55, flags
mjz end

mjmp loop
end: