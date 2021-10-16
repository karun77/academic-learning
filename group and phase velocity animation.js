

/*created for p5.js*/

/* use the slider on the left to change group velocity*/
/* use the slider on the right to change phase velocity*/

var time = 0;
var strum = 1;
var x,y,y1,y2,angle,angle1;
//ampC is the amplitude of the envelope
//wC and wM are the wave numbers of envelope and the actual information signal
var ampC = 100, wC = 0.02, wM = 0.3;
//these are not the actual group and phase velocity
// that would be given by groupVel/wC and phaseVel/wM
var groupVel = -0.1, phaseVel = 5;
var getApoint = true;
var cPointX = [];
var cPointY = [];
//moneyX is the x coordinate of the marker indicating phase velocity
var moneyX = 633.5545185;
var i,j;
var maxCpoints = 7;
var canvasLen = 930;
var slider1, slider2;


function setup() { 
  createCanvas(canvasLen, 500);
  for(var i=0; i < maxCpoints; i++) {
    cPointX[i]  = ((i+1)*PI)/wC;
    cPointY[i] = 200;
  }
  slider1 = createSlider(-1,1,0,0.1);
  slider2 = createSlider(-5,5,0,0.5);
} 

function draw() { 
  background(220);
  
  groupVel = slider1.value();
  phaseVel = slider2.value();
  
  //here we draw the sine wave
  stroke(4);
  beginShape();
  noFill();
  for(x = 0; x < width; x++){
  
    angle = groupVel*time + x * wC;
    angle1 = phaseVel*time + x * wM;

    
    y = map(sin(angle), -strum, strum, -ampC, ampC);
    y2 = 200 - y*sin(angle1);
    vertex(x, y2);
  }
  endShape(); 
  
  //here we'll draw the marker points
  
  //the marker points indicating group velocity
  
  for(i = 0; i<maxCpoints;i++) {
   // cPointX[i] += -(groupVel/wC)*time;
    fill(0,128,0);
    ellipse(cPointX[i] - (groupVel/wC)*time,cPointY[i],10);
  }
  
  //drawing the marker point indicating phase velocity
  
  if(phaseVel > 0) {
      if(moneyX - (phaseVel/wM)*time < 0) {
       moneyX += 942.4777961;
      }
  } else {
      if(moneyX - (phaseVel/wM)*time > canvasLen) {
       moneyX -= 942.4777961;
      }  
  }

  //here we calculate the position of the marker point indicating phase velocity
  angle = groupVel*time + (moneyX - (phaseVel/wM)*time)*wC;
  angle1 = phaseVel*time + (moneyX - (phaseVel/wM)*time)*wM;

  y = map(sin(angle), -strum, strum, -ampC, ampC);
  y2 = 200 - y*sin(angle1);
  
  fill(0,255,255);
  rect(moneyX - (phaseVel/wM)*time,y2,10);
  
  // here we'll check if we need an extra marker point and do what's necessary
  if(groupVel > 0) {
    if((cPointX[maxCpoints-1] - (groupVel/wC)*time) < (canvasLen - ((0.8)*PI/wC))) {
      addCmarkerPoint();
    }
  } 
  if(groupVel < 0) {
        if((cPointX[0] - (groupVel/wC)*time) > ((0.8)*PI/wC)) {
      addCmarkerPoint();
    }
  }
 
  
  //display the group velocity and phase velocity
  textSize(32);
  fill(0, 102, 153, 51);
  text("Group velocity: " + round(groupVel/wC,2), 200,400);
  text("Phase velocity: " + round(phaseVel/wM,2), 600,400);
  //modx -= (phaseVel/wM)*time;
  time += 0.1;
}

//just add the extra marker point to account for the one
// marker point which is about to go of the screen

function addCmarkerPoint() {
  if(groupVel > 0) {
    cPointX[maxCpoints] = cPointX[maxCpoints-1] + (PI/wC);
    cPointY[maxCpoints] = 200; 
    for(j = 0;j < maxCpoints; j++) {
      cPointX[j] = cPointX[j+1];
    }
  } else {
    cPointX[maxCpoints] = cPointX[0] - (PI/wC);
    cPointY[maxCpoints] = 200;
    for(j = maxCpoints;j > 1; j--) {
      cPointX[j-1] = cPointX[j-2];
    }
    cPointX[0] = cPointX[maxCpoints];
  }
}