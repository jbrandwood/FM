#define CLOCK       17   // A0 for CLOCK
#define LATCH       18   // A1 for LATCH
#define DATA        19   // A2 for DATA

#define OUT_BEGIN   2    // Pin 2
#define NUM_OUTPUT  12   // to Pin 13

void setup() {
    pinMode(LATCH,OUTPUT);
    pinMode(CLOCK,OUTPUT);
    pinMode(DATA,INPUT);

    digitalWrite(CLOCK,LOW);
    digitalWrite(LATCH,LOW);

    for(int i=0; i<NUM_OUTPUT; ++i)
    {
        pinMode(OUT_BEGIN+i,OUTPUT);
        digitalWrite(OUT_BEGIN+i,LOW);
    }
}

void loop() {
    digitalWrite(CLOCK,LOW);
    digitalWrite(LATCH,HIGH);
    digitalWrite(LATCH,LOW);
    for(int i=0; NUM_OUTPUT; ++i)
    {
        digitalWrite(OUT_BEGIN+i,digitalRead(DATA));
        digitalWrite(CLOCK,HIGH);
        digitalWrite(CLOCK,LOW);
    }
}
