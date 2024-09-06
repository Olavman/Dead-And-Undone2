width = 64;
height = 104;

opBorder = 8;
opSpace = 16;
	
opLength = 0;
selection = 0;
locked = false;
increment = 0;
slider = noone;

menuLvl = 0;

// menu enums
#region
enum MENULVL
{
	MAINMENU,
	SETTINGS,
	SOUND,
	WINDOW_SIZE,
	EXIT_GAME
}

enum MAINMENU
{
	START_GAME,
	LOAD_GAME,
	SETTINGS,
	ABOUT,
	EXIT_GAME
}

enum SETTINGS
{
	FULLSCREEN,
	WINDOW_SIZE,
	BRIGHTNESS,
	SOUND,
	CONTROLS,
	BACK
}

enum SOUND
{
	MAIN_VOLUME,
	MUSIC_VOLUME,
	EFFECTS_VOLUME,
	BACK
}

enum WINDOW_SIZE
{
	LARGE,
	MEDIUM,
	SMALL,
	BACK
}

enum EXIT_GAME
{
	YES,
	NO
}
#endregion

// menu options
#region
// main menu
option [MENULVL.MAINMENU] = [
	"Start game",
	"Load game",
	"Settings",
	"About",
	"Exit game"];
	
// settings menu
option[MENULVL.SETTINGS] = [
	"Fullscreen",
	"Window size",
	"Brightness",
	"Sound",
	"Controls",
	"Back"];
	
// Sound menu
option[MENULVL.SOUND] = [
	"Main volume",
	"Music volume",
	"Effects volume",
	"Back"];

// window size menu
option[MENULVL.WINDOW_SIZE] = [
	"1280 X 720",
	"640 X 360",
	"320 X 180",
	"Back"];

// exit menu
option[MENULVL.EXIT_GAME] = [
	"Yes",
	"No"];
#endregion

/*
// Define a variable to hold the player's name
playerName = "";
