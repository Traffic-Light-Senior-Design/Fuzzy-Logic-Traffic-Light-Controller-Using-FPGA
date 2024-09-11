// Pin mappings for the segments and common pins for the four displays
const int segmentPins1[] = {2, 3, 4, 5, 6, 7, 8}; // Segments for Display 1 (A-G)
const int commonPins1[] = {38, 39}; // Common pins for Display 1

const int segmentPins2[] = {9, 10, 11, 12, 13, 22, 23}; // Segments for Display 2 (A-G)
const int commonPins2[] = {40, 41}; // Common pins for Display 2

const int segmentPins3[] = {24, 25, 26, 27, 28, 29, 30}; // Segments for Display 3 (A-G)
const int commonPins3[] = {42, 43}; // Common pins for Display 3

const int segmentPins4[] = {31, 32, 33, 34, 35, 36, 37}; // Segments for Display 4 (A-G)
const int commonPins4[] = {44, 45}; // Common pins for Display 4

// Segment patterns for digits 0-9 (Common Anode)
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
  {1, 1, 1, 1, 0, 1, 1}  // 9
};

// Countdown values for each display
int countdown[4] = {0, 0, 0, 0};  // Store values for all 4 displays
int byteCount = 0;  // Counter to track how many bytes we've received
bool newDataReceived = false;  // Flag to track if new data was received

unsigned long lastUpdate = 0;  // Timer to control when to decrement

void setup() {
  Serial.begin(115200);  // Start the serial monitor for debugging
  Serial1.begin(115200);  // Use Serial1 for UART communication with FPGA

  // Set all segment pins as output
  for (int i = 0; i < 7; i++) {
    pinMode(segmentPins1[i], OUTPUT);
    pinMode(segmentPins2[i], OUTPUT);
    pinMode(segmentPins3[i], OUTPUT);
    pinMode(segmentPins4[i], OUTPUT);
  }

  // Set all common pins as output
  for (int i = 0; i < 2; i++) {
    pinMode(commonPins1[i], OUTPUT);
    pinMode(commonPins2[i], OUTPUT);
    pinMode(commonPins3[i], OUTPUT);
    pinMode(commonPins4[i], OUTPUT);
  }

  // Initially, turn off all displays
  clearAllDisplays();
}

void loop() {
  // Check if new data is available and read exactly 4 bytes from Serial1
  if (Serial1.available() > 0) {
    byte receivedByte = Serial1.read();  // Read one byte at a time
    countdown[byteCount] = (int)receivedByte;  // Store as int for displaying
    Serial.print("Received for Display ");
    Serial.print(byteCount + 1);
    Serial.print(": ");
    Serial.println(countdown[byteCount]);

    newDataReceived = true;  // Data was received

    // Display the received byte on the corresponding display
    switch (byteCount) {
      case 0:
        displayNumber(countdown[0], segmentPins1, commonPins1);
        break;
      case 1:
        displayNumber(countdown[1], segmentPins2, commonPins2);
        break;
      case 2:
        displayNumber(countdown[2], segmentPins3, commonPins3);
        break;
      case 3:
        displayNumber(countdown[3], segmentPins4, commonPins4);
        break;
    }

    byteCount++;

    // Reset the byte counter after reading 4 bytes
    if (byteCount >= 4) {
      byteCount = 0;
    }
  }

  // Decrement countdown if enough time has passed
  if (millis() - lastUpdate >= 1000 && newDataReceived) {  // Decrement every second
    for (int i = 0; i < 4; i++) {
      if (countdown[i] > 0) {
        countdown[i]--;  // Decrement countdown values
      }
    }

    lastUpdate = millis();  // Update the lastUpdate time
  }

  // Check each display individually and turn it off if countdown reaches 0
  if (countdown[0] == 0) {
    clearDisplay(commonPins1);  // Turn off display 1
  } else {
    displayNumber(countdown[0], segmentPins1, commonPins1);  // Keep refreshing display 1 if not 0
  }

  if (countdown[1] == 0) {
    clearDisplay(commonPins2);  // Turn off display 2
  } else {
    displayNumber(countdown[1], segmentPins2, commonPins2);  // Keep refreshing display 2 if not 0
  }

  if (countdown[2] == 0) {
    clearDisplay(commonPins3);  // Turn off display 3
  } else {
    displayNumber(countdown[2], segmentPins3, commonPins3);  // Keep refreshing display 3 if not 0
  }

  if (countdown[3] == 0) {
    clearDisplay(commonPins4);  // Turn off display 4
  } else {
    displayNumber(countdown[3], segmentPins4, commonPins4);  // Keep refreshing display 4 if not 0
  }
}

// Display a number on the 7-segment display
void displayNumber(int number, const int segmentPins[], const int commonPins[]) {
  int tens = number / 10;  // Get the tens digit
  int ones = number % 10;  // Get the ones digit

  // Display the tens digit
  displayDigit(tens, segmentPins, commonPins[0], commonPins[1]);

  // Display the ones digit
  displayDigit(ones, segmentPins, commonPins[1], commonPins[0]);
}

// Display a single digit on the 7-segment display
void displayDigit(int digit, const int segmentPins[], int activeCommonPin, int inactiveCommonPin) {
  clearSegments(segmentPins);  // Clear all segments

  // Activate the correct common pin
  digitalWrite(activeCommonPin, LOW);  // Common anode active when LOW
  digitalWrite(inactiveCommonPin, HIGH);  // Inactive common pin HIGH

  // Set the segments for the digit
  for (int i = 0; i < 7; i++) {
    digitalWrite(segmentPins[i], Segment_Pins[digit][i]);
  }

  delay(2);  // Short delay for visibility

  // Turn off the display after showing the digit
  digitalWrite(activeCommonPin, HIGH);
}

// Clear all segments of the display
void clearSegments(const int segmentPins[]) {
  for (int i = 0; i < 7; i++) {
    digitalWrite(segmentPins[i], LOW);  // Turn off segments for common anode
  }
}

// Clear a specific display (turn it off)
void clearDisplay(const int commonPins[]) {
  // Turn off both common pins of the display
  digitalWrite(commonPins[0], HIGH);
  digitalWrite(commonPins[1], HIGH);
}

// Clear all displays (turn them off)
void clearAllDisplays() {
  clearDisplay(commonPins1);
  clearDisplay(commonPins2);
  clearDisplay(commonPins3);
  clearDisplay(commonPins4);
}