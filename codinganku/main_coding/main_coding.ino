 #include "variable.h"

void setup() {
  // Inisialisasi kode yang akan dijalankan sekali saat Arduino pertama kali dinyalakan
  Serial.begin(115200);  // Memulai komunikasi serial dengan baud rate 115200
  
  // Menetapkan pesan status ke dalam array
  statuswarning[0] = "  Mesin Normal  ";
  statuswarning[1] = "5-10 km suhu 50C";
  statuswarning[2] = " MATIKAN MESIN  ";
  
  // Memanggil fungsi-fungsi inisialisasi
  int_buzzer();
  int_lamp();
  int_lcd_r();
  int_suhu();
  int_BLE();
}

void loop() {
  // Mengulangi kode berikut secara berulang
  loop_suhu();   // Membaca suhu
  logika();       // Mengendalikan logika untuk lampu dan buzzer berdasarkan suhu
  loop_ble();     // Menghandle koneksi BLE
  lcd_display();  // Menampilkan pesan status dan suhu pada LCD
  debug();        // Mencetak informasi debug melalui komunikasi serial
}

void logika() {
  // Mengendalikan logika lampu dan buzzer berdasarkan suhu
  if (suhucelcius < 40) {
    red_lamp(0);
    yellow_lamp(0);
    green_lamp(1);
    buzzer(0);
    warning = 0;
  }
  else if (suhucelcius < 50) {
    red_lamp(0);                                                              
    yellow_lamp(1);
    green_lamp(0);
    buzzer(0);
    warning = 1;
  }
  else if (suhucelcius >= 50) {
    red_lamp(1);
    yellow_lamp(0);
    green_lamp(0);
    warning = 2;
    beep = !beep;
    buzzer(beep);
    delay(500);
  }
}

void lcd_display() {
  // Menampilkan pesan status dan suhu pada LCD
  char buffersuhu[5];
  sprintf(buffersuhu, "%.2f   ", suhucelcius);
  lcd.setCursor(0, 0);
  lcd.print(statuswarning[warning]);
  lcd.setCursor(0, 1);
  lcd.print("Suhu Mesin:");
  lcd.setCursor(11, 1);
  lcd.print(buffersuhu);
}

void debug() {
  // Mencetak informasi debug melalui komunikasi serial
  Serial.print("suhucelcius:");
  Serial.print(suhucelcius);
  Serial.print(",status_buzzer:");
  Serial.print(status_buzzer);
  Serial.print(",status_red:");
  Serial.print(status_red);
  Serial.print(",status_yellow:");
  Serial.print(status_yellow);
  Serial.print(",status_green:");
  Serial.print(status_green);
  Serial.println("");
}