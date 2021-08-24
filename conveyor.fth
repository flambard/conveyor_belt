( words for controlling the conveyors )

MA CONSTANT V-TEST ( visual test motor )
MB CONSTANT E-TEST ( electric test motor )
MC CONSTANT OUTPUT ( output motor )

S1 CONSTANT V-TEST-SENSOR ( visual test position sensor )
S2 CONSTANT E-TEST-SENSOR ( electric test position sensor )
S3 CONSTANT OUTPUT-SENSOR ( output position sensor )

V-TEST-SENSOR IS-TOUCH
E-TEST-SENSOR IS-TOUCH
OUTPUT-SENSOR IS-TOUCH

: NOT ( a -- b )
   TRUE XOR ;

: 3DUP ( a b c -- a b c a b c )
   DUP 2OVER ROT ;

: 3NOR ( a b c -- bool )
   OR OR NOT ;

: 3DROP ( a b c -- )
   2DROP DROP ;

( boolean variables indicating whether a position is occupied )
VARIABLE V-TEST-OCCUPIED
VARIABLE E-TEST-OCCUPIED
VARIABLE OUTPUT-OCCUPIED

( the generic feed word )
: PARALLEL-FEED ( v-bool e-bool o-bool -- )
   TRUE OUTPUT-OCCUPIED ! ( set the occupation variables )
   TRUE E-TEST-OCCUPIED !
   TRUE V-TEST-OCCUPIED !
   3DUP
   IF FORWARD OUTPUT MOTOR THEN ( start the motors )
   IF FORWARD E-TEST MOTOR THEN
   IF FORWARD V-TEST MOTOR THEN
   BEGIN ( loop until all positions have been unoccupied, then occupied. )

      ROT DUP
      IF V-TEST-SENSOR TOUCH? DUP V-TEST-OCCUPIED @ NOT AND
         IF STOP V-TEST MOTOR
            SWAP NOT SWAP
         THEN V-TEST-OCCUPIED !
      THEN

      ROT DUP
      IF E-TEST-SENSOR TOUCH? DUP E-TEST-OCCUPIED @ NOT AND
         IF STOP E-TEST MOTOR
            SWAP NOT SWAP
         THEN E-TEST-OCCUPIED !
      THEN

      ROT DUP
      IF OUTPUT-SENSOR TOUCH? DUP OUTPUT-OCCUPIED @ NOT AND
         IF STOP OUTPUT MOTOR
            SWAP NOT SWAP
         THEN OUTPUT-OCCUPIED !
      THEN

      3DUP 3NOR
   UNTIL 3DROP
;

( these are the words used by LabVIEW )

: V-TEST-FEED ( -- )
   TRUE FALSE FALSE PARALLEL-FEED ;

: E-TEST-FEED ( -- )
   TRUE TRUE FALSE PARALLEL-FEED ;

: FULL-FEED ( -- )
   TRUE TRUE TRUE PARALLEL-FEED ;

: EMPTY-V-TEST ( -- )
   FORWARD V-TEST MOTOR
   FALSE TRUE TRUE PARALLEL-FEED
   FLOAT V-TEST MOTOR ;

: EMPTY-E-TEST ( -- )
   FORWARD E-TEST MOTOR
   FALSE FALSE TRUE PARALLEL-FEED
   FLOAT E-TEST MOTOR ;

: EMPTY-OUTPUT ( -- )
   FORWARD OUTPUT MOTOR
   FALSE FALSE FALSE PARALLEL-FEED
   FLOAT OUTPUT MOTOR ;
