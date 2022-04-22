

ArrayList<Snake> snakes= new ArrayList<Snake>();

int time=0;
int sizeX=1024;
int sizeY=1024;
ArrayList<Wall> walls;
RayCastInterface rc=new RayCastInterface();

void setup(){
  size(1024,1024);
  int teamSize=8;
  for(int i=0;i<teamSize;i++){
   Snake mySnake=new Snake("A",new PVector(sizeX-100,sizeY/(teamSize+1)*(i+1)),20,new PVector(10,0.1));
   rc.addSnake(mySnake);
   snakes.add(mySnake);
  }
  for(int i=0;i<teamSize;i++){
   Snake mySnake=new Snake("B",new PVector(100,sizeY/(teamSize+1)*(i+1)),20,new PVector(-10,0.1));
   rc.addSnake(mySnake);
   snakes.add(mySnake);
  }
  
  walls=new ArrayList<Wall>();
  //four corners
  walls.add(new Wall(0.1,0.2,0.3,sizeY));
  walls.add(new Wall(0.1,0.2,sizeX,0.3));
  walls.add(new Wall(sizeX,sizeY,0.1,sizeX+0.1));
  walls.add(new Wall(sizeX,sizeY,sizeY+0.1,0.1));
  walls.add(new Wall(50,0,0,50));
  walls.add(new Wall(sizeX-50,0,sizeX,50));
  walls.add(new Wall(0,sizeY-50,50,sizeY));
  walls.add(new Wall(sizeX-50,sizeY,sizeX,sizeY-50));
  //mid blocks
  walls.add(new Wall(462,200,462.1,sizeY-200));
  walls.add(new Wall(sizeX-462,200,sizeX-462.1,sizeY-200));


  
  //add walls to rc
  for(int i=0;i<walls.size();i++){
    rc.lines.add(walls.get(i).line);
  }
  
  
  
}

void draw(){
  background(0);
  int it=0;
  for( Snake s:snakes){
    s.wallDetection(rc);
    s.seekEnemies(rc);
    s.turn(noise(time*0.01+100*it)*0.05-0.025);
    s.move();
    s.show();
    it++;
  }
  
  time++;
  
  //draw walls
  for(int i=0;i<walls.size();i++){
    walls.get(i).show();
  }
  
  //saveFrame("A3/####.png");
}
