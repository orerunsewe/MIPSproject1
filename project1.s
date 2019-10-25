.data
        input_str: .space   11        # Preallocate space for 10 characters and the null string

.text
        main:
            li $v0, 8                     # Instruction to get user's input string
            la $a0, input_str             # Load register with address of input string
            li $a1, 10                    # Read maximum of 10 characters from string (i.e. do not read null character)
            syscall

            la $s0, input_str             # Load register with address of input string
            add $t0, $zero, $zero         # Initialize the counter to equal 0

            Loop1:
                add $t1, $t0, $s0         # Add counter to input address and store in $t1 to get the current character's address
                lb $a2, 0($t1)            # Get current character in the string
                jal ConvertToDecimal      # Jump to subroutine to get decimal value of the current character


            # This subroutine is used to convert the string characters to their corresponding decimal values, treating each character as a base-N number
            # Conversions done based on formula N = 26 + (X % 11) where X is my StudentID: 02805400
            # N = 30 so valid range is from 'a' to 't' or 'A' to 'T'
            # Characters '0' to '9' correspond to a decimal value of 0 to 9 respectively
            # Characters 'a' to 't' correspond to a decimal value of 10 to 29 respectively
            # Characters 'A' to 'T' correspond to a decimal value of 10 to 29 respectively
            # All other characters are out of range and correspond to a decimal value 0
            # Register $a2 contains current character in the string

            ConvertToDecimal:
                add $t2, $zero, $a2       # Copy character at $a2 to temporary register $t2
                addi $t3, $zero, 87       # Load $t3 with reference value 87 (ascii value of 'a' - 10) for conversion
                bgt $t2, 'f', Return0     # If current character is greater than f, it is out of range. Go to Return0
                bge $t2, 'a', Return1     # If current character is between 'a' and 'f', go to Return0 to convert



            # This subroutine is returns a value of 0 in $v1. Used for out of range characters

            Return0:
                addi $v1, $zero, 0        # Load register $v1 with value 0
                jr $ra                    # Return result in $v1 (0)


            # This subroutine calculates the decimal value of the character
            # The result is returned in $v1

            Return1:
                sub $v1, $t2, $t3         # subtract the the reference value in $t3 from the character's 1-byte ascii value
