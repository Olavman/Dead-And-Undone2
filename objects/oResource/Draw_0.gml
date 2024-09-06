// Inherit the parent event
event_inherited();

if (playingMinigame) {
	play_minigame_1(oPlayer);
	//play_minigame_2(oPlayer);
	display_resource_remaining();
}

draw_text(oPlayer.x + 10, oPlayer.y+40, minigameMarker)