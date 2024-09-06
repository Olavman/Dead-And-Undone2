#macro view view_camera[0]

viewWidth = 1920/3;
viewHeight = 1080/3;

followTarget = oPlayer;

windowScale = 2;

// Screen shake variables
shakeAmount = 0;
shakeDuration = 0;
shakeDecreaseFactor = 1;

screen_shake = function(_amount, _duration, _decreaseFactor) {
    shakeAmount = _amount;
    shakeDuration = _duration;
    shakeDecreaseFactor = _decreaseFactor;
}

resize = function(){
	window_set_size(viewWidth*windowScale, viewHeight*windowScale);
	alarm[0] = 1;

	surface_resize(application_surface, viewWidth*windowScale, viewHeight*windowScale);
}

follow_target = function ()
{
	var _x = clamp(followTarget.x - viewWidth/2, 0, room_width-viewWidth);
	var _y = clamp(followTarget.y - viewHeight/2, 0, room_height-viewHeight);
	
	var _currX = camera_get_view_x(view);
	var _currY = camera_get_view_y(view);
	
	var _spd = 0.1;
	
	// Apply shake effect
    if (shakeDuration > 0) {
        _currX += random_range(-shakeAmount, shakeAmount);
        _currY += random_range(-shakeAmount, shakeAmount);
        shakeDuration--;
        shakeAmount *= shakeDecreaseFactor;
    }
	
	camera_set_view_pos(view,
		lerp(_currX, _x, _spd),
		lerp(_currY, _y, _spd));
}
resize();