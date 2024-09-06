// Move piece
if (array_length(path) > 0){
	timer--;
	if (timer <= 0){
		timer = room_speed/3;
		var _length = array_length(path)-1;
		// Move toward destination
		if (i < _length-1 && moveCost < spd){
			i++;
			gridX = path[_length-i][0];
			gridY = path[_length-i][1];
			moveCost = path[_length-i][2];
		}
		// Distination reached
		if (i == _length-1 || moveCost >= spd) {
			if (i == _length-1){
				// Attack
				attack(path[0][0], path[0][1]);
			}
			array_resize(path, 0)
			i = 0;
			moveCost = 0;
			oTacticalCombat.ready = true;
		}
	}
}
	
// Die
if (hp <= 0) instance_destroy(id);