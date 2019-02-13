
// Doshirak RP - D1maz. - vk.com/d1maz.myzt3ry

/*      Инклуды     */

#include <a_samp>
main();
#include <a_mysql>
#include <sscanf2>
#include <regex>
#include <crashdetect>
#include <streamer>
#include <doshirak\objects>

/*      Дефайны     */

// Настройки подключения к БД

#define MYSQL_HOST "localhost" // Сервер, к которому нужно подключаться
#define MYSQL_USER "root" // Пользователь, под которым нужно заходить
#define MYSQL_DATABASE "doshirak" // База, которая открывается
#define MYSQL_PASSWORD "" // Пароль от пользователя
new mysql_connection; // Статус подключения

// Прочее

#undef MAX_PLAYERS // Удаляем дефайн
#define MAX_PLAYERS (1000) // Создаём дефайн, равный 1000

#define MAX_PASSWORD_LEN (24) // Максимальная длина пароля
#define MIN_PASSWORD_LEN (4) // Минимальная длина пароля
#define MAX_EMAIL_LEN (32) // Максимальная длина пароля
#define MIN_EMAIL_LEN (10) // Минимальная длина пароля
#define MAX_PROMOCODE_LEN (32) // Максимальная длина промокода
#define MIN_PROMOCODE_LEN (4) // Минимальная длина промокода

#define KEY_NUM4 (8192) // ID клавиши - NUM4
#define KEY_NUM6 (16384) // ID клавиши - NUM6

// Цвета

#define C_BLUE 0x5495FFFF // Основной цвета сервера - синий
#define C_RED 0xF45F5FFF // Красный

#define BLUE "{5495ff}" // Синий для использования в тексте и диалогах
#define RED "{f45f5f}" // Красный для использования в тексте и диалогах
#define WHITE "{ffffff}" // Белый для использования в тексте и диалогах

/*      Переменные  */

// Проверка по IP

new check_ip_for_reconnect[MAX_PLAYERS][16],//Двойная глобальная переменная для записи IP адреса
	check_ip_for_reconnect_time[MAX_PLAYERS];//Глобальная переменная для записи времени

// Аккаунты

enum UINFO{
	id,// Номер аккаунта
	name[MAX_PLAYER_NAME],// Никнейм
	email[MAX_EMAIL_LEN],// Электронная почта
	referal_name[MAX_PLAYER_NAME],//Никнейм реферала
	referal_money,//Деньги, полученные с приглашённых игроков
	age,//Возраст персонажа
	origin,//Раса персонажа
	gender,//Пол персонажа
	character//Скин персонажа
}

new player[MAX_PLAYERS][UINFO];

// Диалоги

enum dialogs{
	NULL,// Нулевой диалог
	dRegistration=1,// Диалог регистрации
	dRegistrationEmail,//Диалог ввода электронной почты
	dRegistrationReferal,//Диалог ввода реферала
	dRegistrationAge,//Диалог ввода возраста персонажа
	dRegistrationOrigin,//Диалог выбора расы персонажа
	dRegistrationGender,//Диалог выбора пола персонажа
	dAuthorization//Диалог авторизации
}

// Прочее

new origins[5][24]={
	"NULL","Европеоидная","Негроидная","Монголоидная","Американоидная"
};// Расы персонажей

new characters[5][3][16]={
	{{NULL},{NULL},{NULL}},// Нулевая ячейка
	{{NULL},{6,23,26,32,46,82,101,188,259,299,20,29,45,184},{12,31,41,55,88,91,233}},// Европеоидная мужские/женские
	{{NULL},{83,183,221,7,14,21,4,76},{9,40,211,215}},// Негроидная мужские/женские
	{{NULL},{229,44,58,170,210,229},{56,141,193,224,225}},// Монголоидная мужские/женские
	{{NULL},{26,32,37,46,82,94,101,188,242,259,299,20,29,72,97,184},{12,41,55,91,191,233}}// Американоидная мужские/женские
};// Скины персонажей

/*      Каллбэки    */

