import processing.video.*;
import processing.net.*;

Server myserver;
int port = 5204;

Capture video;
color track_color=-592154;

int variance = 50;

ArrayList<Integer> last_x = new ArrayList<Integer>();
ArrayList<Integer> last_y = new ArrayList<Integer>();

int min_blob_dist = 20; //min dist between blobs
int color_threshold = 100;

ArrayList<Blob> blobs = new ArrayList<Blob>();


//--------------------------------------------------

float ex=11, ey=125;
float dx=1, dy=1;
int rx=0, ry=0;
int rlowx=(rx), rupx=(rx+50);
int f=100;
int life=5;
int scores=0;
boolean play=true;
PFont font1, font2;


void setup() {

  String[] cams = Capture.list();
  for(String s : cams){ println(s); }

  size(640,360);
  video = new Capture(this, 640,360);
  video.start();  
  smooth();
  
  myserver = new Server(this, port);
  
  noStroke();
  rectMode(CORNER);
  font1 = loadFont("ComicSansMS-20.vlw");
  font2 = loadFont("CourierNewPS-BoldMT-48.vlw");
}

float prev_x=0, prev_y=0;

void draw() {

    blobs.clear();
    //background(0);
    video.loadPixels();
    image(video, 0, 0);
      
    int index=0;

    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {

      color currentColor = video.pixels[index];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(track_color);
      float g2 = green(track_color);
      float b2 = blue(track_color);
        float dist = distSq(r1,g1,b1,r2,g2,b2);
        
        
        if(dist < color_threshold*color_threshold){ //&& brightness(currentColor)>200) {
 
          boolean found = false;
          for (Blob b : blobs){
            if(b.isNear(x,y)){
            b.add2b(x,y);
            found=true;
            break;
            }
          }
          
          if(!found){
            Blob new_blob = new Blob(x,y);
            blobs.add(new_blob);
          }
        }
        index++;
      }
    }
    String data_packet="";
    int i=0;
    for (Blob b : blobs){
      if(b.area()< 10000 && b.points.size()>5){
          int cx = int(b.getCX());
          int cy = int(b.getCY());
          //data_packet += (str(cx)+","+str(cy)+",");
          b.show(); 
      }
      
    }
    //println(data_packet);
  
  float avgX=0.0,avgY=0.0;
  for (Blob b : blobs){
        avgX += b.getCX();
        avgY += b.getCY();
  }
  
  avgX /= blobs.size();
  avgY /= blobs.size();
  
  avgX = avgX==0?prev_x:avgX;
  avgY = avgY==0?prev_y:avgY;
  
//---------------------------------------------------------------------
frameRate(f);
  if((avgX-prev_x)*(avgX-prev_x)<variance){
    rx= int(avgX);
  }
  else{
    rx = int(prev_x);
  }
  
  if((avgY-prev_y)*(avgY-prev_y)<variance){
    ry = int(avgY);
  }
  else{
    ry = int(prev_y);
  }
  
  last_x.add(rx);
  last_y.add(ry);
  
  if(last_x.size()>5){
    last_x.remove(0);
    int sum = 0;
    for (Integer n : last_x)
    {
      sum += n;
    }
    rx = sum/last_x.size();      
  }
  if(last_y.size()>5){
  last_y.remove(0);
  int sum = 0;
  for (Integer n : last_y)
  {
    sum += n;
  }
  ry = sum/last_y.size();      
  }
  
  data_packet = (str(rx)+","+str(ry)+",");
  myserver.write(data_packet);

  rlowx=(rx);
  rupx=(rx+50);
  
  if(ey<=10)
  {
    dy=-dy;
  }
  if(ey==(height-20))
  {
    if(ex<(rupx+14) && ex>(rlowx-14))
    {
    scores++;
    f=f+100;
    dy=-dy;
    }
  }
  if(ex>(width-10) || ex<=10)
  {
    dx=-dx;
  }
  if(ey>height)
  {
    ey=11;
    life--;
    
    if(life==0)
    {
     // background(0);
      //textFont(font2);
      //text(" Game OVER !",((width/2)-141),((height/2)-50));
      //String sc="Your Score: "+scores;
      //text(sc,((width/2)-163),((height/2)+20));
      //fill(172,200,250);
      //rect(((width/2)-130),((height/2)+40),320,80,30);
      //textFont(font2);
      //fill(0, 0, 255);
      //text("PLAY again",((width/2)-117),((height/2)+90));
      
      //scores=0;
      //play=!play;
      life = 5;
      scores = 0;
    }
  }
  if(play)
  {
    //update score and life card
  //background(255);
  fill(#1AFFAD);
  textFont(font1);
  text("Lives: ", 10,20);
  textFont(font1);
  text("Scores: ", 228,20);
  textFont(font1);
  text(scores, 320,20);
  int c=75;
  for(int h=0;h<life;h++)
  {
  fill(#1AFFAD);
  ellipse(c, 15, 10, 10);
  c=c+20;
  }
  //update ball and bar position
  ex=ex+dx;
  ey=ey+dy;
  noStroke();
  fill(255);
  ellipse(ex,ey,20,20);
  stroke(#1AFFAD);
  fill(0, 0, 255);
  rect(rx,(height-10), 50, 10);
  }
  prev_x = avgX;
  prev_y = avgY;
}

void mousePressed(){
    video.loadPixels();
    track_color = video.pixels[mouseX+mouseY*width];
    println(min(640,mouseX)+" "+min(360,mouseY)+track_color);
    
    if(life==0){
    if(mouseX>331 && mouseX<630 && mouseY>340 && mouseY<420){
    play=!play;
    life=5;
    f=100; 
    }
    }
    //if(blobs.isEmpty()){
    // println("Blob list empty");
    //}
    //else{
    //for(Blob b : blobs){
    //b.info();
    //}
    //}
}


float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}


void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    color_threshold+=5;
      println("color threshold: " +color_threshold);
  } else if (key == 'd') {
    color_threshold-=5;
      println("color threshold: " +color_threshold);

  }
  else if(key =='w'){
    min_blob_dist+=5;
    println("dist threshold: " +min_blob_dist);

  }
  else if(key=='s'){
    min_blob_dist-=5;
    println("dist threshold: " +min_blob_dist);
    
  }
}
