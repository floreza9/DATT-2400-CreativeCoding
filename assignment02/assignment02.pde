// global vars for the application
int deg = 0;
boolean reverse = false;
// I'm using an array list here because I don't want to define a size
// array lists seems a little easiear to work with
ArrayList<MyPoint> arr = new ArrayList<MyPoint>(); // my objects will be stored here
boolean continueAnimation = true;

// standard setup
void setup(){
  size(500, 500);
  background(0);
  frameRate(20);
}

// Custom object for the points that are rendered
public class MyPoint {
    private int sub = 0; // variable used to decrease the size of the point
    private int angle = 0; // angle of the point to be placed
    private boolean active = true; // variable used to determine if I should render the point
    private int diameter = 250; // diamater of the circle the points are placed around

    public MyPoint() {
    }

    // this is the constructor used in the application
    // it accepts an angle as the paramater so each point added can be added in a different location
    public MyPoint(int angle) {
      this.angle = angle;
    }
    
    // this drawMe function is whats used to actually render the point
    public void drawMe() {
      double x = diameter / 2 * Math.cos(radians(this.angle)) + width / 2;
      double y = diameter / 2 * Math.sin(radians(this.angle)) + height / 2;
      // everytime the point is rendererd is decreases in size
      int w = 15 - this.sub;
      // once the size is 0 I don't want to render it anymore
      // so I'll mark this.active as false
      if (w < 0) {
        this.active = false;
      }
      // so if it's no longer active then just don't render it
      if (this.active) {
        strokeWeight(w);
        point((int)(x), (int)(y));
      }
    }
    
    // I call this function after each render to continuosly decrease the size 
    public void decreaseSize() {
      this.sub = this.sub + 1;
    }
}

void draw(){
  stroke(255);
  strokeWeight(10);
  background(0);
  noFill();

  // here, I add points to the array
  // there are times where I stop adding points
  // and wait for the all other points to disappear
  if (continueAnimation) {
    // if the animation is reversed I want to creat a point with a negative deg / angle
    if (reverse) {
      arr.add(new MyPoint(-deg));
    } else {
      arr.add(new MyPoint(deg));
    }
  }
  
  if (arr.size() > 0) {
    // then I just loop through the array, draw the points, then decrease their size
    for (int i = 0; i < arr.size(); i++) {
      arr.get(i).drawMe();
      arr.get(i).decreaseSize();
    }
  }
  
  deg += 20;
  // this line will save the frames, if you want to comment it in
  //saveFrame("test/line-######.png");
  
  // pause animation after 19 frames, 1 rotation
  if (frameCount == 19) {
    continueAnimation = false;
  }
  // after 34 frames it looks like all points have disappeared
  // so I can begin the animation again and reverse the order
  if (frameCount == 34) {
    deg = 0;
    continueAnimation = true;
    reverse = true;
  }
  // after 53 frames I stop the animation again and wait for all points to disappear
  if (frameCount == 53) {
    continueAnimation = false;
  }
  // after 68 frames, all points seems to have disappeared
  // so lets stop the animation
  if (frameCount == 68) {
    noLoop();
  }
}
