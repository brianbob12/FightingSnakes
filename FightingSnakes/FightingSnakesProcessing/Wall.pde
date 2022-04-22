class Wall{
  PVector start;
  PVector end;
  Line line;
  Wall(float startX,float startY,float endX,float endY){
    this.start=new PVector(startX,startY);
    this.end=new PVector(endX,endY);
    PVector direction=PVector.sub(this.end,this.start);//order doesn't matter
    direction.normalize();
    this.line=new Line(this.start,this.end,direction,this);
  }
  
  void show(){
    stroke(255);
    strokeWeight(1);
    line(this.start.x,this.start.y,this.end.x,this.end.y);
  }
}
