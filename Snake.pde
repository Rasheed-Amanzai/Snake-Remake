// Snake
// By: Rasheed Amanzai

import java.util.Scanner;
import java.io.*;
import java.util.Arrays;

PrintWriter pw1, pw2, pw3;
File scoreboardN = new File("normalScoreboard.txt"); // File for the normal difficulty scoreboard
File scoreboardF = new File("fastScoreboard.txt"); // File for the fast difficulty scoreboard
File scoreboardE = new File("extremeScoreboard.txt"); // File for the extreme difficulty scoreboard

int[] snakeX = new int[2500]; // Holds the x coordinate for the snake
int[] snakeY = new int[2500]; // Holds the y coordinate for the snake
int appleX = (round(random(48)) + 1) * 10; // Random number for the x-axis of the apple
int appleY = (round(random(48)) + 1) * 10; // Random number for the y-axis of the apple
int snakeSize = 5;
int turnAngle, gameState, normalScore, fastScore, extremeScore = 0;
boolean relocateApple, runGame = true;
color red = color (211, 9, 2);
color orange = color (252, 145, 3);
color yellow = color (255, 215, 0);
color green = color (0, 234, 63);
color blue = color (2, 224, 242);
color purple = color (189, 2, 219);
color snakeColor = green;
int speed = 12;
int x = 240;

void setup() {
  size(500, 500);
  background(30);
  snakeX[0] = width / 2; // This will make the snake start at the middle of the screen when you start the game
  snakeY[0] = height / 2;
  textAlign(CENTER);
}

void draw()  {
  frameRate(speed); // This is what is used to change the speed of the snake
  
  // The game state is used to switch betweens the different parts of the game and lets you exit the game as well
  // These different parts include: The main menu, game, scoreboard and the options
  switch (gameState) {
    case 0: // Main Menu
      mainMenu(); // Method used for the main menu that includes all of the visuals for it
      break;
    case 1: // Game
      if (runGame) { // The game will run if runGame = true, and it will stop when runGame = false
        stroke(30);
        fill(255, 70, 70);
        rect(appleX, appleY, 10, 10);
        
        movement(); // Method for the movement of the snake
        apple(); // This method checks to see if the snake eats the apple, and it also places the apple in a random location on the screen
        snake(); // Method for displaying the snake
        snakeDead(); // Checks to see if the snake is dead or not
      }
      break;
    case 2: // Scoreboard
      scoreboardDisplay(); // Method for display all 3 scoreboards
      break;
    case 3: // Options
      stroke(30);
      fill(snakeColor);
      rect(x, 185, 10, 10); // These rectangles are used to display the snake that's in the options section
      fill(30);
      rect(x - 50, 185, 10, 10);
      x += 10; // Makes the snake go forward by 10
      options();
      
      if (x > 550) { // If the snake goes off the screen, this will make it come out from the other side
        x = 0;
      }
      break;
  }
}

// Controls
void keyPressed() {
  if (key == CODED) {
    
    if ((keyCode == UP) && (turnAngle != 270) && (snakeY[0]-10 != snakeY[1])) { // Makes the snake go up
      turnAngle = 90;
    }
    if ((keyCode == DOWN) && (turnAngle != 90) && (snakeY[0]+10 != snakeY[1])) { // Makes the snake go down
      turnAngle = 270;
    }
    if ((keyCode == LEFT) && (turnAngle != 0) && (snakeX[0]-10 != snakeX[1])) { // Makes the snake go left
      turnAngle = 180;
    }
    if ((keyCode == RIGHT) && (turnAngle != 180) && (snakeX[0]+10 != snakeX[1])) { // Makes the snake go right
      turnAngle = 0;
    }
    if (keyCode == CONTROL) { // Restarts the game
      restart();
    }
    if (keyCode == SHIFT) { // Returns user back to the main menu
      clear();
      restart(); // Method for reseting all variables that need to be reset in order to restart the game
      background(30);
      gameState = 0;
    }
  }
}

