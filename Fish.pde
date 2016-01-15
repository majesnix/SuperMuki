class Fish {
	
	PVector position, velocity;

	Boolean alive;

	Fish(float positionX, float positionY){
		velocity = new PVector();
		position = new PVector();
		position.x = positionX;
		position.y = positionY;
		alive=true;
	}

	void move(){

    	velocity.y = -3;

    	position.add(velocity);

	}

	void draw(){
		if (position.y<0){
			alive=false;
		}
	int guyWidth = fish.width;
    int guyHeight = fish.height;

    pushMatrix();
    translate(position.x, position.y);
    translate(-guyWidth/2, -guyHeight);

      image(fish, 0, 0);

    popMatrix();
  }//draw
}//Fish.class