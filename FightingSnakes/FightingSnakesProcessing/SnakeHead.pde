class SnakeHead extends SnakeNode{
  
  private float sqrt2=sqrt(2);
  
  SnakeHead(PVector pos){
    super(pos);
  }
  
  void show(PVector velocityDirection,boolean alive,color col){
    float size=5;
    PVector a=PVector.add(this.pos,PVector.mult(velocityDirection,size));
    PVector velocityNormal=velocityDirection.copy().rotate(PI/2);
    PVector b=PVector.add(this.pos,PVector.mult(velocityNormal,size/sqrt2),PVector.mult(velocityDirection,-size));
    PVector c=PVector.add(this.pos,PVector.mult(velocityNormal,-size/sqrt2),PVector.mult(velocityDirection,-size));
    if(alive){
      fill(col);
    }
    else{
      
      fill(red(col)/2,green(col)/2,blue(col)/2);
    }
    noStroke();
    triangle(a.x,a.y,b.x,b.y,c.x,c.y);
  }
  
  void move(float speed,PVector velocityDirection){
    this.pos.add(PVector.mult(velocityDirection,speed));
  }
}
