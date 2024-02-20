#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Initialize the LCD library with I2C address and LCD size
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Function to initialize the LCD
void int_lcd_r() {
  lcd.init();          // Initialize the LCD
  lcd.backlight();     // Turn on the LCD backlight
  lcd.clear();         // Clear the LCD display
  lcd.setCursor(0, 3); // Set the cursor to row 0, column 3
  lcd.print("Motor Monitoring"); // Print "Motor Monitoring" text
  delay(1000);         // Delay for 1 second
  lcd.clear();         // Clear the LCD display
}