public OnGameModeInit(){// Запускаем игровой мод
	mysql_connection=mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DATABASE,MYSQL_PASSWORD);// Подключение к базе данных
	switch(mysql_errno(mysql_connection)){// Проверяем подключение на ошибки
	    case 0:{//Если подключение без ошибок
	        print(""MYSQL_DATABASE": Подключение к '"MYSQL_HOST"' - успешно");
	    }
	    default:{// Если есть казусы с подключением
	        printf(""MYSQL_DATABASE": Ошибка подключения к '"MYSQL_HOST"' (#%i)",mysql_errno(mysql_connection));// Выводим сообщение об ошибке и её номер
	        return true;// Выходим из функции
	    }
	}
	mysql_log(LOG_DEBUG);//Включаем дебаг режим
	SetGameModeText("Doshirak v0.001");//Ставим название мода для клиента
	SendRconCommand("hostname Doshirak Role Play - 0.3.7");//Ставим название сервера для клиента через RCON
	LoadObjects();
	return true;
}

public OnPlayerConnect(playerid){// Подключаемся к серверу
	new temp_ip[16];//Создаём переменную для записи IP адреса
	GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));//Записываем IP адрес в переменную
	for(new i=0; i!=MAX_PLAYERS; i++){//Проходим по циклу игроков, иначе 1000 итераций
		if(!strcmp(check_ip_for_reconnect[i],temp_ip)){//Если одна из итераций в переменной совпала с глобальной переменной
		    if(gettime()-check_ip_for_reconnect_time[i]<20){//И если полученное время оказалось меньше 20-ти, то...
		        SendClientMessage(playerid,C_RED,"Вы были кикнуты сервером! Причина: Anti Reconnect");
		        SetTimerEx("@__kick_player",250,false,"i",playerid);//Кикаем игрока
		        return true;//Выходим из функции
		    }
		}
	}
	GetPlayerIp(playerid,check_ip_for_reconnect[playerid],16);//Записываем IP адрес в глобальную переменную
	GetPlayerName(playerid,player[playerid][name],MAX_PLAYER_NAME);//Запишем никнейм игрока в переменную
	new query[36-2+MAX_PLAYER_NAME];// Объявляем переменную для запроса
	mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",player[playerid][name]);// Форматируем "безопасный" запрос в базу данных
	mysql_query(mysql_connection,query);// Отправляем запрос в базу данных
	if(cache_get_row_count(mysql_connection)){// Если в базе есть больше нуля полей с одинаковым никнеймом
		new string[118-2+MAX_PLAYER_NAME];// Создаём переменную для форматирования
		format(string,sizeof(string),"\n"WHITE"Добро пожаловать на "BLUE"Doshirak RP!"WHITE"\nВам необходимо авторизоваться!\nВаш логин: "BLUE"%s\n\n",player[playerid][name]);//Форматируем текст
		ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"Авторизация",string,"Дальше","Выход");
	}
	else{// Если в базе нет ни одного поля в никнеймом
	    new string[122-2+MAX_PLAYER_NAME];
	    format(string,sizeof(string),"\n"WHITE"Добро пожаловать на "BLUE"Doshirak RP!"WHITE"\nВам необходимо зарегистрироваться!\nВаш логин: "BLUE"%s\n\n",player[playerid][name]);
	    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"Регистрация",string,"Дальше","Выход");
	}
	RemovePlayerObjects(playerid);//Убираем объекты для игрока (doshirak\objects)
	TogglePlayerSpectating(playerid,true);//Переводим игрока в режим слежения
	return true;
}

