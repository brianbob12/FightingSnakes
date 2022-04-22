//line for raycasing

class Line{
  private PVector origin;
  private PVector end;
  private PVector direction;
  
  Object owner;
  Line(PVector origin, PVector end,PVector direction,Object owner){
    this.origin=origin;
    this.end=end;
    this.direction=direction;
    this.owner=owner;
  }
  
  public PVector getOrigin(){
    return this.origin;
  }
  public void setOrigin(PVector v){
    this.origin=v;
  }
  public PVector getEnd(){
    return this.end;
  }
  public void setEnd(PVector v){
    this.end=v;
  }
  public PVector getDirection(){
    return this.direction;
  }
  public void setDirection(PVector v){
    this.direction=v;
  }
}
