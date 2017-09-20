FSM game;
import http.requests.*;
JSONObject json;
JSONObject j1;
JSONObject j2;

//JSONObject gini_usa;
//JSONObject gini_rus;
//JSONObject gini_col;

PImage bg;
PImage bg2;
PImage bg3;

int id;
int id2;
int id3;
int gini_col;
int gini_rus;
int gini_usa;



State attractMode = new State(this, "enterAttract", "doAttract", "exitAttract");
State usaMode = new State(this, "enterUsa", "doUsa", "exitUsa");
State playMode = new State(this, "enterPlay", "doPlay", "exitPlay");

void setup() {
  bg = loadImage("rf.jpg");
  bg.resize(width,height);
  bg2 = loadImage("af.jpg");
  bg2.resize(width,height);
  bg3 = loadImage("cf.jpg");
  bg3.resize(width,height);
  game = new FSM(attractMode);
  game = new FSM(usaMode);
  size(900,500);
  surface.setResizable(true);//Resize Key
  // Population API
  j1 = loadJSONObject("https://restcountries.eu/rest/v2/alpha/us");
  gini_usa = j1.getInt("gini");
  j2 = loadJSONObject("https://restcountries.eu/rest/v2/alpha/ru");
  gini_rus = j2.getInt("gini");
  json = loadJSONObject("https://restcountries.eu/rest/v2/alpha/col");
  id = json.getInt("population");
  gini_col = json.getInt("gini");
  println("Gini Rate: " + gini_col);
  println("Reponse Content Columbia: " + json);
  //id = json.getInt("population");
  println(id);
    id2 = j1.getInt("population");
  println("Reponse Content USA: " + j1);
  //id = json.getInt("population");
  println(id2);
    id3 = j2.getInt("population");
  println("Reponse Content Russia: " + j2);
  //id = json.getInt("population");
  println(id3);
  

  
  
}

void draw() {
  game.update();
  bg.resize(width,height);
  bg2.resize(width,height);
  bg3.resize(width,height);
}

void enterAttract() {
  println("enter attract");
 bg3.resize(width,height);
}

void doAttract() {
  background(bg3);
  textSize(40);
text("Col", width/2, height);
text("GINI", width/2,height/2);
text("Pop: " + id, width/2, height - 30);
//text(id, 50, 150);
  for (int x = 20; x < width; x += 20) {
    float mx = mouseX / (gini_col);
    float offsetA = random(-mx, mx);
    float offsetB = random(-mx, mx);
    stroke(138,43,226);
    line(x + offsetA, 20, x - offsetB, 100);

    
  }
    

}

void exitAttract() {
  println("exit Attract");
}
void enterUsa() {
  println("enter USA");
  bg2.resize(width,height);

}

void doUsa() {
background(bg2);

  textSize(40);
text("USA", width/2,height);
text("GINI", width/2,height/2);
text("Pop:" + id2, width/2, height - 30);
  for (int x = 20; x < width; x += 20) {
    float mx = mouseX / (gini_usa);
    float offsetA = random(-mx, mx);
    float offsetB = random(-mx, mx);
    stroke(0,255,0);
    line(x + offsetA, 20, x - offsetB, 100);}

 
}

void exitUsa() {
  println("exit USA");
}

void enterPlay() {
  println("enter play");
  bg.resize(width,height);
}

void doPlay() {
  background(bg);
  textSize(40);
  text("Rus", width/2,height);
text("GINI", width/2,height/2);
text("Pop: " + id3, width/2, height - 30);
  for (int x = 20; x < width; x += 20) {
    float mx = mouseX / (gini_rus);
    float offsetA = random(-mx, mx);
    float offsetB = random(-mx, mx);
    stroke(255,0,0);
    line(x + offsetA, 20, x - offsetB, 100);}

}

void exitPlay() {
  println("exit play");
}

void mousePressed() {
  if (game.isInState(attractMode)) {
    game.transitionTo(playMode);
  } 
  else if(game.isInState(playMode)) {
    game.transitionTo(usaMode);
  }
  else if(game.isInState(usaMode)) {
    game.transitionTo(attractMode);
  }
}