// Pin mappings for the segments and common pins for the four displays
const int segmentPins1[] = {2, 3, 4, 5, 6, 7, 8}; // Segments for Display 1
const int commonPins1[] = {38, 39}; // Common pins for Display 1

const int segmentPins2[] = {9, 10, 11, 12, 13, 22, 23}; // Segments for Display 2
const int commonPins2[] = {40, 41, }; // Common pins for Display 2

const int segmentPins3[] = {24, 25, 26, 27, 28, 29, 30}; // Segments for Display 3
const int commonPins3[] = {42, 43}; // Common pins for Display 3

const int segmentPins4[] = {31, 32, 33, 34, 35, 36, 37}; // Segments for Display 4
const int commonPins4[] = {44, 45}; // Common pins for Display 4

// Segment patterns for digits 0-9
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
  int numLoops = 500;

  for (int n = 0; n < numLoops; n++) {
    // Display '12' on Display 1, '34' on Display 2, '56' on Display 3, '78' on Display 4
    displayDigit(1, segmentPins1, commonPins1[0], commonPins1[1]);
    displayDigit(2, segmentPins1, commonPins1[1], commonPins1[0]);

    displayDigit(3, segmentPins2, commonPins2[0], commonPins2[1]);
    displayDigit(4, segmentPins2, commonPins2[1], commonPins2[0]);

    displayDigit(5, segmentPins3, commonPins3[0], commonPins3[1]);
    displayDigit(6, segmentPins3, commonPins3[1], commonPins3[0]);

    displayDigit(7, segmentPins4, commonPins4[0], commonPins4[1]);
    displayDigit(8, segmentPins4, commonPins4[1], commonPins4[0]);
  }
}

void displayDigit(int digit, const int segmentPins[], int activeCommonPin, int inactiveCommonPin) {
  // Clear all segments first
  clearSegments(segmentPins);

  // Activate the correct common pin
  digitalWrite(activeCommonPin, LOW); 
  digitalWrite(inactiveCommonPin, HIGH);

  // Set the segments for the digit
  for (int i = 0; i < 7; i++) {
    digitalWrite(segmentPins[i], Segment_Pins[digit][i]);
  }

  delay(1); // Short delay for visibility

  // Turn off the display after showing the digit
  digitalWrite(activeCommonPin, HIGH);
}

void clearSegments(const int segmentPins[]) {
  for (int i = 0; i < 7; i++) {
    digitalWrite(segmentPins[i], HIGH); // Turn off segments for common anode
  }
}
