import java.io.IOException;
import java.util.Random;

public class NFrostN {
  //declare variables
  private float scale;
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
  private int frostColor = 255;

  //declare diffusion variables
  private int diffuseW;
  private int diffuseH;
  private boolean beginDiffuse = true;
  private int remainingSteps = 0;
  private int diffuseDir=0;



/**
this is the constructor it takes a width and height for grid. the density of particles to the full grid before the algorithm stops
a seed for the random number generator 0 picks random seed. the scale is how big the particle is drawn.
**/
  public NFrostN(int gridWidth, int gridHeight, int particleDensity, int seed, float scale) {
    //initialize  everything!
    this.gridWidth = (int)(gridWidth/scale);
    this.gridHeight = (int)(gridHeight/scale);
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

  //this will fully diffuse a new particle until it runs out
  //of steps or finds another particle to stick to
  public void diffuseParticle() {
    //check if this is the beginning of new diffusion
    if (beginDiffuse) {
      beginDiffuse = false;
      diffuseW = ran.nextInt(gridWidth);
      diffuseH = ran.nextInt(gridHeight);
      remainingSteps = (2*(gridWidth * gridHeight));
      //the random startw and starth needs to be empty
      while (!isEmpty(diffuseW, diffuseH)) {
        diffuseW = ran.nextInt(gridWidth);
        diffuseH = ran.nextInt(gridHeight);
      }
    }

    while (remainingSteps > 0) {
      //check if the particle can stick
      if (checkNeighbors()) {
        beginDiffuse = true;
        grid[diffuseW][diffuseH] = true;
        filled++;
        //drawing this circle makes a sparkling affect when the particle sticks
        fill(frostColor);
        circle(diffuseW*scale, diffuseH*scale, scale+5);
        return;
      }

      moveParticle();

      //uncomment the following to the see the path the particle diffuses the
      //transparancy makes it darker in the locations visited more than once. it looks awfully familiar... almost like land.
      //could this be a way to procedurally generate some land?
      //if(keyPressed){
      fill(frostColor,50);
      circle(diffuseW*scale, diffuseH*scale, scale);
      //}
      remainingSteps--;

    }
    //if we reached here it has diffused until it ran out of energy
    beginDiffuse = true;
    grid[diffuseW][diffuseH] = true;
    filled++;
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

//this will check if a neighbor north west south or east are turned on.
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
    return false;
  }


  /**
   * @return returns true if pixel up is on
   */
  private boolean checkNorth() {
    //if at the top wrap to bottom
    if (diffuseH == 0) {
      return grid[diffuseW][(gridHeight-1)];
    }
    //else check pixel above
    return grid[diffuseW][(diffuseH-1)];
  }

  /**
   * @return returns true if pixel to the right is on
   */
  private boolean checkEast() {
    //if at the right edge wrap to left
    if (diffuseW == (gridWidth-1)) {
      return grid[0][(diffuseH)];
    }
    //else check pixel right
    return grid[(diffuseW+1)][(diffuseH)];
  }

  /**
   * @return True if pixel to the left is on
   */
  private boolean checkWest() {
    //if at the left wrap to the right
    if (diffuseW == 0) {
      return grid[gridWidth-1][(diffuseH)];
    }
    //else check pixel left
    return grid[(diffuseW-1)][diffuseH];
  }

  /**
   * @return Returns true if pixel south is on
   */
  private boolean checkSouth() {
    //if at the bottom wrap to top
    if (diffuseH == (gridHeight-1)) {
      return grid[diffuseW][(0)];
    }
    //else check pixel below
    return grid[diffuseW][(diffuseH+1)];
  }

  //returns true if the cell at w, h is empty
  private boolean isEmpty(int w, int h) {
    return !grid[w][h];
  }

  //this will return true if the particle density has been met.
  public boolean isParticleDensityMet() {
    return (100*((double)filled/(gridWidth*gridHeight))>= particleDensity);
  }

  //This will iterate through the 2d array and draw each element that is on
  public void renderGrid() {
    fill(frostColor);
    for (int i = 0; i<gridWidth; i++) {
      for (int j = 0; j<gridHeight; j++) {
        if (grid[i][j] == true) {
          square(i*scale, j*scale, scale);
        }
      }
    }
  }
}
