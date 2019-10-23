.data
        input_str: .space   11        # Preallocate space for 10 characters and the null string

.text
        main:
            li $v0, 8                     # Instruction to get user's input string
            la $a0, input_str             # Load register with address of input string
            li $a1, 10                    # Read maximum of 10 characters from string (i.e. do not read null character)
            syscall     
