// this is my custom Pixel class
// this class with accpect the colour of the pixel and it's initial position
// the class will end up rendering an ellipse in the colour of the desired pixel
// it will also detect if the mouse is close to itself and if so, move the pixel away from the mouse

class Pixel {
  int diameter = 5; // diameter of the ellipse to be rendered
  
  // variables to store the colour
  float r;
  float g;
  float b;

  // a couple boolean variables here to determine which direction to move the pixel 
  boolean moved = false;
  boolean resetting = false;
  
  int maxDiff = diameter * 2; // maxDiff is used to determine how close the mouse needs to be from the pixel before moving it
  int initialMaxDiff = diameter * 2;
  int maxForce = 4; // force will be used for acceleration / velocity when moving the pixel
  
  // my PVectors for moving the pixel
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector initialLocation; // storing initial location so I can always move the pixel back here after it's moved
  
  // I'm storing time as well
  // once the pixel is moved, after 2000 ms I want the pixel to move back to its original location
  int savedTime;
  int totalTime = 2000;
  
  // constructor
  Pixel(int c1, int x1, int y1) {
    // store the colour variables
    r = red(c1);
    g = green(c1);
    b = blue(c1);
    
    // initialize the PVectors
    location = new PVector(x1, y1);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
 
    // stote initialLocation to reference later
    initialLocation = new PVector(x1, y1);
  }
  
  // this method will determine if the mouse position is within maxDiff distance of the pixel
  // if it is, I will push the pixel away from the mouse by adding some acceleration
  void detectMouseHit() {
    PVector mousePosition = new PVector(mouseX, mouseY);

    ////////////////////////////////////////////////////////////////////////////////////
    // if the mouse is pressed I want to increase the radius of the mouse
    // so more pixels will be pushed away
    if (mousePressed) maxDiff++;
    else maxDiff--;
    
    // here I'm trying to limit the size of the mouse radius to be inbetween 0 and 100
    if (maxDiff >= 100) maxDiff = 100;
    else if (maxDiff <= initialMaxDiff) maxDiff = initialMaxDiff;
    ////////////////////////////////////////////////////////////////////////////////////

    // calculate the distance between the pixel's location and the mouse
    float dist = location.dist(mousePosition); 

    // if the distance is less than maxDiff let's add some acceleration
    if (dist <= maxDiff) {
      savedTime = millis(); // start the timer so eventually we can move the pixel back to it's original position
      resetting = false; // resetting = false so I know the pixel is moving awau from the mouse
      moved = true; // moved = true so I know this pixel has been touched (or moved) by the mouse

      // to move the pixel I'm trying to add some accelearation and magnitude in the direction that the object was hit
      // this part is still a little confusing to me
      // basically I'm trying to calculate the acceleration vector in the direction of the mouse hit
      // then map the magnitude from the range 0 -> maxDiff to the range maxForce -> 0
      // this seems to move the object away from the mouse with a nice speed
      acceleration = PVector.sub(location, mousePosition).setMag(
        map(
          dist,
          0.0,
          (float) maxDiff,
          (float) maxForce,
          0.0
        )
      );
    }

    // if the object was moved and 2000ms has passed we can set resetting to true to begin moving the object back to it's original position
    if (moved) {
      int passedTime = millis() - savedTime;
      if (passedTime > totalTime) {
        resetting = true;
      }
    }
  }
  

  void display() {  
    
    // if we're resetting, this means the object needs to move towards it's original location
    if (resetting) {
      // here I'm trying to reverse the direction of the acceleration to point towards the initial location
      PVector target = new PVector(initialLocation.x, initialLocation.y);
      target.sub(location);
      target.setMag(0.2); // I set the magnitude here to 0.2 which will give it a constant speed
      acceleration = target; // at this point I believe the acceleraion vector is pointing towards the initialLocation

      // then I calculate the distance away from the original position
      float distance = dist(location.x, location.y, initialLocation.x, initialLocation.y);
      
      // if the object gets close to it's original position (within 0.1) I just reset the PVectors and force the object back into the initialLocaion
      if (distance <= 0.1) {
        // reset the PVectors to remove speed and stop movement
        acceleration = new PVector(0, 0);
        velocity = new PVector(0, 0);
        // make location = initialLocation
        location = new PVector(initialLocation.x, initialLocation.y);
        // reset the variables controlling direction
        resetting = false;
        moved = false;
      }
    }
     
    // here we just add the acceleration to the velocity to make the pixel move
    // If the pixel hasn't been touched by the mouse, it will have no accelearion and therefore no velocity and will remain in place
    velocity.add(acceleration);
    location.add(velocity.mult(0.9));
    // here I'm trying to dwindle down the velocity and acceleration to slow it down and eventually stop
    acceleration.sub(acceleration.mult(0.9));
    velocity.limit(5);
    
    // here I finally draw the ellipse where the object is supposed to be 
    fill(color(r, g, b));
    ellipse(location.x, location.y, diameter, diameter);
  }
}  
