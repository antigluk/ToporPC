start:
mnop
mjmp lab1
mnop
mmov R0, #3
madd R0, #2 ; now R0 = 5

#offset 0x0F
lab1:
mnop
mnop
mjmp start