// This method is for when you click on the buttons
void mouseClicked() {
  switch(gameState) {
    case 0: // Main Menu
      if (mouseX >= 200 && mouseX <= 300 && mouseY >= 130 && mouseY <= 190) { // Play Button
        clear();
        background(30);
        gameState = 1;
      }
      if (mouseX >= 150 && mouseX <= 350 && mouseY >= 200 && mouseY <= 260) { // Scoreboard Button
        clear();
        background(30);
        gameState = 2;
      }
      if (mouseX >= 180 && mouseX <= 320 && mouseY >= 270 && mouseY <= 330) { // Options Button
        clear();
        background(30);
        gameState = 3;
      }
      if (mouseX >= 200 && mouseX <= 300 && mouseY >= 340 && mouseY <= 400) { // Exit Button
        exit();
      }
      break;
    case 2: // Scoreboard
      if (mouseX >= 8 && mouseX <= 33 && mouseY >= 10 && mouseY <= 35) { // Back Button
        clear();
        background(30);
        gameState = 0;
      }
      break;
    case 3: // Options
      if (mouseX >= 8 && mouseX <= 33 && mouseY >= 10 && mouseY <= 35) { // Back Button
        clear();
        background(30);
        x = 240;
        gameState = 0;
      }
      if (mouseX >= 60 && mouseX <= 180 && mouseY >= 85 && mouseY <= 135) { // Normal
        speed = 12;
      }
      if (mouseX >= 200 && mouseX <= 300 && mouseY >= 85 && mouseY <= 135) { // Fast
        speed = 20;
      }
      if (mouseX >= 320 && mouseX <= 440 && mouseY >= 85 && mouseY <= 135) { // Extreme
        speed = 30;
      }
      if (mouseX >= 90 && mouseX <= 170 && mouseY >= 280 && mouseY <= 360) { // Red
        snakeColor = red;
      }
      if (mouseX >= 210 && mouseX <= 280 && mouseY >= 280 && mouseY <= 360) { // Orange
        snakeColor = orange;
      }
      if (mouseX >= 330 && mouseX <= 410 && mouseY >= 280 && mouseY <= 360) { // Yellow
        snakeColor = yellow;
      }
      if (mouseX >= 90 && mouseX <= 170 && mouseY >= 380 && mouseY <= 460) { // Green
        snakeColor = green;
      }
      if (mouseX >= 210 && mouseX <= 280 && mouseY >= 380 && mouseY <= 460) { // Blue
        snakeColor = blue;
      }
      if (mouseX >= 330 && mouseX <= 410 && mouseY >= 380 && mouseY <= 460) { // Purple
        snakeColor = purple;
      }
      break;
  }
}

void mainMenu() {
  stroke(30);
  
  textSize(65);
  fill(255);
  text("SNAKE", 250, 100); // Title
  
  fill(255);
  rect(200, 130, 100, 60);
  fill(30);
  rect(205, 135, 90, 50); // Play button
  textSize(25);
  fill(255);
  text("PLAY", 250, 170);
  
  fill(255);
  rect(150, 200, 200, 60);
  fill(30);
  rect(155, 205, 190, 50); // Scoreboard button
  fill(255);
  text("SCOREBOARD", 250, 240);
  
  fill(255);
  rect(180, 270, 140, 60);
  fill(30);
  rect(185, 275, 130, 50); // Options button
  fill(255);
  text("OPTIONS", 250, 310);
  
  fill(255);
  rect(200, 340, 100, 60);
  fill(30);
  rect(205, 345, 90, 50); // Exit button
  fill(255);
  text("EXIT", 250, 380);
}

// Method used to get data that would be put into the files of each scoreboard
void scoreboardData() {
  try {
    Scanner fileIn1 = new Scanner(scoreboardN);
    Scanner fileIn2 = new Scanner(scoreboardF);
    Scanner fileIn3 = new Scanner(scoreboardE);
    int[] temp1 = new int[11];
    int[] temp2 = new int[11];
    int[] temp3 = new int[11];
    int counter = 0;
      
    while (fileIn1.hasNext()) { // Puts all 10 numbers from each file into a array
      temp1[counter] = fileIn1.nextInt();
      temp2[counter] = fileIn2.nextInt();
      temp3[counter] = fileIn3.nextInt();
      counter++;
    }
    
    // The score is added as the 11th element of the array and is then sorted in order to determine if that score is in the top 10
    temp1[10] = normalScore;
    temp2[10] = fastScore;
    temp3[10] = extremeScore;
    Arrays.sort(temp1);
    Arrays.sort(temp2);
    Arrays.sort(temp3);
    
    pw1 = new PrintWriter(scoreboardN); pw2 = new PrintWriter(scoreboardF); pw3 = new PrintWriter(scoreboardE);
    
    // This loop will write the numbers back into the files, from highest to lowest (since Arrays.sort sorts the array from lowest to highest)
    for (int i = 10; i > 0; i--) {
      pw1.println(temp1[i]);
      pw2.println(temp2[i]);
      pw3.println(temp3[i]);
    }
    
    pw1.flush(); pw2.flush(); pw3.flush();
    pw1.close(); pw2.close(); pw3.close();
    fileIn1.close(); fileIn2.close(); fileIn3.close();
  } catch (FileNotFoundException e) { // Exception is inculded incase the file is not found
    e.printStackTrace();
  }
}

