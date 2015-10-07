

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
int simulateSpeed = 4;
int counter = 0;


void setup() {

  pinMode(ledBtConnected, OUTPUT);
  pinMode(ledBtError, OUTPUT);
  pinMode(simulateSpeed, INPUT); 

  ble_set_pins(9,8);
  ble_set_name("OBD-II");
  ble_begin();

  digitalWrite(ledBtConnected, LOW); 

  obd.begin();
  delay(500);
  /* Testing */
  /*
  while (!obd.init()){
    digitalWrite(ledBtError, HIGH); 
    delay(500);
    digitalWrite(ledBtError, LOW); 
  }
  */
}

void loop() {

  int speed = 0;
  if ( ble_connected()) {
    bool state = true;
    digitalWrite(ledBtConnected, HIGH); 

    digitalWrite(ledBtConnected, LOW); 
    int i = (counter % 180);
    ble_write(i);
    ble_do_events();
    counter++;
    
    delay(200);
    digitalWrite(ledBtConnected, HIGH);
    
    //delay(1000);
      
  }
  else{
    digitalWrite(ledBtConnected, LOW); 
    ble_do_events();
  }
  
}






