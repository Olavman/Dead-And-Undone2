function display_hp (_x, _y, _width, _height, _hp, _maxHp)
{
	var _hpWidth = (_hp/_maxHp)*_width;
	draw_rectangle(_x, _y, _x+_width, _y+_height, true);
	draw_set_color(c_green);
	draw_rectangle(_x, _y, _x+_hpWidth, _y+_height, false);
	draw_set_color(c_white);
}