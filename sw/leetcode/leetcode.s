.data
test0:      .string "12"
test1:      .string "226"
test2:      .string "06"
test3:      .string "11106"

result0:    .string "The result of test0 is "
# it should be output 2
result1:    .string "The result of test1 is "
# it should be output 3
result2:    .string "The result of test2 is "
# it should be output 0
result3:    .string "The result of test3 is "
# it should be output 2

nextline:   .string " \n"
iformat:    .string "%d"

.text
.global main
main:

    addi sp, sp, -4     # save ra
    sw  ra, 0(sp)

    la  a0, result0     # printf result0
    call printf
    la  s0, test3       # go test0
    jal ra, numDecodings

finally:
    lw ra, 0(sp)        # exit program
    addi sp, sp, 4
    li a0, 0
    ret


numDecodings:
    li  t0, 1           # res[0] = 1;
    li  t1, 0           # res[1] = 0;
    lb  t2, 0(s0)       # get (*s)
    addi t3, t2, -48    # int previous = (*s) - '0';
    beqz t3, return_0   # if(previous == 0) return 0;
    addi t4, x0, 0      # int tmp = 0;
    addi s0, s0, 1      # s++;
    lb  t2, 0(s0)       # get new (*s)

while:
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
middle:
    beqz s2, else2      # if((*s) - '0') go to else2;
    add t0, t0, t4      # res[0] += tmp;
reset:
    mv t3, s2           # previous = (*s) - '0'
    addi s0, s0, 1      # s++;
    lb  t2, 0(s0)       # get new (*s)
    j while             # go back to while loop

else1:
    mv t1, t0           # res[1] = res[0];
    j middle            # go back to middle

else2:
    li t0, 0            # res[0] = 0
    j reset             # go back to reset

return_value:
    la a0, iformat      # set output format
    add a1, t0, t1      # set a1 for output data
    call printf         # use printf ststem call

    la a0, nextline     # load '\n' to a0
    call printf         # use printf system call

    j   finally

return_0:
    la  a0, iformat     # set output format
    addi a1, x0, 0      # set a1 for output data
    call printf         # use printf system call

    la a0, nextline     # load ' \n' to a0
    call printf         # use printf system call

    j   finally