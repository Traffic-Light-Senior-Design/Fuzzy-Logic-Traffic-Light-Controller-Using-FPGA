int pinA = 2;
int pinB = 3;
int pinC = 4;
int pinD = 5;
int pinE = 6;
int pinF = 7;
int pinG = 8;
int D1 = 38;
int D2 = 39;
int i = 0; // right digit
int k = 0; // left digit
int j = 0;

byte incomingByte = 0;  // To store the received byte
bool newNumberReceived = false; // flag to detect new number reception

int Arduino_Pins[7] = {pinA, pinB, pinC, pinD, pinE, pinF, pinG};

int Segment_Pins[10][7] = {
  {1, 1, 1, 1, 1, 1, 0}, // 0
  {0, 1, 1, 0, 0, 0, 0}, // 1
  {1, 1, 0, 1, 1, 0, 1}, // 2
  {1, 1, 1, 1, 0, 0, 1}, // 3
  {0, 1, 1, 0, 0, 1, 1}, // 4
  {1, 0, 1, 1, 0, 1, 1}, // 5
  {1, 0, 1, 1, 1, 1, 1}, // 6
  {1, 1, 1, 0, 0, 0, 0}, // 7
  {1, 1, 1, 1, 1, 1, 1}, // 8
  {1, 1, 1, 1, 0, 1, 1}, // 9
};

void setup() {
  // Initialize pin modes
  pinMode(pinA, OUTPUT);
  pinMode(pinB, OUTPUT);
  pinMode(pinC, OUTPUT);
  pinMode(pinD, OUTPUT);
  pinMode(pinE, OUTPUT);
  pinMode(pinF, OUTPUT);
  pinMode(pinG, OUTPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);

  // Initialize Serial1 for UART communication
  Serial1.begin(115200);

  // Flush any initial noise from the serial buffer
  while (Serial1.available() > 0) {
    Serial1.read();  // Clear out the buffer
  }

  // Start the regular Serial for debugging
  Serial.begin(115200);
}

void loop() {
  // Check if data is available on Serial1
  if (Serial1.available() > 0) {
    incomingByte = Serial1.read();  // Read the raw byte

    // Ignore initial '0' bytes
    if (incomingByte != 0) {
      int receivedNumber = (int)incomingByte;  // Type case the byte to int

      // Print received byte to verify its correctness
      Serial.print("Raw byte received: ");
      Serial.println(receivedNumber);  // Print as decimal

      if (receivedNumber >= 0 && receivedNumber <= 99) {  // Ensure the number is between 0 and 99
          k = receivedNumber / 10;  // Left digit (tens)
          i = receivedNumber % 10;  // Right digit (ones)

          newNumberReceived = true;

          // Debugging prints
          Serial.print("Received number: ");
          Serial.println(receivedNumber);
          Serial.print("Left digit (k): ");
          Serial.println(k);
          Serial.print("Right digit (i): ");
          Serial.println(i);
      }
    }
  }


  if (newNumberReceived) {
    // Display digits
    for (int n = 0; n < 500; n++) {
      // Display the right digit
      for (j = 0; j < 7; j++) {
        digitalWrite(Arduino_Pins[j], Segment_Pins[i][j]);
      }
      digitalWrite(D1, 1); // Turn on right display
      digitalWrite(D2, 0); // Turn off left display
      delay(1);

      // Display the left digit
      for (j = 0; j < 7; j++) {
        digitalWrite(Arduino_Pins[j], Segment_Pins[k][j]);
      }
      digitalWrite(D1, 0); // Turn off right display
      digitalWrite(D2, 1); // Turn on Left display
      delay(1);
    }

    // Countdown logic
    i--;
    if (i < 0) {
      i = 9;
      k--;
      if (k < 0) {
        i = 0; // Stop decrementing when reaching 00
        k = 0; // Stop decrementing when reaching 00

        // Turn off both digits when the countdown is finished
        digitalWrite(D1, 1); // Turn off right digit
        digitalWrite(D2, 1); // Turn off left digit

        newNumberReceived = false; // Stop countdown when it reaches zero
      }
    }
  }
}
