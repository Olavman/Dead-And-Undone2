// Draw the level
var _col = c_white;
for (var xx = 0; xx < width; xx++){
	for (var yy = 0; yy < height; yy++){
		_col = c_white;
		var _a = 1;
		var _spr = sGrassTile;
		if (map[# xx, yy][CELL.TERR] == infinity){
			_spr = sWallTile;
		}
		if (map[# xx, yy][CELL.TERR] == 4){
			_spr = sWaterTile;
		}
		draw_set_color(_col)
		draw_sprite_ext(_spr, 0, xx*gridSize, yy*gridSize, gridSize/sprite_get_width(_spr), gridSize/sprite_get_height(_spr), 0, _col, 1);
		
		for (var i = 0; i < array_length(path); i++){
			if (path[i][0] == xx && path[i][1] == yy){
				draw_sprite_ext(sPathTile, 0, xx*gridSize, yy*gridSize, gridSize/sprite_get_width(_spr), gridSize/sprite_get_height(_spr), 0, _col, 0.5);
			}
		}
	}
}
draw_set_color(c_white)

// Draw pieces
if (instance_exists(oPiece)){
	var _piece = [0]
	for (var i = 0; i < instance_number(oPiece); i++){
		_piece[i] = instance_find(oPiece, i);
		var _a = 1;
		if (_piece[i].selected == true) _a = 0.5;
		draw_sprite_ext(_piece[i].sprite_index, 0, _piece[i].gridX*gridSize, _piece[i].gridY*gridSize, 1, 1, 0, c_white, _a);
	}
}
clear_path();

draw_text(mouse_x+16, mouse_y, min(width-1, max(0, floor(mouse_x/gridSize))));
draw_text(mouse_x+16, mouse_y+16, min(width-1, max(0, floor(mouse_y/gridSize))));