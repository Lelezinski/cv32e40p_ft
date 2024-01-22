.section .text
.global test1
.type test1, @function

test1:
	# ABI prologue
	addi sp, sp, -112     # allocate 112 bytes on the stack
	sw ra, 104(sp)        # save return address
	sw s0, 96(sp)         # save callee-saved registers
	sw s1, 88(sp)
	sw s2, 80(sp)
	sw s3, 72(sp)
	sw s4, 64(sp)
	sw s5, 56(sp)
	sw s6, 48(sp)
	sw s7, 40(sp)
	sw s8, 32(sp)
	sw s9, 24(sp)
	sw s10, 16(sp)
	sw s11, 8(sp)
	addi s0, sp, 112     # set up s0 to point to start of stack frame

    # You can write your code here 

    addi s2, s2, 12
    sw s2, 80(sp)
    addi s3, s3, -45
    sw s3, 72(sp)
    xori s4, s4, 125
    sw s4, 64(sp)
    ori s5, s5, 255
    sw s5, 56(sp)
    srai s6, s5, 2
    sw s6, 48(sp)
    andi s7, s7, 1
    sw s7, 40(sp)
    add s10, s4, s5
    sw s10, 16(sp)

    mul s1, s2, s3
    sw s1, 88(sp) 
    mul s2, s4, s1
    sw s2, 80(sp)
    mul s3, s5, s6
    sw s3, 72(sp)

    div s8, s6, s7
    sw s8, 32(sp)
    div s9, s10, s6
    sw s9, 24(sp)

    li a0, 0xCAFECAFE    # return value


    # ABI epilogue
	lw s11, 8(sp)        # restore callee-saved registers
	lw s10, 16(sp)
	lw s9, 24(sp)
	lw s8, 32(sp)
	lw s7, 40(sp)
	lw s6, 48(sp)
	lw s5, 56(sp)
	lw s4, 64(sp)
	lw s3, 72(sp)
	lw s2, 80(sp)
	lw s1, 88(sp)
	lw s0, 96(sp)
	lw ra, 104(sp)       # restore return address
	addi sp, sp, 112     # deallocate stack space
	jr ra                # return to caller



# READ/WRITE VARIABLES

.section .data

# READ-ONLY VARIABLES

.section .rodata