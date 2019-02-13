#include <a_samp>
#include <sscanf2>

/*

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

Author: iPLEOMAX
Note: Do not release any other version without my permission.

*/

#define ITD_VER                 "Version: 1.16 Stable (13/10/2012)"
#define ITD_List                "projects.lst"
#define ITD_File            	"%s.itd"
#define ITD                     "{62E300}iTD: {FFFFFF}"
#define ITD_E                   "{62E300}iTD: {FF0000}(Ошибка) {FFFFFF}"
#define ITD_W                   "{62E300}iTD: {FFB429}(Предупреждение) {FFFFFF}"
#define ITD_I                   "{62E300}iTD: {00FF00}(Информация) {FFFFFF}"

#if !defined isnull
	#define isnull(%1) \
				((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#define Send(%0,%1,%2)          SendClientMessage(%0, %1, %2)
#define LoopProjectTextdraws    for (new i = 0; i < MAX_PROJECT_TEXTDRAWS; i++)
#define CountRange(%0,%1)       for (new c = %0; c < %1; c++)
#define EmptyString(%0)         %0[0] = '\0'
#define iShowPlayerDialog       DialogShown = true, ShowPlayerDialog

#define INVALID_INDEX_ID        (-1)
#define MAX_PROJECT_TEXTDRAWS   (100)
#define MAX_UNDO_STATES         (1000)

#define VK_KEY_A	0x41
#define VK_KEY_B	0x42
#define VK_KEY_C	0x43
#define VK_KEY_D	0x44
#define VK_KEY_E	0x45
#define VK_KEY_F	0x46
#define VK_KEY_G	0x47
#define VK_KEY_H	0x48
#define VK_KEY_I	0x49
#define VK_KEY_J	0x4A
#define VK_KEY_K	0x4B
#define VK_KEY_L	0x4C
#define VK_KEY_M	0x4D
#define VK_KEY_N	0x4E
#define VK_KEY_O	0x4F
#define VK_KEY_P	0x50
#define VK_KEY_Q	0x51
#define VK_KEY_R	0x52
#define VK_KEY_S	0x53
#define VK_KEY_T	0x54
#define VK_KEY_U	0x55
#define VK_KEY_V	0x56
#define VK_KEY_W	0x57
#define VK_KEY_X	0x58
#define VK_KEY_Y	0x59
#define VK_KEY_Z	0x5A
#define VK_LBUTTON	0x01
#define VK_MBUTTON	0x04
#define VK_RBUTTON	0x02
#define VK_UP		0x26
#define VK_DOWN		0x28
#define VK_LEFT		0x25
#define VK_RIGHT	0x27
#define VK_LSHIFT	0xA0
#define VK_RSHIFT	0xA1
#define VK_SPACE    0x20

native GetVirtualKeyState(key);
native GetScreenSize(&Width, &Height);
native GetMousePos(&X, &Y);

enum
{
    DIALOG_NEW = 6900,
	DIALOG_LIST,
	DIALOG_CREATE,
	DIALOG_TEXT,
	DIALOG_PROJECTS,
	DIALOG_COLOR,
	DIALOG_HEXCOLOR,
	DIALOG_NUMCOLOR,
	DIALOG_PRECOLOR,
	DIALOG_POSITION,
	DIALOG_POSITIONC,
	DIALOG_SIZE,
	DIALOG_SIZEC,
	DIALOG_LETTER,
	DIALOG_LETTERC,
	DIALOG_FONT5,
	DIALOG_FONT5_SETMODELID,
	DIALOG_WARNING
};

enum
{
	EDITMODE_NONE,
	EDITMODE_TEXTDRAW,
	EDITMODE_USEBOX,
	EDITMODE_TEXTUREBOX,
	EDITMODE_POSITION,
	EDITMODE_SIZE,
	EDITMODE_LETTERSIZE,
	EDITMODE_COLOR,
	EDITMODE_BGCOLOR,
	EDITMODE_BOXCOLOR,
	EDITMODE_OUTLINE,
	EDITMODE_SHADOW,
	EDITMODE_PROPORTION,
	EDITMODE_SELECTABLE,
	EDITMODE_FONT,
	EDITMODE_ALIGNMENT,
	EDITMODE_BOX,
	EDITMODE_TYPE,
	EDITMODE_FONT5,
	EDITMODE_REMOVE
};
new f5mode;
enum
{
	F5EMODE_RX,
	F5EMODE_RY,
	F5EMODE_RZ,
	F5EMODE_RZOOM
};
enum
{
	COLORMODE_NONE,
	COLORMODE_RED,
	COLORMODE_GREEN,
	COLORMODE_BLUE,
	COLORMODE_ALPHA
};

enum
	E_TD_STRUCT
{
	Text:iTextdraw,
	iText[128],
	Float:iPositionX,
	Float:iPositionY,
	Float:iLetterX,
	Float:iLetterY,
	Float:iTextX,
	Float:iTextY,
	iAlignment,
	iColor,
	iUsebox,
	iBoxcolor,
	iShadow,
	iOutline,
	iBackgroundcolor,
	iFont,
	PreviewModel,
	iModelID,
	Float:iMRotX,
	Float:iMRotY,
	Float:iMRotZ,
	Float:iMZoom,
	iProportion,
	iSelectable,
	iType
};

enum
	E_KEY_STRUCT
{
	bool:KEY_PRESSED,
	KEY_CODE,
};

new
	Float:OffsetZ = 415.0,
	Text:TD_Menu[34] = {Text:INVALID_TEXT_DRAW, ...},
	Text:TD_MenuPM[2] = {Text:INVALID_TEXT_DRAW, ...},
	
	File:Handler,
	ProjectEditor,
	ProjectFile[64],
	Font5Edit[MAX_PLAYERS],
	
	bool:DialogShown,
	bool:MenuShown,
	bool:MenuHidden,
	bool:EditEnabled,
	Float:EditSpeed = 1.0,
	
	EditMode,
	EditIndex,
	ColorMode,
	Colors[4],
	
	Project[MAX_PROJECT_TEXTDRAWS][E_TD_STRUCT],
	
	String_Large[3584],
	String_Textdraw[512],
	String_Message[128],
	String_Normal[96],
	
	States[MAX_UNDO_STATES][sizeof String_Textdraw],
	
	UpdateTimer,
	CursorOX, CursorOY,
	CursorX, CursorY,
	ScreenWidth, ScreenHeight,
	VirtualKeys[36][E_KEY_STRUCT]
;

new PremadeColors[][] =
{
	{ 0xFF0000FF , "Красный" },
	{ 0xFFFFFFFF , "Белый" },
	{ 0x00FFFFFF , "Голубой" },
	{ 0xC0C0C0FF , "Серебристый" },
	{ 0x0000FFFF , "Синий" },
	{ 0x808080FF , "Серый" },
	{ 0x0000A0FF , "Темно-голубой" },
	{ 0x000000FF , "Черный" },
	{ 0xADD8E6FF , "Светло-голубой" },
	{ 0xFFA500FF , "Оранжевый" },
	{ 0x800080FF , "Розовый" },
	{ 0xA52A2AFF , "Коричневый" },
	{ 0xFFFF00FF , "Желтый" },
	{ 0x800000FF , "Коричнево-малиновый" },
	{ 0x00FF00FF , "Лайм" },
	{ 0x008000FF , "Зеленый" },
	{ 0xFF00FFFF , "Fuchsia" },
	{ 0x808000FF , "Оливковый" }
};

public OnFilterScriptInit()
{
	printf("\n\tiPLEOMAX's TextDraw Editor loaded successfully!\n\t%s\n", ITD_VER);
    Initiate();
	return true;
}

public OnFilterScriptExit()
{
    Dispose();
    return true;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!strcmp(cmdtext, "/itd", true, 4))
	{
	    if(ProjectEditor == playerid)
	    {
	        if(strlen(cmdtext) >= 6)
			{
				if(!strcmp(cmdtext[5], "top", true))
				{
					OffsetZ = 0.0;
					if(MenuShown && !MenuHidden) ShowEditor();
					return Send(playerid, -1, #ITD_I"Menu location set to: TOP");
				} else

				if(!strcmp(cmdtext[5], "bottom", true))
				{
					OffsetZ = 415.0;
					if(MenuShown && !MenuHidden) ShowEditor();
					return Send(playerid, -1, #ITD_I"Menu location set to: BOTTOM");
				} else
				
				return Send(playerid, -1, "Используйте: /itd (Top / Bottom / Center)");
			}
			return Send(playerid, -1, #ITD_I"Нажмите ESC чтобы выйти из меню iTD.");
	    }
		
		GetPlayerIp(playerid, String_Normal, 16);
		
		/*if(strcmp(String_Normal, "127.0.0.1", false))
		return Send(playerid, -1, #ITD_E"samp-server.exe is not running in this computer! Make sure the server is at localhost, not remote.");*/
		
		if(ProjectEditor != playerid && ProjectEditor != INVALID_PLAYER_ID)
		return Send(playerid, -1, #ITD_E"Кто-то другой уже использует редактор.");
		
		
		Send(playerid, -1, "Добро пожаловать в {62E300}iPLEOMAX's Textdraw Editor{FFFFFF}. Приступайте к редактированию!");
		ProjectEditor = playerid;
		ShowEditor();
		return true;
	}
	return false;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(playerid != ProjectEditor) return false;
	DialogShown = false;
	
	switch(dialogid)
	{
	    case DIALOG_NEW:
	    {
	        if(response)
	        {
	            if( !(1 <= strlen(inputtext) <= 32) )
	            return Send(playerid, -1, #ITD_I"Название проекта должно быть в пределах от 1 до 32 символов");

				if( !IsValidProjectName(inputtext) )
				return Send(playerid, -1, #ITD_I"Название проекта должно состоять только из: A-Z, 0-9, -, _, (, )");
				
				if(strlen(ProjectFile)) CloseProject();
				format(ProjectFile, sizeof ProjectFile, ITD_File, inputtext);
				
				if(!CheckProject(inputtext)) AddProject(ProjectFile);
				
				if(fexist(ProjectFile)) {
				    
					LoadProject();
					format(String_Message, 128, "%sПроект: '%s' уже существует, и был загружен!", ITD_I, ProjectFile);
	    			Send(ProjectEditor, -1, String_Message);
	    			
				} else {
				    Handler = fopen(ProjectFile, io_write);
				    fclose(Handler);
				}
				
				ShowEditor();
				return true;
			}
	    }
	    case DIALOG_PROJECTS:
	    {
	        if(response)
	        {
	            Handler = fopen(ITD_List, io_read);
             	if(!Handler) return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (project.lst)");
             	
             	new Index = -1;
             	while(fread(Handler, String_Normal))
             	{
             	    if(!strlen(String_Normal)) continue;
             	    Index++;
             	    
             	    if(Index == listitem)
             	    {
             	    	StripNewLine(String_Normal);
             	    	
             	    	if(strlen(ProjectFile))
             	    	{
	             	    	SaveProject(true);
	             	    	CloseProject();
             	    	}
             	    	
             	    	format(ProjectFile, sizeof ProjectFile, "%s", String_Normal);
             	    	LoadProject(true);
             	    }
             	}
	        }
	        
	        return true;
	    }
	    case DIALOG_LIST:
	    {
	        if(response)
	        {
	            switch(listitem)
	            {
	                case 0: ShowCreateDialog();
	                case 1:
					{
						TextDrawEdit(EDITMODE_REMOVE);
						ShowTextDrawList();
					}
					case 2:
					{
						LoopProjectTextdraws RemoveTextDraw(i);
					}
	                default:
	                {
	                    listitem -= 3;
	                    new match = -1;
						LoopProjectTextdraws
						{
						    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
						    match++;
						    if(match == listitem)
						    {
						        EditIndex = i;
						        ShowTextDrawList();
						        if(!MenuHidden) ShowEditor();
						    }
						}
	                }
	            }
	        }
	    }
		case DIALOG_CREATE:
		{
		    if(!response) return ShowTextDrawList();

            new Index = GetAvailableIndex();
		    if(Index == INVALID_INDEX_ID)
			return Send(ProjectEditor, -1, #ITD_E"Лимит ТД в проекте достигнут! Создание ТД больше невозможно.");
            EditIndex = Index;

		    switch(listitem)
		    {
		        case 0: TextDrawEdit(EDITMODE_TEXTDRAW);
		        case 1: TextDrawEdit(EDITMODE_USEBOX);
		        case 2: TextDrawEdit(EDITMODE_TEXTUREBOX);
		    }
		    
		    return true;
		}
	    case DIALOG_POSITION:
	    {
	        if(!response) return true;
            switch(listitem)
            {
                case 0: TextDrawEdit(EDITMODE_POSITION);
                case 1: ShowPositionCustomDialog();
            }
            return true;
	    }
	    case DIALOG_POSITIONC:
	    {
	        if(!response) return ShowPositionDialog();
	        if(strlen(inputtext) < 3) return ShowPositionCustomDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Неправильное редактирование индекса @DIALOGPOSITIONC (Отчет ошибки)");
	        
	        new Float:iTemp1, Float:iTemp2;
	        
	        if(!sscanf(inputtext, "ff", iTemp1, iTemp2) ||
				!sscanf(inputtext, "p<,>ff", iTemp1, iTemp2))
	        {
	            SaveTextDrawState(EditIndex);
	            Project[EditIndex][iPositionX] = iTemp1;
	            Project[EditIndex][iPositionY] = iTemp2;
	            
	            UpdateTextDraw(EditIndex);
	            Send(playerid, -1, #ITD_I"Позиция ТД обновлена!");
	        } else {
	            ShowPositionCustomDialog();
	            Send(playerid, -1, #ITD_E"Неправильный форматирование координат");
	        }
	        return true;
	    }
	    case DIALOG_SIZE:
	    {
	        if(response)
	        {
	            switch(listitem)
	            {
	                case 0: TextDrawEdit(EDITMODE_SIZE);
	                case 1: ShowSizeCustomDialog();
	            }
	        }
	        return true;
	    }
	    case DIALOG_SIZEC:
	    {
	        if(!response) return ShowSizeDialog();
	        if(strlen(inputtext) < 3) return ShowSizeCustomDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Неправильное редактирование индекса @DIALOGSIZEC (Отчет об ошибке)");
	        
	        new Float:iTemp1, Float:iTemp2;
	        
	        if(!sscanf(inputtext, "ff", iTemp1, iTemp2) ||
				!sscanf(inputtext, "p<,>ff", iTemp1, iTemp2))
	        {
	            SaveTextDrawState(EditIndex);
	            Project[EditIndex][iTextX] = iTemp1;
	            Project[EditIndex][iTextY] = iTemp2;
	        
	            UpdateTextDraw(EditIndex);
	            Send(playerid, -1, #ITD_I"Text Size обновлен!");
	        } else {
	            ShowSizeCustomDialog();
	            Send(playerid, -1, #ITD_E"Неправильный форматирование размера");
	        }
	        return true;
	    }
	    case DIALOG_LETTER:
	    {
	        if(response)
	        {
	            switch(listitem)
	            {
	                case 0: TextDrawEdit(EDITMODE_LETTERSIZE);
	                case 1: ShowLetterCustomDialog();
	            }
	        }
	        return true;
	    }
	    case DIALOG_LETTERC:
	    {
	        if(!response) return ShowLetterDialog();
	        if(strlen(inputtext) < 3) return ShowLetterCustomDialog();
            if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Неправильное редактирование индекса @DIALOGLETTERC (Отчет об ошибке)");

            new Float:iTemp1, Float:iTemp2;

	        if(!sscanf(inputtext, "ff", iTemp1, iTemp2) ||
				!sscanf(inputtext, "p<,>ff",iTemp1, iTemp2))
	        {
	            SaveTextDrawState(EditIndex);
	            Project[EditIndex][iLetterX] = iTemp1;
	            Project[EditIndex][iLetterY] = iTemp2;
	        
	            UpdateTextDraw(EditIndex);
	            Send(playerid, -1, #ITD_I"Letter Size обновлен!");
	        } else {
	            ShowLetterCustomDialog();
	            Send(playerid, -1, #ITD_E"Неправильный форматирование размера");
	        }
	        return true;
	    }
	    case DIALOG_TEXT:
	    {
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Неправильное редактирование индекса @DIALOGTEXT (Отчет об ошибке)");
	        if(response)
	        {
	            if(!strlen(inputtext)) return ShowTextDialog();
	            
	            SaveTextDrawState(EditIndex);
	            format(Project[EditIndex][iText], 128, "%s", TextToRussia(inputtext));
	            UpdateTextDraw(EditIndex);
	        }
	        return true;
	    }
	    case DIALOG_COLOR:
	    {
	        if(response)
	        {
				switch(listitem)
				{
				    case 0: ShowHEXColorDialog();
				    case 1: ShowNUMColorDialog();
				    case 2: ShowPREColorDialog();
				}
			}
			return true;
	    }
	    case DIALOG_HEXCOLOR:
	    {
	        if(!response) return ShowColorDialog();
	        if(strlen(inputtext) < 8) return ShowHEXColorDialog();
			if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Неправильное редактирование индекса @DIALOGHEXCOLOR (Отчет об ошибке)");
	        
	        if(inputtext[0] == '0' && inputtext[1] == 'x')
	        {
	            Colors[0] = HexToInt(inputtext[2]);
	        } else
			if(inputtext[0] == '#')
	        {
	            Colors[0] = HexToInt(inputtext[1]);
	        } else
	        {
	            Colors[0] = HexToInt(inputtext);
	        }
	        
	        SaveTextDrawState(EditIndex);
	        switch(EditMode)
	        {
	            case EDITMODE_COLOR: 	Project[EditIndex][iColor] = Colors[0];
	            case EDITMODE_BGCOLOR: 	Project[EditIndex][iBackgroundcolor] = Colors[0];
	            case EDITMODE_BOXCOLOR: Project[EditIndex][iBoxcolor] = Colors[0];
	        }
	        
	        UpdateTextDraw(EditIndex);
	        return Send(playerid, Colors[0], "< Цвет установлен >");
	    }
	    case DIALOG_NUMCOLOR:
	    {
	        if(!response) return ShowColorDialog();
	        if(!strlen(inputtext)) return ShowNUMColorDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Неправильное редактирование индекса @DIALOGNUMCOLOR (Отчет об ошибке)");
	        
	        if(!sscanf(inputtext, "iiii", Colors[0], Colors[1], Colors[2], Colors[3]) ||
				!sscanf(inputtext, "p<,>iiii", Colors[0], Colors[1], Colors[2], Colors[3]))
	        {
	            SaveTextDrawState(EditIndex);
	            switch(EditMode)
		        {
		            case EDITMODE_COLOR: 	Project[EditIndex][iColor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
		            case EDITMODE_BGCOLOR: 	Project[EditIndex][iBackgroundcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
		            case EDITMODE_BOXCOLOR: Project[EditIndex][iBoxcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
		        }
	        } else {
				Send(playerid, -1, #ITD_E"Неправильный формат цвета | Пример: 255, 0, 0, 125 (Красный цвет с 50%% прозрачностью)");
				return ShowNUMColorDialog();
			}
			
			UpdateTextDraw(EditIndex);
			return Send(playerid, RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]), "< Цвет установлен >");
	    }
	    case DIALOG_PRECOLOR:
	    {
	        if(!response) return ShowColorDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Неправильное редактирование индекса @DIALOGPRECOLOR (Отчет об ошибке)");
	        
	        SaveTextDrawState(EditIndex);
	        switch(EditMode)
	        {
	            case EDITMODE_COLOR: 	Project[EditIndex][iColor] = PremadeColors[listitem][0];
	            case EDITMODE_BGCOLOR: 	Project[EditIndex][iBackgroundcolor] = PremadeColors[listitem][0];
	            case EDITMODE_BOXCOLOR: Project[EditIndex][iBoxcolor] = PremadeColors[listitem][0];
	        }
	        
	        UpdateTextDraw(EditIndex);
	        return Send(playerid, PremadeColors[listitem][0], "< Цвет установлен >");
	    }
	    case DIALOG_WARNING:
	    {
	        if(!response) ShowSizeDialog();
	        return true;
	    }
	    case DIALOG_FONT5:
	    {
	        if(response)
	        {
	            switch(listitem)
	            {
	                case 0:
	                {
	                    Font5Edit[playerid] = 1;
	                	ShowPlayerDialog(playerid, DIALOG_FONT5_SETMODELID, DIALOG_STYLE_INPUT, "ID модели", "Введите ID модели", "Принять", "Выйти");
	                }
	                case 1:
	                {
	                    Font5Edit[playerid] = 2;
	                	ShowPlayerDialog(playerid, DIALOG_FONT5_SETMODELID, DIALOG_STYLE_INPUT, "Ось X", "Введите координаты по оси X", "Принять", "Выйти");
	                }
	                case 2:
	                {
	                    Font5Edit[playerid] = 3;
	                	ShowPlayerDialog(playerid, DIALOG_FONT5_SETMODELID, DIALOG_STYLE_INPUT, "Ось Y", "Введите координаты по оси Y", "Принять", "Выйти");
	                }
	                case 3:
	                {
	                    Font5Edit[playerid] = 4;
	                	ShowPlayerDialog(playerid, DIALOG_FONT5_SETMODELID, DIALOG_STYLE_INPUT, "Ось Z", "Введите координаты по оси Z", "Принять", "Выйти");
	                }
	                case 4:
	                {
	                    Font5Edit[playerid] = 5;
	                	ShowPlayerDialog(playerid, DIALOG_FONT5_SETMODELID, DIALOG_STYLE_INPUT, "Размеры модели", "Введите размер.\n(Пример: 1.0 или 1)", "Принять", "Выйти");
	                }
	                case 5:
	                {
	                    EditMode = EDITMODE_FONT5;
	                }
	            }
	        }
	    }
	    case DIALOG_FONT5_SETMODELID:
	    {
	        if(response)
	        {
	            if(Font5Edit[playerid] == 1)
	            {
	            	Project[EditIndex][iModelID] = strval(inputtext);
	            	UpdateTextDraw(EditIndex);
	            }
	            if(Font5Edit[playerid] == 2)
	            {
	                Project[EditIndex][iMRotX] = strval(inputtext);
	            	UpdateTextDraw(EditIndex);
	            }
	            if(Font5Edit[playerid] == 3)
	            {
	                Project[EditIndex][iMRotY] = strval(inputtext);
	            	UpdateTextDraw(EditIndex);
	            }
	            if(Font5Edit[playerid] == 4)
	            {
	                Project[EditIndex][iMRotZ] = strval(inputtext);
	            	UpdateTextDraw(EditIndex);
	            }
	            if(Font5Edit[playerid] == 5)
	            {
	                Project[EditIndex][iMZoom] = strval(inputtext);
	            	UpdateTextDraw(EditIndex);
	            }
	        }
	    }
	}
	
	return false;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	//format(String_Message, sizeof String_Message, "Clickedid: %i", _:clickedid);
	//Send(playerid, -1, String_Message);
	
	if(playerid != ProjectEditor) return false;
	
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
	    if(DialogShown)
	    {
	        Send(ProjectEditor, -1, #ITD_W"Пожалуйста, закройте сначала этот диалог!");
	        return SelectTextDraw(playerid, -1);
	    }
	    if(MenuHidden) return ShowEditor();
		if(MenuShown) return HideEditor();
	    return true;
	}
	
	if(clickedid == TD_Menu[1]) iShowPlayerDialog(playerid, DIALOG_NEW, DIALOG_STYLE_INPUT,
	"Новый проект", "\nПожалуйста, введите новое название проекта:\n", "Принять", "Выйти");
	
	if(clickedid == TD_Menu[2])		return ShowProjectList();
	if(clickedid == TD_Menu[3])     return CloseProject(true);
	if(clickedid == TD_Menu[4])     return ExportProject();
	if(clickedid == TD_Menu[8])     return ShowTextDrawList();
	if(clickedid == TD_Menu[9]) 	return ShowPositionDialog();
	if(clickedid == TD_Menu[10]) 	return ShowSizeDialog(true);
	if(clickedid == TD_Menu[11]) 	return ShowTextDialog();
	if(clickedid == TD_Menu[16]) 	return ShowLetterDialog();
	if(clickedid == TD_Menu[14]) 	return TextDrawEdit(EDITMODE_COLOR);
	if(clickedid == TD_Menu[15]) 	return TextDrawEdit(EDITMODE_BGCOLOR);
	if(clickedid == TD_Menu[32]) 	return TextDrawEdit(EDITMODE_BOXCOLOR);
	if(clickedid == TD_Menu[17]) 	return TextDrawEdit(EDITMODE_OUTLINE);
	if(clickedid == TD_Menu[18]) 	return TextDrawEdit(EDITMODE_SHADOW);
	if(clickedid == TD_Menu[31] || clickedid == TD_Menu[30]) return TextDrawEdit(EDITMODE_PROPORTION);
    if(clickedid == TD_Menu[29] || clickedid == TD_Menu[28]) return TextDrawEdit(EDITMODE_SELECTABLE);
    if(clickedid == TD_Menu[27]){ return TextDrawEdit(EDITMODE_FONT);}
	if(clickedid == TD_Menu[26]){ return TextDrawEdit(EDITMODE_FONT);}
	if(clickedid == TD_Menu[25]){ return TextDrawEdit(EDITMODE_FONT);}
	if(clickedid == TD_Menu[24]){ return TextDrawEdit(EDITMODE_FONT);}
	if(clickedid == TD_Menu[12]){ return TextDrawEdit(EDITMODE_FONT);}
	if(clickedid == TD_MenuPM[0]){ return TextDrawEdit(EDITMODE_FONT);}
	if(clickedid == TD_MenuPM[1]){ return ShowFont5Menu(playerid); }
    if(clickedid == TD_Menu[23] || clickedid == TD_Menu[22] || clickedid == TD_Menu[21]) return TextDrawEdit(EDITMODE_ALIGNMENT);
    if(clickedid == TD_Menu[20] || clickedid == TD_Menu[19]) return TextDrawEdit(EDITMODE_BOX);
	if(clickedid == TD_Menu[5] || clickedid == TD_Menu[33]) return TextDrawEdit(EDITMODE_TYPE);
	return false;
}

forward OnEditorUpdate();
public OnEditorUpdate()
{
	CountRange(0, sizeof VirtualKeys)
	{
		if(GetVirtualKeyState(VirtualKeys[c][KEY_CODE]) & 0x8000)
		{
		    if(!VirtualKeys[c][KEY_PRESSED])
		    {
		        CallLocalFunction("OnVirtualKeyDown", "d", VirtualKeys[c][KEY_CODE]);
		        VirtualKeys[c][KEY_PRESSED] = true;
		    }
		}
		else if(VirtualKeys[c][KEY_PRESSED])
		{
		    CallLocalFunction("OnVirtualKeyRelease", "d", VirtualKeys[c][KEY_CODE]);
		    VirtualKeys[c][KEY_PRESSED] = false;
		}
	}

	GetScreenSize(ScreenWidth, ScreenHeight);
	GetMousePos(CursorX, CursorY);

	if(CursorOX != CursorX || CursorOY != CursorY)
	{
	    CallLocalFunction("OnCursorPositionChange", "dd", CursorX, CursorY);
	    CursorOX = CursorX;
	    CursorOY = CursorY;
	}
}

stock ShowValues(Float:ZPos, Float:X, Float:Y)
{
    if(ZPos >= 220)
	{
	    format(String_Normal, sizeof String_Normal, "~w~%.3f, %.3f", X, Y);
	    GameTextForPlayer(ProjectEditor, String_Normal, 1000, 4);
	} else {
	    format(String_Normal, sizeof String_Normal, "~n~~n~~n~~n~%.3f, %.3f", X, Y);
	    GameTextForPlayer(ProjectEditor, String_Normal, 1000, 5);
	}
}

forward OnCursorPositionChange(NewX, NewY);
public OnCursorPositionChange(NewX, NewY)
{
    if(EditEnabled)
	{
	    switch(EditMode)
	    {
	        case EDITMODE_POSITION:
	        {
	            if(Project[EditIndex][iUsebox] && Project[EditIndex][iLetterX] == 0.0)
			    {
			        Project[EditIndex][iPositionX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
				    Project[EditIndex][iTextX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
		    		Project[EditIndex][iPositionY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed;
		    		ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iTextX], Project[EditIndex][iPositionY]);
			    } else {
			        Project[EditIndex][iPositionX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
			    	Project[EditIndex][iPositionY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed;
			    	ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iPositionX], Project[EditIndex][iPositionY]);
			    }
			    UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_USEBOX:
	        {
	            Project[EditIndex][iPositionX] = (floatdiv(NewX, ScreenWidth) * 640.0) + 2.0;
			    Project[EditIndex][iLetterY] = ((floatdiv(NewY, ScreenHeight) * 448.0) - Project[EditIndex][iPositionY])/9.0;
			    Project[EditIndex][iLetterY] -= 0.15;
			    UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_TEXTUREBOX:
	        {
	            Project[EditIndex][iTextX] = (floatdiv((NewX == ScreenWidth - 1) ? ScreenWidth : NewX, ScreenWidth) * 640.0) - Project[EditIndex][iPositionX];
	    		Project[EditIndex][iTextY] = (floatdiv((NewY == ScreenHeight - 1) ? ScreenHeight : NewY, ScreenHeight) * 448.0) - Project[EditIndex][iPositionY];
    			ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iTextX], Project[EditIndex][iTextY]);
				UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_SIZE:
			{
                if(Project[EditIndex][iUsebox] && Project[EditIndex][iLetterX] == 0.0)
			    {
			        Project[EditIndex][iLetterY] -= (floatdiv(floatsub(CursorOY, NewY), ScreenWidth) * 640.0)/10.0 * EditSpeed;
				    Project[EditIndex][iPositionX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
			    } else {
				    Project[EditIndex][iTextX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
				    Project[EditIndex][iTextY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed;
				    ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iTextX], Project[EditIndex][iTextY]);
			    }
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_LETTERSIZE:
			{
			    Project[EditIndex][iLetterX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed * 0.001;
			    Project[EditIndex][iLetterY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed * 0.01;
			    ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iLetterX], Project[EditIndex][iLetterY]);
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_OUTLINE:
			{
			    Project[EditIndex][iOutline] -= floatround(floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0);
			    Project[EditIndex][iOutline] -= floatround(floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0);
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_SHADOW:
			{
			    Project[EditIndex][iShadow] -= floatround(floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0);
			    Project[EditIndex][iShadow] -= floatround(floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0);
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_FONT5:
			{
			    switch(f5mode)
			    {
			    	case F5EMODE_RX:    Project[EditIndex][iMRotX] = floatround(floatdiv(NewY, ScreenHeight) * 360.0);
	            	case F5EMODE_RY:    Project[EditIndex][iMRotY] = floatround(floatdiv(NewX, ScreenWidth) * 360.0);
	            	case F5EMODE_RZ:    Project[EditIndex][iMRotZ] = floatround(floatdiv(NewY, ScreenHeight) * 360.0);
	            	case F5EMODE_RZOOM: Project[EditIndex][iMZoom] = floatround(floatdiv(NewX, ScreenWidth) * 360.0);
	            }
	            format(String_Normal, sizeof String_Normal, "~n~RX%f~n~RY%f~n~RZ%f~n~Zoom%f", Project[EditIndex][iMRotX], Project[EditIndex][iMRotY], Project[EditIndex][iMRotZ], Project[EditIndex][iMZoom]);
				GameTextForPlayer(ProjectEditor, String_Normal, 1000, 3);
	            UpdateTextDraw(EditIndex);
			}
			case EDITMODE_COLOR:
	        {
	            HexToRGBA(Project[EditIndex][iColor], Colors[0], Colors[1], Colors[2], Colors[3]);
	            switch(ColorMode)
	            {
	                case COLORMODE_RED: Colors[0] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0  );
	                case COLORMODE_GREEN: Colors[1] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
                    case COLORMODE_BLUE: Colors[2] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0 );
                    case COLORMODE_ALPHA: Colors[3] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
				}
				format(String_Normal, sizeof String_Normal, "~n~~r~R%i~n~~g~G%i~n~~b~B%i~n~~w~A%i", Colors[0], Colors[1], Colors[2], Colors[3]);
				GameTextForPlayer(ProjectEditor, String_Normal, 1000, 3);
	            Project[EditIndex][iColor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
	            UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_BGCOLOR:
	        {
	            HexToRGBA(Project[EditIndex][iBackgroundcolor], Colors[0], Colors[1], Colors[2], Colors[3]);
	            switch(ColorMode)
	            {
	                case COLORMODE_RED: Colors[0] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0  );
	                case COLORMODE_GREEN: Colors[1] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
                    case COLORMODE_BLUE: Colors[2] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0 );
                    case COLORMODE_ALPHA: Colors[3] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
				}
				format(String_Normal, sizeof String_Normal, "~n~~r~R%i~n~~g~G%i~n~~b~B%i~n~~w~A%i", Colors[0], Colors[1], Colors[2], Colors[3]);
				GameTextForPlayer(ProjectEditor, String_Normal, 1000, 3);
	            Project[EditIndex][iBackgroundcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
	            UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_BOXCOLOR:
	        {
	            HexToRGBA(Project[EditIndex][iBoxcolor], Colors[0], Colors[1], Colors[2], Colors[3]);
	            switch(ColorMode)
	            {
	                case COLORMODE_RED: Colors[0] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0  );
	                case COLORMODE_GREEN: Colors[1] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
                    case COLORMODE_BLUE: Colors[2] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0 );
                    case COLORMODE_ALPHA: Colors[3] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
				}
				format(String_Normal, sizeof String_Normal, "~n~~r~R%i~n~~g~G%i~n~~b~B%i~n~~w~A%i", Colors[0], Colors[1], Colors[2], Colors[3]);
				GameTextForPlayer(ProjectEditor, String_Normal, 1000, 3);
	            Project[EditIndex][iBoxcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
	            UpdateTextDraw(EditIndex);
	        }
	    }
	}
	return true;
}

forward OnVirtualKeyDown(key);
public OnVirtualKeyDown(key)
{
    if(!EditEnabled && ProjectEditor != INVALID_PLAYER_ID && MenuHidden && MenuShown && !DialogShown)
	{
	    switch(key)
	    {
	        case VK_KEY_M: ShowTextDrawList();
			case VK_KEY_N: ShowCreateDialog();
			case VK_KEY_Z: UndoTextDrawState();
	    }
	    if(EditIndex != INVALID_INDEX_ID)
	    {
			if(Project[EditIndex][iTextdraw] != Text:INVALID_TEXT_DRAW)
			{
			    switch(key)
			    {
			        case VK_KEY_C: 
			        {
						new ToIndex = GetAvailableIndex();
						if(ToIndex == INVALID_INDEX_ID) return Send(ProjectEditor, -1, #ITD_E"Проект достиг лимита ТД! Создание новых ТД невозможно.");
						CopyTextDraw(EditIndex, ToIndex);
			        }
			        case VK_KEY_X:
			        {
			            TextDrawEdit(EDITMODE_REMOVE);
						ShowTextDrawList();
			        }
			        case VK_KEY_F: TextDrawEdit(EDITMODE_FONT);
			        case VK_KEY_P: TextDrawEdit(EDITMODE_POSITION);
			        case VK_KEY_S: ShowSizeDialog(true);
			        case VK_KEY_Y: ShowTextDialog();
			        case VK_KEY_L: ShowLetterDialog();
			        case VK_KEY_Q: TextDrawEdit(EDITMODE_COLOR);
			        case VK_KEY_B: TextDrawEdit(EDITMODE_BGCOLOR);
			        case VK_KEY_I: TextDrawEdit(EDITMODE_BOXCOLOR);
			        case VK_KEY_U: TextDrawEdit(EDITMODE_BOX);
			        case VK_KEY_O: TextDrawEdit(EDITMODE_OUTLINE);
			        case VK_KEY_W: TextDrawEdit(EDITMODE_SHADOW);
			        case VK_KEY_G: TextDrawEdit(EDITMODE_TYPE);
			        case VK_KEY_A: TextDrawEdit(EDITMODE_ALIGNMENT);
			        case VK_KEY_K: TextDrawEdit(EDITMODE_SELECTABLE);
			        case VK_KEY_R: TextDrawEdit(EDITMODE_PROPORTION);
				}
			}
	    }
	}
	
	switch(key)
	{
	    case VK_LBUTTON:
	    {
	        switch(EditMode)
	        {
                case EDITMODE_FONT5:
		        {
              		SaveTextDrawState(EditIndex);

		            if(!CursorX && 0 < CursorY < ScreenHeight && f5mode != F5EMODE_RX){ f5mode = F5EMODE_RX; }

		            if(CursorX == ScreenWidth && 0 < CursorY < ScreenHeight && f5mode != F5EMODE_RY){ f5mode = F5EMODE_RY; }

		            if(!CursorY && 0 < CursorX < ScreenWidth && f5mode != F5EMODE_RZ){ f5mode = F5EMODE_RZ; }

		            if(CursorY == ScreenHeight && 0 < CursorX < ScreenWidth && f5mode != F5EMODE_RZOOM) { f5mode = F5EMODE_RZOOM; }

		            EditEnabled = true;
		        }
	            case EDITMODE_COLOR, EDITMODE_BOXCOLOR, EDITMODE_BGCOLOR:
		        {
              		SaveTextDrawState(EditIndex);

		            if(!CursorX && (0 < CursorY < (ScreenHeight - 1)) && ColorMode != COLORMODE_RED)
					ColorMode = COLORMODE_RED;

		            if(CursorX == (ScreenWidth - 1) && (0 < CursorY < (ScreenHeight - 1)) && ColorMode != COLORMODE_BLUE)
					ColorMode = COLORMODE_BLUE;

		            if(!CursorY && (0 < CursorX < (ScreenWidth - 1)) && ColorMode != COLORMODE_GREEN)
					ColorMode = COLORMODE_GREEN;

		            if(CursorY == (ScreenHeight - 1) && (0 < CursorX < (ScreenWidth - 1)) && ColorMode != COLORMODE_ALPHA)
					ColorMode = COLORMODE_ALPHA;

		            EditEnabled = true;
		        }
	            case EDITMODE_TEXTDRAW:
	            {
	                SaveTextDrawState(EditIndex, true);
	                
					format(Project[EditIndex][iText], 128, "New Textdraw");
	                Project[EditIndex][iPositionX] = floatdiv(CursorX, ScreenWidth) * 640.0;
				    Project[EditIndex][iPositionY] = floatdiv(CursorY, ScreenHeight) * 448.0;
		            Project[EditIndex][iLetterX] = 0.45, Project[EditIndex][iLetterY] = 1.6;
		            Project[EditIndex][iColor] = 0xFFFFFFFF;
				    Project[EditIndex][iBackgroundcolor] = 51;
				    Project[EditIndex][iFont] = 1;
				    Project[EditIndex][iOutline] = 1;
				    Project[EditIndex][iProportion] = 1;
				    Project[EditIndex][iAlignment] = 1;
				    UpdateTextDraw(EditIndex);
				    EditMode = EDITMODE_POSITION;
				    EditEnabled = true;
	            }
	            case EDITMODE_USEBOX:
	            {
	                SaveTextDrawState(EditIndex, true);
	                
	                format(Project[EditIndex][iText], 128, "usebox");
	                Project[EditIndex][iAlignment] = 1;
	                Project[EditIndex][iBoxcolor] = 0x00000066;
	                Project[EditIndex][iUsebox] = 1;
	                Project[EditIndex][iPositionX] = (floatdiv(CursorX, ScreenWidth) * 640.0) - 2.0;
					Project[EditIndex][iPositionY] = (floatdiv(CursorY, ScreenHeight) * 448.0) + 1.5;
					Project[EditIndex][iTextX] = Project[EditIndex][iPositionX];
					Project[EditIndex][iLetterX] = 0.0;
					Project[EditIndex][iLetterY] = 0.0;
					EditEnabled = true;
	            }
	            case EDITMODE_TEXTUREBOX:
	            {
	                SaveTextDrawState(EditIndex, true);
	                
	                format(Project[EditIndex][iText], 128, "LD_SPAC:white");
				    Project[EditIndex][iAlignment] = 1;
				    Project[EditIndex][iFont] = 4;
				    Project[EditIndex][iPositionX] = floatdiv(CursorX, ScreenWidth) * 640.0;
				    Project[EditIndex][iPositionY] = floatdiv(CursorY, ScreenHeight) * 448.0;
				    Project[EditIndex][iColor] = 0xFFFFFFFF;
					EditEnabled = true;
	            }
	            case EDITMODE_POSITION, EDITMODE_SIZE, EDITMODE_LETTERSIZE, EDITMODE_OUTLINE, EDITMODE_SHADOW:
	            {
	                SaveTextDrawState(EditIndex);
	                EditEnabled = true;
	            }
	        }
	    }
	    case VK_RBUTTON:
	    {
	        switch(EditMode)
		    {
		        case EDITMODE_OUTLINE:
				{
					SaveTextDrawState(EditIndex);
					Project[EditIndex][iOutline] = 0;
					UpdateTextDraw(EditIndex);
				}
		        case EDITMODE_SHADOW:
				{
					SaveTextDrawState(EditIndex);
					Project[EditIndex][iShadow] = 0;
					UpdateTextDraw(EditIndex);
				}
				case EDITMODE_POSITION:
				{
				    SaveTextDrawState(EditIndex);
				    Project[EditIndex][iPositionX] = floatdiv(floatdiv(ScreenWidth, 2), ScreenWidth) * 640.0;
				    Project[EditIndex][iPositionY] = floatdiv(floatdiv(ScreenHeight, 2), ScreenHeight) * 448.0;
                    UpdateTextDraw(EditIndex);
				}
		    }
	    }
	    case VK_SPACE: EditSpeed = 0.1;
	    case VK_LSHIFT, VK_RSHIFT: EditSpeed = 5.0;
	}
	return true;
}

forward OnVirtualKeyRelease(key);
public OnVirtualKeyRelease(key)
{
    if(key == VK_LBUTTON)
	{
	    if(EditEnabled)
	    {
	        if(ColorMode) ColorMode = 0;
	        EditEnabled = false;
	        SaveProject();
	    }
	}
	if(key == VK_SPACE || key == VK_LSHIFT) EditSpeed = 1.0;
	return true;
}

//============================================================================//
stock ShowFont5Menu(playerid)
{
	iShowPlayerDialog(playerid, DIALOG_FONT5, DIALOG_STYLE_LIST, "Опции Preview Model",
	"+ Изменить modelid\n+ Изменить координаты по оси X\n+ Изменить координаты по оси Y\n+ Изменить координаты по оси Z\n+ Изменить размер модели\n+ Отредактировать все", "Выбрать", "Закрыть");
	return true;
}
stock TextDrawEdit(mode)
{
	if(!mode)
	{
	    if(EditEnabled)
	    {
	        ColorMode 	= COLORMODE_NONE;
	        EditMode  	= EDITMODE_NONE;
	        EditEnabled = false;
	        SaveProject(false);
	    }
	} else
	{
	    if(EditIndex == INVALID_INDEX_ID)
		{
		    ShowTextDrawList();
			Send(ProjectEditor, -1, #ITD_W"Вы должны сначала выбрать ТД из меню!");
			return true;
	    }
	    
	    switch(mode)
	    {
         	case EDITMODE_TEXTDRAW:
	        {
				Send(ProjectEditor, -1, "Вы создали {00FF00}New Textdraw{FFFFFF}: Зажмите ЛКМ и перемещайте ТД");
	            EditMode = EDITMODE_TEXTDRAW;
	            HideEditor(true);
	        }
	        case EDITMODE_USEBOX:
	        {
	            Send(ProjectEditor, -1, "Вы создали {00FF00}Box{FFFFFF}: Зажмите ЛКМ чтобы изменить размер и ПКМ чтобы сохранить размер");
	            EditMode = EDITMODE_USEBOX;
	            HideEditor(true);
	        }
	        case EDITMODE_TEXTUREBOX:
	        {
	            Send(ProjectEditor, -1, "Вы создали {00FF00}Texture Box{FFFFFF}:Зажмите ЛКМ чтобы изменить размер и ПКМ чтобы сохранить размер");
	            EditMode = EDITMODE_TEXTUREBOX;
	            HideEditor(true);
	        }
	        case EDITMODE_POSITION:
	        {
	            Send(ProjectEditor, -1, "Редактирование {00FF00}Позиции{FFFFFF}: Зажмите ЛКМ и перемещайте курсор");
	            EditMode = EDITMODE_POSITION;
	            HideEditor(true);
	        }
	        case EDITMODE_SIZE:
	        {
	            Send(ProjectEditor, -1, "Редактирование {00FF00}Размера{FFFFFF}: Зажмите ЛКМ и перемещайте курсор (Если вы хотите изм. размер шрифта, используйте LetterSize)");
                EditMode = EDITMODE_SIZE;
                HideEditor(true);
			}
			case EDITMODE_LETTERSIZE:
	        {
	            Send(ProjectEditor, -1, "Рекдатирование {00FF00}LetterSize{FFFFFF}: Зажмите ЛКМ и регулируйте");
                EditMode = EDITMODE_LETTERSIZE;
                HideEditor(true);
			}
			case EDITMODE_COLOR:
	        {
	            EditMode = EDITMODE_COLOR;
	            ShowColorDialog();
			}
			case EDITMODE_BGCOLOR:
			{
			    EditMode = EDITMODE_BGCOLOR;
			    ShowColorDialog();
			}
			case EDITMODE_BOXCOLOR:
			{
			    EditMode = EDITMODE_BOXCOLOR;
			    ShowColorDialog();
			}
			case EDITMODE_OUTLINE:
			{
			    Project[EditIndex][iShadow] = 0;
                Send(ProjectEditor, -1, "Рекдатирование {00FF00}Outline{FFFFFF}: Зажмите ЛКМ и регулируйте | ПКМ - отключить outline(обводка).");
                EditMode = EDITMODE_OUTLINE;
                HideEditor(true);
			}
			case EDITMODE_SHADOW:
			{
			    Project[EditIndex][iOutline] = 0;
				Send(ProjectEditor, -1, "Рекдатирование {00FF00}Shadow{FFFFFF}: Зажмите ЛКМ и регулируйте | RMB - отключить shadow(тень).");
                EditMode = EDITMODE_SHADOW;
                HideEditor(true);
			}
			case EDITMODE_ALIGNMENT:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iAlignment])
			    {
			        case 1: Project[EditIndex][iAlignment] = 2, Send(ProjectEditor, -1, "ТД {00FF00}Alignment(Выравнивание){FFFFFF} по: Центру");
			        case 2: Project[EditIndex][iAlignment] = 3, Send(ProjectEditor, -1, "Textdraw {00FF00}Alignment(Выравнивание){FFFFFF} по: Правому краю");
			        case 3: Project[EditIndex][iAlignment] = 1, Send(ProjectEditor, -1, "Textdraw {00FF00}Alignment(Выравнивание){FFFFFF} по: Левому краю");
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_PROPORTION:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iProportion])
			    {
			        case 0: Project[EditIndex][iProportion] = 1, Send(ProjectEditor, -1, "ТД {00FF00}Proportional{FFFFFF}: Да");
			        case 1: Project[EditIndex][iProportion] = 0, Send(ProjectEditor, -1, "ТД {00FF00}Proportional{FFFFFF}: Нет");
				}
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_SELECTABLE:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iSelectable])
			    {
			        case 0: Project[EditIndex][iSelectable] = 1, Send(ProjectEditor, -1, "ТД {00FF00}Selectable{FFFFFF}: Да");
			        case 1: Project[EditIndex][iSelectable] = 0, Send(ProjectEditor, -1, "ТД {00FF00}Selectable{FFFFFF}: Нет");
				}
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_BOX:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iUsebox])
			    {
			        case 0: Project[EditIndex][iUsebox] = 1, Project[EditIndex][iBoxcolor] = 255, Send(ProjectEditor, -1, "ТД {00FF00}Box{FFFFFF}: Используется");
			        case 1: Project[EditIndex][iUsebox] = 0, Send(ProjectEditor, -1, "ТД {00FF00}Box{FFFFFF}: Не используйется");
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_FONT:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iFont])
			    {
			        case 0: { Project[EditIndex][iFont] = 1; Project[EditIndex][PreviewModel] = 0; Send(ProjectEditor, -1, "ТД {00FF00}Font(шрифт){FFFFFF}: 1 Normal"); }
			        case 1: { Project[EditIndex][iFont] = 2; Project[EditIndex][PreviewModel] = 0; Send(ProjectEditor, -1, "ТД {00FF00}Font(шрифт){FFFFFF}: 2 Modern"); }
			        case 2: { Project[EditIndex][iFont] = 3; Project[EditIndex][PreviewModel] = 0; Send(ProjectEditor, -1, "ТД {00FF00}Font(шрифт){FFFFFF}: 3 Bold"); }
			        case 3: { Project[EditIndex][iFont] = 4; Project[EditIndex][PreviewModel] = 0; Send(ProjectEditor, -1, "ТД {00FF00}Font(шрифт){FFFFFF}: 4 TXD Image"); }
			        case 4: { Project[EditIndex][iFont] = 5; Project[EditIndex][PreviewModel] = 1; Send(ProjectEditor, -1, "ТД {00FF00}Font(шрифт){FFFFFF}: 5 Preview Model"); Project[EditIndex][iUsebox] = 1;}
			        case 5: { Project[EditIndex][iFont] = 0; Project[EditIndex][PreviewModel] = 0; Send(ProjectEditor, -1, "ТД {00FF00}Font(шрифт){FFFFFF}: 0 Oldschool"); }
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_TYPE:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iType])
			    {
			        case 0: Project[EditIndex][iType] = 1, Send(ProjectEditor, -1, "ТД {00FF00}Type(Тип){FFFFFF}: PlayerTextDraw(Для игрока)");
			        case 1: Project[EditIndex][iType] = 0, Send(ProjectEditor, -1, "ТД {00FF00}Type(Тип){FFFFFF}: Global TextDraw");
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_REMOVE:
			{
			    SaveTextDrawState(EditIndex);
			    
			    format(String_Normal, sizeof String_Normal, #ITD_I"ТД удален(%i)", EditIndex);
			    Send(ProjectEditor, -1, String_Normal);
			    RemoveTextDraw(EditIndex);
				ShowEditor();
			}
	    }
	}
	return true;
}

//============================================================================//

stock ShowTextSizeWarning()
{
	String_Textdraw = "{FFFF00}Предупреждение\n\n{FFFFFF}Вы пытаетесь отредактировать Text Size , когда у вас box и image отключены.\n";
	strcat(String_Textdraw, "В результате textdraws автоматически создадутся новые линии регулирующие ваш желаемый text size.\n\n");
	strcat(String_Textdraw, "\n{00FF00}Q: Я пытаюсь изменить размер шрифта.\n{FFFFFF}A: Используйте 'Letter Size' инструмент \n");
	strcat(String_Textdraw, "\n{00FF00}Q: Я пытаюсь изменить Зону Кликабельности.\n{FFFFFF}A: Нажмите продолжить.\n");
	strcat(String_Textdraw, "\n{00FF00}Q: Я пытаюсь FIXED REGION для показа своего текста.\n{FFFFFF}A: Нажмите продолжить.");

	return iShowPlayerDialog(ProjectEditor, DIALOG_WARNING, DIALOG_STYLE_MSGBOX,
	"Text Size предупреждение", String_Textdraw, "Отменить", "Продолжить");
}

stock ShowCreateDialog()
{
    return iShowPlayerDialog(ProjectEditor, DIALOG_CREATE, DIALOG_STYLE_LIST,
	"Создание нового ТД",
	"+ Создать Нормальный Textdraw\n\
	+ Создать Box (Используется \"TextDrawUseBox\" )\n\
	+ Создать Texture Box(Используйте \"LD_SPAC:white\" текстуру)",
	"OK", "Back");
}

stock ShowTextDialog()
{
	format(String_Message, sizeof String_Message,
	"Пожалуйста, введите текст ниже.\n\nТекущий текст: %s", TextToRussia(Project[EditIndex][iText]));
	
	return iShowPlayerDialog(ProjectEditor, DIALOG_TEXT, DIALOG_STYLE_INPUT,
	"Изменение TextDraw String", String_Message, "Ок", "Отменить");
}

stock ShowPositionDialog()
{
    return iShowPlayerDialog(ProjectEditor, DIALOG_POSITION, DIALOG_STYLE_LIST, "Изменение позиции",
	"- Использовать Мышку\n\
     - Установить позицию в ручную\n", "Ок", "Отменить");
}

stock ShowPositionCustomDialog()
{
	format(String_Textdraw, sizeof String_Textdraw,
	"Текущая позиция: X: %f Y: %f\n\n\
	 Введите желаемые координаты\n\
     Удостоверьтесь, что используйте один из форматов:\n\
	 X Y | X, Y | X.00, Y.00 | X.00 Y.00",
	 Project[EditIndex][iPositionX],
	 Project[EditIndex][iPositionY]);
	 
    return iShowPlayerDialog(ProjectEditor, DIALOG_POSITIONC, DIALOG_STYLE_INPUT, "Введите координаты",
	String_Textdraw, "Ок", "Назад");
}

stock ShowSizeDialog(bool:warn = false)
{
	if(warn && Project[EditIndex][iFont] != 4 && !Project[EditIndex][iUsebox]) return ShowTextSizeWarning();
	return iShowPlayerDialog(ProjectEditor, DIALOG_SIZE, DIALOG_STYLE_LIST, "Изменение Text Size",
	"- Использовать Мышку\n\
     - Установить Text Size в ручную\n", "OK", "Cancel");
}

stock ShowSizeCustomDialog()
{
	format(String_Textdraw, sizeof String_Textdraw,
	"Текущий Text Size: Ширина: %f Высота: %f\n\n\
	 Введите желаемый размер\n\
     Удостоверьтесь, что используйте один из форматов:\n\
	 Ширина Высота | Ширина, Высота | Ширина.00 Высота.00 | Ширина.00, Высота.00",
	 Project[EditIndex][iTextX],
	 Project[EditIndex][iTextY]);

    return iShowPlayerDialog(ProjectEditor, DIALOG_SIZEC, DIALOG_STYLE_INPUT, "Введите Text Size",
	String_Textdraw, "Ок", "Назад");
}

stock ShowLetterDialog()
{
	return iShowPlayerDialog(ProjectEditor, DIALOG_LETTER, DIALOG_STYLE_LIST, "Изменение Letter Size",
	"- Использовать Мышку\n\
     - Установить Letter Size в ручную\n", "OK", "Cancel");
}

stock ShowLetterCustomDialog()
{
	format(String_Textdraw, sizeof String_Textdraw,
	"Текущий Letter Size: Ширина: %f Высота: %f\n\n\
	 Введите желаемый размер\n\
     Удостоверьтесь, что используйте один из форматов:\n\
	 Ширина Высота | Ширина, Высота | Ширина.00 Высота.00 | Ширина.00, Высота.00",
	 Project[EditIndex][iLetterX],
	 Project[EditIndex][iLetterY]);

    return iShowPlayerDialog(ProjectEditor, DIALOG_LETTERC, DIALOG_STYLE_INPUT, "Введите Letter Size",
	String_Textdraw, "Ок", "Назад");
}

stock ShowColorDialog()
{
	new heading[32];
	switch(EditMode)
	{
	    case EDITMODE_COLOR: heading = "Цвет ТД";
	    case EDITMODE_BGCOLOR: heading = "Цвет фона ТД";
	    case EDITMODE_BOXCOLOR: heading = "Цвет box'a ТД";
	    default: return Send(ProjectEditor, -1, #ITD_E"Тип редактирования цвета: неопределенный (Отчет об ошибке)");
	}
	
    return iShowPlayerDialog(ProjectEditor, DIALOG_COLOR, DIALOG_STYLE_LIST, heading,
	"- Используйте 16'тиричный RGBA код (e.g: 0xFFFFFFFF)\n\
     - Ввести альфавитно-номерной RGBA код (e.g: 255, 255, 255, 255)\n\
     - Выбрать цвет из списка\n\
	 - Использовать редактор цвета", "Ок", "Отменить");
}

stock ShowHEXColorDialog()
{
	return iShowPlayerDialog(ProjectEditor, DIALOG_HEXCOLOR, DIALOG_STYLE_INPUT,
	"16'тиричный RGBA код", "Введите 16'тиричный RGBA код:\n\nУдостоверьтесь, что используйте один из форматов:\n\
	0xRRGGBBAA | #RRGGBBAA | RRGGBBAA", "Принять", "Назад");
}

stock ShowNUMColorDialog()
{
	return iShowPlayerDialog(ProjectEditor, DIALOG_NUMCOLOR, DIALOG_STYLE_INPUT, "Альфавитно-номерной RGBA код",
	"Введите Альфавитно-номерной RGBA код:\n\nУдостоверьтесь, что используйте один из форматов:\n\
	R G B A | R, G, B, A | (Values from 0 to 255)", "Принять", "Назад");
}

stock ShowPREColorDialog()
{
	EmptyString(String_Textdraw);
	CountRange(0, sizeof PremadeColors)
	{
	    format(String_Normal, sizeof String_Normal, "{%06x}%s", PremadeColors[c][0] >>> 8, PremadeColors[c][1]);
	    strcat(String_Textdraw, String_Normal);
	    strcat(String_Textdraw, "\n");
	}
	
	return iShowPlayerDialog(ProjectEditor, DIALOG_PRECOLOR, DIALOG_STYLE_LIST, "Выберите цвет",
	String_Textdraw, "Принять", "назад");
}

stock ShowProjectList()
{
    String_Large = "(No projects created yet)";
    new bool:Found;

    Handler = fopen(ITD_List, io_read);
    if(Handler)
    {
	    while(fread(Handler, String_Normal))
	    {
			if(strlen(String_Normal))
			{
			    if(!Found)
				{
					EmptyString(String_Large);
					Found = true;
				}
				strcat(String_Large, String_Normal);
			}
		}
	    fclose(Handler);
    } else return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (project.lst)");
    
	return iShowPlayerDialog(ProjectEditor, DIALOG_PROJECTS, DIALOG_STYLE_LIST, "Проекты", String_Large, "Открыть", "Отменить");
}

stock ShowTextDrawList()
{
	EmptyString(String_Large);
	strcat(String_Large, "{00FF00}> Создать новый ТД\n{FF0000}> Удалить выбранный ТД\n{FF0000}> Удалить все текстдравы");
	
	LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    
	    format(String_Normal, sizeof String_Normal, "\n%s(%i)%s{FFFFFF}(%s{FFFFFF})", EditIndex == i ? ("{00BFFF}"):(""), i, Project[i][iText],Project[i][iSelectable] ? ("{FFA500}Clickable"):("No click"));
	    strcat(String_Large, String_Normal);
	}
	
	return iShowPlayerDialog(ProjectEditor, DIALOG_LIST, DIALOG_STYLE_LIST, "Список ТД проекта", String_Large, "Выбрать", "Закрыть");
}

//============================================================================//

stock AddProject(name[])
{
    Handler = fopen(ITD_List, io_append);
    if(!Handler) return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (project.lst)");

    fwrite(Handler, name);
    fwrite(Handler, "\r\n");
    fclose(Handler);
    
    printf("iTD: %s добавлен в Projects.lst", name);
    return true;
}

stock CheckProject(name[])
{
    if(!fexist(ITD_List)) return false;
    
    Handler = fopen(ITD_List, io_read);
    if(!Handler) return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (project.lst)");
    
	while(fread(Handler, String_Normal))
	if(!strcmp(String_Normal, name, true, strlen(name)))
	{
	    //printf("iTD: %s exists in Projects.lst", name);
	    fclose(Handler);
	    return true;
	}
	
	//printf("iTD: %s does not exist in Projects.lst", name);
	fclose(Handler);
	return false;
}

stock RemoveProject(name[])
{
	if(!fexist(ITD_List)) return true;
	if(fexist(name)) fremove(name);

	Handler = fopen(ITD_List, io_read);
	if(!Handler) return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (project.lst)");

	EmptyString(String_Large);
	while(fread(Handler, String_Normal))
	if(strcmp(Project, name, true, strlen(name))) strcat(String_Large, String_Normal);

	fclose(Handler);
	fremove(ITD_List);
	
	Handler = fopen(ITD_List, io_append);
	if(!Handler) return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (project.lst)");
	
	fwrite(Handler, String_Large);
	fclose(Handler);
	return true;
}

stock SaveProject(bool:response = false)
{
	if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"Никакой проект не открыт, чтобы сохранить его");
    if(fexist(ProjectFile)) fremove(ProjectFile);

	Handler = fopen(ProjectFile, io_append);
    if(!Handler) return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (.iTD)");
    
    LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    
	    format(String_Textdraw, sizeof String_Textdraw,
		"%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%s\r\n",
	    Project[i][iPositionX], 		Project[i][iPositionY],
		Project[i][iLetterX], 			Project[i][iLetterY],
		Project[i][iTextX], 			Project[i][iTextY],
		Project[i][iMRotX], 			Project[i][iMRotY],
		Project[i][iMRotZ] ,			Project[i][iMZoom],
		Project[i][iModelID],
		Project[i][iAlignment], 		Project[i][iColor],
		Project[i][iUsebox], 			Project[i][iBoxcolor],
		Project[i][iShadow], 			Project[i][iOutline],
		Project[i][iBackgroundcolor], 	Project[i][iFont],
		Project[i][iProportion], 		Project[i][iSelectable],
		Project[i][iType], 				Project[i][iText]);
		fwrite(Handler, String_Textdraw);
	}
    fclose(Handler);
    
	if(response)
	{
	    format(String_Message, 128, "%s Проект: '%s' сохранен!", ITD, ProjectFile);
	    Send(ProjectEditor, -1, String_Message);
	}
	return true;
}

stock CloseProject(bool:response = false)
{
    if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"Вы не открывали проект, по-этому закрыть не возможно!");
    
    SaveProject();
    LoopProjectTextdraws RemoveTextDraw(i);
    
    if(response)
	{
	    format(String_Message, 128, "%s Проект: '%s' закрыт!", ITD, ProjectFile);
	    Send(ProjectEditor, -1, String_Message);
	}
	
	EditIndex = INVALID_INDEX_ID;
	EditMode = EDITMODE_NONE;
	ColorMode = COLORMODE_NONE;
	EmptyString(ProjectFile);
	CountRange(0, sizeof States) EmptyString(States[c]);
	ShowEditor();
    return true;
}

stock LoadProject(bool:response = false)
{
    if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"Ошибка при попытке загрузить проект. (Отчет об ошибке)");
    
    Handler = fopen(ProjectFile, io_read);
    
    new Index;
    
    while(fread(Handler, String_Textdraw))
    {
        StripNewLine(String_Textdraw);
        
		if(!sscanf(String_Textdraw, "p<|>ffffffffffiiiiiiiiiiiis[128]",
		Project[Index][iPositionX], 		Project[Index][iPositionY],
		Project[Index][iLetterX], 			Project[Index][iLetterY],
		Project[Index][iTextX], 			Project[Index][iTextY],
		Project[Index][iMRotX], 				Project[Index][iMRotY],
		Project[Index][iMRotZ] ,				Project[Index][iMZoom],
		Project[Index][iModelID],
		Project[Index][iAlignment], 		Project[Index][iColor],
		Project[Index][iUsebox], 			Project[Index][iBoxcolor],
		Project[Index][iShadow], 			Project[Index][iOutline],
		Project[Index][iBackgroundcolor], 	Project[Index][iFont],
		Project[Index][iProportion], 		Project[Index][iSelectable],
		Project[Index][iType], 				Project[Index][iText]))
		{
		    EditIndex = Index;
		    UpdateTextDraw(Index, false);
		    TextDrawShowForPlayer(ProjectEditor, Project[Index][iTextdraw]);
		    Index++;
		}
    }
    
    fclose(Handler);
	ShowEditor();
    
    if(response)
	{
	    format(String_Message, 128, "%s проект: '%s' успешно загружен!", ITD, ProjectFile);
	    Send(ProjectEditor, -1, String_Message);
	}
	return true;
}

stock ExportProject()
{
    if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"Вы не открывали проект, по-этому экспортировать невозможно!");
    
    new ExportFile[64];
    format(ExportFile, sizeof ExportFile, "%s", ProjectFile);
    strins(ExportFile, "TD_", 0);
    new len = strlen(ExportFile);
	strdel(ExportFile, len - 3, len);
	strcat(ExportFile, "pwn");
	
	format(String_Message, sizeof String_Message, #ITD"Проект экспортирован '%s'..", ExportFile);
    
    if(fexist(ExportFile)) fremove(ExportFile);
	new File:ExportIO = fopen(ExportFile, io_append);
	if(!ExportIO) return Send(ProjectEditor, -1, #ITD_E"Произошла ошибка при ввода/вывода файлы (.pwn)");

	new bool:Type;

	new Index = -1;
	LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    if(Project[i][iType]) continue;
	    if(!Type) fwrite(ExportIO, "//Global Textdraws:\r\n\r\n"), Type = true;
	    
	    Index++;
	    format(String_Textdraw, sizeof String_Textdraw, "new Text:Textdraw%i;\r\n", Index);
	    fwrite(ExportIO, String_Textdraw);
	}
	
	if(Type)
	{
		fwrite(ExportIO, "\r\n\r\n");
		Index = -1;
		LoopProjectTextdraws
		{
		    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
		    if(Project[i][iType]) continue;

			Index++;
			format(String_Textdraw, sizeof String_Textdraw, "Textdraw%i = TextDrawCreate(%f, %f, \"%s\");\r\n", Index, Project[i][iPositionX], Project[i][iPositionY], Project[i][iText]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawLetterSize(Textdraw%i, %f, %f);\r\n", Index, Project[i][iLetterX], Project[i][iLetterY]);
			fwrite(ExportIO, String_Textdraw);

            if(floatadd(Project[i][iTextX], Project[i][iTextY]))
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawTextSize(Textdraw%i, %f, %f);\r\n", Index, Project[i][iTextX], Project[i][iTextY]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawAlignment(Textdraw%i, %i);\r\n", Index, Project[i][iAlignment]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawColor(Textdraw%i, %i);\r\n", Index, Project[i][iColor]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iUsebox])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawUseBox(Textdraw%i, true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);

				format(String_Textdraw, sizeof String_Textdraw, "TextDrawBoxColor(Textdraw%i, %i);\r\n", Index, Project[i][iBoxcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetShadow(Textdraw%i, %i);\r\n", Index, Project[i][iShadow]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetOutline(Textdraw%i, %i);\r\n", Index, Project[i][iOutline]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iBackgroundcolor])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawBackgroundColor(Textdraw%i, %i);\r\n", Index, Project[i][iBackgroundcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawFont(Textdraw%i, %i);\r\n", Index, Project[i][iFont]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iProportion])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetProportional(Textdraw%i, %i);\r\n", Index, Project[i][iProportion]);
				fwrite(ExportIO, String_Textdraw);
			}

			if(Project[i][iSelectable])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetSelectable(Textdraw%i, true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);
			}
			if(Project[i][PreviewModel])
			{
			    format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetPreviewModel(Textdraw%i, %i);\r\n", Index, Project[i][iModelID]);
				fwrite(ExportIO, String_Textdraw);
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetPreviewRot(Textdraw%i, %f, %f, %f, %f);\r\n", Index, Project[i][iMRotX], Project[i][iMRotY], Project[i][iMRotZ], Project[i][iMZoom]);
				fwrite(ExportIO, String_Textdraw);
			}
			fwrite(ExportIO, "\r\n");
		}
	}
	
	Type = false;
	
	new gTexts = Index; Index = -1;
	LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    if(!Project[i][iType]) continue;
	    if(!Type) fwrite(ExportIO, "\r\n//Player Textdraws(Для игрока):\r\n\r\n"), Type = true;
	    Index++;
	    format(String_Textdraw, sizeof String_Textdraw, "new PlayerText:Textdraw%i[MAX_PLAYERS];\r\n", Index);
	    fwrite(ExportIO, String_Textdraw);
	}

    Index = -1;
	if(Type)
	{
		fwrite(ExportIO, "\r\n\r\n");
		LoopProjectTextdraws
		{
		    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
		    if(!Project[i][iType]) continue;

			Index++;
			format(String_Textdraw, sizeof String_Textdraw, "Textdraw%i[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \"%s\");\r\n", Index, Project[i][iPositionX], Project[i][iPositionY], Project[i][iText]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawLetterSize(playerid, Textdraw%i[playerid], %f, %f);\r\n", Index, Project[i][iLetterX], Project[i][iLetterY]);
			fwrite(ExportIO, String_Textdraw);

            if(floatadd(Project[i][iTextX], Project[i][iTextY]))
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawTextSize(playerid, Textdraw%i[playerid], %f, %f);\r\n", Index, Project[i][iTextX], Project[i][iTextY]);
				fwrite(ExportIO, String_Textdraw);
			}
			
			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawAlignment(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iAlignment]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawColor(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iColor]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iUsebox])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawUseBox(playerid, Textdraw%i[playerid], true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);

				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawBoxColor(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iBoxcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetShadow(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iShadow]);
			fwrite(ExportIO, String_Textdraw);
				
			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetOutline(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iOutline]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iBackgroundcolor])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawBackgroundColor(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iBackgroundcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawFont(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iFont]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iProportion])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetProportional(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iProportion]);
				fwrite(ExportIO, String_Textdraw);
			}

			if(Project[i][iSelectable])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetSelectable(playerid, Textdraw%i[playerid], true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);
			}
			if(Project[i][PreviewModel])
			{
			    format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetPreviewModel(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iModelID]);
				fwrite(ExportIO, String_Textdraw);
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetPreviewRot(playerid, Textdraw%i[playerid], %f, %f, %f, %f);\r\n", Index, Project[i][iMRotX], Project[i][iMRotY], Project[i][iMRotZ], Project[i][iMZoom]);
				fwrite(ExportIO, String_Textdraw);
			}
			fwrite(ExportIO, "\r\n");
		}
	}
	
	fclose(ExportIO);
	format(String_Message, sizeof String_Message, #ITD"Проект экспортирован '%s'! (%i Global Textdraws / %i Player Textdraws)", ExportFile, gTexts + 1, Index + 1);
	Send(ProjectEditor, -1, String_Message);
	return true;
}

stock UpdateTextDraw(Index, bool:Show = true)
{
	if(!(0 <= Index < sizeof Project)) return;
	
    TextDrawDestroy(Project[Index][iTextdraw]);
    Project[Index][iTextdraw] = Text:INVALID_TEXT_DRAW;
    
	Project[Index][iTextdraw] = TextDrawCreate
	(
		Project[Index][iPositionX],
		Project[Index][iPositionY],
		Project[Index][iText]
	);

	TextDrawLetterSize		(Project[Index][iTextdraw], Project[Index][iLetterX], Project[Index][iLetterY]);
	
	if(Project[Index][iUsebox] || Project[Index][iFont] == 4)
	TextDrawTextSize    	(Project[Index][iTextdraw], Project[Index][iTextX], Project[Index][iTextY]);
	
	TextDrawAlignment   	(Project[Index][iTextdraw], Project[Index][iAlignment] ? Project[Index][iAlignment] : 1);
	TextDrawColor   		(Project[Index][iTextdraw], Project[Index][iColor]);
	TextDrawUseBox   		(Project[Index][iTextdraw], Project[Index][iUsebox]);
	TextDrawBoxColor   		(Project[Index][iTextdraw], Project[Index][iBoxcolor]);
	TextDrawSetShadow   	(Project[Index][iTextdraw], Project[Index][iShadow]);
	TextDrawSetOutline  	(Project[Index][iTextdraw], Project[Index][iOutline]);
	TextDrawBackgroundColor (Project[Index][iTextdraw], Project[Index][iBackgroundcolor]);
	TextDrawFont   			(Project[Index][iTextdraw], Project[Index][iFont]);
	TextDrawSetProportional	(Project[Index][iTextdraw], Project[Index][iProportion]);
	if(Project[Index][iFont] == 5)
	{
	    Project[Index][PreviewModel] = 1;
	}
	if(Project[Index][PreviewModel] == 1)
	{
	    TextDrawSetPreviewModel(Project[Index][iTextdraw], Project[Index][iModelID]);
	    TextDrawSetPreviewRot(Project[Index][iTextdraw], Project[Index][iMRotX], Project[Index][iMRotY], Project[Index][iMRotZ], Project[Index][iMZoom]);
	}
	if(Show) TextDrawShowForPlayer(ProjectEditor, Project[Index][iTextdraw]);
}

stock RemoveTextDraw(Index)
{
    if(!(0 <= Index < sizeof Project)) return;
    
	TextDrawDestroy(Project[Index][iTextdraw]);
	format(Project[Index][iText], 128, " ");
	Project[Index][iTextdraw] = Text:INVALID_TEXT_DRAW;
	Project[Index][iLetterX] = 0.0;
	Project[Index][iLetterY] = 0.0;
	Project[Index][iTextX] = 0.0;
	Project[Index][iTextY] = 0.0;
	Project[Index][iAlignment] = 1;
	Project[Index][iColor] = 0;
	Project[Index][iUsebox] = 0;
	Project[Index][iBoxcolor] = 0;
	Project[Index][iShadow] = 0;
	Project[Index][iOutline] = 0;
	Project[Index][iBackgroundcolor] = 0;
	Project[Index][iFont] = 0;
	Project[Index][iProportion] = 0;
	Project[Index][iSelectable] = 0;
	
	if(EditIndex == Index)
	{
	    EditMode = EDITMODE_NONE;
	    EditIndex = INVALID_INDEX_ID;
	}
}


stock CopyTextDraw(Index, ToIndex)
{
	if(!(0 <= Index < sizeof Project) || !(0 <= ToIndex < sizeof Project)) return;
	
	format(Project[ToIndex][iText], 128, "%s", Project[Index][iText]);
	Project[ToIndex][iPositionX] = Project[Index][iPositionX] + 1;
	Project[ToIndex][iPositionY] = Project[Index][iPositionY] + 1;
	Project[ToIndex][iLetterY] = Project[Index][iLetterY];
	Project[ToIndex][iLetterX] = Project[Index][iLetterX];
	Project[ToIndex][iLetterY] = Project[Index][iLetterY];
	Project[ToIndex][iTextX] = Project[Index][iTextX];
	Project[ToIndex][iTextY] = Project[Index][iTextY];
	Project[ToIndex][iAlignment] = Project[Index][iAlignment];
	Project[ToIndex][iColor] = Project[Index][iColor];
	Project[ToIndex][iUsebox] = Project[Index][iUsebox];
	Project[ToIndex][iBoxcolor] = Project[Index][iBoxcolor];
	Project[ToIndex][iShadow] = Project[Index][iShadow];
	Project[ToIndex][iOutline] = Project[Index][iOutline];
	Project[ToIndex][iBackgroundcolor] = Project[Index][iBackgroundcolor];
	Project[ToIndex][iFont] = Project[Index][iFont];
	Project[ToIndex][iProportion] = Project[Index][iProportion];
	Project[ToIndex][iSelectable] = Project[Index][iSelectable];
	Project[ToIndex][PreviewModel] = Project[Index][PreviewModel];
	Project[ToIndex][iModelID] = Project[Index][iModelID];
	Project[ToIndex][iMRotX] = Project[Index][iMRotX];
	Project[ToIndex][iMRotY] = Project[Index][iMRotY];
	Project[ToIndex][iMRotZ] = Project[Index][iMRotZ];
	Project[ToIndex][iMZoom] = Project[Index][iMZoom];
	
	EditIndex = ToIndex;
	UpdateTextDraw(ToIndex);
	SaveTextDrawState(EditIndex, true);
	
	format(String_Message, sizeof String_Message, #ITD_I"ТД (%i) скопирован как новый Textdraw (%i)", Index, ToIndex);
	Send(ProjectEditor, -1, String_Message);
	if(EditMode) EditMode = EDITMODE_POSITION;
}

stock SaveTextDrawState(Index, bool:Remove = false)
{
	for( new i = 0; i < MAX_UNDO_STATES - 1; i++ )
	States[i] = States[i + 1];

	if(Remove) format(States[MAX_UNDO_STATES - 1], sizeof States[], "%i", Index);
	else
	{
	    format(States[MAX_UNDO_STATES - 1], sizeof States[],
	    
		"%i|%f|%f|%f|%f|%f|%f|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%s",
		
		Index,
	    Project[Index][iPositionX], 		Project[Index][iPositionY],
		Project[Index][iLetterX], 			Project[Index][iLetterY],
		Project[Index][iTextX], 			Project[Index][iTextY],
		Project[Index][iAlignment], 		Project[Index][iColor],
		Project[Index][iUsebox], 			Project[Index][iBoxcolor],
		Project[Index][iShadow], 			Project[Index][iOutline],
		Project[Index][iBackgroundcolor],	Project[Index][iFont],
		Project[Index][iProportion], 		Project[Index][iSelectable],
		Project[Index][iType], 				Project[Index][iText]);
	}
}

stock UndoTextDrawState()
{
	new
		iCount,
		iIndex = INVALID_INDEX_ID
	;

	CountRange(0, MAX_UNDO_STATES) if(!isnull(States[c])) iIndex = c, iCount++;
	if(iIndex == INVALID_INDEX_ID) return Send(ProjectEditor, -1, #ITD_E"Отменить невозможно.");

	new index = -1, Float:ucX, Float:ucY, Float:ulX, Float:ulY, Float:utX, Float:utY,
	uAl, uCl, uUb, uBc, uSd, uOl, uBg, uFt, uPr, uSl, uT, uS[64];

	if(!sscanf(States[iIndex], "p<|>iffffffiiiiiiiiiiis[128]", index, ucX, ucY, ulX, ulY, utX, utY,
	uAl, uCl, uUb, uBc, uSd, uOl, uBg, uFt, uPr, uSl, uT, uS))
	{
	    if(index != -1)
	    {
	        Project[index][iPositionX] = ucX;
			Project[index][iPositionY] = ucY;
			Project[index][iLetterX] = ulX;
			Project[index][iLetterY] = ulY;
			Project[index][iTextX] = utX;
			Project[index][iTextY] = utY;
			Project[index][iAlignment] = uAl;
			Project[index][iColor] = uCl;
			Project[index][iUsebox] = uUb;
			Project[index][iBoxcolor] = uBc;
			Project[index][iShadow] = uSd;
			Project[index][iOutline] = uOl;
			Project[index][iBackgroundcolor] = uBg;
			Project[index][iFont] = uFt;
			Project[index][iProportion] = uPr;
			Project[index][iSelectable] = uSl;
			Project[index][iType] = uT;
			format(Project[index][iText], 128, "%s", uS);
			EditIndex = index;
			UpdateTextDraw(EditIndex);
	    }
	} else if(!sscanf(States[iIndex], "i", index))
	{
		if(0 <= index < sizeof Project) RemoveTextDraw(index);
	}

	EmptyString(States[iIndex]);
	format(String_Message, sizeof String_Message, #ITD_I"{00FF00}Отменено{FFFFFF} применений (%i)", iCount - 1);
	return Send(ProjectEditor, -1, String_Message);
}

stock ShowEditor()
{
    DestroyMenuTextDraws();
    CreateMenuTextDraws();
    
	TogglePlayerControllable(ProjectEditor, false);
	
	if(EditIndex != INVALID_INDEX_ID)
	{
	    CountRange(0, sizeof TD_MenuPM)
	    {
	        TextDrawColor(TD_MenuPM[c], 0xDDDDDDFF);
	        TextDrawSetSelectable(TD_MenuPM[c], true);
	        switch(c)
	        {
	            case 0:
		        {
			        switch(Project[EditIndex][iFont])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[24]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[25]);
					    case 2: TextDrawShowForPlayer(ProjectEditor, TD_Menu[26]);
					    case 3: TextDrawShowForPlayer(ProjectEditor, TD_Menu[27]);
					    case 4: TextDrawShowForPlayer(ProjectEditor, TD_Menu[12]);
					    case 5: TextDrawShowForPlayer(ProjectEditor, TD_MenuPM[0]);
					}
				}
				case 1:
				{
					switch(Project[EditIndex][PreviewModel])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[17]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_MenuPM[1]);
					}
				}
			}
	    }
	    CountRange(0, sizeof TD_Menu)
	    {
	        TextDrawColor(TD_Menu[c], 0xDDDDDDFF);
	        TextDrawSetSelectable(TD_Menu[c], true);
	        switch(c)
	        {
	            case 24, 25, 26, 27, 12:
		        {
			        switch(Project[EditIndex][iFont])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[24]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[25]);
					    case 2: TextDrawShowForPlayer(ProjectEditor, TD_Menu[26]);
					    case 3: TextDrawShowForPlayer(ProjectEditor, TD_Menu[27]);
					    case 4: TextDrawShowForPlayer(ProjectEditor, TD_Menu[12]);
					    case 5: TextDrawShowForPlayer(ProjectEditor, TD_MenuPM[0]);
					}
				}
				case 5, 33:
		        {
			        switch(Project[EditIndex][iType])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[5]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[33]);
					}
				}
				case 30, 31:
		        {
			        switch(Project[EditIndex][iProportion])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[30]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[31]);
					}
				}
				case 28, 29:
		        {
			        switch(Project[EditIndex][iSelectable])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[28]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[29]);
					}
				}
				case 21, 22, 23:
		        {
			        switch(Project[EditIndex][iAlignment])
					{
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[21]);
					    case 2: TextDrawShowForPlayer(ProjectEditor, TD_Menu[22]);
					    case 3: TextDrawShowForPlayer(ProjectEditor, TD_Menu[23]);
					    default:
						{
						    Project[EditIndex][iAlignment] = 1;
							TextDrawShowForPlayer(ProjectEditor, TD_Menu[21]);
						}
					}
				}
				case 19, 20:
		        {
			        switch(Project[EditIndex][iUsebox])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[19]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[20]);
					}
				}
				case 6, 7, 13:
				{
				    TextDrawColor(TD_Menu[c], 0xFFFFFFFF);
				    TextDrawSetSelectable(TD_Menu[c], false);
				    TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
				}
				case 17:
				{
					switch(Project[EditIndex][PreviewModel])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[17]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_MenuPM[1]);
					}
				}
				case 0:
				{
				    TextDrawColor(TD_Menu[c], 0x000000FF);
				    TextDrawSetSelectable(TD_Menu[c], false);
				    TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
				}
				default: TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
	        }
	    }
	    
	} else {
	    CountRange(0, sizeof TD_Menu)
	    {
	        switch(c)
	        {
	            case 1, 2:
	            {
	                TextDrawColor(TD_Menu[c], 0xDDDDDDFF);
	                TextDrawSetSelectable(TD_Menu[c], true);
	            }
	            case 3, 4, 8:
				{
				    if(strlen(ProjectFile))
				    {
						TextDrawColor(TD_Menu[c], 0xDDDDDDFF);
						TextDrawSetSelectable(TD_Menu[c], true);
					} else {
					    TextDrawColor(TD_Menu[c], 0x888888FF);
					    TextDrawSetSelectable(TD_Menu[c], false);
					}
				}
				case 5, 9..12, 14..33:
				{
				    TextDrawColor(TD_Menu[c], 0x888888FF);
				    TextDrawSetSelectable(TD_Menu[c], false);
				}
	        }
	        TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
	    }
	}
	
	SelectTextDraw(ProjectEditor, 0xFFFFFFFF);
	MenuShown = true;
	MenuHidden = false;
	EditMode = EDITMODE_NONE;
	if(strlen(ProjectFile)) SaveProject(false);
	return true;
}

