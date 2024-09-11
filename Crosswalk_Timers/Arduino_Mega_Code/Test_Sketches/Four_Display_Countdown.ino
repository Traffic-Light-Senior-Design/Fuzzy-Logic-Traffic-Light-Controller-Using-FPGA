
// Pin mappings for the segments and common pins for the four displays
const int segmentPins1[] = {2, 3, 4, 5, 6, 7, 8}; // Segments for Display 1
const int commonPins1[] = {38, 39}; // Common pins for Display 1

const int segmentPins2[] = {9, 10, 11, 12, 13, 22, 23}; // Segments for Display 2
const int commonPins2[] = {40, 41, }; // Common pins for Display 2

const int segmentPins3[] = {24, 25, 26, 27, 28, 29, 30}; // Segments for Display 3
const int commonPins3[] = {42, 43}; // Common pins for Display 3

const int segmentPins4[] = {31, 32, 33, 34, 35, 36, 37}; // Segments for Display 4
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

// Initialize countdown starting values
int countdown1 = 15;
int countdown2 = 12;
int countdown3 = 23;
int countdown4 = 0;

void setup() {
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
}

void loop() {
  // Run the countdown loop until all displays reach 00
  while (countdown1 >= 0 || countdown2 >= 0 || countdown3 >= 0 || countdown4 >= 0) {
    unsigned long startTime = millis();  // Record the start time of this second

    // Continue refreshing the display until 1 second has passed
    while (millis() - startTime < 1000) {
      // Refresh the display continuously
      displayNumber(countdown1, segmentPins1, commonPins1);
      displayNumber(countdown2, segmentPins2, commonPins2);
      displayNumber(countdown3, segmentPins3, commonPins3);
      displayNumber(countdown4, segmentPins4, commonPins4);
    }

    // After 1 second, decrement the countdown values
    if (countdown1 > 0) countdown1--;
    if (countdown2 > 0) countdown2--;
    if (countdown3 > 0) countdown3--;
    if (countdown4 > 0) countdown4--;
  }
}

void displayNumber(int number, const int segmentPins[], const int commonPins[]) {
  int tens = number / 10; // Get the tens digit
  int ones = number % 10; // Get the ones digit

  // Display the tens digit
  displayDigit(tens, segmentPins, commonPins[0], commonPins[1]);

  // Display the ones digit
  displayDigit(ones, segmentPins, commonPins[1], commonPins[0]);
}

void displayDigit(int digit, const int segmentPins[], int activeCommonPin, int inactiveCommonPin) {
  // Clear all segments first
  clearSegments(segmentPins);

  // Activate the correct common pin
  digitalWrite(activeCommonPin, LOW); // Common anode active when LOW
  digitalWrite(inactiveCommonPin, HIGH); // Inactive common pin HIGH

  // Set the segments for the digit
  for (int i = 0; i < 7; i++) {
    digitalWrite(segmentPins[i], Segment_Pins[digit][i]);
  }

  delay(2); // Short delay for visibility

  // Turn off the display after showing the digit
  digitalWrite(activeCommonPin, HIGH);
}

void clearSegments(const int segmentPins[]) {
  for (int i = 0; i < 7; i++) {
    digitalWrite(segmentPins[i], HIGH); // Turn off segments for common anode
  }
}