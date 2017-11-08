import java.util.Collections;
import processing.sound.*;
//////////////STATEMNG1
Table data;
PFont fnt;
int frmCnt = 0; // current frame#
int maxFrm = 0;
boolean fin = false;
int interpFac = 30;
boolean interp = false;
float xScl = 1; // scale factor for x axis
float yScl = 3; // scale factor for y axis
float yMax = 100; // rescale if less than yMax pixels from top
float spd = 8; // spd of the curves
String fileNames[] = {"1.png", "2.png", "3.png", "4.png", "5.png", "6.png", "7.png", "8.png", "9.png", "10.png"};
int col[] = {199, 58, 236, 289, 359, 248, 41, 333, 137, 0}; //ColorAlg
int brg[] = {255,255,255,255,255,255,255,255,255,0};
int row = -1;
float x0 = 1100;
float y0 = 630;
ArrayList<ArrayList<PVector>> curves = new ArrayList<ArrayList<PVector>>();
blockCoordinator blocks = new blockCoordinator();
coordSys coordSys;
FSM game;
SoundFile file;
State attractMode = new State(this, "enterAttract", "doAttract", "exitAttract");
State playMode = new State(this, "enterPlay", "doPlay", "exitPlay");
//////////////ENDSTATE1

//////////////////////////////STATEMNG2

float [] mathos = {
 1.2, 14.27, 23.56, 25.93, 24.71,
};
 
int w = 200; // bar width
int posBar = 1;
 
int bar1 = -1;
int bar2 = -1;
//////////////ENDSTATE1

void setup(){

  file = new SoundFile(this, "sample.mp3");
  file.play();
  game = new FSM(attractMode);
  size(1280,720,P3D);
  colorMode(HSB);
  
  fnt = loadFont("ArialMT-32.vlw");
  textFont(fnt);
  
  frameRate(60);
  data = loadTable("TurnIN.csv","header");
  
  for(int i = 0; i<data.getColumnCount()-1;i++){
    curves.add(new ArrayList<PVector>());
    blocks.add(new infoBlock(loadImage(fileNames[i])));
  }
  
  coordSys = new coordSys();
  
}

void draw(){
  game.update();
}
void enterAttract() {
  println("enter attract");
}

void doAttract() {
  if(frmCnt==0) delay(200);
  background(255);
 
  
  textSize(20);
  text("Per YEAR By Incident Type Total Rate",5,30);
  textSize(14);
  text("Index offense rate(IR), Violent Crime rate(VC), Murder and nonnegligent manslaughter rate(M), Forcible rape rate(FR), Robbery rate(R), Aggravated assault rate(AS)", 5, height-35);
  text("Property crime rate(P), Burglary rate(B), Larceny-theft rate(L), Motor vehicle theft rate(GTA)", 5, height -10);
  
  // only read a new data point every interpFac frames, else interpolate
  if(frmCnt%interpFac==0){
    row++;
    interp = false;
  } else {
    interp = true;  
  }
  
  // if there is data left...
  if(row<data.getRowCount()){
    
    // generate new data point for each curve
    for(int i = 0; i<data.getColumnCount()-1;i++){
      float valX = spd*frmCnt;
      float valY = 0;
      
      // choose between interpolated data point or table data point
      if(interp && row<data.getRowCount()-1){
        valY = data.getFloat(row,i+1)+(frmCnt%interpFac)*(data.getFloat(row+1,i+1)-data.getFloat(row,i+1))/interpFac;
      } else {
        valY = data.getFloat(row,i+1);
      }
      
      // add new data point
      curves.get(i).add(new PVector(valX,-valY,0));
      
      // update the info block
      blocks.get(i).update(x0, -valY*yScl+y0, String.format("%.2f",valY));
      
      // rescale if out of screen
      if(valY*yScl>(y0-yMax)){
         yScl = yScl*0.995; //0.997 for interp 30
      }//AGAIN SCALE IT WOW WTF
      if(valX*xScl>(x0+3)){
         xScl = xScl*0.999; 
      }
    }
    
    // plot curves
    noFill();
    strokeWeight(2);
    int nr = 0;
    for(ArrayList<PVector> curve : curves){
      beginShape();
      for(PVector v : curve){
        stroke(col[nr]*255/360,255,brg[nr]);
        vertex(xScl*(v.x-spd*frmCnt)+x0,yScl*v.y+y0,v.z);
      }
      endShape();
      nr++;
    }
    
    // plot the year
    fill(0);
    textSize(32);
    text(data.getString(row,0), width-100, height-20);
    
  } else if(fin){
    // plot final result
    noFill();
    strokeWeight(2);
    int nr = 0;
    for(ArrayList<PVector> curve : curves){
      beginShape();
      for(PVector v : curve){
        stroke(col[nr]*255/360,255,brg[nr]);
        vertex(xScl*(v.x-spd*maxFrm)+x0,yScl*v.y+y0,v.z);
      }
      endShape();
      nr++;
    }
  } else {
    fin = true;
    maxFrm = frmCnt -1 ; 
  }
  
  blocks.update();
  
  coordSys.update();
  
  frmCnt++;
}


