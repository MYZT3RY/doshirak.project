
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
new PlayerText:Textdraw13[MAX_PLAYERS];
new PlayerText:Textdraw14[MAX_PLAYERS];
new PlayerText:Textdraw15[MAX_PLAYERS];
new PlayerText:Textdraw16[MAX_PLAYERS];
new PlayerText:Textdraw17[MAX_PLAYERS];


Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 610.799865, 101.055557, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.000000, 26.433473);
PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 494.399993, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw0[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw0[playerid], 1419116325);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 0);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 552.399719, 102.044418, "Dmitriy_Yakimov");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 0.247997, 0.863287);
PlayerTextDrawTextSize(playerid, Textdraw1[playerid], 610.800659, -116.480056);
PlayerTextDrawAlignment(playerid, Textdraw1[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw1[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw1[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw1[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw1[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw1[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw1[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw1[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw1[playerid], 1);

Textdraw2[playerid] = CreatePlayerTextDraw(playerid, 542.799743, 123.448898, "PASSWORD");
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], 0.157197, 0.927999);
PlayerTextDrawTextSize(playerid, Textdraw2[playerid], -40.399986, -96.568801);
PlayerTextDrawAlignment(playerid, Textdraw2[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw2[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw2[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw2[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw2[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw2[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw2[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw2[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw2[playerid], 1);

Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 593.200012, 120.960006, "LD_BEAT:cross");
PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw3[playerid], 10.799949, 12.942222);
PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw3[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw3[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw3[playerid], true);

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 542.599792, 142.866622, "E-MAIL");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.157197, 0.927999);
PlayerTextDrawTextSize(playerid, Textdraw4[playerid], -40.399986, -96.568801);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw4[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw4[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);

Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 542.399780, 164.275436, "REFERRER");
PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.157197, 0.927999);
PlayerTextDrawTextSize(playerid, Textdraw5[playerid], -44.399990, -96.568809);
PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw5[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw5[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw5[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw5[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw5[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw5[playerid], 1);

Textdraw6[playerid] = CreatePlayerTextDraw(playerid, 542.599853, 185.684326, "FEMALE");
PlayerTextDrawLetterSize(playerid, Textdraw6[playerid], 0.157197, 0.927999);
PlayerTextDrawTextSize(playerid, Textdraw6[playerid], -44.399990, -96.568809);
PlayerTextDrawAlignment(playerid, Textdraw6[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw6[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw6[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw6[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw6[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw6[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw6[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw6[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw6[playerid], 1);

Textdraw7[playerid] = CreatePlayerTextDraw(playerid, 542.399658, 207.590957, "AMERICANOID");
PlayerTextDrawLetterSize(playerid, Textdraw7[playerid], 0.157197, 0.927999);
PlayerTextDrawTextSize(playerid, Textdraw7[playerid], -44.399990, -96.568809);
PlayerTextDrawAlignment(playerid, Textdraw7[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw7[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw7[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw7[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw7[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw7[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw7[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw7[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw7[playerid], 1);

Textdraw8[playerid] = CreatePlayerTextDraw(playerid, 592.999938, 140.377746, "LD_BEAT:cross");
PlayerTextDrawLetterSize(playerid, Textdraw8[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw8[playerid], 10.799949, 12.942222);
PlayerTextDrawAlignment(playerid, Textdraw8[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw8[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw8[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw8[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw8[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw8[playerid], true);

Textdraw9[playerid] = CreatePlayerTextDraw(playerid, 592.799926, 161.786621, "LD_BEAT:cross");
PlayerTextDrawLetterSize(playerid, Textdraw9[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw9[playerid], 10.799949, 12.942222);
PlayerTextDrawAlignment(playerid, Textdraw9[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw9[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw9[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw9[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw9[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw9[playerid], true);

Textdraw10[playerid] = CreatePlayerTextDraw(playerid, 592.599853, 183.195510, "LD_BEAT:cross");
PlayerTextDrawLetterSize(playerid, Textdraw10[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw10[playerid], 10.799949, 12.942222);
PlayerTextDrawAlignment(playerid, Textdraw10[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw10[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw10[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw10[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw10[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw10[playerid], true);

Textdraw11[playerid] = CreatePlayerTextDraw(playerid, 592.799804, 205.102096, "LD_BEAT:cross");
PlayerTextDrawLetterSize(playerid, Textdraw11[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw11[playerid], 10.799949, 12.942222);
PlayerTextDrawAlignment(playerid, Textdraw11[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw11[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw11[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw11[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw11[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw11[playerid], true);

Textdraw12[playerid] = CreatePlayerTextDraw(playerid, 514.799865, 254.364471, "LD_SPAC:white");
PlayerTextDrawLetterSize(playerid, Textdraw12[playerid], 0.000000, -0.479998);
PlayerTextDrawTextSize(playerid, Textdraw12[playerid], 55.999996, 64.711135);
PlayerTextDrawAlignment(playerid, Textdraw12[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw12[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw12[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw12[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw12[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw12[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw12[playerid], 144);
PlayerTextDrawFont(playerid, Textdraw12[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw12[playerid], 1);
PlayerTextDrawSetPreviewRot(playerid, Textdraw12[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

Textdraw13[playerid] = CreatePlayerTextDraw(playerid, 578.799804, 257.351013, "LD_BEAT:right");
PlayerTextDrawLetterSize(playerid, Textdraw13[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw13[playerid], 19.200012, 23.893310);
PlayerTextDrawAlignment(playerid, Textdraw13[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw13[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw13[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw13[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw13[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw13[playerid], true);

Textdraw14[playerid] = CreatePlayerTextDraw(playerid, 578.599853, 291.702087, "LD_BEAT:left");
PlayerTextDrawLetterSize(playerid, Textdraw14[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw14[playerid], 19.200012, 23.893310);
PlayerTextDrawAlignment(playerid, Textdraw14[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw14[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw14[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw14[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw14[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw14[playerid], true);

Textdraw15[playerid] = CreatePlayerTextDraw(playerid, 497.599975, 331.022216, "LOG UP");
PlayerTextDrawLetterSize(playerid, Textdraw15[playerid], 0.222799, 0.883198);
PlayerTextDrawTextSize(playerid, Textdraw15[playerid], 527.200134, 10.453330);
PlayerTextDrawAlignment(playerid, Textdraw15[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw15[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw15[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw15[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw15[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw15[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw15[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw15[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw15[playerid], 1);
PlayerTextDrawSetSelectable(playerid, Textdraw15[playerid], true);

Textdraw16[playerid] = CreatePlayerTextDraw(playerid, 542.599609, 228.999786, "AGE");
PlayerTextDrawLetterSize(playerid, Textdraw16[playerid], 0.157197, 0.927999);
PlayerTextDrawTextSize(playerid, Textdraw16[playerid], -44.399990, -96.568809);
PlayerTextDrawAlignment(playerid, Textdraw16[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw16[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw16[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw16[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw16[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw16[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw16[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw16[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw16[playerid], 1);

Textdraw17[playerid] = CreatePlayerTextDraw(playerid, 592.599731, 227.008712, "LD_BEAT:cross");
PlayerTextDrawLetterSize(playerid, Textdraw17[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw17[playerid], 10.799949, 12.942222);
PlayerTextDrawAlignment(playerid, Textdraw17[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw17[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw17[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw17[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw17[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw17[playerid], true);

