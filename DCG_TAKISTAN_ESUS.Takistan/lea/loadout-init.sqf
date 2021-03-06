/**
* Generated by LEA for Arma 3
* Version: 2.0.23
* Init call for loadout scripts.
* 
* Call the script: leaFunction =  compile preprocessFileLineNumbers "lea\loadout-init.sqf"; call leaFunction;
* 
*/

enable_lea_addon = false;

_dummy = [] execVM "lea\apply_loadout.sqf";

if (!isMultiplayer) exitWith {
	_dummy = [] execVM "lea\loadoutSingleplayer.sqf";
	waitUntil{scriptDone _dummy};
};

if (isServer) then {
	_dummy = [] execVM "lea\loadoutServer.sqf";
	waitUntil{scriptDone _dummy};
};

if (!isDedicated) then {
	if (player != player) then {
		waitUntil {player == player};
	};

	waitUntil {local player};

	[] spawn {
		_lastcorps = player;
		_dummy = [] execVM "lea\loadoutMultiplayer.sqf";
		waitUntil{scriptDone _dummy};
		while {true} do {
			if (player != _lastcorps) then{
				_dummy = [] execVM "lea\loadoutMultiplayer.sqf";
				waitUntil{scriptDone _dummy};
				_lastcorps = player;
			};
			sleep 1;
		};
	};
};
