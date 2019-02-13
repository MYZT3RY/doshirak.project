new Text:td_logo;

new PlayerText:td_speed[MAX_PLAYERS][6];

new PlayerText:td_register[MAX_PLAYERS][18];

new PlayerText:td_authorization[MAX_PLAYERS][5];

new PlayerText:td_free_house[MAX_PLAYERS][7];

new PlayerText:td_owned_house[MAX_PLAYERS][6];

new Text:td_press_alt;

new PlayerText:td_buy_car[MAX_PLAYERS][13];

new PlayerText:td_free_business[MAX_PLAYERS][8];

new PlayerText:td_owned_business[MAX_PLAYERS][7];

LoadTextDraw(){
	//Лого
    td_logo = TextDrawCreate(577.000000, 7.000000, "Doshirak");
	TextDrawAlignment(td_logo, 2);
	TextDrawBackgroundColor(td_logo, C_BLUE);
	TextDrawFont(td_logo, 2);
	TextDrawLetterSize(td_logo, 0.250000, 1.400000);
	TextDrawColor(td_logo,  C_BLUE);
	TextDrawSetOutline(td_logo, 0);
	TextDrawSetProportional(td_logo, 1);
	TextDrawSetShadow(td_logo, 0);
	//Нажать на Alt
	td_press_alt = TextDrawCreate(86.799865, 282.737670, "Press ALT");
	TextDrawLetterSize(td_press_alt, 0.231997, 1.455641);
	TextDrawTextSize(td_press_alt, -114.400016, 55.751125);
	TextDrawAlignment(td_press_alt, 2);
	TextDrawColor(td_press_alt, -1347440641);
	TextDrawUseBox(td_press_alt, true);
	TextDrawBoxColor(td_press_alt, 1419116325);
	TextDrawSetShadow(td_press_alt, 0);
	TextDrawSetOutline(td_press_alt, 1);
	TextDrawBackgroundColor(td_press_alt, 51);
	TextDrawFont(td_press_alt, 1);
	TextDrawSetProportional(td_press_alt, 1);
}

LoadPlayerTextDraw(playerid){
	//Спидометр
    td_speed[playerid][0] = CreatePlayerTextDraw(playerid, 135.199981, 301.659942, "usebox");
	PlayerTextDrawLetterSize(playerid, td_speed[playerid][0], 0.000000, 3.479999);
	PlayerTextDrawTextSize(playerid, td_speed[playerid][0], 38.399978, 0.000000);
	PlayerTextDrawAlignment(playerid, td_speed[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_speed[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_speed[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_speed[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_speed[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_speed[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, td_speed[playerid][0], 1419116325);
	PlayerTextDrawFont(playerid, td_speed[playerid][0], 0);

	td_speed[playerid][1] = CreatePlayerTextDraw(playerid, 41.999973, 312.106658, "fuel:0.0");
	PlayerTextDrawLetterSize(playerid, td_speed[playerid][1], 0.185598, 1.127110);
	PlayerTextDrawAlignment(playerid, td_speed[playerid][1], 1);
	PlayerTextDrawColor(playerid, td_speed[playerid][1], -1347440641);
	PlayerTextDrawSetShadow(playerid, td_speed[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_speed[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, td_speed[playerid][1], 51);
	PlayerTextDrawFont(playerid, td_speed[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, td_speed[playerid][1], 1);

	td_speed[playerid][2] = CreatePlayerTextDraw(playerid, 42.000038, 301.155517, "0km/h");
	PlayerTextDrawLetterSize(playerid, td_speed[playerid][2], 0.181198, 1.181866);
	PlayerTextDrawAlignment(playerid, td_speed[playerid][2], 1);
	PlayerTextDrawColor(playerid, td_speed[playerid][2], -1347440641);
	PlayerTextDrawSetShadow(playerid, td_speed[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_speed[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, td_speed[playerid][2], 51);
	PlayerTextDrawFont(playerid, td_speed[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, td_speed[playerid][2], 1);

	td_speed[playerid][3] = CreatePlayerTextDraw(playerid, 41.999988, 322.062286, "way:0.0");
	PlayerTextDrawLetterSize(playerid, td_speed[playerid][3], 0.209599, 1.171911);
	PlayerTextDrawAlignment(playerid, td_speed[playerid][3], 1);
	PlayerTextDrawColor(playerid, td_speed[playerid][3], -1347440641);
	PlayerTextDrawSetShadow(playerid, td_speed[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_speed[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, td_speed[playerid][3], 51);
	PlayerTextDrawFont(playerid, td_speed[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, td_speed[playerid][3], 1);

	td_speed[playerid][4] = CreatePlayerTextDraw(playerid, 112.799972, 298.666778, "doors");
	PlayerTextDrawLetterSize(playerid, td_speed[playerid][4], 0.175999, 1.326221);
	PlayerTextDrawAlignment(playerid, td_speed[playerid][4], 1);
	PlayerTextDrawColor(playerid, td_speed[playerid][4], 579543807);
	PlayerTextDrawSetShadow(playerid, td_speed[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_speed[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_speed[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_speed[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_speed[playerid][4], 1);

	td_speed[playerid][5] = CreatePlayerTextDraw(playerid, 110.399986, 310.115539, "lights");
	PlayerTextDrawLetterSize(playerid, td_speed[playerid][5], 0.211199, 1.186843);
	PlayerTextDrawAlignment(playerid, td_speed[playerid][5], 1);
	PlayerTextDrawColor(playerid, td_speed[playerid][5], -195076097);
	PlayerTextDrawSetShadow(playerid, td_speed[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, td_speed[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, td_speed[playerid][5], 51);
	PlayerTextDrawFont(playerid, td_speed[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, td_speed[playerid][5], 1);
	//Регистрация
	td_register[playerid][0] = CreatePlayerTextDraw(playerid, 610.799865, 101.055557, "usebox");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][0], 0.000000, 26.433473);
	PlayerTextDrawTextSize(playerid, td_register[playerid][0], 494.399993, 0.000000);
	PlayerTextDrawAlignment(playerid, td_register[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_register[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][0], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][0], 0);

	td_register[playerid][1] = CreatePlayerTextDraw(playerid, 552.399719, 102.044418, "NICKNAME");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][1], 0.247999, 0.863289);
	PlayerTextDrawTextSize(playerid, td_register[playerid][1], 610.800659, -116.480056);
	PlayerTextDrawAlignment(playerid, td_register[playerid][1], 2);
	PlayerTextDrawColor(playerid, td_register[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][1], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][1], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][1], 1);

	td_register[playerid][2] = CreatePlayerTextDraw(playerid, 542.799743, 123.448898, "PASSWORD");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][2], 0.157199, 0.927999);
	PlayerTextDrawTextSize(playerid, td_register[playerid][2], -40.399986, -96.568801);
	PlayerTextDrawAlignment(playerid, td_register[playerid][2], 2);
	PlayerTextDrawColor(playerid, td_register[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][2], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][2], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][2], 1);

	td_register[playerid][3] = CreatePlayerTextDraw(playerid, 593.200012, 120.960006, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][3], 10.799951, 12.942224);
	PlayerTextDrawAlignment(playerid, td_register[playerid][3], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][3], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][3], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][3], true);

	td_register[playerid][4] = CreatePlayerTextDraw(playerid, 542.599792, 142.866622, "E-MAIL");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][4], 0.157199, 0.927999);
	PlayerTextDrawTextSize(playerid, td_register[playerid][4], -40.399986, -96.568801);
	PlayerTextDrawAlignment(playerid, td_register[playerid][4], 2);
	PlayerTextDrawColor(playerid, td_register[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][4], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][4], 1);

	td_register[playerid][5] = CreatePlayerTextDraw(playerid, 542.399780, 164.275436, "REFERRER");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][5], 0.157199, 0.927999);
	PlayerTextDrawTextSize(playerid, td_register[playerid][5], -44.399990, -96.568809);
	PlayerTextDrawAlignment(playerid, td_register[playerid][5], 2);
	PlayerTextDrawColor(playerid, td_register[playerid][5], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][5], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][5], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][5], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][5], 1);

	td_register[playerid][6] = CreatePlayerTextDraw(playerid, 542.599853, 185.684326, "MALE");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][6], 0.157199, 0.927999);
	PlayerTextDrawTextSize(playerid, td_register[playerid][6], -44.399990, -96.568809);
	PlayerTextDrawAlignment(playerid, td_register[playerid][6], 2);
	PlayerTextDrawColor(playerid, td_register[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][6], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][6], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][6], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][6], 1);

	td_register[playerid][7] = CreatePlayerTextDraw(playerid, 542.399658, 207.590957, "EUROPEAN");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][7], 0.157199, 0.927999);
	PlayerTextDrawTextSize(playerid, td_register[playerid][7], -44.399990, -96.568809);
	PlayerTextDrawAlignment(playerid, td_register[playerid][7], 2);
	PlayerTextDrawColor(playerid, td_register[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][7], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][7], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][7], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][7], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][7], 1);

	td_register[playerid][8] = CreatePlayerTextDraw(playerid, 592.999938, 140.377746, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][8], 10.799951, 12.942224);
	PlayerTextDrawAlignment(playerid, td_register[playerid][8], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][8], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][8], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][8], true);

	td_register[playerid][9] = CreatePlayerTextDraw(playerid, 592.799926, 161.786621, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][9], 10.799951, 12.942224);
	PlayerTextDrawAlignment(playerid, td_register[playerid][9], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][9], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][9], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][9], true);

	td_register[playerid][10] = CreatePlayerTextDraw(playerid, 592.599853, 183.195510, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][10], 10.799951, 12.942224);
	PlayerTextDrawAlignment(playerid, td_register[playerid][10], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][10], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][10], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][10], true);

	td_register[playerid][11] = CreatePlayerTextDraw(playerid, 592.799804, 205.102096, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][11], 10.799951, 12.942224);
	PlayerTextDrawAlignment(playerid, td_register[playerid][11], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][11], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][11], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][11], true);

	td_register[playerid][12] = CreatePlayerTextDraw(playerid, 514.799865, 254.364471, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][12], 0.000000, -0.479998);
	PlayerTextDrawTextSize(playerid, td_register[playerid][12], 55.999996, 64.711135);
	PlayerTextDrawAlignment(playerid, td_register[playerid][12], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][12], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][12], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][12], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][12], 144);
	PlayerTextDrawFont(playerid, td_register[playerid][12], 5);
	PlayerTextDrawSetPreviewModel(playerid, td_register[playerid][12], 1);
	PlayerTextDrawSetPreviewRot(playerid, td_register[playerid][12], 0.000000, 0.000000, 0.000000, 1.000000);

	td_register[playerid][13] = CreatePlayerTextDraw(playerid, 578.799804, 257.351013, "LD_BEAT:right");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][13], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][13], 19.200012, 23.893310);
	PlayerTextDrawAlignment(playerid, td_register[playerid][13], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][13], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][13], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][13], true);

	td_register[playerid][14] = CreatePlayerTextDraw(playerid, 578.599853, 291.702087, "LD_BEAT:left");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][14], 19.200012, 23.893310);
	PlayerTextDrawAlignment(playerid, td_register[playerid][14], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][14], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][14], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][14], true);

	td_register[playerid][15] = CreatePlayerTextDraw(playerid, 497.599975, 331.022216, "LOG UP");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][15], 0.222799, 0.883198);
	PlayerTextDrawTextSize(playerid, td_register[playerid][15], 527.200134, 10.453330);
	PlayerTextDrawAlignment(playerid, td_register[playerid][15], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][15], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][15], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][15], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][15], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][15], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][15], true);

	td_register[playerid][16] = CreatePlayerTextDraw(playerid, 542.599609, 228.999786, "AGE");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][16], 0.157197, 0.927999);
	PlayerTextDrawTextSize(playerid, td_register[playerid][16], -44.399990, -96.568809);
	PlayerTextDrawAlignment(playerid, td_register[playerid][16], 2);
	PlayerTextDrawColor(playerid, td_register[playerid][16], -1);
	PlayerTextDrawUseBox(playerid, td_register[playerid][16], true);
	PlayerTextDrawBoxColor(playerid, td_register[playerid][16], 144);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][16], 1);
	PlayerTextDrawBackgroundColor(playerid, td_register[playerid][16], 51);
	PlayerTextDrawFont(playerid, td_register[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, td_register[playerid][16], 1);

	td_register[playerid][17] = CreatePlayerTextDraw(playerid, 592.599731, 227.008712, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, td_register[playerid][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_register[playerid][17], 10.799949, 12.942222);
	PlayerTextDrawAlignment(playerid, td_register[playerid][17], 1);
	PlayerTextDrawColor(playerid, td_register[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, td_register[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, td_register[playerid][17], 0);
	PlayerTextDrawFont(playerid, td_register[playerid][17], 4);
	PlayerTextDrawSetSelectable(playerid, td_register[playerid][17], true);
	//Авторизация
	td_authorization[playerid][0] = CreatePlayerTextDraw(playerid, 610.800048, 101.055557, "usebox");
	PlayerTextDrawLetterSize(playerid, td_authorization[playerid][0], 0.000000, 6.393472);
	PlayerTextDrawTextSize(playerid, td_authorization[playerid][0], 494.399993, 0.000000);
	PlayerTextDrawAlignment(playerid, td_authorization[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_authorization[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_authorization[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_authorization[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_authorization[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_authorization[playerid][0], 0);
	PlayerTextDrawFont(playerid, td_authorization[playerid][0], 0);

	td_authorization[playerid][1] = CreatePlayerTextDraw(playerid, 552.399719, 102.044418, "NICKNAME");
	PlayerTextDrawLetterSize(playerid, td_authorization[playerid][1], 0.247997, 0.863286);
	PlayerTextDrawTextSize(playerid, td_authorization[playerid][1], 610.800659, -116.480056);
	PlayerTextDrawAlignment(playerid, td_authorization[playerid][1], 2);
	PlayerTextDrawColor(playerid, td_authorization[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, td_authorization[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, td_authorization[playerid][1], 144);
	PlayerTextDrawSetShadow(playerid, td_authorization[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_authorization[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, td_authorization[playerid][1], 51);
	PlayerTextDrawFont(playerid, td_authorization[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, td_authorization[playerid][1], 1);

	td_authorization[playerid][2] = CreatePlayerTextDraw(playerid, 542.799743, 123.448898, "PASSWORD");
	PlayerTextDrawLetterSize(playerid, td_authorization[playerid][2], 0.157196, 0.927999);
	PlayerTextDrawTextSize(playerid, td_authorization[playerid][2], -40.399986, -96.568801);
	PlayerTextDrawAlignment(playerid, td_authorization[playerid][2], 2);
	PlayerTextDrawColor(playerid, td_authorization[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, td_authorization[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, td_authorization[playerid][2], 144);
	PlayerTextDrawSetShadow(playerid, td_authorization[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_authorization[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, td_authorization[playerid][2], 51);
	PlayerTextDrawFont(playerid, td_authorization[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, td_authorization[playerid][2], 1);

	td_authorization[playerid][3] = CreatePlayerTextDraw(playerid, 593.200012, 120.960006, "LD_BEAT:cross");
	PlayerTextDrawLetterSize(playerid, td_authorization[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_authorization[playerid][3], 10.799948, 12.942221);
	PlayerTextDrawAlignment(playerid, td_authorization[playerid][3], 1);
	PlayerTextDrawColor(playerid, td_authorization[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, td_authorization[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_authorization[playerid][3], 0);
	PlayerTextDrawFont(playerid, td_authorization[playerid][3], 4);
	PlayerTextDrawSetSelectable(playerid, td_authorization[playerid][3], true);

	td_authorization[playerid][4] = CreatePlayerTextDraw(playerid, 497.600036, 150.826614, "LOG IN");
	PlayerTextDrawLetterSize(playerid, td_authorization[playerid][4], 0.222799, 0.883198);
	PlayerTextDrawTextSize(playerid, td_authorization[playerid][4], 527.200134, 10.453330);
	PlayerTextDrawAlignment(playerid, td_authorization[playerid][4], 1);
	PlayerTextDrawColor(playerid, td_authorization[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, td_authorization[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, td_authorization[playerid][4], 144);
	PlayerTextDrawSetShadow(playerid, td_authorization[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_authorization[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_authorization[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_authorization[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_authorization[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, td_authorization[playerid][4], true);
	//Свободный дом
	td_free_house[playerid][0] = CreatePlayerTextDraw(playerid, 611.199951, 103.046669, "usebox");
	PlayerTextDrawLetterSize(playerid, td_free_house[playerid][0], 0.000000, 14.008274);
	PlayerTextDrawTextSize(playerid, td_free_house[playerid][0], 494.799987, 0.000000);
	PlayerTextDrawAlignment(playerid, td_free_house[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_free_house[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_free_house[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_free_house[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_free_house[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_free_house[playerid][0], 0);
	PlayerTextDrawFont(playerid, td_free_house[playerid][0], 0);

	td_free_house[playerid][1] = CreatePlayerTextDraw(playerid, 552.800354, 123.448806, "HOUSE NUMBER - NULL");
	PlayerTextDrawLetterSize(playerid, td_free_house[playerid][1], 0.195999, 0.873244);
	PlayerTextDrawTextSize(playerid, td_free_house[playerid][1], 83.200057, 110.008956);
	PlayerTextDrawAlignment(playerid, td_free_house[playerid][1], 2);
	PlayerTextDrawColor(playerid, td_free_house[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, td_free_house[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, td_free_house[playerid][1], 144);
	PlayerTextDrawSetShadow(playerid, td_free_house[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_free_house[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_house[playerid][1], 51);
	PlayerTextDrawFont(playerid, td_free_house[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, td_free_house[playerid][1], 1);

	td_free_house[playerid][2] = CreatePlayerTextDraw(playerid, 552.799865, 142.862274, "OWNER - THE STATE");
	PlayerTextDrawLetterSize(playerid, td_free_house[playerid][2], 0.195999, 0.873244);
	PlayerTextDrawTextSize(playerid, td_free_house[playerid][2], 77.200065, 110.008949);
	PlayerTextDrawAlignment(playerid, td_free_house[playerid][2], 2);
	PlayerTextDrawColor(playerid, td_free_house[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, td_free_house[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, td_free_house[playerid][2], 144);
	PlayerTextDrawSetShadow(playerid, td_free_house[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_free_house[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_house[playerid][2], 51);
	PlayerTextDrawFont(playerid, td_free_house[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, td_free_house[playerid][2], 1);

	td_free_house[playerid][3] = CreatePlayerTextDraw(playerid, 552.799926, 162.773345, "COST - $NULL");
	PlayerTextDrawLetterSize(playerid, td_free_house[playerid][3], 0.195999, 0.873244);
	PlayerTextDrawTextSize(playerid, td_free_house[playerid][3], 73.200088, 110.008979);
	PlayerTextDrawAlignment(playerid, td_free_house[playerid][3], 2);
	PlayerTextDrawColor(playerid, td_free_house[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, td_free_house[playerid][3], true);
	PlayerTextDrawBoxColor(playerid, td_free_house[playerid][3], 144);
	PlayerTextDrawSetShadow(playerid, td_free_house[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_free_house[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_house[playerid][3], 51);
	PlayerTextDrawFont(playerid, td_free_house[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, td_free_house[playerid][3], 1);

	td_free_house[playerid][4] = CreatePlayerTextDraw(playerid, 552.999938, 182.191131, "HOUSE CLASS - NULL");
	PlayerTextDrawLetterSize(playerid, td_free_house[playerid][4], 0.195999, 0.873244);
	PlayerTextDrawTextSize(playerid, td_free_house[playerid][4], 73.200088, 110.008979);
	PlayerTextDrawAlignment(playerid, td_free_house[playerid][4], 2);
	PlayerTextDrawColor(playerid, td_free_house[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, td_free_house[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, td_free_house[playerid][4], 144);
	PlayerTextDrawSetShadow(playerid, td_free_house[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_free_house[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_house[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_free_house[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_free_house[playerid][4], 1);

	td_free_house[playerid][5] = CreatePlayerTextDraw(playerid, 608.000000, 205.091110, "usebox");
	PlayerTextDrawLetterSize(playerid, td_free_house[playerid][5], 0.000000, 2.338147);
	PlayerTextDrawTextSize(playerid, td_free_house[playerid][5], 498.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, td_free_house[playerid][5], 1);
	PlayerTextDrawColor(playerid, td_free_house[playerid][5], 0);
	PlayerTextDrawUseBox(playerid, td_free_house[playerid][5], true);
	PlayerTextDrawBoxColor(playerid, td_free_house[playerid][5], 102);
	PlayerTextDrawSetShadow(playerid, td_free_house[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, td_free_house[playerid][5], 0);
	PlayerTextDrawFont(playerid, td_free_house[playerid][5], 0);

	td_free_house[playerid][6] = CreatePlayerTextDraw(playerid, 552.800170, 209.066665, "You may buy this house! /buyhouse");
	PlayerTextDrawLetterSize(playerid, td_free_house[playerid][6], 0.163999, 1.286401);
	PlayerTextDrawAlignment(playerid, td_free_house[playerid][6], 2);
	PlayerTextDrawColor(playerid, td_free_house[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, td_free_house[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, td_free_house[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_house[playerid][6], 51);
	PlayerTextDrawFont(playerid, td_free_house[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, td_free_house[playerid][6], 1);
	//Купленый дом
	td_owned_house[playerid][0] = CreatePlayerTextDraw(playerid, 611.199951, 103.046669, "usebox");
	PlayerTextDrawLetterSize(playerid, td_owned_house[playerid][0], 0.000000, 11.888276);
	PlayerTextDrawTextSize(playerid, td_owned_house[playerid][0], 494.799987, 0.000000);
	PlayerTextDrawAlignment(playerid, td_owned_house[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_owned_house[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_owned_house[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_owned_house[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_owned_house[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_house[playerid][0], 0);
	PlayerTextDrawFont(playerid, td_owned_house[playerid][0], 0);

	td_owned_house[playerid][1] = CreatePlayerTextDraw(playerid, 552.800354, 123.448806, "HOUSE NUMBER - NULL");
	PlayerTextDrawLetterSize(playerid, td_owned_house[playerid][1], 0.183198, 0.878221);
	PlayerTextDrawTextSize(playerid, td_owned_house[playerid][1], 83.200057, 110.008956);
	PlayerTextDrawAlignment(playerid, td_owned_house[playerid][1], 2);
	PlayerTextDrawColor(playerid, td_owned_house[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, td_owned_house[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, td_owned_house[playerid][1], 144);
	PlayerTextDrawSetShadow(playerid, td_owned_house[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_house[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_house[playerid][1], 51);
	PlayerTextDrawFont(playerid, td_owned_house[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_house[playerid][1], 1);

	td_owned_house[playerid][2] = CreatePlayerTextDraw(playerid, 552.799865, 142.862274, "OWNER - NULL");
	PlayerTextDrawLetterSize(playerid, td_owned_house[playerid][2], 0.159998, 0.823466);
	PlayerTextDrawTextSize(playerid, td_owned_house[playerid][2], 77.200065, 110.008949);
	PlayerTextDrawAlignment(playerid, td_owned_house[playerid][2], 2);
	PlayerTextDrawColor(playerid, td_owned_house[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, td_owned_house[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, td_owned_house[playerid][2], 144);
	PlayerTextDrawSetShadow(playerid, td_owned_house[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_house[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_house[playerid][2], 51);
	PlayerTextDrawFont(playerid, td_owned_house[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_house[playerid][2], 1);

	td_owned_house[playerid][3] = CreatePlayerTextDraw(playerid, 552.799926, 162.773345, "HOUSE CLASS - NULL");
	PlayerTextDrawLetterSize(playerid, td_owned_house[playerid][3], 0.193599, 0.808533);
	PlayerTextDrawTextSize(playerid, td_owned_house[playerid][3], 73.200088, 110.008979);
	PlayerTextDrawAlignment(playerid, td_owned_house[playerid][3], 2);
	PlayerTextDrawColor(playerid, td_owned_house[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, td_owned_house[playerid][3], true);
	PlayerTextDrawBoxColor(playerid, td_owned_house[playerid][3], 144);
	PlayerTextDrawSetShadow(playerid, td_owned_house[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_house[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_house[playerid][3], 51);
	PlayerTextDrawFont(playerid, td_owned_house[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_house[playerid][3], 1);

	td_owned_house[playerid][4] = CreatePlayerTextDraw(playerid, 553.200012, 187.164443, "Press Alt to enter!");
	PlayerTextDrawLetterSize(playerid, td_owned_house[playerid][4], 0.281599, 1.301333);
	PlayerTextDrawAlignment(playerid, td_owned_house[playerid][4], 2);
	PlayerTextDrawColor(playerid, td_owned_house[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, td_owned_house[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_house[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_house[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_owned_house[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_house[playerid][4], 1);

	td_owned_house[playerid][5] = CreatePlayerTextDraw(playerid, 608.000000, 182.691162, "usebox");
	PlayerTextDrawLetterSize(playerid, td_owned_house[playerid][5], 0.000000, 2.338146);
	PlayerTextDrawTextSize(playerid, td_owned_house[playerid][5], 498.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, td_owned_house[playerid][5], 1);
	PlayerTextDrawColor(playerid, td_owned_house[playerid][5], 0);
	PlayerTextDrawUseBox(playerid, td_owned_house[playerid][5], true);
	PlayerTextDrawBoxColor(playerid, td_owned_house[playerid][5], 102);
	PlayerTextDrawSetShadow(playerid, td_owned_house[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_house[playerid][5], 0);
	PlayerTextDrawFont(playerid, td_owned_house[playerid][5], 1);
	//покупка транспорта
	td_buy_car[playerid][0] = CreatePlayerTextDraw(playerid, 494.800018, 176.220001, "usebox");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][0], 0.000000, 15.838831);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][0], 147.199996, 0.000000);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][0], 0);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][0], 0);

	td_buy_car[playerid][1] = CreatePlayerTextDraw(playerid, 136.399963, 154.808898, "");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][1], -0.237200, 9.845147);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][1], 106.400009, 94.079994);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][1], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][1], 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][1], 0xFFFFFF00);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][1], 0xFFFFFF00);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][1], 0);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][1], 5);
	PlayerTextDrawSetPreviewModel(playerid, td_buy_car[playerid][1], 411);
	PlayerTextDrawSetPreviewRot(playerid, td_buy_car[playerid][1], -25.000000, 0.000000, 35.000000, 1.000000);

	td_buy_car[playerid][2] = CreatePlayerTextDraw(playerid, 208.199966, 156.306640, "");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][2], -0.237200, 9.845147);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][2], 106.400009, 94.079994);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][2], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][2], 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][2], 0xFFFFFF00);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][2], 0xFFFFFF00);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][2], 0);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][2], 5);
	PlayerTextDrawSetPreviewModel(playerid, td_buy_car[playerid][2], 411);
	PlayerTextDrawSetPreviewRot(playerid, td_buy_car[playerid][2], -25.000000, 0.000000, 220.000000, 1.000000);

	td_buy_car[playerid][3] = CreatePlayerTextDraw(playerid, 288.800140, 245.413345, "LD_BEAT:right");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][3], 15.200012, 17.422210);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][3], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][3], 0);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][3], 4);
	PlayerTextDrawSetSelectable(playerid, td_buy_car[playerid][3], true);

	td_buy_car[playerid][4] = CreatePlayerTextDraw(playerid, 232.800048, 246.897781, "SELECT CAR");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][4], 0.370000, 1.535287);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][4], -4.399998, 143.359954);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][4], 2);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][4], 144);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_buy_car[playerid][4], 1);

	td_buy_car[playerid][5] = CreatePlayerTextDraw(playerid, 161.400131, 245.417785, "LD_BEAT:left");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][5], 15.200012, 17.422210);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][5], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][5], 0);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][5], 4);
	PlayerTextDrawSetSelectable(playerid, td_buy_car[playerid][5], true);

	td_buy_car[playerid][6] = CreatePlayerTextDraw(playerid, 485.199981, 185.677780, "usebox");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][6], 0.000000, 7.315923);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][6], 325.600006, 0.000000);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][6], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][6], 0);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][6], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][6], 102);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][6], 0);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][6], 0);

	td_buy_car[playerid][7] = CreatePlayerTextDraw(playerid, 405.199951, 193.635559, "MODEL - ");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][7], 0.308398, 1.321244);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][7], 22.399990, 152.817672);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][7], 2);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][7], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][7], 144);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][7], 1);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][7], 51);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, td_buy_car[playerid][7], 1);

	td_buy_car[playerid][8] = CreatePlayerTextDraw(playerid, 404.999694, 213.053344, "FUEL TANK - ");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][8], 0.308398, 1.321244);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][8], -1.599998, 152.817794);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][8], 2);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][8], -1);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][8], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][8], 144);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][8], 1);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][8], 51);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, td_buy_car[playerid][8], 1);

	td_buy_car[playerid][9] = CreatePlayerTextDraw(playerid, 405.199829, 232.471115, "PRICE - ");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][9], 0.308398, 1.321244);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][9], 8.399998, 153.315521);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][9], 2);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][9], -1);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][9], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][9], 144);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][9], 1);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][9], 51);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, td_buy_car[playerid][9], 1);

	td_buy_car[playerid][10] = CreatePlayerTextDraw(playerid, 308.400024, 285.730773, "usebox");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][10], 0.000000, 2.227529);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][10], 158.000045, 0.000000);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][10], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][10], 0);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][10], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][10], 102);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][10], 0);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][10], 0);

	td_buy_car[playerid][11] = CreatePlayerTextDraw(playerid, 169.200012, 289.706726, "BUY");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][11], 0.380398, 1.485509);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][11], 196.400054, 16.924358);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][11], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][11], -1);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][11], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][11], 144);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][11], 1);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][11], 51);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, td_buy_car[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, td_buy_car[playerid][11], true);

	td_buy_car[playerid][12] = CreatePlayerTextDraw(playerid, 250.399963, 289.706665, "CANCEL");
	PlayerTextDrawLetterSize(playerid, td_buy_car[playerid][12], 0.380398, 1.485509);
	PlayerTextDrawTextSize(playerid, td_buy_car[playerid][12], 297.999847, 16.426670);
	PlayerTextDrawAlignment(playerid, td_buy_car[playerid][12], 1);
	PlayerTextDrawColor(playerid, td_buy_car[playerid][12], -1);
	PlayerTextDrawUseBox(playerid, td_buy_car[playerid][12], true);
	PlayerTextDrawBoxColor(playerid, td_buy_car[playerid][12], 144);
	PlayerTextDrawSetShadow(playerid, td_buy_car[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, td_buy_car[playerid][12], 1);
	PlayerTextDrawBackgroundColor(playerid, td_buy_car[playerid][12], 51);
	PlayerTextDrawFont(playerid, td_buy_car[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, td_buy_car[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, td_buy_car[playerid][12], true);
	//свободный бизнес
	td_free_business[playerid][0] = CreatePlayerTextDraw(playerid, 611.199768, 103.046669, "usebox");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][0], 0.000000, 16.208276);
	PlayerTextDrawTextSize(playerid, td_free_business[playerid][0], 494.799987, 0.000000);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_free_business[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_free_business[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_free_business[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][0], 0);
	PlayerTextDrawFont(playerid, td_free_business[playerid][0], 0);

	td_free_business[playerid][1] = CreatePlayerTextDraw(playerid, 552.800354, 123.448806, "BUSINESS NUMBER - -");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][1], 0.195997, 0.873242);
	PlayerTextDrawTextSize(playerid, td_free_business[playerid][1], 83.200057, 110.008956);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][1], 2);
	PlayerTextDrawColor(playerid, td_free_business[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, td_free_business[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, td_free_business[playerid][1], 144);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_business[playerid][1], 51);
	PlayerTextDrawFont(playerid, td_free_business[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, td_free_business[playerid][1], 1);

	td_free_business[playerid][2] = CreatePlayerTextDraw(playerid, 552.799865, 162.275588, "OWNER - THE STATE");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][2], 0.195997, 0.873242);
	PlayerTextDrawTextSize(playerid, td_free_business[playerid][2], 77.200065, 110.008949);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][2], 2);
	PlayerTextDrawColor(playerid, td_free_business[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, td_free_business[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, td_free_business[playerid][2], 144);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_business[playerid][2], 51);
	PlayerTextDrawFont(playerid, td_free_business[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, td_free_business[playerid][2], 1);

	td_free_business[playerid][3] = CreatePlayerTextDraw(playerid, 552.799987, 182.186599, "COST - $-");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][3], 0.195997, 0.873242);
	PlayerTextDrawTextSize(playerid, td_free_business[playerid][3], 73.200088, 110.008979);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][3], 2);
	PlayerTextDrawColor(playerid, td_free_business[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, td_free_business[playerid][3], true);
	PlayerTextDrawBoxColor(playerid, td_free_business[playerid][3], 144);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_business[playerid][3], 51);
	PlayerTextDrawFont(playerid, td_free_business[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, td_free_business[playerid][3], 1);

	td_free_business[playerid][4] = CreatePlayerTextDraw(playerid, 552.999938, 202.102188, "TYPE - -");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][4], 0.195997, 0.873242);
	PlayerTextDrawTextSize(playerid, td_free_business[playerid][4], 73.200088, 110.008979);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][4], 2);
	PlayerTextDrawColor(playerid, td_free_business[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, td_free_business[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, td_free_business[playerid][4], 144);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_business[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_free_business[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_free_business[playerid][4], 1);

	td_free_business[playerid][5] = CreatePlayerTextDraw(playerid, 608.400085, 223.508880, "usebox");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][5], 0.000000, 2.338145);
	PlayerTextDrawTextSize(playerid, td_free_business[playerid][5], 498.399963, 0.000000);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][5], 1);
	PlayerTextDrawColor(playerid, td_free_business[playerid][5], 0);
	PlayerTextDrawUseBox(playerid, td_free_business[playerid][5], true);
	PlayerTextDrawBoxColor(playerid, td_free_business[playerid][5], 102);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][5], 0);
	PlayerTextDrawFont(playerid, td_free_business[playerid][5], 0);

	td_free_business[playerid][6] = CreatePlayerTextDraw(playerid, 553.200134, 229.475509, "You may buy this business! /buybusiness");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][6], 0.141598, 1.171911);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][6], 2);
	PlayerTextDrawColor(playerid, td_free_business[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_business[playerid][6], 51);
	PlayerTextDrawFont(playerid, td_free_business[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, td_free_business[playerid][6], 1);

	td_free_business[playerid][7] = CreatePlayerTextDraw(playerid, 553.000427, 143.364303, "-");
	PlayerTextDrawLetterSize(playerid, td_free_business[playerid][7], 0.195997, 0.873242);
	PlayerTextDrawTextSize(playerid, td_free_business[playerid][7], 83.200057, 110.008956);
	PlayerTextDrawAlignment(playerid, td_free_business[playerid][7], 2);
	PlayerTextDrawColor(playerid, td_free_business[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, td_free_business[playerid][7], true);
	PlayerTextDrawBoxColor(playerid, td_free_business[playerid][7], 144);
	PlayerTextDrawSetShadow(playerid, td_free_business[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, td_free_business[playerid][7], 1);
	PlayerTextDrawBackgroundColor(playerid, td_free_business[playerid][7], 51);
	PlayerTextDrawFont(playerid, td_free_business[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, td_free_business[playerid][7], 1);
	//купленный бизнес
	td_owned_business[playerid][0] = CreatePlayerTextDraw(playerid, 611.199951, 103.046669, "usebox");
	PlayerTextDrawLetterSize(playerid, td_owned_business[playerid][0], 0.000000, 14.208275);
	PlayerTextDrawTextSize(playerid, td_owned_business[playerid][0], 494.799987, 0.000000);
	PlayerTextDrawAlignment(playerid, td_owned_business[playerid][0], 1);
	PlayerTextDrawColor(playerid, td_owned_business[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, td_owned_business[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, td_owned_business[playerid][0], 1419116325);
	PlayerTextDrawSetShadow(playerid, td_owned_business[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_business[playerid][0], 0);
	PlayerTextDrawFont(playerid, td_owned_business[playerid][0], 0);

	td_owned_business[playerid][1] = CreatePlayerTextDraw(playerid, 552.800354, 123.448806, "BUSINESS NUMBER - -");
	PlayerTextDrawLetterSize(playerid, td_owned_business[playerid][1], 0.183198, 0.878220);
	PlayerTextDrawTextSize(playerid, td_owned_business[playerid][1], 83.200057, 110.008956);
	PlayerTextDrawAlignment(playerid, td_owned_business[playerid][1], 2);
	PlayerTextDrawColor(playerid, td_owned_business[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, td_owned_business[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, td_owned_business[playerid][1], 144);
	PlayerTextDrawSetShadow(playerid, td_owned_business[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_business[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_business[playerid][1], 51);
	PlayerTextDrawFont(playerid, td_owned_business[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_business[playerid][1], 1);

	td_owned_business[playerid][2] = CreatePlayerTextDraw(playerid, 552.799865, 142.862274, "-");
	PlayerTextDrawLetterSize(playerid, td_owned_business[playerid][2], 0.159997, 0.823466);
	PlayerTextDrawTextSize(playerid, td_owned_business[playerid][2], 77.200065, 110.008949);
	PlayerTextDrawAlignment(playerid, td_owned_business[playerid][2], 2);
	PlayerTextDrawColor(playerid, td_owned_business[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, td_owned_business[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, td_owned_business[playerid][2], 144);
	PlayerTextDrawSetShadow(playerid, td_owned_business[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_business[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_business[playerid][2], 51);
	PlayerTextDrawFont(playerid, td_owned_business[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_business[playerid][2], 1);

	td_owned_business[playerid][3] = CreatePlayerTextDraw(playerid, 552.799926, 162.773345, "OWNER - -");
	PlayerTextDrawLetterSize(playerid, td_owned_business[playerid][3], 0.193599, 0.808533);
	PlayerTextDrawTextSize(playerid, td_owned_business[playerid][3], 73.200088, 110.008979);
	PlayerTextDrawAlignment(playerid, td_owned_business[playerid][3], 2);
	PlayerTextDrawColor(playerid, td_owned_business[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, td_owned_business[playerid][3], true);
	PlayerTextDrawBoxColor(playerid, td_owned_business[playerid][3], 144);
	PlayerTextDrawSetShadow(playerid, td_owned_business[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_business[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_business[playerid][3], 51);
	PlayerTextDrawFont(playerid, td_owned_business[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_business[playerid][3], 1);

	td_owned_business[playerid][4] = CreatePlayerTextDraw(playerid, 552.399902, 209.564422, "Press Alt to enter!");
	PlayerTextDrawLetterSize(playerid, td_owned_business[playerid][4], 0.281598, 1.301332);
	PlayerTextDrawAlignment(playerid, td_owned_business[playerid][4], 2);
	PlayerTextDrawColor(playerid, td_owned_business[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, td_owned_business[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_business[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_business[playerid][4], 51);
	PlayerTextDrawFont(playerid, td_owned_business[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_business[playerid][4], 1);

	td_owned_business[playerid][5] = CreatePlayerTextDraw(playerid, 607.599975, 205.588897, "usebox");
	PlayerTextDrawLetterSize(playerid, td_owned_business[playerid][5], 0.000000, 2.338145);
	PlayerTextDrawTextSize(playerid, td_owned_business[playerid][5], 497.600036, 0.000000);
	PlayerTextDrawAlignment(playerid, td_owned_business[playerid][5], 1);
	PlayerTextDrawColor(playerid, td_owned_business[playerid][5], 0);
	PlayerTextDrawUseBox(playerid, td_owned_business[playerid][5], true);
	PlayerTextDrawBoxColor(playerid, td_owned_business[playerid][5], 102);
	PlayerTextDrawSetShadow(playerid, td_owned_business[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_business[playerid][5], 0);
	PlayerTextDrawFont(playerid, td_owned_business[playerid][5], 1);

	td_owned_business[playerid][6] = CreatePlayerTextDraw(playerid, 552.599792, 182.191131, "TYPE - -");
	PlayerTextDrawLetterSize(playerid, td_owned_business[playerid][6], 0.193599, 0.808533);
	PlayerTextDrawTextSize(playerid, td_owned_business[playerid][6], 78.000114, 109.511299);
	PlayerTextDrawAlignment(playerid, td_owned_business[playerid][6], 2);
	PlayerTextDrawColor(playerid, td_owned_business[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, td_owned_business[playerid][6], true);
	PlayerTextDrawBoxColor(playerid, td_owned_business[playerid][6], 144);
	PlayerTextDrawSetShadow(playerid, td_owned_business[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, td_owned_business[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, td_owned_business[playerid][6], 51);
	PlayerTextDrawFont(playerid, td_owned_business[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, td_owned_business[playerid][6], 1);
}
