// Use the sorted list as needed, for example, iterate through the sorted list and display the spd values

	
// Start movement of selected piece
if (ready){
	ready = false;
	if (instance_exists(turnOrder[| currTurn])) {
		turnOrder[| currTurn].selected = true;
		start[0] = turnOrder[| currTurn].gridX;
		start[1] = turnOrder[| currTurn].gridY;
		choose_target(turnOrder[| currTurn]);
	}
	found = false;
	pathfind(100);
	show_debug_message(path)
	move();
	currTurn = wrap_value(currTurn+1, 0, instance_number(oPiece)-1);
	deselect_pieces();
//	turnOrder[| currTurn].selected = true;

var player_x = start[0];
var player_y = start[1];
var enemy_x = goal[0];
var enemy_y = goal[1];
var has_line_of_sight = line_of_sight(player_x, player_y, enemy_x, enemy_y, oPiece);

if (has_line_of_sight) {
    show_debug_message("Line of sight is clear!");
} else {
    show_debug_message("Line of sight is blocked!");
}

}

