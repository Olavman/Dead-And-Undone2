width = 64*2;
height = 36*2;
amp = 1;
map = ds_grid_create(width, height);
low = 0;
high = 0;

colors =[0.35, 0.45, 0.48, 0.6, 0.75];

option = ["dark blue", "blue", "yello", "green", "grey"];
selection = 0;
//randomize();

// Fill the grid with a value
fill_map = function(_map, _amp)
{
	for (var xx = 0; xx < ds_grid_width(map); xx++){
		for (var yy = 0; yy < ds_grid_height(map); yy++){
			_map[# xx, yy] = random_range(-_amp, _amp);
			//_map[#xx, yy] = map_value(_map[#xx, yy], -amp, amp, 0, 1);
		}
	}
}

// Average all the cells in the map
average_map = function(_map)
{
	low = amp;
	high = -amp;
	var _width = ds_grid_width(_map);
	var _height = ds_grid_height(_map);
	var _average = ds_grid_create(_width, _height)
	for (var xx = 0; xx < _width; xx++){
		for (var yy = 0; yy < _height; yy++){
			_average[# xx, yy] = check_surroundings(_map, xx, yy);
			//_average[# xx, yy] = lerp(_map[# xx, yy], _map[# xx, yy], 0.2)
		}
	}
	for (var xx = 0; xx < _width; xx++){
		for (var yy = 0; yy < _height; yy++){
			_map[# xx, yy] =  _average[# xx, yy];
			if (_map[# xx, yy] > high) {
				high = _map[# xx, yy];
			}
			if (_map[# xx, yy] < low) {
				low = _map[# xx, yy];
			}
		}
	}
	ds_grid_destroy(_average);
}

// Get the average value of a single cell
check_surroundings = function(_map, xx, yy)
{
	var _average = 0;
	var _count = 0;
	for (var i = -1; i <= 1; i++){
		for (var j = -1; j <= 1; j++){
			// If outside the grid - continue
			if (xx+i < 0 || xx+i >= ds_grid_width(_map) || yy+j < 0 || yy+j >= ds_grid_height(_map)){
				continue;
			}
			// Add value to get average
			_average += _map[# xx+i, yy+j]//*(1+(abs(i)/2)*(abs(j)/2));
			//show_debug_message(_map[# xx+i, yy+j]*(1+(abs(i)*0.6)*(abs(j)*0.6)))
			_count++;
		}
	}
	_average /= _count;
	return _average;
}


// Choose color
color_map = function(_value)
{
	var _col = c_white;
	if (_value < colors[0]){
		_col = make_color_rgb(0, 0, 128);
	}
	else if (_value < colors[1]){
		_col = c_blue;
	}
	else if (_value < colors[2]){
		_col = c_yellow;
	}
	else if (_value < colors[3]){
		_col = c_green;
	}
	else if (_value < colors[4]){
		_col = c_grey;
	}
	else {
		_col = c_white;
	}
	return _col;
}
fill_map(map, amp);
/*

// Set the width and height of the noise map
 width = 128;
 height = 68;

// Set the frequency and amplitude of the noise
 frequency = 0.1;
 amplitude = 0.8;

// Create a new ds_grid to hold the noise values
 noise_map = ds_grid_create(width, height);
_noise_map = ds_grid_create(width, height);

// Fill the noise map with random values between -1 and 1
for (var xx = 0; xx < width; xx++) {
    for (var yy = 0; yy < height; yy++) {
        //var random_value = random_range(-1, 1);
       // ds_grid_set(noise_map, xx, yy, random_value);
		noise_map[# xx, yy] = random_range(-1, 1);
    }
}

// Interpolate between two values using cosine interpolation
cosine_interp = function(a, b, xx) {
    var ft = xx * 3.1415927;
    var f = (1 - cos(ft)) * 0.5;
    return a*(1-f) + b*f;
}


// Generate the noise map using Perlin noise
for (var xx = 0; xx < width; xx++) {
    for (var yy = 0; yy < height; yy++) {
        // Calculate the four corner points for the grid cell
        var x0 = (xx * frequency);
        var x1 = x0 + 1;
        var y0 = floor(yy * frequency);
        var y1 = y0 + 1;
        var xf = xx * frequency - x0;
        var yf = yy * frequency - y0;

        // Interpolate between the four corner points
        var v1 = ds_grid_get(noise_map, x0, y0);
        var v2 = ds_grid_get(noise_map, x1, y0);
        var v3 = ds_grid_get(noise_map, x0, y1);
        var v4 = ds_grid_get(noise_map, x1, y1);
        var i1 = cosine_interp(v1, v2, xf);
        var i2 = cosine_interp(v3, v4, xf);
        var i3 = cosine_interp(i1, i2, yf);

        // Set the noise value for this point
        var noise_value = amplitude * i3;
        ds_grid_set(_noise_map, xx, yy, noise_value);
    }
}
for (var xx = 0; xx < width; xx++){
	for (var yy = 0; yy < height; yy++){
		noise_map[#xx, yy] = _noise_map[#xx, yy];
	}
}