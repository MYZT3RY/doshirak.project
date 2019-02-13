
//Player Textdraws(Äëÿ èãðîêà):

new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new PlayerText:Textdraw2[MAX_PLAYERS];
new PlayerText:Textdraw3[MAX_PLAYERS];
new PlayerText:Textdraw4[MAX_PLAYERS];


Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 610.800048, 101.055557, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.000000, 6.393472);
PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 494.399993, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw0[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw0[playerid], 1419116325);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 0);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 552.399719, 102.044418, "Dmitriy_Yakimov");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 0.247997, 0.863286);
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
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], 0.157196, 0.927999);
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
PlayerTextDrawTextSize(playerid, Textdraw3[playerid], 10.799948, 12.942221);
PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw3[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw3[playerid], 4);
PlayerTextDrawSetSelectable(playerid, Textdraw3[playerid], true);

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 497.600036, 150.826614, "LOG IN");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.222799, 0.883198);
PlayerTextDrawTextSize(playerid, Textdraw4[playerid], 527.200134, 10.453330);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw4[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw4[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetSelectable(playerid, Textdraw4[playerid], true);

