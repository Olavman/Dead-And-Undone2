// Initiate minigame
if (!oInv.open && resourceRemaining > 0 && distance_in_range(x, y, oPlayer.x, oPlayer.y, detectionRange)) playingMinigame = true;
else playingMinigame = false;

// Replenish recoures
if (resourceRemaining < maxResource && lastHarvested < date_current_datetime()-respawnTime) {
	resourceRemaining++;
	lastHarvested = date_current_datetime();
}