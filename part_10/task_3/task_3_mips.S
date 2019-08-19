.eqv    TEST_ADDR   0x18fc1000
.eqv    TEST_DATA   0x55aa55aa

.text

init:
                li  $t0, TEST_ADDR  # Load test address
                li  $t1, TEST_DATA  # Load test data
store_data:
                sw  $t1, 0x0 ($t0)
while_1:
                b   while_1
