#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    BLEDevice::startAdvertising();
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
  }
};

// Fungsi untuk menginisialisasi komunikasi Bluetooth Low Energy (BLE)
void int_BLE() {
  Serial.print("*********************************** WaveShare ***********************************\n");

  // Inisialisasi perangkat BLE
  BLEDevice::init("ESP32 THAT PROJECT");

  // Buat server BLE
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Buat layanan BLE
  BLEService* pService = pServer->createService(SERVICE_UUID);

  // Buat karakteristik BLE
  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |
    BLECharacteristic::PROPERTY_WRITE |
    BLECharacteristic::PROPERTY_NOTIFY |
    BLECharacteristic::PROPERTY_INDICATE
  );

  // Tambahkan deskriptor BLE
  pCharacteristic->addDescriptor(new BLE2902());

  // Memulai layanan BLE
  pService->start();

  // Memulai iklan (advertising)
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

// Fungsi untuk menghandle operasi BLE dalam loop utama
void loop_ble() {
  // Memberi tahu nilai yang berubah
  if (deviceConnected) {
    String str = "";
    str += suhucelcius; // Menambahkan suhu ke dalam string

    pCharacteristic->setValue((char*)str.c_str()); // Mengatur nilai karakteristik BLE dengan nilai suhu
    pCharacteristic->notify(); // Memberi tahu perangkat yang terhubung
  }

  // Mengecek jika perangkat terputus
  if (!deviceConnected && oldDeviceConnected) {
    delay(500); // Memberi kesempatan kepada tumpukan Bluetooth untuk bersiap-siap
    pServer->startAdvertising(); // Memulai ulang iklan
    Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;
  }

  // Mengecek jika perangkat terhubung
  if (deviceConnected && !oldDeviceConnected) {
    // Lakukan sesuatu ketika perangkat terhubung
    oldDeviceConnected = deviceConnected;
  }

  delay(500);
}