import processing.serial.*;
import ddf.minim.*;
import java.awt.*;
import controlP5.*;
Minim minim;
Serial serial;
ControlP5 cp5;
int recv_data = -1;
int set_hour = 99;
int set_min = 99;
AudioPlayer song;
boolean alarm_status = false;
int getUpHour;
int getUpMin;
String textHour =str(int(set_hour));
String textMinut = str(int(set_min));

void setup() {
  //画面サイズ
  size(900, 600);

  //テキストフィールドのパラメータ
  cp5 = new ControlP5(this);
  cp5.addTextfield("textHour")
    .setPosition(460, 450)
      .setSize(100, 80)
        .setFont(createFont("Arial",45,true))
          .setAutoClear(false)
            .setText("");
          
  cp5.addTextfield("textMinut")
    .setPosition(650, 450)
      .setSize(100, 80)
        .setFont(createFont("Arial",45,true))
          .setAutoClear(false)
            .setText("");
            

  
  //シリアル通信
  serial = new Serial( this, Serial.list()[0], 9600 );
  
  //アラーム
  minim = new Minim(this);
  song = minim.loadFile("好きな音楽のファイル名をいれてね！");
  
  //背景
  background(0); 
  frameRate(1);
    
  song.play(0);
}

void draw() {
  int sec = second();
  int min = minute();
  int hour = hour();
  String sleep_status = (sleepStatus(recv_data)) ? "Sleeping now.": "Get up";
  
  //アラームが鳴っているか
  if(!alarm_status || !sleepStatus(recv_data)) {//アラームを鳴らす時間ではないのになっている場合
    song.pause();
    song.rewind();
  }

/*現在時刻を表示させる*/
  //長方形を書いて表示範囲を塗りつぶす
  noStroke();
  fill(0,0,255);
  rect(200, 20, 700, 250);
  rect(70,420, 330, 90);
  
  //時刻を表示
  fill(255,255,255); 
  textSize(80);
  text(hour+":"+min+":"+sec, 300, 100);
  text(recv_data, 100, 500);
  text(sleep_status, 300, 230);
  textSize(40);
  text("Press Enter to set timer", 440, 350);
  
  //テキストフィードの値を取得
  set_hour = int(textHour);
  set_min = int(textMinut);
  println(set_hour);
  println(set_min);

 //アラーム
if((hour==set_hour) && (min == set_min)) {
    set_hour = 99;
    set_min = 99;
    alarm_status = true;
  }
  
  if(alarm_status) {
      if(sleepStatus(recv_data)) {
            song.play();    
      }
      getUpHour = (hour() + 1) / 24;
      getUpMin = minute();  
      if((getUpHour == hour) && (getUpMin == min)) {
        alarm_status = false;
    }
  }
}


void serialEvent(Serial port) {  
  if ( port.available() >= 3 ) {  // ヘッダ + 上位バイト + 下位バイト で合計３バイト
    if ( port.read() == 'H' ) {  // ヘッダ文字を見つけたところから読み取る
      int high = port.read();   // 上位バイト読み込み
      int low = port.read();    // 下位バイト読み込み
      recv_data = high*256 + low;  // 上位・下位を合体させる
      //println(recv_data);  // 結果の表示
    }
  }
}

//ベットに人がいるか、否か判定する
boolean sleepStatus(int sensor_data) {
   if(sensor_data <= 90 && sensor_data >= 0)
      return true;//寝ている
   else
      return false; //起きている
}
