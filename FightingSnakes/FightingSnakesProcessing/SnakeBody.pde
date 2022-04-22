class SnakeBody extends SnakeNode{
  private SnakeNode connection;
  private PVector directionVector;//used for raycasting and movement
  private Line line;//used for raycasting
  
  public int strokeWeight=1;
  
  SnakeBody(PVector pos,SnakeNode connection,Snake snake){
    super(pos);
    this.connection=connection;
    this.directionVector=PVector.sub(pos,connection.pos);
    this.directionVector.normalize();
    this.line=new Line(this.pos,connection.pos,this.directionVector,snake);
  }
  
  void show(boolean attacking,boolean alive){
    if(!alive){
      stroke(200,200,200);
    }
    else{
      if(!attacking){
        stroke(255);
      }
      else{
        stroke(255,0,0);
      }
    }
    strokeWeight(this.strokeWeight);
    PVector connectionPos=connection.getPos();
    line(this.pos.x,this.pos.y,connectionPos.x,connectionPos.y);
    
    super.show();
  }
  
  public void move(float targetDistance){
    PVector directionVector=PVector.sub(this.connection.getPos(),this.pos);
    //assume connection moving at {speed}
    float adjustedSpeed=(directionVector.mag()-targetDistance);
    //adjustedSpeed=max(adjustedSpeed,0);
    directionVector.normalize();
    this.directionVector=directionVector;//to update infomration for raycasting
    this.pos.add(PVector.mult(directionVector,adjustedSpeed));
  }
  
  public void recomputeDirection(){
    PVector directionVector=PVector.sub(this.connection.getPos(),this.pos);
    directionVector.normalize();
    this.directionVector=directionVector;
  }
  
  public Line getLine(){return this.line;}
}