stock HideEditor(bool:temp = false)
{
	if(temp)
	{
	    DestroyMenuTextDraws();
	    MenuHidden = true;
	    return true;
	}
	
    DestroyMenuTextDraws();
    TogglePlayerControllable(ProjectEditor, true);
    EditMode = EDITMODE_NONE;
	EditIndex = INVALID_INDEX_ID;
	MenuHidden = false;
	ProjectEditor = INVALID_PLAYER_ID;
	MenuShown = false;
	return true;
}

stock Initiate()
{
	if(!fexist(ITD_List)) {
		new File:IO = fopen(ITD_List, io_write);
		fclose(IO);
	}
	
    VirtualKeys[0][KEY_CODE] = VK_KEY_A;
    VirtualKeys[1][KEY_CODE] = VK_KEY_B;
    VirtualKeys[2][KEY_CODE] = VK_KEY_C;
    VirtualKeys[3][KEY_CODE] = VK_KEY_D;
    VirtualKeys[4][KEY_CODE] = VK_KEY_E;
    VirtualKeys[5][KEY_CODE] = VK_KEY_F;
    VirtualKeys[6][KEY_CODE] = VK_KEY_G;
    VirtualKeys[7][KEY_CODE] = VK_KEY_H;
    VirtualKeys[8][KEY_CODE] = VK_KEY_I;
    VirtualKeys[9][KEY_CODE] = VK_KEY_J;
    VirtualKeys[10][KEY_CODE] = VK_KEY_K;
    VirtualKeys[11][KEY_CODE] = VK_KEY_L;
    VirtualKeys[12][KEY_CODE] = VK_KEY_M;
    VirtualKeys[13][KEY_CODE] = VK_KEY_N;
    VirtualKeys[14][KEY_CODE] = VK_KEY_O;
    VirtualKeys[15][KEY_CODE] = VK_KEY_P;
    VirtualKeys[16][KEY_CODE] = VK_KEY_Q;
    VirtualKeys[17][KEY_CODE] = VK_KEY_R;
    VirtualKeys[18][KEY_CODE] = VK_KEY_S;
    VirtualKeys[19][KEY_CODE] = VK_KEY_T;
    VirtualKeys[20][KEY_CODE] = VK_KEY_U;
    VirtualKeys[21][KEY_CODE] = VK_KEY_V;
    VirtualKeys[22][KEY_CODE] = VK_KEY_W;
    VirtualKeys[23][KEY_CODE] = VK_KEY_X;
    VirtualKeys[24][KEY_CODE] = VK_KEY_Y;
    VirtualKeys[25][KEY_CODE] = VK_KEY_Z;
    VirtualKeys[26][KEY_CODE] = VK_LBUTTON;
    VirtualKeys[27][KEY_CODE] = VK_MBUTTON;
    VirtualKeys[28][KEY_CODE] = VK_RBUTTON;
    VirtualKeys[29][KEY_CODE] = VK_LEFT;
    VirtualKeys[30][KEY_CODE] = VK_RIGHT;
	VirtualKeys[31][KEY_CODE] = VK_UP;
    VirtualKeys[32][KEY_CODE] = VK_DOWN;
    VirtualKeys[33][KEY_CODE] = VK_LSHIFT;
    VirtualKeys[34][KEY_CODE] = VK_RSHIFT;
    VirtualKeys[35][KEY_CODE] = VK_SPACE;

	EditMode = EDITMODE_NONE;
	EditIndex = INVALID_INDEX_ID;
	ProjectEditor = INVALID_PLAYER_ID;
    LoopProjectTextdraws Project[i][iTextdraw] = Text:INVALID_TEXT_DRAW;
    UpdateTimer = SetTimer("OnEditorUpdate", 25, true);
}

