// declaring global variables
PImage photo;
Pixel[] myPixels; // arry to store pixels of my custom Pixel class

void setup() {
  size(800, 600);
  // here I want to load the pixels of the canvas into memory
  loadPixels();
  
  // then I want to load my frog image and load the frog pixels into memory
  photo = loadImage("frog.jpg");
  photo.loadPixels();
  
  // here I'm trying to map the pixels of the frog image into the canvas
  // since the image is smaller than the canvas and I want the image to be centered
  // I need to offset the mapping by 100px on the width and height
  for (int x1 = 0; x1 < width; x1++) {
    for (int y1 = 0; y1 < height; y1++) {
      // if this condition is met the frog image pixels should be mapped to the canvas pizels
      if (x1 >= 100 && x1 < width - 100 && y1 >= 100 && y1 < height - 100) {
        int x2 = x1 - 100;
        int y2 = y1 - 100;
        int loc1 = x1 + y1 * width;
        int loc2 = x2 + y2 * photo.width;
        int c = photo.pixels[loc2];
        // I want to manipluate the pixels to tbe the inverse
        // so I subtract the value from 255
        pixels[loc1] = color(255 - red(c), 255 - green(c), 255 - blue(c));
      } else {
        // these pixels are ones that don't map to the image
        // I want to make these pixels a nice pink colour
        int loc1 = x1 + y1 * width;
        pixels[loc1] = color(255, 0, 255);
      }
    }
  }
  
  // this chunk of code here will map pixels of the frog image into the myPixels array
  // I wanted to map each pixel but the rendering was way too slow
  // so I map every third pixel to reduce the amount of pixels that need to be rendered each time
  // the outcome makes the image look a little blurry but I think it looks fine
  
  double numRows = Math.ceil(photo.width / 3); // since I'm only rendering every third pixel I can calc the numRows by photo.width / 3
  double numCols = Math.ceil(photo.height / 3.0); // same for numCols
  myPixels = new Pixel[(int)(numRows * numCols)]; // numRows * numCols is how many pixels will end up in the array
  
  int index = 0;
  for (int x = 0; x < photo.width; x += 3) {
    for (int y = 0; y < photo.height; y += 3) {
      int loc = x + y * photo.width;
      int c = photo.pixels[loc];
      // for each Pixel object I need to pass the colour of the pixel and the x, y coordinated
      myPixels[index++] = new Pixel(c, x + 100, y + 100);
    }
  }
}

void draw() {
  background(255, 0, 255);
  // I call this to update the canvs pixels with what I manipulated them to in the setup function
  // so under all my custom Pixel objects will be a canvas with the inverted image in the centre
  updatePixels();

  noStroke();
  ellipseMode(CENTER);
  
  // here I just have to loop through all the pixels in the myPixels array
  for (int i = 0; i < myPixels.length; i++) {
    Pixel p = myPixels[i];
    p.detectMouseHit(); // I call detectMouseHit to see if the mouse in near the pixel
    p.display(); // I then call display to actually draw the pixel
  }
}
