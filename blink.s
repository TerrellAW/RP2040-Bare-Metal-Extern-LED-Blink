/*
RP2040 BARE METAL ASSEMBLY ALTERNATE LED BLINKING PROGRAM

Alternates between blinking the onboard LED at GPIO 25 and the offboard LED at GPIO 0
*/

// Program entry point
.global start
start:

// Release IO_BANK0 from reset controller
	ldr r0, =rst_clr			// move variable value into register 0 for reset clear
	mov r1, #32					// 32 in decimal corresponds to bit 5
	str r1, [r0, #0]			// store value of r1 to address in r0 to clear reset register

// Check if reset is cleared - if bit 5 of rst_base = 1, reset is cleared
rst: 
	ldr r0, =rst_base			// store reset controller base address in register 0
	ldr r1, [r0, #8]			// get value from rst_base at offset of 8
	mov r2, #32					// load 1 in bit 5 of register 2
	and r1, r1, r2				// compare bit 5 of register 1 and 2 and store result in 1
	beq rst						// if bit 5 is 0 then loop, else continue
// Set SIO control over GPIO 25 (LED)
	ldr r0, =ctrl_25			// move variable value into register 0 for GPIO 25 controller
	mov r1, #5					// select function 5 to use SIO for GPIO 25
	str r1, [r0]				// creates GPIO 25 control register
// Set bitmask to enable GPIO 25 (LED)
	mov r1, #1					// setup bitmask by loading 1 into register 1
	lsl r1, r1, #25				// shift left 25 bits to align with GPIO 25
	ldr r0, =sio_base			// use register 0 for SIO base
	str r1, [r0, #36]			// GPIO output enable
// Set SIO control over GPIO 0	(EXTERN)
	ldr r2, =ctrl_0				// move variable value into register 0 for GPIO 0 controller
	mov r1, #5					// select function 5 to use SIO for GPIO 0
	str r1, [r2]				// creates GPIO 0 control register
// Set bitmask to enable GPIO 0 (EXTERN)
	mov r1, #1					// setup bitmask by loading 1 into register 1
	ldr r2, =sio_base			// use register 0 for SIO base
	str r1, [r2, #36]			// GPIO output enable

// Loop to blink LED
led_loop:
	str r1, [r0, #20]			// set GPIO output value to turn on LED
	ldr r3, =big_num			// load countdown number for delay
	bl delay					// branch to delay subroutine
// Runs after delay subroutine hits 0
	str r1, [r0, #24]			// clear GPIO output value to turn off LED
	ldr r3, =big_num			// reset count
	bl delay					// branch to delay subroutine
// Turn on external LED
	str r1, [r2, #20]			// set GPIO output value to turn on external LED
	ldr r3, =big_num			// load countdown number for delay
	bl delay					// branch to delay subroutine
// Turn off external LED
	str r1, [r2, #24]			// clear GPIO output value to turn off LED
	ldr r3, =big_num			// reset count
	bl delay					// branch to delay subroutine
// Runs after delay subroutine hits 0
	b led_loop					// go back to led_loop

// Delay subroutine, counts down big number until 0
delay:
	sub r3, #1					// subtract one from value in r3 and store result in r3
	bne delay					// loop if value in r3 is not 0
	bx lr						// return from subroutine

// Data label
data:
	// Variable declarations
	.equ rst_clr, 	0x4000f000	// atomic register to clear reset controller
	.equ rst_base, 	0x4000c000	// reset controller base
	.equ ctrl_25,	0x400140cc	// GPIO25 controller
	.equ ctrl_0,	0x40014004	// GPIO0 controller
	.equ sio_base, 	0xd0000000	// SIO base
	.equ big_num,	0x00780000	// big number for delay
