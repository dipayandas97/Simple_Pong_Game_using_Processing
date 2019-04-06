
float ex=11, ey=125;
float dx=1, dy=1;
int rx=100;
int rlowx=(rx), rupx=(rx+50);
int f=100;
int life=5;
int scores=0;
boolean play=true;
PFont font1, font2;

void setup()
{
  size(900, 600);
  noStroke();
  rectMode(CORNER);
  font1 = loadFont("ComicSansMS-20.vlw");
  font2 = loadFont("CourierNewPS-BoldMT-48.vlw");
}
void draw()
{
  frameRate(f);
  rx= mouseX;
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
      background(0);
      textFont(font2);
      text(" Game OVER !",((width/2)-141),((height/2)-50));
      String sc="Your Score: "+scores;
      text(sc,((width/2)-163),((height/2)+20));
      fill(172,200,250);
      rect(((width/2)-130),((height/2)+40),320,80,30);
      textFont(font2);
      fill(0, 0, 255);
      text("PLAY again",((width/2)-117),((height/2)+90));
      
      scores=0;
      play=!play;
    }
  }
  if(play)
  {
    //update score and life card
   background(255);
  fill(0, 0, 255);
  textFont(font1);
  text("Lives: ", 10,20);
  fill(0, 0, 255);
  textFont(font1);
  text("Scores: ", 228,20);
  fill(66, 0, 111);
  textFont(font1);
  text(scores, 320,20);
  int c=75;
  for(int i=0;i<life;i++)
  {
  fill(255);
  ellipse(c, 15, 10, 10);
  fill(0,255,0);
  ellipse((c+10), 15, 10, 10); 
  c=c+20;
  }
  //update ball and bar position
  ex=ex+dx;
  ey=ey+dy;b
  fill(255, 0, 0);
  ellipse(ex,ey,20,20);
  fill(0, 0, 255);
  rect(rx,(height-10), 50, 10);
  }
}
 
void mouseReleased()
{
   if(life==0){
    if(mouseX>331 && mouseX<630 && mouseY>340 && mouseY<420){
    play=!play;
    life=5;
    f=100; 
    }
    }
}
