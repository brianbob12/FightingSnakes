
class SnakeNode{
  protected PVector pos;
  
  SnakeNode(PVector pos){
    this.pos=pos;
  }
  
  public void show(){
    float size=0;
    noStroke();
    circle(pos.x,pos.y,size);
  }
  
  public PVector getPos(){
    return pos;
  }
  
}
