depth = -999;

// Textbox parameters
width = 434;
height = 112;
border = 8;
lineSpace = 16;
lineWidth = width - border*2;
offX = 0;
offY = 240;
textboxSprite[0] = sTextbox;
textboxImg = 0;
textboxImgSpd = 0;

// The text
page = 0;
pageNumber = 0;
text[0] = "";
textLength[0] = string_length(text[0]);
char[0, 0] = "";
charX[0, 0] = 0;
charY[0, 0] = 0;
drawChar = 0;
textSpd = 1;

// Options
option[0] = "";
optionLinkId[0] = -1;
optionSelection = 0;
optionNumber = 0;

setup = false;

// Sound
soundDelay = 4;
soundCount = soundDelay;

// Effects
scr_set_defaults_for_text();
lastFreespace = 0;
textPauseTimer = 0;
textPauseTime = 16;