private NFrostN nFrostN;

float scale = 1;

void setup(){
  //set the default size
  size(500,500);
  nFrostN = new NFrostN((int)(width/scale),(int)(height/scale),30,0, scale);
  background(0);
  //background(133);
  fill(255);

  noStroke();
  
  
}

void draw(){
  if(nFrostN.isParticleDensityMet()){
   noLoop(); 
  }
  background(0);
  nFrostN.renderGrid();
  //nFrostN.diffuseStep();
  nFrostN.diffuseQuick();
  //noLoop();
}
