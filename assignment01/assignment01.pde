int x, y;
int deg = 0;
int objectCount = 0;
float hue = random(0, 360);

void setup() {
  size(640, 360);
  background(0, 255, 255);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  ellipseMode(RADIUS);
  rectMode(CENTER);
  x = (int) random(0, width);
  y = (int) random(0, height);
}

void draw() {  
  // if frameCount mod 85 is 0, we can reset the global variables
  // this will define a new random x and y, and a new random hue for the next object
  if (frameCount % 85 == 0) {
    x = (int) random(0, width);
    y = (int) random(0, height);
    hue = random(0, 360);
    deg = 0; // reset deg to 0 so the animation starts scaling at 0
    objectCount = (int) random(0, 4); // objectCount is random between 0 and 4
  }
  
  // define our sine value based off deg
  float sv = sin(deg * 0.01);
  
  // translate to the random positions of x and y
  translate(x, y);
  // scale by the sine value
  scale(sv);
  
  // draw a rect or ellipse dynamically depending on objectCount 
  if (objectCount % 2 == 0) {
    drawGradientRect(0, 0, 100, hue);
  } else {
    drawGradientEllipse(0, 0, 100, hue);
  }
  
  // increase deg to progress the animation
  deg = deg + 2;
  
  saveFrame("frames/assignment01-######.png");
  
  // end the animation after 2000 frames
  if (frameCount >= 2000) {
    noLoop();
  }
}

void drawGradientRect(float x, float y, int size, float hue) {
  // to get a gradient rect, we want to draw many rects from
  // i = size until i = 0, adjusting the hue as we draw towards the center
  for (int i = size; i > 0; i--) {
    // here we use push and pop to keep the rotation from affecting the main canvas
    push();
    fill(hue, 90, 90);
    rotate(radians(-deg));
    rect(x, y, i, i);
    hue = (hue + 1) % 360;
    pop();
  }
}

void drawGradientEllipse(float x, float y, int size, float hue) {
  // to get a gradient ellipse, we want to draw many ellipses from
  // i = size until i = 0, adjusting the hue as we draw towards the center
  for (int i = size; i > 0; i--) {
    fill(hue, 90, 90);
    ellipse(x, y, i, i);
    hue = (hue + 1) % 360;
  }
}
