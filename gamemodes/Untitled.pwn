
// Doshirak RP - D1maz. - vk.com/d1maz.community - 2017-2019

/*      Инклуды     */

#include <a_samp>
main(){}
#include <a_mysql>
#include <sscanf2>
#include <regex>
#include <crashdetect>
#include <streamer>
#include <doshirak\objects>//Объекты сервера
#include <dc_cmd>
#include <foreach>
#include <doshirak\colors>//Дефайны цветов
#include <doshirak\3dtexts>//3Д тексты сервера
#include <doshirak\pickups>//Пикапы сервера
#include <a_actor>
#include <doshirak\fixes>//Фиксы некоторых функций
#include <doshirak\textdraws>
#include <jit>

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
#define MAX_ENTRANCE (3) // Максимальное количество дверей
#undef MAX_ACTORS//Удаляем дефайн
#define MAX_ACTORS (10)// Создаём дефайн, равный 9
#define MAX_HOUSES (512)//Максимальное количество домов
#define MAX_HOUSE_INTERIORS (8)//Максимальное количество интерьеров для домов
#define MAX_FACTIONS (2)//Максимальное количество фракций
#define MAX_ADMIN_COMMANDS (16)//Максимальное количество команд администраторов
#define MAX_OWNED_HOUSES (4)//Максимальное количество купленых домов одним владельцем
#define MAX_RANKS_IN_FACTION (11)//Максимальное количество рангов во фракции
#undef MAX_VEHICLES//Удаляем дефайн
#define MAX_VEHICLES (24)//Максимальное количество транспорта
#define MAX_TRANSPORT (212)//Максимальное количество моделей на сервере
#define MAX_BUSINESS_INTERIORS (1)//Максимальное количество интерьеров для бизнесов
#define MAX_BUSINESSES (2)//Максимальное количество бизнесов
#define MAX_OWNED_BUSINESSES (2)//Максимальное количество купленных бизнесов
#define MAX_ITEMS_IN_BUSINESS (32)//Максимальное количество различных товаров в бизнесе
#define MAX_OWNED_VEHICLES (3)//Максимальное количество купленых авто

#define SECONDS_IN_DAY (86400)//Количество секунд в одном дне
#define SECONDS_IN_WEEK (SECONDS_IN_DAY*7)//Количество секунд в одной неделе
#define SECONDS_IN_MONTH (SECONDS_IN_DAY*30)//Количество секунд в одном месяце

#define MAX_PASSWORD_LEN (24) // Максимальная длина пароля
#define MIN_PASSWORD_LEN (4) // Минимальная длина пароля
#define MAX_EMAIL_LEN (32) // Максимальная длина почты
#define MIN_EMAIL_LEN (10) // Минимальная длина почты
#define MAX_PROMOCODE_LEN (32) // Максимальная длина промокода
#define MIN_PROMOCODE_LEN (4) // Минимальная длина промокода
#define MIN_PLAYER_NAME_LEN (3)//Минимальная длина ника

#define PAYDAY_TIME (30*60) // Время, необходимое для получения зарплаты
#define NEEDED_EXPERIENCE (3) // Количество опыта, необходимое для повышения уровня
#define NEEDED_LEVEL_FOR_REFERAL_TO_TAKE_MONEY (3)// Уровень для реферала, чтобы получить бонус

#define DEVELOPER "Dmitriy_Yakimov"//Никнейм разрабочика

#define SERVER_OPENBETATEST

#define VEHICLE_DRIVER_SEAT (0)//водительское место
#define VEHICLE_FRONT_PASSENGER_SEAT (1)//
#define VEHICLE_BACK_LEFT_PASSENGER_SEAT (2)//
#define VEHICLE_BACK_RIGHT_PASSENGER_SEAT (3)//

// Макросы для TextDraw

#define TD_SPEED_FUEL (1)//Спидометр - топливо
#define TD_SPEED_SPEED (2)//Спидометр - скорость
#define TD_SPEED_WAY (3)//Спидометр - пробег
#define TD_SPEED_DOORS (4)//Спидометр - двери
#define TD_SPEED_LIGHTS (5)//Спидометр - фары

#define TD_REG_NICKNAME (1)//регистрация - никнейм игрока
#define TD_REG_PASSWORD (2)//регистрация - пароль
#define TD_REG_BEAT_PASSWORD (3)//регистрация - клавиша пароля
#define TD_REG_EMAIL (4)//регистрация - почта
#define TD_REG_REFERRER (5)//регистрация - никнейм реферера/промокод
#define TD_REG_GENDER (6)//регистрация - пол персонажа
#define TD_REG_ORIGIN (7)//регистрация - выбор расы
#define TD_REG_BEAT_EMAIL (8)//регистрация - клавиша ввода почты
#define TD_REG_BEAT_REFERRER (9)//регистрация - клавиша ввода реферера
#define TD_REG_BEAT_GENDER (10)//регистрация - клавиша выбора пола
#define TD_REG_BEAT_ORIGIN (11)//регистрация - клавиша выбора расы
#define TD_REG_CHARACTER (12)//регистрация - preview model скин
#define TD_REG_ARROW_RIGHT (13)//регистрация - >
#define TD_REG_ARROW_LEFT (14)//регистрация - <
#define TD_REG_LOG_UP (15)//регистрация - зарегистрироваться
#define TD_REG_AGE (16)//регистрация - возраст
#define TD_REG_BEAT_AGE (17)//регистрация - клавиша ввода возраста

#define TD_AUTH_NICKNAME (1)//авторизация - никнейм игрока
#define TD_AUTH_PASSWORD (2)//авторизация - пароль
#define TD_AUTH_BEAT_PASSWORD (3)//авторизация - кнопка ввода пароля
#define TD_AUTH_LOG_IN (4)//авторизация - авторизоваться

#define TD_FREE_HOUSE_HOUSE_ID (1)//свободный дом - номер дома
#define TD_FREE_HOUSE_OWNER (2)//свободный дом - владелец
#define TD_FREE_HOUSE_COST (3)//свободный дом - стоимость
#define TD_FREE_HOUSE_CLASS (4)//свободный дом - класс

#define TD_OWNED_HOUSE_HOUSE_ID (1)//купленый дом - номер дома
#define TD_OWNED_HOUSE_OWNER (2)//купленый дом - владелец
#define TD_OWNED_HOUSE_CLASS (3)//купленый дом - класс

#define TD_BUY_CAR_VEHICLE_1 (1)//покупка транспорта - превью спереди
#define TD_BUY_CAR_VEHICLE_2 (2)//покупка транспорта - превью сзади
#define TD_BUY_CAR_SELECT_VEHICLE_ARROW_RIGHT (3)//покупка транспорта - выбор модели >
#define TD_BUY_CAR_SELECT_VEHICLE_ARROW_LEFT (5)//покупка транспорта - выбор модели <
#define TD_BUY_CAR_MODEL (7)//покупка транспорта - модель
#define TD_BUY_CAR_FUEL_TANK (8)//покупка транспорта - вместимость бака
#define TD_BUY_CAR_PRICE (9)//покупка транспорта - цена
#define TD_BUY_CAR_BUY (11)//покупка транспорта - купить транспорт
#define TD_BUY_CAR_CANCEL (12)//покупка транспорта - выйти

#define TD_FREE_BUSINESS_ID (1)//свободный бизнес - номер бизнеса
#define TD_FREE_BUSINESS_OWNER (2)//свободный бизнес - владелец
#define TD_FREE_BUSINESS_COST (3)//свободный бизнес - стоимость
#define TD_FREE_BUSINESS_TYPE (4)//свободный бизнес - тип бизнеса
#define TD_FREE_BUSINESS_NAME (7)//свободный бизнес - название бизнеса

#define TD_OWNED_BUSINESS_ID (1)//купленный бизнес - номер бизнеса
#define TD_OWNED_BUSINESS_NAME (2)//купленный бизнес - название бизнеса
#define TD_OWNED_BUSINESS_OWNER (3)//купленный бизнес - владелец
#define TD_OWNED_BUSINESS_TYPE (6)//купленный бизнес - тип бизнеса

/*      Переменные  */

// Проверка по IP

new check_ip_for_reconnect[MAX_PLAYERS][16],//Двойная глобальная переменная для записи IP адреса
	check_ip_for_reconnect_time[MAX_PLAYERS];//Глобальная переменная для записи времени
	
// Собственности
	
new owned_house_id[MAX_PLAYERS][MAX_OWNED_HOUSES];//Здесь хранятся id купленых домов

new owned_business_id[MAX_PLAYERS][MAX_OWNED_BUSINESSES];//Здесь хранятся id купленых бизнесов

new owned_vehicle_id[MAX_PLAYERS][MAX_OWNED_VEHICLES];// Здесь хранятся id купленых авто
	
// 3Д текст на персонажа

new Text3D:attach_3dtext_labelid[MAX_PLAYERS],//ID 3д текста
	bool:attached_3dtext[MAX_PLAYERS];//Для условия

// Аккаунты

enum UINFO{
	id,// Номер аккаунта
	name[MAX_PLAYER_NAME],// Никнейм
	email[MAX_EMAIL_LEN],// Электронная почта
	referal_name[MAX_PLAYER_NAME],//Никнейм реферала
	age,//Возраст персонажа
	origin,//Раса персонажа
	gender,//Пол персонажа
	character,//Скин персонажа
	level,// Уровень
	experience,// Опыт
	reg_ip[16],// Регистрационный IP
	reg_date[32],// Дата регистрации
	money,//Деньги персонажа
	passport_id,//Номер паспорта
	description[64],//текст, который будет прикреплён на персонажа
	faction_id,//Номер фракции
	rank_id,//Номера ранга
	mute//время блокировки чата
}

new player[MAX_PLAYERS][UINFO];

// Диалоги

enum dialogs{
	NULL,// Нулевой диалог
	dRegistration=1,// Диалог регистрации
	dRegistrationEmail,//Диалог ввода электронной почты
	dRegistrationReferal,//Диалог ввода реферала
	dRegistrationAge,//Диалог ввода возраста персонажа
	dAuthorization,//Диалог авторизации
	dAuthorizationSpawn,//Диалог выбора спавна
	dAuthorizationSpawnHouse,//Спавн в доме
	dMainMenu,//Диалог главного меню
	dMainMenuReferalSystem,//Меню реферальной системы
	dMainMenuReferalSystemInfo,//Информация о реферальной системе
	dMainMenuReferalSystemDelete,//Удаление промокода
	dMainMenuReferalSystemCreate,//Создание промокода
	dMainMenuReferalSystemCrLevel,//Ввод уровня для промокода
	dMainMenuReferalSystemCrMoney,//Ввод бонуса для промокода - деньги
	dMainMenuReferalSystemCrExp,//Ввода бонуса для промокода - опыт
	dMainMenuReferalSystemCrConfirm,//Подтверждение создания промокода
	dMainMenuReferalSystemInput,//указать реферера
	dMainMenuInfAboutPers,//Меню информации о персонаже
	dMainMenuInfAboutPersCharacter,//Статистика персонажа
	dMainMenuInfAboutPersAccount,//Статистика аккаунта
	dMainMenuInfAboutBankAccounts,//Просмотр номеров банковских счетов
	dMainMenuHelp,
	dMainMenuHelpCommands,
	dMainMenuHelpCommandsChat,
	dMainMenuHelpCommandsFaction,
	dMainMenuSettings,
	dMainMenuSettingsEmail,
	dBankCreateAccount,//Создание банковского счёта
	dBankCreateAccountDescription,//Описание для банковского счёта
	dBankCreateAccountPassword,//Пароль для банковского счёта
	dBankCreateAccountConfirm,//Подтверждение создания банковского счёта
	dBankCreateAccountSignConfirm,
	dBankAccountInput,//Ввод номера банковского счёта
	dBankAccountPassword,//Ввод пароля банковского счёта
	dBankAccountMenu,//Меню банковского счёта после авторизации
	dBankAccountMenuInf,//Информация о счёте
	dBankAccountMenuTransfer,//Перевод денег на другой счёт
	dBankAccountMenuTransferConfirm,//Подтверждение перевода денег на другой счёт
	dBankAccountMenuWithdraw,//Снятие денег со счёта
	dBankAccountMenuDeposit,//Пополнение счёта
	dBankAccountMenuTransactions,//Информация о транзакциях банковского счёта
	dBankPaymentService,
	dBankPaymentServiceTakePassport,
	dBankPaymentServiceRePassport,
	dCityHallInf,
	dCityHallInfPassport,
	dCityHallTakePassport,
	dCityHallTakePassportBirthday,
	dCityHallTakePassportSignature,
	dCityHallTakePassportValidality,
	dCityHallTakePassportConfirm,
	dCityHallRenewalPassport,
	dCityHallRenewalPassportValid,
	dCityHallRenewalPassportConfirm,
	dCityHallDelOrRenewalPassport,
	dCityHallAddHouse,
	dCityHallAddHouseClass,
	dCityHallAddHouseInterior,
	dCityHallAddHousePreview,
	dCityHallAddHouseTotalCost,
	dCityHallAddHouseConfirm,
	dDescription,
	dDescriptionTempDesc,
	dDescriptionSaveDesc,
	dDescriptionEditDesc,
	dInviteConfirm,
	dMakeleader,
	dGiveaccess,
	dFind,
	dAdminPasswordCreate,
	dAdminPasswordInput,
	dHome,
	dHomeMenu,
	dSellhome,
	dSellhomeSelect,
	dSellhomeWhom,
	dSellhomeWhomConfirm,
	dSellhomeWhomConfirmPlayer,
	dSellhomeState,
	dBuyhome,
	dApanel,
	dApanelProperty,
	dApanelPropertyConfirmList,
	dApanelPropertyConfirmMenu,
	dApanelTeleportToEntrance,
	dFpanel,
	dFpanelSpecial,
	dFpanelSpecialPriceForFee,
	dFpanelSpecialPrice4HClass,
	dFpanelSpecialPrice4HInterior,
	dFpanelSpecialPrice4HInteriorL,
	dFpanelSpecialPrice4HInteriorP,
	dFpanelSpecialPrice4HInteriorE,
	dFpanelCityHallConfirm,
	dFpanelCityHallConfirmMenu,
	dLpanel,
	dLpanelRanks,
	dLpanelRanksEdit,
	dLpanelOfflineMember,
	dLpanelOfflineMemberList,
	dLpanelSubleader,
	dLpanelSubleaderMake,
	dLpanelSubleaderAccess,
	dBusinessCenterLift,
	dBuybusiness,
	dBusiness,
	dBusinessMenu,
	dBusinessSell,
	dBusinessSellWhom,
	dBusinessSellWhomConfirm,
	dBusinessSellWhomConfirmPlayer,
	dBusinessSellState,
	dBuyCarConfirm,
	dLockVehicle,
	dJobLoader
}

enum transactionsType{
	FROM_ACCOUNT_TO_ACCOUNT=1,//Перевод со счёта на счёт
	WITHDRAW_FROM_ACCOUNT,//Снятие денег со счёта
	DEPOSIT_TO_ACCOUNT//Пополнение счёта
}

enum areaID{
	BANK_CREATE_ACCOUNT,
	BANK_TILL_ONE,
	BANK_TILL_TWO,
	BANK_TILL_THREE,
	CITYHALL_INFORMATION,
	CITYHALL_TAKE_PASSPORT,
	BANK_PAYMENT_FOR_SERVICES,
	CITYHALL_CREATE_HOUSE,
	BUSINESS_CENTER_LIFT[21],
	JOB_LOADER_NPC,
	JOB_LOADER_CLOTHES
}

new area[areaID];

enum actorINFO{
	id,//Уникальный номер актёра в бд
	description[32],//описание актёра
	character,//скин актёра
	Float:pos_x,//позиция актёра - х
	Float:pos_y,//позиция актёра - y
	Float:pos_z,//позиция актёра - z
	Float:pos_a,//угол поворота актёра
	virtualworld,//виртуальный мир актёра
	interior,//интерьер актёра
	animlib[32],//библиотека анимации
	animname[32],//название анимации
	Float:delta,
	loop,
	lockx,
	locky,
	freeze,
	time,
	Text3D:labelid,//ID 3Д текста
	createid//ID созданного актёра
}

new actor[MAX_ACTORS][actorINFO];
new total_actors;//Общее количество актёров

enum houseINFO{
	id,
	owner[MAX_PLAYER_NAME],
	Float:enter_x,
	Float:enter_y,
	Float:enter_z,
	Float:enter_a,
	house_interior,
	locked,
	cost,
	class,
	confirmed,
	area_id,
	pickupid,
	Text3D:labelid
}

new house[MAX_HOUSES][houseINFO];
new total_houses;//Общее количество созданных домов

enum house_interiorsINFO{
	id,
	description[32],
	Float:pos_x,
	Float:pos_y,
	Float:pos_z,
	Float:pos_a,
	interior,
	price,
	area_id
}

new house_interiors[MAX_HOUSE_INTERIORS][house_interiorsINFO];
new total_house_interiors;

// Прочее

new origins[4][24]={
	"Европеоидная","Негроидная","Монголоидная","Американоидная"
};// Расы персонажей

new reg_characters[4][2][16]={
	{{6,23,26,32,46,82,101,188,259,299,20,29,45,184},{12,31,41,55,88,91,233}},// Европеоидная мужские/женские
	{{83,183,221,7,14,21,4,76},{9,40,211,215}},// Негроидная мужские/женские
	{{229,44,58,170,210,229},{56,141,193,224,225}},// Монголоидная мужские/женские
	{{26,32,37,46,82,94,101,188,242,259,299,20,29,72,97,184},{12,41,55,91,191,233}}// Американоидная мужские/женские
};// Скины персонажей

new Float:lift_floor[21][4]={
	{1786.6383,-1300.3885,13.4918,0.0},//Лифт вход
	{1786.6346,-1300.3877,22.2109,0.0},//1 этаж
	{1786.6346,-1300.3877,27.6719,0.0},//2 этаж
	{1786.6346,-1300.3877,33.1250,0.0},//3 этаж
	{1786.6346,-1300.3877,38.5781,0.0},//4 этаж
	{1786.6346,-1300.3877,44.0391,0.0},//5 этаж
	{1786.6346,-1300.3877,49.4453,0.0},//6 этаж
	{1786.6346,-1300.3877,54.9063,0.0},//7 этаж
	{1786.6346,-1300.3877,60.3594,0.0},//8 этаж
	{1786.6346,-1300.3877,65.8125,0.0},//9 этаж
	{1786.6346,-1300.3877,71.2734,0.0},//10 этаж
	{1786.6346,-1300.3877,76.6719,0.0},//11 этаж
	{1786.6346,-1300.3877,82.1328,0.0},//12 этаж
	{1786.6346,-1300.3877,87.5859,0.0},//13 этаж
	{1786.6346,-1300.3877,93.0391,0.0},//14 этаж
	{1786.6346,-1300.3877,98.5000,0.0},//15 этаж
	{1786.6346,-1300.3877,103.8984,0.0},//16 этаж
	{1786.6346,-1300.3877,109.3594,0.0},//17 этаж
	{1786.6346,-1300.3877,114.8125,0.0},//18 этаж
	{1786.6346,-1300.3877,120.2656,0.0},//19 этаж
	{1786.6346,-1300.3877,125.7266,0.0}//20 этаж
};

new timer_general,
	timer_minute;

new global__time_hour;

enum paydayINFO{
	time,//время
	salary,//зарплата
	bool:taken//проверка, получена ли зарплата
}

new payday[MAX_PLAYERS][paydayINFO];

enum entranceINFO{
	id,//Уникальный номер входа
	description[64],//Описание
	locked,//Статус замка
	Float:enter_x,//координата входа - х
	Float:enter_y,//координата входа - y
	Float:enter_z,//координата входа - z
	Float:enter_a,//угол поворота персонажа при выходе
	Float:exit_x,//координата выхода - х
	Float:exit_y,//координата выхода - y
	Float:exit_z,//координата выхода - z
	Float:exit_a,//угол поворота персонажа при входе
	interior,//интерьер
	virtualworld,//виртуальный мир
	area_id[2],//id зоны
	pickupid[2],//ID пикапов
	Text3D:labelid[2]//ID 3Д текстов
}

new entrance[MAX_ENTRANCE][entranceINFO];
new total_entrance;//Общее количество созданных входов

enum factionINFO{
	id,
	name[32],
	Float:spawn_x,
	Float:spawn_y,
	Float:spawn_z,
	Float:spawn_a,
	interior,
	virtualworld,
	Float:clothes_x,
	Float:clothes_y,
	Float:clothes_z,
	clothes_areaid,
	skin[11],
	leader[MAX_PLAYER_NAME],
	sub_leader[MAX_PLAYER_NAME],
	sub_leader_access[3],
	entrance_id,
	pickupid,
}

new faction[MAX_FACTIONS][factionINFO];
new total_factions;
new faction_ranks[MAX_FACTIONS][MAX_RANKS_IN_FACTION][24];

enum factions{
	FACTION_BANK=0,
	FACTION_CITYHALL
}

enum subleaderaccess{
	INVITE=0,
	UNINVITE,
	GIVERANK
}

enum adminINFO{
	id,
	commands[MAX_ADMIN_COMMANDS],
	password[16]
}

new admin[MAX_PLAYERS][adminINFO];

enum admin_commandsINFO{
	ADMINS=0,
	MAKELEADER,
	ACHAT,
	FIND,
	APANEL,
	MUTE,
	BAN,
	UNBAN,
	GETIP,
	GETREGIP,
	BANIP,
	UNBANIP,
	DELACC,
	GOTO,
	GETHERE,
	GETSTATS
}

static const admin_commands[MAX_ADMIN_COMMANDS][24]={
	"/admins","/makeleader","/achat","/find","/apanel","/mute","/ban","/unban","/getip","/getregip","/banip","/unbanip","/delacc","/goto","/gethere","/getstats"
};

enum vehiclesINFO{
	mysql_id,
	id,
	model,
	owner[MAX_PLAYER_NAME],
	number_plate[16],
	Float:def_pos_x,
	Float:def_pos_y,
	Float:def_pos_z,
	Float:def_pos_a,
	Float:park_pos_x,
	Float:park_pos_y,
	Float:park_pos_z,
	Float:park_pos_a,
	bool:parkable,
	colors[2],
	Float:fuel,
	Float:mileage,
	locked
}

new vehicle[MAX_VEHICLES][vehiclesINFO];
new total_vehicles;

new timer_speed[MAX_PLAYERS];

enum transportINFO{
	id,
	model,
	name[32],
	price,
	fuel_tank
}

new transport[MAX_TRANSPORT][transportINFO];

enum business_interiorsINFO{
	id,
	description[32],
	Float:pos_x,
	Float:pos_y,
	Float:pos_z,
	Float:pos_a,
	Float:action_pos_x,
	Float:action_pos_y,
	Float:action_pos_z,
	interior,
	virtualworld,
	area_id
}

new business_interiors[MAX_BUSINESS_INTERIORS][business_interiorsINFO];
new total_business_interiors;

enum businessINFO{
	id,
	name[32],
	owner[MAX_PLAYER_NAME],
	Float:pos_x,
	Float:pos_y,
	Float:pos_z,
	Float:pos_a,
	price,
	type,
	business_interior,
	locked,
	item[MAX_ITEMS_IN_BUSINESS],
	Float:load_pos_x,
	Float:load_pos_y,
	Float:load_pos_z,
	Float:load_pos_a,
	action_pickupid,
	pickupid,
	Text3D:labelid,
	area_id,
	action_area_id
}

new business[MAX_BUSINESSES][businessINFO];
new total_businesses;

new type_of_business[1][24]={"Car Dealership"};

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
	EnableStuntBonusForAll(false);//Отключение бонусов за трюки
	LimitPlayerMarkerRadius(0.0);//Отключение маркеров на карте
	DisableInteriorEnterExits();//Отключение стандартных пикапов
	ManualVehicleEngineAndLights();//Ручное включение двигателя
	//mysql_log(LOG_ALL);//Включаем дебаг режим
	mysql_set_charset("cp1251",mysql_connection);
	//Динамические зоны
	area[BANK_CREATE_ACCOUNT]=CreateDynamicSphere(1410.7482,-1689.8737,39.6919,1.0,1,0);
	area[BANK_TILL_ONE]=CreateDynamicSphere(1409.9199,-1673.3026,39.6990,1.0,1,0);
	area[BANK_TILL_TWO]=CreateDynamicSphere(1409.9199,-1676.4822,39.6990,1.0,1,0);
	area[BANK_TILL_THREE]=CreateDynamicSphere(1409.9199,-1679.5331,39.6990,1.0,1,0);
	area[CITYHALL_INFORMATION]=CreateDynamicSphere(1489.6801,-1774.6840,1006.0600,1.0,1,0);
	area[CITYHALL_TAKE_PASSPORT]=CreateDynamicSphere(1488.3724,-1794.8727,1009.5559,1.0,1,0);
	area[BANK_PAYMENT_FOR_SERVICES]=CreateDynamicSphere(1406.3860,-1689.8207,39.6919,1.0,1,0);
	area[CITYHALL_CREATE_HOUSE]=CreateDynamicSphere(1486.1400,-1759.5725,1009.5559,1.0,1,0);
	for(new i=0; i<sizeof(lift_floor); i++){
		area[BUSINESS_CENTER_LIFT][i]=CreateDynamicSphere(lift_floor[i][0],lift_floor[i][1],lift_floor[i][2],1.0,0,0,-1);
		CreateDynamicPickup(1318,23,lift_floor[i][0],lift_floor[i][1],lift_floor[i][2]);
	}
	area[JOB_LOADER_NPC]=CreateDynamicSphere(2627.0745,-2244.0981,13.7639,1.0,0,0);
	area[JOB_LOADER_CLOTHES]=CreateDynamicSphere(2626.9939,-2239.5034,13.7450,1.0,0,0);
	//
	new Cache:cache_general=mysql_query(mysql_connection,"select*from`general`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    print(""MYSQL_DATABASE": Загрузка данных из таблицы `general`");
	    new temp;
	    temp=cache_get_field_content_int(0,"cheque",mysql_connection);
	    printf("\t- `cheque` = '%i'",temp);
	    SetSVarInt("sCheque",temp);
		temp=cache_get_field_content_int(0,"fee_for_passport",mysql_connection);
		printf("\t- `fee_for_passport` = '%i'",temp);
		SetSVarInt("sFeeForPassport",temp);
		new temp_class_cost[64];
		cache_get_field_content(0,"class_cost",temp_class_cost,mysql_connection,sizeof(temp_class_cost));
		new temp_cc[5];
		sscanf(temp_class_cost,"p<|>a<i>[5]",temp_cc);
		SetSVarInt("Houses_Class_A",temp_cc[0]);
		SetSVarInt("Houses_Class_B",temp_cc[1]);
		SetSVarInt("Houses_Class_C",temp_cc[2]);
		SetSVarInt("Houses_Class_D",temp_cc[3]);
		SetSVarInt("Houses_Class_E",temp_cc[4]);
	    printf(""MYSQL_DATABASE": Данные из таблицы `general` загружены за %ims",GetTickCount()-temp_time);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `general` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `general` не найдена!");
	        }
	    }
		return true;
	}
	cache_delete(cache_general,mysql_connection);
	new Cache:cache_entrance=mysql_query(mysql_connection,"select*from`entrance`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_ENTRANCE){
	        printf(""MYSQL_DATABASE": В таблице `entrance` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_ENTRANCE);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	        entrance[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
	        cache_get_field_content(i,"description",entrance[i][description],mysql_connection,64);
	        entrance[i][locked]=cache_get_field_content_int(i,"locked",mysql_connection);
	        new temp_entrance[64];
	        cache_get_field_content(i,"enter_pos",temp_entrance,mysql_connection,sizeof(temp_entrance));
	        sscanf(temp_entrance,"p<|>ffff",entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],entrance[i][enter_a]);
	        cache_get_field_content(i,"exit_pos",temp_entrance,mysql_connection,sizeof(temp_entrance));
	        sscanf(temp_entrance,"p<|>ffff",entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z],entrance[i][exit_a]);
	        entrance[i][interior]=cache_get_field_content_int(i,"interior",mysql_connection);
	        entrance[i][virtualworld]=cache_get_field_content_int(i,"virtualworld",mysql_connection);
	        if(!entrance[i][enter_x] || !entrance[i][enter_y] || !entrance[i][enter_z] || !entrance[i][exit_x] || !entrance[i][exit_y] || !entrance[i][exit_z]){
	            printf(""MYSQL_DATABASE": `id` = '%i' имеет недопустиые координаты: x%f|y%f|z%f|x%f|y%f|z%f",i+1,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z]);
	        }
	        else{
	            entrance[i][area_id][0]=CreateDynamicSphere(entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],2.0,0,0,-1);
	        	entrance[i][area_id][1]=CreateDynamicSphere(entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z],2.0,entrance[i][virtualworld],entrance[i][interior],-1);
	            entrance[i][pickupid][0]=CreateDynamicPickup(1318,23,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],0,0);
	            entrance[i][pickupid][1]=CreateDynamicPickup(1318,23,entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z],entrance[i][virtualworld],entrance[i][interior]);
	            new temp_enter[64];
	            format(temp_enter,sizeof(temp_enter),"%s\n%s",entrance[i][description],entrance[i][locked]?""RED"Закрыто":""GREEN"Открыто");
	            entrance[i][labelid][0]=CreateDynamic3DTextLabel(temp_enter,0xFFFFFFFF,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	            entrance[i][labelid][1]=CreateDynamic3DTextLabel("Выход",0xFFFFFFFF,entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,entrance[i][virtualworld],entrance[i][interior]);
				total_entrance++;
	        }
	    }
	    printf(""MYSQL_DATABASE": Данные из таблицы `entrance` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_entrance);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `entrance` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `entrance` не найдена!");
	        }
	    }
	}
	cache_delete(cache_entrance,mysql_connection);
	new Cache:cache_actors=mysql_query(mysql_connection,"select*from`actors`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>=MAX_ACTORS){
	        printf(""MYSQL_DATABASE": В таблице `actors` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_ENTRANCE);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	        actor[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
	        cache_get_field_content(i,"description",actor[i][description],mysql_connection,32);
	        actor[i][character]=cache_get_field_content_int(i,"character",mysql_connection);
	        new temp_actor[64];
	        cache_get_field_content(i,"pos",temp_actor,mysql_connection,sizeof(temp_actor));
	        sscanf(temp_actor,"p<|>ffff",actor[i][pos_x],actor[i][pos_y],actor[i][pos_z],actor[i][pos_a]);
	        actor[i][virtualworld]=cache_get_field_content_int(i,"virtualworld",mysql_connection);
	        actor[i][interior]=cache_get_field_content_int(i,"interior",mysql_connection);
	        cache_get_field_content(i,"anim",temp_actor,mysql_connection,sizeof(temp_actor));
	        sscanf(temp_actor,"p<|>s[24]s[24]fiiiii",actor[i][animlib],actor[i][animname],actor[i][delta],actor[i][loop],actor[i][lockx],actor[i][locky],actor[i][freeze],actor[i][time]);
	        if(!actor[i][pos_x] || !actor[i][pos_y] || !actor[i][pos_z]){
	            printf(""MYSQL_DATABASE": `id` = '%i' имеет недопустимые координаты: x%f|y%f|z%f|a%f",i+1,actor[i][pos_x],actor[i][pos_y],actor[i][pos_z],actor[i][pos_a]);
	        }
	        else{
				actor[i][createid]=CreateActor(actor[i][character],actor[i][pos_x],actor[i][pos_y],actor[i][pos_z],actor[i][pos_a]);
				SetActorVirtualWorld(actor[i][createid],actor[i][virtualworld]);
				SetActorInvulnerable(actor[i][createid],true);
				if(strlen(actor[i][animlib]) || strlen(actor[i][animname])){
					ApplyActorAnimation(actor[i][createid],actor[i][animlib],actor[i][animname],actor[i][delta],actor[i][loop],actor[i][lockx],actor[i][locky],actor[i][freeze],actor[i][time]);
				}
				actor[i][labelid]=CreateDynamic3DTextLabel(actor[i][description],0xFFFFFFFF,actor[i][pos_x],actor[i][pos_y],actor[i][pos_z],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,actor[i][virtualworld],actor[i][interior]);
				total_actors++;
	        }
	    }
	    printf(""MYSQL_DATABASE": Данные из таблицы `actors` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_actors);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `actors` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `actors` не найдена!");
	        }
	    }
	}
	cache_delete(cache_actors,mysql_connection);
	new Cache:cache_house_interiors=mysql_query(mysql_connection,"select*from`house_interiors`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_HOUSE_INTERIORS){
	        printf(""MYSQL_DATABASE": В таблице `house_interiors` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_HOUSE_INTERIORS);
		}
		for(new i=0; i<cache_get_row_count(mysql_connection); i++){
		    house_interiors[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
		    cache_get_field_content(i,"description",house_interiors[i][description],mysql_connection,32);
		    new temp_pos[64];
		    cache_get_field_content(i,"pos",temp_pos,mysql_connection,sizeof(temp_pos));
			sscanf(temp_pos,"p<|>ffff",house_interiors[i][pos_x],house_interiors[i][pos_y],house_interiors[i][pos_z],house_interiors[i][pos_a]);
			house_interiors[i][interior]=cache_get_field_content_int(i,"interior",mysql_connection);
			house_interiors[i][price]=cache_get_field_content_int(i,"price",mysql_connection);
			house_interiors[i][area_id]=CreateDynamicSphere(house_interiors[i][pos_x],house_interiors[i][pos_y],house_interiors[i][pos_z],1.5,-1,house_interiors[i][interior],-1);
			total_house_interiors++;
		}
		printf(""MYSQL_DATABASE": Данные из таблицы `house_interiors` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_house_interiors);
	}
    else{
        switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `house_interiors` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `house_interiors` не найдена!");
	        }
	    }
    }
    cache_delete(cache_house_interiors,mysql_connection);
	new Cache:cache_houses=mysql_query(mysql_connection,"select*from`houses`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>=MAX_HOUSES){
            printf(""MYSQL_DATABASE": В таблице `houses` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_HOUSES);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	        house[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
	        cache_get_field_content(i,"owner",house[i][owner],mysql_connection,MAX_PLAYER_NAME);
	        new temp_pos[64];
	        cache_get_field_content(i,"enter_pos",temp_pos,mysql_connection,sizeof(temp_pos));
	        sscanf(temp_pos,"p<|>ffff",house[i][enter_x],house[i][enter_y],house[i][enter_z],house[i][enter_a]);
	        house[i][house_interior]=cache_get_field_content_int(i,"house_interior",mysql_connection);
	        house[i][locked]=cache_get_field_content_int(i,"locked",mysql_connection);
	        house[i][cost]=cache_get_field_content_int(i,"cost",mysql_connection);
	        house[i][confirmed]=cache_get_field_content_int(i,"confirmed",mysql_connection);
	        house[i][class]=cache_get_field_content_int(i,"class",mysql_connection);
	        if(!house[i][enter_x]||!house[i][enter_y]||!house[i][enter_z]||!house[i][house_interior]){
                printf(""MYSQL_DATABASE": `id` = '%i' имеет недопустимые координаты: x%f|y%f|z%f|hi%i",i+1,house[i][enter_x],house[i][enter_y],house[i][enter_z],house[i][house_interior]);
	        }
	        else{
				new string[8-2+3];
				format(string,sizeof(string),"H-ID %i",house[i][id]);
				house[i][area_id]=CreateDynamicSphere(house[i][enter_x],house[i][enter_y],house[i][enter_z],1.0,0,0,-1);
				house[i][labelid]=CreateDynamic3DTextLabel(string,0xFFFFFFFF,house[i][enter_x],house[i][enter_y],house[i][enter_z],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
				if(!strcmp(house[i][owner],"-")){
					house[i][pickupid]=CreateDynamicPickup(1273,23,house[i][enter_x],house[i][enter_y],house[i][enter_z],0,0);
				}
				else if(strlen(house[i][owner])>=MIN_PLAYER_NAME_LEN){
				    house[i][pickupid]=CreateDynamicPickup(1272,23,house[i][enter_x],house[i][enter_y],house[i][enter_z],0,0);
				}
				total_houses++;
	        }
	    }
	    printf(""MYSQL_DATABASE": Данные из таблицы `houses` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_houses);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `houses` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `houses` не найдена!");
	        }
	    }
	}
	cache_delete(cache_houses,mysql_connection);
	new Cache:cache_factions=mysql_query(mysql_connection,"select*from`factions`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_FACTIONS){
            printf(""MYSQL_DATABASE": В таблице `factions` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_FACTIONS);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	        faction[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
	        cache_get_field_content(i,"name",faction[i][name],mysql_connection,32);
	        new temp_spawn[64];
	        cache_get_field_content(i,"spawn",temp_spawn,mysql_connection,sizeof(temp_spawn));
	        sscanf(temp_spawn,"p<|>ffffii",faction[i][spawn_x],faction[i][spawn_y],faction[i][spawn_z],faction[i][spawn_a],faction[i][virtualworld],faction[i][interior]);
	        cache_get_field_content(i,"clothes",temp_spawn,mysql_connection,sizeof(temp_spawn));
	        sscanf(temp_spawn,"p<|>fff",faction[i][clothes_x],faction[i][clothes_y],faction[i][clothes_z]);
	        cache_get_field_content(i,"skin",temp_spawn,mysql_connection,sizeof(temp_spawn));
	        sscanf(temp_spawn,"p<|>a<i>[11]",faction[i][skin]);
	        new temp_rank[24*MAX_RANKS_IN_FACTION];
	        cache_get_field_content(i,"rank",temp_rank,mysql_connection,sizeof(temp_rank));
	        sscanf(temp_rank,"p<|>s[24]s[24]s[24]s[24]s[24]s[24]s[24]s[24]s[24]s[24]s[24]",faction_ranks[i][0],faction_ranks[i][1],faction_ranks[i][2],faction_ranks[i][3],faction_ranks[i][4],faction_ranks[i][5],faction_ranks[i][6],faction_ranks[i][7],faction_ranks[i][8],faction_ranks[i][9],faction_ranks[i][10]);
	        cache_get_field_content(i,"leader",faction[i][leader],mysql_connection,MAX_PLAYER_NAME);
	        cache_get_field_content(i,"sub_leader",faction[i][sub_leader],mysql_connection,MAX_PLAYER_NAME);
	        new temp_access[24];
	        cache_get_field_content(i,"sub_leader_access",temp_access,mysql_connection,sizeof(temp_access));
	        sscanf(temp_access,"p<|>a<i>[3]",faction[i][sub_leader_access]);
	        faction[i][entrance_id]=cache_get_field_content_int(i,"entrance_id",mysql_connection);
			if(!faction[i][spawn_x] || !faction[i][spawn_y] || !faction[i][spawn_z] || !faction[i][spawn_a]){
                printf(""MYSQL_DATABASE": `id` = '%i' имеет недопустимые координаты: x%f|y%f|z%f|a%f",i+1,faction[i][spawn_x],faction[i][spawn_y],faction[i][spawn_z],faction[i][spawn_a]);
			}
			else{
			    if(!faction[i][clothes_x] || !faction[i][clothes_y] || !faction[i][clothes_z]){
                    printf(""MYSQL_DATABASE": `id` = '%i' имеет недопустимые координаты: x%f|y%f|z%f",i+1,faction[i][clothes_x],faction[i][clothes_y],faction[i][clothes_z]);
			    }
			    else{
			        new temp_var;
			        for(new j=0; j<11; j++){
			            if(!faction[i][skin][j] || faction[i][skin][j]>311){
							printf(""MYSQL_DATABASE": `id` = '%i' имеет недопустимые значения: 0-%i|1-%i|2-%i|3-%i|4-%i|5-%i|6-%i|7-%i|8-%i|9-%i|10-%i",i+1,faction[i][skin][0],faction[i][skin][1],faction[i][skin][2],faction[i][skin][3],faction[i][skin][4],faction[i][skin][5],faction[i][skin][6],faction[i][skin][7],faction[i][skin][8],faction[i][skin][9],faction[i][skin][10]);
							temp_var++;
							break;
			            }
			        }
			        if(!temp_var){
			            faction[i][clothes_areaid]=CreateDynamicSphere(faction[i][clothes_x],faction[i][clothes_y],faction[i][clothes_z],1.5,faction[i][virtualworld],faction[i][interior],-1);
						faction[i][pickupid]=CreateDynamicPickup(1275,23,faction[i][clothes_x],faction[i][clothes_y],faction[i][clothes_z],faction[i][virtualworld],faction[i][interior]);
				        total_factions++;
			        }
			    }
			}
	    }
        printf(""MYSQL_DATABASE": Данные из таблицы `factions` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_factions);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `factions` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `factions` не найдена!");
	        }
	    }
	}
	cache_delete(cache_factions,mysql_connection);
	new Cache:cache_transport=mysql_query(mysql_connection,"select*from`transport`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_TRANSPORT){
            printf(""MYSQL_DATABASE": В таблице `transport` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_TRANSPORT);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	        transport[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
	        transport[i][model]=cache_get_field_content_int(i,"model",mysql_connection);
	        cache_get_field_content(i,"name",transport[i][name],mysql_connection,32);
	        transport[i][price]=cache_get_field_content_int(i,"price",mysql_connection);
	        transport[i][fuel_tank]=cache_get_field_content_int(i,"fuel_tank",mysql_connection);
	    }
	    printf(""MYSQL_DATABASE": Данные из таблицы `transport` загружены за %ims (%i шт)",GetTickCount()-temp_time,cache_get_row_count(mysql_connection));
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `transport` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `transport` не найдена!");
	        }
	    }
	}
	cache_delete(cache_transport,mysql_connection);
	new Cache:cache_vehicles=mysql_query(mysql_connection,"select*from`vehicles`where`owner`='The State'");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_VEHICLES){
            printf(""MYSQL_DATABASE": В таблице `vehicles` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_VEHICLES);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
		    vehicle[i][mysql_id]=cache_get_field_content_int(i,"id",mysql_connection);
	        vehicle[i][model]=cache_get_field_content_int(i,"model",mysql_connection);
	        cache_get_field_content(i,"owner",vehicle[i][owner],mysql_connection,MAX_PLAYER_NAME);
	        cache_get_field_content(i,"number_plate",vehicle[i][number_plate],mysql_connection,MAX_PLAYER_NAME);
	        new temp_pos[64];
	        cache_get_field_content(i,"def_pos",temp_pos,mysql_connection,sizeof(temp_pos));
	        sscanf(temp_pos,"p<|>ffff",vehicle[i][def_pos_x],vehicle[i][def_pos_y],vehicle[i][def_pos_z],vehicle[i][def_pos_a]);
	        cache_get_field_content(i,"park_pos",temp_pos,mysql_connection,sizeof(temp_pos));
	        sscanf(temp_pos,"p<|>ffff",vehicle[i][park_pos_x],vehicle[i][park_pos_y],vehicle[i][park_pos_z],vehicle[i][park_pos_a]);
			new temp_parkable=cache_get_field_content_int(i,"parkable",mysql_connection);
			vehicle[i][parkable]=bool:temp_parkable;
			new temp_colors[8];
			cache_get_field_content(i,"color",temp_colors,mysql_connection,sizeof(temp_colors));
			sscanf(temp_colors,"p<|>a<i>[2]",vehicle[i][colors]);
			vehicle[i][fuel]=cache_get_field_content_float(i,"fuel",mysql_connection);
			vehicle[i][mileage]=cache_get_field_content_float(i,"mileage",mysql_connection);
			vehicle[i][locked]=cache_get_field_content_int(i,"locked",mysql_connection);
			if(!strcmp(vehicle[i][owner],"The State")){
			    if(vehicle[i][locked]){
			        vehicle[i][locked]=0;
			    }
			    if(vehicle[i][fuel]<=0.0 || vehicle[i][fuel] > float(transport[vehicle[i][model]-400][fuel_tank])){
			        vehicle[i][fuel]=float(transport[vehicle[i][model]-400][fuel_tank]);
			    }
				if(!vehicle[i][park_pos_x] || !vehicle[i][park_pos_y] || !vehicle[i][park_pos_z]){
					vehicle[i][id]=AddStaticVehicleEx(vehicle[i][model],vehicle[i][def_pos_x],vehicle[i][def_pos_y],vehicle[i][def_pos_z],vehicle[i][def_pos_a],vehicle[i][colors][0],vehicle[i][colors][1],300);
				}
				else if(!(!vehicle[i][def_pos_x] || !vehicle[i][def_pos_y] || !vehicle[i][def_pos_z]) && (vehicle[i][park_pos_x] || vehicle[i][park_pos_y] || vehicle[i][park_pos_z])){
				    vehicle[i][id]=AddStaticVehicleEx(vehicle[i][model],vehicle[i][park_pos_x],vehicle[i][park_pos_y],vehicle[i][park_pos_z],vehicle[i][park_pos_a],vehicle[i][colors][0],vehicle[i][colors][1],300);
				}
			}
			else{
			    if(!vehicle[i][park_pos_x] || !vehicle[i][park_pos_y] || !vehicle[i][park_pos_z]){
					vehicle[i][id]=AddStaticVehicleEx(vehicle[i][model],vehicle[i][def_pos_x],vehicle[i][def_pos_y],vehicle[i][def_pos_z],vehicle[i][def_pos_a],vehicle[i][colors][0],vehicle[i][colors][1],999999);
				}
				else if(!(!vehicle[i][def_pos_x] || !vehicle[i][def_pos_y] || !vehicle[i][def_pos_z]) && (vehicle[i][park_pos_x] || vehicle[i][park_pos_y] || vehicle[i][park_pos_z])){
				    vehicle[i][id]=AddStaticVehicleEx(vehicle[i][model],vehicle[i][park_pos_x],vehicle[i][park_pos_y],vehicle[i][park_pos_z],vehicle[i][park_pos_a],vehicle[i][colors][0],vehicle[i][colors][1],999999);
				}
			}
			ChangeVehicleColor(vehicle[i][id],vehicle[i][colors][0],vehicle[i][colors][1]);
			SetVehicleNumberPlate(vehicle[i][id],vehicle[i][number_plate]);
		    SetVehicleToRespawn(vehicle[i][id]);
		    if(IsValidVehicle(vehicle[i][model])){
		    	SetVehicleParamsEx(vehicle[i][id],0,0,0,vehicle[i][locked],0,0,0);
			}
			else{
			    SetVehicleParamsEx(vehicle[i][id],1,0,0,vehicle[i][locked],0,0,0);
			}
		    total_vehicles++;
	    }
	    printf(""MYSQL_DATABASE": Данные из таблицы `vehicles` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_vehicles);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `vehicles` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `vehicles` не найдена!");
	        }
	    }
	}
	cache_delete(cache_vehicles,mysql_connection);
	new Cache:cache_business_interiors=mysql_query(mysql_connection,"select*from`business_interiors`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_BUSINESS_INTERIORS){
            printf(""MYSQL_DATABASE": В таблице `business_interiors` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_BUSINESS_INTERIORS);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	    	business_interiors[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
		    cache_get_field_content(i,"description",business_interiors[i][description],mysql_connection,32);
		    new temp_pos[64];
		    cache_get_field_content(i,"pos",temp_pos,mysql_connection,sizeof(temp_pos));
			sscanf(temp_pos,"p<|>ffff",business_interiors[i][pos_x],business_interiors[i][pos_y],business_interiors[i][pos_z],business_interiors[i][pos_a]);
			business_interiors[i][interior]=cache_get_field_content_int(i,"interior",mysql_connection);
			cache_get_field_content(i,"action_pos",temp_pos,mysql_connection,sizeof(temp_pos));
			sscanf(temp_pos,"p<|>fff",business_interiors[i][action_pos_x],business_interiors[i][action_pos_y],business_interiors[i][action_pos_z]);
			business_interiors[i][area_id]=CreateDynamicSphere(business_interiors[i][pos_x],business_interiors[i][pos_y],business_interiors[i][pos_z],1.5,-1,business_interiors[i][interior],-1);
	        total_business_interiors++;
	    }
	    printf(""MYSQL_DATABASE": Данные из таблицы `business_interiors` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_business_interiors);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `business_interiors` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `business_interiors` не найдена!");
	        }
	    }
	}
	cache_delete(cache_business_interiors,mysql_connection);
	new Cache:cache_businesses=mysql_query(mysql_connection,"select*from`businesses`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_BUSINESSES){
            printf(""MYSQL_DATABASE": В таблице `businesses` больше значений чем в константе (%i/%i)",cache_get_row_count(mysql_connection),MAX_BUSINESSES);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	        business[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
	        cache_get_field_content(i,"name",business[i][name],mysql_connection,MAX_PLAYER_NAME);
	        cache_get_field_content(i,"owner",business[i][owner],mysql_connection,MAX_PLAYER_NAME);
	        new temp_pos[64];
	        cache_get_field_content(i,"pos",temp_pos,mysql_connection,sizeof(temp_pos));
	        sscanf(temp_pos,"p<|>ffff",business[i][pos_x],business[i][pos_y],business[i][pos_z],business[i][pos_a]);
	        business[i][business_interior]=cache_get_field_content_int(i,"business_interior",mysql_connection);
	        business[i][price]=cache_get_field_content_int(i,"price",mysql_connection);
	        business[i][type]=cache_get_field_content_int(i,"type",mysql_connection);
	        business[i][locked]=cache_get_field_content_int(i,"locked",mysql_connection);
	        new temp_items[256];
	        cache_get_field_content(i,"items",temp_items,mysql_connection,sizeof(temp_items));
	        sscanf(temp_items,"p<|>a<i>[32]",business[i][item]);
	        cache_get_field_content(i,"load_pos",temp_pos,mysql_connection,sizeof(temp_pos));
	        sscanf(temp_pos,"p<|>ffff",business[i][load_pos_x],business[i][load_pos_y],business[i][load_pos_z],business[i][load_pos_a]);
	        if(!business[i][pos_x]||!business[i][pos_y]||!business[i][pos_z]||!business[i][business_interior]){
                printf(""MYSQL_DATABASE": `id` = '%i' имеет недопустимые координаты: x%f|y%f|z%f|bi%i",i+1,business[i][pos_x],business[i][pos_y],business[i][pos_z],business[i][business_interior]);
	        }
	        else{
				new string[8-2+3];
				format(string,sizeof(string),"B-ID %i",business[i][id]);
                business[i][labelid]=CreateDynamic3DTextLabel(string,0xFFFFFFFF,business[i][pos_x],business[i][pos_y],business[i][pos_z],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
				business[i][area_id]=CreateDynamicSphere(business[i][pos_x],business[i][pos_y],business[i][pos_z],1.0,0,0,-1);
				new temp_interiorid=business[i][business_interior];
				business[i][action_area_id]=CreateDynamicSphere(business_interiors[temp_interiorid-1][action_pos_x],business_interiors[temp_interiorid-1][action_pos_y],business_interiors[temp_interiorid-1][action_pos_z],1.0,i+1,business_interiors[temp_interiorid-1][interior],-1);
				business[i][action_pickupid]=CreateDynamicPickup(1239,23,business_interiors[temp_interiorid-1][action_pos_x],business_interiors[temp_interiorid-1][action_pos_y],business_interiors[temp_interiorid-1][action_pos_z],i+1,business_interiors[temp_interiorid-1][interior]);
				if(!strcmp(business[i][owner],"-")){
					business[i][pickupid]=CreateDynamicPickup(1274,23,business[i][pos_x],business[i][pos_y],business[i][pos_z],0,0);
				}
				else if(strlen(business[i][owner])>=MIN_PLAYER_NAME_LEN){
				    business[i][pickupid]=CreateDynamicPickup(19132,23,business[i][pos_x],business[i][pos_y],business[i][pos_z],0,0);
				}
				total_businesses++;
	        }
	    }
	    printf(""MYSQL_DATABASE": Данные из таблицы `businesses` загружены за %ims (%i шт)",GetTickCount()-temp_time,total_businesses);
	}
	else{
	    switch(mysql_errno(mysql_connection)){
	        case 0:{
	            print(""MYSQL_DATABASE": Данные в таблице `businesses` не найдены!");
	        }
	        case 1146:{
	            print(""MYSQL_DATABASE": Таблица `businesses` не найдена!");
	        }
	    }
	}
	cache_delete(cache_businesses,mysql_connection);
//	mysql_log(LOG_NONE);
	SetGameModeText("DSHRK v0.034.r3");//Ставим название мода для клиента
	SendRconCommand("hostname DOSHIRAK PROJECT");//Ставим название сервера для клиента через RCON
	SendRconCommand("weburl vk.com/d1maz.community");
	SendRconCommand("language Russian");
	SendRconCommand("mapname San Andreas");
	timer_general=SetTimer("general_timer",1000,false);
	timer_minute=SetTimer("minute_timer",60000,false);
	gettime(global__time_hour,_,_);
	SetWorldTime(global__time_hour);
	LoadObjects();
	Load3DTexts();
	LoadPickups();
	return true;
}

public OnPlayerRequestClass(playerid,classid){
	#pragma unused classid
    new query[99-2+MAX_PLAYER_NAME];// Объявляем переменную для запроса
	new temp_ip[16];
	GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
    mysql_format(mysql_connection,query,sizeof(query),"select`adminname`from`banip`where`ip`='%e'limit 1",temp_ip);
    new Cache:cache_banip=mysql_query(mysql_connection,query);
    if(cache_get_row_count(mysql_connection)){
        new temp_adminname[MAX_PLAYER_NAME];
		cache_get_field_content(0,"adminname",temp_adminname,mysql_connection,sizeof(temp_adminname));
		new string[66-2-2+16+MAX_PLAYER_NAME];
		format(string,sizeof(string),"\n"WHITE"IP адрес - "BLUE"%s\n"WHITE"Администратор - "BLUE"%s\n\n",temp_ip,temp_adminname);
		ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ваш IP адрес заблокирован",string,"Закрыть","");
		SetTimerEx("kick_player",250,false,"i",playerid);
        return true;
    }
    cache_delete(cache_banip,mysql_connection);
    mysql_format(mysql_connection,query,sizeof(query),"select`reason`,`adminname`,`bantime`,`expiretime`from`ban`where`name`='%e'and`unbanned`='0'limit 1",player[playerid][name]);
	new Cache:cache_ban=mysql_query(mysql_connection,query);
	if(cache_get_row_count(mysql_connection)){
		new temp_reason[32],temp_adminname[MAX_PLAYER_NAME],temp_bantime,temp_expiretime;
		cache_get_field_content(0,"reason",temp_reason,mysql_connection,sizeof(temp_reason));
		cache_get_field_content(0,"adminname",temp_adminname,mysql_connection,sizeof(temp_adminname));
		temp_bantime=cache_get_field_content_int(0,"bantime",mysql_connection);
		temp_expiretime=cache_get_field_content_int(0,"expiretime",mysql_connection);
		new temp_time=gettime()+(3600*3);
		if(temp_expiretime>temp_time){
		    new string[166-2-2-2-2-2+24+24+MAX_PLAYER_NAME+32+MAX_PLAYER_NAME];
		    format(string,sizeof(string),"\n"BLUE"%s\n\n"WHITE"Дата блокировки - "BLUE"%s\n"WHITE"Дата разблокировки - "BLUE"%s\n\n"WHITE"Администратор - "BLUE"%s\n\n",player[playerid][name],gettimestamp(temp_bantime,1),gettimestamp(temp_expiretime,1),temp_adminname);
		    if(strcmp(temp_reason,"-")){
		        new temp_string[33-2+32];
		        format(string,sizeof(string),""WHITE"Причина - "BLUE"%s\n\n",temp_reason);
		        strcat(string,temp_string);
		    }
		    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ваш аккаунт заблокирован",string,"Закрыть","");
		    SetTimerEx("kick_player",250,false,"i",playerid);
		    return true;
		}
		else{
		    mysql_format(mysql_connection,query,sizeof(query),"update`ban`set`unbanned`='1'where`name`='%e'limit 1",player[playerid][name]);
		    mysql_query(mysql_connection,query,false);
		    SendClientMessage(playerid,C_RED,"[Информация] Ваш аккаунт был разблокирован!");
		}
	}
	cache_delete(cache_ban,mysql_connection);
	mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'limit 1",player[playerid][name]);// Форматируем "безопасный" запрос в базу данных
	new Cache:cache_users=mysql_query(mysql_connection,query);// Отправляем запрос в базу данных
	LoadPlayerTextDraw(playerid);
	if(cache_get_row_count(mysql_connection)){// Если в базе есть больше нуля полей с одинаковым никнеймом
		PlayerTextDrawSetString(playerid,td_authorization[playerid][TD_AUTH_NICKNAME],player[playerid][name]);
		for(new i=0; i<sizeof(td_authorization[]); i++){
		    PlayerTextDrawShow(playerid,td_authorization[playerid][i]);
		}
		SelectTextDraw(playerid,C_BLUE);
		SetPVarInt(playerid,"RequestStatus",2);
	}
	else{// Если в базе нет ни одного поля в никнеймом
		PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_NICKNAME],player[playerid][name]);
		PlayerTextDrawSetPreviewModel(playerid, td_register[playerid][TD_REG_CHARACTER], reg_characters[0][0][0]);
		SetPVarInt(playerid,"RegGender",1);
		SetPVarInt(playerid,"RegOrigin",1);
		SetPVarInt(playerid,"RegCharacter",1);
		for(new i=0; i<sizeof(td_register[]); i++){
		    PlayerTextDrawShow(playerid,td_register[playerid][i]);
		}
		SelectTextDraw(playerid,C_BLUE);
		SetPVarInt(playerid,"RequestStatus",1);
	}
	cache_delete(cache_users,mysql_connection);
	TogglePlayerSpectating(playerid,true);//Переводим игрока в режим слежения
	LoadTextDraw();
	TextDrawShowForPlayer(playerid,td_logo);
	return true;
}

public OnPlayerConnect(playerid){// Подключаемся к серверу
	new temp_ip[16];//Создаём переменную для записи IP адреса
	GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));//Записываем IP адрес в переменную
	for(new i=0; i!=MAX_PLAYERS; i++){//Проходим по циклу игроков, иначе 1000 итераций
		if(!strcmp(check_ip_for_reconnect[i],temp_ip)){//Если одна из итераций в переменной совпала с глобальной переменной
		    if(gettime()-check_ip_for_reconnect_time[i]<20){//И если полученное время оказалось меньше 20-ти, то...
		        SendClientMessage(playerid,C_RED,"[Информация] Вы были кикнуты сервером! Причина: Anti Reconnect");
		        SetTimerEx("kick_player",250,false,"i",playerid);//Кикаем игрока
		        break;//Выходим из функции
		    }
		}
	}
	new temp_hour;
	gettime(temp_hour,_,_);
	switch(temp_hour){
	    case 0..5:{
	        GameTextForPlayer(playerid,"~w~good night",3000,1);
	    }
	    case 6..11:{
	        GameTextForPlayer(playerid,"~w~good morning",3000,1);
	    }
	    case 12..17:{
	        GameTextForPlayer(playerid,"~w~good afternoon",3000,1);
	    }
		case 18..23:{
		    GameTextForPlayer(playerid,"~w~good evening",3000,1);
		}
	}
	SetPVarInt(playerid,"PasswordAttempts",3);
	GetPlayerIp(playerid,check_ip_for_reconnect[playerid],16);//Записываем IP адрес в глобальную переменную
	GetPlayerName(playerid,player[playerid][name],MAX_PLAYER_NAME);//Запишем никнейм игрока в переменную
	RemovePlayerObjects(playerid);//Убираем объекты для игрока (doshirak\objects)
	return true;
}

public OnPlayerDisconnect(playerid,reason){
	#pragma unused reason
	if(GetPVarInt(playerid,"PlayerLogged")){
		new temp_payday[24];
		format(temp_payday,sizeof(temp_payday),"%i|%i|%i",payday[playerid][time],payday[playerid][salary],payday[playerid][taken]);
	    new query[56-2-2-2+sizeof(temp_payday)+3+11];
	    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`payday`='%e',`mute`='%i'where`id`='%i'",temp_payday,player[playerid][mute],player[playerid][id]);
	    mysql_query(mysql_connection,query,false);
	    if(attached_3dtext[playerid]){
	        Delete3DTextLabel(attach_3dtext_labelid[playerid]);
	        attached_3dtext[playerid]=false;
	    }
	    for(new UINFO:i; i<UINFO; i++){
	        player[playerid][i]=0;
	    }
		for(new adminINFO:i; i<adminINFO; i++){
		    admin[playerid][i]=0;
		}
		for(new i=0; i<MAX_OWNED_HOUSES; i++){
		    owned_house_id[playerid][i]=0;
		}
		for(new i=0; i<MAX_OWNED_BUSINESSES; i++){
		    owned_business_id[playerid][i]=0;
		}
		for(new i=0; i<MAX_OWNED_VEHICLES; i++){
		    if(owned_vehicle_id[playerid][i]<0){
		        continue;
		    }
		    DestroyVehicle(vehicle[owned_vehicle_id[playerid][i]][id]);
		    owned_vehicle_id[playerid][i]=-1;
		}
	}
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
				new sscanf_password[MAX_PASSWORD_LEN];// Объявляем переменные
				if(sscanf(inputtext,"s[128]",sscanf_password)){// Если все ячейки равны нулю, то условие пройдёт в тело
				    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Введите ваш будущий пароль\n\n","Выбрать","Закрыть");
				    return true;// Выходим из функции
				}
                if(!regex_match(sscanf_password,"[a-zA-Z0-9]{4,24}+")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело
                    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"Регистрация","\n"RED"Пароль не подходит по параметрам!\n\n"GREY"Допустимые символы - Aa-Zz, 0-9\nДлина пароля - 4-24 символа\n\n"WHITE"Введите ваш будущий пароль\n\n","Выбрать","Закрыть");
                    return true;// Выходим из функции
                }
				SetPVarString(playerid,"RegPassword",sscanf_password);
				new temp_string[MAX_PASSWORD_LEN];
				for(new i=0,j=strlen(sscanf_password); i<j; i++){
				    strcat(temp_string,"x");
				}
				PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_PASSWORD],temp_string);
	        }
	    }
	    case dRegistrationEmail:{//Если dialogid равен двойке, то переходим в тело
	        if(response){//Если ответ от диалога равен истинее (левая кнопка), то...
	            new sscanf_email[MAX_EMAIL_LEN];//Объявляем переменную для записи эл. почты
				if(sscanf(inputtext,"s[128]",sscanf_email)){//Если поле ввода оказалось пустым, то...
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Введите ваш адрес эл. почты\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
				    return true;//Выходим из функции
				}
				if(!regex_match(sscanf_email,"[a-zA-Z0-9_\\.-]{1,22}+@([a-zA-Z0-9\\-]{2,8}+\\.)+[a-zA-Z]{2,4}")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n"RED"Эл. почта не подходит по параметрам!\n\n"GREY"Допустимые символы - Aa-Zz, 0-9, @, -, .\nДлина эл. почты - 10-32 символов\n\n"WHITE"Введите ваш адрес эл. почты\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
				    return true;//Выходим из функции
				}
				new query[35-2+MAX_EMAIL_LEN];//Объявляем переменную для записи запроса в БД
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`email`='%e'",sscanf_email);//Форматируем запрос с возвращением ответа
				new Cache:cache_users=mysql_query(mysql_connection,query);// Отправляем запрос в БД
				if(cache_get_row_count(mysql_connection)){// Если ответ равен истинне, либо больше, то...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n"RED"Указанный адрес эл. почты уже зарегистрирован в системе!\n\n"WHITE"Введите ваш адрес эл. почты\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
					//Показываем тот же диалог
				}
				else{//Если ответ равен лжи, либо нулю, то...
				    SetPVarString(playerid,"RegEmail",sscanf_email);//Записываем введенный выше текст в переменную
					PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_EMAIL],sscanf_email);
				}
				cache_delete(cache_users,mysql_connection);
			}
	    }
		case dRegistrationReferal:{// Если dialogid равен тройке, то...
		    if(response){//Если ответ диалога равен истине (левая кнопка), то...
		        new sscanf_referal_name[MAX_PROMOCODE_LEN];//Объявляем переменную для записи рефера/промокода
		        if(sscanf(inputtext,"s[128]",sscanf_referal_name)){//Если поле ввода оказалось пустым, то...
		            ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Вы можете ввести никнейм или промокод, если пришли по приглашению\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
		            return true;//Выходим из функции
		        }
				new query[53-2+MAX_PROMOCODE_LEN];//Объявляем переменную для форматирования запроса
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",sscanf_referal_name);//Форматируем запрос с возвращением ответа
				new Cache:cache_users=mysql_query(mysql_connection,query);//Отправляем запрос в БД
				if(cache_get_row_count(mysql_connection)){// Если ответ равен истине, либо больше, то...
				    new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'and`reg_ip`='%e'",sscanf_referal_name,temp_ip);
					new Cache:cache__users=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"RED"Вы не можете указать этот никнейм!\n\n"WHITE"Вы можете ввести никнейм или промокод, если пришли по приглашению\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
					    return true;
					}
					cache_delete(cache__users,mysql_connection);
					SetPVarString(playerid,"RegReferrer",sscanf_referal_name);
					PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_REFERRER],sscanf_referal_name);
				    SendClientMessage(playerid,C_BLUE,"[Информация] Вы были приглашены игроком по никнейму!");//Выводим сообщение с текстом о типе рефера
					//Выводим диалог с вводом возраста персонажа
				}
				else{//Если ответ равен лжи, то...
				    mysql_format(mysql_connection,query,sizeof(query),"select`creator`from`promocodes`where`promocode`='%e'",sscanf_referal_name);//Форматируем запрос с возвращением ответа
				    new Cache:cache_promocodes=mysql_query(mysql_connection,query);// Отправляем запрос
				    if(cache_get_row_count(mysql_connection)){// Если ответ равен истине, либо больше, то...
				        new temp_ip[16],temp_name[MAX_PLAYER_NAME];
						GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
				        cache_get_field_content(0,"creator",temp_name,mysql_connection,sizeof(temp_name));
				        mysql_format(mysql_connection,query,sizeof(query),"select`id`from`users`where`name`='%e'and`reg_ip`='%e'",temp_name,temp_ip);
				        mysql_query(mysql_connection,query);
				        if(cache_get_row_count(mysql_connection)){
				            ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"RED"Вы не можете указать этот промокод!\n\n"WHITE"Вы можете ввести никнейм или промокод, если пришли по приглашению\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
						    return true;
				        }
				        if(!regex_match(sscanf_referal_name,"[a-zA-Z0-9_#@!-]{4,32}+")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело ИЛИ длина текста меньше n ИЛИ длина текста больше n
	                        ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"RED"Промокод не подходит по параметрам!\n\n"GREY"Доступные символы - Aa-Zz, 0-9, _, #, @, !, -.\nДлина промокода - 4-32 символа\n\n"WHITE"Вы можете ввести никнейм или промокод, если пришли по приглашению\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
		          		    return true;//Выходим из функции
		          		}
						SetPVarString(playerid,"RegReferrer",sscanf_referal_name);
						SendClientMessage(playerid,C_BLUE,"[Информация] Вы были приглашены игроком по промокоду!");//Выводим сообщение с текстом о типе рефера
						PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_REFERRER],sscanf_referal_name);
				    }
				    else{//Если ответ равен лжи, то...
                        ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n\n"RED"Промокод/Никнейм игрока не зарегистрирован в системе!\n\n"WHITE"Вы можете ввести никнейм или промокод, если пришли по приглашению\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
				    }
				    cache_delete(cache_promocodes,mysql_connection);
				}
				cache_delete(cache_users,mysql_connection);
		    }
		}
		case dRegistrationAge:{
		    if(response){
		        new sscanf_age;
		        if(sscanf(inputtext,"i",sscanf_age)){
		            ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Введите возраст вашего персонажа\n"GREY"Пример: (16 - 60)\n\n","Выбрать","Закрыть");
		            return true;
		        }
				if(sscanf_age<16 || sscanf_age>60){
				    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Введите возраст вашего персонажа\n"RED"Пример: (16 - 60)\n\n","Выбрать","Закрыть");
				    return true;
				}
				SetPVarInt(playerid,"RegAge",sscanf_age);
				new temp_string[3];
				format(temp_string,sizeof(temp_string),"%i",sscanf_age);
				PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_AGE],temp_string);
			}
		}
		case dAuthorization:{
		    if(response){
		        new sscanf_password[MAX_PASSWORD_LEN];
                if(sscanf(inputtext,"s[128]",sscanf_password)){
                    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_PASSWORD,"Авторизация","\n"WHITE"Введите пароль для авторизации\n\n","Выбрать","Закрыть");
                    return true;
                }
                if(!regex_match(sscanf_password,"[a-zA-Z0-9]{4,24}+")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то услоавие пройдёт в тело
                    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_PASSWORD,"Авторизация","\n"RED"Пароль не подходит по параметрам!\n\n"GREY"Доступные символы - Aa-Zz, 0-9\nДлина пароля - 4-24 символа\n\n"WHITE"Введите пароль для авторизации\n\n","Выбрать","Закрыть");
                    return true;// Выходим из функции
                }
                SetPVarString(playerid,"AuthPassword",sscanf_password);
				new temp_string[MAX_PASSWORD_LEN];
				for(new i=0,j=strlen(sscanf_password); i<j; i++){
				    strcat(temp_string,"x");
				}
				PlayerTextDrawSetString(playerid,td_authorization[playerid][TD_AUTH_PASSWORD],temp_string);
		    }
		}
		case dAuthorizationSpawn:{
		    if(response){
		        switch(listitem){
		            case 0:{
		                SetPVarInt(playerid,"PlayerLogged",1);
						TogglePlayerSpectating(playerid,false);
						SetPVarInt(playerid,"SpawnStatus",1);
						SpawnPlayer(playerid);
		            }
		            case 1:{
		                if(!player[playerid][faction_id]){
		                    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться во фракции!");
		                    new string[61+25+25];
							format(string,sizeof(string),"[0] Обычный спавн\n[1] Спавн фракции %s\n[2] Спавн в доме %s",(player[playerid][faction_id]?""GREEN"[ доступно ]":""RED"[ не доступно ]"),(owned_house_id[playerid][0]?""GREEN"[ доступно ]":""RED"[ не доступно ]"));
							ShowPlayerDialog(playerid,dAuthorizationSpawn,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","");
		                    return true;
		                }
		                SetPVarInt(playerid,"PlayerLogged",1);
						TogglePlayerSpectating(playerid,false);
						SetPVarInt(playerid,"SpawnStatus",2);
						SpawnPlayer(playerid);
		            }
		            case 2:{
		                if(!owned_house_id[playerid][0]){
						    SendClientMessage(playerid,C_RED,"[Информация] Вы не владелец дома!");
						  	new string[61+25+25];
							format(string,sizeof(string),"[0] Обычный спавн\n[1] Спавн фракции %s\n[2] Спавн в доме %s",(player[playerid][faction_id]?""GREEN"[ доступно ]":""RED"[ не доступно ]"),(owned_house_id[playerid][0]?""GREEN"[ доступно ]":""RED"[ не доступно ]"));
							ShowPlayerDialog(playerid,dAuthorizationSpawn,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","");
						   	return true;
						}
						new temp_string[11-2+4];
						new string[sizeof(temp_string)*MAX_OWNED_HOUSES];
                        for(new i=0; i<MAX_OWNED_HOUSES; i++){
						    if(!owned_house_id[playerid][i]){
						        continue;
						    }
							format(temp_string,sizeof(temp_string),"[%i] №%i\n",i,owned_house_id[playerid][i]);
							strcat(string,temp_string);
						}
						ShowPlayerDialog(playerid,dAuthorizationSpawnHouse,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","Назад");
		            }
		        }
		    }
			else{
			    new string[61+25+25];
				format(string,sizeof(string),"[0] Обычный спавн\n[1] Спавн фракции %s\n[2] Спавн в доме %s",(player[playerid][faction_id]?""GREEN"[ доступно ]":""RED"[ не доступно ]"),(owned_house_id[playerid][0]?""GREEN"[ доступно ]":""RED"[ не доступно ]"));
				ShowPlayerDialog(playerid,dAuthorizationSpawn,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","");
			}
		}
		case dAuthorizationSpawnHouse:{
		    if(response){
                if(!owned_house_id[playerid][0]){
					SendClientMessage(playerid,C_RED,"[Информация] Вы не владелец дома!");
				  	new string[61+25+25];
					format(string,sizeof(string),"[0] Обычный спавн\n[1] Спавн фракции %s\n[2] Спавн в доме %s",(player[playerid][faction_id]?""GREEN"[ доступно ]":""RED"[ не доступно ]"),(owned_house_id[playerid][0]?""GREEN"[ доступно ]":""RED"[ не доступно ]"));
					ShowPlayerDialog(playerid,dAuthorizationSpawn,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","");
				   	return true;
				}
				SetPVarInt(playerid,"SpawnStatus",3);
				SetPVarInt(playerid,"SpawnStatusHouse",listitem);
				SetPVarInt(playerid,"PlayerLogged",1);
				TogglePlayerSpectating(playerid,false);
				SpawnPlayer(playerid);
		    }
		    else{
		        new string[61+25+25];
				format(string,sizeof(string),"[0] Обычный спавн\n[1] Спавн фракции %s\n[2] Спавн в доме %s",(player[playerid][faction_id]?""GREEN"[ доступно ]":""RED"[ не доступно ]"),(owned_house_id[playerid][0]?""GREEN"[ доступно ]":""RED"[ не доступно ]"));
				ShowPlayerDialog(playerid,dAuthorizationSpawn,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","");
		    }
		}
		case dMainMenu:{
		    if(response){
		        switch(listitem){
		            case 0:{
						ShowPlayerDialog(playerid,dMainMenuInfAboutPers,DIALOG_STYLE_LIST,""BLUE"Информация о персонаже","[0] Информация о персонаже\n[1] Информация об аккаунте\n[2] Информация о последних подключениях\n[3] Номера банковских счетов","Выбрать","Назад");
		            }
		            case 1:{
		                ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"Реферальная система","[0] Информация\n[1] Создать\\Удалить промокод\n[2] Информация о промокоде\n[3] Список тех, кто ввёл ваш промокод\n[4] Список тех, кто ввёл ваш никнейм\n[5] Указать реферера","Выбрать","Назад");
		            }
		            case 2:{
		                ShowPlayerDialog(playerid,dMainMenuHelp,DIALOG_STYLE_LIST,""BLUE"Помощь по серверу","[0] Команды сервера","Выбор","Назад");
		            }
		            case 3:{
		                ShowPlayerDialog(playerid,dMainMenuSettings,DIALOG_STYLE_LIST,""BLUE"Настройки аккаунта","[0] Указать эл. почту","Выбор","Назад");
		            }
		        }
		    }
		}
		case dMainMenuSettings:{
		    if(response){
		        switch(listitem){
		            case 0:{
		                if(strlen(player[playerid][email])>MIN_EMAIL_LEN){
		                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Эл. почта уже привязана к вашему аккаунту!\n\n","Закрыть","");
		                    return true;
		                }
		                ShowPlayerDialog(playerid,dMainMenuSettingsEmail,DIALOG_STYLE_INPUT,""BLUE"Указать эл. почту","\n"WHITE"Введите ваш адрес эл. почты\n\n","Выбрать","Назад");
		            }
		        }
		    }
		    else{
		        cmd::menu(playerid);
		    }
		}
		case dMainMenuSettingsEmail:{
		    if(response){
		        new sscanf_email[MAX_EMAIL_LEN];//Объявляем переменную для записи эл. почты
				if(sscanf(inputtext,"s[128]",sscanf_email)){//Если поле ввода оказалось пустым, то...
				    ShowPlayerDialog(playerid,dMainMenuSettingsEmail,DIALOG_STYLE_INPUT,""BLUE"Указать эл. почту","\n"WHITE"Введите ваш адрес эл. почты\n\n","Выбрать","Назад");
				    return true;//Выходим из функции
				}
				if(!regex_match(sscanf_email,"[a-zA-Z0-9_\\.-]{1,22}+@([a-zA-Z0-9\\-]{2,8}+\\.)+[a-zA-Z]{2,4}")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело
				    ShowPlayerDialog(playerid,dMainMenuSettingsEmail,DIALOG_STYLE_INPUT,""BLUE"Указать эл. почту","\n"RED"Эл. почта не подходит по параметрам!\n\n"GREY"Допустимые символы - Aa-Zz, 0-9, @, -, .\nДлина эл. почты - 10-32 символов\n\n"WHITE"Введите ваш адрес эл. почты\n\n","Выбрать","Назад");
				    return true;//Выходим из функции
				}
				new query[43-2-2+MAX_EMAIL_LEN+11];//Объявляем переменную для записи запроса в БД
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`email`='%e'",sscanf_email);//Форматируем запрос с возвращением ответа
				new Cache:cache_users=mysql_query(mysql_connection,query);// Отправляем запрос в БД
				if(cache_get_row_count(mysql_connection)){// Если ответ равен истинне, либо больше, то...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n"RED"Указанный адрес эл. почты уже зарегистрирован в системе!\n\n"WHITE"Введите ваш адрес эл. почты\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
					//Показываем тот же диалог
				}
				else{//Если ответ равен лжи, либо нулю, то...
				    strins(player[playerid][email],sscanf_email,0);
				    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`email`='%e'where`id`='%i'",sscanf_email,player[playerid][id]);
				    mysql_query(mysql_connection,query,false);
				}
				cache_delete(cache_users,mysql_connection);
		    }
		    else{
		    	ShowPlayerDialog(playerid,dMainMenuSettings,DIALOG_STYLE_LIST,""BLUE"Настройки аккаунта","[0] Указать эл. почту","Выбор","Назад");
		    }
		}
		case dMainMenuReferalSystem:{
			if(response){
			    switch(listitem){
			        case 0:{//Информация о реферальной системе
						static string[492];
						strcat(string,"\n"WHITE"На сервере действует усовершенствованная реферальная система.\n");
						strcat(string,"Вы можете создать свой промокод с определёнными критериями и вознаграждениями.\n");
						strcat(string,"При создании промокода, вы можете назначить уровень, при достижении которого\n");
						strcat(string,"игрок может получить определённое вознаграждение.(деньги,опыт)\n");
						strcat(string,"Редактировать промокоды нельзя, только повторное создание.\n");
						strcat(string,"\n"GREY"Не действует на никнеймы!\n");
						//strcat(string,"Промокод можно создать только с VIP аккаунтом!\n"); - в следующих обновлениях
						strcat(string,"При вводе промокода идёт проверка на IP!\n\n");
						ShowPlayerDialog(playerid,dMainMenuReferalSystemInfo,DIALOG_STYLE_MSGBOX,""BLUE"Информация о реферальной системе",string,"Назад","");
						string="";
			        }
			        case 1:{//Создание/удаление промокода
						new query[53-2+MAX_PLAYER_NAME];
						mysql_format(mysql_connection,query,sizeof(query),"select`promocode`from`promocodes`where`creator`='%e'",player[playerid][name]);
						new Cache:cache_promocodes=mysql_query(mysql_connection,query);
						if(cache_get_row_count(mysql_connection)){
							new temp[MAX_PROMOCODE_LEN];
							cache_get_field_content(0,"promocode",temp,mysql_connection,sizeof(temp));
							SetPVarString(playerid,"rs_promocode",temp);
							new string[72-2+MAX_PROMOCODE_LEN];
							format(string,sizeof(string),"\n"WHITE"У вас уже есть промокод - "BLUE"%s\n"WHITE"Вы хотите удалить его?\n\n",temp);
							ShowPlayerDialog(playerid,dMainMenuReferalSystemDelete,DIALOG_STYLE_MSGBOX,""BLUE"Удаление промокода",string,"Да","Нет");
						}
						else{
						    ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Введите название вашего промокода\n\n","Дальше","Назад");
						}
						cache_delete(cache_promocodes,mysql_connection);
			        }
			        case 2:{//Информация о промокоде
			            new query[45-2+MAX_PROMOCODE_LEN];
			            mysql_format(mysql_connection,query,sizeof(query),"select*from`promocodes`where`creator`='%e'",player[playerid][name]);
			            new Cache:cache_promocodes=mysql_query(mysql_connection,query);
			            if(cache_get_row_count(mysql_connection)){
							new temp_id,temp_money,temp_experience,temp_level,temp_created[24],temp_promocode[MAX_PROMOCODE_LEN];
                            temp_id=cache_get_field_content_int(0,"id",mysql_connection);
                            temp_money=cache_get_field_content_int(0,"money",mysql_connection);
                            temp_experience=cache_get_field_content_int(0,"experience",mysql_connection);
                            temp_level=cache_get_field_content_int(0,"level",mysql_connection);
                            cache_get_field_content(0,"created",temp_created,mysql_connection,sizeof(temp_created));
                            cache_get_field_content(0,"promocode",temp_promocode,mysql_connection,MAX_PROMOCODE_LEN);
                            static string[327-2-2-2-2-2-2-2+11+MAX_PROMOCODE_LEN+24+4+5+3+11];
                            format(string,sizeof(string),"\n"WHITE"ID промокода -\t\t"BLUE"%d\n"WHITE"Название промокода -\t"BLUE"%s\n"WHITE"Дата создания -\t\t"BLUE"%s\n\n"GREY"Бонусы:\n"WHITE"Требуемый уровень -\t"BLUE"%d\n"WHITE"Количество денег -\t\t"BLUE"%d\n"WHITE"Количество опыта -\t\t"BLUE"%d\n\n"GREY"Количество игроков, которые ввели промокод - %d\n\n",temp_id,temp_promocode,temp_created,temp_level,temp_money,temp_experience,cache_get_row_count(mysql_connection));
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация о промокоде",string,"Закрыть","");
							string="";
			            }
			            else{
			                if(!strlen(player[playerid][referal_name])){
			                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"У вас нет своего\\привязанного промокода!\n\n","Закрыть","");
			                }
							mysql_format(mysql_connection,query,sizeof(query),"select*from`promocodes`where`promocode`='%e'",player[playerid][referal_name]);
							new Cache:cache__promocodes=mysql_query(mysql_connection,query);
							if(cache_get_row_count(mysql_connection)){
								new temp_id,temp_creator[MAX_PLAYER_NAME],temp_promocode[MAX_PROMOCODE_LEN],temp_created[24];
								temp_id=cache_get_field_content_int(0,"id",mysql_connection);
								cache_get_field_content(0,"creator",temp_creator,mysql_connection,MAX_PLAYER_NAME);
								cache_get_field_content(0,"promocode",temp_promocode,mysql_connection,MAX_PROMOCODE_LEN);
								cache_get_field_content(0,"created",temp_created,mysql_connection,sizeof(temp_created));
								static string[208-2-2-2-2-2+11+MAX_PROMOCODE_LEN+MAX_PLAYER_NAME+24+11+4+8];
								format(string,sizeof(string),"\n"WHITE"ID промокода -\t\t"BLUE"%d\n"WHITE"Название промокода -\t"BLUE"%s\n"WHITE"Создатель -\t\t\t"BLUE"%s\n"WHITE"Дата создания -\t\t"BLUE"%s\n\n"GREY"Количество игроков, которые ввели промокод - %d\n\n",temp_id,temp_promocode,temp_creator,temp_created,cache_get_row_count(mysql_connection));
								ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация о промокоде",string,"Закрыть","");
								string="";
							}
							else{
							    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
							}
							cache_delete(cache__promocodes,mysql_connection);
			            }
			            cache_delete(cache_promocodes,mysql_connection);
			        }
			        case 3:{//Список тех, кто ввёл промокод
			            new query[61-2+MAX_PROMOCODE_LEN];
			            mysql_format(mysql_connection,query,sizeof(query),"select`promocode`,`level`from`promocodes`where`creator`='%e'",player[playerid][name]);
			            new Cache:cache_promocodes=mysql_query(mysql_connection,query);
			            if(cache_get_row_count(mysql_connection)){
			                new temp_promocode[MAX_PROMOCODE_LEN], temp_plevel;
			                cache_get_field_content(0,"promocode",temp_promocode,mysql_connection,sizeof(temp_promocode));
			                temp_plevel=cache_get_field_content_int(0,"level",mysql_connection);
			                mysql_format(mysql_connection,query,sizeof(query),"select`name`,`level`from`users`where`referal_name`='%e'",temp_promocode);
			                new Cache:cache_users=mysql_query(mysql_connection,query);
			                if(cache_get_row_count(mysql_connection)){
			                    static string[512+61];
			                    string=""BLUE"Никнейм\t"BLUE"Статус подключения\t"BLUE"Бонус\n";
			                    for(new i=0; i!=cache_get_row_count(mysql_connection); i++){
			                        new temp_name[MAX_PLAYER_NAME], temp_level;
			                        cache_get_field_content(i,"name",temp_name,mysql_connection,MAX_PLAYER_NAME);
			                        temp_level=cache_get_field_content_int(i,"level",mysql_connection);
			                        new temp_playerid;
			                        sscanf(temp_name,"u",temp_playerid);
			                        new temp_connect[16];
			                        temp_connect=GetPVarInt(temp_playerid,"PlayerLogged")?""GREEN"Online":""RED"Offline";
			                        new temp_bonus[24];
			                        temp_bonus=temp_level>=temp_plevel?""GREEN"+":""RED"-";
			                        new temp_string[22-2-2-2+MAX_PLAYER_NAME+16+24];
			                        format(temp_string,sizeof(temp_string),""WHITE"%s\t%s\t%s\n",temp_name,temp_connect,temp_bonus);
			                        strcat(string,temp_string);
			                    }
			                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"Список игроков, кто ввёл промокод",string,"Закрыть","");
			                    string="";
			                }
			                else{
                                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Действие","\n"WHITE"Ваш промокод ещё никто не указывал!\n\n","Закрыть","");
			                }
			                cache_delete(cache_users,mysql_connection);
			                cache_set_active(cache_promocodes,mysql_connection);
			            }
			            else{
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"У вас нет созданного промокода!\n\n","Закрыть","");
			            }
			            cache_delete(cache_promocodes,mysql_connection);
			        }
			        case 4:{//Список тех, кто ввёл никнейм
			            new query[56-2+MAX_PLAYER_NAME];
			            mysql_format(mysql_connection,query,sizeof(query),"select`name`,`level`from`users`where`referal_name`='%e'",player[playerid][name]);
			            new Cache:cache_users=mysql_query(mysql_connection,query);
			            if(cache_get_row_count(mysql_connection)){
			                static string[512+61];
							string=""BLUE"Никнейм\t"BLUE"Статус подключения\t"BLUE"Бонус\n";
							for(new i=0; i!=cache_get_row_count(mysql_connection); i++){
							    new temp_name[MAX_PLAYER_NAME], temp_level;
							    cache_get_field_content(i,"name",temp_name,mysql_connection,MAX_PLAYER_NAME);
							    temp_level=cache_get_field_content_int(i,"level",mysql_connection);
							    new temp_playerid;
							    sscanf(temp_name,"u",temp_playerid);
							    new temp_connect[16];
							    temp_connect=GetPVarInt(temp_playerid,"PlayerLogged")?""GREEN"Online":""RED"Offline";
							    new temp_bonus[24];
							    temp_bonus=temp_level>=3?""GREEN"+":""RED"-";
							    new temp_string[22-2-2-2+MAX_PLAYER_NAME+16+24];
							    format(temp_string,sizeof(temp_string),""WHITE"%s\t%s\t%s\n",temp_name,temp_connect,temp_bonus);
							    strcat(string,temp_string);
							}
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"Список игроков, кто ввёл никнейм",string,"Закрыть","");
							string="";
			            }
			            else{
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Действие","\n"WHITE"Ваш никнейм ещё никто не указывал!\n\n","Закрыть","");
			            }
			            cache_delete(cache_users,mysql_connection);
			        }
			        case 5:{//указать реферера
			            if(strlen(player[playerid][referal_name])>MIN_PROMOCODE_LEN){
			                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Вы уже указывали реферера!\n\n","Закрыть","");
			                return true;
			            }
						ShowPlayerDialog(playerid,dMainMenuReferalSystemInput,DIALOG_STYLE_INPUT,""BLUE"Указать реферера","\n"WHITE"Введите промокод или никнейм игрока, который вас пригласил\n\n","Выбрать","Назад");
			        }
			    }
			}
			else{
			    cmd::menu(playerid);
			}
		}
		case dMainMenuReferalSystemInfo:{
		    if(response || !response){
		        ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"Реферальная система","[0] Информация\n[1] Создать\\Удалить промокод\n[2] Информация о промокоде\n[3] Список тех, кто ввёл ваш промокод\n[4] Список тех, кто ввёл ваш никнейм\n[5] Указать реферера","Выбрать","Назад");
		    }
		}
		case dMainMenuReferalSystemDelete:{
		    if(response){
		        new temp[MAX_PROMOCODE_LEN];
				GetPVarString(playerid,"rs_promocode",temp,MAX_PROMOCODE_LEN);
				if(!strlen(temp)){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    return true;
				}
				new query[45-2+MAX_PROMOCODE_LEN];
				mysql_format(mysql_connection,query,sizeof(query),"delete from`promocodes`where`promocode`='%e'",temp);
				mysql_query(mysql_connection,query,false);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Действие","\n"WHITE"Вы удалили ваш промокод!\n\n","Закрыть","");
		    }
		    else{
		        ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"Реферальная система","[0] Информация\n[1] Создать\\Удалить промокод\n[2] Информация о промокоде\n[3] Список тех, кто ввёл ваш промокод\n[4] Список тех, кто ввёл ваш никнейм\n[5] Указать реферера","Выбрать","Назад");
		        DeletePVar(playerid,"rs_promocode");
		    }
		}
		case dMainMenuReferalSystemCreate:{
			if(response){
			    new sscanf_promocode[MAX_PROMOCODE_LEN];
			    if(sscanf(inputtext,"s[128]",sscanf_promocode) || strlen(inputtext)<MIN_PROMOCODE_LEN || strlen(inputtext)>MAX_PROMOCODE_LEN){
			        ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Введите название вашего промокода\n\n","Дальше","Назад");
			        return true;
			    }
                if(!regex_match(sscanf_promocode,"[a-zA-Z0-9#-]+")){
                    ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"RED"Найдены недопустимые символы!\n\n"WHITE"Введите название вашего промокода\n\n","Дальше","Назад");
                    return true;
                }
				SetPVarString(playerid,"cp_promocode",sscanf_promocode);
				ShowPlayerDialog(playerid,dMainMenuReferalSystemCrLevel,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите уровень, которого нужно достичь, чтобы получить вознаграждение\n\n","Дальше","Назад");
			}
			else{
			    ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"Реферальная система","[0] Информация\n[1] Создать\\Удалить промокод\n[2] Информация о промокоде\n[3] Список тех, кто ввёл ваш промокод\n[4] Список тех, кто ввёл ваш никнейм\n[5] Указать реферера","Выбрать","Назад");
			    DeletePVar(playerid,"cp_promocode");
			    DeletePVar(playerid,"cp_level");
			    DeletePVar(playerid,"cp_money");
			    DeletePVar(playerid,"cp_experience");
			}
		}
		case dMainMenuReferalSystemCrLevel:{
		    if(response){
		        new sscanf_level;
		        if(sscanf(inputtext,"d",sscanf_level) || strval(inputtext)<1){
		            ShowPlayerDialog(playerid,dMainMenuReferalSystemCrLevel,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите уровень, которого нужно достичь, чтобы получить вознаграждение\n\n","Дальше","Назад");
		            return true;
		        }
		        SetPVarInt(playerid,"cp_level",sscanf_level);
                ShowPlayerDialog(playerid,dMainMenuReferalSystemCrMoney,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите сумму денег, которая будет выдаваться\n\n","Дальше","Назад");
		    }
		    else{
		        ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Введите название вашего промокода\n\n","Дальше","Назад");
		        DeletePVar(playerid,"cp_level");
		    }
		}
		case dMainMenuReferalSystemCrMoney:{
		    if(response){
				new sscanf_money;
				if(sscanf(inputtext,"d",sscanf_money) || strval(inputtext)<0 || strval(inputtext)>50000){
                    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrMoney,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите сумму денег, которая будет выдаваться\n\n","Дальше","Назад");
				    return true;
				}
				SetPVarInt(playerid,"cp_money",sscanf_money);
				ShowPlayerDialog(playerid,dMainMenuReferalSystemCrExp,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите количество опыта, которое будет выдаваться\n\n","Дальше","Назад");
		    }
			else{
			    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrLevel,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите уровень, которого нужно достичь, чтобы получить вознаграждение\n\n","Дальше","Назад");
                DeletePVar(playerid,"cp_money");
			}
		}
		case dMainMenuReferalSystemCrExp:{
			if(response){
			    new sscanf_experience;
			    if(sscanf(inputtext,"d",sscanf_experience) || strval(inputtext)>24){
			        ShowPlayerDialog(playerid,dMainMenuReferalSystemCrExp,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите количество опыта, которое будет выдаваться\n\n","Дальше","Назад");
			        return true;
			    }
			    SetPVarInt(playerid,"cp_experience",sscanf_experience);
			    new temp[MAX_PROMOCODE_LEN];
			    GetPVarString(playerid,"cp_promocode",temp,MAX_PROMOCODE_LEN);
			    new temp_money[16];
			    if(GetPVarInt(playerid,"cp_money")){
					format(temp_money,sizeof(temp_money),"$%d",GetPVarInt(playerid,"cp_money"));
			    }
			    else{
			        temp_money="Нет";
			    }
			    new temp_experience[16];
			    if(sscanf_experience){
			        format(temp_experience,sizeof(temp_experience),"%d",sscanf_experience);
			    }
			    else{
			        temp_experience="Нет";
			    }
			    new string[122-2-2-2-2+MAX_PROMOCODE_LEN+16+16+4];
			    format(string,sizeof(string),"\n"WHITE"Промокод - "BLUE"%s\n"WHITE"Уровень - "BLUE"%d\n"WHITE"Деньги - "BLUE"%s\n"WHITE"Опыт - "BLUE"%s\n\n",temp,GetPVarInt(playerid,"cp_level"),temp_money,temp_experience);
			    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Создание промокода",string,"Дальше","Назад");
			}
			else{
			    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrMoney,DIALOG_STYLE_INPUT,""BLUE"Создание промокода","\n"WHITE"Укажите сумму денег, которая будет выдаваться\n\n","Дальше","Назад");
			    DeletePVar(playerid,"cp_experience");
			}
		}
		case dMainMenuReferalSystemCrConfirm:{
			if(response){
			    new temp_promocode[MAX_PROMOCODE_LEN];
			    GetPVarString(playerid,"cp_promocode",temp_promocode,sizeof(temp_promocode));
			    if(!strlen(temp_promocode) || !GetPVarInt(playerid,"cp_level")){
			        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			        return true;
			    }
			    new query[108-2-2-2-2-2+MAX_PLAYER_NAME+MAX_PROMOCODE_LEN+4+11+11];
			    mysql_format(mysql_connection,query,sizeof(query),"insert into`promocodes`(`creator`,`promocode`,`level`,`money`,`experience`)values('%e','%e','%d','%d','%d')",player[playerid][name],temp_promocode,GetPVarInt(playerid,"cp_level"),GetPVarInt(playerid,"cp_money"),GetPVarInt(playerid,"cp_experience"));
			    mysql_query(mysql_connection,query);
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Действие","\n"WHITE"Вы создали свой промокод!\n\n","Закрыть","");
			    DeletePVar(playerid,"cp_promocode");
			    DeletePVar(playerid,"cp_level");
			    DeletePVar(playerid,"cp_money");
			    DeletePVar(playerid,"cp_experience");
			}
			else{
			    DeletePVar(playerid,"cp_promocode");
			    DeletePVar(playerid,"cp_level");
			    DeletePVar(playerid,"cp_money");
			    DeletePVar(playerid,"cp_experience");
			}
		}
		case dMainMenuReferalSystemInput:{
		    if(response){
		        new sscanf_referrer[MAX_PROMOCODE_LEN];
		        if(sscanf(inputtext,"s[128]",sscanf_referrer)){
		            ShowPlayerDialog(playerid,dMainMenuReferalSystemInput,DIALOG_STYLE_INPUT,""BLUE"Указать реферера","\n"WHITE"Введите промокод или никнейм игрока, который вас пригласил\n\n","Выбрать","Назад");
		            return true;
		        }
		        new query[54-2-2+MAX_PROMOCODE_LEN+16];//Объявляем переменную для форматирования запроса
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",sscanf_referrer);//Форматируем запрос с возвращением ответа
				new Cache:cache_users=mysql_query(mysql_connection,query);//Отправляем запрос в БД
				if(cache_get_row_count(mysql_connection)){// Если ответ равен истине, либо больше, то...
				    new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'and`reg_ip`='%e'",sscanf_referrer,temp_ip);
					new Cache:cache__users=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    ShowPlayerDialog(playerid,dMainMenuReferalSystemInput,DIALOG_STYLE_INPUT,""BLUE"Указать реферера","\n"RED"Вы не можете указать этот никнейм!\n\n"WHITE"Введите промокод или никнейм игрока, который вас пригласил\n\n","Выбрать","Закрыть");
					    return true;
					}
					cache_delete(cache__users,mysql_connection);
					strins(player[playerid][referal_name],sscanf_referrer,0);
					mysql_format(mysql_connection,query,sizeof(query),"update`users`set`referal_name`='%e'where`id`='%i'",sscanf_referrer,player[playerid][id]);
					mysql_query(mysql_connection,query,false);
				    SendClientMessage(playerid,C_BLUE,"[Информация] Вы были приглашены игроком по никнейму!");//Выводим сообщение с текстом о типе рефера
				}
				else{//Если ответ равен лжи, то...
				    mysql_format(mysql_connection,query,sizeof(query),"select`creator`from`promocodes`where`promocode`='%e'",sscanf_referrer);//Форматируем запрос с возвращением ответа
				    new Cache:cache_promocodes=mysql_query(mysql_connection,query);// Отправляем запрос
				    if(cache_get_row_count(mysql_connection)){// Если ответ равен истине, либо больше, то...
				        new temp_ip[16],temp_name[MAX_PLAYER_NAME];
						GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
				        cache_get_field_content(0,"creator",temp_name,mysql_connection,sizeof(temp_name));
				        mysql_format(mysql_connection,query,sizeof(query),"select`id`from`users`where`name`='%e'and`reg_ip`='%e'",temp_name,temp_ip);
				        mysql_query(mysql_connection,query);
				        if(cache_get_row_count(mysql_connection)){
				            ShowPlayerDialog(playerid,dMainMenuReferalSystemInput,DIALOG_STYLE_INPUT,""BLUE"Указать реферера","\n"RED"Вы не можете указать этот промокод!\n\n"WHITE"Введите промокод или никнейм игрока, который вас пригласил\n\n","Выбрать","Закрыть");
						    return true;
				        }
				        if(!regex_match(sscanf_referrer,"[a-zA-Z0-9_#@!-]{4,32}+")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то условие пройдёт в тело ИЛИ длина текста меньше n ИЛИ длина текста больше n
	                        ShowPlayerDialog(playerid,dMainMenuReferalSystemInput,DIALOG_STYLE_INPUT,""BLUE"Указать реферера","\n"RED"Промокод не подходит по параметрам!\n\n"GREY"Доступные символы - Aa-Zz, 0-9, _, #, @, !, -.\nДлина промокода - 4-32 символа\n\n"WHITE"Введите промокод или никнейм игрока, который вас пригласил\n\n","Выбрать","Закрыть");
		          		    return true;//Выходим из функции
		          		}
		          		strins(player[playerid][referal_name],sscanf_referrer,0);
						mysql_format(mysql_connection,query,sizeof(query),"update`users`set`referal_name`='%e'where`id`='%i'",sscanf_referrer,player[playerid][id]);
						mysql_query(mysql_connection,query,false);
						SendClientMessage(playerid,C_BLUE,"[Информация] Вы были приглашены игроком по промокоду!");//Выводим сообщение с текстом о типе рефера
				    }
				    else{//Если ответ равен лжи, то...
                        ShowPlayerDialog(playerid,dMainMenuReferalSystemInput,DIALOG_STYLE_INPUT,""BLUE"Указать реферера","\n\n"RED"Промокод/Никнейм игрока не зарегистрирован в системе!\n\n"WHITE"Введите промокод или никнейм игрока, который вас пригласил\n\n","Выбрать","Закрыть");
				    }
				    cache_delete(cache_promocodes,mysql_connection);
				}
				cache_delete(cache_users,mysql_connection);
		    }
		    else{
		        ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"Реферальная система","[0] Информация\n[1] Создать\\Удалить промокод\n[2] Информация о промокоде\n[3] Список тех, кто ввёл ваш промокод\n[4] Список тех, кто ввёл ваш никнейм\n[5] Указать реферера","Выбрать","Назад");
		    }
		}
		case dMainMenuInfAboutPers:{
		    if(response){
		        switch(listitem){
			        case 0:{
			            showStats(playerid,playerid);
			        }
			        case 1:{
			            new string[195-2-2-2-2-2+11+MAX_PLAYER_NAME+MAX_EMAIL_LEN+MAX_PROMOCODE_LEN+20];
			            new temp_email[MAX_EMAIL_LEN];
			            if(!strlen(player[playerid][email])){
			                temp_email="не привязана";
			            }
			            else{
			                format(temp_email,sizeof(temp_email),player[playerid][email]);
			            }
			            new temp_referal_name[MAX_PROMOCODE_LEN];
			            if(!strlen(player[playerid][referal_name])){
			                temp_referal_name="не указан";
			            }
			            else{
			                format(temp_referal_name,sizeof(temp_referal_name),player[playerid][referal_name]);
			            }
			            format(string,sizeof(string),"\n"WHITE"Номер аккаунта - "BLUE"%i\n"WHITE"Никнейм - "BLUE"%s\n\n"WHITE"Электронная почта - "GREY"%s\n"WHITE"Реферер\\Промокод - "GREY"%s\n\n"WHITE"Дата регистрации - "BLUE"%s\n\n",player[playerid][id],player[playerid][name],temp_email,temp_referal_name,player[playerid][reg_date]);
			            ShowPlayerDialog(playerid,dMainMenuInfAboutPersAccount,DIALOG_STYLE_MSGBOX,""BLUE"Информация об аккаунте",string,"Назад","");
					}
					case 2:{//Информация о последних подключениях
						new query[73-2+11];
						mysql_format(mysql_connection,query,sizeof(query),"select`date`,`ip`from`connects`where`id`='%i'order by`date`desc limit 15",player[playerid][id]);
						new Cache:cache_connects=mysql_query(mysql_connection,query);
						if(cache_get_row_count(mysql_connection)){
						    new temp_date[32],temp_ip[16],temp_string[13-2-2-2+11+32+16];
						    new temp_ip_color[24];
						    static string[sizeof(temp_string)*15];
						    string=""BLUE"№\t"WHITE"Дата\t"WHITE"IP адрес\n";
						    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
								cache_get_field_content(i,"date",temp_date,mysql_connection,sizeof(temp_date));
								cache_get_field_content(i,"ip",temp_ip,mysql_connection,sizeof(temp_ip));
								if(!strcmp(temp_ip,player[playerid][reg_ip])){
								    format(temp_ip_color,sizeof(temp_ip_color),""GREEN"%s",temp_ip);
								}
								else{
								    format(temp_ip_color,sizeof(temp_ip_color),""RED"%s",temp_ip);
								}
								format(temp_string,sizeof(temp_string),"%i\t%s\t%s\n",i,temp_date,temp_ip_color);
								strcat(string,temp_string);
						    }
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"Информация о последних подключениях",string,"Закрыть","");
						    string="";
						}
						else{
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
						}
						cache_delete(cache_connects,mysql_connection);
					}
					case 3:{
					    new query[61-2+MAX_PLAYER_NAME];
					    mysql_format(mysql_connection,query,sizeof(query),"select`id`,`description`from`bank_accounts`where`owner`='%e'",player[playerid][name]);
					    new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
					    if(cache_get_row_count(mysql_connection)){
					        new temp_id,temp_description[32];
					        static string[24+(48*10)];
							string=""BLUE"Название\t"BLUE"Номер счёта\n";
					        new temp_string[9-2-2+32+11];
							for(new i=0; i<cache_get_row_count(mysql_connection); i++){
							    temp_id=cache_get_field_content_int(i,"id",mysql_connection);
							    cache_get_field_content(i,"description",temp_description,mysql_connection,sizeof(temp_description));
							    format(temp_string,sizeof(temp_string),"%s\t%i\n",temp_description,temp_id);
							    strcat(string,temp_string);
							}
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"Номера банковских счетов",string,"Закрыть","");
							string="";
					    }
					    else{
					        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"У вас ещё нет созданных банковских счетов!\n\n","Ок","");
					    }
					    cache_delete(cache_bank_accounts,mysql_connection);
					}
				}
		    }
		    else{
		        cmd::menu(playerid);
		    }
		}
		case dMainMenuHelp:{
		    if(response){
		        switch(listitem){
		            case 0:{
		                ShowPlayerDialog(playerid,dMainMenuHelpCommands,DIALOG_STYLE_LIST,""BLUE"Команды сервера","[0] Команды для чата\n[1] Команды для фракции\n[2] Команды для дома\n[3] Команды для транспорта\n[4] Команды для бизнеса","Выбрать","Назад");
		            }
		        }
		    }
		    else{
		        cmd::menu(playerid);
		    }
		}
		case dMainMenuHelpCommands:{
		    if(response){
		        switch(listitem){
		            case 0:{
						static string[798];
						strcat(string,"\n"BLUE"/todo "WHITE"- сообщение с действием\n");
						strcat(string,""BLUE"/me "WHITE"- действие персонажа\n");
						strcat(string,""BLUE"/do "WHITE"- действие от третьего лица\n");
						strcat(string,""BLUE"/try(/coin) "WHITE"- попытка действия\n");
						strcat(string,""BLUE"/shout "WHITE"- крикнуть\n");
						strcat(string,""BLUE"/whisper "WHITE"- прошептать сообщение игроку\n");
						strcat(string,""BLUE"/n(/b) "WHITE"- OOC сообщение\n\n");
						strcat(string,""BLUE"/atodo "WHITE"- сообщение с действием"GREY"(текст только над головой)\n");
						strcat(string,""BLUE"/ame "WHITE"- действие персонажа"GREY"(текст только над головой)\n");
						strcat(string,""BLUE"/ado "WHITE"- действие от третьего лица"GREY"(текст только над головой)\n");
						strcat(string,""BLUE"/atry(/acoin) "WHITE"- попытка действия"GREY"(текст только над головой)\n");
						strcat(string,""BLUE"/ashout "WHITE"- крикнуть"GREY"(текст только над головой)\n");
						strcat(string,""BLUE"/an(/ab) "WHITE"- OOC сообщение"GREY"(текст только над головой)\n\n");
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Команды для чата",string,"Закрыть","");
						string="\0";
		            }
		            case 1:{
		                static string[418];
		                strcat(string,"\n"BLUE"/faction(/f) "WHITE"- чат фракции\n");
		                strcat(string,""BLUE"/find "WHITE"- онлайн фракции\n\n");
		                strcat(string,""BLUE"/fmenu(/fpanel /fp /fm) "WHITE"- меню фракции\n\n");
		                strcat(string,""GREY"Команды для лидера и заместителя\n\n");
		                strcat(string,""BLUE"/invite "WHITE"- пригласить игрока во фракцию\n");
		                strcat(string,""BLUE"/uninvite "WHITE"- уволить игрока из фракции\n");
		                strcat(string,""BLUE"/giverank "WHITE"- повысить/понизить должность\n");
		                strcat(string,""BLUE"/lmenu(/lpanel /lp /lm) "WHITE"- панель лидера\n\n");
                        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Команды для фракции",string,"Закрыть","");
                        string="\0";
		            }
		            case 2:{
		                static string[84];
		                strcat(string,"\n"BLUE"/home(/hm - /hmenu - /hpanel - /hp) "WHITE"- панель управления домом\n\n");
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Команды для дома",string,"Закрыть","");
		                string="\0";
		            }
		            case 3:{
		                static string[213];
		                strcat(string,"\n"BLUE"/engine "WHITE"- завести/заглушить двигатель транспорта\n");
		                strcat(string,""BLUE"/lights "WHITE"- включить/выключить фары транспорта\n");
		                strcat(string,""BLUE"/sellcar(/sellvehicle) "WHITE"- продать личный транспорт государству\n\n");
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Команды для транспорта",string,"Закрыть","");
		                string="\0";
		            }
					case 4:{
					    static string[91];
					    strcat(string,"\n"BLUE"/business(/bm - /bmenu - /bpanel - /bp) "WHITE"- панель управления бизнесом\n\n");
					    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Команды для бизнеса",string,"Закрыть","");
					    string="\0";
					}
		        }
		    }
			else{
				cmd::menu(playerid);
			}
		}
		case dBankCreateAccount:{
		    if(response){
				if(player[playerid][passport_id]<100000){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    return true;
				}
		        SetPVarInt(playerid,"Bank_CreatingAccount",1);
		        ShowPlayerDialog(playerid,dBankCreateAccountDescription,DIALOG_STYLE_INPUT,""BLUE"Создание банковского счёта","\n"WHITE"Введите название для вашего нового счёта\n\n","Дальше","Отмена");
		    }
		    else{
				DeletePVar(playerid,"Bank_CreatingAccount");
				DeletePVar(playerid,"Bank_CreatingAccountDescription");
				DeletePVar(playerid,"Bank_CreatingAccountPassword");
		    }
		}
		case dBankCreateAccountDescription:{
		    if(response){
		        if(!GetPVarInt(playerid,"Bank_CreatingAccount") || player[playerid][passport_id]<100000){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            return true;
		        }
		        new temp_description[32];
		        if(sscanf(inputtext,"s[128]",temp_description)){
		            ShowPlayerDialog(playerid,dBankCreateAccountDescription,DIALOG_STYLE_INPUT,""BLUE"Создание банковского счёта","\n"WHITE"Введите название для вашего нового счёта\n\n","Дальше","Отмена");
		            return true;
		        }
		        SetPVarString(playerid,"Bank_CreatingAccountDescription",temp_description);
		        new string[99-2+32];
		        format(string,sizeof(string),"\n"GREY"Название банковского счёта - %s\n\n"WHITE"Придумайте пароль для вашего нового счёта\n\n",temp_description);
		        ShowPlayerDialog(playerid,dBankCreateAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"Создание банковского счёта",string,"Дальше","Отмена");
			}
			else{
                DeletePVar(playerid,"Bank_CreatingAccount");
                DeletePVar(playerid,"Bank_CreatingAccountDescription");
                DeletePVar(playerid,"Bank_CreatingAccountPassword");
			}
		}
		case dBankCreateAccountPassword:{
		    if(response){
		        new temp_description[32];
				GetPVarString(playerid,"Bank_CreatingAccountDescription",temp_description,sizeof(temp_description));
		        if(!GetPVarInt(playerid,"Bank_CreatingAccount") && !strlen(temp_description) || player[playerid][passport_id]<100000){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            return true;
		        }
		        new sscanf_password[32];
				if(sscanf(inputtext,"s[128]",sscanf_password) || !regex_match(sscanf_password,"[a-zA-Z0-9]+")){
				    new string[99-2+32];
			        format(string,sizeof(string),"\n"GREY"Название банковского счёта - %s\n\n"WHITE"Придумайте пароль для вашего нового счёта\n\n",temp_description);
			        ShowPlayerDialog(playerid,dBankCreateAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"Создание банковского счёта",string,"Дальше","Отмена");
				    return true;
				}
				SetPVarString(playerid,"Bank_CreatingAccountPassword",sscanf_password);
				new string[87-2-2+32+32];
				format(string,sizeof(string),"\n"WHITE"Название - %s\nПароль - %s\n\n"GREY"Вы хотите создать банковский счёт?\n\n",temp_description,sscanf_password);
				ShowPlayerDialog(playerid,dBankCreateAccountConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Создание банковского счёта",string,"Да","Нет");
		    }
		    else{
                DeletePVar(playerid,"Bank_CreatingAccount");
                DeletePVar(playerid,"Bank_CreatingAccountDescription");
                DeletePVar(playerid,"Bank_CreatingAccountPassword");
		    }
		}
		case dBankCreateAccountConfirm:{
		    if(response){
		        new temp_description[32],temp_password[32];
		        GetPVarString(playerid,"Bank_CreatingAccountDescription",temp_description,sizeof(temp_description));
		        GetPVarString(playerid,"Bank_CreatingAccountPassword",temp_password,sizeof(temp_password));
		        if(!GetPVarInt(playerid,"Bank_CreatingAccount") && !strlen(temp_description) && !strlen(temp_password) || player[playerid][passport_id]<100000){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            return true;
		        }
		        ShowPlayerDialog(playerid,dBankCreateAccountSignConfirm,DIALOG_STYLE_INPUT,""BLUE"Банковский счёт","\n"WHITE"Для создания счёта, вам необходимо поставить вашу подпись"GREY"(из паспорта)\n\n","Дальше","Отмена");
		    }
		    else{
                DeletePVar(playerid,"Bank_CreatingAccount");
                DeletePVar(playerid,"Bank_CreatingAccountDescription");
                DeletePVar(playerid,"Bank_CreatingAccountPassword");
		    }
		}
		case dBankCreateAccountSignConfirm:{
		    if(response){
				new sscanf_sign[32];
				if(sscanf(inputtext,"s[128]",sscanf_sign)){
                    ShowPlayerDialog(playerid,dBankCreateAccountSignConfirm,DIALOG_STYLE_INPUT,""BLUE"Банковский счёт","\n"WHITE"Для создания счёта, вам необходимо поставить вашу подпись"GREY"(из паспорта)\n\n","Дальше","Отмена");
				    return true;
				}
				new query[83-2-2-2+MAX_PLAYER_NAME+32+32];
				mysql_format(mysql_connection,query,sizeof(query),"select`id`from`passports`where`signature`='%e'and`id`='%i'",sscanf_sign,player[playerid][passport_id]);
				new Cache:cache_passports=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					new temp_description[32],temp_password[32];
			        GetPVarString(playerid,"Bank_CreatingAccountDescription",temp_description,sizeof(temp_description));
			        GetPVarString(playerid,"Bank_CreatingAccountPassword",temp_password,sizeof(temp_password));
					mysql_format(mysql_connection,query,sizeof(query),"insert into`bank_accounts`(`owner`,`password`,`description`)values('%e','%e','%e')",player[playerid][name],temp_password,temp_description);
					mysql_query(mysql_connection,query);
					new temp_id=cache_insert_id(mysql_connection);
					DeletePVar(playerid,"Bank_CreatingAccount");
	                DeletePVar(playerid,"Bank_CreatingAccountDescription");
	                DeletePVar(playerid,"Bank_CreatingAccountPassword");
	                new string[44-2+11];
	                format(string,sizeof(string),"[Информация] Номер вашего нового счёта - %i",temp_id);
					SendClientMessage(playerid,C_GREEN,string);
					SendClientMessage(playerid,C_BLUE,"[Информация] Используйте номер счёта и пароль у кассира для действий!");
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Вы указали неправильную подпись!\n\n","Закрыть","");
				    DeletePVar(playerid,"Bank_CreatingAccount");
	                DeletePVar(playerid,"Bank_CreatingAccountDescription");
	                DeletePVar(playerid,"Bank_CreatingAccountPassword");
				}
				cache_delete(cache_passports);
		    }
		    else{
                DeletePVar(playerid,"Bank_CreatingAccount");
                DeletePVar(playerid,"Bank_CreatingAccountDescription");
                DeletePVar(playerid,"Bank_CreatingAccountPassword");
		    }
		}
		case dBankAccountInput:{
		    if(response){
				new temp_id;
				if(sscanf(inputtext,"i",temp_id)){
				    ShowPlayerDialog(playerid,dBankAccountInput,DIALOG_STYLE_INPUT,""BLUE"Банковский счёт","\n"WHITE"Введите номер вашего банковского счёта\n\n"GREY"(( Подсказка: /menu [0] [3] ))\n\n","Дальше","Отмена");
				    return true;
				}
				new query[52-2+11];
				mysql_format(mysql_connection,query,sizeof(query),"select`description`from`bank_accounts`where`id`='%i'",temp_id);
				new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
				    new temp_description[32];
				    cache_get_field_content(0,"description",temp_description,mysql_connection,sizeof(temp_description));
					SetPVarInt(playerid,"tempBankAccount",temp_id);
					SetPVarString(playerid,"tempBankAccountDesc",temp_description);
					new string[69-2+32];
					format(string,sizeof(string),"\n"WHITE"Название банковского счёта - %s\nВам необходимо ввести пароль для доступа\n\n",temp_description);
					ShowPlayerDialog(playerid,dBankAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"Банковский счёт",string,"Дальше","Отмена");
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Указанного банковского счёта не существует!\n\n","Закрыть","");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
		    }
		}
		case dBankAccountPassword:{
		    if(response){
		        new temp_description[32];
		        GetPVarString(playerid,"tempBankAccountDesc",temp_description,sizeof(temp_description));
		        new temp_password[32];
		        if(sscanf(inputtext,"s[128]",temp_password)){
		            new string[69-2+32];
					format(string,sizeof(string),"\n"WHITE"Название банковского счёта - %s\nВам необходимо ввести пароль для доступа\n\n",temp_description);
					ShowPlayerDialog(playerid,dBankAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"Банковский счёт",string,"Дальше","Отмена");
		            return true;
		        }
				new query[58-2-2+32+11];
				mysql_format(mysql_connection,query,sizeof(query),"select*from`bank_accounts`where`password`='%e'and`id`='%i'",temp_password,GetPVarInt(playerid,"tempBankAccount"));
				new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					new temp_main=cache_get_field_content_int(0,"main",mysql_connection);
					SetPVarInt(playerid,"tempBankAccountMain",temp_main);
					if(temp_main){
						ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n"GREY"[5] Сделать счёт основным","Выбрать","Выход");
					}
					else{
                        ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n[5] Сделать счёт основным","Выбрать","Выход");
					}
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы ввели неправильный пароль!\n\n","Закрыть","");
				    DeletePVar(playerid,"tempBankAccount");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
				DeletePVar(playerid,"tempBankAccountDesc");
		    }
		    else{
		        DeletePVar(playerid,"tempBankAccount");
		        DeletePVar(playerid,"tempBankAccountDesc");
		    }
		}
		case dBankAccountMenu:{
		    if(response){
				if(!GetPVarInt(playerid,"tempBankAccount")){
				    return true;
				}
		        switch(listitem){
		            case 0:{// Информация о счёте
		                new query[81-2+11];
		                mysql_format(mysql_connection,query,sizeof(query),"select`id`,`owner`,`date`,`description`,`money`from`bank_accounts`where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
		                new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
		                if(cache_get_row_count(mysql_connection)){
							new temp_id,temp_owner[MAX_PLAYER_NAME],temp_date[32],temp_description[32],temp_money;
							temp_id=cache_get_field_content_int(0,"id",mysql_connection);
							cache_get_field_content(0,"owner",temp_owner,mysql_connection,sizeof(temp_owner));
							cache_get_field_content(0,"date",temp_date,mysql_connection,sizeof(temp_date));
							cache_get_field_content(0,"description",temp_description,mysql_connection,sizeof(temp_description));
							temp_money=cache_get_field_content_int(0,"money",mysql_connection);
							static string[187-2-2-2-2+11+32+MAX_PLAYER_NAME+32+11];
							format(string,sizeof(string),"\n"WHITE"Номер счёта - "BLUE"%i\n"WHITE"Название счёта - "BLUE"%s\n"WHITE"Владелец счёта - "BLUE"%s\n"WHITE"Дата создания - "BLUE"%s\n"WHITE"Баланс - "GREEN"$%i\n\n",temp_id,temp_description,temp_owner,temp_date,temp_money);
							ShowPlayerDialog(playerid,dBankAccountMenuInf,DIALOG_STYLE_MSGBOX,""BLUE"Информация о счёте",string,"Назад","");
							string="\0";
		                }
		                else{
		                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		                }
		                cache_delete(cache_bank_accounts,mysql_connection);
		            }
		            case 1:{// Перевести деньги на другой счёт
						ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"Перевести деньги на другой счёт","\n"WHITE"Введите номер счёта и сумму перевода через запятую\n\n"GREY"Пример: 12345,2000\n\n","Дальше","Назад");
		            }
					case 2:{//Снять деньги со счёта
					    ShowPlayerDialog(playerid,dBankAccountMenuWithdraw,DIALOG_STYLE_INPUT,""BLUE"Снять деньги со счёта","\n"WHITE"Введите сумму, которую вы хотите снять со счёта\n\n","Дальше","Назад");
					}
					case 3:{//Положить деньги на счёт
					    ShowPlayerDialog(playerid,dBankAccountMenuDeposit,DIALOG_STYLE_INPUT,""BLUE"Положить деньги на счёт","\n"WHITE"Введите сумму, которую хотите положить на счёт\n\n","Дальше","Назад");
					}
					case 4:{//История транзакций
					    new query[121-2+11];
					    mysql_format(mysql_connection,query,sizeof(query),"select`transaction_id`,`type`,`date`,`money`,`transfer_id`from`ba_transactions`where`ba_id`='%i'order by`date`desc limit 15",GetPVarInt(playerid,"tempBankAccount"));
					    new Cache:cache_ba_transactions=mysql_query(mysql_connection,query);
					    if(cache_get_row_count(mysql_connection)){
					        new temp_transaction_id,temp_type,temp_date[20],temp_money,temp_transfer_id;
							new temp_money_color[18-2+11];
							new temp_string[67-2-2-2-2+11+sizeof(temp_date)+sizeof(temp_money_color)+11];
							static string[sizeof(temp_string)*15];
					        for(new i=0; i<cache_get_row_count(mysql_connection); i++){
								temp_transaction_id=cache_get_field_content_int(i,"transaction_id",mysql_connection);
								temp_type=cache_get_field_content_int(i,"type",mysql_connection);
								cache_get_field_content(i,"date",temp_date,mysql_connection,sizeof(temp_date));
								temp_money=cache_get_field_content_int(i,"money",mysql_connection);
								temp_transfer_id=cache_get_field_content_int(i,"transfer_id",mysql_connection);
								if(temp_money>=1){
								    format(temp_money_color,sizeof(temp_money_color),""GREEN"$%i"WHITE"",temp_money);
								}
								else if(temp_money<=-1){
								    format(temp_money_color,sizeof(temp_money_color),""RED"$%i"WHITE"",temp_money);
								}
								switch(temp_type){
								    case FROM_ACCOUNT_TO_ACCOUNT:{
										format(temp_string,sizeof(temp_string),""WHITE"TRANSFER | ID - %i | Дата - %s | %s | Номер счёта - %i\n",temp_transaction_id,temp_date,temp_money_color,temp_transfer_id);
								    }
								    case WITHDRAW_FROM_ACCOUNT:{
								        format(temp_string,sizeof(temp_string),""WHITE"WITHDRAW | ID - %i | Дата - %s | %s | Номер аккаунта - %i\n",temp_transaction_id,temp_date,temp_money_color,temp_transfer_id);
								    }
								    case DEPOSIT_TO_ACCOUNT:{
								        format(temp_string,sizeof(temp_string),""WHITE"DEPOSIT | ID - %i | Дата - %s | %s | Номер аккаунта - %i\n",temp_transaction_id,temp_date,temp_money_color,temp_transfer_id);
								    }
								}
								strcat(string,temp_string);
							}
							ShowPlayerDialog(playerid,dBankAccountMenuInf,DIALOG_STYLE_MSGBOX,""BLUE"История транзакций",string,"Назад","");
							string="\0";
					    }
					    else{
                            ShowPlayerDialog(playerid,dBankAccountMenuInf,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Транзакций с вашим счётом не найдено!\n\n","Назад","");
					    }
					    cache_delete(cache_ba_transactions,mysql_connection);
					}
					case 5:{
						new query[52-2+MAX_PLAYER_NAME];
						mysql_format(mysql_connection,query,sizeof(query),"select`id`from`bank_accounts`where`id`='%i'and`main`='1'",GetPVarInt(playerid,"tempBankAccount"));
						new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
						if(cache_get_row_count(mysql_connection)){
                            ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n"GREY"[5] Сделать счёт основным","Выбрать","Выход");
						}
						else{
                            ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n"GREY"[5] Сделать счёт основным","Выбрать","Выход");
							mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`main`='0'where`owner`='%e'",player[playerid][name]);
							mysql_query(mysql_connection,query,false);
							mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`main`='1'where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
							mysql_query(mysql_connection,query,false);
						}
						cache_delete(cache_bank_accounts,mysql_connection);
					}
		        }
		    }
		    else{
                DeletePVar(playerid,"tempBankAccount");
                DeletePVar(playerid,"tempBankAccountMain");
		    }
		}
		case dBankAccountMenuInf:{
			if(response || !response){
                if(GetPVarInt(playerid,"tempBankAccountMain")){
					ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n"GREY"[5] Сделать счёт основным","Выбрать","Выход");
				}
				else{
                    ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n[5] Сделать счёт основным","Выбрать","Выход");
				}
			}
		}
		case dBankAccountMenuTransfer:{
			if(response){
			    new sscanf_id,sscanf_money;
			    if(sscanf(inputtext,"p<,>ii",sscanf_id,sscanf_money)){
				    ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"Перевести деньги на другой счёт","\n"WHITE"Введите номер счёта и сумму перевода через запятую\n\n"GREY"Пример: 12345,2000\n\n","Дальше","Назад");
				    return true;
				}
				if(sscanf_money < 0){
					ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"Перевести деньги на другой счёт","\n"WHITE"Введите номер счёта и сумму перевода через запятую\n\n"GREY"Пример: 12345,2000\n\n","Дальше","Назад");
					return true;
				}
				new query[61-2+11];
				mysql_format(mysql_connection,query,sizeof(query),"select`money`from`bank_accounts`where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
				new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					new temp_money;
					temp_money=cache_get_field_content_int(0,"money",mysql_connection);
					if(sscanf_money>temp_money){
                        ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"Перевести деньги на другой счёт","\n"RED"На вашем счету нет столько средств!\n\n"WHITE"Введите номер счёта и сумму перевода через запятую\n\n"GREY"Пример: 12345,2000\n\n","Дальше","Назад");
					    return true;
					}
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    return true;
				}
				cache_delete(cache_bank_accounts,mysql_connection);
				mysql_format(mysql_connection,query,sizeof(query),"select`description`,`owner`from`bank_accounts`where`id`='%i'",sscanf_id);
				cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					new temp_description[32],temp_owner[MAX_PLAYER_NAME];
					cache_get_field_content(0,"description",temp_description,mysql_connection,sizeof(temp_description));
					cache_get_field_content(0,"owner",temp_owner,mysql_connection,sizeof(temp_owner));
					SetPVarInt(playerid,"tempBankAccountTransfer",sscanf_id);
					SetPVarInt(playerid,"tempBankAccountTransferMoney",sscanf_money);
					SetPVarString(playerid,"tempBankAccountTransferOwner",temp_owner);
					static string[202-2-2-2+11+32+11];
					format(string,sizeof(string),"\n"WHITE"Номер счёта - "BLUE"%i\n"WHITE"Название счёта - "BLUE"%s\n"WHITE"Владелец - "BLUE"%s\n"WHITE"Сумма перевода - "GREEN"$%i\n\n"WHITE"Вы хотите перевести деньги на указанный счёт?\n\n",sscanf_id,temp_description,temp_owner,sscanf_money);
					ShowPlayerDialog(playerid,dBankAccountMenuTransferConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Перевести деньги на другой счёт",string,"Да","Нет");
					string="\0";
				}
				else{
                    ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"Перевести деньги на другой счёт","\n"RED"Указанный банковский счёт не найден!\n\n"WHITE"Введите номер счёта и сумму перевода через запятую\n\n"GREY"Пример: 12345,2000\n\n","Дальше","Назад");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
			}
			else{
                ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций","Выбрать","Выход");
			}
		}
		case dBankAccountMenuTransferConfirm:{
		    if(response){
		        new temp_owner[MAX_PLAYER_NAME];
		        GetPVarString(playerid,"tempBankAccountTransferOwner",temp_owner,sizeof(temp_owner));
		        if(!GetPVarInt(playerid,"tempBankAccountTransfer") || !GetPVarInt(playerid,"tempBankAccountTransferMoney") || !strlen(temp_owner)){
		            DeletePVar(playerid,"tempBankAccountTransfer");
			        DeletePVar(playerid,"tempBankAccountTransferMoney");
			        DeletePVar(playerid,"tempBankAccountTransferOwner");
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            return true;
		        }
				new temp_playerid;
				sscanf(temp_owner,"u",temp_playerid);
				if(GetPVarInt(temp_playerid,"PlayerLogged")){
				    new string[91-2-2+11+11];
				    format(string,sizeof(string),"[Информация] На ваш счёт было переведено "GREEN"$%i"BLUE". Номер счёта отправителя - %i",GetPVarInt(playerid,"tempBankAccountTransferMoney"),GetPVarInt(playerid,"tempBankAccount"));
				    SendClientMessage(temp_playerid,C_BLUE,string);
				}
				new query[103-2-2-2-2-2+11+11+11+16+11];
			    mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`+'%i'where`id`='%i'",GetPVarInt(playerid,"tempBankAccountTransferMoney"),GetPVarInt(playerid,"tempBankAccountTransfer"));
				mysql_query(mysql_connection,query,false);
				mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`-'%i'where`id`='%i'",GetPVarInt(playerid,"tempBankAccountTransferMoney"),GetPVarInt(playerid,"tempBankAccount"));
				mysql_query(mysql_connection,query,false);
				new temp_ip[16];
				GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
				mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','-%i','%e','%i')",GetPVarInt(playerid,"tempBankAccount"),FROM_ACCOUNT_TO_ACCOUNT,GetPVarInt(playerid,"tempBankAccountTransferMoney"),temp_ip,GetPVarInt(playerid,"tempBankAccountTransfer"));
				mysql_query(mysql_connection,query);
				mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','%i','%e','%i')",GetPVarInt(playerid,"tempBankAccountTransfer"),FROM_ACCOUNT_TO_ACCOUNT,GetPVarInt(playerid,"tempBankAccountTransferMoney"),temp_ip,GetPVarInt(playerid,"tempBankAccount"));
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы успешно перевели деньги на другой счёт!\n\n","Закрыть","");
				DeletePVar(playerid,"tempBankAccountTransfer");
		        DeletePVar(playerid,"tempBankAccountTransferMoney");
		        DeletePVar(playerid,"tempBankAccountTransferOwner");
		        DeletePVar(playerid,"tempBankAccount");
		        DeletePVar(playerid,"tempBankAccountMain");
		    }
		    else{
		        DeletePVar(playerid,"tempBankAccountTransfer");
		        DeletePVar(playerid,"tempBankAccountTransferMoney");
		        if(GetPVarInt(playerid,"tempBankAccountMain")){
					ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n"GREY"[5] Сделать счёт основным","Выбрать","Выход");
				}
				else{
                    ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n[5] Сделать счёт основным","Выбрать","Выход");
				}
		    }
		}
		case dBankAccountMenuWithdraw:{
		    if(response){
		        new sscanf_money;
		        if(sscanf(inputtext,"i",sscanf_money)){
		            ShowPlayerDialog(playerid,dBankAccountMenuWithdraw,DIALOG_STYLE_INPUT,""BLUE"Снять деньги со счёта","\n"WHITE"Введите сумму, которую вы хотите снять\n\n","Дальше","Назад");
		            return true;
		        }
				if(sscanf_money < 0){
					ShowPlayerDialog(playerid,dBankAccountMenuWithdraw,DIALOG_STYLE_INPUT,""BLUE"Снять деньги со счёта","\n"WHITE"Введите сумму, которую вы хотите снять\n\n","Дальше","Назад");
					return true;
				}
		        new query[103-2-2-2-2-2+11+11+11+16+11];
		        mysql_format(mysql_connection,query,sizeof(query),"select`money`from`bank_accounts`where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
		        new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
		        if(cache_get_row_count(mysql_connection)){
					new temp_money;
					temp_money=cache_get_field_content_int(0,"money",mysql_connection);
					if(temp_money<sscanf_money){
					    ShowPlayerDialog(playerid,dBankAccountMenuWithdraw,DIALOG_STYLE_INPUT,""BLUE"Снять деньги со счёта","\n"RED"На вашем счету нет столько средств!\n\n"WHITE"Введите сумму, которую вы хотите снять\n\n","Дальше","Назад");
					    return true;
					}
					mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`=`money`+'%i'where`id`='%i'",sscanf_money,player[playerid][id]);
					mysql_query(mysql_connection,query,false);
					mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`-'%i'where`id`='%i'",sscanf_money,GetPVarInt(playerid,"tempBankAccount"));
					mysql_query(mysql_connection,query,false);
					new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','-%i','%e','%i')",GetPVarInt(playerid,"tempBankAccount"),WITHDRAW_FROM_ACCOUNT,sscanf_money,temp_ip,player[playerid][id]);
					mysql_query(mysql_connection,query);
					player[playerid][money]+=sscanf_money;
					ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid,player[playerid][money]);
					new string[81-2-2+11+11];
					format(string,sizeof(string),"\n"WHITE"Вы сняли со счёта "GREEN"$%i\n"WHITE"Остаток счёта - "GREEN"$%i\n\n",sscanf_money,temp_money-sscanf_money);
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Снять деньги со счёта",string,"Закрыть","");
					DeletePVar(playerid,"tempBankAccount");
					DeletePVar(playerid,"tempBankAccountMain");
		        }
				else{
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
		    }
		    else{
                if(GetPVarInt(playerid,"tempBankAccountMain")){
					ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n"GREY"[5] Сделать счёт основным","Выбрать","Выход");
				}
				else{
                    ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n[5] Сделать счёт основным","Выбрать","Выход");
				}
		    }
		}
		case dBankAccountMenuDeposit:{
		    if(response){
		        new sscanf_money;
		        if(sscanf(inputtext,"i",sscanf_money)){
		            ShowPlayerDialog(playerid,dBankAccountMenuDeposit,DIALOG_STYLE_INPUT,""BLUE"Положить деньги на счёт","\n"WHITE"Введите сумму, которую хотите положить на счёт\n\n","Дальше","Назад");
		            return true;
		        }
		        if(player[playerid][money]<sscanf_money || sscanf_money < 0){
		            ShowPlayerDialog(playerid,dBankAccountMenuDeposit,DIALOG_STYLE_INPUT,""BLUE"Положить деньги на счёт","\n"RED"У вас нет столько средств на руках!\n\n"WHITE"Введите сумму, которую хотите положить на счёт\n\n","Дальше","Назад");
		            return true;
		        }
				new query[104-2-2-2-2-2+11+11+11+16+11];
				mysql_format(mysql_connection,query,sizeof(query),"select`money`from`bank_accounts`where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
				new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
				    new temp_money;
				    temp_money=cache_get_field_content_int(0,"money",mysql_connection);
					mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money]-sscanf_money,player[playerid][id]);
					mysql_query(mysql_connection,query,false);
					mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`+'%i'where`id`='%i'",sscanf_money,GetPVarInt(playerid,"tempBankAccount"));
					mysql_query(mysql_connection,query,false);
					new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','%i','%e','%i')",GetPVarInt(playerid,"tempBankAccount"),DEPOSIT_TO_ACCOUNT,sscanf_money,temp_ip,player[playerid][id]);
					mysql_query(mysql_connection,query);
					player[playerid][money]-=sscanf_money;
					ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid,player[playerid][money]);
					new string[86-2-2+11+11];
					format(string,sizeof(string),"\n"WHITE"Вы положили на счёт "GREEN"$%i\n"WHITE"Остаток на счёте - "GREEN"$%i\n\n",sscanf_money,temp_money+sscanf_money);
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Положить деньги на счёт",string,"Закрыть","");
					DeletePVar(playerid,"tempBankAccount");
					DeletePVar(playerid,"tempBankAccountMain");
				}
				else{
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
		    }
		    else{
                if(GetPVarInt(playerid,"tempBankAccountMain")){
					ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n"GREY"[5] Сделать счёт основным","Выбрать","Выход");
				}
				else{
                    ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] Информация о счёте\n[1] Перевести деньги на другой счёт\n[2] Снять деньги со счёта\n[3] Положить деньги на счёт\n[4] История транзакций\n[5] Сделать счёт основным","Выбрать","Выход");
				}
		    }
		}
		case dCityHallInf:{
		    if(response){
		        switch(listitem){
		            case 0:{
		                new Float:temp_x,Float:temp_y,Float:temp_z;
		                GetPlayerPos(playerid,temp_x,temp_y,temp_z);
		                InterpolateCameraPos(playerid,temp_x,temp_y,temp_z,1489.6252,-1789.3142,1009.5559,3000);
						InterpolateCameraLookAt(playerid,temp_x,temp_y,temp_z,1485.6642,-1791.5790,1009.5559,2500);
		                ShowPlayerDialog(playerid,dCityHallInfPassport,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Паспорт можно получить пройдя в этот кабинет\n\n","Закрыть","");
		            }
					case 1:{
					    new Float:temp_x,Float:temp_y,Float:temp_z;
					    GetPlayerPos(playerid,temp_x,temp_y,temp_z);
					    InterpolateCameraPos(playerid,temp_x,temp_y,temp_z,1490.5195,-1760.0215,1009.5559,3000);
						InterpolateCameraLookAt(playerid,temp_x,temp_y,temp_z,1488.1479,-1758.4341,1009.5559,2500);
		                ShowPlayerDialog(playerid,dCityHallInfPassport,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Разрешение на постройку дома можно получить пройдя в этот кабинет\n\n","Закрыть","");
					}
		        }
		    }
		}
		case dCityHallInfPassport:{
		    if(response || !response){
		        SetCameraBehindPlayer(playerid);
		    }
		}
		case dCityHallTakePassport:{
		    if(response){
		        ShowPlayerDialog(playerid,dCityHallTakePassportBirthday,DIALOG_STYLE_INPUT,""BLUE"Получение паспорта","\n"WHITE"Укажите дату рождения вашего персонажа\n\n"GREY"Пример: 25/05/1999\n\n","Далее","Отмена");
		    }
		}
		case dCityHallTakePassportBirthday:{
		    if(response){
		        new sscanf_day,sscanf_month,sscanf_year;
				if(sscanf(inputtext,"p</>iii",sscanf_day,sscanf_month,sscanf_year)){
                    ShowPlayerDialog(playerid,dCityHallTakePassportBirthday,DIALOG_STYLE_INPUT,""BLUE"Получение паспорта","\n"WHITE"Укажите дату рождения вашего персонажа\n\n"GREY"Пример: 25/05/1999\n\n","Далее","Отмена");
				    return true;
				}
				new temp_day,temp_month,temp_year;
				getdate(temp_year,temp_month,temp_day);
				if(temp_year-sscanf_year > 100 || sscanf_year < 1 || sscanf_year >= temp_year || temp_year-sscanf_year < 16){
				    ShowPlayerDialog(playerid,dCityHallTakePassportBirthday,DIALOG_STYLE_INPUT,""BLUE"Получение паспорта","\n"WHITE"Укажите дату рождения вашего персонажа\n\n"GREY"Пример: 25/05/1999\n\n","Далее","Отмена");
				    return true;
				}
				new temp_age=temp_year-sscanf_year;
				if(sscanf_month > temp_month){
				    temp_age--;
				}
				else if(sscanf_month == temp_month && sscanf_day > temp_day){
				    temp_age--;
				}
				new temp_date[24];
				format(temp_date,sizeof(temp_date),"%i/%i/%i",sscanf_day,sscanf_month,sscanf_year);
				SetPVarString(playerid,"passportDate",temp_date);
				SetPVarInt(playerid,"passportAge",temp_age);
				ShowPlayerDialog(playerid,dCityHallTakePassportSignature,DIALOG_STYLE_INPUT,""BLUE"Получение паспорта","\n"WHITE"Вам нужно придумать подпись\n\n"GREY"Примечание: она будет использоваться в договорах\nтолько латинские буквы без пробелов\n\n","Дальше","Отмена");
		    }
		}
		case dCityHallTakePassportSignature:{
		    if(response){
		        new sscanf_signature[16];
		        if(sscanf(inputtext,"s[128]",sscanf_signature) || strlen(inputtext)>16 || !regex_match(inputtext,"[a-zA-Z]+")){
		            ShowPlayerDialog(playerid,dCityHallTakePassportSignature,DIALOG_STYLE_INPUT,""BLUE"Получение паспорта","\n"WHITE"Вам нужно придумать подпись\n\n"GREY"Примечание: она будет использоваться в договорах\nтолько латинские буквы без пробелов\n\n","Дальше","Отмена");
		            return true;
		        }
				SetPVarString(playerid,"passportSignature",sscanf_signature);
				ShowPlayerDialog(playerid,dCityHallTakePassportValidality,DIALOG_STYLE_INPUT,""BLUE"Получение паспорта","\n"WHITE"На какой срок(дни) вы хотите приобрести паспорт?\n\n","Дальше","Отмена");
		    }
		    else{
				DeletePVar(playerid,"passportAge");
		    }
		}
		case dCityHallTakePassportValidality:{
		    if(response){
		        new sscanf_days;
		        if(sscanf(inputtext,"i",sscanf_days)){
		            ShowPlayerDialog(playerid,dCityHallTakePassportValidality,DIALOG_STYLE_INPUT,""BLUE"Получение паспорта","\n"WHITE"На какой срок(дни) вы хотите приобрести паспорт?\n\n","Дальше","Отмена");
		            return true;
		        }
		        new temp_validality=gettime()+(SECONDS_IN_DAY*sscanf_days)+(3600*3);
		        SetPVarInt(playerid,"passportDays",sscanf_days);
				SetPVarInt(playerid,"passportValidality",temp_validality);
				new temp_signature[16];
				GetPVarString(playerid,"passportSignature",temp_signature,sizeof(temp_signature));
				new temp_date[12];
				GetPVarString(playerid,"passportDate",temp_date,sizeof(temp_date));
				new string[122-2-2-2-2+sizeof(temp_date)+2+sizeof(temp_signature)+32];
				format(string,sizeof(string),"\n"WHITE"Дата рождения - "BLUE"%s "GREY"(%i)\n"WHITE"Подпись - "BLUE"%s\n"WHITE"Действителен до - "BLUE"%s\n\n"WHITE"Вы хотите оплатить пошлину?\n\n",temp_date,GetPVarInt(playerid,"passportAge"),temp_signature,gettimestamp(temp_validality,1));
				ShowPlayerDialog(playerid,dCityHallTakePassportConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Получение паспорта",string,"Да","Нет");
		    }
		    else{
                DeletePVar(playerid,"passportAge");
                DeletePVar(playerid,"passportSignature");
                DeletePVar(playerid,"passportDate");
		    }
		}
		case dCityHallTakePassportConfirm:{
		    if(response){
		        SetPVarInt(playerid,"PayFeeForPassport",1);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"","\n"WHITE"Вам нужно оплатить пошлину на получение паспорта в банке!\n\n","Закрыть","");
		    }
		    else{
                DeletePVar(playerid,"passportAge");
                DeletePVar(playerid,"passportSignature");
                DeletePVar(playerid,"passportDate");
                DeletePVar(playerid,"passportValidality");
                DeletePVar(playerid,"passportDays");
		    }
		}
		case dBankPaymentService:{
		    if(response){
		        switch(listitem){
		            case 0:{
						if(GetPVarInt(playerid,"PayFeeForPassport")!=1 || !GetPVarInt(playerid,"passportValidality")){
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\nВы не подавали заявку на оплату пошлины за паспорт!\n\n","Закрыть","");
						    return true;
						}
						SetPVarInt(playerid,"TotalFeeForPassport",GetSVarInt("sFeeForPassport")*GetPVarInt(playerid,"passportDays"));
						new string[89-2+6];
						format(string,sizeof(string),"\n"WHITE"Вам нужно оплатить "GREEN"$%i"WHITE" за получение паспорта\nВы согласны?\n\n",GetPVarInt(playerid,"TotalFeeForPassport"));
						ShowPlayerDialog(playerid,dBankPaymentServiceTakePassport,DIALOG_STYLE_MSGBOX,""BLUE"Оплата пошлины за паспорт",string,"Да","Нет");
		            }
					case 1:{
					    if(GetPVarInt(playerid,"PayFeeForPassport")!=2 || !GetPVarInt(playerid,"renewalPassportValidality") || !GetPVarInt(playerid,"renewalPassportDays")){
					        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы не подавали заявку на оплату пошлины за продление паспорта!\n\n","Закрыть","");
					        return true;
					    }
					    SetPVarInt(playerid,"TotalFeeForRenewalPassport",GetSVarInt("sFeeForPassport")*GetPVarInt(playerid,"renewalPassportDays"));
					    new string[87-2+6];
					    format(string,sizeof(string),"\n"WHITE"Вам нужно оплатить "GREEN"$%i"WHITE" за продление паспорта!\nВы согласны?\n\n",GetPVarInt(playerid,"TotalFeeForRenewalPassport"));
					    ShowPlayerDialog(playerid,dBankPaymentServiceRePassport,DIALOG_STYLE_MSGBOX,""BLUE"Оплата пошлины за продление паспорта",string,"Да","Нет");
					}
				}
		    }
		}
		case dBankPaymentServiceTakePassport:{
		    if(response){
		        if(GetPVarInt(playerid,"PayFeeForPassport")!=1 || !GetPVarInt(playerid,"passportValidality") || !GetPVarInt(playerid,"TotalFeeForPassport") || !GetPVarInt(playerid,"passportDays")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка\n\n","Закрыть","");
		            return true;
		        }
		        if(player[playerid][money]<GetPVarInt(playerid,"TotalFeeForPassport")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Информация","\n"WHITE"У вас недостаточно денег!\n\n","Закрыть","");
		            return true;
		        }
				player[playerid][money]-=GetPVarInt(playerid,"TotalFeeForPassport");
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				new query[105-2-2-2-2+MAX_PLAYER_NAME+16+16+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				new temp_birthday[16];
				GetPVarString(playerid,"passportDate",temp_birthday,sizeof(temp_birthday));
				new temp_signature[16];
				GetPVarString(playerid,"passportSignature",temp_signature,sizeof(temp_signature));
				mysql_format(mysql_connection,query,sizeof(query),"insert into`passports`(`owner`,`taken`,`birthday`,`signature`,`valid_to`)values('%e','0','%e','%e','%i')",player[playerid][name],temp_birthday,temp_signature,GetPVarInt(playerid,"passportValidality"));
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Получение паспорта","\n"WHITE"Вам нужно вернуться в мэрию, для получения паспорта!\n\n","Закрыть","");
		    }
		}
		case dBankPaymentServiceRePassport:{
		    if(response){
		        if(GetPVarInt(playerid,"PayFeeForPassport")!=2 || !GetPVarInt(playerid,"renewalPassportValidality") || !GetPVarInt(playerid,"TotalFeeForRenewalPassport") || !GetPVarInt(playerid,"renewalPassportDays")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка\n\n","Закрыть","");
		            return true;
		        }
		        if(player[playerid][money]<GetPVarInt(playerid,"TotalFeeForRenewalPassport")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Информация","\n"WHITE"У вас недостаточно денег!\n\n","Закрыть","");
		            return true;
		        }
		        player[playerid][money]-=GetPVarInt(playerid,"TotalFeeForRenewalPassport");
		        ResetPlayerMoney(playerid);
		        GivePlayerMoney(playerid,player[playerid][money]);
		        new query[50-2-2+11+11];
		        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
		        mysql_query(mysql_connection,query,false);
				mysql_format(mysql_connection,query,sizeof(query),"update`passports`set`valid_to`='%i'where`id`='%i'",GetPVarInt(playerid,"renewalPassportValidTo"),player[playerid][passport_id]);
				mysql_query(mysql_connection,query,false);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы продлили срок действия паспорта!\n\n","Закрыть","");
				DeletePVar(playerid,"PayFeeForPassport");
				DeletePVar(playerid,"renewalPassportValidality");
				DeletePVar(playerid,"TotalFeeForRenewalPassport");
				DeletePVar(playerid,"renewalPassportDays");
				DeletePVar(playerid,"renewalPassportValidTo");
		    }
		}
		case dCityHallRenewalPassport:{
			if(response){
				ShowPlayerDialog(playerid,dCityHallRenewalPassportValid,DIALOG_STYLE_INPUT,""BLUE"Продление паспорта","\n"WHITE"На какой срок(дни) вы хотите продлить паспорт?\n\n","Дальше","Отмена");
				return true;
			}
		}
		case dCityHallRenewalPassportValid:{
			if(response){
			    if(!GetPVarInt(playerid,"renewalPassportValidality")){
			        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
					return true;
		        }
			    new sscanf_days;
			    if(sscanf(inputtext,"i",sscanf_days)){
			        ShowPlayerDialog(playerid,dCityHallRenewalPassportValid,DIALOG_STYLE_INPUT,""BLUE"Продление паспорта","\n"WHITE"На какой срок(дни) вы хотите продлить паспорт?\n\n","Дальше","Отмена");
			        return true;
				}
				SetPVarInt(playerid,"renewalPassportDays",sscanf_days);
				new renewal_valid_to=gettime()+(SECONDS_IN_DAY*sscanf_days);
				new string[52-2+31];
				format(string,sizeof(string),"\n"WHITE"Паспорт будет продлён до - "BLUE"%s\n\n",gettimestamp(renewal_valid_to));
				ShowPlayerDialog(playerid,dCityHallRenewalPassportConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Продление паспорта",string,"Дальше","Отмена");
				SetPVarInt(playerid,"renewalPassportValidTo",renewal_valid_to);
			}
			else{
			    DeletePVar(playerid,"renewalPassportValidality");
			}
		}
		case dCityHallRenewalPassportConfirm:{
		    if(response){
		        if(!GetPVarInt(playerid,"renewalPassportValidality") || !GetPVarInt(playerid,"renewalPassportValidTo")){
			        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
					return true;
		        }
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Продление паспорта","\n"WHITE"Вам нужно оплатить пошлину в банке!\n\n","Закрыть","");
				SetPVarInt(playerid,"PayFeeForPassport",2);
		    }
		    else{
                DeletePVar(playerid,"renewalPassportValidality");
                DeletePVar(playerid,"renewalPassportValidTo");
                DeletePVar(playerid,"renewalPassportDays");
		    }
		}
		case dCityHallDelOrRenewalPassport:{
		    if(response){
                ShowPlayerDialog(playerid,dCityHallRenewalPassportValid,DIALOG_STYLE_INPUT,""BLUE"Продление паспорта","\n"WHITE"На какой срок(дни) вы хотите продлить паспорт?\n\n","Дальше","Отмена");
		    }
			else{
			    new query[48-2+11];
		        mysql_format(mysql_connection,query,sizeof(query),"delete from`passports`where`id`='%i'",player[playerid][passport_id]);
		        mysql_query(mysql_connection,query,false);
		        player[playerid][passport_id]=0;
		        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`passport_id`='0'where`id`='%i'",player[playerid][id]);
		        mysql_query(mysql_connection,query,false);
		        ShowPlayerDialog(playerid,dCityHallTakePassport,DIALOG_STYLE_MSGBOX,""BLUE"Получение паспорта","\n"WHITE"Для получения паспорта, необходимо заполнить некоторые данные\nВы хотите продолжить?\n\n","Да","Нет");
			}
		}
		case dDescription:{
		    if(response){
		        switch(listitem){
		            case 0:{
						ShowPlayerDialog(playerid,dDescriptionTempDesc,DIALOG_STYLE_INPUT,""BLUE"Временное описание","\n"WHITE"Введите текст, который будет отображаться на персонаже\n\n","Далее","Назад");
		            }
		            case 1:{
                        ShowPlayerDialog(playerid,dDescriptionSaveDesc,DIALOG_STYLE_INPUT,""BLUE"Сохранить и прикрепить описание","\n"WHITE"Введите текст, который будет отображаться на персонаже\n\n"GREY"Примечание: оно будет сохранено\n\n","Далее","Назад");
		            }
		            case 2:{
		                if(!strcmp(player[playerid][description],"-") || !strlen(player[playerid][description])){
		                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"У вас нет сохранённого описания персонажа!\n\n","Закрыть","");
		                    return true;
		                }
		                if(attached_3dtext[playerid]){
							Update3DTextLabelText(attach_3dtext_labelid[playerid],C_WHITE,player[playerid][description]);
						}
						else{
						    attach_3dtext_labelid[playerid]=Create3DTextLabel(player[playerid][description],C_WHITE,0.0,0.0,0.0,15.0,0,1);
						    Attach3DTextLabelToPlayer(attach_3dtext_labelid[playerid],playerid,0.0,0.0,-0.5);
						    attached_3dtext[playerid]=true;
						}
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы прикрепили сохранённое описание!\n\n","Закрыть","");
		            }
		            case 3:{
		                new string[75-2+64];
		                format(string,sizeof(string),"\n"WHITE"Введите новое описание персонажа\nТекущее описание - "BLUE"%s\n\n",player[playerid][description]);
		                ShowPlayerDialog(playerid,dDescriptionEditDesc,DIALOG_STYLE_INPUT,""BLUE"Изменить описание",string,"Дальше","Назад");
		            }
		            case 4:{
		                if(attached_3dtext[playerid]){
							Delete3DTextLabel(attach_3dtext_labelid[playerid]);
		                    attached_3dtext[playerid]=false;
		                }
						cmd::description(playerid);
		            }
		        }
		    }
		}
		case dDescriptionTempDesc:{
		    if(response){
				new sscanf_description[64];
				if(sscanf(inputtext,"s[128]",sscanf_description) || strlen(inputtext)<5){
				    ShowPlayerDialog(playerid,dDescriptionTempDesc,DIALOG_STYLE_INPUT,""BLUE"Временное описание","\n"WHITE"Введите текст, который будет отображаться на персонаже\n\n","Далее","Назад");
				    return true;
				}
	           	if(attached_3dtext[playerid]){
					Update3DTextLabelText(attach_3dtext_labelid[playerid],C_WHITE,sscanf_description);
				}
				else{
				    attach_3dtext_labelid[playerid]=Create3DTextLabel(sscanf_description,C_WHITE,0.0,0.0,0.0,15.0,0,1);
				    Attach3DTextLabelToPlayer(attach_3dtext_labelid[playerid],playerid,0.0,0.0,-0.5);
				    attached_3dtext[playerid]=true;
				}
		    }
		    else{
		        cmd::description(playerid);
		    }
		}
		case dDescriptionSaveDesc:{
		    if(response){
		        new sscanf_description[64];
		        if(sscanf(inputtext,"s[128]",sscanf_description) || strlen(inputtext)<5){
		            ShowPlayerDialog(playerid,dDescriptionSaveDesc,DIALOG_STYLE_INPUT,""BLUE"Сохранить и прикрепить описание","\n"WHITE"Введите текст, который будет отображаться на персонаже\n\n"GREY"Примечание: оно будет сохранено\n\n","Далее","Назад");
		            return true;
		        }
		        new query[49-2-2+64+11];
		        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`description`='%e'where`id`='%i'",sscanf_description,player[playerid][id]);
		        mysql_query(mysql_connection,query,false);
				strins(player[playerid][description],sscanf_description,0);
	           	if(attached_3dtext[playerid]){
					Update3DTextLabelText(attach_3dtext_labelid[playerid],C_WHITE,player[playerid][description]);
				}
				else{
				    attach_3dtext_labelid[playerid]=Create3DTextLabel(player[playerid][description],C_WHITE,0.0,0.0,0.0,15.0,0,1);
				    Attach3DTextLabelToPlayer(attach_3dtext_labelid[playerid],playerid,0.0,0.0,-0.5);
				    attached_3dtext[playerid]=true;
				}
		    }
		    else{
    			cmd::description(playerid);
		    }
		}
		case dDescriptionEditDesc:{
		    if(response){
		        new sscanf_description[64];
		        if(sscanf(inputtext,"s[128]",sscanf_description) || strlen(sscanf_description)<5){
                    new string[75-2+64];
	                format(string,sizeof(string),"\n"WHITE"Введите новое описание персонажа\nТекущее описание - "BLUE"%s\n\n",player[playerid][description]);
	                ShowPlayerDialog(playerid,dDescriptionEditDesc,DIALOG_STYLE_INPUT,""BLUE"Изменить описание",string,"Дальше","Назад");
		            return true;
		        }
		        new query[49-2-2+64+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`description`='%e'where`id`='%i'",sscanf_description,player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				strins(player[playerid][description],sscanf_description,0);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы изменили описание персонажа!\n\n","Закрыть","");
		    }
		    else{
		        cmd::description(playerid);
		    }
		}
		case dInviteConfirm:{
		    if(response){
		        player[playerid][faction_id]=GetPVarInt(playerid,"inviteFactionId");
		        player[playerid][rank_id]=1;
		        new query[62-2-2+2+11];
		        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`faction_id`='%i',`rank_id`='1'where`id`='%i'",player[playerid][faction_id],player[playerid][id]);
		        mysql_query(mysql_connection,query,false);
		        new string[70-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME];
		        new player_id=GetPVarInt(playerid,"invitePlayerId");
		        format(string,sizeof(string),"[F] "WHITE"%s"BLUE" пригласил игрока "WHITE"%s"BLUE" во фракцию",player[player_id][name],player[playerid][name]);
		        SendFactionMessage(player[player_id][faction_id],C_BLUE,string);
		        DeletePVar(playerid,"invitePlayerId");
		        DeletePVar(playerid,"inviteFactionId");
		    }
		    else{
		        DeletePVar(playerid,"invitePlayerId");
		        DeletePVar(playerid,"inviteFactionId");
		    }
		}
		case dMakeleader:{
		    if(response){
				new temp_playerid=GetPVarInt(playerid,"makeleaderPlayerId");
				new string[68-2-2+MAX_PLAYER_NAME+32];
				new query[47-2-2+MAX_PLAYER_NAME+2];
				for(new i=0; i<total_factions; i++){
				    if(!strcmp(faction[i][leader],player[temp_playerid][name])){
				        format(string,sizeof(string),"%s был снят с поста лидера!",player[temp_playerid][name]);
				        SendClientMessage(playerid,C_WHITE,string);
						SendClientMessage(temp_playerid,C_BLUE,"Вы были сняты с поста лидера!");
						strdel(faction[i][leader],0,MAX_PLAYER_NAME);
						mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`leader`='-'where`id`='%i'",i+1);
						mysql_query(mysql_connection,query,false);
				        break;
				    }
				}
				player[temp_playerid][faction_id]=listitem+1;
				player[temp_playerid][rank_id]=11;
				strdel(faction[listitem][leader],0,MAX_PLAYER_NAME);
				strins(faction[listitem][leader],player[temp_playerid][name],0);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`faction_id`='%i',`rank_id`='11'where`id`='%i'",player[temp_playerid][faction_id],player[temp_playerid][id]);
				mysql_query(mysql_connection,query,false);
				mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`leader`='%e'where`id`='%i'",player[temp_playerid][name],listitem+1);
				mysql_query(mysql_connection,query,false);
				format(string,sizeof(string),"Вы были назначены лидером фракции - "WHITE"%s",faction[listitem][name]);
				SendClientMessage(temp_playerid,C_BLUE,string);
				format(string,sizeof(string),"Вы назначили игрока "WHITE"%s"BLUE" лидером фракции - "WHITE"%s",player[temp_playerid][name],faction[listitem][name]);
				SendClientMessage(playerid,C_BLUE,string);
				DeletePVar(playerid,"makeleaderPlayerId");
		    }
		    else{
				DeletePVar(playerid,"makeleaderPlayerId");
		    }
		}
		case dGiveaccess:{
		    if(response){
				if(!GetPVarInt(playerid,"IsPlayerDeveloper")){
				    return true;
				}
				new temp_playerid=GetPVarInt(playerid,"giveaccessPlayerId");
				new string[75-2-2+MAX_PLAYER_NAME+16];
				new temp_string[45-2+16];
				if(admin[temp_playerid][commands][listitem]){
				    format(string,sizeof(string),"Вы забрали доступ к команде "WHITE"(%s)"BLUE" Администратору "WHITE"%s",admin_commands[listitem],player[temp_playerid][name]);
				    format(temp_string,sizeof(string),"У вас забрали доступ к команде "WHITE"(%s)",admin_commands[listitem]);
				    admin[temp_playerid][commands][listitem]=0;
				}
				else{
				    format(string,sizeof(string),"Вы выдали доступ к команде "WHITE"(%s)"BLUE" Администратору "WHITE"%s",admin_commands[listitem],player[temp_playerid][name]);
				    format(temp_string,sizeof(string),"Вам выдали доступ к команде "WHITE"(%s)",admin_commands[listitem]);
				    admin[temp_playerid][commands][listitem]=1;
				}
				SendClientMessage(playerid,C_BLUE,string);
				SendClientMessage(temp_playerid,C_BLUE,temp_string);
				new temp_commands_ex[4];
				new temp_commands[sizeof(temp_commands_ex)*MAX_ADMIN_COMMANDS];
				for(new i=0; i<MAX_ADMIN_COMMANDS; i++){
				    format(temp_commands_ex,sizeof(temp_commands_ex),(i==MAX_ADMIN_COMMANDS-1)?"%i":"%i|",admin[temp_playerid][commands][i]);
				    strcat(temp_commands,temp_commands_ex);
				}
				new query[46-2-2+sizeof(temp_commands)+2];
				mysql_format(mysql_connection,query,sizeof(query),"update`admins`set`commands`='%s'where`id`='%i'",temp_commands,admin[temp_playerid][id]);
				mysql_query(mysql_connection,query,false);
	            DeletePVar(playerid,"giveaccessPlayerId");
		    }
		    else{
                DeletePVar(playerid,"giveaccessPlayerId");
		    }
		}
		case dFind:{
		    if(response){
		        if(!admin[playerid][commands][FIND]){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            return true;
		        }
		        new temp_string[23-2-2-2+MAX_PLAYER_NAME+3+24];
		        static string[sizeof(temp_string)*MAX_FACTIONS];
		        foreach(new i:Player){
		            if(GetPVarInt(i,"PlayerLogged") && player[i][faction_id] == listitem+1){
		                format(temp_string,sizeof(temp_string),""WHITE"%s [%i] - %s\n",player[i][name],i,faction_ranks[listitem][player[i][rank_id]-1]);
		                strcat(string,temp_string);
		            }
		        }
		        if(!strlen(string)){
				    strcat(string,"\n"WHITE"Нет участников фракции онлайн!\n\n");
				}
		        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Участники фракции онлайн",string,"Закрыть","");
		        string="\0";
		    }
		}
		case dAdminPasswordCreate:{
 			if(response){
		        new sscanf_password[16];
				if(sscanf(inputtext,"s[128]",sscanf_password) || strlen(inputtext)<4 || strlen(inputtext)>16){
				    ShowPlayerDialog(playerid,dAdminPasswordCreate,DIALOG_STYLE_INPUT,""BLUE"Установка пароля Администратора","\n"WHITE"Введите желаемый пароль для авторизации в админ-панели\n\n","Дальше","Выход");
				    return true;
				}
				new query[47-2-2+16+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`admins`set`password`='%e'where`id`='%i'",sscanf_password,admin[playerid][id]);
				mysql_query(mysql_connection,query,false);
				SendClientMessage(playerid,C_GREEN,"Вы установили пароль для авторизации в админ-панели!");
				SendClientMessage(playerid,C_GREEN,"Вам необходимо перезайти на сервер!");
				SetTimerEx("kick_player",200,false,"i",playerid);
		    }
		    else{
		        SetTimerEx("kick_player",200,false,"i",playerid);
		    }
		}
		case dAdminPasswordInput:{
		    if(response){
		        new sscanf_password[16];
		        if(sscanf(inputtext,"s[128]",sscanf_password)){
		            ShowPlayerDialog(playerid,dAdminPasswordInput,DIALOG_STYLE_INPUT,""BLUE"Авторизация в админ-панели","\n"WHITE"Введите пароль для авторизации в админ-панели\n\n","Дальше","Выход");
		            return true;
		        }
		        if(!strcmp(sscanf_password,admin[playerid][password])){
			        if(!strcmp(player[playerid][name],DEVELOPER)){
					    SendClientMessage(playerid,C_BLUE,"Вы авторизовались как Разработчик сервера!");
					    SetPVarInt(playerid,"IsPlayerDeveloper",1);
					}
					else{
						SendClientMessage(playerid,C_BLUE,"Вы авторизовались как Администратор сервера!");
					}
					new string[61+25+25];
					format(string,sizeof(string),"[0] Обычный спавн\n[1] Спавн фракции %s\n[2] Спавн в доме %s",(player[playerid][faction_id]?""GREEN"[ доступно ]":""RED"[ не доступно ]"),(owned_house_id[playerid][0]?""GREEN"[ доступно ]":""RED"[ не доступно ]"));
					ShowPlayerDialog(playerid,dAuthorizationSpawn,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","");
				}
				else{
				    SendClientMessage(playerid,C_RED,"[Информация] Вы ввели неправильный пароль для авторизации в админ-панели!");
                    SetTimerEx("kick_player",200,false,"i",playerid);
				}
		    }
		    else{
                SetTimerEx("kick_player",200,false,"i",playerid);
		    }
		}
		case dHome:{
		    if(response){
          		new cmdtext[9-2+3];
          		DeletePVar(playerid,"command_time");
	            format(cmdtext,sizeof(cmdtext),"/home %i",listitem);
				DC_CMD(playerid,cmdtext);
		    }
		}
		case dHomeMenu:{
		    if(response){
		        new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSelectedHouseid")];
				if(!houseid){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    DeletePVar(playerid,"tempSelectedHouseid");
				    return true;
				}
		        switch(listitem){
		            case 0:{
		                new string[77-2-2+4+11];
		                format(string,sizeof(string),"\n"WHITE"Номер дома - "BLUE"%i\n\n"WHITE"Государственная цена - "BLUE"%i\n\n",houseid,house[houseid-1][cost]);
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация о доме",string,"Закрыть","");
		            }
		            case 1:{
		                house[houseid-1][locked]=house[houseid-1][locked]?0:1;
		                new query[45-2-2+1+4];
		                mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`locked`='%i'where`id`='%i'",house[houseid-1][locked],houseid);
		                mysql_query(mysql_connection,query,false);
		                new cmdtext[9-2+3];
		                DeletePVar(playerid,"command_time");
			            format(cmdtext,sizeof(cmdtext),"/home %i",GetPVarInt(playerid,"tempSelectedHouseid"));
			            DC_CMD(playerid,cmdtext);
		            }
		            case 2:{
                        ShowPlayerDialog(playerid,dSellhomeSelect,DIALOG_STYLE_LIST,""BLUE"Продать дом","[0] Продать дом игроку\n[1] Продать дом государству","Выбрать","Отмена");
		            }
		        }
		    }
		    else{
		        DeletePVar(playerid,"tempSelectedHouseid");
		    }
		}
		case dSellhomeSelect:{
		    new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSelectedHouseid")];
			if(!houseid){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			    DeletePVar(playerid,"tempSelectedHouseid");
			    return true;
			}
		    if(response){
		        switch(listitem){
		            case 0:{
		                ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"Продать дом игроку","\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            }
		            case 1:{
						new string[81-2+11];
						format(string,sizeof(string),"\n"WHITE"Вы хотите продать дом государству?\n\nГос. цена дома - "GREEN"$%i\n\n",house[houseid-1][cost]);
						ShowPlayerDialog(playerid,dSellhomeState,DIALOG_STYLE_MSGBOX,""BLUE"Продать дом государству",string,"Да","Нет");
		            }
		        }
		    }
		    else{
		        new cmdtext[9-2+3];
		        DeletePVar(playerid,"command_time");
	            format(cmdtext,sizeof(cmdtext),"/home %i",GetPVarInt(playerid,"tempSelectedHouseid"));
	            DC_CMD(playerid,cmdtext);
		    }
		}
		case dSellhomeWhom:{
		    new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSelectedHouseid")];
			if(!houseid){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			    DeletePVar(playerid,"tempSelectedHouseid");
			    return true;
			}
		    if(response){
		        new sscanf_player, sscanf_cost;
		        if(sscanf(inputtext,"p<,>ui",sscanf_player,sscanf_cost)){
		            ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"Продать дом игроку","\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            return true;
		        }
		        if(!GetPVarInt(sscanf_player,"PlayerLogged")){
				    ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"Продать дом игроку","\n"RED"Игрок не подключен к серверу!\n\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
				    return true;
				}
				if(owned_house_id[sscanf_player][MAX_OWNED_HOUSES-1]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Игрок владеет максимальным количеством домов!\n\n","Закрыть","");
				    return true;
				}
		        if(sscanf_cost < 1 || sscanf_cost > 1000000){
		            ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"Продать дом игроку","\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            return true;
		        }
		        if(sscanf_cost > player[sscanf_player][money]){
		            ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"Продать дом игроку","\n"RED"У игрока нет столько денег!\n\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            return true;
		        }
		        SetPVarInt(playerid,"tempSellhomePlayer",sscanf_player);
		        SetPVarInt(playerid,"tempSellhomeCost",sscanf_cost);
		        new string[135-2-2+MAX_PLAYER_NAME+4];
		        format(string,sizeof(string),"\n"WHITE"Вы собираетесь продать свой дом игроку "BLUE"%s"WHITE" за "GREEN"$%i\n\n"WHITE"Вы действительно хотите продать дом?\n\n",player[sscanf_player][name],sscanf_cost);
		        ShowPlayerDialog(playerid,dSellhomeWhomConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Продажа дома игроку",string,"Да","Нет");
		    }
		}
		case dSellhomeWhomConfirm:{
		    new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSelectedHouseid")];
			if(!houseid){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			    DeletePVar(playerid,"tempSelectedHouseid");
			    return true;
			}
		    if(response){
		        if(!GetPVarInt(playerid,"tempSellhomeCost")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            DeletePVar(playerid,"tempSellhomePlayer");
					DeletePVar(playerid,"tempSellhomeCost");
		            return true;
		        }
				new player_id=GetPVarInt(playerid,"tempSellhomePlayer");
				if(!GetPVarInt(player_id,"PlayerLogged")){
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Сделка была сорвана!\nИгрок вышел из игры!\n\n","Закрыть","");
					DeletePVar(playerid,"tempSellhomePlayer");
					DeletePVar(playerid,"tempSellhomeCost");
				    return true;
				}
				if(owned_house_id[player_id][MAX_OWNED_HOUSES-1]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Игрок владеет максимальным количеством домов!\n\n","Закрыть","");
				    DeletePVar(playerid,"tempSellhomePlayer");
					DeletePVar(playerid,"tempSellhomeCost");
				    return true;
				}
				SetPVarInt(player_id,"tempSellhomePlayerid",playerid);
				new string[113-2-2-2+MAX_PLAYER_NAME+4+11];
				format(string,sizeof(string),"\n"BLUE"%s"WHITE" предлагает вам купить его дом "BLUE"№%i"WHITE" за "GREEN"$%i\n\n"WHITE"Вы согласны?\n\n",player[playerid][name],houseid,GetPVarInt(playerid,"tempSellhomeCost"));
				ShowPlayerDialog(player_id,dSellhomeWhomConfirmPlayer,DIALOG_STYLE_MSGBOX,""BLUE"Продажа дома",string,"Да","Нет");
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Продажа дома","\n"WHITE"Заявка на покупку дома другому игроку отправлена!\n\n","Закрыть","");
		    }
		    else{
				DeletePVar(playerid,"tempSellhomePlayer");
				DeletePVar(playerid,"tempSellhomeCost");
		    }
		}
		case dSellhomeWhomConfirmPlayer:{
		    new player_id=GetPVarInt(playerid,"tempSellhomePlayerid");
		    new houseid=owned_house_id[player_id][GetPVarInt(player_id,"tempSelectedHouseid")];
			if(!houseid){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			    DeletePVar(playerid,"tempSelectedHouseid");
			    return true;
			}
		    if(response){
				if(!GetPVarInt(player_id,"tempSellhomeCost") || !GetPVarInt(playerid,"PlayerLogged") || !GetPVarInt(player_id,"PlayerLogged")){
                    DeletePVar(playerid,"tempSellhomePlayerid");
	                DeletePVar(player_id,"tempSellhomePlayer");
					DeletePVar(player_id,"tempSellhomeCost");
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    ShowPlayerDialog(player_id,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    return true;
				}
				new string[75-2-2+MAX_PLAYER_NAME+11];
				format(string,sizeof(string),"\n"WHITE"Вы купили дом у игрока "BLUE"%s"WHITE" за "GREEN"$%i\n\n",player[player_id][name],GetPVarInt(player_id,"tempSellhomeCost"));
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация",string,"Закрыть","");
				format(string,sizeof(string),"\n"WHITE"Вы продали свой дом игроку "BLUE"%s"WHITE" за "GREEN"$%i\n\n",player[playerid][name],GetPVarInt(player_id,"tempSellhomeCost"));
				ShowPlayerDialog(player_id,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация",string,"Закрыть","");
                strmid(house[houseid-1][owner],player[playerid][name],0,strlen(player[playerid][name]));
				new query[44-2-2+MAX_PLAYER_NAME+4];
				mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`owner`='%e'where`id`='%i'",player[playerid][name],houseid);
				mysql_query(mysql_connection,query,false);
				player[playerid][money]-=GetPVarInt(player_id,"tempSellhomeCost");
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				player[player_id][money]+=GetPVarInt(player_id,"tempSellhomeCost");
				ResetPlayerMoney(player_id);
				GivePlayerMoney(player_id,player[player_id][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[player_id][money],player[player_id][id]);
				mysql_query(mysql_connection,query,false);
				for(new i=0; i<MAX_OWNED_HOUSES; i++){
					if(owned_house_id[playerid][i]){
				        continue;
				    }
				    owned_house_id[playerid][i]=houseid;
				    break;
				}
				for(new i=GetPVarInt(player_id,"tempSellhomeHouseId"); i<MAX_OWNED_HOUSES; i++){
				    owned_house_id[player_id][i]=owned_house_id[player_id][i+1];
				}
				DeletePVar(playerid,"tempSellhomePlayerid");
                DeletePVar(player_id,"tempSellhomePlayer");
				DeletePVar(player_id,"tempSellhomeCost");
		    }
			else{
			    DeletePVar(playerid,"tempSellhomePlayerid");
                DeletePVar(player_id,"tempSellhomePlayer");
				DeletePVar(player_id,"tempSellhomeCost");
			}
		}
		case dSellhomeState:{
		    new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSelectedHouseid")];
			if(!houseid){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			    DeletePVar(playerid,"tempSelectedHouseid");
			    return true;
			}
		    if(response){
				strmid(house[houseid-1][owner],"-",0,1);
                DestroyDynamicPickup(house[houseid-1][pickupid]);
                house[houseid-1][pickupid]=CreateDynamicPickup(1273,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z]);
                new query[43-2+4];
				mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`owner`='-'where`id`='%i'",houseid);
				mysql_query(mysql_connection,query,false);
				owned_house_id[playerid][GetPVarInt(playerid,"tempSellhomeHouseId")]=0;
				for(new i=GetPVarInt(playerid,"tempSellhomeHouseId"); i<MAX_OWNED_HOUSES; i++){
				    owned_house_id[playerid][i]=owned_house_id[playerid][i+1];
				}
		    }
		}
		case dBuyhome:{
		    if(response){
		        new houseid=GetPVarInt(playerid,"buyhomeHouseId");
		        if(!houseid){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            return true;
		        }
		        if(owned_house_id[playerid][MAX_OWNED_HOUSES-1]){
		            return true;
		        }
				if(!IsPlayerInDynamicArea(playerid,house[houseid-1][area_id])){
				    return true;
				}
				if(player[playerid][money]<house[houseid-1][cost]){
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, но у вас нет столько денег!\n\n","Закрыть","");
				    return true;
				}
				strdel(house[houseid-1][owner],0,MAX_PLAYER_NAME);
				strins(house[houseid-1][owner],player[playerid][name],0);
				DestroyDynamicPickup(house[houseid-1][pickupid]);
				house[houseid-1][pickupid]=CreateDynamicPickup(1272,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z]);
				new query[44-2-2+MAX_PLAYER_NAME+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`owner`='%e'where`id`='%i'",player[playerid][name],houseid);
				mysql_query(mysql_connection,query,false);
				for(new i=0; i<MAX_OWNED_HOUSES; i++){
				    if(owned_house_id[playerid][i]){
				        continue;
				    }
				    owned_house_id[playerid][i]=houseid;
				    break;
				}
				player[playerid][money]-=house[houseid-1][cost];
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				SendClientMessage(playerid,C_BLUE,"[Информация] Поздравляем, вы купили дом!");
				SendClientMessage(playerid,C_WHITE,"[Информация] (( Команда для управления домом /home (/hpanel - /hm - hmenu) ))");
				DeletePVar(playerid,"buyhomeHouseId");
		    }
		    else{
		        DeletePVar(playerid,"buyhomeHouseId");
		    }
		}
		case dCityHallAddHouse:{
		    if(response){
		        new string[180-2-2-2-2-2+(11*5)];
		        format(string,sizeof(string),"\n"WHITE"Выберите класс для вашего дома:\n\n1. A - "GREEN"$%i\n"WHITE"2. B - "GREEN"$%i\n"WHITE"3. C - "GREEN"$%i\n"WHITE"4. D - "GREEN"$%i\n"WHITE"5. E - "GREEN"$%i\n\n",GetSVarInt("Houses_Class_A"),GetSVarInt("Houses_Class_B"),GetSVarInt("Houses_Class_C"),GetSVarInt("Houses_Class_D"),GetSVarInt("Houses_Class_E"));
				ShowPlayerDialog(playerid,dCityHallAddHouseClass,DIALOG_STYLE_INPUT,""BLUE"Размещение дома",string,"Дальше","Отмена");
			}
		}
		case dCityHallAddHouseClass:{
		    if(response){
		        new sscanf_class;
		        if(sscanf(inputtext,"i",sscanf_class) || strval(inputtext) < 1 || strval(inputtext) > 5){
		            new string[180-2-2-2-2-2+(11*5)];
			        format(string,sizeof(string),"\n"WHITE"Выберите класс для вашего дома:\n\n1. A - "GREEN"$%i\n"WHITE"2. B - "GREEN"$%i\n"WHITE"3. C - "GREEN"$%i\n"WHITE"4. D - "GREEN"$%i\n"WHITE"5. E - "GREEN"$%i\n\n",GetSVarInt("Houses_Class_A"),GetSVarInt("Houses_Class_B"),GetSVarInt("Houses_Class_C"),GetSVarInt("Houses_Class_D"),GetSVarInt("Houses_Class_E"));
					ShowPlayerDialog(playerid,dCityHallAddHouseClass,DIALOG_STYLE_INPUT,""BLUE"Размещение дома",string,"Дальше","Отмена");
		            return true;
		        }
		        SetPVarInt(playerid,"AddHouse_Class",sscanf_class);
		        new temp_string[29-2+2+32+11];
		        static string[49+sizeof(temp_string)*MAX_HOUSE_INTERIORS+43];
		        strcat(string,"\n"WHITE"Выберите интерьер для вашего дома:\n\n");
		        for(new i=0; i<total_house_interiors; i++){
		            format(temp_string,sizeof(temp_string),""WHITE"%i. %s - "GREEN"$%i\n",i+1,house_interiors[i][description],house_interiors[i][price]);
		            strcat(string,temp_string);
		        }
		        strcat(string,"\n\n"GREY"Интерьер можно просмотреть\n\n");
		        ShowPlayerDialog(playerid,dCityHallAddHouseInterior,DIALOG_STYLE_INPUT,""BLUE"Размещение дома",string,"Дальше","Отмена");
		        string="\0";
		    }
		}
		case dCityHallAddHouseInterior:{
		    if(response){
				new sscanf_interior;
				if(sscanf(inputtext,"i",sscanf_interior)){
                    new temp_string[29-2+2+32+11];
			        static string[49+sizeof(temp_string)*MAX_HOUSE_INTERIORS+43];
			        strcat(string,"\n"WHITE"Выберите интерьер для вашего дома:\n\n");
			        for(new i=0; i<total_house_interiors; i++){
			            format(temp_string,sizeof(temp_string),""WHITE"%i. %s - "GREEN"$%i\n",i+1,house_interiors[i][description],house_interiors[i][price]);
			            strcat(string,temp_string);
			        }
			        strcat(string,"\n\n"GREY"Интерьер можно просмотреть\n\n");
			        ShowPlayerDialog(playerid,dCityHallAddHouseInterior,DIALOG_STYLE_INPUT,""BLUE"Размещение дома",string,"Дальше","Отмена");
			        string="\0";
				    return true;
				}
				SetPVarInt(playerid,"AddHouse_Interior",sscanf_interior);
				ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"Размещение дома","[0] Просмотреть выбранный интерьер\n[1] Выбрать этот интерьер\n[2] Вернуться обратно","Дальше","Отмена");
		    }
		    else{
		        DeletePVar(playerid,"AddHouse_Class");
		    }
		}
		case dCityHallAddHousePreview:{
		    if(response){
		        switch(listitem){
		            case 0:{
						new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_a;
						GetPlayerPos(playerid,temp_x,temp_y,temp_z);
						GetPlayerFacingAngle(playerid,temp_a);
						SetPVarFloat(playerid,"AddHouse_PPosX",temp_x);
						SetPVarFloat(playerid,"AddHouse_PPosY",temp_y);
						SetPVarFloat(playerid,"AddHouse_PPosZ",temp_z);
						SetPVarFloat(playerid,"AddHouse_PPosA",temp_a);
						new interiorid=GetPVarInt(playerid,"AddHouse_Interior");
						SetPlayerVirtualWorld(playerid,random(1000));
						SetPlayerInterior(playerid,house_interiors[interiorid][interior]);
						SetPlayerPos(playerid,house_interiors[interiorid][pos_x],house_interiors[interiorid][pos_y],house_interiors[interiorid][pos_z]);
						SetPlayerFacingAngle(playerid,house_interiors[interiorid][pos_a]);
						SendClientMessage(playerid,-1,"[Информация] Для выхода из просмотра интерьера, введите /exit_preview");
						SetPVarInt(playerid,"AddHouse_Preview",1);
		            }
		            case 1:{
                        new temp_class_price;
						switch(GetPVarInt(playerid,"AddHouse_Class")){
						    case 1:{
						        temp_class_price=GetSVarInt("Houses_Class_A");
						    }
						    case 2:{
						        temp_class_price=GetSVarInt("Houses_Class_B");
						    }
						    case 3:{
						        temp_class_price=GetSVarInt("Houses_Class_C");
						    }
						    case 4:{
						        temp_class_price=GetSVarInt("Houses_Class_D");
						    }
						    case 5:{
						        temp_class_price=GetSVarInt("Houses_Class_E");
						    }
						}
						SetPVarInt(playerid,"AddHouse_TotalCost",temp_class_price+house_interiors[GetPVarInt(playerid,"AddHouse_Interior")-1][price]);
						new string[86-2+11];
						format(string,sizeof(string),"\n"WHITE"Общая цена за дом составит "GREEN"$%i\n\n"WHITE"Вы хотите продолжить?\n\n",GetPVarInt(playerid,"AddHouse_TotalCost"));
						ShowPlayerDialog(playerid,dCityHallAddHouseTotalCost,DIALOG_STYLE_MSGBOX,""BLUE"Размещение дома",string,"Да","Нет");
		            }
		            case 2:{
                        new temp_string[29-2+2+32+11];
				        static string[49+sizeof(temp_string)*MAX_HOUSE_INTERIORS+43];
				        strcat(string,"\n"WHITE"Выберите интерьер для вашего дома:\n\n");
				        for(new i=0; i<total_house_interiors; i++){
				            format(temp_string,sizeof(temp_string),""WHITE"%i. %s - "GREEN"$%i\n",i+1,house_interiors[i][description],house_interiors[i][price]);
				            strcat(string,temp_string);
				        }
				        strcat(string,"\n\n"GREY"Интерьер можно просмотреть\n\n");
				        ShowPlayerDialog(playerid,dCityHallAddHouseInterior,DIALOG_STYLE_INPUT,""BLUE"Размещение дома",string,"Дальше","Отмена");
				        string="\0";
		            }
		        }
		    }
		    else{
                DeletePVar(playerid,"AddHouse_Class");
                DeletePVar(playerid,"AddHouse_Interior");
		    }
		}
		case dCityHallAddHouseTotalCost:{
		    if(response){
				if(player[playerid][money]<GetPVarInt(playerid,"AddHouse_TotalCost")){
					SendClientMessage(playerid,C_RED,"[Информация] У вас нет столько денег!");
					ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"Размещение дома","[0] Просмотреть выбранный интерьер\n[1] Выбрать этот интерьер\n[2] Вернуться обратно","Дальше","Отмена");
				    return true;
				}
				SendClientMessage(playerid,C_GREEN,"[Информация] Вам нужно выбрать местоположение для вашего будущего дома!");
				SendClientMessage(playerid,-1,"[Информация] Для установки местоположения, используйте команду /take_house");
				SetPVarInt(playerid,"AddHouse_SetHPos",1);
		    }
		    else{
                ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"Размещение дома","[0] Просмотреть выбранный интерьер\n[1] Выбрать этот интерьер\n[2] Вернуться обратно","Дальше","Отмена");
		    }
		}
		case dCityHallAddHouseConfirm:{
		    if(response){
		        if(!GetPVarInt(playerid,"AddHouse_SetHPos") || /*!GetPVarInt(playerid,"AddHouse_TotalCost") ||*/ !GetPVarInt(playerid,"AddHouse_Class") || !GetPVarInt(playerid,"AddHouse_Interior") || !GetPVarFloat(playerid,"AddHouse_HPosX") || !GetPVarFloat(playerid,"AddHouse_HPosY") || !GetPVarFloat(playerid,"AddHouse_HPosZ") || player[playerid][money]<GetPVarInt(playerid,"AddHouse_TotalCost")){
       			    DeletePVar(playerid,"AddHouse_SetHPos");
			        DeletePVar(playerid,"AddHouse_TotalCost");
			        DeletePVar(playerid,"AddHouse_Class");
			        DeletePVar(playerid,"AddHouse_Interior");
			        DeletePVar(playerid,"AddHouse_HPosX");
			        DeletePVar(playerid,"AddHouse_HPosY");
			        DeletePVar(playerid,"AddHouse_HPosZ");
			        DeletePVar(playerid,"AddHouse_HPosA");
       			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
					return true;
       			}
				strins(house[total_houses][owner],player[playerid][name],0);
       			house[total_houses][house_interior]=GetPVarInt(playerid,"AddHouse_Interior");
       			house[total_houses][enter_x]=GetPVarFloat(playerid,"AddHouse_HPosX");
       			house[total_houses][enter_y]=GetPVarFloat(playerid,"AddHouse_HPosY");
       			house[total_houses][enter_z]=GetPVarFloat(playerid,"AddHouse_HPosZ");
       			house[total_houses][enter_a]=GetPVarFloat(playerid,"AddHouse_HPosA");
       			house[total_houses][locked]=true;
       			house[total_houses][confirmed]=false;
       			house[total_houses][class]=GetPVarInt(playerid,"AddHouse_Class");
       			house[total_houses][cost]=GetPVarInt(playerid,"AddHouse_TotalCost");
       			new query[114-2-2-2-2-2-2-2-2+MAX_PLAYER_NAME+(11*4)+2+11+2];
       			mysql_format(mysql_connection,query,sizeof(query),"insert into`houses`(`owner`,`enter_pos`,`house_interior`,`cost`,`class`)values('%e','%f|%f|%f|%f','%i','%i','%i')",house[total_houses][owner],house[total_houses][enter_x],house[total_houses][enter_y],house[total_houses][enter_z],house[total_houses][enter_a],house[total_houses][house_interior],house[total_houses][class],house[total_houses][cost]);
       			mysql_query(mysql_connection,query);
       			house[total_houses][id]=cache_insert_id(mysql_connection);
       			new string[86-2+MAX_PLAYER_NAME];
				format(string,sizeof(string),"Номер дома - %i",house[total_houses][id]);
				house[total_houses][labelid]=CreateDynamic3DTextLabel(string,0xFFFFFFFF,house[total_houses][enter_x],house[total_houses][enter_y],house[total_houses][enter_z],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
				house[total_houses][pickupid]=CreateDynamicPickup(1272,23,house[total_houses][enter_x],house[total_houses][enter_y],house[total_houses][enter_z],0,0);
				house[total_houses][area_id]=CreateDynamicSphere(house[total_houses][enter_x],house[total_houses][enter_y],house[total_houses][enter_z],1.0,0,0,-1);
				player[playerid][money]-=house[total_houses][cost];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				for(new i=0; i<MAX_OWNED_HOUSES; i++){
		            if(owned_house_id[playerid][i]){
		                continue;
		            }
		            owned_house_id[playerid][i]=house[total_houses][id];
		            break;
		        }
		        format(string,sizeof(string),"[A] [HOUSES]: Игрок %s разместил новый дом в штате! Необходимо подтвердить координаты!",player[playerid][name]);
		        SendAdminsMessage(C_RED,string);
		        format(string,sizeof(string),"[F] [HOUSES]: Игрок %s разместил новый дом в штате! Необходимо подтвердить координаты!",player[playerid][name]);
		        SendFactionMessage(faction[FACTION_CITYHALL][id],C_BLUE,string);
       			total_houses++;
       			ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Размещение дома","\n"WHITE"Вы разместили новый дом в штате!\n\n"GREY"Мэрия или Администраторы должны подтвердить местоположение дома\n\n","Закрыть","");
       			DeletePVar(playerid,"AddHouse_SetHPos");
		        DeletePVar(playerid,"AddHouse_TotalCost");
		        DeletePVar(playerid,"AddHouse_Class");
		        DeletePVar(playerid,"AddHouse_Interior");
		        DeletePVar(playerid,"AddHouse_HPosX");
		        DeletePVar(playerid,"AddHouse_HPosY");
		        DeletePVar(playerid,"AddHouse_HPosZ");
		        DeletePVar(playerid,"AddHouse_HPosA");
		    }
		    else{
		        DeletePVar(playerid,"AddHouse_SetHPos");
		        DeletePVar(playerid,"AddHouse_TotalCost");
		        DeletePVar(playerid,"AddHouse_Class");
		        DeletePVar(playerid,"AddHouse_Interior");
		        DeletePVar(playerid,"AddHouse_HPosX");
		        DeletePVar(playerid,"AddHouse_HPosY");
		        DeletePVar(playerid,"AddHouse_HPosZ");
		        DeletePVar(playerid,"AddHouse_HPosA");
		        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Размещение дома","\n"WHITE"Вы отклонили размещение дома!\n\n","Закрыть","");
		    }
		}
		case dApanel:{
		    if(response){
		        if(!admin[playerid][commands][APANEL]){
		            return true;
		        }
		        switch(listitem){
		            case 0:{
		                new temp_string[10-2-2+2+24];
		                new string[sizeof(temp_string)*MAX_ADMIN_COMMANDS];
		                new increment=0;
		                for(new i=0; i<MAX_ADMIN_COMMANDS; i++){
		                    if(!admin[playerid][commands][i]){
		                        continue;
		                    }
		                    format(temp_string,sizeof(temp_string),"[%i] %s\n",increment,admin_commands[i]);
		                    strcat(string,temp_string);
		                    increment++;
		                }
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_LIST,""BLUE"Доступые команды",string,"Закрыть","");
		            }
		            case 1:{
		                ShowPlayerDialog(playerid,dApanelProperty,DIALOG_STYLE_LIST,""BLUE"Управление имуществами","[0] Статистика домов\n[1] Подтверждение созданных домов","Выбрать","Назад");
		            }
		            case 2:{
		                new temp_string[10-2-2+3+64];
		                static string[sizeof(temp_string)*MAX_ENTRANCE];
		                for(new i=0; i<total_entrance; i++){
		                    format(temp_string,sizeof(temp_string),"[%i] %s\n",i,entrance[i][description]);
		                    strcat(string,temp_string);
		                }
		                ShowPlayerDialog(playerid,dApanelTeleportToEntrance,DIALOG_STYLE_LIST,""BLUE"Телепорт ко входу",string,"Выбрать","Назад");
		                string="\0";
		            }
		        }
		    }
		}
		case dApanelProperty:{
		    if(response){
		        if(!admin[playerid][commands][APANEL]){
		            return true;
		        }
				switch(listitem){
				    case 0:{
						new Cache:cache_houses=mysql_query(mysql_connection,"select sum(`cost`)as`total_cost`,avg(`cost`)as`average_cost`,min(`cost`)as`lower_cost`,max(`cost`)as`higher_cost`from`houses`");
						new total_cost=cache_get_field_content_int(0,"total_cost",mysql_connection);
						new average_cost=cache_get_field_content_int(0,"average_cost",mysql_connection);
						new lower_cost=cache_get_field_content_int(0,"lower_cost",mysql_connection);
						new higher_cost=cache_get_field_content_int(0,"higher_cost",mysql_connection);
						cache_delete(cache_houses,mysql_connection);
						new temp_string[55-2+11];
						static string[(42-2+11)+(55-2+11)+(53-2+11)+(52-2+11)+(55-2+11)];
						string=""WHITE"";
						format(temp_string,sizeof(temp_string),"\nКоличество домов - "BLUE"%i\n\n",total_houses);
						strcat(string,temp_string);
						format(temp_string,sizeof(temp_string),""WHITE"Суммарная стоимость всех домов - "GREEN"$%i\n",total_cost);
						strcat(string,temp_string);
						format(temp_string,sizeof(temp_string),""WHITE"Средняя стоимость всех домов - "GREEN"$%i\n",average_cost);
						strcat(string,temp_string);
						format(temp_string,sizeof(temp_string),""WHITE"Самая низкая стоимость дома - "GREEN"$%i\n",lower_cost);
						strcat(string,temp_string);
						format(temp_string,sizeof(temp_string),""WHITE"Самая высокая стоимость дома - "GREEN"$%i\n\n",higher_cost);
						strcat(string,temp_string);
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Статистика домов",string,"Закрыть","");
						string="\0";
				    }
				    case 1:{
				        new Cache:cache_houses=mysql_query(mysql_connection,"select`id`from`houses`where`confirmed`='0'order by`id`asc limit 100");
						if(cache_get_row_count(mysql_connection)){
						    new temp_string[7-2+4];
					        static string[(8+sizeof(temp_string))*100];
							string=""WHITE"";
							new temp_id;
						    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
						        temp_id=cache_get_field_content_int(i,"id",mysql_connection);
						        format(temp_string,sizeof(temp_string),!(i % 5) ? "\n%i\t" : "%i\t",temp_id);
						        strcat(string,temp_string);
						    }
						    strcat(string,"\n\nВведите ID одного из домов:\n\n");
							ShowPlayerDialog(playerid,dApanelPropertyConfirmList,DIALOG_STYLE_INPUT,""BLUE"Подтверждение созданных домов",string,"Выбрать","Назад");
							string="\0";
						}
						else{
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Нет доступных домов для подтверждения!\n\n","Закрыть","");
						}
						cache_delete(cache_houses,mysql_connection);
				    }
				}
		    }
		    else{
				cmd::apanel(playerid);
		    }
		}
		case dApanelPropertyConfirmList:{
		    if(response){
		        new sscanf_houseid;
		        if(sscanf(inputtext,"i",sscanf_houseid)){
		            new Cache:cache_houses=mysql_query(mysql_connection,"select`id`from`houses`where`confirmed`='0'order by`id`asc limit 100");
					if(cache_get_row_count(mysql_connection)){
					    new temp_string[7-2+4];
				        static string[(8+sizeof(temp_string))*100];
				        string=""WHITE"";
						new temp_id;
					    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
					        temp_id=cache_get_field_content_int(i,"id",mysql_connection);
					        format(temp_string,sizeof(temp_string),!(i % 5) ? "\n%i\t" : "%i\t",temp_id);
					        strcat(string,temp_string);
					    }
					    strcat(string,"\n\nВведите ID одного из домов:\n\n");
						ShowPlayerDialog(playerid,dApanelPropertyConfirmList,DIALOG_STYLE_INPUT,""BLUE"Подтверждение созданных домов",string,"Выбрать","Назад");
						string="\0";
					}
					else{
					    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Нет доступных домов для подтверждения!\n\n","Закрыть","");
					}
					cache_delete(cache_houses,mysql_connection);
		            return true;
		        }
		        if(house[sscanf_houseid-1][confirmed]){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Этот дом уже подтверждён!\n\n","Закрыть","");
		            return true;
		        }
		        SetPVarInt(playerid,"ApanelConfirm_HouseId",sscanf_houseid);
		        ShowPlayerDialog(playerid,dApanelPropertyConfirmMenu,DIALOG_STYLE_LIST,""BLUE"Подтверждение созданных домов","[0] Телепортироваться к дому\n[1] Изменить координаты дома\n[2] Подтвердить координаты дома","Выбрать","Назад");
		    }
		    else{
		        cmd::apanel(playerid);
		    }
		}
		case dApanelPropertyConfirmMenu:{
		    if(response){
		        if(!admin[playerid][commands][APANEL] || !GetPVarInt(playerid,"ApanelConfirm_HouseId")){
		            return true;
		        }
		        new houseid=GetPVarInt(playerid,"ApanelConfirm_HouseId");
		        switch(listitem){
		            case 0:{
		                SetPlayerPos(playerid,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z]);
		                SetPlayerFacingAngle(playerid,house[houseid-1][enter_a]);
		                SetPlayerInterior(playerid,0);
		                SetPlayerVirtualWorld(playerid,0);
		            }
		            case 1:{
		                SetPVarInt(playerid,"ApanelConfirm_ChangeHouse",1);
		                SendClientMessage(playerid,-1,"[Информация] Для установки новых координат, используйте команду /change_house");
		            }
		            case 2:{
		                new query[73-2-2-2-2-2+(11*5)];
						if(GetPVarInt(playerid,"ApanelConfirm_ChangeHouse")){
						    house[houseid-1][enter_x]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseX");
						    house[houseid-1][enter_y]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseY");
						    house[houseid-1][enter_z]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseZ");
						    house[houseid-1][enter_a]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseA");
						    mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`enter_pos`='%f|%f|%f|%f',`confirmed`='1'where`id`='%i'",house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],house[houseid-1][enter_a],house[houseid-1][id]);
						}
						else{
						    mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`confirmed`='%i'where`id`='%i'",house[houseid-1][id]);
						}
						house[houseid-1][confirmed]=1;
						mysql_query(mysql_connection,query,false);
						DestroyDynamic3DTextLabel(house[houseid-1][labelid]);
						DestroyDynamicPickup(house[houseid-1][pickupid]);
                        new string[16-2+11];
						format(string,sizeof(string),"Номер дома - %i",house[houseid-1][id]);
						house[houseid-1][labelid]=CreateDynamic3DTextLabel(string,0xFFFFFFFF,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
						if(!strcmp(house[houseid-1][owner],"-")){
							house[houseid-1][pickupid]=CreateDynamicPickup(1273,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],0,0);
						}
						else if(strlen(house[houseid-1][owner])>=MIN_PLAYER_NAME_LEN){
						    house[houseid-1][pickupid]=CreateDynamicPickup(1272,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],0,0);
						}
						DeletePVar(playerid,"ApanelConfirm_ChangeHouse");
						DeletePVar(playerid,"ApanelConfirm_HouseId");
						DeletePVar(playerid,"ApanelConfirm_ChangeHouseX");
						DeletePVar(playerid,"ApanelConfirm_ChangeHouseY");
						DeletePVar(playerid,"ApanelConfirm_ChangeHouseZ");
						DeletePVar(playerid,"ApanelConfirm_ChangeHouseA");
		            }
		        }
		    }
		}
		case dApanelTeleportToEntrance:{
		    if(!admin[playerid][commands][APANEL]){
	            return true;
	        }
	        if(response){
	            SetPlayerPos(playerid,entrance[listitem][enter_x],entrance[listitem][enter_y],entrance[listitem][enter_z]);
	            SetPlayerFacingAngle(playerid,entrance[listitem][enter_a]);
	        }
	        else{
	            cmd::apanel(playerid);
	        }
		}
		case dFpanel:{
		    if(response){
		        if(!player[playerid][faction_id]){
		            return true;
		        }
		        switch(listitem){
		            case 0:{
						new string[107];
						switch(player[playerid][faction_id]){
						    case 1:{
						        format(string,sizeof(string),"[0] Изменение цены на паспортную пошлину");
						    }
						    case 2:{
						        format(string,sizeof(string),"[0] Подтверждение созданных домов\n[1] Изменение цен на классы домов\n[2] Изменение цен на интерьеры домов");
						    }
						}
						ShowPlayerDialog(playerid,dFpanelSpecial,DIALOG_STYLE_LIST,""BLUE"Меню фракции",string,"Выбрать","Назад");
						string="\0";
		            }
		            case 1:{
		                cmd::find(playerid);
		            }
		            case 2:{
		                new temp_faction_id=player[playerid][faction_id];
						new temp_entrance_id=faction[temp_faction_id-1][entrance_id]-1;
						entrance[temp_entrance_id][locked]=entrance[temp_entrance_id][locked]?0:1;
						new temp_entrance_status[15];
						format(temp_entrance_status,sizeof(temp_entrance_status),entrance[temp_entrance_id][locked]?""RED"закрыл":""GREEN"открыл");
						new string[45-2-2+MAX_PLAYER_NAME+15];
						format(string,sizeof(string),"[F] %s %s "BLUE"вход/выход в здание фракции!",player[playerid][name],temp_entrance_status);
						SendFactionMessage(temp_faction_id,C_BLUE,string);
						new query[47-2-2+1+3];
						mysql_format(mysql_connection,query,sizeof(query),"update`entrance`set`locked`='%i'where`id`='%i'",entrance[temp_entrance_id][locked],temp_entrance_id+1);
						mysql_query(mysql_connection,query,false);
						new temp_enter[64];
			            format(temp_enter,sizeof(temp_enter),"%s\n%s",entrance[temp_entrance_id][description],entrance[temp_entrance_id][locked]?""RED"Закрыто":""GREEN"Открыто");
			            UpdateDynamic3DTextLabelText(entrance[temp_entrance_id][labelid][0],C_WHITE,temp_enter);
		            }
		        }
		    }
		}
		case dFpanelSpecial:{
		    if(!player[playerid][faction_id]){
	            return true;
	        }
		    if(response){
		        switch(player[playerid][faction_id]){
					case 1:{
					    switch(listitem){
					        case 0:{
							    new string[87-2+6];
		                        format(string,sizeof(string),"\n"WHITE"Текущая цена за единицу дня - "GREEN"$%i\n\n"WHITE"Введите новую цену:\n\n",GetSVarInt("sFeeForPassport"));
		                        ShowPlayerDialog(playerid,dFpanelSpecialPriceForFee,DIALOG_STYLE_INPUT,""BLUE"Цена за паспортную пошлину",string,"Выбрать","Назад");
							}
						}
					}
					case 2:{
						switch(listitem){
							case 0:{
							    new Cache:cache_houses=mysql_query(mysql_connection,"select`id`from`houses`where`confirmed`='0'order by`id`asc limit 100");
								if(cache_get_row_count(mysql_connection)){
									new temp_string[7-2+4];
							        static string[8+sizeof(temp_string)*100];
							        string=""WHITE"";
							        new temp_id;
								    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
								        temp_id=cache_get_field_content_int(i,"id",mysql_connection);
								        format(temp_string,sizeof(temp_string),!(i % 5) ? "\n%i\t" : "%i\t",temp_id);
								        strcat(string,temp_string);
								    }
								    strcat(string,"\n\nВведите ID одного из домов:\n\n");
									ShowPlayerDialog(playerid,dFpanelCityHallConfirm,DIALOG_STYLE_INPUT,""BLUE"Подтверждение созданных домов",string,"Выбрать","Назад");
									string="\0";
								}
								else{
		 							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Нет доступных домов для подтверждения!\n\n","Закрыть","");
								}
								cache_delete(cache_houses,mysql_connection);
							}
							case 1:{
							    static string[256-2-2-2-2-2+11+11+11+11+11];
							    new temp_class_a=GetSVarInt("Houses_Class_A");
								new temp_class_b=GetSVarInt("Houses_Class_B");
								new temp_class_c=GetSVarInt("Houses_Class_C");
								new temp_class_d=GetSVarInt("Houses_Class_D");
								new temp_class_e=GetSVarInt("Houses_Class_E");
								string="\n"WHITE"";
							    format(string,sizeof(string),"1. A класс - "GREEN"$%i\n"WHITE"2. B класс - "GREEN"$%i\n"WHITE"3. C класс - "GREEN"$%i\n"WHITE"4. D класс - "GREEN"$%i\n"WHITE"5. E класс - "GREEN"$%i\n\n"WHITE"Введите номер класса и новую цену через запятую.\n\n"GREY"Пример: 2,25000\n\n",temp_class_a,temp_class_b,temp_class_c,temp_class_d,temp_class_e);
								ShowPlayerDialog(playerid,dFpanelSpecialPrice4HClass,DIALOG_STYLE_INPUT,""BLUE"Изменение цен на классы домов",string,"Выбрать","Назад");
								string="\0";
							}
							case 2:{
							    new temp_string[23-2-2-2+2+32+11];
							    static string[sizeof(temp_string)*MAX_HOUSE_INTERIORS];
							    for(new i=0; i<total_house_interiors; i++){
							        format(temp_string,sizeof(temp_string),"[%i] %s - "GREEN"$%i\n",i,house_interiors[i][description],house_interiors[i][price]);
							        strcat(string,temp_string);
							    }
							    ShowPlayerDialog(playerid,dFpanelSpecialPrice4HInterior,DIALOG_STYLE_LIST,""BLUE"Изменение цен на интерьеры домов",string,"Выбрать","Назад");
							    string="\0";
							}
						}
					}
		        }
		    }
		    else{
		        cmd::fmenu(playerid);
		    }
		}
		case dFpanelSpecialPrice4HInterior:{
		    if(!player[playerid][faction_id]){
	            return true;
	        }
	        if(response){
	            ShowPlayerDialog(playerid,dFpanelSpecialPrice4HInteriorL,DIALOG_STYLE_LIST,""BLUE"Изменение цены на интерьер дома","[0] Просмотреть интерьер\n[1] Изменить цену на интерьер","Выбрать","Назад");
	            SetPVarInt(playerid,"Price4HInterior_ListItem",listitem);
	        }
	        else{
	            cmd::fmenu(playerid);
	        }
		}
		case dFpanelSpecialPrice4HInteriorL:{
		    if(!player[playerid][faction_id]){
	            return true;
	        }
	        if(response){
	            switch(listitem){
	                case 0:{
	                    new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_a;
	                    GetPlayerPos(playerid,temp_x,temp_y,temp_z);
	                    GetPlayerFacingAngle(playerid,temp_a);
	                    new temp_interior,temp_virtualworld;
	                    temp_interior=GetPlayerInterior(playerid);
	                    temp_virtualworld=GetPlayerVirtualWorld(playerid);
	                    SetPVarFloat(playerid,"Price4HInterior_PosX",temp_x);
	                    SetPVarFloat(playerid,"Price4HInterior_PosY",temp_y);
	                    SetPVarFloat(playerid,"Price4HInterior_PosZ",temp_z);
	                    SetPVarFloat(playerid,"Price4HInterior_PosA",temp_a);
	                    SetPVarInt(playerid,"Price4HInterior_Interior",temp_interior);
	                    SetPVarInt(playerid,"Price4HInterior_VirtualWorld",temp_virtualworld);
	                    new temp_listitem=GetPVarInt(playerid,"Price4HInterior_ListItem");
	                    SetPlayerPos(playerid,house_interiors[temp_listitem][pos_x],house_interiors[temp_listitem][pos_y],house_interiors[temp_listitem][pos_z]);
	                    SetPlayerFacingAngle(playerid,house_interiors[temp_listitem][pos_a]);
	                    SetPlayerInterior(playerid,house_interiors[temp_listitem][interior]);
	                    SetPlayerVirtualWorld(playerid,0);
	                    SendClientMessage(playerid,-1,"[Информация] Чтобы выйти из интерьера и вызвать меню, используйте команду /exit_interior");
	                    SetPVarInt(playerid,"Price4HInterior_PreviewStatus",1);
					}
					case 1:{
					    ShowPlayerDialog(playerid,dFpanelSpecialPrice4HInteriorE,DIALOG_STYLE_INPUT,""BLUE"Изменение цены на интерьер дома","\n"WHITE"Введите новую цену для интерьера\n\n","Выбрать","Назад");
					}
	            }
	        }
			else{
			    cmd::fmenu(playerid);
			}
		}
		case dFpanelSpecialPrice4HInteriorE:{
		    if(!player[playerid][faction_id]){
	            return true;
	        }
			if(response){
			    new sscanf_price;
			    if(sscanf(inputtext,"i",sscanf_price)){
			        ShowPlayerDialog(playerid,dFpanelSpecialPrice4HInteriorE,DIALOG_STYLE_INPUT,""BLUE"Изменение цены на интерьер дома","\n"WHITE"Введите новую цену для интерьера\n\n","Выбрать","Назад");
					return true;
			    }
			    new temp_listitem=GetPVarInt(playerid,"Price4HInterior_ListItem");
				house_interiors[temp_listitem][price]=sscanf_price;
				new string[60-2-2-2+MAX_PLAYER_NAME+32+11];
				format(string,sizeof(string),"[F] %s изменил цену интерьера "WHITE"%s"BLUE" на "GREEN"$%i",player[playerid][name],house_interiors[temp_listitem][description],sscanf_price);
				SendFactionMessage(faction[FACTION_CITYHALL][id],C_BLUE,string);
				new query[53-2-2+11+2];
				mysql_format(mysql_connection,query,sizeof(query),"update`house_interiors`set`price`='%i'where`id`='%i'",sscanf_price,house_interiors[temp_listitem][id]);
				mysql_query(mysql_connection,query,false);
  			}
			else{
			    ShowPlayerDialog(playerid,dFpanelSpecialPrice4HInteriorL,DIALOG_STYLE_LIST,""BLUE"Изменение цены на интерьер дома","[0] Просмотреть интерьер\n[1] Изменить цену на интерьер","Выбрать","Назад");
			}
		}
		case dFpanelSpecialPrice4HClass:{
		    if(!player[playerid][faction_id]){
	            return true;
	        }
	        if(response){
	            new sscanf_class,sscanf_price;
	            if(sscanf(inputtext,"p<,>ii",sscanf_class,sscanf_price)){
	                static string[256-2-2-2-2-2+11+11+11+11+11];
				    new temp_class_a=GetSVarInt("Houses_Class_A");
					new temp_class_b=GetSVarInt("Houses_Class_B");
					new temp_class_c=GetSVarInt("Houses_Class_C");
					new temp_class_d=GetSVarInt("Houses_Class_D");
					new temp_class_e=GetSVarInt("Houses_Class_E");
					string=""WHITE"";
				    format(string,sizeof(string),"1. A класс - "GREEN"$%i\n"WHITE"2. B класс - "GREEN"$%i\n"WHITE"3. C класс - "GREEN"$%i\n"WHITE"4. D класс - "GREEN"$%i\n"WHITE"5. E класс - "GREEN"$%i\n\n"WHITE"Введите номер класса и новую цену через запятую.\n\n"GREY"Пример: 2,25000",temp_class_a,temp_class_b,temp_class_c,temp_class_d,temp_class_e);
					ShowPlayerDialog(playerid,dFpanelSpecialPrice4HClass,DIALOG_STYLE_INPUT,""BLUE"Изменение цен на классы домов",string,"Выбрать","Назад");
					string="\0";
	                return true;
	            }
	            new temp_class[2];
				switch(sscanf_class){
					case 1:{
					    SetSVarInt("Houses_Class_A",sscanf_price);
					    temp_class="A";
					}
					case 2:{
					    SetSVarInt("Houses_Class_B",sscanf_price);
					    temp_class="B";
					}
					case 3:{
					    SetSVarInt("Houses_Class_C",sscanf_price);
					    temp_class="C";
					}
					case 4:{
					    SetSVarInt("Houses_Class_D",sscanf_price);
					    temp_class="D";
					}
					case 5:{
					    SetSVarInt("Houses_Class_E",sscanf_price);
					    temp_class="E";
					}
					default:{
					    static string[256-2-2-2-2-2+11+11+11+11+11];
					    new temp_class_a=GetSVarInt("Houses_Class_A");
						new temp_class_b=GetSVarInt("Houses_Class_B");
						new temp_class_c=GetSVarInt("Houses_Class_C");
						new temp_class_d=GetSVarInt("Houses_Class_D");
						new temp_class_e=GetSVarInt("Houses_Class_E");
						string=""WHITE"";
					    format(string,sizeof(string),"1. A класс - "GREEN"$%i\n"WHITE"2. B класс - "GREEN"$%i\n"WHITE"3. C класс - "GREEN"$%i\n"WHITE"4. D класс - "GREEN"$%i\n"WHITE"5. E класс - "GREEN"$%i\n\n"WHITE"Введите номер класса и новую цену через запятую.\n\n"GREY"Пример: 2,25000",temp_class_a,temp_class_b,temp_class_c,temp_class_d,temp_class_e);
						ShowPlayerDialog(playerid,dFpanelSpecialPrice4HClass,DIALOG_STYLE_INPUT,""BLUE"Изменение цен на классы домов",string,"Выбрать","Назад");
						string="\0";
		                return true;
					}
				}
				new string[65-2-2-2+MAX_PLAYER_NAME+2+11];
				format(string,sizeof(string),"[F] %s изменил цену класса [ "WHITE"%s"BLUE" ] на "GREEN"$%i",player[playerid][name],temp_class,sscanf_price);
				SendFactionMessage(faction[FACTION_CITYHALL][id],C_BLUE,string);
				new temp_class_a=GetSVarInt("Houses_Class_A");
				new temp_class_b=GetSVarInt("Houses_Class_B");
				new temp_class_c=GetSVarInt("Houses_Class_C");
				new temp_class_d=GetSVarInt("Houses_Class_D");
				new temp_class_e=GetSVarInt("Houses_Class_E");
				new query[48-2-2-2-2-2+11+11+11+11+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`general`set`class_cost`='%i|%i|%i|%i|%i'",temp_class_a,temp_class_b,temp_class_c,temp_class_d,temp_class_e);
				mysql_query(mysql_connection,query,false);
	        }
	        else{
				cmd::fmenu(playerid);
	        }
		}
		case dFpanelSpecialPriceForFee:{
		    if(!player[playerid][faction_id]){
	            return true;
	        }
		    if(response){
		        new sscanf_fee;
				if(sscanf(inputtext,"i",sscanf_fee)){
				    new string[87-2+6];
                    format(string,sizeof(string),"\n"WHITE"Текущая цена за единицу дня - "GREEN"$%i\n\n"WHITE"Введите новую цену:\n\n",GetSVarInt("sFeeForPassport"));
                    ShowPlayerDialog(playerid,dFpanelSpecialPriceForFee,DIALOG_STYLE_INPUT,""BLUE"Цена за паспортную пошлину",string,"Выбрать","Назад");
				    return true;
				}
				if(sscanf_fee<1 || sscanf_fee>20){
				    new string[130-2+6];
                    format(string,sizeof(string),"\n"RED"Значние может быть от $1 до $20\n\n"WHITE"Текущая цена за единицу дня - "GREEN"$%i\n\n"WHITE"Введите новую цену:\n\n",GetSVarInt("sFeeForPassport"));
                    ShowPlayerDialog(playerid,dFpanelSpecialPriceForFee,DIALOG_STYLE_INPUT,""BLUE"Цена за паспортную пошлину",string,"Выбрать","Назад");
				    return true;
				}
				SetSVarInt("sFeeForPassport",sscanf_fee);
				new query[42-2+2];
				mysql_format(mysql_connection,query,sizeof(query),"update`general`set`fee_for_passport`='%i'",sscanf_fee);
				mysql_query(mysql_connection,query,false);
				new string[55-2-2+MAX_PLAYER_NAME+2];
				format(string,sizeof(string),"[F] %s сменил цену за паспортную пошлину на "GREEN"$%i",player[playerid][name],sscanf_fee);
				SendFactionMessage(player[playerid][faction_id],C_BLUE,string);
		    }
		    else{
		        cmd::fmenu(playerid);
		    }
		}
		case dFpanelCityHallConfirm:{
		    if(response){
				if(player[playerid][faction_id] != faction[FACTION_CITYHALL][id]){
				    return true;
				}
				new sscanf_id;
				if(sscanf(inputtext,"i",sscanf_id)){
				    new Cache:cache_houses=mysql_query(mysql_connection,"select`id`from`houses`where`confirmed`='0'order by`id`asc limit 100");
					if(cache_get_row_count(mysql_connection)){
						new temp_string[7-2+4];
				        static string[(8+sizeof(temp_string))*100];
				        string=""WHITE"";
				        new temp_id;
					    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
					        temp_id=cache_get_field_content_int(i,"id",mysql_connection);
					        format(temp_string,sizeof(temp_string),!(i % 5) ? "\n%i\t" : "%i\t",temp_id);
					        strcat(string,temp_string);
					    }
					    strcat(string,"\n\nВведите ID одного из домов:\n\n");
						ShowPlayerDialog(playerid,dFpanelCityHallConfirm,DIALOG_STYLE_INPUT,""BLUE"Подтверждение созданных домов",string,"Выбрать","Назад");
						string="\0";
					}
					else{
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Нет доступных домов для подтверждения!\n\n","Закрыть","");
					}
					cache_delete(cache_houses,mysql_connection);
				    return true;
				}
				if(house[sscanf_id-1][confirmed]){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Этот дом уже подтверждён!\n\n","Закрыть","");
		            return true;
		        }
				SetPVarInt(playerid,"FpanelConfirm_HouseId",sscanf_id);
		        ShowPlayerDialog(playerid,dFpanelCityHallConfirmMenu,DIALOG_STYLE_LIST,""BLUE"Подтверждение созданных домов","[0] Поставить чекпоинт к дому\n[1] Изменить координаты дома\n[2] Подтвердить координаты дома","Выбрать","Назад");
		    }
		}
		case dFpanelCityHallConfirmMenu:{
		    if(response){
		        if(player[playerid][faction_id] != faction[FACTION_CITYHALL][id]){
				    return true;
				}
				new houseid=GetPVarInt(playerid,"FpanelConfirm_HouseId");
		        switch(listitem){
		            case 0:{
		                if(GetPlayerVirtualWorld(playerid) || GetPlayerInterior(playerid)){
							SendClientMessage(playerid,C_RED,"[Информация] Вы не должны находиться в интреьере или вирт. мире!");
		                    return true;
		                }
		                SetPlayerCheckpoint(playerid,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],2.0);
		                SetPVarInt(playerid,"Checkpoint_Status",1);
		            }
		            case 1:{
		                SetPVarInt(playerid,"FpanelConfirm_ChangeHouse",1);
		                SendClientMessage(playerid,-1,"[Информация] Для установки новых координат, используйте команду /change_house");
		            }
		            case 2:{
		                new query[73-2-2-2-2-2+(11*5)];
						if(GetPVarInt(playerid,"FpanelConfirm_ChangeHouse")){
						    house[houseid-1][enter_x]=GetPVarFloat(playerid,"FpanelConfirm_ChangeHouseX");
						    house[houseid-1][enter_y]=GetPVarFloat(playerid,"FpanelConfirm_ChangeHouseY");
						    house[houseid-1][enter_z]=GetPVarFloat(playerid,"FpanelConfirm_ChangeHouseZ");
						    house[houseid-1][enter_a]=GetPVarFloat(playerid,"FpanelConfirm_ChangeHouseA");
						    mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`enter_pos`='%f|%f|%f|%f',`confirmed`='1'where`id`='%i'",house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],house[houseid-1][enter_a],house[houseid-1][id]);
						}
						else{
						    mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`confirmed`='%i'where`id`='%i'",house[houseid-1][id]);
						}
						house[houseid-1][confirmed]=1;
						mysql_query(mysql_connection,query,false);
						DestroyDynamic3DTextLabel(house[houseid-1][labelid]);
						DestroyDynamicPickup(house[houseid-1][pickupid]);
                        new string[16-2+11];
						format(string,sizeof(string),"Номер дома - %i",house[houseid-1][id]);
						house[houseid-1][labelid]=CreateDynamic3DTextLabel(string,0xFFFFFFFF,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
						if(!strcmp(house[houseid-1][owner],"-")){
							house[houseid-1][pickupid]=CreateDynamicPickup(1273,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],0,0);
						}
						else if(strlen(house[houseid-1][owner])>=MIN_PLAYER_NAME_LEN){
						    house[houseid-1][pickupid]=CreateDynamicPickup(1272,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z],0,0);
						}
						DeletePVar(playerid,"FpanelConfirm_ChangeHouse");
						DeletePVar(playerid,"FpanelConfirm_HouseId");
						DeletePVar(playerid,"FpanelConfirm_ChangeHouseX");
						DeletePVar(playerid,"FpanelConfirm_ChangeHouseY");
						DeletePVar(playerid,"FpanelConfirm_ChangeHouseZ");
						DeletePVar(playerid,"FpanelConfirm_ChangeHouseA");
		            }
		        }
		    }
		}
		case dLpanel:{
		    if(response){
		        new temp_faction_id=player[playerid][faction_id];
		    	if(temp_faction_id && GetPVarInt(playerid,"IsPlayerLeader")){
		        	switch(listitem){
			            case 0:{
			                new temp_string[8-2-2+2+24];
			               	static string[sizeof(temp_string)*MAX_RANKS_IN_FACTION];
			                for(new i=0; i<MAX_RANKS_IN_FACTION; i++){
			                    format(temp_string,sizeof(temp_string),"[%i] %s\n",i,faction_ranks[temp_faction_id-1][i]);
			                    strcat(string,temp_string);
			                }
			                ShowPlayerDialog(playerid,dLpanelRanks,DIALOG_STYLE_LIST,""BLUE"Наименование рангов фракции",string,"Выбрать","Назад");
			                string="\0";
			            }
			            case 1:{
							new temp_string[7-2+MAX_PLAYER_NAME];
	   						static string[sizeof(temp_string)*128];
	   						string=""WHITE"";
							new query[46-2+2];
							mysql_format(mysql_connection,query,sizeof(query),"select`name`from`users`where`faction_id`='%i'",player[playerid][faction_id]);
							new Cache:cache_users=mysql_query(mysql_connection,query);
							new temp_name[MAX_PLAYER_NAME];
							if(cache_get_row_count(mysql_connection)){
							    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
									cache_get_field_content(i,"name",temp_name,mysql_connection,MAX_PLAYER_NAME);
									format(temp_string,sizeof(temp_string),!(i % 5) ? "\n%s\t" : "%s\t",temp_name);
									strcat(string,temp_string);
							    }
							    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Участники фракции",string,"Закрыть","");
							}
							else{
							    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка",""WHITE"Извините, произошла ошибка!","Закрыть","");
							}
							cache_delete(cache_users,mysql_connection);
							string="\0";
			            }
						case 2:{
						    ShowPlayerDialog(playerid,dLpanelOfflineMember,DIALOG_STYLE_INPUT,""BLUE"Управление участниками фракции "RED"OFFLINE","\n"WHITE"Введите никнейм участника фракции\n\n"GREY"Игрок должен быть оффлайн\n\n","Дальше","Назад");
						}
						case 3:{
						    ShowPlayerDialog(playerid,dLpanelSubleader,DIALOG_STYLE_LIST,""BLUE"Заместитель","[0] Назначить заместителя\n[1] Снять заместителя\n[2] Права для заместителя","Выбрать","Назад");
						}
					}
		        }
		    }
		}
		case dLpanelRanks:{
		    if(response){
		        new temp_faction_id=player[playerid][faction_id];
		        if(temp_faction_id && GetPVarInt(playerid,"IsPlayerLeader")){
			        new string[59-2+24];
	                format(string,sizeof(string),"\n"WHITE"Введите новое название для ранга - "BLUE"%s\n\n",faction_ranks[temp_faction_id-1][listitem]);
	                ShowPlayerDialog(playerid,dLpanelRanksEdit,DIALOG_STYLE_INPUT,""BLUE"Изменение наименования ранга",string,"Далее","Назад");
	                SetPVarInt(playerid,"LpanelRanks_RankId",listitem);
				}
		    }
		    else{
		        cmd::lmenu(playerid);
		    }
		}
		case dLpanelRanksEdit:{
		    if(response){
		        new temp_faction_id=player[playerid][faction_id];
                if(temp_faction_id && GetPVarInt(playerid,"IsPlayerLeader")){
			        new sscanf_rank[24];
			        listitem=GetPVarInt(playerid,"LpanelRanks_RankId");
			        if(sscanf(inputtext,"s[128]",sscanf_rank)){
			            new string[59-2+24];
		                format(string,sizeof(string),"\n"WHITE"Введите новое название для ранга - "BLUE"%s\n\n",faction_ranks[temp_faction_id-1][listitem]);
		                ShowPlayerDialog(playerid,dLpanelRanksEdit,DIALOG_STYLE_INPUT,""BLUE"Изменение наименования ранга",string,"Далее","Назад");
			            return true;
			        }
			        new string[55-2+24];
			        strdel(faction_ranks[temp_faction_id-1][listitem],0,24);
			        strins(faction_ranks[temp_faction_id-1][listitem],sscanf_rank,0);
			        new temp_faction_ranks_ex[3-2+24];
			        static temp_faction_ranks[sizeof(temp_faction_ranks_ex)*MAX_RANKS_IN_FACTION];
					for(new i=0; i<MAX_RANKS_IN_FACTION; i++){
					    format(temp_faction_ranks_ex,sizeof(temp_faction_ranks_ex),(i==MAX_RANKS_IN_FACTION-1)?"%s":"%s|",faction_ranks[temp_faction_id-1][i]);
					    strcat(temp_faction_ranks,temp_faction_ranks_ex);
					}
					static query[45-2-2+sizeof(temp_faction_ranks)+2];
					mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`rank`='%e'where`id`='%i'",temp_faction_ranks,temp_faction_id);
					mysql_query(mysql_connection,query,false);
					temp_faction_ranks="\0";
					query="\0";
			        format(string,sizeof(string),"\n"WHITE"Вы изменили название ранга на "BLUE"%s\n\n",faction_ranks[temp_faction_id-1][listitem]);
			        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация",string,"Закрыть","");
			        DeletePVar(playerid,"LpanelRanks_RankId");
				}
		    }
			else{
			    DeletePVar(playerid,"LpanelRanks_RankId");
			    cmd::lmenu(playerid);
			}
		}
		case dLpanelOfflineMember:{
		    new temp_faction_id=player[playerid][faction_id];
		    if(temp_faction_id && GetPVarInt(playerid,"IsPlayerLeader")){
				if(response){
				    new sscanf_name[MAX_PLAYER_NAME];
					if(sscanf(inputtext,"s[128]",sscanf_name)){
					    ShowPlayerDialog(playerid,dLpanelOfflineMember,DIALOG_STYLE_INPUT,""BLUE"Управление участниками фракции "RED"OFFLINE","\n"WHITE"Введите никнейм участника фракции\n\n"GREY"Игрок должен быть оффлайн\n\n","Дальше","Назад");
					    return true;
					}
					new temp_playerid;
					sscanf(sscanf_name,"u",temp_playerid);
					if(GetPVarInt(temp_playerid,"PlayerLogged")){
					    ShowPlayerDialog(playerid,dLpanelOfflineMember,DIALOG_STYLE_INPUT,""BLUE"Управление участниками фракции "RED"OFFLINE","\n"WHITE"Введите никнейм участника фракции\n\n"GREY"Игрок должен быть оффлайн\n\n","Дальше","Назад");
					    return true;
					}
					new query[67-2-2+MAX_PLAYER_NAME+2];
					mysql_format(mysql_connection,query,sizeof(query),"select`name`from`users`where`name`='%e'and`faction_id`='%i'limit 1",sscanf_name,temp_faction_id);
					new Cache:cache_users=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    SetPVarString(playerid,"LpanelOfflineMember_Name",sscanf_name);
						ShowPlayerDialog(playerid,dLpanelOfflineMemberList,DIALOG_STYLE_LIST,""BLUE"Управление участником фракции","[0] Информация об участнике\n[1] Повысить в должности\n[2] Понизить в должности\n[3] Уволить из фракции","Выбрать","Отмена");
					}
					else{
					    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Игрок не найден/Игрок не находится в вашей фракции!\n\n","Закрыть","");
					}
					cache_delete(cache_users,mysql_connection);
				}
			}
			else{
			    cmd::lmenu(playerid);
			}
		}
		case dLpanelOfflineMemberList:{
		    if(response){
                new temp_faction_id=player[playerid][faction_id];
                new temp_name[MAX_PLAYER_NAME];
				GetPVarString(playerid,"LpanelOfflineMember_Name",temp_name,sizeof(temp_name));
				new temp_playerid;
				sscanf(temp_name,"u",temp_playerid);
                if(GetPVarInt(temp_playerid,"PlayerLogged") || strlen(temp_name) > MIN_PLAYER_NAME_LEN || temp_faction_id || GetPVarInt(playerid,"IsPlayerLeader")){
                    switch(listitem){
                        case 0:{
                            new query[50-2+MAX_PLAYER_NAME];
                            mysql_format(mysql_connection,query,sizeof(query),"select`rank_id`from`users`where`name`='%e'limit 1",temp_name);
                            new Cache:cache_users=mysql_query(mysql_connection,query);
                            if(cache_get_row_count(mysql_connection)){
                                new temp_rank_id=cache_get_field_content_int(0,"rank_id",mysql_connection);
                                new string[72-2-2-2+MAX_PLAYER_NAME+24+2];
								format(string,sizeof(string),"\n"WHITE"Никнейм - "BLUE"%s\n"WHITE"Должность - "BLUE"%s "GREY"(%i)\n\n",temp_name,faction_ranks[temp_faction_id-1][temp_rank_id-1],temp_rank_id);
								ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация об участнике",string,"Закрыть","");
                            }
                            else{
                                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
                            }
                            cache_delete(cache_users,mysql_connection);
                        }
                        case 1:{
                            new query[102-2+MAX_PLAYER_NAME-2+2];
                            mysql_format(mysql_connection,query,sizeof(query),"update`users`set`rank_id`=`rank_id`+'1'where`name`='%e'and(`rank_id`<'11'and`faction_id`='%i')limit 1",temp_name,player[playerid][faction_id]);
                            mysql_query(mysql_connection,query);
                            if(!cache_affected_rows(mysql_connection)){
                                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Игрок уже повышен до максимальной должности!\n\n","Закрыть","");
                                return true;
                            }
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы повысили игрока в должности\n\n","Закрыть","");
                        }
                        case 2:{
                            new query[101-2+MAX_PLAYER_NAME-2+2];
                            mysql_format(mysql_connection,query,sizeof(query),"update`users`set`rank_id`=`rank_id`-'1'where`name`='%e'and(`rank_id`>'1'and`faction_id`='%i')limit 1",temp_name,player[playerid][faction_id]);
                            mysql_query(mysql_connection,query);
                            if(!cache_affected_rows(mysql_connection)){
                                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Игрок уже понижен до минимальной должности!\n\n","Закрыть","");
                                return true;
                            }
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы понизили игрока в должности\n\n","Закрыть","");
                        }
                        case 3:{
                            new query[68-2+MAX_PLAYER_NAME];
                            mysql_format(mysql_connection,query,sizeof(query),"update`users`set`rank_id`='0',`faction_id`='0'where`name`='%e'limit 1",temp_name);
                            mysql_query(mysql_connection,query,false);
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы уволили игрока из фракции\n\n","Закрыть","");
                        }
                    }
                }
		    }
		}
		case dLpanelSubleader:{
			new temp_faction_id=player[playerid][faction_id];
		    if(temp_faction_id && GetPVarInt(playerid,"IsPlayerLeader")){
			    if(response){
					switch(listitem){
					    case 0:{//назначить заместителя
					        if(!strcmp(faction[temp_faction_id-1][sub_leader],"-")){
					        	ShowPlayerDialog(playerid,dLpanelSubleaderMake,DIALOG_STYLE_INPUT,""BLUE"Назначить заместителя","\n"WHITE"Введите никнейм игрока, которого хотите назначить заместителем\n\n","Выбрать","Назад");
					        	return true;
					        }
					        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Вы уже назначали заместителя!\n\n","Закрыть","");
						}
						case 1:{//снять заместителя
						    if(!strcmp(faction[temp_faction_id-1][sub_leader],"-")){
	                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"У вас нет заместителя!\n\n","Закрыть","");
	                            return true;
							}
							new temp_name[MAX_PLAYER_NAME];
							strins(temp_name,faction[temp_faction_id-1][sub_leader],0);
							new temp_playerid;
							sscanf(temp_name,"u",temp_playerid);
							if(GetPVarInt(temp_playerid,"PlayerLogged")){
								DeletePVar(temp_playerid,"IsPlayerSubleader");
								new string[65-2+32];
								format(string,sizeof(string),"[Информация] Вы были сняты с поста заместителя лидера фракции %s",faction[temp_faction_id-1][name]);
								SendClientMessage(temp_playerid,C_BLUE,string);
							}
							strdel(faction[temp_faction_id-1][sub_leader],0,MAX_PLAYER_NAME);
							strins(faction[temp_faction_id-1][sub_leader],"-",0);
							new query[50-2+2];
							mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`sub_leader`='-'where`id`='%i'",temp_faction_id);
							mysql_query(mysql_connection,query,false);
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы сняли игрока с поста заместителя!\n\n","Закрыть","");
						}
						case 2:{//права заместителя
						    new temp_invite[24];
						    format(temp_invite,sizeof(temp_invite),faction[temp_faction_id-1][sub_leader_access][INVITE]?""GREEN"[ доступно ]":""RED"[ не доступно ]");
						    new temp_uninvite[24];
						    format(temp_uninvite,sizeof(temp_uninvite),faction[temp_faction_id-1][sub_leader_access][UNINVITE]?""GREEN"[ доступно ]":""RED"[ не доступно ]");
						    new temp_giverank[24];
						    format(temp_giverank,sizeof(temp_giverank),faction[temp_faction_id-1][sub_leader_access][GIVERANK]?""GREEN"[ доступно ]":""RED"[ не доступно ]");
							new string[89-2-2-2+24+24+24];
							format(string,sizeof(string),"[0] Принимать во фракцию - %s\n[1] Выгонять из фракции - %s\n[2] Изменять должность - %s",temp_invite,temp_uninvite,temp_giverank);
							ShowPlayerDialog(playerid,dLpanelSubleaderAccess,DIALOG_STYLE_LIST,""BLUE"Права заместителя",string,"Выбрать","Назад");
						}
					}
				}
			}
		    else{
		        cmd::lmenu(playerid);
		    }
		}
		case dLpanelSubleaderMake:{
            new temp_faction_id=player[playerid][faction_id];
		    if(temp_faction_id && GetPVarInt(playerid,"IsPlayerLeader")){
		        if(response){
		            new sscanf_name[MAX_PLAYER_NAME];
					if(sscanf(inputtext,"s[128]",sscanf_name)){
					    ShowPlayerDialog(playerid,dLpanelSubleaderMake,DIALOG_STYLE_INPUT,""BLUE"Назначить заместителя","\n"WHITE"Введите никнейм игрока, которого хотите назначить заместителем\n\n","Выбрать","Назад");
					    return true;
					}
					new query[58-2-2+MAX_PLAYER_NAME+2];
					mysql_format(mysql_connection,query,sizeof(query),"select`id`from`users`where`name`='%e'and`faction_id`='%i'",sscanf_name,temp_faction_id);
					new Cache:cache_users=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
						strins(faction[temp_faction_id-1][sub_leader],sscanf_name,0);
						new temp_playerid;
						sscanf(sscanf_name,"u",temp_playerid);
						if(GetPVarInt(temp_playerid,"PlayerLogged")){
						    SetPVarInt(temp_playerid,"IsPlayerSubleader",1);
						    new string[62-2+32];
						    format(string,sizeof(string),"[Информация] Вы были назначены заместителем лидера фракции %s",faction[temp_faction_id-1][name]);
						    SendClientMessage(temp_playerid,C_BLUE,string);
						}
						mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`sub_leader`='%e'where`id`='%i'",sscanf_name,temp_faction_id);
						mysql_query(mysql_connection,query,false);
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы назначили игрока на пост заместителя!\n\n","Закрыть","");
					}
					else{
					    ShowPlayerDialog(playerid,dLpanelSubleaderMake,DIALOG_STYLE_INPUT,""BLUE"Назначить заместителя","\n"RED"Игрок не находится в вашей фракции! /\nАккаунт игрока не существует!\n\n"WHITE"Введите никнейм игрока,\nкоторого хотите назначить заместителем\n\n","Выбрать","Назад");
					}
					cache_delete(cache_users,mysql_connection);
		        }
		        else{
		            ShowPlayerDialog(playerid,dLpanelSubleader,DIALOG_STYLE_LIST,""BLUE"Заместитель","[0] Назначить заместителя\n[1] Снять заместителя\n[2] Права для заместителя","Выбрать","Назад");
		        }
			}
		}
		case dLpanelSubleaderAccess:{
		    new temp_faction_id=player[playerid][faction_id];
		    if(temp_faction_id && GetPVarInt(playerid,"IsPlayerLeader")){
			    if(response){
					faction[temp_faction_id-1][sub_leader_access][listitem]=faction[temp_faction_id-1][sub_leader_access][listitem]?0:1;
					new temp_invite[24];
				    format(temp_invite,sizeof(temp_invite),faction[temp_faction_id-1][sub_leader_access][INVITE]?""GREEN"[ доступно ]":""RED"[ не доступно ]");
				    new temp_uninvite[24];
				    format(temp_uninvite,sizeof(temp_uninvite),faction[temp_faction_id-1][sub_leader_access][UNINVITE]?""GREEN"[ доступно ]":""RED"[ не доступно ]");
				    new temp_giverank[24];
				    format(temp_giverank,sizeof(temp_giverank),faction[temp_faction_id-1][sub_leader_access][GIVERANK]?""GREEN"[ доступно ]":""RED"[ не доступно ]");
					new string[89-2-2-2+24+24+24];
					format(string,sizeof(string),"[0] Принимать во фракцию - %s\n[1] Выгонять из фракции - %s\n[2] Изменять должность - %s",temp_invite,temp_uninvite,temp_giverank);
					ShowPlayerDialog(playerid,dLpanelSubleaderAccess,DIALOG_STYLE_LIST,""BLUE"Права заместителя",string,"Выбрать","Назад");
					new temp_string[4];
					new temp_access[24];
					for(new i=0; i<3; i++){
					    format(temp_string,sizeof(temp_string),(i==2)?"%i":"%i|",faction[temp_faction_id-1][sub_leader_access][i]);
						strcat(temp_access,temp_string);
					}
					new query[58-2-2+24+2];
					mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`sub_leader_access`='%e'where`id`='%i'",temp_access,temp_faction_id);
					mysql_query(mysql_connection,query,false);
			    }
				else{
				    ShowPlayerDialog(playerid,dLpanelSubleader,DIALOG_STYLE_LIST,""BLUE"Заместитель","[0] Назначить заместителя\n[1] Снять заместителя\n[2] Права для заместителя","Выбрать","Назад");
				}
			}
		}
		case dBusinessCenterLift:{
		    if(response){
		        for(new i=0; i<sizeof(lift_floor); i++){
		            if(!IsPlayerInDynamicArea(playerid,area[BUSINESS_CENTER_LIFT][i])){
		                return true;
		            }
		        }
				SetPlayerPos(playerid,lift_floor[listitem][0],lift_floor[listitem][1],lift_floor[listitem][2]);
				SetPlayerFacingAngle(playerid,lift_floor[listitem][3]);
				SetCameraBehindPlayer(playerid);
		    }
		}
		case dBuybusiness:{
		    if(response){
		        new temp_businessid=GetPVarInt(playerid,"buybusinessId");
		        if(!temp_businessid){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            return true;
		        }
		        if(owned_business_id[playerid][MAX_OWNED_BUSINESSES-1]){
		            return true;
		        }
				if(!IsPlayerInDynamicArea(playerid,business[temp_businessid-1][area_id])){
				    return true;
				}
				if(player[playerid][money]<business[temp_businessid-1][price]){
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, но у вас нет столько денег!\n\n","Закрыть","");
				    return true;
				}
				strmid(business[temp_businessid-1][owner],player[playerid][name],0,strlen(player[playerid][name]));
				DestroyDynamicPickup(business[temp_businessid-1][pickupid]);
				business[temp_businessid-1][pickupid]=CreateDynamicPickup(19132,23,business[temp_businessid-1][pos_x],business[temp_businessid-1][pos_y],business[temp_businessid-1][pos_z]);
				new query[48-2-2+MAX_PLAYER_NAME+3];
				mysql_format(mysql_connection,query,sizeof(query),"update`businesses`set`owner`='%e'where`id`='%i'",player[playerid][name],temp_businessid);
				mysql_query(mysql_connection,query,false);
				for(new i=0; i<MAX_OWNED_BUSINESSES; i++){
				    if(owned_business_id[playerid][i]){
				        continue;
				    }
				    owned_business_id[playerid][i]=temp_businessid;
				    break;
				}
				player[playerid][money]-=business[temp_businessid-1][price];
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				SendClientMessage(playerid,C_BLUE,"[Информация] Поздравляем, вы купили бизнес!");
				SendClientMessage(playerid,C_WHITE,"[Информация] (( Команда для управления бизнесом /business (/bpanel - /bp - /bmenu - /bm) ))");
				DeletePVar(playerid,"buybusinessId");
		    }
		    else{
		        DeletePVar(playerid,"buybusinessId");
		    }
		}
		case dBusiness:{
		    if(response){
          		new cmdtext[13-2+3];
          		DeletePVar(playerid,"command_time");
	            format(cmdtext,sizeof(cmdtext),"/business %i",listitem);
				DC_CMD(playerid,cmdtext);
		    }
		}
		case dBusinessMenu:{
		    if(response){
		        new temp_businessid=owned_business_id[playerid][GetPVarInt(playerid,"tempSelectedBusinessid")];
				if(!temp_businessid){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    DeletePVar(playerid,"tempSelectedBusinessid");
				    return true;
				}
		        switch(listitem){
		            case 0:{
		                new string[159-2-2-2-2+4+11+24+32];
		                format(string,sizeof(string),"\n"WHITE"Номер бизнеса - "BLUE"%i\n\n"WHITE"Государственная цена - "GREEN"$%i\n"WHITE"Тип бизнеса - "BLUE"%s\n"WHITE"Название бизнеса - "BLUE"%s\n\n",temp_businessid,business[temp_businessid-1][price],type_of_business[business[temp_businessid-1][type]-1],business[temp_businessid-1][name]);
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация о бизнесе",string,"Закрыть","");
		            }
		            case 1:{
		                business[temp_businessid-1][locked]=business[temp_businessid-1][locked]?0:1;
		                new query[49-2-2+1+4];
		                mysql_format(mysql_connection,query,sizeof(query),"update`businesses`set`locked`='%i'where`id`='%i'",business[temp_businessid-1][locked],temp_businessid);
		                mysql_query(mysql_connection,query,false);
		                new cmdtext[13-2+3];
		                DeletePVar(playerid,"command_time");
			            format(cmdtext,sizeof(cmdtext),"/business %i",GetPVarInt(playerid,"tempSelectedBusinessid"));
						DC_CMD(playerid,cmdtext);
		            }
		            case 2:{
                        ShowPlayerDialog(playerid,dBusinessSell,DIALOG_STYLE_LIST,""BLUE"Продать бизнес","[0] Продать бизнес игроку\n[1] Продать бизнес государству","Выбрать","Отмена");
		            }
		        }
		    }
		    else{
		        DeletePVar(playerid,"tempSelectedBusinessid");
		    }
		}
		case dBusinessSell:{
		    if(response){
		        new temp_businessid=owned_business_id[playerid][GetPVarInt(playerid,"tempSelectedBusinessid")];
				if(!temp_businessid){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    DeletePVar(playerid,"tempSelectedBusinessid");
				    return true;
				}
				switch(listitem){
				    case 0:{
		                ShowPlayerDialog(playerid,dBusinessSellWhom,DIALOG_STYLE_INPUT,""BLUE"Продать бизнес игроку","\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            }
		            case 1:{
						new string[87-2+11];
						format(string,sizeof(string),"\n"WHITE"Вы хотите продать бизнес государству?\n\nГос. цена бизнеса - "GREEN"$%i\n\n",business[temp_businessid-1][price]);
						ShowPlayerDialog(playerid,dBusinessSellState,DIALOG_STYLE_MSGBOX,""BLUE"Продать бизнес государству",string,"Да","Нет");
		            }
				}
		    }
			else{
			    new cmdtext[13-2+3];
			    DeletePVar(playerid,"command_time");
	            format(cmdtext,sizeof(cmdtext),"/business %i",GetPVarInt(playerid,"tempSelectedBusinessid"));
				DC_CMD(playerid,cmdtext);
			}
		}
		case dBusinessSellWhom:{
		    new temp_businessid=owned_business_id[playerid][GetPVarInt(playerid,"tempSelectedBusinessid")];
			if(!temp_businessid){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			    DeletePVar(playerid,"tempSelectedBusinessid");
			    return true;
			}
		    if(response){
		        new sscanf_player, sscanf_cost;
		        if(sscanf(inputtext,"p<,>ui",sscanf_player,sscanf_cost)){
		            ShowPlayerDialog(playerid,dBusinessSellWhom,DIALOG_STYLE_INPUT,""BLUE"Продать бизнес игроку","\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            return true;
		        }
		        if(!GetPVarInt(sscanf_player,"PlayerLogged")){
				    ShowPlayerDialog(playerid,dBusinessSellWhom,DIALOG_STYLE_INPUT,""BLUE"Продать бизнес игроку","\n"RED"Игрок не подключен к серверу!\n\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
				    return true;
				}
				if(owned_business_id[sscanf_player][MAX_OWNED_BUSINESSES-1]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Игрок владеет максимальным количеством бизнесов!\n\n","Закрыть","");
				    return true;
				}
		        if(sscanf_cost < 1 || sscanf_cost > 1000000){
		            ShowPlayerDialog(playerid,dBusinessSellWhom,DIALOG_STYLE_INPUT,""BLUE"Продать бизнес игроку","\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            return true;
		        }
		        if(sscanf_cost > player[sscanf_player][money]){
		            ShowPlayerDialog(playerid,dBusinessSellWhom,DIALOG_STYLE_INPUT,""BLUE"Продать бизнес игроку","\n"RED"У игрока нет столько денег!\n\n"WHITE"Введите ID игрока и цену через запятую\n\n"GREY"Пример: 25,25000\n\n","Дальше","Назад");
		            return true;
		        }
		        SetPVarInt(playerid,"tempSellBusinessPlayer",sscanf_player);
		        SetPVarInt(playerid,"tempSellBusinessCost",sscanf_cost);
		        new string[141-2-2+MAX_PLAYER_NAME+4];
		        format(string,sizeof(string),"\n"WHITE"Вы собираетесь продать свой бизнес игроку "BLUE"%s"WHITE" за "GREEN"$%i\n\n"WHITE"Вы действительно хотите продать бизнес?\n\n",player[sscanf_player][name],sscanf_cost);
		        ShowPlayerDialog(playerid,dBusinessSellWhomConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Продажа дома игроку",string,"Да","Нет");
		    }
		}
		case dBusinessSellWhomConfirm:{
		    new temp_businessid=owned_business_id[playerid][GetPVarInt(playerid,"tempSelectedBusinessid")];
			if(!temp_businessid){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
			    DeletePVar(playerid,"tempSelectedBusinessid");
			    return true;
			}
		    if(response){
		        if(!GetPVarInt(playerid,"tempSellBusinessCost")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
		            DeletePVar(playerid,"tempSellBusinessPlayer");
					DeletePVar(playerid,"tempSellBusinessCost");
		            return true;
		        }
				new player_id=GetPVarInt(playerid,"tempSellBusinessPlayer");
				if(!GetPVarInt(player_id,"PlayerLogged")){
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Сделка была сорвана!\nИгрок вышел из игры!\n\n","Закрыть","");
					DeletePVar(playerid,"tempSellBusinessPlayer");
					DeletePVar(playerid,"tempSellBusinessCost");
				    return true;
				}
				if(owned_business_id[player_id][MAX_OWNED_BUSINESSES-1]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Игрок владеет максимальным количеством домов!\n\n","Закрыть","");
				    DeletePVar(playerid,"tempSellBusinessPlayer");
					DeletePVar(playerid,"tempSellBusinessCost");
				    return true;
				}
				SetPVarInt(player_id,"tempSellBusinessPlayerid",playerid);
				new string[117-2-2-2+MAX_PLAYER_NAME+4+11];
				format(string,sizeof(string),"\n"BLUE"%s"WHITE" предлагает вам купить его бизнес "BLUE"№%i"WHITE" за "GREEN"$%i\n\n"WHITE"Вы согласны?\n\n",player[playerid][name],temp_businessid,GetPVarInt(playerid,"tempSellBusinessCost"));
				ShowPlayerDialog(player_id,dBusinessSellWhomConfirmPlayer,DIALOG_STYLE_MSGBOX,""BLUE"Продажа бизнеса",string,"Да","Нет");
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Продажа бизнеса","\n"WHITE"Заявка на покупку бизнеса другому игроку отправлена!\n\n","Закрыть","");
		    }
		    else{
				DeletePVar(playerid,"tempSellBusinessPlayer");
				DeletePVar(playerid,"tempSellBusinessCost");
		    }
		}
		case dBusinessSellWhomConfirmPlayer:{
		    if(response){
		        new player_id=GetPVarInt(playerid,"tempSellBusinessPlayerid");
		        new temp_businessid=owned_business_id[player_id][GetPVarInt(player_id,"tempSelectedBusinessid")];
				if(!temp_businessid){
				    ShowPlayerDialog(player_id,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    DeletePVar(player_id,"tempSelectedBusinessid");
				    return true;
				}
				if(!GetPVarInt(player_id,"tempSellBusinessCost") || !GetPVarInt(playerid,"PlayerLogged") || !GetPVarInt(player_id,"PlayerLogged")){
                    DeletePVar(playerid,"tempSellBusinessPlayerid");
	                DeletePVar(player_id,"tempSellBusinessPlayer");
					DeletePVar(player_id,"tempSellBusinessCost");
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    ShowPlayerDialog(player_id,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    return true;
				}
				new string[75-2-2+MAX_PLAYER_NAME+11];
				format(string,sizeof(string),"\n"WHITE"Вы купили бизнес у игрока "BLUE"%s"WHITE" за "GREEN"$%i\n\n",player[player_id][name],GetPVarInt(player_id,"tempSellBusinessCost"));
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация",string,"Закрыть","");
				format(string,sizeof(string),"\n"WHITE"Вы продали свой бизнес игроку "BLUE"%s"WHITE" за "GREEN"$%i\n\n",player[playerid][name],GetPVarInt(player_id,"tempSellBusinessCost"));
				ShowPlayerDialog(player_id,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация",string,"Закрыть","");
				strmid(business[temp_businessid-1][owner],player[playerid][name],0,strlen(player[playerid][name]));
				new query[48-2-2+MAX_PLAYER_NAME+4];
				mysql_format(mysql_connection,query,sizeof(query),"update`businesses`set`owner`='%e'where`id`='%i'",player[playerid][name],temp_businessid);
				mysql_query(mysql_connection,query,false);
				player[playerid][money]-=GetPVarInt(player_id,"tempSellBusinessCost");
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				player[player_id][money]+=GetPVarInt(player_id,"tempSellBusinessCost");
				ResetPlayerMoney(player_id);
				GivePlayerMoney(player_id,player[player_id][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[player_id][money],player[player_id][id]);
				mysql_query(mysql_connection,query,false);
				for(new i=0; i<MAX_OWNED_BUSINESSES; i++){
					if(owned_business_id[playerid][i]){
				        continue;
				    }
				    owned_business_id[playerid][i]=temp_businessid;
				    break;
				}
				for(new i=GetPVarInt(player_id,"tempSelectedBusinessid"); i<MAX_OWNED_BUSINESSES; i++){
				    owned_business_id[player_id][i]=owned_business_id[player_id][i+1];
				}
				DeletePVar(playerid,"tempSellBusinessPlayerid");
                DeletePVar(player_id,"tempSellBusinessPlayer");
				DeletePVar(player_id,"tempSellBusinessCost");
		    }
			else{
			    new player_id=GetPVarInt(playerid,"tempSellBusinessPlayerid");
			    DeletePVar(playerid,"tempSellhomePlayerid");
                DeletePVar(player_id,"tempSellBusinessPlayer");
				DeletePVar(player_id,"tempSellBusinessCost");
			}
		}
		case dBusinessSellState:{
		    if(response){
		        new temp_businessid=owned_business_id[playerid][GetPVarInt(playerid,"tempSelectedBusinessid")];
				if(!temp_businessid){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    DeletePVar(playerid,"tempSelectedBusinessid");
				    return true;
				}
                strmid(business[temp_businessid-1][owner],"-",0,1);
                DestroyDynamicPickup(business[temp_businessid-1][pickupid]);
                business[temp_businessid-1][pickupid]=CreateDynamicPickup(1274,23,business[temp_businessid-1][pos_x],business[temp_businessid-1][pos_y],business[temp_businessid-1][pos_z]);
                new query[47-2+4];
				mysql_format(mysql_connection,query,sizeof(query),"update`businesses`set`owner`='-'where`id`='%i'",temp_businessid);
				mysql_query(mysql_connection,query,false);
				owned_business_id[playerid][GetPVarInt(playerid,"tempSelectedBusinessid")]=0;
				for(new i=GetPVarInt(playerid,"tempSelectedBusinessid"); i<MAX_OWNED_BUSINESSES; i++){
				    owned_business_id[playerid][i]=owned_business_id[playerid][i+1];
				}
		    }
		}
		case dBuyCarConfirm:{
		    if(!GetPVarInt(playerid,"CarDealership_Status")){
		        CancelSelectTextDraw(playerid);
		        for(new i=0; i<sizeof(td_buy_car[]); i++){
			        PlayerTextDrawHide(playerid,td_buy_car[playerid][i]);
			    }
			    DeletePVar(playerid,"CarDealership_Status");
		        return true;
		    }
		    if(response){
		        new temp_item=GetPVarInt(playerid,"CarDealership_Item");
				new temp_businessid=GetPVarInt(playerid,"CarDealership_Businessid");
				new temp_vehicleid=business[temp_businessid-1][item][temp_item-1];
				new temp_price=transport[temp_vehicleid-400][price];
				if(player[playerid][money]<temp_price){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"У Вас недостаточно денег для покупки транспорта!!\n\n","Закрыть","");
				    return true;
				}
				if(!business[temp_businessid-1][item][temp_item-1]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Этой модели нет в автосалоне!\n\n","Закрыть","");
				    CancelSelectTextDraw(playerid);
				    for(new i=0; i<sizeof(td_buy_car[]); i++){
				        PlayerTextDrawHide(playerid,td_buy_car[playerid][i]);
				    }
				    return true;
				}
				if(owned_vehicle_id[playerid][MAX_OWNED_VEHICLES-1] != -1){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Вы владеете максимальным количеством личного транспорта!\n\n","Закрыть","");
				    return true;
				}
				new query[146-2-2-2-2-2-2+3+MAX_PLAYER_NAME+7+7+7+7];
				new temp_count=0;
				for(new i=0; i<MAX_VEHICLES; i++){
				    if(vehicle[i][mysql_id]){
				        continue;
				    }
				    temp_count=i;
				    break;
				}
				mysql_format(mysql_connection,query,sizeof(query),"insert into`vehicles`(`model`,`owner`,`number_plate`,`fuel`,`def_pos`,`parkable`,`color`)values('%i','%e','TRANSIT','%i','%f|%f|%f|%f','1','1|1')",temp_vehicleid,player[playerid][name],transport[temp_vehicleid-400][fuel_tank],business[temp_businessid-1][load_pos_x],business[temp_businessid-1][load_pos_y],business[temp_businessid-1][load_pos_z],business[temp_businessid-1][load_pos_a]);
				mysql_query(mysql_connection,query);
				vehicle[temp_count][mysql_id]=cache_insert_id(mysql_connection);
				vehicle[temp_count][model]=temp_vehicleid;
				vehicle[temp_count][def_pos_x]=business[temp_businessid-1][load_pos_x];
				vehicle[temp_count][def_pos_y]=business[temp_businessid-1][load_pos_y];
				vehicle[temp_count][def_pos_z]=business[temp_businessid-1][load_pos_z];
				vehicle[temp_count][def_pos_a]=business[temp_businessid-1][load_pos_a];
				vehicle[temp_count][fuel]=transport[temp_vehicleid-400][fuel_tank];
                vehicle[temp_count][id]=AddStaticVehicleEx(vehicle[temp_count][model],vehicle[temp_count][def_pos_x],vehicle[temp_count][def_pos_y],vehicle[temp_count][def_pos_z],vehicle[temp_count][def_pos_a],1,1,999999);
                vehicle[temp_count][colors][0]=1;
                vehicle[temp_count][colors][1]=1;
				strmid(vehicle[temp_count][owner],player[playerid][name],0,strlen(player[playerid][name]));
				strmid(vehicle[temp_count][number_plate],"TRANSIT",0,strlen("TRANSIT"));
				vehicle[temp_count][parkable]=true;
				SetVehicleNumberPlate(vehicle[temp_count][id],vehicle[temp_count][number_plate]);
			    SetVehicleToRespawn(vehicle[temp_count][id]);
			    SetVehicleParamsEx(vehicle[temp_count][id],0,0,0,vehicle[temp_count][locked],0,0,0);
			    for(new i=0; i<MAX_OWNED_VEHICLES; i++){
				    if(owned_vehicle_id[playerid][i] != -1){
				        continue;
				    }
				    owned_vehicle_id[playerid][i]=temp_count;
				    break;
				}
                player[playerid][money]-=temp_price;
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query,false);
				total_vehicles++;
				for(new i=0; i<sizeof(td_buy_car[]); i++){
			        PlayerTextDrawHide(playerid,td_buy_car[playerid][i]);
			    }
			    business[temp_businessid-1][item][temp_item-1]=0;
			    new temp_string[4-2+3];
			    new string[sizeof(temp_string)*MAX_ITEMS_IN_BUSINESS];
			    for(new i=0; i<MAX_ITEMS_IN_BUSINESS; i++){
				    format(temp_string,sizeof(temp_string),(i==MAX_ITEMS_IN_BUSINESS-1)?"%i":"%i|",business[temp_businessid-1][item][i]);
				    strcat(string,temp_string);
				}
				mysql_format(mysql_connection,query,sizeof(query),"update`businesses`set`items`='%e'where`id`='%i'",string,temp_businessid);
				mysql_query(mysql_connection,query,false);
				CancelSelectTextDraw(playerid);
				DeletePVar(playerid,"CarDealership_Status");
				SendClientMessage(playerid,C_BLUE,"Поздравляем с покупкой нового транспорта!");
		    }
		}
		case dLockVehicle:{
		    if(response){
				new temp_vehicleid=owned_vehicle_id[playerid][listitem];
				if(temp_vehicleid<0){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
				    return true;
				}
				new Float:temp_x,Float:temp_y,Float:temp_z;
				GetVehiclePos(vehicle[temp_vehicleid][id],temp_x,temp_y,temp_z);
				if(!IsPlayerInRangeOfPoint(playerid,3.0,temp_x,temp_y,temp_z)){
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Вы находитесь далеко от личного транспорта!\n\n","Закрыть","");
				    return true;
				}
				lockOfVehicle(temp_vehicleid,playerid);
		    }
		}
		case dJobLoader:{
			if(response){
				switch(listitem){
					case 0:{
						//что здесь происходит
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Что здесь происходит?\n\n","Закрыть","");
					}
					case 1:{
						//что я могу здесь получить
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Что я могу здесь получить?\n\n","Закрыть","");
					}
					case 2:{
						//я хочу взять работу
						if(GetPVarInt(playerid,"jLoader_")){
							
						}
						else{
							
						}
					}
					case 3:{
						//я хочу забрать деньги за работу
					}
				}
			}
		}
	}
	return true;
}

public OnPlayerSpawn(playerid){
	if(!GetPVarInt(playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы должны авторизоваться!");
	    SetTimerEx("kick_player",250,false,"i",playerid);
	    return true;
	}
	if(GetPVarInt(playerid,"InteriorID")!=-1){
	    SetPVarInt(playerid,"InteriorID",-1);
	}
	switch(GetPVarInt(playerid,"SpawnStatus")){
	    case 1:{
			switch(player[playerid][origin]){
			    case 1,2:{
			        SetPlayerPos(playerid,1755.0696,-1920.8274,13.5723);
			        SetPlayerFacingAngle(playerid,264.0957);
			    }
			    case 3:{
			        switch(random(3)){
			            case 0:{
		                    SetPlayerPos(playerid,1730.2971,-2331.1396,13.5469);
			        		SetPlayerFacingAngle(playerid,7.7399);
			            }
			            case 1:{
			                SetPlayerPos(playerid,1685.5536,-2331.0498,13.5469);
			        		SetPlayerFacingAngle(playerid,3.9799);
			            }
			            case 2:{
			                SetPlayerPos(playerid,1642.4863,-2331.5056,13.5469);
			        		SetPlayerFacingAngle(playerid,358.3398);
			            }
			        }
			    }
			    case 4:{
			        SetPlayerPos(playerid,1715.6703,-1927.4058,13.5659);
			        SetPlayerFacingAngle(playerid,0.5799);
			    }
			}
			SetPlayerVirtualWorld(playerid,0);
		}
		case 2:{
		    new temp_faction_id=player[playerid][faction_id]-1;
			SetPlayerPos(playerid,faction[temp_faction_id][spawn_x],faction[temp_faction_id][spawn_y],faction[temp_faction_id][spawn_z]);
			SetPlayerFacingAngle(playerid,faction[temp_faction_id][spawn_a]);
			SetPlayerVirtualWorld(playerid,faction[temp_faction_id][virtualworld]);
			SetPlayerInterior(playerid,faction[temp_faction_id][interior]);
		}
		case 3:{
			new temp_houseid=owned_house_id[playerid][GetPVarInt(playerid,"SpawnStatusHouse")]-1;
			new temp_house_interior=house[temp_houseid][house_interior]-1;
            SetPlayerPos(playerid,house_interiors[temp_house_interior][pos_x],house_interiors[temp_house_interior][pos_y],house_interiors[temp_house_interior][pos_z]);
            SetPlayerInterior(playerid,house_interiors[temp_house_interior][interior]);
            SetPlayerFacingAngle(playerid,house_interiors[temp_house_interior][pos_a]);
			SetPVarInt(playerid,"HouseID",temp_houseid);
			SetCameraBehindPlayer(playerid);
		}
		default:{
			SetPVarInt(playerid,"SpawnStatus",1);
			SpawnPlayer(playerid);
		    //типа спавн в больнице
		}
	}
	//SetPVarInt(playerid,"SpawnStatus",1);
	SetPlayerSkin(playerid,player[playerid][character]);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,player[playerid][money]);
	SetPlayerScore(playerid,player[playerid][level]);
	SetCameraBehindPlayer(playerid);
	return true;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys){
	#pragma unused oldkeys
	if((gettime()-GetPVarInt(playerid,"FloodKeyState"))<1){
	    return true;
	}
	SetPVarInt(playerid,"FloodKeyState",gettime());
	if(newkeys == KEY_WALK){
	    if(!IsPlayerInAnyVehicle(playerid)){
		    for(new i=0; i<total_entrance; i++){
			    if(IsPlayerInDynamicArea(playerid,entrance[i][area_id][0])){
		            if(entrance[i][locked]){
					    SendClientMessage(playerid,C_RED,"[Информация] Дверь заперта!");
						break;
					}
				    SetPlayerPos(playerid,entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z]);
				    SetPlayerFacingAngle(playerid,entrance[i][exit_a]);
				    SetPlayerInterior(playerid,entrance[i][interior]);
				    SetPlayerVirtualWorld(playerid,entrance[i][virtualworld]);
				    SetCameraBehindPlayer(playerid);
				    break;
			    }
			    else if(IsPlayerInDynamicArea(playerid,entrance[i][area_id][1])){
		            if(entrance[i][locked]){
						SendClientMessage(playerid,C_RED,"[Информация] Дверь заперта!");
						break;
					}
					SetPlayerPos(playerid,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z]);
					SetPlayerFacingAngle(playerid,entrance[i][enter_a]);
					SetPlayerInterior(playerid,0);
					SetPlayerVirtualWorld(playerid,0);
					SetCameraBehindPlayer(playerid);
			    }
			}
			if(IsPlayerInDynamicArea(playerid,area[BANK_CREATE_ACCOUNT])){
				if(GetPVarInt(playerid,"Bank_CreatingAccount")){
				    DeletePVar(playerid,"Bank_CreatingAccount");
	                DeletePVar(playerid,"Bank_CreatingAccountDescription");
	                DeletePVar(playerid,"Bank_CreatingAccountPassword");
				}
				if(player[playerid][passport_id]<100000){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"У вас нет паспорта!\n\n","Закрыть","");
				    return true;
				}
			    new query[47-2+MAX_PLAYER_NAME];
			    mysql_format(mysql_connection,query,sizeof(query),"select`id`from`bank_accounts`where`owner`='%e'",player[playerid][name]);
			    new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
			    new string[96-2+11];
			    format(string,sizeof(string),cache_get_row_count(mysql_connection)?"\n"WHITE"Вы хотите создать новый банковский счёт?\n\n"GREY"Создано банковских счетов - %i\n\n":"\n"WHITE"Вы хотите создать новый банковский счёт?\n\n",cache_get_row_count(mysql_connection));
				ShowPlayerDialog(playerid,dBankCreateAccount,DIALOG_STYLE_MSGBOX,""BLUE"Создание банковского счёта",string,"Да","Нет");
				cache_delete(cache_bank_accounts,mysql_connection);
			    return true;
			}
			if(IsPlayerInDynamicArea(playerid,area[BANK_TILL_ONE]) || IsPlayerInDynamicArea(playerid,area[BANK_TILL_TWO]) || IsPlayerInDynamicArea(playerid,area[BANK_TILL_THREE])){
				if(GetPVarInt(playerid,"tempBankAccount")){
					DeletePVar(playerid,"tempBankAccount");
				}
				ShowPlayerDialog(playerid,dBankAccountInput,DIALOG_STYLE_INPUT,""BLUE"Банковский счёт","\n"WHITE"Введите номер вашего банковского счёта\n\n"GREY"(( Подсказка: /menu [0] [3] ))\n\n","Дальше","Отмена");
				return true;
			}
			for(new i=0; i<total_houses; i++){
                if(IsPlayerInDynamicArea(playerid,house[i][area_id])){
                    if(house[i][locked]){
                        SendClientMessage(playerid,C_RED,"[Информация] Дверь заперта!");
                        break;
                    }
                    new temp_interiorid=house[i][house_interior]-1;
					SetPlayerPos(playerid,house_interiors[temp_interiorid][pos_x],house_interiors[temp_interiorid][pos_y],house_interiors[temp_interiorid][pos_z]);
					SetPlayerFacingAngle(playerid,house_interiors[temp_interiorid][pos_a]);
					SetPlayerInterior(playerid,house_interiors[temp_interiorid][interior]);
					SetPVarInt(playerid,"HouseID",i);
					SetCameraBehindPlayer(playerid);
					new string[32-2+MAX_PLAYER_NAME];
					if(strcmp(house[i][owner],"-")){
						format(string,sizeof(string),"[Информация] Владелец дома - %s",house[i][owner]);
						SendClientMessage(playerid,C_GREEN,string);
					}
					break;
                }
			}
			for(new i=0; i<total_house_interiors; i++){
                if(IsPlayerInDynamicArea(playerid,house_interiors[i][area_id])){
                    new temp_houseid=GetPVarInt(playerid,"HouseID");
                    SetPlayerPos(playerid,house[temp_houseid][enter_x],house[temp_houseid][enter_y],house[temp_houseid][enter_z]);
                    SetPlayerFacingAngle(playerid,house[temp_houseid][enter_a]);
                    SetPlayerInterior(playerid,0);
                    SetCameraBehindPlayer(playerid);
                    DeletePVar(playerid,"HouseID");
                    break;
                }
			}
			if(IsPlayerInDynamicArea(playerid,area[CITYHALL_INFORMATION])){
				ShowPlayerDialog(playerid,dCityHallInf,DIALOG_STYLE_LIST,""BLUE"Информация","[0] Получение паспорта\n[1] Получение разрешения на постройку дома","Выбрать","Отмена");
			    return true;
			}
			if(IsPlayerInDynamicArea(playerid,area[CITYHALL_TAKE_PASSPORT])){
			    new query[69-2+MAX_PLAYER_NAME];
			    mysql_format(mysql_connection,query,sizeof(query),"select`id`,`taken`,`valid_to`from`passports`where`owner`='%e'limit 1",player[playerid][name]);
			    new Cache:cache_passports=mysql_query(mysql_connection,query);
			    new temp_taken;
				temp_taken=cache_get_field_content_int(0,"taken",mysql_connection);
			    if(cache_get_row_count(mysql_connection) && !temp_taken){
					new temp_id;
					temp_id=cache_get_field_content_int(0,"id",mysql_connection);
					player[playerid][passport_id]=temp_id;
					mysql_format(mysql_connection,query,sizeof(query),"update`users`set`passport_id`='%i'where`id`='%i'",player[playerid][passport_id],player[playerid][id]);
					mysql_query(mysql_connection,query,false);
					mysql_format(mysql_connection,query,sizeof(query),"update`passports`set`taken`='1'where`id`='%i'",temp_id);
					mysql_query(mysql_connection,query,false);
					new string[78-2+11];
					format(string,sizeof(string),"\n"WHITE"Поздравляем с получением паспорта!\nНомер паспорта - "BLUE"%i\n\n",temp_id);
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Получение паспорта",string,"Закрыть","");
					DeletePVar(playerid,"passportAge");
	                DeletePVar(playerid,"passportSignature");
	                DeletePVar(playerid,"passportDate");
	                DeletePVar(playerid,"passportValidality");
	                DeletePVar(playerid,"passportDays");
			        return true;
			    }
			    else if(GetPVarInt(playerid,"PayFeeForPassport")==1 || GetPVarInt(playerid,"PayFeeForPassport")==2){//послать в банк за оплатой
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы должны оплатить пошлину за паспорт в банке!\n\n","Закрыть","");
					return true;
				}
			    else if(!GetPVarInt(playerid,"PayFeeForPassport") && !player[playerid][passport_id]){
			    	ShowPlayerDialog(playerid,dCityHallTakePassport,DIALOG_STYLE_MSGBOX,""BLUE"Получение паспорта","\n"WHITE"Для получения паспорта, необходимо заполнить некоторые данные\nВы хотите продолжить?\n\n","Да","Нет");
			    	return true;
				}
				else if(player[playerid][passport_id] && cache_get_row_count(mysql_connection) && temp_taken){
				    new temp_valid_to;
				    temp_valid_to=cache_get_field_content_int(0,"valid_to",mysql_connection);
				    SetPVarInt(playerid,"renewalPassportValidality",temp_valid_to);
				    if(gettime()>=temp_valid_to){
						ShowPlayerDialog(playerid,dCityHallDelOrRenewalPassport,DIALOG_STYLE_MSGBOX,""BLUE"Продление паспорта","\n"WHITE"Срок действия вашего паспорта истёк!\nВы можете продлить его, либо получить новый!\n\n","Продлить","Новый");
				    }
			    	else{
				        new string[55-2+31];
					    format(string,sizeof(string),"\n"WHITE"Ваш паспорт действителен до - "BLUE"%s\n\n",gettimestamp(temp_valid_to));
						ShowPlayerDialog(playerid,dCityHallRenewalPassport,DIALOG_STYLE_MSGBOX,""BLUE"Продление паспорта",string,"Продлить","Отмена");
				    }
				}
				cache_delete(cache_passports,mysql_connection);
			    return true;
			}
			if(IsPlayerInDynamicArea(playerid,area[BANK_PAYMENT_FOR_SERVICES])){
			    ShowPlayerDialog(playerid,dBankPaymentService,DIALOG_STYLE_LIST,""BLUE"Оплата услуг","[0] Оплата пошлины за паспорт\n[1] Оплата пошлины за продление паспорта","Выбрать","Отмена");
				return true;
			}
		    if(IsPlayerInDynamicArea(playerid,faction[player[playerid][faction_id]-1][clothes_areaid])){
		        switch(GetPVarInt(playerid,"factionDuty")){
		            case 0:{
		                SetPVarInt(playerid,"factionDuty",1);
		                SendClientMessage(playerid,C_GREEN,"[Информация] Вы начали рабочий день!");
		                SetPlayerSkin(playerid,faction[player[playerid][faction_id]][skin][player[playerid][rank_id]-1]);
		                return true;
		            }
		            case 1:{
		                SetPVarInt(playerid,"factionDuty",0);
		                SendClientMessage(playerid,C_GREEN,"[Информация] Вы закончили рабочий день!");
		                SetPlayerSkin(playerid,player[playerid][character]);
						return true;
		            }
		        }
		    }
		    if(IsPlayerInDynamicArea(playerid,area[CITYHALL_CREATE_HOUSE])){
		        if(player[playerid][passport_id]<100000){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"У вас нет паспорта!\n\n","Закрыть","");
		            return true;
		        }
		        if(owned_house_id[playerid][MAX_OWNED_HOUSES-1]){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"WHITE"Вы имеете максимальное количество купленных домов!\n\n","Закрыть","");
		            return true;
		        }
		        if(GetPVarInt(playerid,"AddHouse_SetHPos") && (!GetPVarFloat(playerid,"AddHouse_HPosX") || !GetPVarFloat(playerid,"AddHouse_HPosY") || !GetPVarFloat(playerid,"AddHouse_HPosZ"))){
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Размещение дома","\n"WHITE"Вы ещё не выставили координаты для будущего дома!\n\n","Закрыть","");
		            return true;
		        }
		        if(GetPVarInt(playerid,"AddHouse_SetHPos") && GetPVarFloat(playerid,"AddHouse_HPosX") && GetPVarFloat(playerid,"AddHouse_HPosY") && GetPVarFloat(playerid,"AddHouse_HPosZ")){
		            new string[104-2+11];
		            format(string,sizeof(string),"\n"WHITE"Вы хотите разместить дом в указанных координатах?\n\nВам необходимо заплатить "GREEN"$%i\n\n",GetPVarInt(playerid,"AddHouse_TotalCost"));
		            ShowPlayerDialog(playerid,dCityHallAddHouseConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Размещение дома",string,"Да","Нет");
		            return true;
		        }
		        ShowPlayerDialog(playerid,dCityHallAddHouse,DIALOG_STYLE_MSGBOX,""BLUE"Размещение дома","\n"WHITE"Вы хотите разместить новый дом в штате?\n\n","Да","Нет");
		        return true;
		    }
		    for(new i=0; i<sizeof(lift_floor); i++){
			    if(IsPlayerInDynamicArea(playerid,area[BUSINESS_CENTER_LIFT][i])){
			        new temp_string[36];
			        static string[sizeof(lift_floor)*sizeof(temp_string)];
			        string="[0] Вход\n";
			        for(new j=1; j<sizeof(lift_floor); j++){
			            format(temp_string,sizeof(temp_string),(i == j) ? "[%i] %i этаж "GREY"[ Вы здесь ]\n":"[%i] %i этаж\n",j,j);
			            strcat(string,temp_string);
			        }
			        ShowPlayerDialog(playerid,dBusinessCenterLift,DIALOG_STYLE_LIST,""BLUE"Лифт",string,"Выбрать","Отмена");
			        string="\0";
			        break;
			    }
			}
			for(new i=0; i<total_businesses; i++){
                if(IsPlayerInDynamicArea(playerid,business[i][area_id])){
                    if(business[i][locked]){
                        SendClientMessage(playerid,C_RED,"[Информация] Дверь заперта!");
                        break;
                    }
                    new temp_interiorid=business[i][business_interior]-1;
					SetPlayerPos(playerid,business_interiors[temp_interiorid][pos_x],business_interiors[temp_interiorid][pos_y],business_interiors[temp_interiorid][pos_z]);
					SetPlayerFacingAngle(playerid,business_interiors[temp_interiorid][pos_a]);
					SetPlayerInterior(playerid,business_interiors[temp_interiorid][interior]);
					SetPlayerVirtualWorld(playerid,i+1);
					SetPVarInt(playerid,"BusinessID",i);
					SetCameraBehindPlayer(playerid);
					new string[32-2+MAX_PLAYER_NAME];
					if(strcmp(business[i][owner],"-")){
						format(string,sizeof(string),"[Информация] Владелец бизнеса - %s",business[i][owner]);
						SendClientMessage(playerid,C_GREEN,string);
					}
					break;
                }
			}
			for(new i=0; i<total_businesses; i++){
				if(IsPlayerInDynamicArea(playerid,business[i][action_area_id])){
					switch(business[i][type]){
					    case 1:{//автосалон
					        new temp_item=0;
							for(new j=0; j<32; j++){
							    if(!business[i][item][j]){
							        continue;
							    }
							    temp_item=j+1;
							    break;
							}
							if(!temp_item){
								ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Информация","\n"WHITE"В автосалоне нет транспорта!\n\n","Закрыть","");
							    return true;
							}
							new temp_vehicleid=business[i][item][temp_item-1];
							PlayerTextDrawSetPreviewModel(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1],temp_vehicleid);
							PlayerTextDrawSetPreviewVehCol(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1],1,1);
							PlayerTextDrawSetPreviewModel(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2],temp_vehicleid);
							PlayerTextDrawSetPreviewVehCol(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2],1,1);
							new temp_string[11-2+32];
							format(temp_string,sizeof(temp_string),"MODEL - %s",transport[temp_vehicleid-400][name]);
							PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_MODEL],temp_string);
							format(temp_string,sizeof(temp_string),"PRICE - $%i",transport[temp_vehicleid-400][price]);
							PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_PRICE],temp_string);
							format(temp_string,sizeof(temp_string),"FUEL TANK - %iliters",transport[temp_vehicleid-400][fuel_tank]);
							PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_FUEL_TANK],temp_string);
							for(new j=0; j<sizeof(td_buy_car[]); j++){
							    PlayerTextDrawShow(playerid,td_buy_car[playerid][j]);
							}
							SelectTextDraw(playerid,C_BLUE);
							SetPVarInt(playerid,"CarDealership_Status",1);
							SetPVarInt(playerid,"CarDealership_Item",temp_item);
							SetPVarInt(playerid,"CarDealership_Businessid",i+1);
							break;
					    }
					    default:{
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Информация","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
							break;
					    }
					}
			    }
			}
			for(new i=0; i<total_business_interiors; i++){
                if(IsPlayerInDynamicArea(playerid,business_interiors[i][area_id])){
                    new temp_businessid=GetPVarInt(playerid,"BusinessID");
                    SetPlayerPos(playerid,business[temp_businessid][pos_x],business[temp_businessid][pos_y],business[temp_businessid][pos_z]);
                    SetPlayerFacingAngle(playerid,business[temp_businessid][pos_a]);
                    SetPlayerInterior(playerid,0);
                    SetPlayerVirtualWorld(playerid,0);
                    SetCameraBehindPlayer(playerid);
                    DeletePVar(playerid,"BusinessID");
                    break;
                }
			}
			if(IsPlayerInDynamicArea(playerid,area[JOB_LOADER_NPC])){
				ShowPlayerDialog(playerid,dJobLoader,DIALOG_STYLE_LIST,""BLUE"Диалог","[0] - Здравствуй, что здесь происходит?\n[1] - Что я смогу здесь получить?\n[2] - Я хочу взять работу!\n[3] - Я хочу забрать деньги за работу!","Выбрать","Отмена");
			    return true;
			}
			if(IsPlayerInDynamicArea(playerid,area[JOB_LOADER_CLOTHES])){
				if(GetPVarInt(playerid,"JobLoader_Status")==2){
				    new temp_money=GetPVarInt(playerid,"JobLoader_Transferred")*9;
					new temp_salary[68-2+11];
					format(temp_salary,sizeof(temp_salary),temp_money?"заработали "GREEN"$%i! Подойтите к прорабу, чтобы получить деньги!":"ничего не заработали!",temp_money);
					new string[26-2+sizeof(temp_salary)];
					format(string,sizeof(string),"Вы закончили работу и %s",temp_salary);
					SendClientMessage(playerid,C_BLUE,string);
					RemovePlayerAttachedObject(playerid,GetPVarInt(playerid,"JobLoader_SlotID"));
				    DeletePVar(playerid,"JobLoader_Status");
				    DeletePVar(playerid,"JobLoader_Transferred");
					SetPVarInt(playerid,"JobLoader_WithdrawMoney",temp_money);
					DeletePVar(playerid,"JobLoader_SlotID");
				}
				else if(GetPVarInt(playerid,"JobLoader_Status")==1){
				    for(new i=0; i<10; i++){
				        if(IsPlayerAttachedObjectSlotUsed(playerid,i)){
				            continue;
				        }
				        SetPVarInt(playerid,"JobLoader_SlotID",i);
				        break;
				    }
				    SetPlayerAttachedObject(playerid,GetPVarInt(playerid,"JobLoader_SlotID"),18638,2);
				    EditAttachedObject(playerid,GetPVarInt(playerid,"JobLoader_SlotID"));
				    SendClientMessage(playerid,-1,"[Информация] (( Вам нужно разместить рабочую экипировку на месте, где положено! ))");
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Информация","\n"WHITE"Вы не можете взять экипировку, пока прораб не нанял Вас!\n\n","Закрыть","");
				}
				return true;
			}
		}
	    return true;
	}
	else if(newkeys & KEY_SUBMISSION){
		if(IsPlayerInAnyVehicle(playerid)){
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
				cmd::engine(playerid);
				return true;
		    }
		}
	    return true;
	}
	return true;
}

public OnPlayerText(playerid,text[]){
	if(!GetPVarInt(playerid,"PlayerLogged")){
	    return false;
	}
	if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return false;
	}
	new string[17-2-2+128+MAX_PLAYER_NAME];
	format(string,sizeof(string),"- %s - сказал %s",text,player[playerid][name]);
	ProxDetector(15.0,playerid,string,-1,-1,-1,-1,-1);
	return false;
}

public OnPlayerEnterCheckpoint(playerid){
	if(GetPVarInt(playerid,"Checkpoint_Status")){
	    DisablePlayerCheckpoint(playerid);
	    return true;
	}
	return true;
}

public OnGameModeExit(){
	KillTimer(timer_general);
	KillTimer(timer_minute);
	return true;
}

public OnPlayerStateChange(playerid,newstate,oldstate){
	if(newstate == PLAYER_STATE_DRIVER){
	    new temp_vehicleid=GetPlayerVehicleID(playerid);
		if(IsValidVehicle(temp_vehicleid)){
		    new temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective;
			GetVehicleParamsEx(temp_vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
			for(new i=0; i<MAX_VEHICLES; i++){
			    if(vehicle[i][id] == temp_vehicleid){
			        temp_vehicleid=i;
			        break;
			    }
			}
			PlayerTextDrawShow(playerid,td_speed[playerid][0]);
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_SPEED]);
			PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_DOORS],temp_doors?C_RED:C_GREEN);
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_DOORS]);
			PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_LIGHTS],temp_lights?C_GREEN:C_RED);
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_LIGHTS]);
			new string[8-2+11];
			format(string,sizeof(string),"way:%.02f",vehicle[temp_vehicleid][mileage]);
			PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_WAY],string);
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_WAY]);
			format(string,sizeof(string),"fuel:%.01f",vehicle[temp_vehicleid][fuel]);
			PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_FUEL],string);
			PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_FUEL],C_GREY);
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_FUEL]);
			if(!temp_engine){
			    SendClientMessage(playerid,C_GREEN,"[Информация] Чтобы завести двигатель, используйте клавишу \"2\" или команду \"/engine\"");
			    PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_FUEL]);
				PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_FUEL],C_RED);
			    PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_FUEL],"fuel:eng off");
			    PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_FUEL]);
			}
			else{
			    timer_speed[playerid]=SetTimerEx("speed",150,false,"i",playerid,temp_vehicleid);
			}
		}
	}
	else if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT){
	    for(new i=0; i<sizeof(td_speed[]); i++){
	        PlayerTextDrawHide(playerid,td_speed[playerid][i]);
	    }
	    KillTimer(timer_speed[playerid]);
	}
	return true;
}

public OnPlayerClickTextDraw(playerid,Text:clickedid){
    if(_:clickedid == INVALID_TEXT_DRAW){
	    if(GetPVarInt(playerid,"RequestStatus")==1){
	        SelectTextDraw(playerid,C_BLUE);
	    }
	    else if(GetPVarInt(playerid,"RequestStatus")==2){
	        SelectTextDraw(playerid,C_BLUE);
	    }
	    else if(GetPVarInt(playerid,"CarDealership_Status")){
	        SelectTextDraw(playerid,C_BLUE);
	    }
	    return true;
	}
	return true;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid){
	if(GetPVarInt(playerid,"RequestStatus")==1){
		if(playertextid == td_register[playerid][TD_REG_BEAT_PASSWORD]){
            ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Введите ваш будущий пароль\n\n","Выбрать","Закрыть");
		}
		else if(playertextid == td_register[playerid][TD_REG_BEAT_EMAIL]){
		    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Введите ваш адрес эл. почты\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
		}
		else if(playertextid == td_register[playerid][TD_REG_BEAT_REFERRER]){
		    ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Вы можете ввести никнейм или промокод, если пришли по приглашению\n\n"GREY"Это действие не обязательно!\n\n","Выбрать","Закрыть");
		}
		else if(playertextid == td_register[playerid][TD_REG_BEAT_GENDER]){
		    new temp_gender=GetPVarInt(playerid,"RegGender");
		    temp_gender=temp_gender==2?1:2;
		    PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_GENDER],temp_gender==2?"FEMALE":"MALE");
			PlayerTextDrawHide(playerid,td_register[playerid][TD_REG_CHARACTER]);
			new temp_origin=GetPVarInt(playerid,"RegOrigin");
			PlayerTextDrawSetPreviewModel(playerid,td_register[playerid][TD_REG_CHARACTER],reg_characters[temp_origin-1][temp_gender-1][0]);
			PlayerTextDrawShow(playerid,td_register[playerid][TD_REG_CHARACTER]);
			SetPVarInt(playerid,"RegCharacter",1);
		    SetPVarInt(playerid,"RegGender",temp_gender);
		}
		else if(playertextid == td_register[playerid][TD_REG_BEAT_ORIGIN]){
			new temp_origin=GetPVarInt(playerid,"RegOrigin");
			temp_origin++;
			if(temp_origin>=5){
			    temp_origin=1;
			}
			new temp_origins[4][16]={"EUROPEAN","NEGROID","MONGOLOID","AMERICANOID"};
			PlayerTextDrawSetString(playerid,td_register[playerid][TD_REG_ORIGIN],temp_origins[temp_origin-1]);
			PlayerTextDrawHide(playerid,td_register[playerid][TD_REG_CHARACTER]);
			new temp_gender=GetPVarInt(playerid,"RegGender");
			PlayerTextDrawSetPreviewModel(playerid,td_register[playerid][TD_REG_CHARACTER],reg_characters[temp_origin-1][temp_gender-1][0]);
			PlayerTextDrawShow(playerid,td_register[playerid][TD_REG_CHARACTER]);
			SetPVarInt(playerid,"RegCharacter",1);
			SetPVarInt(playerid,"RegOrigin",temp_origin);
		}
		else if(playertextid == td_register[playerid][TD_REG_ARROW_LEFT]){
		    new temp_gender=GetPVarInt(playerid,"RegGender");
		    new temp_characters_stack_id[4][2]={{14,7},{8,4},{6,5},{16,6}};
		    new temp_character=GetPVarInt(playerid,"RegCharacter");
		    new temp_origin=GetPVarInt(playerid,"RegOrigin");
		    temp_character--;
		    if(temp_character<=0){
		        temp_character=temp_characters_stack_id[temp_origin-1][temp_gender-1];
		    }
		    PlayerTextDrawHide(playerid,td_register[playerid][TD_REG_CHARACTER]);
		    PlayerTextDrawSetPreviewModel(playerid,td_register[playerid][TD_REG_CHARACTER],reg_characters[temp_origin-1][temp_gender-1][temp_character-1]);
		    PlayerTextDrawShow(playerid,td_register[playerid][TD_REG_CHARACTER]);
		    SetPVarInt(playerid,"RegCharacter",temp_character);
		}
		else if(playertextid == td_register[playerid][TD_REG_ARROW_RIGHT]){
		    new temp_gender=GetPVarInt(playerid,"RegGender");
		    new temp_characters_stack_id[4][2]={{14,7},{8,4},{6,5},{16,6}};
		    new temp_character=GetPVarInt(playerid,"RegCharacter");
		    new temp_origin=GetPVarInt(playerid,"RegOrigin");
		    temp_character++;
		    if(temp_character>=temp_characters_stack_id[temp_origin-1][temp_gender-1]){
		        temp_character=1;
		    }
		    PlayerTextDrawHide(playerid,td_register[playerid][TD_REG_CHARACTER]);
		    PlayerTextDrawSetPreviewModel(playerid,td_register[playerid][TD_REG_CHARACTER],reg_characters[temp_origin-1][temp_gender-1][temp_character-1]);
		    PlayerTextDrawShow(playerid,td_register[playerid][TD_REG_CHARACTER]);
		    SetPVarInt(playerid,"RegCharacter",temp_character);
		}
		else if(playertextid == td_register[playerid][TD_REG_BEAT_AGE]){
		    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"Регистрация","\n"WHITE"Введите возраст вашего персонажа\n"GREY"Пример: (16 - 60)\n\n","Выбрать","Закрыть");
		}
		else if(playertextid == td_register[playerid][TD_REG_LOG_UP]){
		    new temp_password[MAX_PASSWORD_LEN];
			GetPVarString(playerid,"RegPassword",temp_password,MAX_PASSWORD_LEN);
		    if(!regex_match(temp_password,"[a-zA-Z0-9]{4,24}+")){
                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,"Регистрация","\n"RED"Пароль не подходит по параметрам, либо не введён!\n\n"GREY"Допустимые символы - Aa-Zz, 0-9\nДлина пароля - 4-24 символа\n\n","Закрыть","");
                return true;
            }
            new temp_age=GetPVarInt(playerid,"RegAge");
            if(temp_age<16 || temp_age>60){
                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,"Регистрация","\n"RED"Возраст персонажа не подходит по параметрам, либо не введён!\n\n"GREY"Допустимый возраст - 16-60 лет\n\n","Закрыть","");
                return true;
            }
            new temp_origin=GetPVarInt(playerid,"RegOrigin");
            new temp_gender=GetPVarInt(playerid,"RegGender");
            new temp_character=GetPVarInt(playerid,"RegCharacter");
            new temp_email[MAX_EMAIL_LEN];
            GetPVarString(playerid,"RegEmail",temp_email,MAX_EMAIL_LEN);
            new temp_referrer[MAX_PROMOCODE_LEN];
            GetPVarString(playerid,"RegReferrer",temp_referrer,MAX_PROMOCODE_LEN);
            static string[238];
            string="\n";
            if(strlen(temp_email)<MAX_EMAIL_LEN){
                strcat(string,""WHITE"Вы не указали почту при регистрации!\nЭто можно сделать позже "GREY"в настройках аккаунта!");
            }
            if(strlen(string)>2){
                strcat(string,"\n\n");
            }
			if(strlen(temp_referrer)<MAX_PROMOCODE_LEN){
			    strcat(string,""WHITE"Вы не указали промокод или игрока, который вас пригласил!\nЭто можно сделать позже "GREY"в меню реферальной системы!");
			    if(strlen(temp_email)<MAX_EMAIL_LEN){
			        strcat(string,"\n\n");
			    }
			}
			if(strlen(string)>2){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация",string,"Закрыть","");
			    string="\0";
			}
			player[playerid][age]=temp_age;
			player[playerid][origin]=temp_origin;
			player[playerid][gender]=temp_gender;
			player[playerid][character]=reg_characters[temp_origin-1][temp_gender-1][temp_character-1];
			strins(player[playerid][email],"-",0);
			if(strlen(temp_email)>MIN_EMAIL_LEN){
			    strins(player[playerid][email],temp_email,0);
			}
			strins(player[playerid][referal_name],"-",0);
			if(strlen(temp_referrer)>MIN_PROMOCODE_LEN){
			    strins(player[playerid][referal_name],temp_referrer,0);
			}
			player[playerid][money]=200;
			player[playerid][level]=1;
			new temp_ip[16];
			GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
			strins(player[playerid][reg_ip],temp_ip,0);
			new query[158-2-2-2-2-2-2-2-2+MAX_PLAYER_NAME+MAX_PASSWORD_LEN+MAX_EMAIL_LEN+MAX_PROMOCODE_LEN+1+3+sizeof(temp_ip)];
			mysql_format(mysql_connection,query,sizeof(query),"insert into`users`(`name`,`password`,`email`,`referal_name`,`age`,`origin`,`gender`,`character`,`reg_ip`)values('%e','%e','%e','%e','%i','%i','%i','%i','%e')",player[playerid][name],temp_password,temp_email,temp_referrer,temp_age,temp_origin,temp_gender,player[playerid][character],temp_ip);
			new Cache:cache_users=mysql_query(mysql_connection,query);
			player[playerid][id]=cache_insert_id(mysql_connection);
			cache_delete(cache_users,mysql_connection);
			mysql_format(mysql_connection,query,sizeof(query),"select`reg_date`from`users`where`id`='%i'",player[playerid][id]);
			cache_users=mysql_query(mysql_connection,query);
			cache_get_field_content(0,"reg_date",player[playerid][reg_date],mysql_connection,32);
			cache_delete(cache_users,mysql_connection);
			for(new i=0; i<sizeof(td_register[]); i++){
			    PlayerTextDrawHide(playerid,td_register[playerid][i]);
			}
			CancelSelectTextDraw(playerid);
			DeletePVar(playerid,"RequestStatus");
			DeletePVar(playerid,"RegPassword");
			DeletePVar(playerid,"RegAge");
			DeletePVar(playerid,"RegOrigin");
			DeletePVar(playerid,"RegGender");
			DeletePVar(playerid,"RegCharacter");
			DeletePVar(playerid,"RegEmail");
			DeletePVar(playerid,"RegReferrer");
			SetPVarInt(playerid,"PlayerLogged",1);
			TogglePlayerSpectating(playerid,false);
			SpawnPlayer(playerid);
		}
		return true;
	}
	else if(GetPVarInt(playerid,"RequestStatus")==2){
	    if(playertextid == td_authorization[playerid][TD_AUTH_BEAT_PASSWORD]){
	        ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_PASSWORD,"Авторизация","\n"WHITE"Введите пароль для авторизации\n\n","Выбрать","Закрыть");
	    }
	    else if(playertextid == td_authorization[playerid][TD_AUTH_LOG_IN]){
	        new temp_password[MAX_PASSWORD_LEN];
	        GetPVarString(playerid,"AuthPassword",temp_password,MAX_PASSWORD_LEN);
	        if(!regex_match(temp_password,"[a-zA-Z0-9]{4,24}+")){//Если возвращаемое значение регулярного выражения будет равен нулю(лжи), то услоавие пройдёт в тело
                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,"Авторизация","\n"RED"Пароль не подходит по параметрам, либо не введён!\n\n"GREY"Доступные символы - Aa-Zz, 0-9\nДлина пароля - 4-24 символа\n\n","Закрыть","");
                return true;// Выходим из функции
            }
            new query[53-2-2+MAX_PLAYER_NAME+MAX_PASSWORD_LEN];
			mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`password`='%e'and`name`='%e'",temp_password,player[playerid][name]);
			new Cache:cache_users=mysql_query(mysql_connection,query);
			if(cache_get_row_count(mysql_connection)){
			    player[playerid][id]=cache_get_field_content_int(0,"id",mysql_connection);
				cache_get_field_content(0,"email",player[playerid][email],mysql_connection,MAX_EMAIL_LEN);
				cache_get_field_content(0,"referal_name",player[playerid][referal_name],mysql_connection,MAX_EMAIL_LEN);
				player[playerid][age]=cache_get_field_content_int(0,"age",mysql_connection);
				player[playerid][origin]=cache_get_field_content_int(0,"origin",mysql_connection);
				player[playerid][gender]=cache_get_field_content_int(0,"gender",mysql_connection);
				player[playerid][character]=cache_get_field_content_int(0,"character",mysql_connection);
				player[playerid][level]=cache_get_field_content_int(0,"level",mysql_connection);
				player[playerid][experience]=cache_get_field_content_int(0,"experience",mysql_connection);
				cache_get_field_content(0,"reg_ip",player[playerid][reg_ip],mysql_connection,16);
				cache_get_field_content(0,"reg_date",player[playerid][reg_date],mysql_connection,32);
				new temp_payday[24];
				cache_get_field_content(0,"payday",temp_payday,mysql_connection,sizeof(temp_payday));
				sscanf(temp_payday,"p<|>iib",payday[playerid][time],payday[playerid][salary],payday[taken]);
				player[playerid][money]=cache_get_field_content_int(0,"money",mysql_connection);
				player[playerid][passport_id]=cache_get_field_content_int(0,"passport_id",mysql_connection);
				cache_get_field_content(0,"description",player[playerid][description],mysql_connection,64);
				player[playerid][faction_id]=cache_get_field_content_int(0,"faction_id",mysql_connection);
				player[playerid][rank_id]=cache_get_field_content_int(0,"rank_id",mysql_connection);
				player[playerid][mute]=cache_get_field_content_int(0,"mute",mysql_connection);
				SendClientMessage(playerid,C_GREEN,"Вы успешно авторизовались!");
				#if defined SERVER_OPENBETATEST
				    SendClientMessage(playerid,C_GREY," - Режим ОБТ активирован -");
					SendClientMessage(playerid,C_GREY," - Доступные команды: /payday_time /setmoney /giveadmin /givecmd /givecmd_id -");
					SendClientMessage(playerid,C_GREY," -                       -");
				#endif
				for(new i=0; i<sizeof(td_authorization[]); i++){
				    PlayerTextDrawHide(playerid,td_authorization[playerid][i]);
				}
				DeletePVar(playerid,"RequestStatus");
				DeletePVar(playerid,"AuthPassword");
				CancelSelectTextDraw(playerid);
				mysql_format(mysql_connection,query,sizeof(query),"select`id`from`houses`where`owner`='%e'",player[playerid][name]);
				new Cache:cache_houses=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
				    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
				        owned_house_id[playerid][i]=cache_get_field_content_int(i,"id",mysql_connection);
				    }
				}
				cache_delete(cache_houses,mysql_connection);
				cache_set_active(cache_users,mysql_connection);
				mysql_format(mysql_connection,query,sizeof(query),"select`id`from`businesses`where`owner`='%e'",player[playerid][name]);
				new Cache:cache_businesses=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
				    for(new i=0,j=cache_get_row_count(mysql_connection); i<j; i++){
				        owned_business_id[playerid][i]=cache_get_field_content_int(i,"id",mysql_connection);
				    }
				}
				cache_delete(cache_businesses,mysql_connection);
				cache_set_active(cache_users,mysql_connection);
				new temp_ip[16];
				GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
				mysql_format(mysql_connection,query,sizeof(query),"insert into`connects`(`id`,`ip`)values('%i','%e')",player[playerid][id],temp_ip);
				mysql_query(mysql_connection,query);
				if(player[playerid][faction_id]){
				    new temp_faction_id=player[playerid][faction_id];
				    mysql_format(mysql_connection,query,sizeof(query),"select`id`from`factions`where`leader`='%e'and`id`='%i'",player[playerid][name],temp_faction_id);
					new Cache:cache_factions=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    SetPVarInt(playerid,"IsPlayerLeader",1);
					    new string[39-2+32];
					    format(string,sizeof(string),"Вы авторизовались как лидер фракции %s",faction[temp_faction_id-1][name]);
					    SendClientMessage(playerid,C_BLUE,string);
					}
					cache_delete(cache_factions,mysql_connection);
					mysql_format(mysql_connection,query,sizeof(query),"select`id`from`factions`where`sub_leader`='%e'and`id`='%i'",player[playerid][name],temp_faction_id);
					cache_factions=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    SetPVarInt(playerid,"IsPlayerSubleader",1);
					    new string[52-2+32];
					    format(string,sizeof(string),"Вы авторизовались как заместитель лидера фракции %s",faction[temp_faction_id-1][name]);
					    SendClientMessage(playerid,C_BLUE,string);
					}
					cache_delete(cache_factions,mysql_connection);
				}
				for(new i=0; i<MAX_OWNED_VEHICLES; i++){
				    owned_vehicle_id[playerid][i]=-1;
				}
				mysql_format(mysql_connection,query,sizeof(query),"select*from`vehicles`where`owner`='%e'",player[playerid][name]);
				new Cache:cache_vehicles=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					for(new i=0, j=cache_get_row_count(mysql_connection); i<j; i++){
						vehicle[total_vehicles][mysql_id]=cache_get_field_content_int(i,"id",mysql_connection);
				        vehicle[total_vehicles][model]=cache_get_field_content_int(i,"model",mysql_connection);
				        cache_get_field_content(i,"owner",vehicle[total_vehicles][owner],mysql_connection,MAX_PLAYER_NAME);
				        cache_get_field_content(i,"number_plate",vehicle[total_vehicles][number_plate],mysql_connection,MAX_PLAYER_NAME);
				        new temp_pos[64];
				        cache_get_field_content(i,"def_pos",temp_pos,mysql_connection,sizeof(temp_pos));
				        sscanf(temp_pos,"p<|>ffff",vehicle[total_vehicles][def_pos_x],vehicle[total_vehicles][def_pos_y],vehicle[total_vehicles][def_pos_z],vehicle[total_vehicles][def_pos_a]);
				        cache_get_field_content(i,"park_pos",temp_pos,mysql_connection,sizeof(temp_pos));
				        sscanf(temp_pos,"p<|>ffff",vehicle[total_vehicles][park_pos_x],vehicle[total_vehicles][park_pos_y],vehicle[total_vehicles][park_pos_z],vehicle[total_vehicles][park_pos_a]);
						new temp_parkable=cache_get_field_content_int(i,"parkable",mysql_connection);
						vehicle[total_vehicles][parkable]=bool:temp_parkable;
						new temp_colors[8];
						cache_get_field_content(i,"color",temp_colors,mysql_connection,sizeof(temp_colors));
						sscanf(temp_colors,"p<|>a<i>[2]",vehicle[total_vehicles][colors]);
						vehicle[total_vehicles][fuel]=cache_get_field_content_float(i,"fuel",mysql_connection);
						vehicle[total_vehicles][mileage]=cache_get_field_content_float(i,"mileage",mysql_connection);
						vehicle[total_vehicles][locked]=cache_get_field_content_int(i,"locked",mysql_connection);
					    if(!vehicle[total_vehicles][park_pos_x] || !vehicle[total_vehicles][park_pos_y] || !vehicle[total_vehicles][park_pos_z]){
							vehicle[total_vehicles][id]=AddStaticVehicleEx(vehicle[total_vehicles][model],vehicle[total_vehicles][def_pos_x],vehicle[total_vehicles][def_pos_y],vehicle[total_vehicles][def_pos_z],vehicle[total_vehicles][def_pos_a],vehicle[total_vehicles][colors][0],vehicle[total_vehicles][colors][1],999999);
						}
						else if(!(!vehicle[total_vehicles][def_pos_x] || !vehicle[total_vehicles][def_pos_y] || !vehicle[total_vehicles][def_pos_z]) && (vehicle[total_vehicles][park_pos_x] || vehicle[total_vehicles][park_pos_y] || vehicle[total_vehicles][park_pos_z])){
						    vehicle[total_vehicles][id]=AddStaticVehicleEx(vehicle[total_vehicles][model],vehicle[total_vehicles][park_pos_x],vehicle[total_vehicles][park_pos_y],vehicle[total_vehicles][park_pos_z],vehicle[total_vehicles][park_pos_a],vehicle[total_vehicles][colors][0],vehicle[total_vehicles][colors][1],999999);
						}
						ChangeVehicleColor(vehicle[total_vehicles][id],vehicle[total_vehicles][colors][0],vehicle[total_vehicles][colors][1]);
						SetVehicleNumberPlate(vehicle[total_vehicles][id],vehicle[total_vehicles][number_plate]);
					    SetVehicleToRespawn(vehicle[total_vehicles][id]);
					    if(IsValidVehicle(vehicle[total_vehicles][model])){
					    	SetVehicleParamsEx(vehicle[total_vehicles][id],0,0,0,vehicle[total_vehicles][locked],0,0,0);
						}
						else{
						    SetVehicleParamsEx(vehicle[total_vehicles][id],1,0,0,vehicle[total_vehicles][locked],0,0,0);
						}
						owned_vehicle_id[playerid][i]=total_vehicles;
					    total_vehicles++;
					}
				}
				cache_delete(cache_vehicles,mysql_connection);
				cache_set_active(cache_users,mysql_connection);
				mysql_format(mysql_connection,query,sizeof(query),"select`id`,`commands`,`password`from`admins`where`name`='%e'limit 1",player[playerid][name]);
				new Cache:cache_admins=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
				    new temp_commands[64];
				    admin[playerid][id]=cache_get_field_content_int(0,"id",mysql_connection);
				    cache_get_field_content(0,"commands",temp_commands,mysql_connection,sizeof(temp_commands));
					new temp_sscanf[13-2+2];
					format(temp_sscanf,sizeof(temp_sscanf),"p<|>a<i>[%i]",MAX_ADMIN_COMMANDS);					
				    sscanf(temp_commands,temp_sscanf,admin[playerid][commands]);
				    cache_get_field_content(0,"password",admin[playerid][password],mysql_connection,16);
				    if(!strcmp(admin[playerid][password],"-")){
				        ShowPlayerDialog(playerid,dAdminPasswordCreate,DIALOG_STYLE_INPUT,""BLUE"Установка пароля Администратора","\n"WHITE"Введите желаемый пароль для авторизации в админ-панели\n\n","Дальше","Выход");
				    }
				    else{
				        ShowPlayerDialog(playerid,dAdminPasswordInput,DIALOG_STYLE_INPUT,""BLUE"Авторизация в админ-панели","\n"WHITE"Введите пароль для авторизации в админ-панели\n\n","Дальше","Выход");
				    }
				    return true;
				}
				cache_delete(cache_admins,mysql_connection);
				cache_set_active(cache_users,mysql_connection);
				new string[61+25+25];
				format(string,sizeof(string),"[0] Обычный спавн\n[1] Спавн фракции %s\n[2] Спавн в доме %s",(player[playerid][faction_id]?""GREEN"[ доступно ]":""RED"[ не доступно ]"),(owned_house_id[playerid][0]?""GREEN"[ доступно ]":""RED"[ не доступно ]"));
				ShowPlayerDialog(playerid,dAuthorizationSpawn,DIALOG_STYLE_LIST,""BLUE"Выбор спавна",string,"Выбрать","");
				/*
				SetPVarInt(playerid,"PlayerLogged",1);
				TogglePlayerSpectating(playerid,false);
				SpawnPlayer(playerid);*/
			}
			else{
			    new temp_attemps=GetPVarInt(playerid,"PasswordAttempts");
			    temp_attemps--;
				new string[78-2+1];
				format(string,sizeof(string),"\n"WHITE"Вы ввели неправильный пароль к аккаунту!\n\n"GREY"Попытки - %i/3\n\n",temp_attemps);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,"Авторизация",string,"Закрыть","");
				if(!temp_attemps){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,"Авторизация","\n"WHITE"Вы ввели неправильный пароль три раза и были кикнуты!\n\n","Закрыть","");
				    SetTimerEx("kick_player",250,false,"i",playerid);
				    return true;
				}
				SetPVarInt(playerid,"PasswordAttempts",temp_attemps);
			}
			cache_delete(cache_users,mysql_connection);
	    }
	}
	else if(GetPVarInt(playerid,"CarDealership_Status")){
	    if(playertextid == td_buy_car[playerid][TD_BUY_CAR_SELECT_VEHICLE_ARROW_RIGHT]){
			new temp_item=GetPVarInt(playerid,"CarDealership_Item");
			new temp_businessid=GetPVarInt(playerid,"CarDealership_Businessid");
			new temp_count=0;
			for(new i=temp_item;;i++){
	            if(temp_count>=64){
	                break;
	            }
	            if(i==32){
			        i=0;
			    }
			    if(business[temp_businessid-1][item][i]){
			        temp_item=i+1;
			        break;
	            }
	            temp_count++;
	        }
	        new temp_vehicleid=business[temp_businessid-1][item][temp_item-1];
	        PlayerTextDrawHide(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1]);
	        PlayerTextDrawHide(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2]);
	        PlayerTextDrawSetPreviewModel(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1],temp_vehicleid);
			PlayerTextDrawSetPreviewVehCol(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1],1,1);
			PlayerTextDrawSetPreviewModel(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2],temp_vehicleid);
			PlayerTextDrawSetPreviewVehCol(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2],1,1);
	        PlayerTextDrawShow(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1]);
	        PlayerTextDrawShow(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2]);
			new temp_string[11-2+32];
			format(temp_string,sizeof(temp_string),"MODEL - %s",transport[temp_vehicleid-400][name]);
			PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_MODEL],temp_string);
			format(temp_string,sizeof(temp_string),"FUEL TANK - %iliters",transport[temp_vehicleid-400][fuel_tank]);
			PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_FUEL_TANK],temp_string);
			format(temp_string,sizeof(temp_string),"PRICE - $%i",transport[temp_vehicleid-400][price]);
			PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_PRICE],temp_string);
			SetPVarInt(playerid,"CarDealership_Item",temp_item);
	    }
	    else if(playertextid == td_buy_car[playerid][TD_BUY_CAR_SELECT_VEHICLE_ARROW_LEFT]){
	        new temp_item=GetPVarInt(playerid,"CarDealership_Item");
			new temp_businessid=GetPVarInt(playerid,"CarDealership_Businessid");
			new temp_count=0;
			for(new i=temp_item-2;;i--){
	            if(temp_count>=64){
	                break;
	            }
	            if(i==-1){
			        i=31;
			    }
			    if(business[temp_businessid-1][item][i]){
			        temp_item=i+1;
			        break;
	            }
	            temp_count++;
	        }
	        new temp_vehicleid=business[temp_businessid-1][item][temp_item-1];
	        PlayerTextDrawHide(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1]);
	        PlayerTextDrawHide(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2]);
	        PlayerTextDrawSetPreviewModel(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1],temp_vehicleid);
			PlayerTextDrawSetPreviewVehCol(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1],1,1);
			PlayerTextDrawSetPreviewModel(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2],temp_vehicleid);
			PlayerTextDrawSetPreviewVehCol(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2],1,1);
	        PlayerTextDrawShow(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_1]);
	        PlayerTextDrawShow(playerid,td_buy_car[playerid][TD_BUY_CAR_VEHICLE_2]);
			new temp_string[11-2+32];
			format(temp_string,sizeof(temp_string),"MODEL - %s",transport[temp_vehicleid-400][name]);
			PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_MODEL],temp_string);
			format(temp_string,sizeof(temp_string),"FUEL TANK - %iliters",transport[temp_vehicleid-400][fuel_tank]);
			PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_FUEL_TANK],temp_string);
			format(temp_string,sizeof(temp_string),"PRICE - $%i",transport[temp_vehicleid-400][price]);
			PlayerTextDrawSetString(playerid,td_buy_car[playerid][TD_BUY_CAR_PRICE],temp_string);
			SetPVarInt(playerid,"CarDealership_Item",temp_item);
	    }
	    else if(playertextid == td_buy_car[playerid][TD_BUY_CAR_BUY]){
            new temp_item=GetPVarInt(playerid,"CarDealership_Item");
			new temp_businessid=GetPVarInt(playerid,"CarDealership_Businessid");
			if(!business[temp_businessid-1][item][temp_item-1]){
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Этой модели нет в автосалоне!\n\n","Закрыть","");
			    CancelSelectTextDraw(playerid);
			    for(new i=0; i<sizeof(td_buy_car[]); i++){
			        PlayerTextDrawHide(playerid,td_buy_car[playerid][i]);
			    }
			    return true;
			}
			new temp_vehicleid=business[temp_businessid-1][item][temp_item-1];
			new temp_price=transport[temp_vehicleid-400][price];
			new string[97-2-2+24-11];
			format(string,sizeof(string),"\n"WHITE"Вы хотите купить "BLUE"%s"WHITE" за "GREEN"$%i\n\n"WHITE"Вы хотите продолжить?\n\n",transport[temp_vehicleid-400][name],temp_price);
			ShowPlayerDialog(playerid,dBuyCarConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Покупка транспорта",string,"Да","Нет");
	    }
	    else if(playertextid == td_buy_car[playerid][TD_BUY_CAR_CANCEL]){
	        CancelSelectTextDraw(playerid);
		    for(new i=0; i<sizeof(td_buy_car[]); i++){
		        PlayerTextDrawHide(playerid,td_buy_car[playerid][i]);
		    }
		    DeletePVar(playerid,"CarDealership_Status");
	    }
	}
	return true;
}

public OnPlayerEnterDynamicArea(playerid,areaid){
	for(new i=0; i<total_houses; i++){
	    if(IsPlayerInDynamicArea(playerid,house[i][area_id])){
	    	new temp_string[33];
	    	new temp_class[5][3]={"A","B","C","D","E"};
	        if(strlen(house[i][owner])<3){
	            format(temp_string,sizeof(temp_string),"HOUSE NUMBER - %i",house[i][id]);
	            PlayerTextDrawSetString(playerid,td_free_house[playerid][TD_FREE_HOUSE_HOUSE_ID],temp_string);
	            format(temp_string,sizeof(temp_string),"COST - $%i",house[i][cost]);
	            PlayerTextDrawSetString(playerid,td_free_house[playerid][TD_FREE_HOUSE_COST],temp_string);
	            format(temp_string,sizeof(temp_string),"HOUSE CLASS - %s",temp_class[house[i][class]-1]);
	            PlayerTextDrawSetString(playerid,td_free_house[playerid][TD_FREE_HOUSE_CLASS],temp_string);
	            for(new j=0; j<sizeof(td_free_house[]); j++){
	                PlayerTextDrawShow(playerid,td_free_house[playerid][j]);
	            }
	            SetPVarInt(playerid,"HouseTD",1);
	        }
	        else{
	            format(temp_string,sizeof(temp_string),"HOUSE NUMBER - %i",house[i][id]);
	            PlayerTextDrawSetString(playerid,td_owned_house[playerid][TD_OWNED_HOUSE_HOUSE_ID],temp_string);
	            format(temp_string,sizeof(temp_string),"OWNER - %s",house[i][owner]);
	            PlayerTextDrawSetString(playerid,td_owned_house[playerid][TD_OWNED_HOUSE_OWNER],temp_string);
	            format(temp_string,sizeof(temp_string),"HOUSE CLASS - %s",temp_class[house[i][class]-1]);
	            PlayerTextDrawSetString(playerid,td_owned_house[playerid][TD_OWNED_HOUSE_CLASS],temp_string);
	            for(new j=0; j<sizeof(td_owned_house[]); j++){
	                PlayerTextDrawShow(playerid,td_owned_house[playerid][j]);
	            }
	            SetPVarInt(playerid,"HouseTD",2);
	        }
	        SetPVarInt(playerid,"HouseArea",house[i][area_id]);
	        break;
	    }
	}
	for(new i=0; i<total_businesses; i++){
	    if(IsPlayerInDynamicArea(playerid,business[i][area_id])){
	        new temp_string[32];
	        if(strlen(business[i][owner])<3){
	            format(temp_string,sizeof(temp_string),"BUSINESS NUMBER - %i",business[i][id]);
	            PlayerTextDrawSetString(playerid,td_free_business[playerid][TD_FREE_BUSINESS_ID],temp_string);
	            format(temp_string,sizeof(temp_string),"COST - $%i",business[i][price]);
	            PlayerTextDrawSetString(playerid,td_free_business[playerid][TD_FREE_BUSINESS_COST],temp_string);
             	format(temp_string,sizeof(temp_string),"TYPE - %s",type_of_business[business[i][type]-1]);
	            PlayerTextDrawSetString(playerid,td_free_business[playerid][TD_FREE_BUSINESS_TYPE],temp_string);
	            PlayerTextDrawSetString(playerid,td_free_business[playerid][TD_FREE_BUSINESS_NAME],business[i][name]);
	            for(new j=0; j<sizeof(td_free_business[]); j++){
	                PlayerTextDrawShow(playerid,td_free_business[playerid][j]);
	            }
	            SetPVarInt(playerid,"BusinessTD",1);
	        }
	        else{
	            format(temp_string,sizeof(temp_string),"BUSINESS NUMBER - %i",business[i][id]);
	            PlayerTextDrawSetString(playerid,td_owned_business[playerid][TD_OWNED_BUSINESS_ID],temp_string);
	            PlayerTextDrawSetString(playerid,td_owned_business[playerid][TD_OWNED_BUSINESS_NAME],business[i][name]);
	            format(temp_string,sizeof(temp_string),"OWNER - %s",business[i][owner]);
	            PlayerTextDrawSetString(playerid,td_owned_business[playerid][TD_OWNED_BUSINESS_OWNER],temp_string);
	            format(temp_string,sizeof(temp_string),"TYPE - %s",type_of_business[business[i][type]-1]);
	            PlayerTextDrawSetString(playerid,td_owned_business[playerid][TD_OWNED_BUSINESS_TYPE],temp_string);
	            for(new j=0; j<sizeof(td_owned_business[]); j++){
	                PlayerTextDrawShow(playerid,td_owned_business[playerid][j]);
	            }
	            SetPVarInt(playerid,"BusinessTD",2);
	        }
	        SetPVarInt(playerid,"BusinessArea",business[i][area_id]);
	        break;
	    }
	}
	if(IsPlayerInAnyDynamicArea(playerid) && !GetPVarInt(playerid,"HouseTD") && !GetPVarInt(playerid,"BusinessTD")){
	    TextDrawShowForPlayer(playerid,td_press_alt);
	    SetPVarInt(playerid,"PressAltTD",1);
	}
	return true;
}

public OnPlayerLeaveDynamicArea(playerid,areaid){
	if(GetPVarInt(playerid,"HouseArea")){
	    if(GetPVarInt(playerid,"HouseTD")==1){
	        for(new i=0; i<sizeof(td_free_house[]); i++){
                PlayerTextDrawHide(playerid,td_free_house[playerid][i]);
            }
	    }
	    else if(GetPVarInt(playerid,"HouseTD")==2){
	        for(new i=0; i<sizeof(td_owned_house[]); i++){
                PlayerTextDrawHide(playerid,td_owned_house[playerid][i]);
            }
	    }
	    DeletePVar(playerid,"HouseArea");
	    DeletePVar(playerid,"HouseTD");
	}
	if(GetPVarInt(playerid,"BusinessArea")){
	    if(GetPVarInt(playerid,"BusinessTD")==1){
	        for(new i=0; i<sizeof(td_free_business[]); i++){
                PlayerTextDrawHide(playerid,td_free_business[playerid][i]);
            }
	    }
	    else if(GetPVarInt(playerid,"BusinessTD")==2){
	        for(new i=0; i<sizeof(td_owned_business[]); i++){
                PlayerTextDrawHide(playerid,td_owned_business[playerid][i]);
            }
	    }
	    DeletePVar(playerid,"BusinessArea");
	    DeletePVar(playerid,"BusinessTD");
	}
	if(GetPVarInt(playerid,"PressAltTD")){
		TextDrawHideForPlayer(playerid,td_press_alt);
		DeletePVar(playerid,"PressAltTD");
	}
	return true;
}

forward OnPlayerCommandReceived(playerid, cmdtext[]);
public OnPlayerCommandReceived(playerid, cmdtext[]){
    if(!GetPVarInt(playerid,"PlayerLogged")){
        return false;
    }
    if((gettime()-GetPVarInt(playerid,"command_time"))<2){
        SendClientMessage(playerid,C_RED,"[Информация] Пожалуйста, не флудите!");
        return false;
    }
    SetPVarInt(playerid,"command_time",gettime());
    return true;
}

public OnVehicleDeath(vehicleid,killerid){
	SetVehicleToRespawn(vehicleid);
	return true;
}

/*      Кастомные каллбеки      */

forward kick_player(playerid);
public kick_player(playerid){
	Kick(playerid);
	return true;
}

forward general_timer();
public general_timer(){
	foreach(new i:Player){
	    if(GetPVarInt(i,"PlayerLogged")){
	        if(payday[i][time]>=PAYDAY_TIME && !payday[i][taken]){
				SendClientMessage(i,C_GREEN,"[Информация] Вы можете забрать свою зарплату!");
				SendClientMessage(i,-1,"[Информация] (( Введите /takecheque для получения зарплаты ))");
				payday[i][taken]=true;
			}
	        if(!payday[i][taken]){
				payday[i][time]++;
			}
	    }
	}
	new temp_hour;
	gettime(temp_hour,_,_);
	if(global__time_hour!=temp_hour){
		SetWorldTime(global__time_hour=temp_hour);
	}
	timer_general=SetTimer("general_timer",1000,false);
	return true;
}

get_payday(playerid){
	if(GetPVarInt(playerid,"PlayerLogged")){
		if(payday[playerid][time]<PAYDAY_TIME && !payday[playerid][taken]){
		    return true;
		}
	    new string_promocode[36-2+MAX_PROMOCODE_LEN];
	    new string_new_level[40];
	    player[playerid][experience]++;
	    payday[playerid][time]=0;
		payday[playerid][taken]=false;
	    if(player[playerid][experience]>=player[playerid][level]*NEEDED_EXPERIENCE){
			strins(string_new_level,"Ваш уровень повышен\nIC возраст повышен\n",0,sizeof(string_new_level));
			player[playerid][experience]=(player[playerid][experience]-(player[playerid][level]*NEEDED_EXPERIENCE));
	        player[playerid][level]++;
	        player[playerid][age]++;
			SetPlayerScore(playerid,player[playerid][level]);
	        if(strlen(player[playerid][referal_name])>=MIN_PROMOCODE_LEN){
	            new query[84-2+MAX_PROMOCODE_LEN];
	            if(player[playerid][level]==NEEDED_LEVEL_FOR_REFERAL_TO_TAKE_MONEY && !player[playerid][experience]){
					mysql_format(mysql_connection,query,sizeof(query),"select`payday`,`name`from`users`where`name`='%e'limit 1",player[playerid][referal_name]);
					new Cache:cache_users=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
						new temp_payday[24], temp_name[MAX_PLAYER_NAME], arr_payday[3];
						cache_get_field_content(0,"payday_money",temp_payday,mysql_connection,sizeof(temp_payday));
						sscanf(temp_payday,"p<|>i[3]",arr_payday);
						cache_get_field_content(0,"name",temp_name,mysql_connection,sizeof(temp_name));
						new temp_playerid;
						sscanf(temp_name,"u",temp_playerid);
						if(GetPVarInt(temp_playerid,"PlayerLogged")){
						    format(string_promocode,sizeof(string_promocode),"Вы получили бонус за приглашённого игрока - %s\n",player[playerid][name]);
						    payday[temp_playerid][salary]+=50000;
						    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`payday`='%i|%i|%i'where`id`='%i'",payday[temp_playerid][time],payday[temp_playerid][salary],payday[temp_playerid][taken],player[temp_playerid][id]);
						}
						else{
						    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`payday`='%i|%i|%i'where`name`='%e'limit 1",arr_payday[0],arr_payday[1]+50000,arr_payday[2],temp_name);
						}
						mysql_query(mysql_connection,query,false);
					}
					cache_delete(cache_users,mysql_connection);
				}
	            mysql_format(mysql_connection,query,sizeof(query),"select`level`,`promocode`,`money`,`experience`from`promocodes`where`promocode`='%e'",player[playerid][referal_name]);
	            new Cache:cache_promocodes=mysql_query(mysql_connection,query);
	            if(cache_get_row_count(mysql_connection)){
	                new temp_level,temp_promocode[MAX_PROMOCODE_LEN],temp_money,temp_experience;
	                temp_level=cache_get_field_content_int(0,"level",mysql_connection);
	                cache_get_field_content(0,"promocode",temp_promocode,mysql_connection,sizeof(temp_promocode));
	                temp_money=cache_get_field_content_int(0,"money",mysql_connection);
	                temp_experience=cache_get_field_content_int(0,"experience",mysql_connection);
	                if(player[playerid][level]==temp_level && !player[playerid][experience]){
	                    payday[playerid][salary]+=temp_money;
	                    player[playerid][experience]+=temp_experience;
	                    new string_money[16];
						format(string_money,sizeof(string_money),temp_money?" $%i":"",temp_money);
						new string_experience[16];
						format(string_experience,sizeof(string_experience),temp_experience?" %i опыта":"",temp_experience);
						format(string_promocode,sizeof(string_promocode),"Вы получили бонус [%s%s ] по промокоду - %s\n",temp_money,temp_experience,temp_promocode);
	                }
	            }
	            cache_delete(cache_promocodes,mysql_connection);
	        }
	        new query[54-2-2-2+11+11+11];
	        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`level`='%i',`age`='%i'where`id`='%i'",player[playerid][level],player[playerid][age],player[playerid][id]);
	        mysql_query(mysql_connection,query,false);
	    }
	    new string_money[33-2+11];
	    format(string_money,sizeof(string_money),""WHITE"Зарплата -\t"GREEN"$%i\n",payday[playerid][salary]);
	    new string_salary[61];
	    if(payday[playerid][salary]){
	        new query[75-2+MAX_PLAYER_NAME];
	        mysql_format(mysql_connection,query,sizeof(query),"select`id`,`money`from`bank_accounts`where`owner`='%e'and`main`='1'limit 1",player[playerid][name]);
	        new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
	        if(cache_get_row_count(mysql_connection)){
	            new temp_money=cache_get_field_content_int(0,"money",mysql_connection);
	            temp_money+=payday[playerid][salary];
	            payday[playerid][salary]=0;
	            new temp_id=cache_get_field_content_int(0,"id",mysql_connection);
				format(string_salary,sizeof(string_salary),"Зарплата была переведена на основной счёт - %i\n",temp_id);
				mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`='%i'where`id`='%i'",temp_money,temp_id);
				mysql_query(mysql_connection,query,false);
	        }
	        else{
	            format(string_salary,sizeof(string_salary),"Зарплата не была переведена, т.к отсутствует основной счёт\n");
	        }
	        cache_delete(cache_bank_accounts,mysql_connection);
	    }
	    new string[73-2-2-2-2-2+11+sizeof(string_money)+sizeof(string_promocode)+sizeof(string_new_level)+sizeof(string_salary)];
	    format(string,sizeof(string),"\n\n"GREY"\t[ Номер чека №%i ]\n\n%s\n"GREY"Дополнительно:\n%s%s%s\n",GetSVarInt("sCheque"),string_money,string_promocode,string_new_level,string_salary);
	    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Зарплата",string,"Закрыть","");
	    new query[74-2-2-2+5+11+11];
	    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`experience`='%i',`payday`='0|%i|0'where`id`='%i'",player[playerid][experience],payday[playerid][salary],player[playerid][id]);
	    mysql_query(mysql_connection,query,false);
	    SetSVarInt("sCheque",GetSVarInt("sCheque")+1);
	    mysql_format(mysql_connection,query,sizeof(query),"update`general`set`cheque`='%i'",GetSVarInt("sCheque"));
	    mysql_query(mysql_connection,query,false);
	}
	return true;
}

ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5){
	if(GetPVarInt(playerid,"PlayerLogged")){
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		new tempvirtualworld=GetPlayerVirtualWorld(playerid);
		foreach(new i:Player){
			GetPlayerPos(i, posx, posy, posz);
			tempposx = (oldposx -posx);
			tempposy = (oldposy -posy);
			tempposz = (oldposz -posz);
			if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)) && GetPlayerVirtualWorld(i)==tempvirtualworld){
				SendSplitClientMessage(i, col1, string);
			}
			else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)) && GetPlayerVirtualWorld(i)==tempvirtualworld){
				SendSplitClientMessage(i, col2, string);
			}
			else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)) && GetPlayerVirtualWorld(i)==tempvirtualworld){
				SendSplitClientMessage(i, col3, string);
			}
			else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)) && GetPlayerVirtualWorld(i)==tempvirtualworld){
				SendSplitClientMessage(i, col4, string);
			}
			else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)) && GetPlayerVirtualWorld(i)==tempvirtualworld){
				SendSplitClientMessage(i, col5, string);
			}
		}
	}
	return true;
}

gettimestamp (timestamp, _form=0){
    new
        year=1970, day=0, month=0, hour=0, mins=0, sec=0,
		days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 },
    	names_of_month[12][10] = {"January","February","March","April","May","June","July","August","September","October","November","December"},
    	returnstring[32];
    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ){ 
			timestamp -= 86400;
		}
        year++;
    }
    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ){
        days_of_month[1] = 29;
	}
    else{
        days_of_month[1] = 28;
	}
    while(timestamp>86400){
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }
    while(timestamp>60){
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hour++;
    }
    sec=timestamp;
    switch( _form ){
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hour, mins, sec);
        case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,hour,mins);
        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
    }
    return returnstring;
}

SendFactionMessage(factionid,color,message[]){
	foreach(new i:Player){
	    if(GetPVarInt(i,"PlayerLogged") && player[i][faction_id]==factionid){
            SendSplitClientMessage(i,color,message);
	    }
	}
	return true;
}

SendAdminsMessage(color,message[]){
	foreach(new i:Player){
	    if(GetPVarInt(i,"PlayerLogged") && admin[i][id]!=0){
	        SendSplitClientMessage(i,color,message);
		}
	}
	return true;
}

SendSplitClientMessage(playerid, color, text[], minlen = 0, maxlen = 128){
    new str[128];
    if(strlen(text) > maxlen){
        new pos = maxlen;
        while(text[--pos] > ' ') {}
        if(pos < minlen) pos = maxlen;
        format(str, sizeof(str), "%.*s ...", pos, text);
        SendClientMessage(playerid,color,str);
        format(str, sizeof(str), "....%s %s", text[pos+1]);
        SendClientMessage(playerid,color,str);
    }
    else{
        format(str, sizeof(str), "%s", text);
        SendClientMessage(playerid,color,str);
    }
}

forward minute_timer();
public minute_timer(){
	foreach(new i:Player){
		if(!GetPVarInt(i,"PlayerLogged")){
		    continue;
		}
		if(player[i][mute]){
			player[i][mute]--;
			if(!player[i][mute]){
			    SendClientMessage(i,C_BLUE,"[Информация] Срок бана чата истёк!");
			}
		}
	}
	new query[74-2-2-2-2+1+11+11+11];
	for(new i=0; i<total_vehicles; i++){
	    mysql_format(mysql_connection,query,sizeof(query),"update`vehicles`set`fuel`='%f',`mileage`='%f',`locked`='%i'where`id`='%i'",vehicle[i][fuel],vehicle[i][mileage],vehicle[i][locked],vehicle[i][mysql_id]);
	    mysql_query(mysql_connection,query,false);
	}
	timer_minute=SetTimer("minute_timer",60000,false);
}

IsValidVehicle(vehicleid){
	switch(vehicleid){
	    case 481,509,510:{
	        return false;
	    }
	    default:{
	        return true;
	    }
	}
	return false;
}

forward engine_turn_on(playerid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
public engine_turn_on(playerid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective){
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
	    new vehicleid=GetPlayerVehicleID(playerid);
	    SetVehicleParamsEx(vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	    new temp[32];
	    format(temp,sizeof(temp),"/ame завёл двигатель транспорта");
		DC_CMD(playerid,temp);
	    PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_FUEL]);
	    PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_FUEL],C_GREY);
	    PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_FUEL]);
	    timer_speed[playerid]=SetTimerEx("speed",150,false,"i",playerid);
	}
	return true;
}

forward speed(playerid,vehicleid);
public speed(playerid,vehicleid){
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsPlayerInAnyVehicle(playerid)){
        KillTimer(timer_speed[playerid]);
	    return true;
	}
	new temp_vehicleid=GetPlayerVehicleID(playerid);
	if(!IsValidVehicle(GetVehicleModel(temp_vehicleid))){
	    KillTimer(timer_speed[playerid]);
	    return true;
	}
	if(temp_vehicleid != vehicle[vehicleid][id]){
	    for(new i=0; i<MAX_VEHICLES; i++){
	        if(vehicle[i][id] == temp_vehicleid){
	            vehicleid=i;
	            break;
	        }
	    }
	}
    new temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective;
	GetVehicleParamsEx(temp_vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	if(!temp_engine){
	    KillTimer(timer_speed[playerid]);
	    return true;
	}
	if(vehicle[vehicleid][fuel]<=0.0){
	    SendClientMessage(playerid,C_RED,"[Информация] Двигатель заглох!");
	    new temp[33];
	    format(temp,sizeof(temp),"/ado заглох двигатель транспорта");
		DC_CMD(playerid,temp);
	    temp_engine=0;
	    SetVehicleParamsEx(temp_vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
		PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_SPEED],"0km/h");
		PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_FUEL]);
		PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_FUEL],C_RED);
		PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_FUEL],"fuel:eng_off");
		PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_FUEL]);
		vehicle[vehicleid][fuel]=0.0;
		KillTimer(timer_speed[playerid]);
	    return true;
	}
	new Float:temp_mileage=(GetVehicleSpeed(temp_vehicleid)/8.6)/600;
	if(temp_mileage){
		vehicle[vehicleid][mileage]+=temp_mileage;
	}
	new Float:temp_fuel=(GetVehicleSpeed(temp_vehicleid)/13.6)/1100;
	if(temp_fuel){
	    vehicle[vehicleid][fuel]-=temp_fuel;
	}
	new string[8-2+11];
	format(string,sizeof(string),"way:%.02f",vehicle[vehicleid][mileage]);
	PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_WAY],string);
	format(string,sizeof(string),"fuel:%.01f",vehicle[vehicleid][fuel]);
	PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_FUEL],string);
	format(string,sizeof(string),"%ikm/h",GetVehicleSpeed(temp_vehicleid));
	PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_SPEED],string);
	timer_speed[playerid]=SetTimerEx("speed",150,false,"i",playerid,vehicleid);
	return true;
}

GetVehicleSpeed(temp_vehicleid){
	new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_result;
	GetVehicleVelocity(temp_vehicleid,temp_x,temp_y,temp_z);
	temp_result=floatsqroot(floatpower(floatabs(temp_x),2.0)+floatpower(floatabs(temp_y),2.0)+floatpower(floatabs(temp_z),2.0))*100.3;
	return floatround(temp_result);
}

lockOfVehicle(vehicleid,playerid=-1){
	vehicle[vehicleid][locked]=vehicle[vehicleid][locked]?0:1;
	new temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective;
	GetVehicleParamsEx(vehicle[vehicleid][id],temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	SetVehicleParamsEx(vehicle[vehicleid][id],temp_engine,temp_lights,temp_alarm,vehicle[vehicleid][locked],temp_bonnet,temp_boot,temp_objective);
	if(playerid != -1){
		GameTextForPlayer(playerid,vehicle[vehicleid][locked]?"~w~vehicle doors ~r~closed":"~w~vehicle doors ~g~opened",1500,3);
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
			PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_DOORS]);
			if(vehicle[vehicleid][locked]){
				PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_DOORS],C_RED);
			}
			else{
				PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_DOORS],C_GREEN);
			}
			PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_DOORS],vehicle[vehicleid][locked]?C_RED:C_GREEN);
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_DOORS]);
		}
	}
}

showStats(playerid,temp_playerid,Cache:cache_users=Cache:0){
	static houses[16+MAX_OWNED_HOUSES*(22-2+11)];
	houses=""WHITE"Жильё - ";
	static vehicles[20+MAX_OWNED_VEHICLES*(25-2-2+24+11)];
	vehicles=""WHITE"Транспорт - ";
	new temp_str_gender[8];
	static businesses[18+MAX_OWNED_BUSINESSES*(25-2-2+32+11)];
	businesses=""WHITE"Бизнесы - ";
	new temp_gender, temp_name[MAX_PLAYER_NAME], temp_age, temp_origin, temp_money, temp_level, temp_experience;
	new temp_owned_houses[MAX_OWNED_HOUSES]={0}, temp_owned_businesses[MAX_OWNED_BUSINESSES]={0}, temp_owned_vehicles[MAX_OWNED_VEHICLES]={-1};
	if(temp_playerid == -1){
		SendClientMessage(playerid,-1,"temp_playerid = -1");
		cache_set_active(cache_users,mysql_connection);
		cache_get_field_content(0,"name",temp_name,mysql_connection,MAX_PLAYER_NAME);
		temp_gender=cache_get_field_content_int(0,"gender",mysql_connection);
		temp_age=cache_get_field_content_int(0,"age",mysql_connection);
		temp_origin=cache_get_field_content_int(0,"origin",mysql_connection);
		temp_money=cache_get_field_content_int(0,"money",mysql_connection);
		temp_level=cache_get_field_content_int(0,"level",mysql_connection);
		temp_experience=cache_get_field_content_int(0,"experience",mysql_connection);
		cache_delete(cache_users,mysql_connection);
		new query[44-2+MAX_PLAYER_NAME];
		mysql_format(mysql_connection,query,sizeof(query),"select`id`from`houses`where`owner`='%e'",temp_name);		
		new Cache:cache_houses=mysql_query(mysql_connection,query,true);
		if(cache_get_row_count(mysql_connection)){
			for(new i=0; i<cache_get_row_count(mysql_connection); i++){
				temp_owned_houses[i]=cache_get_field_content_int(i,"id",mysql_connection);
			}
		}
		cache_delete(cache_houses,mysql_connection);
		mysql_format(mysql_connection,query,sizeof(query),"select`id`from`vehicles`where`owner`='%e'",temp_name);
		new Cache:cache_vehicles=mysql_query(mysql_connection,query,true);
		if(cache_get_row_count(mysql_connection)){
			new temp_id;
			for(new i=0; i<cache_get_row_count(mysql_connection); i++){
				temp_id=cache_get_field_content_int(i,"id",mysql_connection);
				for(new j=0; j<MAX_VEHICLES; j++){
					if(vehicle[j][mysql_id] == temp_id){
						temp_owned_vehicles[i]=j;
					}
				}
			}
		}
		cache_delete(cache_vehicles,mysql_connection);
		mysql_format(mysql_connection,query,sizeof(query),"select`id`from`businesses`where`owner`='%e'",temp_name);		
		new Cache:cache_businesses=mysql_query(mysql_connection,query,true);
		if(cache_get_row_count(mysql_connection)){
			for(new i=0; i<MAX_OWNED_BUSINESSES; i++){
				temp_owned_businesses[i]=cache_get_field_content_int(i,"id",mysql_connection);
				printf(temp_owned_businesses[i]);
			}
		}
		cache_delete(cache_businesses,mysql_connection);
	}
	else{
		SendClientMessage(playerid,-1,"temp_playerid = 0-999");
		strmid(temp_name,player[temp_playerid][name],0,strlen(player[temp_playerid][name]));
		temp_gender=player[temp_playerid][gender];
		temp_age=player[temp_playerid][age];
		temp_origin=player[temp_playerid][origin];
		temp_money=player[temp_playerid][money];
		temp_level=player[temp_playerid][level];
		temp_experience=player[temp_playerid][experience];
		for(new i=0; i<MAX_OWNED_HOUSES; i++){
			temp_owned_houses[i]=owned_house_id[temp_playerid][i];
		}
		for(new i=0; i<MAX_OWNED_VEHICLES; i++){
			temp_owned_vehicles[i]=owned_vehicle_id[temp_playerid][i];
		}
		for(new i=0; i<MAX_OWNED_BUSINESSES; i++){
			temp_owned_businesses[i]=owned_business_id[temp_playerid][i];
		}
	}
	if(!temp_owned_houses[0]){
		strcat(houses,""BLUE"бездомный\n");
	}
	else{
		new temp[22-2+11];
		for(new i=0; i<MAX_OWNED_HOUSES; i++){
			if(!temp_owned_houses[i]){
				continue;
			}
			if(!i){
				format(temp,sizeof(temp),""BLUE"\t[ H-ID %i ]\n",temp_owned_houses[i]);
			}
			else{
				format(temp,sizeof(temp),"\t\t[ H-ID %i ]\n",temp_owned_houses[i]);
			}
			strcat(houses,temp);
		}
	}
	if(temp_owned_vehicles[0] == -1){
		strcat(vehicles,""BLUE"отсутствует\n");
	}
	else{
		new temp[25-2-2+24+11];
		for(new i=0; i<MAX_OWNED_VEHICLES; i++){
			if(temp_owned_vehicles[i] == -1){
				continue;
			}
			if(!i){
				format(temp,sizeof(temp),""BLUE"\t[ %s V-ID %i ]\n",transport[vehicle[temp_owned_vehicles[i]][model]-400][name],vehicle[temp_owned_vehicles[i]][mysql_id]);
			}
			else{
				format(temp,sizeof(temp),"\t\t[ %s V-ID %i ]\n",transport[vehicle[temp_owned_vehicles[i]][model]-400][name],vehicle[temp_owned_vehicles[i]][mysql_id]);
			}
			strcat(vehicles,temp);
		}
	}
	if(!temp_owned_businesses[0]){
		strcat(businesses,""BLUE"отсутствуют\n");
	}
	else{
		new temp[25-2-2+32+11];
		for(new i=0; i<MAX_OWNED_BUSINESSES; i++){
			if(!temp_owned_businesses[i]){
				continue;
			}
			if(!i){
				format(temp,sizeof(temp),""BLUE"\t[ %s B-ID %i ]\n",business[temp_owned_businesses[i]-1][name],temp_owned_businesses[i]);
			}
			else{
				format(temp,sizeof(temp),"\t\t[ %s B-ID %i ]\n",business[temp_owned_businesses[i]-1][name],temp_owned_businesses[i]);
			}
			strcat(businesses,temp);
		}
	}
	format(temp_str_gender,sizeof(temp_str_gender),temp_gender?"Мужской":"Женский");
	new main_bank_account[23+24-2-2+32+11];
	strcat(main_bank_account,""WHITE"Основной счёт - ");
	new query[89-2+MAX_PLAYER_NAME];
	mysql_format(mysql_connection,query,sizeof(query),"select`id`,`description`from`bank_accounts`where`owner`='%e'and`main`='1'limit 1",temp_name);
	new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
	if(cache_get_row_count(mysql_connection)){
		new temp_id=cache_get_field_content_int(0,"id",mysql_connection);
		new temp_description[32];
		cache_get_field_content(0,"description",temp_description,mysql_connection,sizeof(temp_description));
		new temp[26-2-2+32+11];
		format(temp,sizeof(temp),""BLUE"[ %s BA-ID %i ]\n",temp_description,temp_id);
		strcat(main_bank_account,temp);
	}
	else{
		strcat(main_bank_account,""BLUE"отсутствует\n");
	}
	cache_delete(cache_bank_accounts,mysql_connection);
	static string[113-2-2-2-2-2-2-2-2+3+24+8+11+6+11+11+sizeof(houses)+sizeof(vehicles)+sizeof(businesses)+sizeof(main_bank_account)];
	format(string,sizeof(string),"\n"WHITE"Возраст - "BLUE"%i лет\n"WHITE"Раса - "BLUE"%s\n"WHITE"Пол - "BLUE"%s\n\n"WHITE"Наличные - "GREEN"$%i\n%s\n"WHITE"Опыт - "BLUE"%i (%i / %i)\n\n%s\n%s\n%s\n",temp_age,origins[temp_origin-1],temp_str_gender,temp_money,main_bank_account,temp_level,temp_experience,temp_level*NEEDED_EXPERIENCE,houses,businesses,vehicles);
	ShowPlayerDialog(playerid,dMainMenuInfAboutPersCharacter,DIALOG_STYLE_MSGBOX,""BLUE"Информация о персонаже",string,"Назад","");
	SendClientMessage(playerid,-1,"ShowPlayerDialog");
	string="";
	houses="";
	vehicles="";
	businesses="";
}

/*      ------------------      */

/*      Команды сервера         */

CMD:menu(playerid){
	ShowPlayerDialog(playerid,dMainMenu,DIALOG_STYLE_LIST,""BLUE"Main Menu","[0] Информация о персонаже\n[1] Реферальная система\n[2] Помощь по серверу\n[3] Настройки аккаунта","Выбрать","Отмена");
	return true;
}

//ALTX:menu("/mn","/mm");

CMD:mn(playerid){
	return cmd_menu(playerid);
}

CMD:mm(playerid){
	return cmd_menu(playerid);
}

CMD:takecheque(playerid){
	if(!payday[playerid][taken] && payday[playerid][time]<PAYDAY_TIME){
	    SendClientMessage(playerid,C_RED,"[Информация] На ваше имя не приходило чеков!");
	    return true;
	}
	get_payday(playerid);
	return true;
}

CMD:todo(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new text[64],action[64];
	if(sscanf(params,"p<*>s[128]s[128]",text,action)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /todo [ сообщение*действие ]");
	    return true;
	}
	static string[22+64+64-2-2-2+MAX_PLAYER_NAME+9];
	format(string,sizeof(string),"- %s - сказал %s - "RED"%s",text,player[playerid][name],action);
	ProxDetector(15.0,playerid,string,-1,-1,-1,-1,-1);
	string="";
	return true;
}

CMD:atodo(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new text[64],action[64];
	if(sscanf(params,"p<*>s[128]s[128]",text,action)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /atodo [ сообщение*действие ]");
	    return true;
	}
	new string[16-2-2+64+64];
	format(string,sizeof(string),"%s "RED"* %s",text,action);
	SetPlayerChatBubble(playerid,string,-1,15.0,4000);
	return true;
}

CMD:me(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
        SendClientMessage(playerid,C_GREY,"Используйте: /me [ действие ]");
	    return true;
	}
	new string[8-2-2+MAX_PLAYER_NAME+128];
	format(string,sizeof(string),"%s - %s",player[playerid][name],temp);
	ProxDetector(15.0,playerid,string,C_RED,C_RED,C_RED,C_RED,C_RED);
	return true;
}

CMD:ame(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
        SendClientMessage(playerid,C_GREY,"Используйте: /ame [ действие ]");
	    return true;
	}
	SetPlayerChatBubble(playerid,temp,C_RED,15.0,4000);
	return true;
}

CMD:do(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
        SendClientMessage(playerid,C_GREY,"Используйте: /do [ действие от третьего лица ]");
	    return true;
	}
	new string[14-2-2+128+MAX_PLAYER_NAME];
	format(string,sizeof(string),"%s - (( %s ))",temp,player[playerid][name]);
	ProxDetector(15.0,playerid,string,C_RED,C_RED,C_RED,C_RED,C_RED);
	return true;
}

CMD:ado(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
        SendClientMessage(playerid,C_GREY,"Используйте: /ado [ действие от третьего лица ]");
	    return true;
	}
	new string[9-2+128];
	format(string,sizeof(string),"(( %s ))",temp);
    SetPlayerChatBubble(playerid,string,C_RED,15.0,4000);
	return true;
}

CMD:try(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /try [ действие ]");
	    return true;
	}
	new rand=random(2);
	new string[21-2-2-2+MAX_PLAYER_NAME+128+10];
	format(string,sizeof(string),"%s - %s | "GREY"%s",player[playerid][name],temp,rand?"Удачно":"Не удачно");
    ProxDetector(15.0,playerid,string,C_RED,C_RED,C_RED,C_RED,C_RED);
	return true;
}

//ALTX:try("/coin");

CMD:coin(playerid,params[]){
	return cmd_try(playerid,params);
}

CMD:atry(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /atry [ действие ]");
	    return true;
	}
	new rand=random(2);
	new string[16-2-2+64+10];
    format(string,sizeof(string),"%s | "GREY"%s",temp,rand?"Удачно":"Не удачно");
    SetPlayerChatBubble(playerid,string,C_RED,15.0,4000);
	return true;
}

//ALTX:atry("/acoin");

CMD:acoin(playerid,params[]){
	return cmd_atry(playerid,params);
}

CMD:shout(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /shout [ сообщение ] "WHITE"- крикнуть");
	    return true;
	}
	new string[17-2-2+MAX_PLAYER_NAME+128];
	format(string,sizeof(string),"- %s - крикнул %s",temp,player[playerid][name]);
	ProxDetector(25.0,playerid,string,-1,-1,-1,-1,-1);
	return true;
}

//ALTX:shout("/s");

CMD:s(playerid,params[]){
	return cmd_shout(playerid,params);
}

CMD:ashout(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /ashout [ сообщение ] "WHITE"- крикнуть");
	    return true;
	}
	new string[7-2+128];
	format(string,sizeof(string),"[S] %s",temp);
	SetPlayerChatBubble(playerid,string,-1,25.0,4000);
	return true;
}

//ALTX:ashout("/as");

CMD:as(playerid,params[]){
	return cmd_ashout(playerid,params);
}

CMD:whisper(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp_playerid,text[64];
	if(sscanf(params,"us[128]",temp_playerid,text)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /whisper [ id игрока ] [ сообщение ] "WHITE"- прошептать");
	    return true;
	}
	if(temp_playerid == playerid){
	    return true;
	}
	new Float:temp_x,Float:temp_y,Float:temp_z;
	GetPlayerPos(temp_playerid,temp_x,temp_y,temp_z);
	if(!IsPlayerInRangeOfPoint(playerid,2.0,temp_x,temp_y,temp_z)){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы находитесь далеко от игрока!");
	    return true;
	}
	new string[24-2-2+64+MAX_PLAYER_NAME];
	format(string,sizeof(string),"- %s - вам прошептал %s",text,player[playerid][name]);
	SendSplitClientMessage(temp_playerid,C_GREEN,string);
	format(string,sizeof(string),"- %s - вы прошептали %s",text,player[temp_playerid][name]);
	SendSplitClientMessage(playerid,C_GREEN,string);
	return true;
}

//ALTX:whisper("/w");

CMD:w(playerid,params[]){
	return cmd_whisper(playerid,params);
}

CMD:n(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	if(sscanf(params,"s[128]",params[0])){
        SendClientMessage(playerid,C_GREY,"Используйте: /n [ сообщение ] "WHITE"- OOC информация");
	    return true;
	}
	new string[23-2-2+128+MAX_PLAYER_NAME];
	format(string,sizeof(string),"(( - %s - сказал %s ))",params[0],player[playerid][name]);
	ProxDetector(15.0,playerid,string,C_GREY,C_GREY,C_GREY,C_GREY,C_GREY);
	return true;
}

//ALTX:n("/b");

CMD:b(playerid,params[]){
	return cmd_n(playerid,params);
}

CMD:an(playerid,params[]){
    if(player[playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У вас есть бана чата!");
	    return true;
	}
	new temp[128];
	if(sscanf(params,"s[128]",temp)){
        SendClientMessage(playerid,C_GREY,"Используйте: /an [ сообщение ] "WHITE"- OOC информация");
	    return true;
	}
	new string[9-2+128];
	format(string,sizeof(string),"(( %s ))",temp);
	SetPlayerChatBubble(playerid,string,C_GREY,15.0,4000);
	return true;
}

//ALTX:an("/ab");

CMD:ab(playerid,params[]){
	return cmd_an(playerid,params);
}

CMD:description(playerid){
	ShowPlayerDialog(playerid,dDescription,DIALOG_STYLE_LIST,""BLUE"Описание персонажа","[0] Прикрепить временное описание\n[1] Прикрепить и сохранить описание\n[2] Прикрепить сохранённое описание\n[3] Изменить описание\n[4] Убрать описание","Выбрать","Отмена");
	return true;
}

//ALTX:description("/desc");

CMD:desc(playerid){
	return cmd_description(playerid);
}

// Команды для транспорта

CMD:engine(playerid){
	new vehicleid=GetPlayerVehicleID(playerid);
	if(!vehicleid){
	    return true;
	}
	new temp_vehicleid=0;
	for(new i=0; i<MAX_VEHICLES; i++){
	    if(vehicle[i][id] == vehicleid){
	        temp_vehicleid=i;
	        break;
	    }
	}
	if(vehicle[temp_vehicleid][fuel]<=0.0){
	    SendClientMessage(playerid,C_RED,"[Информация] В транспорте нет топлива!");
	    return true;
	}
    new temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective;
	GetVehicleParamsEx(vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	switch(temp_engine){
	    case 0,-1:{
	        new temp[43];
	        format(temp,sizeof(temp),"/ado пытается завести двигатель транспорта");
	        DC_CMD(playerid,temp);
	        temp_engine=1;
			PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_FUEL]);
			PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_FUEL],C_RED);
			PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_FUEL],"fuel:eng_starting");
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_FUEL]);
	        SetTimerEx("engine_turn_on",500+random(500),false,"iiiiiiii",playerid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	    }
	    case 1:{
	        temp_engine=0;
	        SetVehicleParamsEx(vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	        new temp[35];
	        format(temp,sizeof(temp),"/ame заглушил двигатель транспорта");
	        DC_CMD(playerid,temp);
			PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_FUEL]);
			PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_FUEL],C_RED);
			PlayerTextDrawSetString(playerid,td_speed[playerid][TD_SPEED_FUEL],"fuel:eng_off");
			PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_FUEL]);
			KillTimer(timer_speed[playerid]);
	    }
	}
	return true;
}

CMD:lights(playerid){
	new temp_vehicleid=GetPlayerVehicleID(playerid);
	if(!temp_vehicleid){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться в транспорте!");
	    return true;
	}
	if(!IsValidVehicle(temp_vehicleid)){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете включать/выключать фары в этом транспорте!");
	    return true;
	}
    new temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective;
	GetVehicleParamsEx(temp_vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	switch(temp_lights){
	    case 0:{
	        temp_lights=1;
	        SetVehicleParamsEx(temp_vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	        new temp[29];
	        format(temp,sizeof(temp),"/ame включил фары транспорта");
	        DC_CMD(playerid,temp);
	        PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_LIGHTS]);
	        PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_LIGHTS],C_GREEN);
	        PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_LIGHTS]);
	    }
	    case 1:{
			temp_lights=0;
	        SetVehicleParamsEx(temp_vehicleid,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
	        new temp[30];
	        format(temp,sizeof(temp),"/ame выключил фары транспорта");
	        DC_CMD(playerid,temp);
	        PlayerTextDrawHide(playerid,td_speed[playerid][TD_SPEED_LIGHTS]);
	        PlayerTextDrawColor(playerid,td_speed[playerid][TD_SPEED_LIGHTS],C_RED);
	        PlayerTextDrawShow(playerid,td_speed[playerid][TD_SPEED_LIGHTS]);
	    }
	}
	return true;
}

// Команды для фракций

CMD:invite(playerid,params[]){
	if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться во фракции!");
	    return true;
	}
	if(GetPVarInt(playerid,"IsPlayerLeader")){
	    goto mark_2;
	}
	else if(GetPVarInt(playerid,"IsPlayerSubleader")){
		goto mark;
	}
	else{
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не лидер фракции!");
	    return true;
	}
	mark:
	if(!faction[player[playerid][faction_id]-1][sub_leader_access][INVITE]){
		SendClientMessage(playerid,C_RED,"[Информация] Лидер ограничил доступ к команде!");
		return true;
	}
	mark_2:
	if(sscanf(params,"u",params[0])){
	    SendClientMessage(playerid,C_GREY,"Используйте: /invite [ id игрока/часть ника ] "WHITE"- пригласить игрока во фракцию");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете принять во фракцию самого себя!");
	    return true;
	}
	new Float:temp_x,Float:temp_y,Float:temp_z;
	GetPlayerPos(params[0],temp_x,temp_y,temp_z);
	if(!IsPlayerInRangeOfPoint(playerid,5.0,temp_x,temp_y,temp_z)){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок находится далеко от вас!");
	    return true;
	}
	if(player[params[0]][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок уже находится во фракции!");
	    return true;
	}
	SetPVarInt(params[0],"invitePlayerId",playerid);
	SetPVarInt(params[0],"inviteFactionId",player[playerid][faction_id]);
	new string[84-2-2+MAX_PLAYER_NAME+32];
	format(string,sizeof(string),"\n"WHITE"Вы были приглашены лидером "BLUE"%s"WHITE" во фракцию - "BLUE"%s\n\n",player[playerid][name],faction[player[playerid][faction_id]][name]);
	ShowPlayerDialog(params[0],dInviteConfirm,DIALOG_STYLE_MSGBOX,""BLUE"Приглашение во фракцию",string,"Принять","Отказаться");
	return true;
}

CMD:uninvite(playerid,params[]){
    if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться во фракции!");
	    return true;
	}
	if(GetPVarInt(playerid,"IsPlayerLeader")){
	    goto mark_2;
	}
	else if(GetPVarInt(playerid,"IsPlayerSubleader")){
		goto mark;
	}
	else{
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не лидер фракции!");
	    return true;
	}
	mark:
	if(!faction[player[playerid][faction_id]-1][sub_leader_access][UNINVITE]){
		SendClientMessage(playerid,C_RED,"[Информация] Лидер ограничил доступ к команде!");
		return true;
	}
	mark_2:
	new reason[32];
	if(sscanf(params,"us[128]",params[0],reason)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /uninvite [ id игрока/часть ника ] [ причина ] "WHITE"- уволить игрока из фракции");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете уволить из фракции самого себя!");
	    return true;
	}
	if(player[params[0]][faction_id]!=player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок находится не в вашей фракции!");
	    return true;
	}
	if(GetPVarInt(playerid,"IsPlayerLeader") || GetPVarInt(playerid,"IsPlayerSubleader")){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете уволить лидера/заместителя!");
	    return true;
	}
	new string[81-2-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME+sizeof(reason)];
	format(string,sizeof(string),"[F] "WHITE"%s"BLUE" уволил игрока "WHITE"%s"BLUE" из фракции. Причина: "WHITE"%s",player[playerid][name],player[params[0]][name],reason);
	SendFactionMessage(player[playerid][faction_id],C_BLUE,string);
	player[params[0]][faction_id]=0;
	player[params[0]][rank_id]=0;
	new query[61-2+11];
	mysql_format(mysql_connection,query,sizeof(query),"update`users`set`faction_id`='0',`rank_id`='0'where`id`='%i'",player[params[0]][id]);
	mysql_query(mysql_connection,query,false);
	return true;
}

CMD:giverank(playerid,params[]){
    if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться во фракции!");
	    return true;
	}
	if(GetPVarInt(playerid,"IsPlayerLeader")){
	    goto mark_2;
	}
	else if(GetPVarInt(playerid,"IsPlayerSubleader")){
		goto mark;
	}
	else{
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не лидер фракции!");
	    return true;
	}
	mark:
	if(!faction[player[playerid][faction_id]-1][sub_leader_access][GIVERANK]){
		SendClientMessage(playerid,C_RED,"[Информация] Лидер ограничил доступ к команде!");
		return true;
	}
	mark_2:
	new rank[2];
	if(sscanf(params,"us[128]",params[0],rank)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /giverank [ id игрока/часть ника ] [ + / - ]");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете повысить/понизить самого себя!");
	    return true;
	}
	if(player[params[0]][faction_id]!=player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок находится не в вашей фракции!");
	    return true;
	}
	if(GetPVarInt(playerid,"IsPlayerLeader") || GetPVarInt(playerid,"IsPlayerSubleader")){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете повысить/понизить лидера/заместителя!");
	    return true;
	}
	if(!strcmp(rank,"+")){
	    if(player[params[0]][rank_id]==9){
	        SendClientMessage(playerid,C_RED,"[Информация] Игрок имеет уже максимальную должность во фракции!");
	        return true;
		}
		player[params[0]][rank_id]++;
		new string[75-2-2-2+MAX_PLAYER_NAME+24+2];
		format(string,sizeof(string),"Вы повысили игрока "WHITE"%s"BLUE" до должности "WHITE"%s "GREY"(%i)",player[params[0]][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(playerid,C_BLUE,string);
		format(string,sizeof(string),"%s "BLUE"повысил вас до должности "WHITE"%s "GREY"(%i)",player[playerid][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(params[0],C_WHITE,string);
	}
	else if(!strcmp(rank,"-")){
		if(player[params[0]][rank_id]==1){
		    SendClientMessage(playerid,C_RED,"[Информация] Игрок имеет уже минимальную должность во фракции!");
		    return true;
		}
		player[params[0]][rank_id]--;
		new string[75-2-2-2+MAX_PLAYER_NAME+24+2];
		format(string,sizeof(string),"Вы понизили игрока "WHITE"%s"BLUE" до должности "WHITE"%s "GREY"(%i)",player[params[0]][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(playerid,C_BLUE,string);
		format(string,sizeof(string),"%s "BLUE"понизил вас до должности "WHITE"%s "GREY"(%i)",player[playerid][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(params[0],C_WHITE,string);
	}
	else{
	    SendClientMessage(playerid,C_GREY,"Используйте: /giverank [ id игрока/часть ника ] [ + / - ]");
	    return true;
	}
	new query[45-2-2+2+11];
	mysql_format(mysql_connection,query,sizeof(query),"update`users`set`rank_id`='%i'where`id`='%i'",player[params[0]][rank_id],player[params[0]][id]);
	mysql_query(mysql_connection,query,false);
	return true;
}

CMD:faction(playerid,params[]){
    if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться во фракции!");
	    return true;
	}
	if(sscanf(params,"s[128]",params[0])){
	    SendClientMessage(playerid,C_GREY,"Используйте: /faction [ сообщение ]");
	    return true;
	}
	new string[11-2-2-2+24+MAX_PLAYER_NAME+128];
	format(string,sizeof(string),"[F] %s %s: %s",faction_ranks[player[playerid][faction_id]-1][player[playerid][rank_id]-1],player[playerid][name],params[0]);
	SendFactionMessage(player[playerid][faction_id],C_BLUE,string);
	return true;
}

//ALTX:faction("/f");

CMD:f(playerid,params[]){
	return cmd_faction(playerid,params);
}

CMD:find(playerid){
	if(!admin[playerid][commands][FIND]){
	    if(!player[playerid][faction_id]){
		    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться во фракции!");
		    return true;
		}
		new temp_faction_id=player[playerid][faction_id];
		new temp_string[23-2-2-2+MAX_PLAYER_NAME+3+24];
		static string[sizeof(temp_string)*20];
		foreach(new i:Player){
		    if(GetPVarInt(i,"PlayerLogged") && player[i][faction_id] == temp_faction_id){
		        format(temp_string,sizeof(string),""WHITE"%s [%i] - %s\n",player[i][name],i,faction_ranks[temp_faction_id-1][player[i][rank_id]-1]);
		        strcat(string,temp_string);
		    }
		}
		if(!strlen(string)){
		    strcat(string,"\n"WHITE"Нет участников фракции онлайн!\n\n");
		}
		ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Участники фракции онлайн",string,"Закрыть","");
		string="\0";
	}
	else{
	    new temp_string[10-2-2+2+24];
	    static string[sizeof(temp_string)*MAX_FACTIONS];
		for(new i=0; i<total_factions; i++){
		    format(temp_string,sizeof(temp_string),"[%i] %s\n",i+1,faction[i][name]);
		    strcat(string,temp_string);
		}
		ShowPlayerDialog(playerid,dFind,DIALOG_STYLE_LIST,""BLUE"Просмотр онлайна фракции",string,"Выбрать","Отмена");
		string="\0";
	}
	return true;
}

//ALTX:find("/members");

CMD:members(playerid){
	return cmd_find(playerid);
}

CMD:fmenu(playerid){
	if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться во фракции!");
	    return true;
	}
	new temp_entrance_id=faction[player[playerid][faction_id]-1][entrance_id]-1;
	new temp_entrance_status[20];
	format(temp_entrance_status,sizeof(temp_entrance_status),entrance[temp_entrance_id][locked]?""RED"[ закрыто ]":""GREEN"[ открыто ]");
	new string[104-2+20];
	format(string,sizeof(string),"[0] Специальные возможности фракции\n[1] Просмотреть онлайн фракции\n[2] Вход/Выход здания фракции - %s",temp_entrance_status);
	ShowPlayerDialog(playerid,dFpanel,DIALOG_STYLE_LIST,""BLUE"Меню фракции",string,"Выбрать","Отмена");
	return true;
}

//ALTX:fmenu("/fpanel","/fp","/fm");

CMD:fpanel(playerid){
	return cmd_fmenu(playerid);
}

CMD:fp(playerid){
	return cmd_fmenu(playerid);
}

CMD:fm(playerid){
	return cmd_fmenu(playerid);
}

CMD:lmenu(playerid){
	if(!GetPVarInt(playerid,"IsPlayerLeader")){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не лидер фракции!");
		return true;
	}
	ShowPlayerDialog(playerid,dLpanel,DIALOG_STYLE_LIST,""BLUE"Меню лидера","[0] Наименование рангов фракции\n[1] Участники фракции "RED"OFFLINE"GREEN"ONLINE\n[2] Управление участниками фракции "RED"OFFLINE\n[3] Заместитель","Выбрать","Отмена");
	return true;
}

//ALTX:lmenu("/lpanel","/lp","/lm");

CMD:lpanel(playerid){
	return cmd_lmenu(playerid);
}

CMD:lp(playerid){
	return cmd_lmenu(playerid);
}

CMD:lm(playerid){
	return cmd_lmenu(playerid);
}

// Команды для управления домом

CMD:home(playerid,params[]){
	if(!owned_house_id[playerid][0]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не владелец дома!");
	   	return true;
	}
	if(sscanf(params,"i",params[0])){
		new temp_string[11-2-2+1+4];
		new string[sizeof(temp_string)*MAX_OWNED_HOUSES];
		for(new i=0; i<MAX_OWNED_HOUSES; i++){
		    if(!owned_house_id[playerid][i]){
		        continue;
		    }
			format(temp_string,sizeof(temp_string),"[%i] №%i\n",i,owned_house_id[playerid][i]);
			strcat(string,temp_string);
		}
		ShowPlayerDialog(playerid,dHome,DIALOG_STYLE_LIST,""BLUE"Панель управления домом",string,"Выбрать","Отмена");
		return true;
	}
	if(!owned_house_id[playerid][params[0]]){
	    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
	    return true;
	}
	new temp_lock[20];
	new string[55-2+sizeof(temp_lock)];
	new houseid=owned_house_id[playerid][params[0]];
	temp_lock=house[houseid-1][locked]?""RED"[ закрыт ]":""GREEN"[ открыт ]";
    format(string,sizeof(string),"[0] Информация о доме\n[1] Замок - %s\n[2] Продать дом",temp_lock);
    SetPVarInt(playerid,"tempSelectedHouseid",params[0]);
    ShowPlayerDialog(playerid,dHomeMenu,DIALOG_STYLE_LIST,""BLUE"Панель управления домом",string,"Выбрать","Отмена");
	return true;
}

//ALTX:home("/hmenu","/hpanel","/hm","/hp");

CMD:hmenu(playerid,params[]){
	return cmd_home(playerid,params);
}

CMD:hpanel(playerid,params[]){
	return cmd_home(playerid,params);
}

CMD:hm(playerid,params[]){
	return cmd_home(playerid,params);
}

CMD:hp(playerid,params[]){
	return cmd_home(playerid,params);
}

CMD:buyhome(playerid){
	if(owned_house_id[playerid][MAX_OWNED_HOUSES-1]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы владеете максимальным количеством домов!");
	    return true;
	}
	new string[132-2-2+4+11];
	for(new i=0; i<total_houses; i++){
	    if(IsPlayerInDynamicArea(playerid,house[i][area_id])){
	        new houseid=i+1;
			format(string,sizeof(string),"\n"WHITE"Вы собираетесь купить дом "BLUE"№%i\n"WHITE"Государственная цена - "GREEN"$%i\n"WHITE"Вы хотите купить этот дом?\n\n",houseid,house[i][cost]);
			ShowPlayerDialog(playerid,dBuyhome,DIALOG_STYLE_MSGBOX,""BLUE"Покупка дома",string,"Да","Нет");
			SetPVarInt(playerid,"buyhomeHouseId",houseid);
		}
	}
	return true;
}

//ALTX:buyhome("/buyhouse");

CMD:buyhouse(playerid){
	return cmd_buyhome(playerid);
}

CMD:exit_preview(playerid){
	if(!GetPVarInt(playerid,"AddHouse_Preview")){
	    return true;
	}
	if(!GetPVarFloat(playerid,"AddHouse_PPosX") || !GetPVarFloat(playerid,"AddHouse_PPosY") || !GetPVarFloat(playerid,"AddHouse_PPosZ")){
		ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка!",""WHITE"Извините, произошла ошибка!","Закрыть","");
		DeletePVar(playerid,"AddHouse_Preview");
		DeletePVar(playerid,"AddHouse_PPosX");
		DeletePVar(playerid,"AddHouse_PPosY");
		DeletePVar(playerid,"AddHouse_PPosZ");
		DeletePVar(playerid,"AddHouse_PPosA");
		SpawnPlayer(playerid);
	    return true;
	}
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,1);//виртуальный мир мэрии
	SetPlayerPos(playerid,GetPVarFloat(playerid,"AddHouse_PPosX"),GetPVarFloat(playerid,"AddHouse_PPosY"),GetPVarFloat(playerid,"AddHouse_PPosZ"));
	SetPlayerFacingAngle(playerid,GetPVarFloat(playerid,"AddHouse_PPosA"));
    DeletePVar(playerid,"AddHouse_Preview");
	DeletePVar(playerid,"AddHouse_PPosX");
	DeletePVar(playerid,"AddHouse_PPosY");
	DeletePVar(playerid,"AddHouse_PPosZ");
	DeletePVar(playerid,"AddHouse_PPosA");
	ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"Размещение дома","[0] Просмотреть выбранный интерьер\n[1] Выбрать этот интерьер\n[2] Вернуться обратно","Дальше","Отмена");
	return true;
}

CMD:take_house(playerid){
	if(!GetPVarInt(playerid,"AddHouse_SetHPos")){
	    return true;
	}
	if(GetPVarFloat(playerid,"AddHouse_HPosX") || GetPVarFloat(playerid,"AddHouse_HPosY") || GetPVarFloat(playerid,"AddHouse_HPosZ") || GetPVarFloat(playerid,"AddHouse_HPosA")){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы уже выставили координаты для вашего дома!");
	    return true;
	}
	if(GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid)){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете установить вход в интерьере или вирт. мире!");
	    return true;
	}
	for(new i=0; i<total_houses; i++){
		if(IsPlayerInRangeOfPoint(playerid,2.5,house[i][enter_x],house[i][enter_y],house[i][enter_z])){
		    SendClientMessage(playerid,C_RED,"[Информация] Вы можете установить вход в этом месте!");
		    break;
		}
	}
	for(new i=0; i<total_entrance; i++){
		if(IsPlayerInRangeOfPoint(playerid,5.0,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z])){
            SendClientMessage(playerid,C_RED,"[Информация] Вы можете установить вход в этом месте!");
		    break;
		}
	}
	for(new i=0; i<total_actors; i++){
	    if(IsPlayerInRangeOfPoint(playerid,5.0,actor[i][pos_x],actor[i][pos_y],actor[i][pos_z])){
            SendClientMessage(playerid,C_RED,"[Информация] Вы можете установить вход в этом месте!");
		    break;
	    }
	}
	for(new i=0; i<total_businesses; i++){
		if(IsPlayerInRangeOfPoint(playerid,5.0,business[i][pos_x],business[i][pos_y],business[i][pos_z])){
		    SendClientMessage(playerid,C_RED,"[Информация] Вы можете установить вход в этом месте!");
		    break;
		}
	}
	new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_a;
	GetPlayerPos(playerid,temp_x,temp_y,temp_z);
	GetPlayerFacingAngle(playerid,temp_a);
	SetPVarFloat(playerid,"AddHouse_HPosX",temp_x);
	SetPVarFloat(playerid,"AddHouse_HPosY",temp_y);
	SetPVarFloat(playerid,"AddHouse_HPosZ",temp_z);
	SetPVarFloat(playerid,"AddHouse_HPosA",temp_a);
	ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Размещение дома","\n"WHITE"Вам нужно вернуться обратно в мэрию!\n\n","Закрыть","");
	return true;
}

CMD:exit_interior(playerid){
    if(player[playerid][faction_id] != faction[FACTION_CITYHALL][id] || !GetPVarInt(playerid,"Price4HInterior_PreviewStatus")){
        return true;
    }
    new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_a;
    temp_x=GetPVarFloat(playerid,"Price4HInterior_PosX");
    temp_y=GetPVarFloat(playerid,"Price4HInterior_PosY");
    temp_z=GetPVarFloat(playerid,"Price4HInterior_PosZ");
    temp_a=GetPVarFloat(playerid,"Price4HInterior_PosA");
    DeletePVar(playerid,"Price4HInterior_PosX");
    DeletePVar(playerid,"Price4HInterior_PosY");
    DeletePVar(playerid,"Price4HInterior_PosZ");
    DeletePVar(playerid,"Price4HInterior_PosA");
    SetPlayerPos(playerid,temp_x,temp_y,temp_z);
    SetPlayerFacingAngle(playerid,temp_a);
    new temp_interior,temp_virtualworld;
    temp_interior=GetPVarInt(playerid,"Price4HInterior_Interior");
    DeletePVar(playerid,"Price4HInterior_Interior");
    SetPlayerInterior(playerid,temp_interior);
    temp_virtualworld=GetPVarInt(playerid,"Price4HInterior_VirtualWorld");
    DeletePVar(playerid,"Price4HInterior_VirtualWorld");
    SetPlayerVirtualWorld(playerid,temp_virtualworld);
    DeletePVar(playerid,"Price4HInterior_PreviewStatus");
    ShowPlayerDialog(playerid,dFpanelSpecialPrice4HInteriorL,DIALOG_STYLE_LIST,""BLUE"Изменение цены на интерьер дома","[0] Просмотреть интерьер\n[1] Изменить цену на интерьер","Выбрать","Назад");
	return true;
}

//Команды для управления бизнесами

CMD:buybusiness(playerid,params[]){
    if(owned_business_id[playerid][MAX_OWNED_BUSINESSES-1]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы владеете максимальным количеством домов!");
	    return true;
	}
	new string[215-2-2-2-2+3+11+24+32];
	for(new i=0; i<total_businesses; i++){
	    if(IsPlayerInDynamicArea(playerid,business[i][area_id])){
			format(string,sizeof(string),"\n"WHITE"Вы собираетесь купить бизнес "BLUE"№%i\n\n"WHITE"Государственная цена - "GREEN"$%i\n"WHITE"Тип бизнеса - "BLUE"%s\n"WHITE"Название бизнеса - "BLUE"%s\n\n"WHITE"Вы хотите купить этот бизнес?\n\n",i+1,business[i][price],type_of_business[business[i][type]-1],business[i][name]);
			ShowPlayerDialog(playerid,dBuybusiness,DIALOG_STYLE_MSGBOX,""BLUE"Покупка бизнеса",string,"Да","Нет");
			SetPVarInt(playerid,"buybusinessId",i+1);
		}
	}
	return true;
}

//ALTX:buybusiness("/buybiz");

CMD:buybiz(playerid,params[]){
	return cmd_buybusiness(playerid,params);
}

CMD:business(playerid,params[]){
	if(!owned_business_id[playerid][0]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не владелец бизнеса!");
	   	return true;
	}
	if(sscanf(params,"i",params[0])){
		new temp_string[11-2-2+1+4];
		new string[sizeof(temp_string)*MAX_OWNED_BUSINESSES];
		for(new i=0; i<MAX_OWNED_BUSINESSES; i++){
		    if(!owned_business_id[playerid][i]){
		        continue;
		    }
			format(temp_string,sizeof(temp_string),"[%i] №%i\n",i,owned_business_id[playerid][i]);
			strcat(string,temp_string);
		}
		ShowPlayerDialog(playerid,dBusiness,DIALOG_STYLE_LIST,""BLUE"Панель управления бизнесом",string,"Выбрать","Отмена");
		return true;
	}
	if(!owned_business_id[playerid][params[0]]){
	    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"Ошибка","\n"WHITE"Извините, произошла ошибка!\n\n","Закрыть","");
	    return true;
	}
	new temp_lock[20];
	new string[61-2+sizeof(temp_lock)];
	new temp_businessid=owned_business_id[playerid][params[0]];
	format(temp_lock,sizeof(temp_lock),business[temp_businessid-1][locked]?""RED"[ закрыт ]":""GREEN"[ открыт ]");
    format(string,sizeof(string),"[0] Информация о бизнесе\n[1] Замок - %s\n[2] Продать бизнес",temp_lock);
    SetPVarInt(playerid,"tempSelectedBusinessid",params[0]);
    ShowPlayerDialog(playerid,dBusinessMenu,DIALOG_STYLE_LIST,""BLUE"Панель управления бизнесом",string,"Выбрать","Отмена");
	return true;
}

//ALTX:business("/bmenu","/bpanel","/bm","/bp");

CMD:bmenu(playerid,params[]){
	return cmd_business(playerid,params);
}

CMD:bpanel(playerid,params[]){
	return cmd_business(playerid,params);
}

CMD:bm(playerid,params[]){
	return cmd_business(playerid,params);
}

CMD:bp(playerid,params[]){
	return cmd_business(playerid,params);
}

//Команды управления транспортом

CMD:lock(playerid,params[]){
	new sscanf_type;
	if(sscanf(params,"i",sscanf_type)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /lock [ тип транспорта ] (1 - личный)");
	    return true;
	}
	switch(sscanf_type){
	    case 1:{
	        if(owned_vehicle_id[playerid][0]<0){
	            SendClientMessage(playerid,C_RED,"[Информация] У Вас нет личного транспорта!");
	            return true;
	        }
			if(IsPlayerInAnyVehicle(playerid)){
				new temp_vehicleid=GetPlayerVehicleID(playerid);
				for(new i=0; i<MAX_OWNED_VEHICLES; i++){
					if(temp_vehicleid == vehicle[owned_vehicle_id[playerid][i]][id]){
						lockOfVehicle(owned_vehicle_id[playerid][i],playerid);
						break;
					}
				}
			}
			else{
				new temp_string[22-2-2-2+2+32+3];
				new string[sizeof(temp_string)*MAX_OWNED_VEHICLES];
				new temp_vehiclemodel=0;
				for(new i=0; i<MAX_OWNED_VEHICLES; i++){
					if(owned_vehicle_id[playerid][i]<0){
						continue;
					}
					temp_vehiclemodel=vehicle[owned_vehicle_id[playerid][i]][model];
					format(temp_string,sizeof(temp_string),"[%i] %s [ V-ID %i ]\n",i,transport[temp_vehiclemodel-400][name],vehicle[owned_vehicle_id[playerid][i]][mysql_id]);
					strcat(string,temp_string);
				}
				ShowPlayerDialog(playerid,dLockVehicle,DIALOG_STYLE_LIST,""BLUE"Управление замком личного транспорта",string,"Выбрать","Отмена");
			}
	    }
	    default:{
            SendClientMessage(playerid,C_GREY,"Используйте: /lock [ тип транспорта ] (1 - личный)");
	    }
	}
	return true;
}

CMD:park(playerid){
    if(owned_vehicle_id[playerid][0]<0){
        SendClientMessage(playerid,C_RED,"[Информация] У Вас нет личного транспорта!");
        return true;
    }
    new temp_vehicleid;
    for(new i=0; i<MAX_VEHICLES; i++){
	    for(new j=0; j<MAX_OWNED_VEHICLES; j++){
	        if(IsPlayerInAnyVehicle(playerid) && (GetPlayerVehicleID(playerid) == vehicle[i][id] && owned_vehicle_id[playerid][j]+1 == vehicle[i][id])){
				temp_vehicleid=i;
				break;
	        }
	    }
	}
    if(!temp_vehicleid){
        SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться в личном транспорте!");
        return true;
    }
    new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_a;
    GetVehiclePos(vehicle[temp_vehicleid][id],temp_x,temp_y,temp_z);
    GetVehicleZAngle(vehicle[temp_vehicleid][id],temp_a);
    vehicle[temp_vehicleid][park_pos_x]=temp_x;
    vehicle[temp_vehicleid][park_pos_y]=temp_y;
    vehicle[temp_vehicleid][park_pos_z]=temp_z;
    vehicle[temp_vehicleid][park_pos_a]=temp_a;
    new query[49-2-2-2-2-2+11+11+11+11+11];
    mysql_format(mysql_connection,query,sizeof(query),"update`vehicles`set`park_pos`='%f|%f|%f|%f'where`id`='%i'",temp_x,temp_y,temp_z,temp_a,vehicle[temp_vehicleid][mysql_id]);
    mysql_query(mysql_connection,query,false);
    SendClientMessage(playerid,C_BLUE,"[Информация] Вы припарковали личный транспорт!");
    new temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective;
	GetVehicleParamsEx(temp_vehicleid+1,temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
    DestroyVehicle(vehicle[temp_vehicleid][id]);
    vehicle[temp_vehicleid][id]=AddStaticVehicleEx(vehicle[temp_vehicleid][model],vehicle[temp_vehicleid][park_pos_x],vehicle[temp_vehicleid][park_pos_y],vehicle[temp_vehicleid][park_pos_z],vehicle[temp_vehicleid][park_pos_a],vehicle[temp_vehicleid][colors][0],vehicle[temp_vehicleid][colors][1],999999);
    SetVehicleParamsEx(vehicle[temp_vehicleid][id],temp_engine,temp_lights,temp_alarm,temp_doors,temp_bonnet,temp_boot,temp_objective);
    PutPlayerInVehicle(playerid,vehicle[temp_vehicleid][id],VEHICLE_DRIVER_SEAT);
	return true;
}

CMD:sellcar(playerid){
    if(owned_vehicle_id[playerid][0]<0){
        SendClientMessage(playerid,C_RED,"[Информация] У Вас нет личного транспорта!");
        return true;
    }
    new temp_vehicleid;
    for(new i=0; i<MAX_VEHICLES; i++){
	    for(new j=0; j<MAX_OWNED_VEHICLES; j++){
	        if(IsPlayerInAnyVehicle(playerid) && (GetPlayerVehicleID(playerid) == vehicle[i][id] && owned_vehicle_id[playerid][j]+1 == vehicle[i][id])){
				temp_vehicleid=i;
				break;
	        }
	    }
	}
    if(!temp_vehicleid){
        SendClientMessage(playerid,C_RED,"[Информация] Вы должны находиться в личном транспорте!");
        return true;
    }
    DestroyVehicle(vehicle[temp_vehicleid][id]);
    new query[36-2+11];
	mysql_format(mysql_connection,query,sizeof(query),"delete from`vehicles`where`id`='%i'",vehicle[temp_vehicleid][mysql_id]);
	mysql_query(mysql_connection,query,false);
    for(new i=0; i<MAX_OWNED_VEHICLES; i++){
	    owned_vehicle_id[playerid][i]=-1;
	}
	for(new vehiclesINFO:i; i<vehiclesINFO; i++){
        vehicle[temp_vehicleid][i]=0;
    }
	new temp_count=0;
	for(new i=0; i<MAX_VEHICLES; i++){
	    if(!strcmp(vehicle[i][owner],player[playerid][name])){
	        owned_vehicle_id[playerid][temp_count]=i;
	    }
	}
    SendClientMessage(playerid,C_BLUE,"[Информация] Вы продали личный транспорт!");
	return true;
}

//ALTX:sellcar("/sellvehicle");

CMD:sellvehicle(playerid){
	return cmd_sellcar(playerid);
}

//Команды для администраторов

CMD:admins(playerid){
	if(!admin[playerid][commands][ADMINS]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new Cache:admins=mysql_query(mysql_connection,"select`name`from`admins`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_name[MAX_PLAYER_NAME],temp_playerid,temp_online[41],temp_id,temp_date[24];
	    new query[67-2+11];
	    new temp_string[25-2-2-2+2+MAX_PLAYER_NAME+41];
	    static string[sizeof(temp_string)*20];
	    string="\n";
		new rows=cache_get_row_count(mysql_connection);
		for(new i=0; i<rows; i++){
		    cache_get_field_content(i,"name",temp_name,mysql_connection,sizeof(temp_name));
			sscanf(temp_name,"u",temp_playerid);
			if(GetPVarInt(temp_playerid,"PlayerLogged")){
			    temp_online=""GREEN"Online";
			}
			else{
				mysql_format(mysql_connection,query,sizeof(query),"select`id`from`users`where`name`='%e'limit 1",temp_name);
				new Cache:users=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					temp_id=cache_get_field_content_int(0,"id",mysql_connection);
					mysql_format(mysql_connection,query,sizeof(query),"select`date`from`connects`where`id`='%i'order by`date`desc limit 1",temp_id);
					new Cache:connects=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
						cache_get_field_content(0,"date",temp_date,mysql_connection,sizeof(temp_date));
						format(temp_online,sizeof(temp_online),""RED"Offline | %s",temp_date);
					}
					cache_delete(connects,mysql_connection);
				}
				cache_delete(users,mysql_connection);
			}
			format(temp_string,sizeof(temp_string),""WHITE"[%i] %s - %s\n",i+1,temp_name,temp_online);
			strcat(string,temp_string);
			cache_set_active(admins,mysql_connection);
		}
		ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Администраторы сервера",string,"Закрыть","");
		string="";
	}
	else{
	    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"Информация","\n"BLUE"Извините, произошла ошибка!\n\n","Закрыть","");
	}
	cache_delete(admins,mysql_connection);
	return true;
}

CMD:makeleader(playerid,params[]){
	if(!admin[playerid][commands][MAKELEADER]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	if(sscanf(params,"u",params[0])){
	    SendClientMessage(playerid,C_GREY,"Используйте: /makeleader [ id игрока/часть ника ]");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете назначить лидером самого себя!");
	    return true;
	}
	SetPVarInt(playerid,"makeleaderPlayerId",params[0]);
	new temp_string[13-2-2-2+2+32+MAX_PLAYER_NAME];
	static string[sizeof(temp_string)*MAX_FACTIONS];
	for(new i=0; i<total_factions; i++){
	    format(temp_string,sizeof(temp_string),"%i\t%s\t%s\n",i+1,faction[i][name],faction[i][leader]);
		strcat(string,temp_string);
	}
	ShowPlayerDialog(playerid,dMakeleader,DIALOG_STYLE_LIST,""BLUE"Назначение игрока на пост лидера",string,"Выбрать","Отмена");
	string="";
	return true;
}

CMD:achat(playerid,params[]){
	if(!admin[playerid][commands][ACHAT]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	if(sscanf(params,"s[128]",params[0])){
	    SendClientMessage(playerid,C_GREY,"Используйте: /achat [ сообщение ]");
	    return true;
	}
	new string[16-2-2-2+MAX_PLAYER_NAME+4+128];
	format(string,sizeof(string),"[A] %s [%i]: %s",player[playerid][name],playerid,params[0]);
	SendAdminsMessage(C_RED,string);
	return true;
}

CMD:giveaccess(playerid,params[]){
	if(!GetPVarInt(playerid,"IsPlayerDeveloper")){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	if(sscanf(params,"u",params[0])){
	    SendClientMessage(playerid,C_GREY,"Используйте: /giveaccess [ id игрока/часть ника ]");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	SetPVarInt(playerid,"giveaccessPlayerId",params[0]);
	new temp_string[13-2-2-2+2+16+24];
	static string[sizeof(temp_string)*MAX_ADMIN_COMMANDS];
	new temp_access[24];
	for(new i=0; i<MAX_ADMIN_COMMANDS; i++){
	    temp_access=admin[params[0]][commands][i]?""GREEN"[Есть доступ]":""RED"[Нет доступа]";
	    format(temp_string,sizeof(temp_string),"[%i] %s %s\n",i,admin_commands[i],temp_access);
	    strcat(string,temp_string);
	}
	ShowPlayerDialog(playerid,dGiveaccess,DIALOG_STYLE_LIST,""BLUE"Выдать доступ к команде",string,"Выбрать","Отмена");
	string="";
	return true;
}

CMD:apanel(playerid){
	if(!admin[playerid][commands][APANEL]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	ShowPlayerDialog(playerid,dApanel,DIALOG_STYLE_LIST,""BLUE"Панель Администратора","[0] Доступные команды\n[1] Управление имуществами\n[2] Телепорт ко входам","Выбрать","Отмена");
	return true;
}

CMD:change_house(playerid){
    if(player[playerid][faction_id]==faction[FACTION_CITYHALL][id]){
	    if(!GetPVarInt(playerid,"FpanelConfirm_ChangeHouse")){
		    return true;
		}
		new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_a;
		GetPlayerPos(playerid,temp_x,temp_y,temp_z);
		GetPlayerFacingAngle(playerid,temp_a);
		SetPVarFloat(playerid,"FpanelConfirm_ChangeHouseX",temp_x);
		SetPVarFloat(playerid,"FpanelConfirm_ChangeHouseY",temp_y);
		SetPVarFloat(playerid,"FpanelConfirm_ChangeHouseZ",temp_z);
		SetPVarFloat(playerid,"FpanelConfirm_ChangeHouseA",temp_a);
		SendClientMessage(playerid,C_GREEN,"[Информация] Вы установили новые координаты для дома!");
	}
	else if(admin[playerid][commands][APANEL]){
		if(!GetPVarInt(playerid,"ApanelConfirm_ChangeHouse")){
		    return true;
		}
		new Float:temp_x,Float:temp_y,Float:temp_z,Float:temp_a;
		GetPlayerPos(playerid,temp_x,temp_y,temp_z);
		GetPlayerFacingAngle(playerid,temp_a);
		SetPVarFloat(playerid,"ApanelConfirm_ChangeHouseX",temp_x);
		SetPVarFloat(playerid,"ApanelConfirm_ChangeHouseY",temp_y);
		SetPVarFloat(playerid,"ApanelConfirm_ChangeHouseZ",temp_z);
		SetPVarFloat(playerid,"ApanelConfirm_ChangeHouseA",temp_a);
		SendClientMessage(playerid,C_GREEN,"[Информация] Вы установили новые координаты для дома!");
	}
	else{
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	}
	return true;
}

CMD:mute(playerid,params[]){
    if(!admin[playerid][commands][MUTE]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_playerid,temp_time,temp_reason[32];
	if(sscanf(params,"uis[128]",temp_playerid,temp_time,temp_reason)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /mute [ id игрока/часть ника ] [ кол-во минут(0 - снять) ] [ причина ]");
	    return true;
	}
	if(!GetPVarInt(temp_playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	if(!GetPVarInt(playerid,"IsPlayerDeveloper")){
	    if(admin[temp_playerid][id]){
	        SendClientMessage(playerid,C_RED,"[Информация] Вы не можете забанить администратора!");
	        return true;
	    }
	}
	if(!player[temp_playerid][mute] && temp_time){
	    player[temp_playerid][mute]=temp_time;
		new string[61-2-2-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME+3+32];
		format(string,sizeof(string),"[ ADMIN ] %s дал бан чата игроку %s на %i минут. Причина: %s",player[playerid][name],player[temp_playerid][name],temp_time,temp_reason);
		SendClientMessageToAll(C_RED,string);
	}
	else if(!temp_time && player[temp_playerid][mute]){
	    player[temp_playerid][mute]=0;
	    new string[50-2-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME+32];
	    format(string,sizeof(string),"[ ADMIN ] %s снял бан чата игроку %s. Причина: %s",player[playerid][name],player[temp_playerid][name],temp_reason);
	    SendClientMessageToAll(C_RED,string);
	}
	else if(temp_time && player[temp_playerid][mute]){
	    SendClientMessage(playerid,C_RED,"[Информация] У игрока уже есть бан чата!");
	    return true;
	}
	else if(temp_time<1 || temp_time>360){
	    SendClientMessage(playerid,C_RED,"[Информация] Значение может быть от 1 до 360 минут!");
	    return true;
	}
	new query[42-2-2+3+11];
	mysql_format(mysql_connection,query,sizeof(query),"update`users`set`mute`='%i'where`id`='%i'",player[temp_playerid][mute],player[temp_playerid][id]);
	mysql_query(mysql_connection,query,false);
	return true;
}

CMD:ban(playerid,params[]){
    if(!admin[playerid][commands][BAN]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_playerid,temp_days,temp_reason[32];
	if(sscanf(params,"uis[128]",temp_playerid,temp_days,temp_reason)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /ban [ id игрока/часть ника ] [ кол-во дней ] [ причина(- без причины) ]");
	    return true;
	}
	if(!GetPVarInt(temp_playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	if(temp_days<1 || temp_days>30){
	    SendClientMessage(playerid,C_RED,"[Информация] Значение может быть от 1 до 30 дней!");
	    return true;
	}
	if(!GetPVarInt(playerid,"IsPlayerDeveloper")){
	    if(admin[temp_playerid][id]){
	        SendClientMessage(playerid,C_RED,"[Информация] Вы не можете забанить администратора!");
	        return true;
	    }
	}
	new temp_bantime=gettime()+(3600*3);
	new temp_expiretime=temp_bantime+(86400*temp_days);
	new query[101-2-2-2-2-2+MAX_PLAYER_NAME+32+MAX_PLAYER_NAME+11+11];
	mysql_format(mysql_connection,query,sizeof(query),"insert into`ban`(`name`,`reason`,`adminname`,`bantime`,`expiretime`)values('%e','%e','%e','%i','%i')",player[temp_playerid][name],temp_reason,player[playerid][name],temp_bantime,temp_expiretime);
	mysql_query(mysql_connection,query,false);
	new string[55-2-2-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME+2+32];
	format(string,sizeof(string),(!strcmp(temp_reason,"-"))?"[ ADMIN ] %s забанил игрока %s на %i дней":"[ ADMIN ] %s забанил игрока %s на %i дней. Причина: %s",player[playerid][name],player[temp_playerid][name],temp_days,temp_reason);
	SendClientMessageToAll(C_RED,string);
	SetTimerEx("kick_player",250,false,"i",temp_playerid);
	return true;
}

CMD:unban(playerid,params[]){
    if(!admin[playerid][commands][UNBAN]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_name[MAX_PLAYER_NAME];
	if(sscanf(params,"s[128]",temp_name)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /unban [ никнейм ]");
	    return true;
	}
	new query[62-2+MAX_PLAYER_NAME];
	mysql_format(mysql_connection,query,sizeof(query),"select`id`from`users`where`name`='%e'limit 1",temp_name);
	new Cache:cache_users=mysql_query(mysql_connection,query);
	if(cache_get_row_count(mysql_connection)){
		mysql_format(mysql_connection,query,sizeof(query),"select`id`from`ban`where`name`='%e'and`unbanned`='0'",temp_name);
		new Cache:cache_ban=mysql_query(mysql_connection,query);
		if(cache_get_row_count(mysql_connection)){
		    mysql_format(mysql_connection,query,sizeof(query),"update`ban`set`unbanned`='1'where`name`='%e'and`unbanned`='0'",temp_name);
		    mysql_query(mysql_connection,query,false);
		    new string[45-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME];
		    format(string,sizeof(string),"[ ADMIN ] %s разблокировал аккаунт игрока %s",player[playerid][name],temp_name);
		    SendClientMessageToAll(C_RED,string);
		}
		else{
		    SendClientMessage(playerid,C_RED,"[Информация] Указанный аккаунт не заблокирован!");
		}
		cache_delete(cache_ban,mysql_connection);
	}
	else{
	    SendClientMessage(playerid,C_RED,"[Информация] Указанный аккаунт не найден в базе данных!");
	}
	cache_delete(cache_users,mysql_connection);
	return true;
}

CMD:getip(playerid,params[]){
    if(!admin[playerid][commands][GETIP]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_playerid;
	if(sscanf(params,"u",temp_playerid)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /getip [ id игрока/часть ника ]");
	    return true;
	}
	if(!GetPVarInt(temp_playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не авторизован на сервере!");
	    return true;
	}
	new temp_ip[16];
	GetPlayerIp(temp_playerid,temp_ip,sizeof(temp_ip));
	new string[29-2-2+MAX_PLAYER_NAME+16];
	format(string,sizeof(string),"[ GETIP ] Игрок: %s | IP: %s",player[temp_playerid][name],temp_ip);
	SendClientMessage(playerid,C_GREEN,string);
	return true;
}

CMD:getregip(playerid,params[]){
    if(!admin[playerid][commands][GETREGIP]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_name[MAX_PLAYER_NAME];
	if(sscanf(params,"s[128]",temp_name)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /getregip [ id игрока/никнейм(offline) ]");
	    return true;
	}
	new temp_playerid;
	sscanf(temp_name,"u",temp_playerid);
	if(!GetPVarInt(temp_playerid,"PlayerLogged")){
	    new query[60-2+MAX_PLAYER_NAME];
	    mysql_format(mysql_connection,query,sizeof(query),"select`reg_ip`,`reg_date`from`users`where`name`='%e'limit 1",temp_name);
	    new Cache:cache_users=mysql_query(mysql_connection,query);
	    if(cache_get_row_count(mysql_connection)){
	        new temp_regip[16],temp_regdate[24];
	        cache_get_field_content(0,"reg_ip",temp_regip,mysql_connection,sizeof(temp_regip));
	        cache_get_field_content(0,"reg_date",temp_regdate,mysql_connection,sizeof(temp_regdate));
	        new string[51-2-2-2+MAX_PLAYER_NAME+16+24];
	        format(string,sizeof(string),"[ GETREGIP ] Аккаунт: %s | REGIP: %s | REGDATE: %s",temp_name,temp_regip,temp_regdate);
	        SendClientMessage(playerid,C_GREEN,string);
	    }
	    else{
	        SendClientMessage(playerid,C_RED,"[Информация] Указанный аккаунт не найден в базе данных!");
	    }
	    cache_delete(cache_users,mysql_connection);
	}
	else{
	    new string[49-2-2-2+MAX_PLAYER_NAME+16+24];
	    format(string,sizeof(string),"[ GETREGIP ] Игрок: %s | REGIP: %s | REGDATE: %s",player[temp_playerid][name],player[temp_playerid][reg_ip],player[temp_playerid][reg_date]);
	    SendClientMessage(playerid,C_GREEN,string);
	}
	return true;
}

CMD:banip(playerid,params[]){
    if(!admin[playerid][commands][BANIP]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_ip[16];
	if(sscanf(params,"s[128]",temp_ip)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /banip [ IP адрес ]");
	    return true;
	}
	if(!regex_match(temp_ip,"[0-9]{1,3}+.[0-9]{1,3}+.[0-9]{1,3}+.[0-9]{1,3}")){
	    SendClientMessage(playerid,C_RED,"[Информация] Неправильный формат IP адреса!");
	    return true;
	}
	new query[49-2-2+MAX_PLAYER_NAME+16];
	mysql_format(mysql_connection,query,sizeof(query),"insert into`banip`(`adminname`,`ip`)values('%e','%e')",player[playerid][name],temp_ip);
	mysql_query(mysql_connection,query,false);
	new string[38-2-2+MAX_PLAYER_NAME+16];
	format(string,sizeof(string),"[ ADMIN ] %s заблокировал IP адрес %s",player[playerid][name],temp_ip);
	SendClientMessageToAll(C_RED,string);
	return true;
}

CMD:unbanip(playerid,params[]){
    if(!admin[playerid][commands][UNBANIP]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_ip[16];
	if(sscanf(params,"s[128]",temp_ip)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /unbanip [ IP адрес ]");
	    return true;
	}
	if(!regex_match(temp_ip,"[0-9]{1,3}+.[0-9]{1,3}+.[0-9]{1,3}+.[0-9]{1,3}")){
	    SendClientMessage(playerid,C_RED,"[Информация] Неправильный формат IP адреса!");
	    return true;
	}
	new query[33-2+16];
	mysql_format(mysql_connection,query,sizeof(query),"delete from`banip`where`ip`='%e'",temp_ip);
	mysql_query(mysql_connection,query,false);
	new string[39-2-2+MAX_PLAYER_NAME+16];
	format(string,sizeof(string),"[ ADMIN ] %s разблокировал IP адрес %s",player[playerid][name],temp_ip);
	SendClientMessageToAll(C_RED,string);
	return true;
}

CMD:delacc(playerid,params[]){
    if(!admin[playerid][commands][DELACC]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_name[MAX_PLAYER_NAME];
	if(sscanf(params,"s[128]",temp_name)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /delacc [ никнейм ]");
	    return true;
	}
	if(!regex_match(temp_name,"[a-zA-Z0-9_]{3,24}+")){
	    SendClientMessage(playerid,C_RED,"[Информация] Неправильный формат никнейма!");
	    return true;
	}
	new temp_playerid;
	sscanf(temp_name,"u",temp_playerid);
	if(GetPVarInt(playerid,"PlayerLogged")){
	    SendClientMessage(temp_playerid,C_RED,"Ваш аккаунт был удалён!");
	    SetTimerEx("kick_player",250,false,"i",temp_playerid);
	}
	new query[58-2+MAX_PLAYER_NAME];
	mysql_format(mysql_connection,query,sizeof(query),"select`id`from`admins`where`name`='%e'",temp_name);
	new Cache:cache_admins=mysql_query(mysql_connection,query);
	if(cache_get_row_count(mysql_connection)){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете удалить аккаунт администратора!");
	    return true;
	}
	cache_delete(cache_admins,mysql_connection);
	mysql_format(mysql_connection,query,sizeof(query),"delete from`users`where`name`='%e'",temp_name);
	new Cache:cache_users=mysql_query(mysql_connection,query);
	if(cache_affected_rows(mysql_connection)){
	    mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`owner`='-'where`owner`='%e'",temp_name);
	    new Cache:cache_houses=mysql_query(mysql_connection,query);
		new string[38-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME];
	    if(cache_affected_rows(mysql_connection)){
	        format(string,sizeof(string),"[ DELACC ] С аккаунта было продано %i домов!",cache_affected_rows(mysql_connection));
	        SendClientMessage(playerid,C_GREY,string);
	        for(new i=0; i<total_houses; i++){
	            if(strlen(house[i][owner])<3){
	                continue;
	            }
	            if(!strcmp(house[i][owner],temp_name)){
					strmid(house[i][owner],"-",0,1);
					DestroyDynamicPickup(house[i][pickupid]);
                	house[i][pickupid]=CreateDynamicPickup(1273,23,house[i][enter_x],house[i][enter_y],house[i][enter_z]);
	            }
	        }
	    }
	    cache_delete(cache_houses,mysql_connection);
	    cache_set_active(cache_users,mysql_connection);
	    mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`leader`='-'where`leader`='%e'",temp_name);
	    new Cache:cache_factions=mysql_query(mysql_connection,query);
	    if(cache_affected_rows(mysql_connection)){
	        SendClientMessage(playerid,C_GREY,"[ DELACC ] Аккаунт снят с поста лидерства!");
	    }
	    cache_delete(cache_factions,mysql_connection);
		cache_set_active(cache_users,mysql_connection);
		mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`sub_leader`='-'where`sub_leader`='%e'",temp_name);
		cache_factions=mysql_query(mysql_connection,query);
		if(cache_affected_rows(mysql_connection)){
	        SendClientMessage(playerid,C_GREY,"[ DELACC ] Аккаунт снят с поста заместителя лидера!");
	    }
	    cache_delete(cache_factions,mysql_connection);
		cache_set_active(cache_users,mysql_connection);
		mysql_format(mysql_connection,query,sizeof(query),"delete from`passports`where`owner`='%e'",temp_name);
		new Cache:cache_passports=mysql_query(mysql_connection,query);
		if(cache_affected_rows(mysql_connection)){
	        SendClientMessage(playerid,C_GREY,"[ DELACC ] Паспорт, которым владел аккаунт был удалён!");
	    }
	    cache_delete(cache_passports,mysql_connection);
		cache_set_active(cache_users,mysql_connection);
		format(string,sizeof(string),"[ ADMIN ] %s удалил аккаунт игрока %s",player[playerid][name],temp_name);
		SendClientMessageToAll(C_RED,string);
	}
	else{
	    SendClientMessage(playerid,C_RED,"[Информация] Указанный аккаунт не зарегистрирован в системе!");
	}
	cache_delete(cache_users,mysql_connection);
	return true;
}

CMD:goto(playerid,params[]){
    if(!admin[playerid][commands][GOTO]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_playerid;
	if(sscanf(params,"u",temp_playerid)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /goto [ id игрока ]");
	    return true;
	}
	if(!GetPVarInt(temp_playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не подключен к серверу!");
	    return true;
	}
	if(playerid == temp_playerid){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете использовать это действие на себе!");
	    return true;
	}
	new Float:temp_x,Float:temp_y,Float:temp_z;
	GetPlayerPos(temp_playerid,temp_x,temp_y,temp_z);
	SetPlayerPos(playerid,temp_x+1.0,temp_y+1.0,temp_z);
	return true;
}

CMD:gethere(playerid,params[]){
    if(!admin[playerid][commands][GETHERE]){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
	    return true;
	}
	new temp_playerid;
	if(sscanf(params,"u",temp_playerid)){
	    SendClientMessage(playerid,C_GREY,"Используйте: /gethere [ id игрока ]");
	    return true;
	}
	if(!GetPVarInt(temp_playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[Информация] Игрок не подключен к серверу!");
	    return true;
	}
	if(playerid == temp_playerid){
	    SendClientMessage(playerid,C_RED,"[Информация] Вы не можете использовать это действие на себе!");
	    return true;
	}
	if(IsPlayerInAnyVehicle(temp_playerid)){
	    RemovePlayerFromVehicle(temp_playerid);
	}
    new Float:temp_x,Float:temp_y,Float:temp_z;
	GetPlayerPos(playerid,temp_x,temp_y,temp_z);
	SetPlayerPos(temp_playerid,temp_x+1.0,temp_y+1.0,temp_z);
	SendClientMessage(temp_playerid,C_BLUE,"[Информация] Вы были телепортированы администратором сервера!");
	return true;
}

CMD:getstats(playerid,params[]){
	if(!admin[playerid][commands][GETSTATS]){
		SendClientMessage(playerid,C_RED,"[Информация] Вы не имеете доступ к этой команде!");
		return true;
	}
	new temp_name[MAX_PLAYER_NAME];
	if(sscanf(params,"s[128]",temp_name)){
		SendClientMessage(playerid,C_GREY,"Используйте: /getstats [ id игрока/никнейм ]");
		return true;
	}
	new temp_playerid;
	sscanf(temp_name,"u",temp_playerid);
	if(GetPVarInt(temp_playerid,"PlayerLogged")){
		showStats(playerid,temp_playerid);
	}
	else{
		new query[42-2+MAX_PLAYER_NAME];
		mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'limit 1",temp_name);		
		new Cache:cache_users=mysql_query(mysql_connection,query,true);
		if(cache_get_row_count(mysql_connection)){
			showStats(playerid,-1,cache_users);
		}
		else{
			SendClientMessage(playerid,C_RED,"[Информация] Аккаунт не найден в базе данных!");
			cache_delete(cache_users,mysql_connection);
		}
	}
	return true;
}

//////////////////////////////////////////////// Команды для тестов

#if defined SERVER_OPENBETATEST

CMD:tp(playerid){
	SetPlayerPos(playerid,-2976.382,472.039,998.251);
	return true;
}

CMD:payday_time(playerid){
	if(payday[playerid][taken]){
	    payday[playerid][taken]=false;
	}
	else{
	    payday[playerid][time]=PAYDAY_TIME;
	}
	payday[playerid][salary]+=random(5000);
	return true;
}

CMD:setmoney(playerid,params[]){
	if(sscanf(params,"i",params[0])){
	    SendClientMessage(playerid,-1,"OBT: /setmoney [ value ]");
	    return true;
	}
	player[playerid][money]+=params[0];
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,player[playerid][money]);
	return true;
}

CMD:giveadmin(playerid){
	new query[52-2+MAX_PLAYER_NAME];
	mysql_format(mysql_connection,query,sizeof(query),"select`commands`from`admins`where`name`='%e'limit 1",player[playerid][name]);
	new Cache:cache_admins=mysql_query(mysql_connection,query);
	if(cache_get_row_count(mysql_connection)){
	    SendClientMessage(playerid,-1,"OBT: У вас уже есть права администратора!");
	    SendClientMessage(playerid,-1,"OBT: Используйте /givecmd");
	}
	else{
	    mysql_format(mysql_connection,query,sizeof(query),"insert into`admins`(`name`)values('%e')",player[playerid][name]);
	    mysql_query(mysql_connection,query);
		admin[playerid][id]=cache_insert_id(mysql_connection);
	    SendClientMessage(playerid,-1,"OBT: Вам выданы права администратора!");
	    SendClientMessage(playerid,-1,"OBT: Используйте /givecmd");
	}
	cache_delete(cache_admins,mysql_connection);
	return true;
}

CMD:givecmd(playerid,params[]){
    if(!admin[playerid][id]){
	    SendClientMessage(playerid,-1,"OBT: Вы не администратор! (/giveadmin)");
	    return true;
	}
	if(sscanf(params,"i",params[0])){
	    SendClientMessage(playerid,-1,"OBT: /givecmd [ command id(/givecmd_id) ]");
	    return true;
	}
	new temp_access[8];
	temp_access=admin[playerid][commands][params[0]]?"забрали":"выдали";
	admin[playerid][commands][params[0]]=admin[playerid][commands][params[0]]?0:1;
	new string[31-2-2+8+sizeof(admin_commands)];
	format(string,sizeof(string),"OBT: Вы %s доступ к команде %s",temp_access,admin_commands[params[0]]);
	SendClientMessage(playerid,-1,string);
	return true;
}

CMD:givecmd_id(playerid){
	new temp_string[8-2-2+2+sizeof(admin_commands)];
	new string[sizeof(temp_string)*MAX_ADMIN_COMMANDS];
	for(new i=0; i<MAX_ADMIN_COMMANDS; i++){
	    format(temp_string,sizeof(temp_string),"[%i] %s\n",i,admin_commands[i]);
	    strcat(string,temp_string);
	}
	ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST,""BLUE"Команды администратора",string,"Закрыть","");
	return true;
}

#endif

CMD:attachobject(playerid,params[]){
	new temp_object_id,temp_slot_id,temp_bone_id;
	if(sscanf(params,"iii",temp_object_id,temp_slot_id,temp_bone_id)){
	    SendClientMessage(playerid,-1,"/attachobject [ object id ] [ slot id ] [ bone id ]");
	    return true;
	}
	if(IsPlayerAttachedObjectSlotUsed(playerid,temp_slot_id) || temp_slot_id < 0 || temp_slot_id > 9){
	    SendClientMessage(playerid,-1,"invalid slot id!");
	    return true;
	}
	if(temp_bone_id < 1 || temp_bone_id > 18){
	    SendClientMessage(playerid,-1,"invalid bone id!");
		return true;
	}
	SetPlayerAttachedObject(playerid,temp_slot_id,temp_object_id,temp_bone_id);
	return true;
}

CMD:removeobject(playerid,params[]){
	new temp_slot_id;
    if(sscanf(params,"i",temp_slot_id)){
	    SendClientMessage(playerid,-1,"/removeobject [ slot id ]");
	    return true;
	}
	if(!IsPlayerAttachedObjectSlotUsed(playerid,temp_slot_id) || temp_slot_id < 0 || temp_slot_id > 9){
	    SendClientMessage(playerid,-1,"invalid slot id!");
	    return true;
	}
	RemovePlayerAttachedObject(playerid,temp_slot_id);
	return true;
}

CMD:editobject(playerid,params[]){
	new temp_slot_id;
    if(sscanf(params,"i",temp_slot_id)){
	    SendClientMessage(playerid,-1,"/editobject [ slot id ]");
	    return true;
	}
    if(!IsPlayerAttachedObjectSlotUsed(playerid,temp_slot_id) || temp_slot_id < 0 || temp_slot_id > 9){
	    SendClientMessage(playerid,-1,"invalid slot id!");
	    return true;
	}
	EditAttachedObject(playerid,temp_slot_id);
	return true;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ){
	if(response){
		new temp[32];
		format(temp,sizeof(temp),"attachobject%i.ini",modelid);
		if(!fexist(temp)){
		    fopen(temp,io_write);
		}
	    new File:handle=fopen(temp,io_append);
	    new string[256];
	    format(string,sizeof(string),"%f,%f,%f,%f,%f,%f,%f,%f,%f\n",fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
	    fwrite(handle,string);
	    fclose(handle);
	}
	else{
        SetPlayerAttachedObject(playerid,index,modelid,boneid);
	}
	return true;
}

CMD:skin(playerid,params[]){
	new temp;
	if(sscanf(params,"i",temp)){
	    SendClientMessage(playerid,-1,"/skin [ skin id ]");
	    return true;
	}
	SetPlayerSkin(playerid,temp);
	return true;
}

CMD:specialaction(playerid){
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CARRY);
	return true;
}
/*
16  0.200000,0.027000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000 - каска
	0.165000,0.400000,-0.257999,0.000000,0.000000,0.000000,0.670000,0.606000,0.685000 - ящик
131 0.139999,0.027000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000 - каска
	0.279000,0.400000,-0.257999,0.000000,0.000000,0.000000,0.670000,0.606000,0.685000 - ящик
*/