if (open) {
	x = camera_get_view_x(view) + xOffset;
	y = camera_get_view_y(view) + yOffset;
	draw_inventory();
}
//inv_display_inventory(inventory, invWidth, invHeight, x, y, 64, 5);
inv_display_inventory(pickedItem, 1, 1, mouse_x, mouse_y, 64, 0, false);

draw_text(10, 10, xOffset);
draw_text(10, 20, yOffset);
