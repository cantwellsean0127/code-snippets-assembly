global print_integer

print_integer:

    ;; Function prologue
    mov rbp, rsp
    push rbp

    ;; An overview of the steps for this function are as follows:
    ;; 1. Push whatever registers we will be using onto the stack in order to preserve their values.
    ;; 2. Print the negative sign if the number to print is negative
    ;; 3. Push each digit onto the stack 1 by 1 starting from the right-most digit and moving towards the left-most digit.
    ;; 4. Pop each digit off the stack and print it. This will print the left-most digit and then move towards the right-most digit.
    ;; 5. Pop the preserved values from the stack back into their respective registers.
    
    ;; During the function, the rax, rcx, rdx, rsi, and r10 register values are modified. In case the user is has important data stored there, we will preserve their values via the stack. 
    push rax
    push rcx
    push rdx
    push rsi
    push r10

    ;; Since we're using rdx to store the amount of digits, we should initialize it to zero
    xor rdx, rdx

    ;; Now that we've preserved the original register values, we can move on to the next step. Here, we will check if the integer to print is negative, and if so, print the negative sign. If the integer to print is not negative, we can skip to the next step which is either printing the zero or adding each digit to the stack.
    cmp rdi, 0
    je print_zero
    jg push_digits_onto_stack

    ;; Perform the write system call, printing the negative sign (ASCII value 45). Since the write system call requires us to change the value of rdx and rdi, we need to preserve their values.
    push rdx
    push rdi
    push 45
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop r10
    pop rdi
    pop rdx

    ;; Now that we've printed the negative sign, we can turn it into a positive value. To do this, we will use the imul instruction. This instruction multiplies rax by a given number and stores the result in rdx:rax. Normally, one would set rdx to zero, however, since rdx is already zero, this is not neccessary.
    mov rax, rdi
    push -1
    imul qword [rsp]
    pop r10
    mov rdi, rax
    jmp push_digits_onto_stack
    
print_zero:
    ;; If the value is 0, we can just print the 0 and then finish.
    push 48
    mov rax, 1
    mov rdi, 1 
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop r10
    jmp restore_registers

push_digits_onto_stack:
    
    ;; Here, we check if the number is greater than or equal to 0, therefore having more digits. If so, we push the last digit onto the stack and then remove it from the integer to print. We also need to increment the amount of digits to print. Since the div instruction requires us to change the value of rdx, we need to preserve it's value.
    cmp rdi, 0
    je print_digits
    add rdx, 1
    push rdx
    xor rdx, rdx
    mov rax, rdi
    push 10
    div qword [rsp]
    pop r10
    mov rdi, rax
    mov rsi, rdx
    pop rdx
    push rsi
    jmp push_digits_onto_stack

print_digits:
    ;; Here, we print each digit popping them off the stack. Since the write system call requires us to change the value of rdx, we need to preserve it's value. Since we're adding rdx to the stack, we first need to remove the digit on top and then readd it after rdx because the write system call is printing whatever's on top. We also add 48 to the value so that the digit now represents the cooresponding ASCII value.
    pop r10
    add r10, 48
    push rdx
    push r10
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop r10
    pop rdx
    sub rdx, 1
    cmp rdx, 0
    jne print_digits

;; This is where we restore the original values for the registers that were changed, specifically, the rax, rcx, rdx, and rsi registers.
restore_registers:
    pop r10
    pop rsi
    pop rdx
    pop rcx
    pop rax
    
    ;; Function epilogue and return
    mov rsp, rbp
    pop rbp
    ret