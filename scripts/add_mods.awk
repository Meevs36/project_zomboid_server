#! /bin/awk -f
# Author -- meevs
# Creation Date -- 2024-04-28
# File Name -- add_mods.awk
# Notes --

BEGIN {
	MOD_NAMES=ENVIRON["MOD_NAMES"];
	MOD_IDS=ENVIRON["MOD_IDS"];
}

/Mods=.*/ { 
	gsub (/Mods=.*/, "Mods=" MOD_NAMES);
}

/WorkshopItems=.*/ { 
	gsub (/WorkshopItems=.*/, "WorkshopItems=" MOD_IDS);
}

{ print $0 }

