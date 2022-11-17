.data
addr_name:    .string "alex"
addr_typed0:  .string "aaleex"
addr_typed1:  .string "aalleexx"
addr_typed2:  .string "aalewx"

SuccessResult: .string "PASS\n"   
FailResult:  .string "FAIL\n"

test:       .word 65
iformat:    .string "%d"

.text
.global main
main:

    # save ra
    addi sp, sp, -4
    sw ra, 0(sp)

    la    t0, addr_name     #Load "name" 1st address
    la    t1, addr_typed0   #Load "typed" 1st address
    jal   ra, isLongPressed #1st test-case
    la    t1, addr_typed1   #Load "typed" 1st address
    jal   ra, isLongPressed #2nd test-case
    la    t1, addr_typed2   #Load "typed" 1st address
    jal   ra, isLongPressed #3rd test-case
    j     End

isLongPressed:
    addi  sp, sp, -8     #Use 2 byte for saving register
    sw    ra, 0(sp)      #1st byte is ra
    sw    t0, 4(sp)      #2nd byte is t0 
    lb    t2, 0(t0)      #1st character of name
    lb    t3, 0(t1)      #1st character of typed
    bne   t2, t3, Fail   #1st character must the same
    addi  t0, t0, 1      #i++
    addi  t1, t1, 1      #j++
    jal   Loop           #Call Loop
finally:
    lw    ra, 0(sp)      #Recall ra
    lw    t0, 4(sp)      #Recall t0
    addi  sp,sp, 8
    ret
Loop: #1st while loop
    lb    t2, 0(t0)      #Load name[i]
    lb    t3, 0(t1)      #Load typed[j] 
    beq   t2, x0, checkLastCharacter #If name[i]= NULL
If:
    bne   t2, t3, Else   #If name[i]!=typed[j]
    addi  t0, t0, 1      #i++
    addi  t1, t1, 1      #j++
    j     Loop
Else:
    lb    t2, -1(t0)     # Load name[i-1]
    bne   t2, t3,Fail    # If typed[j] != name[i-1] then Fail
    addi  t1, t1, 1      # j++
    j     Loop          
checkLastCharacter: #2nd while loop
    lb    t2, -1(t0)     # Load last character of name
if2:
    beq   t3, x0, Pass   # If typed[j] = NULL, then passed
    bne   t2, t3,Fail    # If typed[j] != name[last] then Fail
    addi  t1, t1, 1      # j++
    lb    t3, 0(t1)      # Load next character of typed
    j     if2
Pass:

    # modify for srv32
    la a0, SuccessResult
    call printf 
    j finally

    #li a7, SYSWRITE       # "write" syscall
    #li a0, 1              # 1 = standard output (stdout)
    #la a1, SuccessResult  # load address of hello string
    #li a2, success_result_size # length of hello string
    #ecall                 # invoke syscall to print the string
    #ret
Fail:

    # modify
    la a0, FailResult
    call printf
    j finally

    #li a7, SYSWRITE      # "write" syscall
    #li a0, 1             # 1 = standard output (stdout)
    #la a1, FailResult    # load address of hello string
    #li a2, fail_result_size # length of hello string
    #ecall                # invoke syscall to print the string
    #ret
End:
    # restore ra
    lw ra, 0(sp)
    addi sp, sp, 4
    
    # exit
    li a0, 0
    ret
