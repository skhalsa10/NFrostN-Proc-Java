private NFrostN nFrostN;
//declare and initialize constants
final float scale = 1;
final int seed = 0;
//percentage of screen filled by particles
final int particleDense = 30;

void setup(){
  //set the default size
  size(500,500);
  nFrostN = new NFrostN(width,height,particleDense,seed, scale);
  background(0);
  fill(255);
  noStroke();


}

//loop  and draw new particle until specified density is met
void draw(){
  if(nFrostN.isParticleDensityMet()){
   noLoop();
  }
  background(0);
  nFrostN.renderGrid();
  nFrostN.diffuseParticle();
  noLoop();
}
