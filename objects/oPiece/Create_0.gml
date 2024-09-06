gridX = 4;
gridY = 9;
spd = 16;
path = [];
timer = room_speed;
i = 0;
moveCost = 0;
selected = false;
side = 1;
hp = 10;
dmg = 2;

attack = function(xx, yy)
{
	if (instance_exists(oPiece)){
		var _piece = [0]
		for (var i = 0; i < instance_number(oPiece); i++){
			_piece[i] = instance_find(oPiece, i);
			// Piece at target position
			if (_piece[i].gridX == xx && _piece[i].gridY == yy){
				// Piece is enemy
				if (_piece[i].side != side){
				_piece[i].hp -= dmg;
				}
			}
		}
	}
}