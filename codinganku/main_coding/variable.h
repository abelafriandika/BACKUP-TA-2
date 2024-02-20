float suhucelcius = 0;  // Variabel untuk menyimpan suhu dalam derajat Celsius
int status_buzzer = 0;  // Variabel untuk status buzzer (0: Mati, 1: Hidup)
int status_red = 0;     // Variabel untuk status lampu merah (0: Mati, 1: Hidup)
int status_yellow = 0;  // Variabel untuk status lampu kuning (0: Mati, 1: Hidup)
int status_green = 0;   // Variabel untuk status lampu hijau (0: Mati, 1: Hidup)
int beep = 0;           // Variabel untuk status bunyi beep (0: Mati, 1: Hidup)

int warning = 0;  // Variabel untuk status peringatan (0, 1, atau 2)
String statuswarning[3];  // Array untuk pesan status (indeks 0, 1, atau 2)

// Memasukkan berkas header yang diperlukan
#include "buzzer.h"     // Berkas header untuk buzzer
#include "rgb.h"        // Berkas header untuk lampu RGB
#include "senso_suhu.h" // Berkas header untuk sensor suhu
#include "lcdd.h"       // Berkas header untuk LCD
#include "bluetooth.h"  // Berkas header untuk Bluetooth