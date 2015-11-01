

/*
  Developer Podcast 
 Folge: DP003-OBD2_BluetoothLE_iOS
 
 Marko Seifert
 http://www.marko-seifert.de
 Apache 2 License
 
 */

#include <Arduino.h>
#include <OBD.h>
#include <Wire.h>
#include <SPI.h>
#include <boards.h>
#include <RBL_nRF8001.h>
#include <RBL_services.h>

COBD obd;
int ledBtConnected = 3;
int ledBtError = 2;

void setup() {

  pinMode(ledBtConnected, OUTPUT);
  pinMode(ledBtError, OUTPUT);

  ble_set_pins(9,8);
  ble_set_name("OBD-II");
  ble_begin();

  digitalWrite(ledBtConnected, LOW); 

  obd.begin();
  delay(500);
  while (!obd.init()){
    digitalWrite(ledBtError, HIGH); 
    delay(500);
    digitalWrite(ledBtError, LOW); 
  }
}

void loop() {

  int speed = 0;
  if ( ble_connected()) {
    bool state = obd.read(PID_SPEED, speed);
    digitalWrite(ledBtConnected, HIGH); 

    if(state){
      digitalWrite(ledBtConnected, LOW); 
      ble_write(speed);
      ble_do_events();
      delay(200);
      digitalWrite(ledBtConnected, HIGH); 
    } else{
      digitalWrite(ledBtError, HIGH);
      // reset,
      obd.init();
      delay(500);
      digitalWrite(ledBtError, LOW); 
    }
    delay(1000);
      
  }
  else{
    digitalWrite(ledBtConnected, LOW); 
    ble_do_events();
  }
  
}






