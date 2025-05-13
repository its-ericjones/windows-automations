const int buttonPin = 12; 
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 1000;  // 1 second debounce period
int lastButtonState = HIGH;
int buttonState = HIGH;

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT_PULLUP);
  Serial.println("Button detection ready...");
}

void loop() {
  // Read the current button state
  int reading = digitalRead(buttonPin);

  // Check if button state changed (potential press)
  if (reading != lastButtonState) {
    // Reset debounce timer
    lastDebounceTime = millis();
  }

  // Wait for debounce period to ensure stable reading
  if ((millis() - lastDebounceTime) > debounceDelay) {
    // If the button state has changed and is stable
    if (reading != buttonState) {
      buttonState = reading;
      
      // Button is pressed (LOW when using INPUT_PULLUP)
      if (buttonState == LOW) {
        Serial.println("BUTTON_PRESSED");
      }
    }
  }
  
  // Save reading for next comparison
  lastButtonState = reading;
}