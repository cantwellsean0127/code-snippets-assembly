section .data
    
    ;; The integer that is to be printed
    integer_to_print dq -1456

    negative_sign db "-"

    ;; This variable is used by the write system call when we are printing each digit.
    digit_to_print db 0

section .text

    global main

main:

    push rbp
    mov rbp, rsp

print_integer:

    ;; Next, we move the integer we want to print into the r8 register. By accessing the integer through r8, we can modify the value without modifying the original value. The r9 register will contain the reversed version of the integer. The r10 register will contain the digit we are currently working with. The r11 register will be used to determine whether the original integer was negative or not.
    mov r8, qword [integer_to_print]
    mov r9, 0
    mov r10, 0
    mov r11, 0
    
check_if_negative:  

    cmp r8, 0
    jge reverse_integer
    mov r11, 1
    mov rdx, 0
    mov rax, r8
    mov rbx, -1
    mul rbx
    mov r8, rax

reverse_integer:
    
    ;; If the integer to reverse is greater than 0, therefore having more digits, we move on to grabbing the right-most digit. If there are no more digits to grab, we move on to printing the reversed integer.
    cmp r8, 0
    je print_negative_sign

grab_right_most_digit:
    
    ;; First, we divide the integer to reverse (r8) by rbx (10). The remainder in rdx will be the last digit (r10). Since the idiv always divides RDX:RAX by the given number, we need to zeroize rdx and then move the integer to reverse (r8) into rax. Afterwards, we can move the new value back.
    mov rdx, 0
    mov rax, r8
    mov rbx, 10
    idiv rbx
    mov r8, rax
    mov r10, rdx
    
    ;; Now, we will multiply the reversed integer (r9) by rbx (10), effectively sliding each digit to the left by 1, and then add the digit we are currently working on (r10) to the reversed integer (r9).
    mov rax, r9
    mov rbx, 10
    imul rbx
    mov r9, rax 
    add r9, r10
    
    ;; Now that we're done with the current digit, we can restart the loop.
    jmp reverse_integer

print_negative_sign:

    cmp r11, 1
    jne print_reversed_integer
    mov rax, 1
    mov rdi, 1
    mov rsi, negative_sign
    mov rdx, 1
    syscall

print_reversed_integer:

    ;; Now that we have the reversed integer (r9), we can print it digit by digit starting from the right most digit and working towards the left most digit. We will do this by grabbing the last digit (r10), printing it, and then repeat until there are no more digits (r9 = 0).
    cmp r9, 0
    jbe after_print_integer
    
print_last_digit:

    ;; First, we'll grab the last digit 
    mov rdx, 0
    mov rax, r9
    mov rbx, 10
    idiv rbx
    mov r9, rax
    mov r10, rdx
    
    ;; The characters '0' through '9' are represented by character codes 48 through 57, so to convert an integer into it's character representation, we need to add 48.
    add rdx, 48
    mov qword [digit_to_print], rdx
    
    ;; Now, using the write system call, we can print the digit we are currently on.
    mov rax, 1
    mov rdi, 1
    mov rsi, digit_to_print
    mov rdx, 1
    syscall

    ;; Moves on to the next digit
    jmp print_reversed_integer
    
;; This is the end of this code snippet, any additional code can be placed after this.
after_print_integer:

exit:

    mov rsp, rbp
    pop rbp

    mov rax, 60
    mov rdi, 0
    syscall