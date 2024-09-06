recipes_initialize();
global.popup = array_create(1);
global.rewardMissCurve = animcurve_get_channel(acCurves, "rewardMiss");
global.rewardPoorCurve = animcurve_get_channel(acCurves, "rewardPoor");
global.rewardFairCurve = animcurve_get_channel(acCurves, "rewardFair");
global.rewardGoodCurve = animcurve_get_channel(acCurves, "rewardGood");
global.rewardGreatCurve = animcurve_get_channel(acCurves, "rewardGreat");