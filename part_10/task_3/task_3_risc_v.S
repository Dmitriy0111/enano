.equ    TEST_ADDR,  0x18fc1000
.equ    TEST_DATA,  0x55aa55aa

.section        .text

init:
                la  t0, TEST_ADDR  # Load test address
                la  t1, TEST_DATA  # Load test data
store_data:
                sw  t1, 0x0 (t0)
while_1:
                j   while_1
