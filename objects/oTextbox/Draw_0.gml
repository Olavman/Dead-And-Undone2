acceptKey = keyboard_check_pressed(vk_control);
keyUp = keyboard_check_pressed(vk_up);
keyDown = keyboard_check_pressed(vk_down);

textboxX = camera_get_view_x(view_camera[0]);
textboxY = camera_get_view_y(view_camera[0]) + offY;

// Setup
if (!setup){
	setup = true;
	draw_set_font(global.fontMain);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	
	// Loop through the pages
	for (var p = 0; p < pageNumber; p++){
		// Find how many characters are on each page and store that number in the "textLength" array
		textLength[p] = string_length(text[p]);
		
		// Get the x position for the textbox
		// Character on the left
		textXOffset[p] = 80;
		portraitXOffset[p] = 8;
		// Character on the right
		if (speakerSide == -1){
			textXOffset[p] = 8;
			portraitXOffset[p] = 216;
		}
		
		// If no character then center textbox
		if (speakerSprite[p] == noone){
			textXOffset[p] = (camera_get_view_width(view_camera[0])-width)/2;
		}
		
		// Setting individual characters and finding where the lines should break
		for (var c = 0; c < textLength[p]; c++){
			var _charPos = c+1;
			
			// Store individual characters in the "char" array
			char[c, p] = string_char_at(text[p], _charPos);
			
			// Get current width of the line
			var _textUpToChar = string_copy(text[p], 1, _charPos);
			var _currentTextW = string_width(_textUpToChar) - string_width(char[c, p]);
			
			// Get the last free space
			if (char[c, p] == " "){
				lastFreespace = _charPos+1;
			}
			
			// Get the line breaks
			if (_currentTextW - lineBreakOffset[p] > lineWidth){
				lineBreakPos[lineBreakNumber[p], p] = lastFreespace;
				lineBreakNumber[p]++;
				var _textUpToLastSpace = string_copy(text[p], 1, lastFreespace);
				var _lastFreeSpaceString = string_char_at(text[p], lastFreespace);
				lineBreakOffset[p] = string_width(_textUpToLastSpace) - string_width(_lastFreeSpaceString);
			}
		}
		
		// Getting each characters coordinates
		for (var c = 0; c < textLength[p]; c++){
			var _charPos = c+1;
			var _textX = textboxX + textXOffset[p] + border;
			var _textY = textboxY + border;
			
			// Get current width of the line
			var _textUpToChar = string_copy(text[p], 1, _charPos);
			var _currentTextW = string_width(_textUpToChar) - string_width(char[c, p]);
			var _textLine = 0;
			
			// Compensate for string breaks
			for (var lb = 0; lb < lineBreakNumber[p]; lb++){
				// If the current looping character is after a line break
				if (_charPos >= lineBreakPos[lb, p]){
					var _strCopy = string_copy(text[p], lineBreakPos[lb, p], _charPos - lineBreakPos[lb, p]);
					_currentTextW = string_width(_strCopy);
					
					// Record the "line" this character should be on
					_textLine = lb+1; // +1 since lb starts at 0
				}
			}
			// Add to the x and y coordinates based on our new info
			charX[c, p] = _textX + _currentTextW;
			charY[c, p] = _textY + _textLine*lineSpace;
		}
	}
}
	
// Typing the text
#region
if (textPauseTimer <= 0){
	if (drawChar < textLength[page]){
		drawChar += textSpd;
		drawChar = clamp(drawChar, 0, textLength[page]);
		var _checkChar = string_char_at(text[page], drawChar);
		if (_checkChar == "." || _checkChar == "!" || _checkChar == "?"){
			textPauseTimer = textPauseTime;
			if (!audio_is_paused(sound[page])){
				audio_play_sound(sound[page], 8, false);
			}
		}
		else if (_checkChar == ","){
			textPauseTimer = textPauseTime/2;
			if (!audio_is_paused(sound[page])){
				audio_play_sound(sound[page], 8, false);
			}
		}
		else {
			// Typing sound
			if (soundCount < soundDelay){
				soundCount++;
			}
			else {
				soundCount = 0;
				audio_play_sound(sound[page], 8, false);
			}
		}
	}
}
else {
	textPauseTimer--;
}
#endregion

