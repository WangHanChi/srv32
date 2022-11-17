.data
    n:          .word 65
    comma:      .ascii ", 12"
    r:      .string "\n"
    iformat:    .string "%c"

.text

.global main
main:
    addi sp, sp, -4
    sw ra, 0(sp)

    #la a0, comma
    #call printf

    la t0, n

    la a0, iformat
    lw a1, 0(t0)
    lw a1, n
    call printf
    

    la a0, r
    call printf

    # restore ra
    lw ra, 0(sp)
    addi sp, sp, 4

    # exit
    li a0, 0
    ret