.text
li $s0, 0x12345678 # load test value for these function
sra $s1, $s0, 24 # Extract the MSB of $s0
andi $t0, $s0, 0xffffff00 # Clear LSB of $s0
ori $t3, $s0, 0x000000ff # Set LSB of $s0 (bits 7 to 0 are set to 1)
xor $s0, $s0, $s0 # Clear $s0
