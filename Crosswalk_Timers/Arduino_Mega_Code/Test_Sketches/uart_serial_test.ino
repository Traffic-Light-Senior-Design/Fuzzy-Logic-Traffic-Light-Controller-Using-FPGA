// Constants to define the number of non-zero bytes
const int NUM_NON_ZERO_BYTES = 4;
byte receivedBytes[NUM_NON_ZERO_BYTES];  // Array to store received bytes

void clearSerial1Buffer() {
  while (Serial1.available() > 0) {
    Serial1.read();  // Clear out any existing bytes in the buffer
  }
}

void setup() {
  // Initialize the serial communication for the Serial Monitor:
  Serial.begin(115200);

  // Initialize Serial1 for communication with the FPGA:
  Serial1.begin(115200);  // Matching the FPGA baud rate

  Serial.println("Ready to receive non-zero data from FPGA...");

  // Clear the buffer before starting
  clearSerial1Buffer();
}

void loop() {
  int byteCount = 0;  // Counter to track how many non-zero bytes we've received

  // Clear the buffer at the beginning of each loop
  clearSerial1Buffer();

  // Loop until 4 non-zero bytes
  while (byteCount < NUM_NON_ZERO_BYTES) {
    // Check if data is available to read from Serial1:
    if (Serial1.available() > 0) {
      // Read the incoming byte:
      byte receivedByte = Serial1.read();

      Serial.print("Received: ");
      Serial.println(receivedByte, HEX); 

      // Only count and store non-zero bytes
      if (receivedByte != 0) {
        receivedBytes[byteCount] = receivedByte;
        // Serial.print("Received: ");
        // Serial.println(receivedByte, HEX);  // Print the received non-zero byte as hexadecimal value
        byteCount++;  // Increment the count for valid non-zero byte
      }
    }
  }

  // After receiving 4 non-zero bytes, you can process them further if needed:
  Serial.println("All 4 non-zero bytes received!");

  // Optional: Add a delay before starting over or do something else here
  delay(1000);  // Add a small delay before resetting for the next 4 bytes
  byteCount = 0;  // Reset the byte count for the next transmission
}