stock CreateMenuTextDraws()
{
    TD_Menu[0] = TextDrawCreate(0.0, OffsetZ - 2.0, "LD_SPAC:white");
	TextdrawSettings(TD_Menu[0], Float:{0.5, 1.0, 640.0, 37.0}, {0,0x000000FF,0,0,0,0,255,4,1,0});

	new Float:OffsetX = 0.01;

	TD_Menu[1] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_new"); OffsetX += 32.0;
	TD_Menu[2] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_open"); OffsetX += 32.0;

	CountRange(1, 3)
	TextdrawSettings(TD_Menu[c], Float:{0.5, 1.0, 32.0, 32.0}, {0,0xDDDDDDFF,0,0,0,0,0,4,1,0});

	TD_Menu[3] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_close"); OffsetX += 32.0;
	TD_Menu[4] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_export"); OffsetX += 32.0;
    TD_Menu[8] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_manage"); OffsetX += 32.0;
    TD_Menu[24] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font0");
    TD_Menu[25] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font1");
    TD_Menu[26] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font2");
    TD_Menu[27] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font3");
    TD_MenuPM[0] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:font5");
    TextdrawSettings(TD_MenuPM[0], Float:{0.5, 1.0, 32.0, 32.0}, {0,0x888888FF,0,0,0,0,0,4,1,0});
    TD_Menu[12] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_image"); OffsetX += 32.0;
	TD_Menu[9] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_pos"); OffsetX += 32.0;
    TD_Menu[10] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_size"); OffsetX += 32.0;
    TD_Menu[11] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_text"); OffsetX += 32.0;
    TD_Menu[14] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_color"); OffsetX += 32.0;
    TD_Menu[15] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_bgcolor"); OffsetX += 32.0;
    TD_Menu[32] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_boxcolor"); OffsetX += 32.0;
    TD_Menu[16] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_lettersize"); OffsetX += 32.0;
    TD_MenuPM[1] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:font5options");
    TextdrawSettings(TD_MenuPM[1], Float:{0.5, 1.0, 32.0, 32.0}, {0,0x888888FF,0,0,0,0,0,4,1,0});
    TD_Menu[17] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_outline"); OffsetX += 32.0;
    TD_Menu[18] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_shadow"); OffsetX += 32.0;
    TD_Menu[19] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_useboxno");
    TD_Menu[20] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_useboxyes"); OffsetX += 32.0;
    TD_Menu[21] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_alignmentleft");
    TD_Menu[22] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_alignmentcenter");
    TD_Menu[23] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_alignmentright"); OffsetX += 32.0;
    TD_Menu[5] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_global");
	TD_Menu[33] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_player"); OffsetX += 32.0;
    TD_Menu[28] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_selectableno");
    TD_Menu[29] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_selectableyes"); OffsetX += 32.0;
    TD_Menu[30] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_proportionno");
    TD_Menu[31] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_proportionyes"); OffsetX += 32.0;
    
    TD_Menu[6] = TextDrawCreate(22222.0, 22173.0, " ");
	TD_Menu[7] = TextDrawCreate(22222.0, 22234.0, " ");
	TD_Menu[13] = TextDrawCreate(22222.0, 22334.0, " ");

    CountRange(3, sizeof TD_Menu)
    TextdrawSettings(TD_Menu[c], Float:{0.5, 1.0, 32.0, 32.0}, {0,0x888888FF,0,0,0,0,0,4,1,0});
}