// Method for displaying all 3 scoreboards
void scoreboardDisplay() {
  stroke(30);
  
  textSize(25);
  fill(255);
  text("<", 20, 30); // The "<" is the back button
  text("TOP 10 HIGHSCORES", 250,60);
  
  
  fill(255);
  rect(105, 90, 290, 320);
  
  fill(30);
  rect(110, 95, 90, 310);
  fill(30);
  rect(205, 95, 90, 310);
  fill(30);
  rect(300, 95, 90, 310);
  
  stroke(255);
  fill(255);
  rect(106, 135, 288, 4);
  
  textSize(18);
  fill(255);
  text("Normal", 155, 120);
  text("Fast", 250, 120);
  text("Extreme", 345, 120);
  
  try {
    // Output the highscores
    Scanner fileIn1 = new Scanner(scoreboardN);
    Scanner fileIn2 = new Scanner(scoreboardF);
    Scanner fileIn3 = new Scanner(scoreboardE);
    int spacing = 165;
    textSize(18);
    while (fileIn1.hasNext()) {
      text(fileIn1.next(), 155, spacing);
      text(fileIn2.next(), 250, spacing);
      text(fileIn3.next(), 345, spacing);
      spacing+=25; // Spacing between entries
    }
    
    fileIn1.close(); fileIn2.close(); fileIn3.close();
  } catch (FileNotFoundException e) {
    e.printStackTrace();
  }
}

void options() {
  stroke(30);
  
  textSize(25);
  fill(255);
  text("<", 20, 30);
  
  textSize(33);
  fill(255);
  text("GAME SPEED", 250, 60);
  
  fill(255);
  rect(60, 85, 120, 50);
  fill(30);
  rect(65, 90, 110, 40); // Button for normal speed
  textSize(25);
  fill(255);
  text("Normal", 120, 120);
  
  fill(255);
  rect(200, 85, 100, 50);
  fill(30);
  rect(205, 90, 90, 40); // Button for fast speed
  textSize(25);
  fill(255);
  text("Fast", 250, 120);
  
  fill(255);
  rect(320, 85, 120, 50);
  fill(30);
  rect(325, 90, 110, 40); // Button for extreme speed
  textSize(25);
  fill(255);
  text("Extreme", 380, 120);
  
  textSize(33);
  fill(255);
  text("SNAKE COLOUR", 250, 260);
  
  // RED
  fill(255);
  rect(90, 280, 80, 80);
  stroke(red);
  fill(red);
  rect(95, 285, 70, 70);
  
  // ORANGE
  stroke(30);
  fill(255);
  rect(210, 280, 80, 80);
  stroke(orange);
  fill(orange);
  rect(215, 285, 70, 70);
  
  // YELLOW
  stroke(30);
  fill(255);
  rect(330, 280, 80, 80);
  stroke(yellow);
  fill(yellow);
  rect(335, 285, 70, 70);
  
  // GREEN
  stroke(30);
  fill(255);
  rect(90, 380, 80, 80);
  stroke(green);
  fill(green);
  rect(95, 385, 70, 70);
  
  // BLUE
  stroke(30);
  fill(255);
  rect(210, 380, 80, 80);
  stroke(blue);
  fill(blue);
  rect(215, 385, 70, 70);
  
  // PURPLE
  stroke(30);
  fill(255);
  rect(330, 380, 80, 80);
  stroke(purple);
  fill(purple);
  rect(335, 385, 70, 70);
}

