( common constants and words used by both conveyor.fth and operation.fth )
0 CONSTANT MA ( motor A )
1 CONSTANT MB ( motor B )
2 CONSTANT MC ( motor C )
0 CONSTANT S1 ( sensor 1 )
1 CONSTANT S2 ( sensor 2 )
2 CONSTANT S3 ( sensor 3 )

( motor actions )
1 CONSTANT FORWARD
2 CONSTANT BACKWARD
3 CONSTANT STOP
4 CONSTANT FLOAT

: -ROT ( a b c -- c a b )
   ROT ROT ;

: MOTOR ( mode motor -- )
   7 -ROT MOTOR_SET ;

: IS-TOUCH ( sensor -- )
   1 OVER SENSOR_TYPE
   32 SWAP SENSOR_MODE ;

: TOUCH? ( sensor -- bool )
   DUP SENSOR_READ DROP SENSOR_BOOL NEGATE ;
