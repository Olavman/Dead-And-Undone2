event_inherited();// Parent body

if (get_timer() mod scanTimer == 0){
	scan_targets();
	show_debug_message(id);
	show_debug_message(decision);
}

switch decision{
	case "heal":
		decision_heal();
	break;
	
	case "attack":
		decision_attack();
	break;
	
	case "flee":
		decision_flee();
	break;
	
	case "patrol":
		decision_patrol();
	break;
	
	default:
	break;
}