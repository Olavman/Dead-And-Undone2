
event_inherited();// Parent body

scanRange = 300;
scanTimer = 60+irandom(10);

attackRange = 64;
healRange = 32;
team = 1;

attackCooldown = room_speed*2;
attackTimer = 0;

targetID = noone;
targetsOptions = [];
decision = "";

targetX = 0;
targetY = 0;

scan_targets = function()
{
	targetID = noone;
	decision = "";
	var _list = ds_list_create();
	var _num = collision_circle_list(x, y, scanRange, oBody, false, true, _list, false);
	
	if (_num > 0){
		targetsOptions = array_create(_num);
		
		for (var i = 0; i < _num; i++){
			var _id = _list[|i];
			
			var _weight = 0;
			var _decision = "";
			
			targetsOptions[i] = {id:_id, weight:_weight, decision:_decision};
			
			// Weight variables
			var _distPercent = distance_squared(x, y, _id.x, _id.y)/power(scanRange, 2);
			var _idHpPercent = _id.hp / _id.maxHp;
			var _selfHpPercent = hp/maxHp;
			var _team = abs(_id.team-team);
			
			// Weigh all options (attack, flee, defend, heal, patrol)
			var _attack = _team * _selfHpPercent *power((1-_distPercent), 2);
			var _flee = _team * (1-_selfHpPercent) * _idHpPercent*_distPercent;
			var _heal = (1-_team) * (1-_idHpPercent)*(1-_distPercent);
			var _patrol = (1-_team) * (_idHpPercent)*(_distPercent) *0;
			/*
			show_debug_message(string(id) + " " +string(_attack) + " " + string(_team) + " " + string(_selfHpPercent) + " " + string(power((1-_distPercent), 2)));
			show_debug_message(string(id)+" "+string(_flee)+" "+string((1-_selfHpPercent))+" "+string(_idHpPercent)+" "+string(_distPercent));
			show_debug_message(_heal);
			show_debug_message(_patrol);
			*/
			_weight = max(_attack, _flee, _heal, _patrol);
			
			switch _weight
			{
				case _attack:
					_decision = "attack";
				break;
				
				case _flee:
					_decision = "flee";
				break;
				
				case _heal:
					_decision = "heal";
				break;
				
				case _patrol:
					_decision = "patrol";
					targetX = x + random_range(-64, 64);
					targetY = y + random_range(-64, 64);
				break;
				
				default:
					_decision = "default patrol";
					targetX = x + random_range(-64, 64);
					targetY = y + random_range(-64, 64);
				break;
				
			}
			targetsOptions[i].weight = _weight;
			targetsOptions[i].decision = _decision;
		}
	}
	else decision = "patrol";
	// Clean up list
	ds_list_destroy(_list);
	
	// Find the object with the highest weight and set it as target
	if (_num > 0){
		var _highest = 0;
		
		if (array_length(targetsOptions) > 0){
			for (var i = 0; i < _num; i++){
				if (targetsOptions[i].weight > targetsOptions[_highest].weight) _highest = i;
			}
		}
		if (targetsOptions[_highest].weight != 0){
			targetID = targetsOptions[_highest].id;
			decision = targetsOptions[_highest].decision;
		}
		else decision = "patrol";
	}
}

decision_attack = function()
{
	var _x = targetID.x;
	var _y = targetID.y;
	if(!distance_in_range(x, y, _x, _y, attackRange)){
		move_towards_target_position(_x, _y);
	}
	else if (targetID.hp > 0) {
		if (attackTimer >= attackCooldown){
			//attack
			targetID.hp --;
			
			attackTimer = 0;
		}
		else attackTimer++;
	}
	else scan_targets();
}

decision_heal = function()
{
	var _x = targetID.x;
	var _y = targetID.y;
	if(!distance_in_range(x, y, _x, _y, healRange)){
		move_towards_target_position(_x, _y);
	}
	else if (targetID.hp < targetID.maxHp) targetID.hp+=0.01;
	else scan_targets();
}

decision_flee = function()
{
	var _x = x + (x-targetID.x);
	var _y = y + (y-targetID.y);
	move_towards_target_position(_x, _y);
}

decision_patrol = function()
{
	move_towards_target_position(targetX, targetY);
}