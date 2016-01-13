class Timer{

	int startTime;
	PVector tilePosition;	
	Boolean done;

	Timer(){
	}

	Timer(int _startTime, PVector playerPosition){

		startTime = _startTime;
		tilePosition = playerPosition;
		done=false;
	}

	void run(){
		if(millis()/1000-startTime/1000==1){
			theWorld.setSquareAtToThis(tilePosition, World.TILE_EMPTY);
			done=true;
		}
	}
}