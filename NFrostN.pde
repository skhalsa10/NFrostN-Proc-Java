import java.io.IOException;
import java.util.Random;

public class NFrostN {

  private float scale;

  //declare member fields
  //holds width argument
  private int gridWidth;
  //holds height argument
  private int gridHeight;
  //holds density argument
  private int particleDensity;
  //holds seed argument
  private int seed;
  //holds value of the grid used only internally for algorithm
  private boolean[][] grid;
  //counter that holds filled amount
  private int filled = 0;
  //declare random
  private Random ran;
  //private int backColor = 0;
  //private int frostColor = #CEFDFF;
  private int frostColor = 255;

  //declare diffusion variables
  private int diffuseW;
  private int diffuseH;
  private boolean beginDiffuse = true;
  private int remainingSteps = 0;
  private int diffuseDir=0;




  public NFrostN(int gridWidth, int gridHeight, int particleDensity, int seed, float scale) {
    //initialize  everything!
    this.gridWidth = gridWidth;
    this.gridHeight = gridHeight;
    this.particleDensity = particleDensity;
    this.seed = seed;
    this.scale = scale;
    grid = new boolean[gridWidth][gridHeight];

    //init grid to false for empty
    for (int i = 0; i<this.gridWidth; i++) {
      for (int j = 0; j<this.gridHeight; j++) {
        grid[i][j] = false;
      }
    }

    //init random
    if (seed == 0) {
      ran = new Random();
    } else {
      ran = new Random(seed);
    }
  }

  public void diffuseQuick() {
    //check if this is the beginning of new diffusion
    if (beginDiffuse) {
      beginDiffuse = false;
      diffuseW = ran.nextInt(gridWidth);
      diffuseH = ran.nextInt(gridHeight);
      remainingSteps = (2*(gridWidth * gridHeight));
      //print(remainingSteps);
      //remainingSteps = 1000;
      //the random startw and starth needs to be empty
      while (!isEmpty(diffuseW, diffuseH)) {
        diffuseW = ran.nextInt(gridWidth);
        diffuseH = ran.nextInt(gridHeight);
      }
      //return;
    }

    while (remainingSteps > 0) {
      //check if the particle can stick
      if (checkNeighbors()) {
        beginDiffuse = true;
        grid[diffuseW][diffuseH] = true;
        filled++;
        fill(frostColor);
        circle(diffuseW*scale, diffuseH*scale, scale+5);
        return;
      }

      moveParticle();

      //uncomment the following to the see the path the particle diffuses the 
      //transparancy makes it darker in the locations visited more than once. it looks awfully familiar... almost like land.
      //could this be a way to procedurally generate some land?
      //if(keyPressed){
      //fill(frostColor,50);
      //circle(diffuseW*scale, diffuseH*scale, scale);
      //}
      remainingSteps--;

    }
    //if we reached here it has diffused until it ran out of energy
    beginDiffuse = true;
    grid[diffuseW][diffuseH] = true;
    filled++;
    fill(frostColor);
    circle(diffuseW*scale, diffuseH*scale, scale);
  }

  //this will step through the diffusion step
  public void diffuseVerbose() {
    //check if this is the beginning of new diffusion
    if (beginDiffuse) {
      beginDiffuse = false;
      diffuseW = ran.nextInt(gridWidth);
      diffuseH = ran.nextInt(gridHeight);
      remainingSteps = (2*(gridWidth * gridHeight));
      //print(remainingSteps);
      //remainingSteps = 1000;
      //the random startw and starth needs to be empty
      while (!isEmpty(diffuseW, diffuseH)) {
        diffuseW = ran.nextInt(gridWidth);
        diffuseH = ran.nextInt(gridHeight);
      }
      fill(frostColor);
      circle(diffuseW*scale, diffuseH*scale, scale);
      return;
    }

    if (remainingSteps > 0) {
      //check if the particle can stick
      if (checkNeighbors()) {
        beginDiffuse = true;
        grid[diffuseW][diffuseH] = true;
        fill(frostColor);
        circle(diffuseW*scale, diffuseH*scale, scale);
        return;
      }

      moveParticle();

      fill(frostColor);
      circle(diffuseW*scale, diffuseH*scale, scale);
      remainingSteps--;
      return;
    }
    //if we reached here it has diffused until it ran out of energy
    beginDiffuse = true;
    grid[diffuseW][diffuseH] = true;
    fill(frostColor);
    circle(diffuseW*scale, diffuseH*scale, scale);
  }

  private void moveParticle() {
    diffuseDir = ran.nextInt(4);
    if (diffuseDir == 0) {
      moveN();
    }
    if (diffuseDir == 1) {
      moveE();
    }
    if (diffuseDir == 2) {
      moveS();
    }
    if (diffuseDir == 3) {
      moveW();
    }
  }

  private void moveN() {
    if (diffuseH == 0) {
      diffuseH = (gridHeight - 1);
    } else {
      diffuseH--;
    }
  }

  private void moveS() {
    if (diffuseH == gridHeight - 1) {
      diffuseH = 0;
    } else {
      diffuseH++;
    }
  }

  private void moveE() {
    if (diffuseW == gridWidth - 1) {
      diffuseW = 0;
    } else {
      diffuseW++;
    }
  }

