
/*
 * 50㎝まではかなりの精度で測定できる。
 * 
 */

const int numSns = 1;  //number of sensors
const double k1 = 43742.75;
const double k2 = -37.6452;

/* Initialization */
void setup(){
 Serial.begin(9600);
}

/* main program */
void loop(){
  // variables
  double value = 0.0;     // sensor value
  double destination = 0.0;
  String data = "";  // string to contain sending data
  String dest_data = "";
  
  for(int n = 0; n < numSns; n++){
    value = analogRead(n);    // measure the output voltage from sensors by A/D conversion
    destination = k1 / (value + k2); 
    // add sensor value to the string
    data += String(value);
    dest_data += String(destination);
    
    if(n != numSns - 1){  
      data += ",";
      dest_data += ",";
    }
  }
  
  // send data by serial communication
  Serial.println(destination/10);
  Serial.write('H');
  Serial.write(highByte((int)destination/10));
  Serial.write(lowByte((int)destination/10));
  delay(500);  // wait 20 ms
}
