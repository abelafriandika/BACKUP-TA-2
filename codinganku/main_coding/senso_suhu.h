#include "max6675.h"

int thermoDO = 19;   // Pin data output dari sensor MAX6675
int thermoCS = 23;   // Pin chip select untuk sensor MAX6675
int thermoCLK = 5;   // Pin clock untuk sensor MAX6675

MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);

// Fungsi untuk inisialisasi sensor suhu MAX6675
void int_suhu() {
  Serial.println("MAX6675 test");
  // Tunggu agar chip MAX6675 stabil
  delay(500);
}

// Fungsi untuk membaca suhu dari sensor MAX6675
void loop_suhu() {
  suhucelcius = thermocouple.readCelsius(); 
  // Untuk MAX6675 agar diperbarui, Anda harus menunda SETIDAKNYA 250ms antara bacaan
  delay(250);
}