  private void moveW() {
    if (diffuseW == 0) {
      diffuseW = (gridWidth - 1);
    } else {
      diffuseW--;
    }
  }


  private boolean checkNeighbors() {
    if (checkNorth()) {
      return true;
    }
    if (checkEast()) {
      return true;
    }
    if (checkSouth()) {
      return true;
    }
    if (checkWest()) {
      return true;
    }
    /*if (checkNE()) {
      return true;
    }
    if (checkSE()) {
      return true;
    }
    if (checkNW()) {
      return true;
    }
    if (checkSW()) {
      return true;
    }*/

    return false;
  }

  private boolean checkNE() {
    //check corner case 1
    if (diffuseH == 0 && diffuseW == (gridWidth-1)) {
      return grid[0][(gridHeight-1)];
    }
    //now check corner case for only h =0
    if (diffuseH ==0) {
      return grid[diffuseW+1][gridHeight-1];
    }
    //last corner case for if we are on right edge
    if (diffuseW == (gridWidth-1)) {
      return grid[0][(diffuseH-1)];
    }

    return grid[(diffuseW+1)][(diffuseH-1)];
  }

  private boolean checkSE() {
    //check corner case 1
    if (diffuseH == gridHeight-1 && diffuseW == (gridWidth-1)) {
      return grid[0][0];
    }
    //now check corner case for only h =0
    if (diffuseH ==gridHeight-1) {
      return grid[diffuseW+1][0];
    }
    //last corner case for if we are on right edge
    if (diffuseW == (gridWidth-1)) {
      return grid[0][(diffuseH+1)];
    }

    return grid[(diffuseW+1)][(diffuseH+1)];
  }

  private boolean checkSW() {
    //check corner case 1
    if (diffuseH == gridHeight-1 && diffuseW == 0) {
      return grid[(gridWidth-1)][0];
    }
    //now check corner case for only h =0
    if (diffuseH ==gridHeight-1) {
      return grid[diffuseW-1][0];
    }
    //last corner case for if we are on right edge
    if (diffuseW == 0) {
      return grid[(gridWidth-1)][(diffuseH+1)];
    }

    return grid[(diffuseW-1)][(diffuseH+1)];
  }

  private boolean checkNW() {
    //check corner case 1
    if (diffuseH == 0 && diffuseW == 0) {
      return grid[(gridWidth-1)][gridHeight-1];
    }
    //now check corner case for only h
    if (diffuseH ==0) {
      return grid[diffuseW-1][gridHeight-1];
    }
    //last corner case for if we are on right edge
    if (diffuseW == 0) {
      return grid[(gridWidth-1)][(diffuseH-1)];
    }

    return grid[(diffuseW-1)][(diffuseH-1)];
  }

  /**
   * @return returns true if pixel up is on
   */
  private boolean checkNorth() {
    //if at the top wrap to bottom
    if (diffuseH == 0) {
      if (grid[diffuseW][(gridHeight-1)]) {
        return true;
      } else if (grid[diffuseW][(gridHeight-1)]==false) {
        return false;
      }
    }
    //else check pixel above
    if (grid[diffuseW][(diffuseH-1)]== true) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * @return returns true if pixel to the right is on
   */
  private boolean checkEast() {
    //if at the right edge wrap to left
    if (diffuseW == (gridWidth-1)) {
      if (grid[0][(diffuseH)]==true) {
        return true;
      } else if (grid[0][(diffuseH)]==false) {
        return false;
      }
    }
    //else check pixel right
    if (grid[(diffuseW+1)][(diffuseH)]== true) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * @return True if pixel to the left is on
   */
  private boolean checkWest() {
    //if at the left wrap to the right
    if (diffuseW == 0) {
      if (grid[gridWidth-1][(diffuseH)]==true) {
        return true;
      } else if (grid[gridWidth-1][(diffuseH)]==false) {
        return false;
      }
    }
    //else check pixel left
    if (grid[(diffuseW-1)][diffuseH]== true) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * @return Returns true if pixel south is on
   */
  private boolean checkSouth() {
    //if at the bottom wrap to top
    if (diffuseH == (gridHeight-1)) {
      if (grid[diffuseW][(0)]==true) {
        return true;
      } else if (grid[diffuseW][(0)]==false) {
        return false;
      }
    }
    //else check pixel below
    if (grid[diffuseW][(diffuseH+1)]== true) {
      return true;
    } else {
      return false;
    }
  }

  //returns true if the cell at w, h is empty
  private boolean isEmpty(int w, int h) {
    return !grid[w][h];
  }

  //this will return true if the particle density has been met.
  public boolean isParticleDensityMet() {
    return (100*((double)filled/(gridWidth*gridHeight))>= particleDensity);
  }

  public void renderGrid() {
    fill(frostColor);
    //blendMode(SCREEN);

    //int onCount = 0;
    for (int i = 0; i<gridWidth; i++) {
      for (int j = 0; j<gridHeight; j++) {
        if (grid[i][j] == true) {
          fill(frostColor);
          //circle(i*scale, j*scale, scale+1);
          square(i*scale, j*scale, scale);
          //onCount++;
        }
      }
    }
    //println(onCount);
  }
}
