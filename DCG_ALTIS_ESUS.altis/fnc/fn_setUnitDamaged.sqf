/*
Author: SENSEI

Last modified: 10/3/2015

Description: set unit in cardiac arrest

Note: needs delay if called directly after spawning unit

Return: nothing
__________________________________________________________________*/
private ["_unconsciousTime","_selection"];

params ["_unit"];

if (ace_medical_level isEqualTo 1) then {
	_unconsciousTime = 120 + round (random 600);
	//[_unit, 0.5] call ace_medical_fnc_adjustPainLevel;
	[_unit,true,_unconsciousTime,true] call ace_medical_fnc_setUnconscious;
	_selection = [
	    "head",
	    "body",
	    "hand_l",
	    "hand_r",
	    "leg_l",
	    "leg_r"
	];
	_type = [
	    "bullet",
	    "grenade",
	    "explosive",
	    "shell"
	];
	for "_i" from 0 to 2 do {
		[_unit, (_selection select (random ((count _selection) - 1))), 0.7 + (random 0.15), objNull, (_type select (random ((count _type) - 1)))] call ace_medical_fnc_handleDamage;
		//[_unit, (_selection select (random ((count _selection) - 1))), 0.7 + (random 0.15)] call ace_medical_fnc_setHitPointDamage;
	};
	[{
		params ["_args","_id"];
		_args params ["_unit","_time"];

		if (diag_tickTime > _time) exitWith {
			[_id] call CBA_fnc_removePerFrameHandler;
			if !([_unit] call ace_common_fnc_isAwake) then {
				_unit setDamage 1;
			};
		};
	}, 1, [_unit,diag_tickTime + _unconsciousTime]] call CBA_fnc_addPerFrameHandler;
} else {
	[_unit, 0.5] call ace_medical_fnc_adjustPainLevel;
	[_unit,true,10,true] call ace_medical_fnc_setUnconscious;
	[_unit] call ace_medical_fnc_setCardiacArrest;
	_selection = [
	    "head",
	    "body",
	    "hand_l",
	    "hand_r",
	    "leg_l",
	    "leg_r"
	];
	_type = [
	    "bullet",
	    "grenade",
	    "explosive",
	    "shell"
	];
	[_unit, (_selection select (random ((count _selection) - 1))), 0, objNull, (_type select (random ((count _type) - 1))), 0, 0.2] call ace_medical_fnc_handleDamage_advanced;
};

/*
_unit = (createGroup CIVILIAN) createUnit [SEN_unitPoolCiv select floor (random (count SEN_unitPoolCiv)),player modeltoworld [0,4,0], [], 0, "NONE"];
_unit disableAI "MOVE";
sleep 3;
[_unit] call SEN_fnc_setUnitDamaged;

ID = [{
	params ["_args","_id"];
	_args params ["_unit"];

	if ((!alive _unit) || {[_unit] call ace_common_fnc_isAwake}) exitWith {
		[_id] call CBA_fnc_removePerFrameHandler;
		hint "DONE";
	};
	hint format ["PAIN: %1\nOPEN WOUNDS: %2\nBANDAGED WOUNDS: %3\nAWAKE: %4",_unit getvariable ["ace_medical_pain", 0],_unit getvariable ["ace_medical_openwounds", []],_unit getvariable ["ace_medical_bandagedwounds", []],[_unit] call ace_common_fnc_isAwake];
}, 1, [_unit]] call CBA_fnc_addPerFrameHandler;
*/