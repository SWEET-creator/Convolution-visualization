PImage img;

void setup() {
  size(600, 600);
  
  //load image
  loadPixels();
  img = loadImage("IMG_7597.jpeg");
  img.resize(600,600);
  
  //open sub window
  String[] args = {"YourSketchNameHere"};
  SecondApplet sa = new SecondApplet();
  PApplet.runSketch(args, sa);
}

int size_w = 600;
int size_h = 600;
int pixel_size = 10;
int pixel_num_x = int(size_w/pixel_size);
int pixel_num_y = int(size_h/pixel_size);

float[][] Gauss = {{1.0/16.0, 1.0/8.0, 1.0/16.0},
                   {1.0/8.0, 1.0/4.0, 1.0/8.0},
                   {1.0/16.0, 1.0/8.0, 1.0/16.0}};

float[][] line = {{.0, 1.0, 0.0},
                   {.0, -2.0, 0.0},
                   {.0, 1.0, 0.0}};
                   
float[][] Laplacian = {{0.0, 1.0, 0.0},
                   {1.0, -4.0, 1.0},
                   {.0, 1.0, 0.0}};
                   
float[][] filter = Laplacian;
int filter_size = filter.length;
int step = 1;

int out_shape_x = pixel_num_x-filter_size+1/step;
int out_shape_y = pixel_num_y-filter_size+1;

int t = 0;
int filter_x = 0;
int filter_y = -1;

float[][][] out = new float [(out_shape_x)][(out_shape_y)][3];
float[][][] pixel = new float[pixel_num_x][pixel_num_y][3];

void draw() {
  if(t == 0){
    init_out();
    load_img();
  }
  background(0);
  for(int x=0; x<pixel_num_x; x++){
    for(int y=0; y<pixel_num_y; y++){
      stroke(0);
      strokeWeight(0); 
      fill(pixel[x][y][0], pixel[x][y][1], pixel[x][y][2]);
      square(x*pixel_size,y*pixel_size,pixel_size);
    }
  }
  stroke(255,0,0);
  strokeWeight(2); 
  noFill();
  filter_x = t%(out_shape_x);
  if(filter_x == 0){
    filter_y++;
  }
  if(t == (out_shape_x)*(out_shape_y)-1){
    noLoop();
  }
  square(filter_x*pixel_size, filter_y*pixel_size, pixel_size*filter_size);
  out_update(filter_x, filter_y);
  //delay(100);
  t++;
}

void load_img(){
  img.loadPixels();
    for (int x = 0;x<int(img.width/pixel_size);x++){
      for (int y = 0;y<int(img.height/pixel_size);y++){
        int loc = x + y*img.width;
        loc *= pixel_size;
        pixel[x][y][0] = red(img.pixels[loc]);
        pixel[x][y][1] = green(img.pixels[loc]);
        pixel[x][y][2] = blue(img.pixels[loc]);
    }
  }
}

void init_out(){
  for (int i = 0;i<out.length;i++){
    for (int j = 0;j<out.length;j++){
      out[i][j][0] = 0;
      out[i][j][1] = 0;
      out[i][j][2] = 0;
    }
  }
}

void out_update(int filter_x, int filter_y){
  float R = 0;
  float G = 0;
  float B = 0;
  for (int k = 0;k<filter_size;k++){
    for (int l = 0;l<filter_size;l++){
      R += pixel[filter_x+k][filter_y+l][0]*filter[k][l];
      G += pixel[filter_x+k][filter_y+l][1]*filter[k][l];
      B += pixel[filter_x+k][filter_y+l][2]*filter[k][l];
      
    }
  }
  out[filter_x][filter_y][0] = R;
  out[filter_x][filter_y][1] = G;
  out[filter_x][filter_y][2] = B;
}

public class SecondApplet extends PApplet {

  public void settings() {
    size(out_shape_x*pixel_size, out_shape_y*pixel_size);
  }
                  
  public void draw() {
    for(int x=0; x<out.length; x++){
      for(int y=0; y<out.length; y++){
        stroke(0);
        strokeWeight(0); 
        fill(out[x][y][0], out[x][y][1], out[x][y][2]);
        square(x*pixel_size, y*pixel_size, pixel_size);
      }
    }
    //delay(100);
  }
}
