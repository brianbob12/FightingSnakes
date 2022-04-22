
class Snake{
  PVector velocity;//unitvector
  public float speed=0.6;
  public float turningSpeed=0.0125;//reads per frame
  
  
  public float seekingRange=200;
  public float seekingPOV=PI/2;
  public float transitionTime=30;//number of frames for transition betweek seeking and attacking
  public float attackingRange=350;//must be bigger
  public float attackingPOV=PI/4;//must be smaller
  
  private float activeRange=seekingRange;
  private float activePOV=seekingPOV;
  
  public int searchRays=9;
  
  public float attackSpeed=1.8;
  public float killDistance=5;
  
  public boolean alive=true;
  
  private boolean attacking=false;
  
  public int numberOfNodes;//excludes head
  
  public int strokeWeight=1;
  
  private SnakeHead head;
  private ArrayList<SnakeBody> bodyParts;
  //distance between body nodes
  private float targetDistance;
  
  private HashMap<Integer,ArrayList<PVector>> skippedConnectionDirections=new HashMap<Integer,ArrayList<PVector>>();//the pointers of these PVectors should not change so the lines don't have to be updated
  private int skippedOrders=2;//2 and 3
  
  public String name;
  
  //numberOfNodes excludes head 
  Snake(String name,PVector headPos,int numberOfNodes,PVector nodeSeperation){
    this.name=name;
    this.numberOfNodes=numberOfNodes;
    this.targetDistance=nodeSeperation.mag();
    
    //head
    this.head=new SnakeHead(headPos);
    
    //body
    this.bodyParts=new ArrayList<SnakeBody>();
    this.bodyParts.add(new SnakeBody(PVector.add(headPos,nodeSeperation),this.head,this));
    this.bodyParts.get(0).strokeWeight=this.strokeWeight;
    for(int i=1;i<numberOfNodes;i++){
      this.bodyParts.add(new SnakeBody(PVector.add(this.bodyParts.get(i-1).getPos(),nodeSeperation),this.bodyParts.get(i-1),this));
      this.bodyParts.get(i).strokeWeight=this.strokeWeight;
    }
    //starting velocity
    this.velocity=PVector.mult(nodeSeperation,-1);
    this.velocity.normalize();
    
    //setup skipped orders
    for(int i=1;i<this.skippedOrders+1;i++){
      ArrayList<PVector> directionVectors =this.computeSkipDirectionVectors(i);
      this.skippedConnectionDirections.put(i,directionVectors);
    }
  }
  
  //from head
  RayImpact castRay(RayCastInterface rc,float relativeAngle){
    PVector lookVector=this.velocity.copy();
    lookVector.rotate(relativeAngle);
    RayImpact impact=rc.rayCast(this.head.pos,lookVector);
    
    /*
    if(impact!=null){
      stroke(255,255,0);
      strokeWeight(1);
      line(this.head.pos.x,this.head.pos.y,impact.hitPos.x,impact.hitPos.y);
    }
    */
    
    return impact;
  }
  
  void show(){
    color col;
    if(this.name=="A"){
      col=color(0,255,0);
    }
    else{
      col=color(255,0,0);
    }
    this.head.show(this.velocity,this.alive,col);
    for(int i=0;i<numberOfNodes;i++){
      this.bodyParts.get(i).show(this.attacking,this.alive);
    }
    
    for(int i=1;i<this.skippedOrders+1;i++){
      this.drawSkippedConnections(i);
    }
    
    //vision range
    if(this.alive){
      fill(255,255,0,50);
      noStroke();
      float start=-this.activePOV/2+this.velocity.heading();
      float end=start+this.activePOV;
      arc(this.head.getPos().x,this.head.getPos().y,this.activeRange*2,this.activeRange*2,start,end);
    }
  }
  
  //order should be 2
  private void drawSkippedConnections(int order){
    //2nd connections
    strokeWeight(this.strokeWeight);
    if(!this.attacking){
      stroke(255);
    }
    else{
      stroke(255,0,0);
    }
    if(!this.alive){
      stroke(150,150,150,150);//partly transparent
    }
    //head
    if(numberOfNodes>order-1){
      PVector p=this.bodyParts.get(order-1).getPos();
      line(this.head.pos.x,this.head.pos.y,p.x,p.y);
    }
    //body
    for(int i=0;i<numberOfNodes-order;i++){
      PVector p1=this.bodyParts.get(i).getPos();
      PVector p2=this.bodyParts.get(i+order).getPos();
      line(p1.x,p1.y,p2.x,p2.y);
    }
  }
  
  
  void move(){
    if(!this.alive){return;}
    
    //motion
    
    //reverse order
    for(var i=this.numberOfNodes-1;i>=0;i--){
      this.bodyParts.get(i).move(this.targetDistance);
    }
    if(!this.attacking){
      this.head.move(this.speed,this.velocity);
    }
    else{
      this.head.move(this.attackSpeed,this.velocity);
    }
    
    //recompute direction for all bodypart lines
    for(var i=0;i<this.numberOfNodes;i++){
      this.bodyParts.get(i).recomputeDirection();
    }
    //recompute diretions for all skipped orders
    for(int i=1;i<this.skippedOrders+1;i++){
      this.recomputeSkipDirectionVectors(i);
    }
    
    //move range and POV
    if(this.attacking){
      if(this.activePOV>this.attackingPOV){
        this.activePOV-=(this.seekingPOV-this.attackingPOV)*1/this.transitionTime;
      }
      if(this.activePOV<this.attackingPOV){
        //overshot
        this.activePOV=this.attackingPOV;
      }
      if(this.activeRange<this.attackingRange){
        this.activeRange+=(this.attackingRange-this.seekingRange)*1/this.transitionTime;
      }
      if(this.activeRange>this.attackingRange){
        //overshot
        this.activeRange=this.attackingRange;
      }
    }
    else{
      if(this.activePOV<this.seekingPOV){
        this.activePOV+=(this.seekingPOV-this.attackingPOV)*1/this.transitionTime;
      }
      if(this.activePOV>this.seekingPOV){
        //overshot
        this.activePOV=this.seekingPOV;
      }
      if(this.activeRange>this.seekingRange){
        this.activeRange-=(this.attackingRange-this.seekingRange)*1/this.transitionTime;
      }
      if(this.activeRange<this.seekingRange){
        //overshot
        this.activeRange=this.seekingRange;
      }
    }
  }
  