// Movement of the snake
void movement() {
  for (int i = snakeSize; i >= 0; i--) {
    if (i != 0) {
      snakeX[i] = snakeX[i-1];
      snakeY[i] = snakeY[i-1];
    }
    else {
      if (turnAngle == 0) { // RIGHT
        snakeX[0] += 10;  
      }
      else if (turnAngle == 90) { // UP
        snakeY[0] -= 10;
      }
      else if (turnAngle == 180) { // LEFT
        snakeX[0] -= 10;
      }
      else if (turnAngle == 270) { // DOWN
        snakeY[0] += 10;
      }
    }
  }
}

// Checks to see if the snake ate the apple and also randomizes the location of the apple
void apple() {
  if (snakeX[0] == appleX && snakeY[0] == appleY) { // If the head of the snake is equal to the the apple, then it will execute the code below
    snakeSize += 3;
    relocateApple = true;
    
    switch (speed) { // Checks to see which game speed you chose, and will increase the score for the chosen difficulty
      case 12: normalScore++; break;
      case 20: fastScore++; break;
      case 30: extremeScore++; break;
    }
    
    while (relocateApple) {
      appleX = (round(random(48)) + 1) * 10; // Puts the apple in a random location on the screen
      appleY = (round(random(48)) + 1) * 10;
      
      for (int i = 0; i < snakeSize; i++) { // This for loop makes sure that the apple is not on the snake
        if (appleX == snakeX[i] && appleY == snakeY[i]) {
          relocateApple = true;
        }
        else {
          relocateApple = false;
          i = 9999; // Has to be a number above snakeSize so that it exits the for loop
        }
      }
    }
  }
}

// Displays the snake on the screen
void snake() {
  stroke(30);
  fill(snakeColor);
  rect(snakeX[0], snakeY[0], 10, 10);
  
  fill(30);
  rect(snakeX[snakeSize], snakeY[snakeSize], 10, 10);
}

// Checks to see if the snake hit itself or the border
void snakeDead() {
  if (snakeX[0] >= width || snakeY[0] >= height || snakeX[0] <= 0 || snakeY[0] <= 0) { // This if statement checks to see if the snake hit the border
    scoreboardData();
    
    runGame = false;
    fill(255);
    rect(100, 200, 300, 100);
    fill(30);
    rect(105, 205, 290, 90);
    fill(255);
    textSize(13);
    switch (speed) {
      case 12: text("Score: " + normalScore, 250, 230); break;
      case 20: text("Score: " + fastScore, 250, 230); break;
      case 30: text("Score: " + extremeScore, 250, 230); break; // Upon death, it will tell you the score you got
    }                                                           // and give you the option to restart or go back to the main menu
    text("Press CTRL to restart.", 250, 250);
    text("Press SHIFT to go back to the Main Menu.", 250, 270);
  }
  
  for (int i = 1; i < snakeSize; i++) { // This for loop checks to see if the snake hit itself
    if ((snakeX[0] == snakeX[i]) && (snakeY[0] == snakeY[i])) {
      scoreboardData();
      
      runGame = false;
      fill(255);
      rect(100, 200, 300, 100);
      fill(30);
      rect(105, 205, 290, 90);
      fill(255);
      textSize(13);
      switch (speed) {
        case 12: text("Score: " + normalScore, 250, 230); break;
        case 20: text("Score: " + fastScore, 250, 230); break;
        case 30: text("Score: " + extremeScore, 250, 230); break;
      }
      text("Press CTRL to restart.", 250, 250);
      text("Press SHIFT to go back to the Main Menu.", 250, 270);
    }
  }
}

// These are all the variables that are reset when the user chooses to restart the game
void restart() {
  background(30);
  snakeX[0] = width / 2;
  snakeY[0] = height / 2;
  
  for (int i = 1; i < 2500; i++) {
    snakeX[i] = 0;
    snakeY[i] = 0;
  }
  runGame = true;
  relocateApple = true;
  appleX = (round(random(48)) + 1) * 10;
  appleY = (round(random(48)) + 1) * 10;
  snakeSize = 5;
  turnAngle = 0;
  normalScore = 0;
  fastScore = 0;
  extremeScore = 0;
}
