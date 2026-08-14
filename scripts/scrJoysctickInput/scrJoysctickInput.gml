function scrJoysctickInput(joydir){
	
	//if abs(270-joydir)<65{input_down=true}
	if abs(90-joydir)<65{key_jump=true}
	if abs(180-joydir)<65{key_left=true}
	if ((joydir<60) or joydir>295){key_right=true}
}