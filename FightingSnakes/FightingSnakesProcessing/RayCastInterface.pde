class RayCastInterface{
  public ArrayList<Line> lines=new ArrayList<Line>();//this should be a linked list but seems not to be implemented in processing

  //May return null
  //direction should be a unit vector
  RayImpact rayCast(PVector origin,PVector direction){
    ArrayList<RayImpact> hits= new ArrayList<RayImpact>();
    
    for(int i=0;i<lines.size();i++){
      //lineOragin + lineDirection*mu = rayOragin + rayDirection*lambda
      Line myLine=lines.get(i);
      PVector lineOrigin=myLine.getOrigin();
      PVector lineEnd=myLine.getEnd();
      PVector lineDirection=myLine.getDirection();
      float a=lineDirection.x;
      float b=lineDirection.y;
      float c=direction.x;
      float d=direction.y;
      float lambda = b*origin.x+a*lineOrigin.y-a*origin.y-b*lineOrigin.x;
      lambda/=a*d-b*c;
      
      if(lambda<0){continue;}//line goes in the opposite direction
      
      PVector impactPos=PVector.add(origin,PVector.mult(direction,lambda));
      
            
      //check if impact in line range
      if(lineOrigin.x>lineEnd.x){
        if(!(impactPos.x<lineOrigin.x && impactPos.x>lineEnd.x)){
          continue;
        }
      }
      else{
        if(!(impactPos.x>lineOrigin.x && impactPos.x<lineEnd.x)){
          continue;
        }
      }
      if(lineOrigin.y>lineEnd.y){
        if(!(impactPos.y<lineOrigin.y && impactPos.y>lineEnd.y)){
          continue;
        }
      }
      else{
        if(!(impactPos.y>lineOrigin.y && impactPos.y<lineEnd.y)){
          continue;
        }
      }
    
      RayImpact myRayImpact=new RayImpact(myLine,impactPos,lambda);
      hits.add(myRayImpact);
    }
    float min=1E+30;
    RayImpact first=null;
    for(int i=0;i<hits.size();i++){
      RayImpact j = hits.get(i);
      if(j.distance<min){
        first=j;
        min=j.distance;
      }
    }
  
    return first;
  }
  
  void addSnake(Snake snake){
    ArrayList<SnakeBody> bodyParts=snake.getBodyParts();
    for(int i=0;i<bodyParts.size();i++){
      this.lines.add(bodyParts.get(i).getLine());
    }
    ArrayList<Line> skipConnections=snake.getSkipLines();
    for(int i=0;i<skipConnections.size();i++){
      this.lines.add(skipConnections.get(i));
    }
  }
}

class RayImpact{
  public Line line;
  public PVector hitPos;
  public float distance;
  
  RayImpact(Line line, PVector hitPos, float distance){
    this.line=line;
    this.hitPos=hitPos;
    this.distance=distance;
  }
}
