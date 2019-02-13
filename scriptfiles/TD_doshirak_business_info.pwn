
//Player Textdraws(Äëÿ èãðîêà):

new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new PlayerText:Textdraw2[MAX_PLAYERS];
new PlayerText:Textdraw3[MAX_PLAYERS];
new PlayerText:Textdraw4[MAX_PLAYERS];
new PlayerText:Textdraw5[MAX_PLAYERS];
new PlayerText:Textdraw6[MAX_PLAYERS];
new PlayerText:Textdraw7[MAX_PLAYERS];


Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 611.199768, 103.046669, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.000000, 16.208276);
PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 494.799987, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw0[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw0[playerid], 1419116325);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 0);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 552.800354, 123.448806, "BUSINESS NUMBER - 999");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 0.195997, 0.873242);
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

Textdraw2[playerid] = CreatePlayerTextDraw(playerid, 552.799865, 162.275588, "OWNER - THE STATE");
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], 0.195997, 0.873242);
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

Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 552.799987, 182.186599, "COST - $99999999");
PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.195997, 0.873242);
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

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 552.999938, 202.102188, "TYPE - Car Dealership");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.195997, 0.873242);
PlayerTextDrawTextSize(playerid, Textdraw4[playerid], 73.200088, 110.008979);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw4[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw4[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);

Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 608.400085, 223.508880, "usebox");
PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.000000, 2.338145);
PlayerTextDrawTextSize(playerid, Textdraw5[playerid], 498.399963, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw5[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw5[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw5[playerid], 102);
PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw5[playerid], 0);

Textdraw6[playerid] = CreatePlayerTextDraw(playerid, 553.200134, 229.475509, "You may buy this business! /buybusiness");
PlayerTextDrawLetterSize(playerid, Textdraw6[playerid], 0.141598, 1.171911);
PlayerTextDrawAlignment(playerid, Textdraw6[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw6[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw6[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw6[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw6[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw6[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw6[playerid], 1);

Textdraw7[playerid] = CreatePlayerTextDraw(playerid, 553.000427, 143.364303, "Coutt N Schutz");
PlayerTextDrawLetterSize(playerid, Textdraw7[playerid], 0.195997, 0.873242);
PlayerTextDrawTextSize(playerid, Textdraw7[playerid], 83.200057, 110.008956);
PlayerTextDrawAlignment(playerid, Textdraw7[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw7[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw7[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw7[playerid], 144);
PlayerTextDrawSetShadow(playerid, Textdraw7[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw7[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw7[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw7[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw7[playerid], 1);

