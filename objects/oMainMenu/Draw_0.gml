// dynamically get width and height of menu
var _newWidth = 0;
for (var i = 0; i < opLength; i++){
	_newWidth = max(_newWidth, string_width(option[menuLvl][i]))
}
width = opBorder*2 + _newWidth;
height = opBorder*2 + string_height(option[menuLvl][0]) + (opLength-1)*opSpace

// center menu
x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])/2 - width/2;
y = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])/2 - height/2;

// Draw the menu background
draw_sprite_ext(sprite_index, image_index, x, y, width/sprite_width, height/sprite_height, 0, c_white, 1);

// Draw the options
draw_set_font(global.fontMain);
draw_set_valign(fa_top);
draw_set_halign(fa_left);
for (var i = 0; i < opLength; i++){
	var _c = c_white;
	if (i == selection) _c = c_yellow;
	draw_text_color(x+opBorder, y+opBorder +opSpace*i, option[menuLvl][i], _c, _c, _c, _c, 1);
}
