.data
        input_str: .space   11        # Preallocate space for 10 characters and the null string

.text
        main:
            li $v0, 8                     # Instruction to get user's input string
            la $a0, input_str             # Load register with address of input string
            li $a1, 10                    # Read maximum of 10 characters from string (i.e. do not read null character)
            syscall

            la $s0, input_str             # Load register with address of input string
            add $a2, $zero, $zero         # Initialize the counter to equal 0

            Loop1:
                add $t0, $a2, $s0         # add counter to input address and store in $t0 to get current character
                lb $t1, 0($t0)            # Get current character in the string
                bne $t1, 0, Convert       # If the current character is not null, it is not the end of file. Go to Convert