public OnPlayerDisconnect(playerid,reason){
	check_ip_for_reconnect_time[playerid]=gettime();//Записываем время выхода с сервера (ОБНУЛЯТЬ НЕЛЬЗЯ!)
	return true;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	while(strfind(inputtext,"%s",true)!=-1){//Пока в тексте находится идентификатор, выполняется цикл
		strdel(inputtext,strfind(inputtext,"%s",true),strfind(inputtext,"%s",true)+2);//Если найден идентификатор, то удаляем его
	}
	switch(dialogid){//Объявляем оператор для работы с разделами(номерами) диалогов
	    case dRegistration:{//Если dialogid равен единице, то переходим в тело
	        if(response){// Если ответ диалога равен истине(левая кнопка диалога), то
				new sscanf_password[MAX_PASSWORD_LEN]/*Переменная для записи пароля*/, string[122-2+MAX_PLAYER_NAME+77]/*Переменная для форматирования текста*/;// Объявляем переменные
    			format(string,sizeof(string),"\n{ffffff}Добро пожаловать на "BLUE"Doshirak RP!"WHITE"\nВам необходимо зарегистрироваться!\nВаш логин: "BLUE"%s\n\n",player[playerid][name]);// Форматируем текст
				if(sscanf(inputtext,"s[128]",sscanf_password)){// Если все ячейки равны нулю, то условие пройдёт в тело
				    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"Регистрация",string,"Дальше","Выход");// Показываем диалог с ранее форматированным текстом
				    return true;// Выходим из функции
				}
				new strlen_text=sizeof(string);// Узнаём количество символов в ранее форматированном тексте
				if(strlen(sscanf_password)<MIN_PASSWORD_LEN || strlen(sscanf_password)>MAX_PASSWORD_LEN){// Если пароль меньше указанных символов или больше указанных символов, то условие пройдёт в тело
					strcat(string,""RED"Длина пароля может быть не меньше 4-х и не больше 24-х символов!\n\n");// Связываем дополнительный текст с форматированным
				    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"Регистрация",string,"Дальше","Выход");// Показываем диалог с полученным текстом
				    strdel(string,strlen_text,sizeof(string));// Удаляем текст, который ранее связывали с форматированным
				    return true;// Выходим из функции
				}
                if(!regex_match(sscanf_password,"[a-zA-Z0-9]+")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело
                    strcat(string,""RED"В пароле используются недопустимые символы!\n\n");// Связываем дополнительный текст с форматированным
                    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"Регистрация",string,"Дальше","Выход");// Показываем диалог с полученным текстом
                    strdel(string,strlen_text,sizeof(string));// Удаляем текст, который ранее связывали с форматированным
                    return true;// Выходим из функции
                }
                new query[55-2-2+MAX_PLAYER_NAME+MAX_PASSWORD_LEN];// Объявляем переменную для отправления запроса в базу данных
                mysql_format(mysql_connection,query,sizeof(query),"insert into`users`(`name`,`password`)values('%e','%e')",player[playerid][name],sscanf_password);// Форматируем "безопасный" запрос создания ячейки в базе данных
                mysql_query(mysql_connection,query);// Отправляем запрос в базу данных
				player[playerid][id]=cache_insert_id(mysql_connection);//Возьмём значение авто инкременета из базы данных в переменную игрока
				ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n{ffffff}Для продолжения регистрации необходимо\nуказать адрес электронной почты\n\n","Дальше","Пропустить");// Показываем диалог ввода электронной почты
				SendClientMessage(playerid,C_BLUE,"Ваш аккаунт внесён в базу данных сервера!");//Выводим сообщение об успешном создании аккаунта
	        }
	        else{// Если ответ диалога равен лжи(правая кнопка диалога), то
				SendClientMessage(playerid,C_RED,"Вы отказались от регистрации и были кикнуты!");// Выводим сообщение в чат
				SetTimerEx("@__kick_player",250,false,"i",playerid);// Выталкиваем игрока с сервера под таймером
	        }
	    }
	    case dRegistrationEmail:{//Если dialogid равен двойке, то переходим в тело
	        if(response){//Если ответ от диалога равен истинее (левая кнопка), то...
	            new sscanf_email[MAX_EMAIL_LEN];//Объявляем переменную для записи эл. почты
				if(sscanf(inputtext,"s[128]",sscanf_email)){//Если поле ввода оказалось пустым, то...
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n{ffffff}Для продолжения регистрации необходимо\nуказать адрес электронной почты\n\n","Дальше","Пропустить");
				    return true;//Выходим из функции
				}
				if(strlen(sscanf_email)<MIN_EMAIL_LEN || strlen(sscanf_email)>MAX_EMAIL_LEN){//Если длина текста меньше n, и больше n, то...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n{ffffff}Для продолжения регистрации необходимо\nуказать адрес электронной почты\n\n"RED"Длина адреса электронной почты может не меньше 4-х и не больше 32-х символов!","Дальше","Пропустить");
				    return true;//Выходим из функции
				}
				if(!regex_match(sscanf_email,"[a-zA-Z0-9_\\.-]+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z]{2,4}")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n{ffffff}Для продолжения регистрации необходимо\nуказать адрес электронной почты\n\n"RED"В адресе электронной почте найдены недопустимые символы!","Дальше","Пропустить");
				    return true;//Выходим из функции
				}
				new query[35-2-2+MAX_EMAIL_LEN+11];//Объявляем переменную для записи запроса в БД
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`email`='%e'",sscanf_email);//Форматируем запрос с возвращением ответа
				mysql_query(mysql_connection,query);// Отправляем запрос в БД
				if(cache_get_row_count(mysql_connection)){// Если ответ равен истинне, либо больше, то...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n{ffffff}Для продолжения регистрации необходимо\nуказать адрес электронной почты\n\n"RED"Указанный электронный адрес уже зарегистрирован в системе!","Дальше","Пропустить");
					//Показываем тот же диалог
				}
				else{//Если ответ равен лжи, либо нулю, то...
				    strins(player[playerid][email],sscanf_email,0,sizeof(sscanf_email));//Записываем введенный выше текст в переменную
				    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`email`='%e'where`id`='%i'",player[playerid][email],player[playerid][id]);//Форматируем запрос с обновлением ячейки
					mysql_query(mysql_connection,query);//Отправляем запрос
                    ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Если вы пришли на сервер по приглашению,\nто можете указать никнейм или промокод\n\n","Дальше","Пропустить");
					//Показываем диалог с вводом рефера/промокода
				}
	        }
	        else{//Если ответ диалога равен лжи (правая кнопка), то...
	            ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Если вы пришли на сервер по приглашению,\nто можете указать никнейм или промокод\n\n","Дальше","Пропустить");
                //Показываем диалог с вводом рефера/промокода
	        }
	    }
		case dRegistrationReferal:{// Если dialogid равен тройке, то...
		    if(response){//Если ответ диалога равен истине (левая кнопка), то...
		        new sscanf_referal_name[MAX_PROMOCODE_LEN];//Объявляем переменную для записи рефера/промокода
		        if(sscanf(inputtext,"s[128]",sscanf_referal_name)){//Если поле ввода оказалось пустым, то...
		            ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Если вы пришли на сервер по приглашению,\nто можете указать никнейм или промокод\n\n","Дальше","Пропустить");
		            return true;//Выходим из функции
		        }
				new query[45-2+MAX_PROMOCODE_LEN];//Объявляем переменную для форматирования запроса
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",sscanf_referal_name);//Форматируем запрос с возвращением ответа
				mysql_query(mysql_connection,query);//Отправляем запрос в БД
				if(cache_get_row_count(mysql_connection)){// Если ответ равен истинне, либо больше, то...
				    strins(player[playerid][referal_name],sscanf_referal_name,0);//Записываем введённый выше текст в переменную
				    SendClientMessage(playerid,C_BLUE,"Вы были приглашены игроком по никнейму!");//Выводим сообщение с текстом о типе рефера
                    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Вам необходимо указать возраст вашего персонажа\n"BLUE"Пример: (16 - 60)\n\n","Дальше","Выход");
					//Выводим диалог с вводом возраста персонажа
				}
				else{//Если ответ равен лжи, то...
				    mysql_format(mysql_connection,query,sizeof(query),"select*from`promocodes`where`promocode`='%e'",sscanf_referal_name);//Форматируем запрос с возвращением ответа
				    mysql_query(mysql_connection,query);// Отправляем запрос
				    if(cache_get_row_count(mysql_connection)){// Если ответ равен истинне, либо больше, то...
				        if(!regex_match(sscanf_referal_name,"[a-zA-Z0-9_#@!]+") || strlen(sscanf_referal_name)<MIN_PROMOCODE_LEN || strlen(sscanf_referal_name)>MAX_PROMOCODE_LEN){
				            //Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело ИЛИ длина текста меньше n ИЛИ длина текста больше n
	                        ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Если вы пришли на сервер по приглашению,\nто можете указать никнейм или промокод\n\n"RED"В введённом промокоде найдены недопустимые символы!\n\n","Дальше","Пропустить");
		          		    return true;//Выходим из функции
		          		}
						strins(player[playerid][referal_name],sscanf_referal_name,0);//Записываем введённый выше текст в переменную
						SendClientMessage(playerid,C_BLUE,"Вы были приглашены игроком по промокоду!");//Выводим сообщение с текстом о типе рефера
						ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Вам необходимо указать возраст вашего персонажа\n"BLUE"Пример: (16 - 60)\n\n","Дальше","Выход");
						//Выводим диалог с вводом возраста персонажа
				    }
				    else{//Если ответ равен лжи, то...
				        //Показываем тот же диалог
                        ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Если вы пришли на сервер по приглашению,\nто можете указать никнейм или промокод\n\n"RED"Указанный никнейм/промокод не найден!\n\n","Дальше","Пропустить");
                        return true;//Выходим из функции
				    }
				}
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`referal_name`='%e'where`id`='%i'",player[playerid][referal_name],player[playerid][id]);//Форматируем запрос с обновлением ячеек
				mysql_query(mysql_connection,query);//Отправляем запрос
		    }
		    else{//Если ответ диалога равен лжи (правая кнопка), то...
                ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Вам необходимо указать возраст вашего персонажа\n"BLUE"Пример: (16 - 60)\n\n","Дальше","Выход");
		    }
		}
		case dRegistrationAge:{
		    if(response){
		        new sscanf_age;
		        if(sscanf(inputtext,"i",sscanf_age)){
		            ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Вам необходимо указать возраст вашего персонажа\n"BLUE"Пример: (16 - 60)\n\n","Дальше","Выход");
		            return true;
		        }
				if(sscanf_age<16 || sscanf_age>60){
				    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Вам необходимо указать возраст вашего персонажа\n"RED"Пример: (16 - 60)\n\n","Дальше","Выход");
				    return true;
				}
				player[playerid][age]=sscanf_age;
				new query[41-2-2+3+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`age`='%i'where`id`='%i'",player[playerid][age],player[playerid][id]);
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,dRegistrationOrigin,DIALOG_STYLE_TABLIST_HEADERS,"Регистрация",""BLUE"Выберите расу вашего персонажа:"WHITE"\n[0] Европеоидная\n[1] Негроидная\n[2] Монголоидная\n[3] Американоидная","Дальше","Выход");
		    }
		    else{
		        SendClientMessage(playerid,C_RED,"Вы отказались от регистрации и были кикнуты!");// Выводим сообщение в чат
				SetTimerEx("@__kick_player",250,false,"i",playerid);// Выталкиваем игрока с сервера под таймером
		    }
		}
		case dRegistrationOrigin:{
		    if(response){
				player[playerid][origin]=listitem+1;
				new string[21-2+24];
				format(string,sizeof(string),"Вы выбрали расу - %s",origins[player[playerid][origin]]);
				SendClientMessage(playerid,C_BLUE,string);
				new query[44-2-2+1+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`origin`='%i'where`id`='%i'",player[playerid][origin],player[playerid][id]);
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,dRegistrationGender,DIALOG_STYLE_MSGBOX,"Регистрация","\n"WHITE"Выберите пол вашего персонажа\n\n","Мужской","Женский");
		    }
		    else{
                SendClientMessage(playerid,C_RED,"Вы отказались от регистрации и были кикнуты!");// Выводим сообщение в чат
				SetTimerEx("@__kick_player",250,false,"i",playerid);// Выталкиваем игрока с сервера под таймером
		    }
		}
		case dRegistrationGender:{
		    player[playerid][gender]=(response)?1:2;
		    TogglePlayerSpectating(playerid,false);
		    SetPVarInt(playerid,"PlayerChoiceCharacter",1);
		    SetPVarInt(playerid,"PlayerChoiceCharacterNumber",1);
		    new query[44-2-2+1+11];
			mysql_format(mysql_connection,query,sizeof(query),"update`users`set`gender`='%i'where`id`='%i'",player[playerid][gender],player[playerid][id]);
			mysql_query(mysql_connection,query);
		    SendClientMessage(playerid,-1,"Для выбора между скина используйте клавиши "BLUE"(NUM4) "WHITE"и "BLUE"(NUM6)");
		    SendClientMessage(playerid,-1,"Чтобы сохранить выбранный скин, используйте клавишу "BLUE"(SPACE)");
			SetSpawnInfo(playerid,0,player[playerid][character]=characters[player[playerid][origin]][player[playerid][gender]][GetPVarInt(playerid,"PlayerChoiceCharacterNumber")],0.0,0.0,0.0,0.0,0,0,0,0,0,0);
			SpawnPlayer(playerid);
		}
		case dAuthorization:{
		    if(response){
		        new sscanf_password[MAX_PASSWORD_LEN], string[118-2+MAX_PLAYER_NAME+77];
                format(string,sizeof(string),"\n"WHITE"Добро пожаловать на "BLUE"Doshirak RP!"WHITE"\nВам необходимо авторизоваться!\nВаш логин: "BLUE"%s\n\n",player[playerid][name]);
                if(sscanf(inputtext,"s[128]",sscanf_password)){
                    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"Авторизация",string,"Дальше","Выход");
                    return true;
                }
                new strlen_text=sizeof(string);// Узнаём количество символов в ранее форматированном тексте
				if(strlen(sscanf_password)<MIN_PASSWORD_LEN || strlen(sscanf_password)>MAX_PASSWORD_LEN){// Если пароль меньше указанных символов или больше указанных символов, то условие пройдёт в тело
					strcat(string,""RED"Длина пароля может быть не меньше 4-х и не больше 24-х символов!\n\n");// Связываем дополнительный текст с форматированным
				    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"Авторизация",string,"Дальше","Выход");// Показываем диалог с полученным текстом
				    strdel(string,strlen_text,sizeof(string));// Удаляем текст, который ранее связывали с форматированным
				    return true;// Выходим из функции
				}
                if(!regex_match(sscanf_password,"[a-zA-Z0-9]+")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то услоавие пройдёт в тело
                    strcat(string,""RED"В пароле используются недопустимые символы!\n\n");// Связываем дополнительный текст с форматированным
                    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"Авторизация",string,"Дальше","Выход");// Показываем диалог с полученным текстом
                    strdel(string,strlen_text,sizeof(string));// Удаляем текст, который ранее связывали с форматированным
                    return true;// Выходим из функции
                }
				new query[53-2-2+MAX_PLAYER_NAME+MAX_PASSWORD_LEN];
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`password`='%e'and`name`='%e'",sscanf_password,player[playerid][name]);
				mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
				    player[playerid][id]=cache_get_field_content_int(0,"id",mysql_connection);
					cache_get_field_content(0,"email",player[playerid][email],mysql_connection,MAX_EMAIL_LEN);
					cache_get_field_content(0,"referal_name",player[playerid][referal_name],mysql_connection,MAX_EMAIL_LEN);
					player[playerid][referal_money]=cache_get_field_content_int(0,"referal_money",mysql_connection);
					player[playerid][age]=cache_get_field_content_int(0,"age",mysql_connection);
					player[playerid][origin]=cache_get_field_content_int(0,"origin",mysql_connection);
					player[playerid][gender]=cache_get_field_content_int(0,"gender",mysql_connection);
					player[playerid][character]=cache_get_field_content_int(0,"character",mysql_connection);
					SetPVarInt(playerid,"PlayerLogged",1);
					TogglePlayerSpectating(playerid,false);
					SpawnPlayer(playerid);
				}
				else{
					new inc_string[40-2+1];
					format(inc_string,sizeof(inc_string),"{ffffff}Неправильный пароль! (%d/3)\n\n",GetPVarInt(playerid,"PasswordAttempts"));
					strcat(string,inc_string);
					ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"Авторизация",string,"Дальше","Выход");
					strdel(string,strlen_text,sizeof(string));
					SetPVarInt(playerid,"PasswordAttempts",GetPVarInt(playerid,"PasswordAttempts")-1);
					if(GetPVarInt(playerid,"PasswordAttempts")<=0){
					    ShowPlayerDialog(playerid,NULL,NULL,"","","","");
					    SendClientMessage(playerid,C_RED,"Вы ввели неправильный пароль три раза и были кикнуты!");
					    SetTimerEx("@__kick_player",250,false,"i",playerid);
					    return true;
					}
				}
		    }
		    else{
				SendClientMessage(playerid,C_RED,"Вы отказались от авторизации и были кикнуты!");
				SetTimerEx("@__kick_player",250,false,"i",playerid);
		    }
		}
	}
	return true;
}

