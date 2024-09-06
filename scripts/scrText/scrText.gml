function scr_set_defaults_for_text()
{
	lineBreakPos[0, pageNumber] = 999;
	lineBreakNumber[pageNumber] = 0;
	lineBreakOffset[pageNumber] = 0;
	
	// Variables of every letter/character
	for (var c = 0; c < 500; c++){
		col1[c, pageNumber] = c_white;
		col2[c, pageNumber] = c_white;
		col3[c, pageNumber] = c_white;
		col4[c, pageNumber] = c_white;
		
		floatText[c, pageNumber] = 0;
		floatDir[c, pageNumber] = c*20;
		floatAmp[c, pageNumber] = 1;
		floatFreq[c, pageNumber] = 1;
		
		shakeText[c, pageNumber] = 0;
		shakeDir[c, pageNumber] = irandom(360);
		shakeTimer[c, pageNumber] = irandom(4);
	}
	
	textboxSprite[pageNumber] = sTextbox;
	speakerSprite[pageNumber] = noone;
	speakerSide[pageNumber] = 1;
	sound[pageNumber] = sndSpeak;
}

// Text VFX
/// @param [1st char]
/// @param [last char]
/// @param [col1]
/// @param [col2]
/// @param [col3]
/// @param [col4]
function scr_text_color(_start, _end, _col1, _col2, _col3, _col4)
{
	for (var c = _start; c <= _end; c++){
		col1[c, pageNumber-1] = _col1;	// Top left
		col2[c, pageNumber-1] = _col2;	// Top right
		col3[c, pageNumber-1] = _col3;	// Bot right
		col4[c, pageNumber-1] = _col4;	// Bot left
	}
}

/// @param [1st char]
/// @param [last char]
/// @param [amp]
/// @param [freq]
function scr_text_float(_start, _end, _amp, _freq)
{
	for (var c = _start; c <= _end; c++){
		floatText[c, pageNumber-1] = true;
		floatAmp[c, pageNumber-1] = _amp;
		floatFreq[c, pageNumber-1] = _freq;
	}
}

/// @param [1st char]
/// @param [last char]
/// @param [amp]
/// @param [freq]
function scr_text_shake(_start, _end, _amp, _freq)
{
	for (var c = _start; c <= _end; c++){
		shakeText[c, pageNumber-1] = true;
		shakeAmp[c, pageNumber-1] = _amp;
		shakeFreq[c, pageNumber-1] = _freq;
	}
}

/// @param text
/// @param [character]
/// @param [side 1 or -1]
function scr_text(_text)
{
	scr_set_defaults_for_text();
	
	text[pageNumber] = _text;
	
	// Get character info
	if (argument_count > 1){
		switch (argument[1])
		{
			case "npc 1" :
			speakerSprite[pageNumber] = sCharacter1Speak;	// portrait image
			// textbox image
			// sound
			break;
			
			case "npc 1 happy" :
			speakerSprite[pageNumber] = sCharacter1Smile;
			break;
			
			default :
			speakerSprite[pageNumber] = sPlayerSpeak;
			break;
		}
	}
	
	// Side the character is on
	if (argument_count > 2){
			speakerSide[pageNumber] = argument[2];
	}
	pageNumber++;
}

/// @param text_id
function create_textbox(_textId)
{
	with (instance_create_depth(0, 0, -999, oTextbox)){
		scr_game_text(_textId);
	}
}



/// @param option
/// @param link_id
function scr_option(_option, _linkId){
	option[optionNumber] = _option;
	optionLinkId[optionNumber] = _linkId;
	
	optionNumber++;
}

/// @param text_id
function scr_game_text(_textId)
{
	switch (_textId)
	{
		case "npc 1":
		scr_text("I'm npc 1", "npc 1");
			scr_text_color(4, 8, c_red, c_red, c_green, c_green);
		scr_text("So you're npc 1 huh?");
			scr_text_shake(16, 20, 1, 4);
			scr_text_float(16, 20, 6, 4);
		scr_text("That's true. Is that surprising?", "npc 1");
		scr_option("No, not really", "npc 1 - no");
		scr_option("Yeah, I had no idea!", "npc 1 - yes");
		break;
			
			case "npc 1 - no":
			scr_text("Well then why did you ask", "npc 1");
			break;
			
			case "npc 1 - yes":
			scr_text("You're awsome aswell :D", "npc 1 happy");
			break;
		
		case "npc 2":
		scr_text("Hi dude! I'm npc 2");
		scr_text("Just like npc 1, I also have a second line");		
		break;
		
		case "npc 3":
		scr_text("Don't pay attention to npc 1 and 2");
		scr_text("I have not only one or two lines of text");
		scr_text("Not even 3 lines");
		scr_text("But 4 lines of text!");
		break;
		
		default:
		break;
	}
}
