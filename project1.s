.data
        input_str: .space   11        # Preallocate space for 10 characters and the null string

.text
        main:
            li $v0, 8                     # Systemcall to get user's input string
            la $a0, input_str             # Load register with address of input string
            li $a1, 11                    # Read maximum of 11 characters from string (include null character)
            syscall

            la $s0, input_str             # Load register with address of input string
            add $t0, $zero, $zero         # Initialize the counter to equal 0
            addi $t6, $zero, 10           # $t6 used to check for end of string
            add $t5, $zero, $zero         # Register which holds the sum initialized to 0

            Loop1:
                add $t1, $t0, $s0         # Add counter to input address and store in $t1 to get the current character's address
                lb $a2, 0($t1)            # Get current character in the string
                jal ConvertToDecimal      # Jump to subroutine to get decimal value of the current character
                add $t5, $t5, $v1         # Add the decimal value from conversion to the sum
                beq $t0, $t6, PrintValue  # If counter is at the end of string, print sum
                addi $t0, $t0, 1          # Increment counter by +1
                j Loop1                   # reiterate

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
                bgt $t2, 't', Return0     # If current character is greater than 't', it is out of range. Go to Return0
                bge $t2, 'a', Return1     # If current character is between 'a' and 't', go to Return1 to convert
                addi $t3, $zero, 55       # Change reference value to 55 for uppercase characters
                bgt $t2, 'T', Return0     # If current character is greater than 'T', it is out of range. Go to Return0
                bge $t2, 'A', Return1     # If current character is between 'A' and 'T', go to Return1 to convert
                addi $t3, $zero, 48       # Change reference value to 48 for numbers
                bgt $t2, '9', Return0     # If current character is greater than '9' it is out of range. Go to Return0
                bge $t2, '0', Return1     # If current char is between '0' and '9', go to Return1 to convert
                blt $t2, '0', Return0     # For all other characters out of the range, convert to a value of 0

            # This subroutine is returns a value of 0 in $v1. Used for out of range characters
            Return0:
                addi $v1, $zero, 0        # Load register $v1 with value 0
                jr $ra                    # Return result in $v1 (0)


            # This subroutine calculates the decimal value of the character
            # The result is returned in $v1
            Return1:
                sub $v1, $t2, $t3         # subtract the the reference value in $t3 from the character's 1-byte ascii value
                jr $ra                    # Return the decimal value in $v1


           # This subroutine prints the decimal value of sum on a new line
          PrintValue:

                li $v0, 11                # System call to print character
                li $a0, 10                # Load $a0 with 10 (ascii value for newline character)
                syscall

                li $v0, 1                 # System call to print an integer (the sum)
                or $a0, $t5, 0            # Load register $a0 with the sum to in $t5 to be printed
                syscall
                j Exit                    # Jump to Exit


           # Subroutine to exit program
            Exit:
                li, $v0, 10               # System call to exit program
                syscall