public OnPlayerSpawn(playerid){
	if(GetPVarInt(playerid,"PlayerChoiceCharacter")){
	    SetPlayerPos(playerid,221.9781,-10.9523,1002.2109);
		SetPlayerFacingAngle(playerid,32.6315);
		SetPlayerCameraPos(playerid,221.2089,-8.9589,1003.5172);
		SetPlayerCameraLookAt(playerid,221.9781,-10.9523,1002.2109);
		TogglePlayerControllable(playerid,false);
	    SetPlayerVirtualWorld(playerid,1+random(50));
	    SetPlayerInterior(playerid,5);
		SetPlayerSkin(playerid,player[playerid][character]=characters[player[playerid][origin]][player[playerid][gender]][GetPVarInt(playerid,"PlayerChoiceCharacterNumber")]);
	    return true;
	}
	if(!GetPVarInt(playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"Вы должны авторизоваться!");
	    SetTimerEx("@__kick_player",250,false,"i",playerid);
	    return true;
	}
	SetPlayerPos(playerid,1895.7316,-1682.5453,13.4989);
	SetPlayerFacingAngle(playerid,90.0);
	SetPlayerSkin(playerid,player[playerid][character]);
	return true;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys){
	if((gettime()-GetPVarInt(playerid,"FloodKeyState"))<1){
	    return true;
	}
	SetPVarInt(playerid,"FloodKeyState",gettime());
	if(newkeys & KEY_NUM4){
	    if(GetPVarInt(playerid,"PlayerChoiceCharacter")){
			SetPVarInt(playerid,"PlayerChoiceCharacterNumber",GetPVarInt(playerid,"PlayerChoiceCharacterNumber")-1);
			SetPlayerSkin(playerid,player[playerid][character]=characters[player[playerid][origin]][player[playerid][gender]][GetPVarInt(playerid,"PlayerChoiceCharacterNumber")]);
			if(GetPVarInt(playerid,"PlayerChoiceCharacterNumber")<=0){
			    switch(player[playerid][origin]){
				    case 1:{
				    	SetPVarInt(playerid,"PlayerChoiceCharacterNumber",player[playerid][gender]?13:6);
					}
					case 2:{
					    SetPVarInt(playerid,"PlayerChoiceCharacterNumber",player[playerid][gender]?7:3);
					}
					case 3:{
					    SetPVarInt(playerid,"PlayerChoiceCharacterNumber",player[playerid][gender]?5:4);
					}
					case 4:{
					    SetPVarInt(playerid,"PlayerChoiceCharacterNumber",player[playerid][gender]?15:5);
					}
				}
			}
	    }
	    return true;
	}
	else if(newkeys & KEY_NUM6){
	    if(GetPVarInt(playerid,"PlayerChoiceCharacter")){
			SetPVarInt(playerid,"PlayerChoiceCharacterNumber",GetPVarInt(playerid,"PlayerChoiceCharacterNumber")+1);
			SetPlayerSkin(playerid,player[playerid][character]=characters[player[playerid][origin]][player[playerid][gender]][GetPVarInt(playerid,"PlayerChoiceCharacterNumber")]);
			if(player[playerid][gender]==1 && (player[playerid][origin]==1 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=13 || player[playerid][origin]==2 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=7 || player[playerid][origin]==3 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=5 || player[playerid][origin]==4 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=15) || player[playerid][gender]==2 && (player[playerid][origin]==1 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=6 || player[playerid][origin]==2 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=3 || player[playerid][origin]==3 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=4 || player[playerid][origin]==4 && GetPVarInt(playerid,"PlayerChoiceCharacterNumber")>=5 )){
                SetPVarInt(playerid,"PlayerChoiceCharacterNumber",0);
			}
	    }
	    return true;
	}
	else if(newkeys & KEY_SPRINT){
	    if(GetPVarInt(playerid,"PlayerChoiceCharacter")){
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid,0);
			DeletePVar(playerid,"PlayerChoiceCharacter");
			DeletePVar(playerid,"PlayerChoiceCharacterNumber");
			SetPVarInt(playerid,"PlayerLogged",1);
			new query[47-2-2+3+11];
			mysql_format(mysql_connection,query,sizeof(query),"update`users`set`character`='%i'where`id`='%i'",player[playerid][character],player[playerid][id]);
			mysql_query(mysql_connection,query);
			SpawnPlayer(playerid);
	    }
	    return true;
	}
	return true;
}

public OnPlayerCommandText(playerid,cmdtext[]){
	if(!strcmp("/car",cmdtext)){
	    new Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid,x,y,z);
		CreateVehicle(560,x,y,z,0.0,0,0,false,0);
	    return true;
	}
	return true;
}

/*      Кастомные каллбеки      */

@__kick_player(playerid);
@__kick_player(playerid){
	Kick(playerid);
	return true;
}

/*      ------------------      */
