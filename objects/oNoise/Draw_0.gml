var _col = c_white;
for (var xx = 0; xx < width; xx++){
	for (var yy = 0; yy < height; yy++){
		var _c = map_value(map[#xx, yy], low, high, 0, 1);
		_col = make_color_rgb(_c*255, _c*255, _c*255); 
		_col = color_map(_c);
		draw_set_color(_col)
		draw_rectangle(xx*gridSize, yy*gridSize, xx*gridSize+gridSize, yy*gridSize+gridSize, false)
	}
}