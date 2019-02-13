
//Player Textdraws(Äëÿ èãðîêà):

new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new PlayerText:Textdraw2[MAX_PLAYERS];
new PlayerText:Textdraw3[MAX_PLAYERS];
new PlayerText:Textdraw4[MAX_PLAYERS];
new PlayerText:Textdraw5[MAX_PLAYERS];
new PlayerText:Textdraw6[MAX_PLAYERS];


Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 611.199951, 103.046669, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.000000, 14.208275);
PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 494.799987, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw0[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw0[playerid], 1419116325);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 0);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 552.800354, 123.448806, "BUSINESS NUMBER - 999");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 0.183198, 0.878220);
PlayerTextDrawTextSize(playerid, Textdraw1[playerid], 83.200057, 110.008956);
PlayerTextDrawAlignment(playerid, Textdraw1[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw1[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw1[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw1[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw1[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw1[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw1[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw1[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw1[playerid], 1);

Textdraw2[playerid] = CreatePlayerTextDraw(playerid, 552.799865, 142.862274, "Coutt N Schutz");
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], 0.159997, 0.823466);
PlayerTextDrawTextSize(playerid, Textdraw2[playerid], 77.200065, 110.008949);
PlayerTextDrawAlignment(playerid, Textdraw2[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw2[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw2[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw2[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw2[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw2[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw2[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw2[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw2[playerid], 1);

Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 552.799926, 162.773345, "OWNER - The State");
PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.193599, 0.808533);
PlayerTextDrawTextSize(playerid, Textdraw3[playerid], 73.200088, 110.008979);
PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw3[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw3[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw3[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw3[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw3[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw3[playerid], 1);

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 552.399902, 209.564422, "Press Alt to enter!");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.281598, 1.301332);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);

Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 607.599975, 205.588897, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.000000, 2.338145);
PlayerTextDrawTextSize(playerid, Textdraw5[playerid], 497.600036, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw5[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw5[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw5[playerid], 102);
PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw5[playerid], 1);

Textdraw6[playerid] = CreatePlayerTextDraw(playerid, 552.599792, 182.191131, "TYPE - Car Dealership");
PlayerTextDrawLetterSize(playerid, Textdraw6[playerid], 0.193599, 0.808533);
PlayerTextDrawTextSize(playerid, Textdraw6[playerid], 78.000114, 109.511299);
PlayerTextDrawAlignment(playerid, Textdraw6[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw6[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw6[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw6[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw6[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw6[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw6[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw6[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw6[playerid], 1);