// Flip through pages
if (acceptKey){
	// If the typing is done, go to the next page
	if (drawChar == textLength[page]){
		// Next page
		if (page < pageNumber -1){
			page++;
			drawChar = 0;
		}
		// Destroy the textbox
		else {
			// Link text for options
			if (optionNumber > 0){
				create_textbox(optionLinkId[optionSelection]);
			}
			instance_destroy();
		}
	}
	// If not done typing, fill out the page
	else{
		drawChar = textLength[page];
	}
}

// Draw the textbox
#region
textboxImg += textboxImgSpd;
textboxSpriteW = sprite_get_width(textboxSprite[page]);
textboxSpriteH = sprite_get_height(textboxSprite[page]);
var _textbX = textboxX + textXOffset[page];
var _textbY = textboxY;
var _arrowOffset = 16;
// Draw the speaker
if (speakerSprite[page] != noone){
	sprite_index = speakerSprite[page];
	if (drawChar == textLength[page]){
		image_index = 0;
	}
	var _speakerX = textboxX + portraitXOffset[page];
	if (speakerSide[page] == -1){
		_speakerX += sprite_width;
	}
	// Draw the speaker
	draw_sprite_ext(textboxSprite[page], textboxImg, textboxX + portraitXOffset[page], textboxY, sprite_width/textboxSpriteW, sprite_height/textboxSpriteH, 0, c_white, 1);
	draw_sprite_ext(sprite_index, image_index, _speakerX, textboxY, speakerSide[page], 1, 0, c_white, 1);
}
// Back of the textbox
draw_sprite_ext(textboxSprite[page], textboxImg, _textbX, _textbY, width/textboxSpriteW, height/textboxSpriteH, 0, c_white, 1);

// Options
if (drawChar == textLength[page] && page == pageNumber-1){
	// Option selection
	optionSelection += keyboard_check_pressed(keyDown) - keyboard_check_pressed(keyUp);
	optionSelection = clamp(optionSelection, 0, optionNumber-1);
	
	// Draw the options
	var _opSpace = lineSpace+6;
	var _opBorder = 4;
	for (var op = 0; op < optionNumber; op++){
		// The option box
		var _opW = string_width(option[op]) + _opBorder*2;
		draw_sprite_ext(textboxSprite[page], textboxImg, _textbX + _arrowOffset, _textbY - _opSpace*optionNumber + _opSpace*op, _opW/textboxSpriteW, (_opSpace-1)/textboxSpriteH, 0, c_white, 1);
		
		// The arrow
		if (optionSelection == op){
			draw_sprite(sTextboxArrow, 0, _textbX, _textbY - _opSpace*optionNumber + _opSpace*op);
		}
		
		// The option text
		draw_text(_textbX + _arrowOffset + _opBorder, _textbY - _opSpace*optionNumber + _opSpace*op + 2, option[op])
	}
}

// Draw the text
for (var c = 0; c < drawChar; c++){
	
	// Special stuff
	// Wavy text
	var _floatY = 0;
	if (floatText[c, page] == true){
		floatDir[c, page] += -floatFreq[c, page];
		_floatY = dsin(floatDir[c, page]) * floatAmp[c, page];
	}
	// Shake text
	var _shakeX = 0;
	var _shakeY = 0;
	if (shakeText[c, page] == true){
		shakeTimer[c, page]--;
		if (shakeTimer[c, page] <= 0){
			shakeTimer[c, page] = irandom_range(shakeFreq[c, page]-2, shakeFreq[c, page]+2);
			shakeDir[c, page] = irandom(360);
		}
		if (shakeTimer[c, page] <= 2){
			_shakeX = lengthdir_x(shakeAmp[c, page], shakeDir[c, page]);
			_shakeY = lengthdir_y(shakeAmp[c, page], shakeDir[c, page]);
		}
	}
	
	// The text
	draw_text_color(charX[c, page] + _shakeX, charY[c, page] + _floatY + _shakeY, char[c, page], col1[c, page], col2[c, page], col3[c, page], col4[c, page], 1);
}
#endregion
