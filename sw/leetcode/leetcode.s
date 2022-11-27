.data
test0:      .string "1111111111111111111111"
test1:      .string "2222222222222222222222"
test2:      .string "1231231231231231231231"
test3:      .string "1110612312111221232132"

result0:    .string "The result of test0 is %d\n"
# it should be output 2
result1:    .string "The result of test1 is %d\n"
# it should be output 3
result2:    .string "The result of test2 is %d\n"
# it should be output 0
result3:    .string "The result of test3 is %d\n"
# it should be output 2

.text
.global main

.macro whileloop
#while:
    beqz t2, return_value   # check enter while or not
    mv  t4, t1          # tmp = res[1];
    slli s1, t3, 1      # s1 = previous * 2;
    slli s2, t3, 3      # s2 = previous * 8;
    add s1, s1, s2      # s1 = previous * 2 + previous * 8;
    addi s2, t2, -48    # s2 = (*s) - '0';
    addi t5, x0, 26     # t5 = 26;
    add s1, s1, s2      # s1 = previous * 10 + (*s) - '0';
    ble s1, t5, else1   # if(previous * 10 + (*s) - '0' <= 26) go to else1;
    li t1, 0            # res[1] = 0;
#middle:
    beqz s2, else2      # if((*s) - '0') go to else2;
    add t0, t0, t4      # res[0] += tmp;
#reset:
    mv t3, s2           # previous = (*s) - '0'
    addi s0, s0, 1      # s++;
    lb  t2, 0(s0)       # get new (*s)
    #j while             # go back to while loop  

# double while
    beqz t2, return_value   # check enter while or not
    mv  t4, t1          # tmp = res[1];
    slli s1, t3, 1      # s1 = previous * 2;
    slli s2, t3, 3      # s2 = previous * 8;
    add s1, s1, s2      # s1 = previous * 2 + previous * 8;
    addi s2, t2, -48    # s2 = (*s) - '0';
    addi t5, x0, 26     # t5 = 26;
    add s1, s1, s2      # s1 = previous * 10 + (*s) - '0';
    ble s1, t5, else1   # if(previous * 10 + (*s) - '0' <= 26) go to else1;
    li t1, 0            # res[1] = 0;
#middle:
    beqz s2, else2      # if((*s) - '0') go to else2;
    add t0, t0, t4      # res[0] += tmp;
#reset:
    mv t3, s2           # previous = (*s) - '0'
    addi s0, s0, 1      # s++;
    lb  t2, 0(s0)       # get new (*s)
    #j while             # go back to while loop 
.endm

main:

    addi sp, sp, -4     # save ra
    sw  ra, 0(sp)

    la  s0, test0       # go test0
    jal ra, numDecodings
    la a0, result0
    call printf

    la  s0, test1       # go test1
    jal ra, numDecodings
    la a0, result1
    call printf

    la  s0, test2       # go test2
    jal ra, numDecodings
    la a0, result2
    call printf

    la  s0, test3       # go test3
    jal ra, numDecodings
    la a0, result3
    call printf

finally:
    lw ra, 0(sp)        # exit program
    addi sp, sp, 4
    li a0, 0
    ret


numDecodings:
    addi sp, sp, -4
    sw ra, 0(sp)
    li  t0, 1           # res[0] = 1;
    li  t1, 0           # res[1] = 0;
    lb  t2, 0(s0)       # get (*s)
    addi t3, t2, -48    # int previous = (*s) - '0';
    beqz t3, return_0   # if(previous == 0) return 0;
    addi t4, x0, 0      # int tmp = 0;
    addi s0, s0, 1      # s++;
    lb  t2, 0(s0)       # get new (*s)

while:
    whileloop
    j while             # go back to while loop   



else1:
    mv t1, t0           # res[1] = res[0];
    #j middle            # go back to middle
#middle:
    beqz s2, else2      # if((*s) - '0') go to else2;
    add t0, t0, t4      # res[0] += tmp;
#reset:
    mv t3, s2           # previous = (*s) - '0'
    addi s0, s0, 1      # s++;
    lb  t2, 0(s0)       # get new (*s)
    #j while             # go back to while loop   
    whileloop
    j while
    
    

else2:
    li t0, 0            # res[0] = 0
    #j reset
# reset:
    mv t3, s2           # previous = (*s) - '0'
    addi s0, s0, 1      # s++;
    lb  t2, 0(s0)       # get new (*s)
    #j while             # go back to while loop  
    whileloop
    j while 
    
    

return_value:
    add a1, t0, t1
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

return_0:
    addi a1, x0, 0      # set a1 for output data
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
