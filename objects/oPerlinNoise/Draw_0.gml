var size = 5;
var _col = c_white;
var _value = 0;
var _c =0;
for (var xx = 0; xx < width; xx++){
	for (var yy = 0; yy < height; yy++){
		_value = map[# xx, yy];
		_c = map_value(_value, low, high, 0, 1)
		_col = make_color_rgb(_c*256, _c*256, _c*256);
		//_col = color_map(_c);
		draw_set_color(_col);
		draw_rectangle(xx*size, yy*size, xx*size+size, yy*size+size, false)
		//draw_set_color(c_red);
		//draw_text(xx*size, yy*size, _c);
	}
}

draw_text(550, 10, option[selection])
for (var i = 0; i < array_length(option); i++){
	draw_text(550, 10+i*16+16, option[i])
	draw_text(500, 10+i*16+16, colors[i])
}

/*
for (var xx = 0; xx < width; xx++){
	for (var yy = 0; yy < height; yy++){
		_value = noise_map[# xx, yy];
		_col = make_color_rgb(_value*128+128, _value*128+128, _value*128+128);
		//_col = color_map(map, xx, yy);
		draw_set_color(_col);
		draw_rectangle(xx*size, yy*size, xx*size+size, yy*size+size, false)
		//draw_set_color(c_red);
		//draw_text(xx*size, yy*size, _c);
	}
}