stock DestroyMenuTextDraws()
{
    CountRange(0, sizeof TD_Menu)
	{
		TextDrawDestroy(TD_Menu[c]);
		TD_Menu[c] = Text:INVALID_TEXT_DRAW;
	}
    CountRange(0, sizeof TD_MenuPM)
	{
		TextDrawDestroy(TD_MenuPM[c]);
		TD_MenuPM[c] = Text:INVALID_TEXT_DRAW;
	}
}

stock TextdrawSettings(Text:textid, Float:Sizes[4], Options[10])
{
	TextDrawLetterSize		(textid, Sizes[0], Sizes[1]);
	TextDrawTextSize    	(textid, Sizes[2], Sizes[3]);
	TextDrawAlignment   	(textid, Options[0] ? Options[0] : 1);
	TextDrawColor   		(textid, Options[1]);
	TextDrawUseBox   		(textid, Options[2]);
	TextDrawBoxColor   		(textid, Options[3]);
	TextDrawSetShadow   	(textid, Options[4]);
	TextDrawSetOutline  	(textid, Options[5]);
	TextDrawBackgroundColor (textid, Options[6]);
	TextDrawFont   			(textid, Options[7]);
	TextDrawSetProportional	(textid, Options[8]);
	TextDrawSetSelectable   (textid, Options[9]);
}

