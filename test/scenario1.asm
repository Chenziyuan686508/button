.data
	
.text
main:
	addi t0, zero, 0xFFFFFC70 # left switches 
	addi t1, zero, 0xFFFFFC72 # right switches (test case)
	addi t2, zero, 0xFFFFFC50 # button 1 (test case control)
	addi t3, zero, 0xFFFFFC52 # button 2 (input control)
	addi t4, zero, 0xFFFFFC60 # left LEDs
	addi t5, zero, 0xFFFFFC62 # right LEDs
	addi t6, zero, 0xFFFFFC80 # Segment tubes
	addi s6, zero, 0xFFFFFFFF # full 1's, use to light up leds later
	
start:
	lb s1, 0(t2)         # load button 1 values
	andi s1, s1, 0x1
	beq s1, zero, start  # if it is not full 1's, then continue loop

for:
  li a6,25000000
  addi a6,a6,-1
  benz a6,for
	
	sw zero, 0(t4) # reset left LEDs (after every test case)
	sw zero, 0(t5) # reset right LEDs
	sw zero, 0(t6) # reset segment tube
	
	addi s2, zero, 0  # reset registers to avoid conflicts
	addi s3, zero, 0
	addi s4, zero, 0

	lb s1, 0(t1)          # load values from right switches
    	andi s1, s1, 0x7      # mask to choose which test case

	beq s1, zero, case_0
	addi s2, s2, 1
    	beq s1, s2, case_1
    	addi s2, s2, 1
    	beq s1, x2, case_2
    	addi s2, s2, 1
    	beq s1, s2, case_3
    	addi s2, s2, 1
    	beq s1, s2, case_4
    	addi s2, s2, 1
    	beq s1, s2, case_5
    	addi s2, s2, 1
    	beq s1, s2, case_6
    	addi s2, s2, 1
    	beq s1, s2, case_7
    	j start

case_0:
	jal ra, read_switch_lb
    	addi s3, s1, 0         # value A (actually move inst here)

    	jal ra, read_switch_lb
    	addi s4, s1, 0        # value B

    	sb s3, 0(t4) # store A to left LEDs
    	sb s4, 0(t5) # store B to right LEDs
    	j start              

case_1:
	jal ra, read_switch_lb
    	addi s3, s1, 0         # value A (lb)
    	
    	sb s3, 1(t6) # store in 0xFFFFFC84 !
    	sb s3, 0(t6)  # to be displayed on segment tubes
	j start

case_2:
	jal ra, read_switch_lbu
    	addi s3, s1, 0    # value B (lbu)
    	
    	sb s3, 2(t6) # store in 0xFFFFFC88 !
    	sb s3, 0(t6)  # to be displayed on segment tubes
	j start

case_3:
	lb s3, 1(t6) # load A
	lb s4, 2(t6) # load B
	
	beq s3, s4, lightUpLEDs
	j start	

case_4:
	lb s3, 1(t6) # load A
	lb s4, 2(t6) # load B
	
	blt s3, s4, lightUpLEDs
	j start	

case_5:
	lb s3, 1(t6) # load A
	lb s4, 2(t6) # load B
	
	bge s3, s4, lightUpLEDs
	j start

case_6:
	lb s3, 1(t6) # load A
	lb s4, 2(t6) # load B
	
	bltu s3, s4, lightUpLEDs
	j start

case_7:
	lb s3, 1(t6) # load A
	lb s4, 2(t6) # load B
	
	bgeu s3, s4, lightUpLEDs
	j start

read_switch_lb:
    	read_button_lb:
        		lw s1, 0(t3)   #load value from button 2
        		andi s1, s1, 0x1
        		beq s1, zero, read_button_lb
for1:
      li a6,25000000
      addi a6,a6,-1
      benz a6,for1 # reset button (new)

    	lb s1, 0(t0)         # load byte from left swtiches after button pressed
    	jalr x0, 0(ra)
    	
read_switch_lbu:
    	read_button_lbu:
        		lw s1, 0(t3)   #load value from button 2
        		andi s1, s1, 0x1
        		beq s1, zero, read_button_lbu
for2:
      li a6,25000000
      addi a6,a6,-1
      benz a6,for2 # reset button (new)

    	lbu s1, 0(t0)         # load byte unsigned
    	jalr x0, 0(ra)
    	
lightUpLEDs:
	sw s6, 0(t4)
	sw s6, 0(t5) # light up all left and right leds
	j start
