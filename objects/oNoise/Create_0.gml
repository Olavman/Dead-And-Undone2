width = 40;
height = 22;
gridSize = 16;
low = 1;
high = 0;
map = ds_grid_create(width, height);
loopX = 6/width;
loopY = 6/height;
loops = 20;
randomize();
colors =[0.34, 0.36, 0.91, 0.991];

// Generate noise map
generate_noise = function(xFreq, yFreq, _amp)
{ 
	var startY = random_range(0, 60);
	var startY = 0;
	var offY = startY;
	for (var xx = 0; xx < width; xx++){
		offY = startY+xFreq*xx;
		for (var yy = 0; yy < height; yy++){
			offY += yFreq;
			map[# xx, yy] += sin(offY)*_amp;
			if (map[# xx, yy] > high) high = map[#xx, yy];
			else if (map[# xx, yy] < low) low = map[#xx, yy];
		}
	}
}

// Choose color
color_map = function(_value)
{
	var _col = c_white;
	if (_value < colors[0]){
		_col = make_color_rgb(0, 0, 255*_value);
	}
	else if (_value < colors[1]){
		_col = make_color_rgb(255*(_value/3), 255*(_value/2), 0)
	}
	else if (_value < colors[2]){
		_col = make_color_rgb(0, 255*(_value/2), 0)
	}
	else if (_value < colors[3]){
		_col = make_color_rgb(180*(_value/1), 180*(_value/1), 180*(_value/1))
	}
	else {
		_col = c_white;
	}
	return _col;
}

restart = function()
{
	for (var i = 0; i < width; i++){
		for (var j = 0; j < height; j++){
			map[#i, j] = 0;
		}
	}
	var _total = 0.5;
	var _x = random_range((_total/2)-_total, _total/2);
	var _y = (_total-abs(_x))*sign(_x)*-1;
	var _amp = 2;
	for (var i = 0; i < loops; i++){
		generate_noise(loopX*_x, loopY*_y, _amp);
		show_debug_message("_total " + string(_total) +" x = " + string(_x) + " y = " + string(_y) + " amp = " + string(_amp))
		if (i mod (3) == 0){
			_total *= 2;
			_amp *= 0.5;
		}
		_x = random_range((_total/2)-_total, _total/2);
		_y = (_total-abs(_x))*sign(_x)*-1;
	}
}