stock Dispose()
{
	CountRange(0, sizeof States) EmptyString(States[c]);
    KillTimer(UpdateTimer);
    LoopProjectTextdraws TextDrawDestroy(Project[i][iTextdraw]);
    DestroyMenuTextDraws();
}

stock IsValidProjectName(name[])
{
	CountRange(0, strlen(name))
	{
	    switch(name[c])
	    {
	        case 'A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_', '(', ')': continue;
	        default: return false;
	    }
	}
	return true;
}

stock GetAvailableIndex()
{
	LoopProjectTextdraws if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) return i;
	return INVALID_INDEX_ID;
}

stock StripNewLine(string[]) //DracoBlue (bugfix idea by Y_Less)
{
	new len = strlen(string);
	if (string[0]==0) return ;
	if ((string[len - 1] == '\n') || (string[len - 1] == '\r')) {
		string[len - 1] = 0;
		if (string[0]==0) return ;
		if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
	}
}

stock HexToInt(string[])//DracoBlue
{
   if (string[0] == 0) return 0;
   new i, cur=1, res = 0;
   for (i=strlen(string);i>0;i--) {
     if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
     cur=cur*16;
   }
   return res;
 }

stock RGBAToHex(r, g, b, a) //By Betamaster
{
    return (r<<24 | g<<16 | b<<8 | a);
}

