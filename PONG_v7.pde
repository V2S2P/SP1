float ballX = 0;
float ballY = 0;
float xspeed = 4;
float yspeed = 2.3;
int paddleX = 400;
int paddleY = mouseY;
int paddleWidth = 20;
int paddleHeight = 60;
int t;
int wallHitCounter = 0;
int wallHitsRecord;
ArrayList<Integer> wallHitCounterList = new ArrayList<Integer>();

void setup() {
  loadWallHitsRecord();
  size(500, 500);
  
}

void loadWallHitsRecord(){
  String[] lines = loadStrings("wallHitsRecord.txt");
  if (lines.length > 0){
    wallHitsRecord = Integer.parseInt(lines[0]);
   println("Loaded wall hits record: " + wallHitsRecord);
  } else {
    println("Error: Unable to load wall hits record. File is empty.");
  }
}

boolean saveWallHitsRecord() {
  String[] lines = { str(wallHitsRecord) };
  try {
    saveStrings("wallHitsRecord.txt", lines);
    println("Wall hits record saved successfully: " + wallHitsRecord);
    return true;  // Indicate success
  } catch (Exception e) {
    println("Error: Unable to save wall hits record: " + e.getMessage());
    return false;  // Indicate failure
  }
}

void draw() {
  background(0);
  arena();
  ball();
  player();
  limits();
  counter();
  updateWallHitsRecord();
  
  if (ballX > width){
    saveWallHits();
    saveWallHitsRecord();
    exit();
  }
}

void updateWallHitsRecord(){
  wallHitsRecord = 0;
  for(int i = 0; i < wallHitCounterList.size(); i++){
    int value = wallHitCounterList.get(i);
    if (value > wallHitsRecord){
      wallHitsRecord = value;
    }
  }
}

void saveWallHits(){
  wallHitCounterList.add(wallHitCounter);
  println("Wall hits: " + wallHitCounter);
}

void counter() {
  textSize(20);
  fill(255);
  text("Wall Hits: " + wallHitCounter, 10, 30);
  text("Wall Hits Record: " + wallHitsRecord, 330, 30);
}

void arena() {
  stroke(0, 255, 0);
  fill(0);
  rect(0, 0, 499, 499);

  if (wallHitCounter >= 10) {
    fill(255, 0, 0);
    rect(0, 0, 499, 499);
  }
  if (wallHitCounter >= 15) {
    fill(0, 255, 0);
    rect(0, 0, 499, 499);
  }
  if (wallHitCounter >= 20) {
    fill(0, 0, 255);
    rect(0, 0, 499, 499);
  }
}

void ball() {
  stroke(0);
  fill(127);

  // Move the ball in smaller steps
  float step = 1.0;
  for (float t = 0; t < 1.0; t += step) {
    float nextX = ballX + xspeed * step;
    float nextY = ballY + yspeed * step;

    // Check for collision with paddle, the +16 and -16 values represent half the width and height of the ball. Basically makes it so
    // there's a buffer to help ensure that the collision is detected before the ball actually reaches the paddle's edges, for clarity sake.
    if (nextX + 16 >= paddleX && nextX - 16 <= paddleX + paddleWidth && nextY + 16 >= mouseY && nextY - 16 <= mouseY + paddleHeight) {
      xspeed = -xspeed; // Reverse the horizontal direction
      break; // Exit the loop if collision detected
    }

    // Update ball position
    ballX = nextX;
    ballY = nextY;
  }

  // Draw the ball
  ellipse(ballX, ballY, 32, 32);

  // Update ball position for the remaining fraction of time
  ballX += xspeed * (1.0 - t);
  ballY += yspeed * (1.0 - t);
}

void player() {
  fill(255);
  rect(paddleX, mouseY, paddleWidth, paddleHeight);
}

void limits() {
  // Check for arena boundaries
  if (ballX < 0) {
    xspeed = -xspeed; // Reverse the horizontal direction
    wallHitCounter++; //plus 1 to wall count
    wallHitCounterList.add(wallHitCounter);
    println(wallHitCounter);
  }
  // Game over
  if (ballX > width) {
    //exit();
  }//
  if (ballY > height || ballY < 0) {
    yspeed = -yspeed; // Reverse the vertical direction
  }
  // Check collision with paddle
  if (ballX + 16 >= paddleX && ballX - 16 <= paddleX + paddleWidth && ballY + 16 >= mouseY && ballY - 16 <= mouseY + paddleHeight) {
    xspeed = -xspeed; // Reverse the horizontal direction
  }
  /*
  for (int i = 0; i < wallHitCounterList.size(); i++) {
  int value = wallHitCounterList.get(i);
  println("Value at index " + i + ": " + value);
  }
  */
}
