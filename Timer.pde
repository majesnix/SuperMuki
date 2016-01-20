/**
 * Timer.pde
 * Purpose: Remembers the tileposition, and starts a Timer, when the timer is done, TILE is replaced with an EMPTY Block
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Timer{

	int startTime;
	PVector tilePosition;	
	Boolean done;

	Timer(){
	}

	Timer(int _startTime, PVector _tilePosition){

		startTime = _startTime;
		tilePosition = _tilePosition;
		done=false;
	}

	void run(){
		if(millis()/1000-startTime/1000==3 && level==1){
			theWorld.setSquareAtToThis(tilePosition, World.TILE_EMPTY);
			done=true;
		} else if (millis()/1000-startTime/1000==1 && level==3){
			theWorld.setSquareAtToThis(tilePosition, World.TILE_EMPTY);
			done=true;
		}
	}
}