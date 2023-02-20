ISBN13 Check Digit Calculator
This is a simple Ruby program that calculates the check digit for an ISBN13 number. It takes an ISBN13 number as input, removes any non-digit characters, verifies that the input is 12 digits long and contains only digits, multiplies each digit alternately by 1 and 3, takes the mod 10 of the sum, and subtracts the result from 10 to get the check digit. If the check digit is 10, it is replaced with 0. The program returns the complete ISBN13 number, including the check digit.

Usage
To use the program, simply call the calculate_isbn13_check_digit method and pass in an ISBN13 number as a string or integer. For example:
