
//Player Textdraws(Äëÿ èãðîêà):

new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new PlayerText:Textdraw2[MAX_PLAYERS];
new PlayerText:Textdraw3[MAX_PLAYERS];
new PlayerText:Textdraw4[MAX_PLAYERS];
new PlayerText:Textdraw5[MAX_PLAYERS];
new PlayerText:Textdraw6[MAX_PLAYERS];
new PlayerText:Textdraw7[MAX_PLAYERS];
new PlayerText:Textdraw8[MAX_PLAYERS];
new PlayerText:Textdraw9[MAX_PLAYERS];
new PlayerText:Textdraw10[MAX_PLAYERS];
new PlayerText:Textdraw11[MAX_PLAYERS];
new PlayerText:Textdraw12[MAX_PLAYERS];


Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 494.800018, 176.220001, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.000000, 15.838831);
PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 147.199996, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw0[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw0[playerid], 1419116325);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 0);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 136.399963, 154.808898, "411");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], -0.237200, 9.845147);
PlayerTextDrawTextSize(playerid, Textdraw1[playerid], 106.400009, 94.079994);
PlayerTextDrawAlignment(playerid, Textdraw1[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw1[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw1[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw1[playerid], 255);
PlayerTextDrawSetShadow(playerid, Textdraw1[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw1[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw1[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw1[playerid], 411);
PlayerTextDrawSetPreviewRot(playerid, Textdraw1[playerid], -25.000000, 0.000000, 35.000000, 1.000000);

Textdraw2[playerid] = CreatePlayerTextDraw(playerid, 208.199966, 156.306640, "411");
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], -0.237200, 9.845147);
PlayerTextDrawTextSize(playerid, Textdraw2[playerid], 106.400009, 94.079994);
PlayerTextDrawAlignment(playerid, Textdraw2[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw2[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw2[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw2[playerid], 255);
PlayerTextDrawSetShadow(playerid, Textdraw2[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw2[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw2[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw2[playerid], 411);
PlayerTextDrawSetPreviewRot(playerid, Textdraw2[playerid], -25.000000, 0.000000, 220.000000, 1.000000);

Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 288.800140, 245.413345, "LD_BEAT:right");
PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw3[playerid], 15.200012, 17.422210);
PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw3[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw3[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw3[playerid], true);

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 232.800048, 246.897781, "SELECT CAR");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.370000, 1.535287);
PlayerTextDrawTextSize(playerid, Textdraw4[playerid], -4.399998, 143.359954);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw4[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw4[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);

Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 161.400131, 245.417785, "LD_BEAT:left");
PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw5[playerid], 15.200012, 17.422210);
PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw5[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw5[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw5[playerid], true);

Textdraw6[playerid] = CreatePlayerTextDraw(playerid, 485.199981, 185.677780, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw6[playerid], 0.000000, 7.315923);
PlayerTextDrawTextSize(playerid, Textdraw6[playerid], 325.600006, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw6[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw6[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw6[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw6[playerid], 102);
PlayerTextDrawSetShadow(playerid, Textdraw6[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw6[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw6[playerid], 0);

Textdraw7[playerid] = CreatePlayerTextDraw(playerid, 405.199951, 193.635559, "MODEL - Landstalker");
PlayerTextDrawLetterSize(playerid, Textdraw7[playerid], 0.308398, 1.321244);
PlayerTextDrawTextSize(playerid, Textdraw7[playerid], 22.399990, 152.817672);
PlayerTextDrawAlignment(playerid, Textdraw7[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw7[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw7[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw7[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw7[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw7[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw7[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw7[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw7[playerid], 1);

Textdraw8[playerid] = CreatePlayerTextDraw(playerid, 404.999694, 213.053344, "FUEL TANK - 999liters");
PlayerTextDrawLetterSize(playerid, Textdraw8[playerid], 0.308398, 1.321244);
PlayerTextDrawTextSize(playerid, Textdraw8[playerid], -1.599998, 152.817794);
PlayerTextDrawAlignment(playerid, Textdraw8[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw8[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw8[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw8[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw8[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw8[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw8[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw8[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw8[playerid], 1);

Textdraw9[playerid] = CreatePlayerTextDraw(playerid, 405.199829, 232.471115, "PRICE - $9999999");
PlayerTextDrawLetterSize(playerid, Textdraw9[playerid], 0.308398, 1.321244);
PlayerTextDrawTextSize(playerid, Textdraw9[playerid], 8.399998, 153.315521);
PlayerTextDrawAlignment(playerid, Textdraw9[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw9[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw9[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw9[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw9[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw9[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw9[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw9[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw9[playerid], 1);

Textdraw10[playerid] = CreatePlayerTextDraw(playerid, 308.400024, 285.730773, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw10[playerid], 0.000000, 2.227529);
PlayerTextDrawTextSize(playerid, Textdraw10[playerid], 158.000045, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw10[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw10[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw10[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw10[playerid], 102);
PlayerTextDrawSetShadow(playerid, Textdraw10[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw10[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw10[playerid], 0);

Textdraw11[playerid] = CreatePlayerTextDraw(playerid, 169.200012, 289.706726, "BUY");
PlayerTextDrawLetterSize(playerid, Textdraw11[playerid], 0.380398, 1.485509);
PlayerTextDrawTextSize(playerid, Textdraw11[playerid], 196.400054, 16.924358);
PlayerTextDrawAlignment(playerid, Textdraw11[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw11[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw11[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw11[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw11[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw11[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw11[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw11[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw11[playerid], 1);
PlayerTextDrawSetSelectable(playerid, Textdraw11[playerid], true);

Textdraw12[playerid] = CreatePlayerTextDraw(playerid, 250.399963, 289.706665, "CANCEL");
PlayerTextDrawLetterSize(playerid, Textdraw12[playerid], 0.380398, 1.485509);
PlayerTextDrawTextSize(playerid, Textdraw12[playerid], 297.999847, 16.426670);
PlayerTextDrawAlignment(playerid, Textdraw12[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw12[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw12[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw12[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw12[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw12[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw12[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw12[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw12[playerid], 1);
PlayerTextDrawSetSelectable(playerid, Textdraw12[playerid], true);

