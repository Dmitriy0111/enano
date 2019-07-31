.eqv    TEST_ADDR,  0x18fc1000
.eqv    TEST_DATA,  0x55aa55aa

.text

init:
                movw    r0, #:lower16:TEST_ADDR 
                movt    r0, #:upper16:TEST_ADDR 
                movw    r1, #:lower16:TEST_DATA 
                movt    r1, #:upper16:TEST_DATA 
store_data:
	            str     r1, [r0]
while_1:
	            b       while_1
