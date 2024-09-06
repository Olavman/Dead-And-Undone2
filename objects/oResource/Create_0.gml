// Resource variables
detectionRange = sprite_height*1.4;
maxResource = 3;
resourceRemaining = 3;
lastHarvested = date_current_datetime();
respawnTime =room_speed*0.000001;

// Minigame variables
playingMinigame = true;
minigameVariation = 0;
minigameMarker = random(1);
minigameTarget = random(1);
minigameToggle = 1;

// Reward variables
baseScore = 0;
finalScore = 0;
rewardScore = 0;
rewardMultiplier = 3;

rewardCurve1 = animcurve_get_channel(acCurves, "rewardCurve1");
rewardCurve2 = animcurve_get_channel(acCurves, "rewardCurve2");

reward = function(_source)
{
	var _toolQualityBonus = 100;
	var _skillPointBonus = 50;
	finalScore = baseScore * (0.8 + (_toolQualityBonus + _skillPointBonus) * 0.002);
	rewardScore += finalScore;
	
	var _x = _source.x;
	var _y = _source.y-_source.sprite_height;
	var _lifespan = room_speed/2;
	if (finalScore <= 0.1){
		array_push(global.popup, new PopupReward("Miss", _x, _y, _lifespan*0.8, global.rewardMissCurve));
		oCamera.screen_shake(15 * finalScore/2, 10 * finalScore/2, 0.5);
	}
	else if (finalScore < 0.25){
		array_push(global.popup, new PopupReward("Poor", _x, _y, _lifespan*0.9, global.rewardPoorCurve));
		oCamera.screen_shake(15 * finalScore/2, 10 * finalScore/2, 0.55);
	}
	else if (finalScore < 0.5){
		array_push(global.popup, new PopupReward("Fair", _x, _y, _lifespan, global.rewardFairCurve));
		oCamera.screen_shake(15 * finalScore/2, 10 * finalScore/2, 0.6);
	}
	else if (finalScore < 0.75){
		array_push(global.popup, new PopupReward("Good", _x, _y, _lifespan*1.3, global.rewardGoodCurve));
		oCamera.screen_shake(15 * finalScore/2, 10 * finalScore/2, 0.65);
	}
	else{
		array_push(global.popup, new PopupReward("Great!", _x, _y, _lifespan*2, global.rewardGreatCurve));
		oCamera.screen_shake(15 * finalScore/2, 10 * finalScore/2, 0.7);
	}
	
	if (resourceRemaining == maxResource){
		lastHarvested = date_current_datetime();
	}
	
	resourceRemaining--;
	inv_add_item(oInv.inventory, new Wood(), floor(rewardScore*rewardMultiplier), true);
	rewardScore = wrap_value(rewardScore*rewardMultiplier, 0, 1);
	show_debug_message(rewardScore)
}

play_minigame_1 = function(_source)
{
	var _minigameWidth = 32;
	var _minigameHeight = 10;
	var _minigameDuration = 0.5;
	var _x = _source.x-16;
	var _y = _source.y-42;
	
	minigameToggle = toggle_value(minigameToggle, minigameMarker, 0, 1);
	minigameMarker += 1/room_speed/_minigameDuration * minigameToggle;
	
	// Draw minigame UI
	draw_sprite_stretched(sMinigame1Background, 0, _x, _y, _minigameWidth+4, _minigameHeight);
	draw_sprite_stretched(sMinigame1Target, 0, _x+_minigameWidth*minigameTarget, _y, 4, _minigameHeight);
	draw_sprite_stretched(sMinigame1Marker, 0, _x+_minigameWidth*minigameMarker, _y, 3, _minigameHeight);
	
	// Calculate minigame score
	if (mouse_check_button_pressed(mb_left)){
		baseScore = max(0, 1- abs(minigameMarker - minigameTarget));
		baseScore = animcurve_channel_evaluate(rewardCurve1, baseScore);
		minigameTarget = random(1);
		reward(_source);
	}
}

play_minigame_2 = function(_source)
{
	var _minigameRadius = 3;
	var _minigameDuration = 2;
	var _reactionTimeBuffer = 2;
	var _x = _source.x-16;
	var _y = _source.y-42;
	var _col = c_green;
	
	minigameMarker += 1/room_speed/_minigameDuration;
	minigameMarker = wrap_value(minigameMarker, 0, 1);
	if (minigameMarker > minigameTarget){
		minigameMarker = 0;
		minigameTarget = random_range(0.5, 1);
	}
	
	// Draw minigame UI
	draw_set_color(_col);
	//draw_circle(_x, _y, _minigameRadius, true);
	draw_set_alpha(1-minigameMarker*5);
	draw_circle(_x, _y, _minigameRadius, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_sprite(sMinigameOre, 0, _x, _y);
	
	// Calculate minigame score
	if (mouse_check_button_pressed(mb_left)){
		baseScore = normalize_value(max(0, _reactionTimeBuffer - minigameMarker), 0, _reactionTimeBuffer);
		baseScore = animcurve_channel_evaluate(rewardCurve2, baseScore);
		minigameTarget = random(1);
		reward(_source);
	}
}

display_resource_remaining = function()
{
	var _x = x+32;
	var _y = y;
	var _displayHeight = sprite_get_height(sMinigame1Resource)+2;
	
	for (var i = 0; i < resourceRemaining; i++){
		draw_sprite(sMinigame1Resource, 0, _x, _y - (_displayHeight*i))
	}
}