stock HexToRGBA(colour, &r, &g, &b, &a) //By Betamaster
{
    r = (colour >> 24) & 0xFF;
    g = (colour >> 16) & 0xFF;
    b = (colour >> 8) & 0xFF;
    a = colour & 0xFF;
}

stock TextToRussia(string[])
{
    new result[128];
    for (new i = 0; i < sizeof(result); i++)
    {
        switch (string[i])
        {
        case 'а': result[i] = 'A';
        case 'А': result[i] = 'A';
        case 'б': result[i] = '—';
		case 'Б': result[i] = 'Ђ';
        case 'в': result[i] = '‹';
        case 'В': result[i] = 'B';
        case 'г': result[i] = '‚';
        case 'Г': result[i] = '‚';
        case 'д': result[i] = 'ѓ';
        case 'Д': result[i] = 'ѓ';
        case 'е': result[i] = 'E';
        case 'Е': result[i] = 'E';
        case 'ё': result[i] = 'E';
        case 'Ё': result[i] = 'E';
        case 'ж': result[i] = '„';
        case 'Ж': result[i] = '„';
        case 'з': result[i] = '€';
        case 'З': result[i] = '€';
        case 'и': result[i] = '…';
        case 'И': result[i] = '…';
        case 'й': result[i] = '…';
        case 'Й': result[i] = '…';
        case 'к': result[i] = 'K';
        case 'К': result[i] = 'K';
        case 'л': result[i] = '‡';
        case 'Л': result[i] = '‡';
        case 'м': result[i] = 'M';
        case 'М': result[i] = 'M';
        case 'н': result[i] = 'Н';
        case 'Н': result[i] = 'Н';
        case 'о': result[i] = 'O';
        case 'О': result[i] = 'O';
        case 'п': result[i] = 'Њ';
        case 'П': result[i] = 'Њ';
        case 'р': result[i] = 'P';
        case 'Р': result[i] = 'P';
        case 'с': result[i] = 'C';
        case 'С': result[i] = 'C';
        case 'т': result[i] = 'Џ';
        case 'Т': result[i] = 'Џ';
        case 'у': result[i] = 'Y';
        case 'У': result[i] = 'Y';
        case 'ф': result[i] = 'Ѓ';
        case 'Ф': result[i] = 'Ѓ';
        case 'х': result[i] = 'X';
        case 'Х': result[i] = 'X';
        case 'ц': result[i] = '‰';
        case 'Ц': result[i] = '‰';
        case 'ч': result[i] = 'Ќ';
        case 'Ч': result[i] = 'Ќ';
        case 'ш': result[i] = 'Ћ';
        case 'Ш': result[i] = 'Ћ';
        case 'щ': result[i] = 'Љ';
        case 'Щ': result[i] = 'Љ';
        case 'ь': result[i] = '’';
        case 'Ь': result[i] = '’';
        case 'ъ': result[i] = '§';
        case 'Ъ': result[i] = '§';
        case 'ы': result[i] = '‘';
        case 'Ы': result[i] = '‘';
        case 'э': result[i] = '“';
        case 'Э': result[i] = '“';
        case 'ю': result[i] = '”';
        case 'Ю': result[i] = '”';
        case 'я': result[i] = '•';
        case 'Я': result[i] = '•';
        default: result[i] = string[i];
        }
    }
    return result;
} 
