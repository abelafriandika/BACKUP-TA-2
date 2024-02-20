#define pinlamp_red 32
#define pinlamp_yellow 33
#define pinlamp_green 25

// Fungsi untuk menginisialisasi pin-pin lampu sebagai output dan mematikan semua lampu
void int_lamp() {
  pinMode(pinlamp_red, OUTPUT);     // Inisialisasi pin lampu merah sebagai output
  pinMode(pinlamp_yellow, OUTPUT);  // Inisialisasi pin lampu kuning sebagai output
  pinMode(pinlamp_green, OUTPUT);   // Inisialisasi pin lampu hijau sebagai output
  digitalWrite(pinlamp_red, LOW);     // Matikan lampu merah (nyala rendah)
  digitalWrite(pinlamp_yellow, LOW);  // Matikan lampu kuning (nyala rendah)
  digitalWrite(pinlamp_green, LOW);   // Matikan lampu hijau (nyala rendah)
}

// Fungsi untuk mengendalikan lampu merah berdasarkan nilai state
void red_lamp(int state) {
  status_red = state;  // Set status lampu merah sesuai dengan nilai state
  if (state == 1) {
    digitalWrite(pinlamp_red, HIGH);  // Nyalakan lampu merah
  } else {
    digitalWrite(pinlamp_red, LOW);   // Matikan lampu merah
  }
}

// Fungsi untuk mengendalikan lampu kuning berdasarkan nilai state
void yellow_lamp(int state) {
  status_yellow = state;  // Set status lampu kuning sesuai dengan nilai state
  if (state == 1) {
    digitalWrite(pinlamp_yellow, HIGH);  // Nyalakan lampu kuning
  } else {
    digitalWrite(pinlamp_yellow, LOW);   // Matikan lampu kuning
  }
}

// Fungsi untuk mengendalikan lampu hijau berdasarkan nilai state
void green_lamp(int state) {
  status_green = state;  // Set status lampu hijau sesuai dengan nilai state
  if (state == 1) {
    digitalWrite(pinlamp_green, HIGH);  // Nyalakan lampu hijau
  } else {
    digitalWrite(pinlamp_green, LOW);   // Matikan lampu hijau
  }
}

// Fungsi untuk mengendalikan semua lampu sekaligus berdasarkan nilai state
void ALL_lamp(int state) {
  if (state == 1) {
    red_lamp(1);        // Nyalakan lampu merah
    yellow_lamp(1);     // Nyalakan lampu kuning
    green_lamp(1);      // Nyalakan lampu hijau
  } else {
    red_lamp(0);        // Matikan lampu merah
    yellow_lamp(0);     // Matikan lampu kuning
    green_lamp(0);      // Matikan lampu hijau
  }
}