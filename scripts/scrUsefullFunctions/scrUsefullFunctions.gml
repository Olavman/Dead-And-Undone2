// Map a value from one range to another
function map_value(_value, _current_lower_bound, _current_upper_bound, _desired_lowered_bound, _desired_upper_bound) {
    return (((_value - _current_lower_bound) / (_current_upper_bound - _current_lower_bound)) * (_desired_upper_bound - _desired_lowered_bound)) + _desired_lowered_bound;
}

// Wrap a value around an upper and lower limit
function wrap_value(_value, _lowerLimit, _upperLimit)
{
	var _difference = _upperLimit-_lowerLimit;
	if (_difference == 0) return false;
	while (_value > _upperLimit) _value -= _difference;
	while (_value < _lowerLimit) _value += _difference;
	return _value;
}

// Toggle a value when an upper or lower limit is reached
function toggle_value(_toggle, _value, _lowerLimit, _upperLimit){
	if (_value >= _upperLimit ) return -1;
	else if (_value <= _lowerLimit ) return 1;
	else return _toggle;
}

// Normalize a value 
function normalize_value(value, minValue, maxValue) {
    return (value - minValue) / (maxValue - minValue);
}

// Find the squared distance to a point
function distance_squared(x1, y1, x2, y2){
	var _distanceSquared = power(abs(x1-x2), 2) + power(abs(y1-y2), 2);
	return _distanceSquared;
}

// Checks if 2 points are within a distance
function distance_in_range(x1, y1, x2, y2, _dst){
	if (distance_squared(x1, y1, x2, y2) <= power(_dst, 2)) return true;
	else return false;
}