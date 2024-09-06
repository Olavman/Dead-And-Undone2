
// Pops up a number that moves up and increases in size
function PopupReward(_scoreValue, _x, _y, _lifespan, _curve) constructor
{
	scoreValue = _scoreValue;
	xx = _x;
	yy = _y;
	startY = _y;
	lifespan = _lifespan;
	currentLife = 0;
	curve = _curve;
	
	update = function()
	{
		var _percent = currentLife / lifespan;
		var _yOffset = animcurve_channel_evaluate(curve, _percent) * lifespan/3;
		currentLife++;
		yy = startY - _yOffset - lifespan/2;
		if (currentLife >= lifespan){
			return true;
		}
		return false;
	}
	
	display_number = function()
	{
		var _percent = currentLife / lifespan;
		var _scale = animcurve_channel_evaluate(curve, _percent);
		var _alpha = 1 - _percent;
		draw_set_alpha(_alpha);
		draw_text_transformed(xx, yy, string(scoreValue), _scale, _scale, 0);
		draw_set_alpha(1);
	}
}

function popup_update()
{
	var _len = array_length(global.popup)-1;
	for (var i = _len; i > 0; i--){
		if (global.popup[i] != undefined){
			var done = global.popup[i].update();
			global.popup[i].display_number();
			if (done){
				array_delete(global.popup, i, 1);
			}
		}
	}
}