void exitAttract() {
  println("exit Attract");
}

void enterPlay() {
  println("enter play");

}

void doPlay() {
println("play me");
smooth();
   background(255); // Reset the whole scene (including the diff) on each frame
  barr(); // And redraw it
  compareBars(); // Show the diff, if there is something to compare
    text("Crime Calculator Right Click To Calculate Hover to get info!",TOP,30);
 //   text("Crime Calculator Right Click To Calculate!",TOP,30);
}

void exitPlay() {
  println("exit play");
}

void barr() {
 
  int XBarr = 50; //local and reseted on each call
  color f=0;
 
  for (int j=0; j < mathos.length; j++) {
 
    XBarr = XBarr + w + posBar;
    noStroke();
    float YBarr = 300 - mathos[j];
 
    if (hoverBarr(XBarr, YBarr, mathos[j])) {
      f=200;
      text("Sum of Total PRECENTAGES BY DECADE divided by 100000 = " + mathos[j],height/2,width/2);
      if (mathos[j]==mathos[0])
      text("Starting at 1960", 1000,700);
      if (mathos[j]==mathos[1])
      text("From 1961-1970", 1000,700);
      if (mathos[j]==mathos[2])
      text("From 1971-1980", 1000,700);
       if (mathos[j]==mathos[3])
      text("From 1981-1990", 1000,700);
       if (mathos[j]==mathos[4])
      text("From 1991-2000", 1000,700);
    }
    else {
      if (j == bar1 || j == bar2) {
        f =100 ;
      } else {
        f = 0;
      }
    }
    fill(f);
    rect(XBarr, YBarr, w, mathos[j]);
    
  }
}
boolean hoverBarr(float x, float y, float h) {
  return mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h;
}
void mousePressed() {
  if (mouseButton == LEFT){
  if (game.isInState(attractMode)) {
    game.transitionTo(playMode);
  } 
  else if(game.isInState(playMode)) {
    game.transitionTo(attractMode);
  }
  }
    if (mouseButton == RIGHT){
  if (bar1 != -1 && bar2 != -1) {
    bar1 = bar2 = -1;
  }
  
  float XBarr = 50;
  for (int j=0; j < mathos.length; j++) {
 
    XBarr = XBarr + w + posBar;
    float YBarr = 300 - mathos[j];
 
    if (hoverBarr(XBarr, YBarr, mathos[j])) {
      if (bar1 == -1) bar1 = j;
      else if (bar2 == -1) bar2 = j;
    }
  }
}
}
void compareBars() {
 
  if (bar2 == -1)
    return; // Don't compare yet, we don't have two bars selected
    
  float dif;
  dif = mathos[bar1] - mathos[bar2];
 
  textSize(20);
  fill(0);
  text("Change Between Decades " +dif, 500, 100);
}