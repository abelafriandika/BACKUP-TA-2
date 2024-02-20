#define pinbuzzer 26

// Fungsi untuk menginisialisasi pin buzzer sebagai output dan menghentikan bunyi buzzer
void int_buzzer() {
  pinMode(pinbuzzer, OUTPUT);  // Menginisialisasi pin buzzer sebagai output
  analogWrite(pinbuzzer, 0);  // Menghentikan bunyi buzzer dengan analogWrite 0
}

// Fungsi untuk mengendalikan buzzer berdasarkan nilai state
void buzzer(int state) {
  status_buzzer = state;  // Menetapkan status buzzer sesuai dengan nilai state
  
  if (state == 1) {
    analogWrite(pinbuzzer, 100);  // Menyalakan buzzer dengan analogWrite 100 (suara buzzer terdengar)
  } else {
    analogWrite(pinbuzzer, 0);  // Mematikan buzzer dengan analogWrite 0 (tidak ada suara buzzer)
  }
}