  void turn(float theta){
    this.velocity.rotate(theta);
  }
  
  public ArrayList<SnakeBody> getBodyParts(){
    return this.bodyParts;
  }
  
  private ArrayList<PVector> computeSkipDirectionVectors(int order){
    ArrayList<PVector> out= new ArrayList<PVector>();
    //head
    if(numberOfNodes>order-1){
      PVector p=this.bodyParts.get(order-1).getPos();
      PVector headVec=PVector.sub(this.head.getPos(),p);
      headVec.normalize();
      out.add(headVec);
    }
    //body
    for(int i=0;i<numberOfNodes-order;i++){
      PVector vec=PVector.sub(this.bodyParts.get(i).getPos(),this.bodyParts.get(i+order).getPos());
      vec.normalize();
      out.add(vec);
    }
    return out;
  }
  
  //does not change PVector pointers
  private void recomputeSkipDirectionVectors(int order){
    ArrayList<PVector> workingArray= this.skippedConnectionDirections.get(order);
    //head
    if(numberOfNodes>order-1){
      PVector p=this.bodyParts.get(order-1).getPos();
      PVector headVec=PVector.sub(this.head.getPos(),p);
      headVec.normalize();
      workingArray.get(0).set(headVec.x,headVec.y);
    }
    //body
    for(int i=0;i<numberOfNodes-order;i++){
      PVector vec=PVector.sub(this.bodyParts.get(i).getPos(),this.bodyParts.get(i+order).getPos());
      vec.normalize();
      workingArray.get(i+1).set(vec.x,vec.y);
    }
  }
  
  public ArrayList<Line> getSkipLines(){
    ArrayList<Line> out= new ArrayList<Line>();
    for(int order=1;order<this.skippedOrders+1;order++){
      //head
      if(numberOfNodes>order-1){
        PVector end=this.bodyParts.get(order-1).getPos();
        PVector start=this.head.getPos();
        PVector direction=this.skippedConnectionDirections.get(order).get(0);
        out.add(new Line(start,end,direction,this));
      }
      //body
      for(int i=0;i<numberOfNodes-order;i++){
        PVector start=this.bodyParts.get(i).getPos();
        PVector end=this.bodyParts.get(i+order).getPos();
        PVector direction=this.skippedConnectionDirections.get(order).get(i+1);
        out.add(new Line(start,end,direction,this));
      }
    }
    return out;
  }
  
  public boolean wallDetection(RayCastInterface rc){
    if(!this.alive){return false;}
    float triggerDistance=100;
    boolean out=false;
    for(int i=-1;i<2;i+=2){
      RayImpact impact = this.castRay(rc,PI/4*i);
      if(impact!=null){
        if(!(impact.line.owner instanceof Wall)){
          if(impact.line.owner instanceof Snake){
            if(this.name!=((Snake) impact.line.owner).name){
              continue;
            }
          }
          else{
            continue;
          }
        }
        //distance is sometimes buggy so recalculate
        float distance=PVector.sub(this.head.pos,impact.hitPos).mag();
        if(distance<triggerDistance){
          //the min is there to stop the turning from being too fast
          this.turn((-this.turningSpeed*i*min(triggerDistance/distance,3))*2);
          out= true;
        }
      }
    }
    return out;
  }
  
  public boolean seekEnemies(RayCastInterface rc){
    if(!this.alive){return false;}
    boolean out=false;
    float triggerDistance=this.activeRange;
    for(float i=-1;i<=1;i+=2/float(this.searchRays)){
      RayImpact impact = this.castRay(rc,this.activePOV/2*i);
      if(impact!=null){
        if(!(impact.line.owner instanceof Snake)){
          continue;
        }
        if(this.name==((Snake) impact.line.owner).name){
          continue;
        }
        if(!((Snake) impact.line.owner).alive){
          continue;
        }
        //distance from impact is buggy, recalculate
        float distance=PVector.sub(this.head.pos,impact.hitPos).mag();
        if(distance<triggerDistance){
          //the min is there to stop the turning speed going too high
          this.turn((this.turningSpeed*i*min(triggerDistance/distance,3))*1.5);
          out= true;
        }
        if(distance<this.killDistance){
          //kill it
          println(this.name+" killed "+((Snake) impact.line.owner).name);
          ((Snake) impact.line.owner).alive=false;
        }
      }
    }
    attacking=out;
    return out;
  }
}
