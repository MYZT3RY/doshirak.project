
// Doshirak RP - D1maz. - vk.com/d1maz.community

/*      �������     */

#include <a_samp>
main();
#include <a_mysql>
#include <sscanf2>
#include <regex>
#include <crashdetect>
#include <streamer>
#include <doshirak\objects>//������� �������
#include <dc_cmd>
#include <foreach>
#include <doshirak\colors>//������� ������
#include <doshirak\3dtexts>//3� ������ �������
#include <doshirak\pickups>//������ �������
#include <a_actor>
#include <doshirak\fixes>//����� ��������� �������
//#include <doshirak\anim_cmd>

// �������

#define dc_cmd:%1(%2,%3) cmd_%1(%2,%3)

/*      �������     */

// ��������� ����������� � ��

#define MYSQL_HOST "localhost" // ������, � �������� ����� ������������
#define MYSQL_USER "root" // ������������, ��� ������� ����� ��������
#define MYSQL_DATABASE "doshirak" // ����, ������� �����������
#define MYSQL_PASSWORD "" // ������ �� ������������
new mysql_connection; // ������ �����������

// ������

#define SERVER_OBT

#undef MAX_PLAYERS // ������� ������
#define MAX_PLAYERS (1000) // ������ ������, ������ 1000
#define MAX_ENTRANCE (8) // ������������ ���������� ������
#undef MAX_ACTORS//������� ������
#define MAX_ACTORS (32)// ������ ������, ������ 32
#define MAX_HOUSES (128)//������������ ���������� �����
#define MAX_HOUSE_INTERIORS (8)//������������ ���������� ���������� ��� �����
#define MAX_FACTIONS (2)//������������ ���������� �������
#define MAX_ADMIN_COMMANDS (5)//������������ ���������� ������ ���������������
#define MAX_OWNED_HOUSES (4)//������������ ���������� �������� �����

#define SECONDS_IN_DAY (86400)//���������� ������ � ����� ���
#define SECONDS_IN_WEEK (SECONDS_IN_DAY*7)//���������� ������ � ����� ������
#define SECONDS_IN_MONTH (SECONDS_IN_DAY*30)//���������� ������ � ����� ������

#define MAX_PASSWORD_LEN (24) // ������������ ����� ������
#define MIN_PASSWORD_LEN (4) // ����������� ����� ������
#define MAX_EMAIL_LEN (32) // ������������ ����� �����
#define MIN_EMAIL_LEN (10) // ����������� ����� �����
#define MAX_PROMOCODE_LEN (32) // ������������ ����� ���������
#define MIN_PROMOCODE_LEN (4) // ����������� ����� ���������
#define MIN_PLAYER_NAME_LEN (3)//����������� ����� ����

#define PAYDAY_TIME (30*60) // �����, ����������� ��� ��������� ��������
#define NEEDED_EXPERIENCE (3) // ���������� �����, ����������� ��� ��������� ������
#define NEEDED_LEVEL_FOR_REFERAL_TO_TAKE_MONEY (3)// ������� ��� ��������, ����� �������� �����

#define DEVELOPER "Dmitriy_Yakimov"//������� �����������

/*      ����������  */

// �������� �� IP

new check_ip_for_reconnect[MAX_PLAYERS][16],//������� ���������� ���������� ��� ������ IP ������
	check_ip_for_reconnect_time[MAX_PLAYERS];//���������� ���������� ��� ������ �������
	
new owned_house_id[MAX_PLAYERS][MAX_OWNED_HOUSES];//����� �������� id �������� �����
	
// 3� ����� �� ���������

new Text3D:attach_3dtext_labelid[MAX_PLAYERS],//ID 3� ������
	bool:attached_3dtext[MAX_PLAYERS];//��� �������

// ��������

enum UINFO{
	id,// ����� ��������
	name[MAX_PLAYER_NAME],// �������
	email[MAX_EMAIL_LEN],// ����������� �����
	referal_name[MAX_PLAYER_NAME],//������� ��������
	age,//������� ���������
	origin,//���� ���������
	gender,//��� ���������
	character,//���� ���������
	level,// �������
	experience,// ����
	reg_ip[16],// ��������������� IP
	reg_date[32],// ���� �����������
	money,//������ ���������
	passport_id,//����� ��������
	description[64],//�����, ������� ����� ��������� �� ���������
	faction_id,//����� �������
	rank_id//������ �����
}

new player[MAX_PLAYERS][UINFO];

// �������

enum dialogs{
	NULL,// ������� ������
	dRegistration=1,// ������ �����������
	dRegistrationEmail,//������ ����� ����������� �����
	dRegistrationReferal,//������ ����� ��������
	dRegistrationAge,//������ ����� �������� ���������
	dRegistrationOrigin,//������ ������ ���� ���������
	dRegistrationGender,//������ ������ ���� ���������
	dAuthorization,//������ �����������
	dMainMenu,//������ �������� ����
	dMainMenuReferalSystem,//���� ����������� �������
	dMainMenuReferalSystemInfo,//���������� � ����������� �������
	dMainMenuReferalSystemDelete,//�������� ���������
	dMainMenuReferalSystemCreate,//�������� ���������
	dMainMenuReferalSystemCrLevel,//���� ������ ��� ���������
	dMainMenuReferalSystemCrMoney,//���� ������ ��� ��������� - ������
	dMainMenuReferalSystemCrExp,//����� ������ ��� ��������� - ����
	dMainMenuReferalSystemCrConfirm,//������������� �������� ���������
	dMainMenuInfAboutPers,//���� ���������� � ���������
	dMainMenuInfAboutPersCharacter,//���������� ���������
	dMainMenuInfAboutPersAccount,//���������� ��������
	dMainMenuInfAboutBankAccounts,//�������� ������� ���������� ������
	dMainMenuHelp,
	dMainMenuHelpCommands,
	dMainMenuHelpCommandsChat,
	dMainMenuHelpCommandsFaction,
	dBankCreateAccount,//�������� ����������� �����
	dBankCreateAccountDescription,//�������� ��� ����������� �����
	dBankCreateAccountPassword,//������ ��� ����������� �����
	dBankCreateAccountConfirm,//������������� �������� ����������� �����
	dBankCreateAccountSignConfirm,
	dBankAccountInput,//���� ������ ����������� �����
	dBankAccountPassword,//���� ������ ����������� �����
	dBankAccountMenu,//���� ����������� ����� ����� �����������
	dBankAccountMenuInf,//���������� � �����
	dBankAccountMenuTransfer,//������� ����� �� ������ ����
	dBankAccountMenuTransferConfirm,//������������� �������� ����� �� ������ ����
	dBankAccountMenuWithdraw,//������ ����� �� �����
	dBankAccountMenuDeposit,//���������� �����
	dBankAccountMenuTransactions,//���������� � ����������� ����������� �����
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
	dApanelPropertyConfirmMenu
}

enum transactionsType{
	FROM_ACCOUNT_TO_ACCOUNT=1,//������� �� ����� �� ����
	WITHDRAW_FROM_ACCOUNT,//������ ����� �� �����
	DEPOSIT_TO_ACCOUNT//���������� �����
}

enum actorINFO{
	id,//���������� ����� ����� � ��
	description[32],//�������� �����
	character,//���� �����
	Float:pos_x,//������� ����� - �
	Float:pos_y,//������� ����� - y
	Float:pos_z,//������� ����� - z
	Float:pos_a,//���� �������� �����
	virtualworld,//����������� ��� �����
	interior,//�������� �����
	animlib[32],//���������� ��������
	animname[32],//�������� ��������
	Float:delta,
	loop,
	lockx,
	locky,
	freeze,
	time,
	Text3D:labelid,//ID 3� ������
	createid//ID ���������� �����
}

new actor[MAX_ACTORS][actorINFO];
new total_actors;//����� ���������� ������

enum houseINFO{
	id,
	owner[MAX_PLAYER_NAME],
	Float:enter_x,
	Float:enter_y,
	Float:enter_z,
	Float:enter_a,
	house_interior,
	lock,
	cost,
	class,
	confirmed,
	pickupid,
	Text3D:labelid
}

new house[MAX_HOUSES][houseINFO];
new total_houses;//����� ���������� ��������� �����

enum house_interiorsINFO{
	id,
	description[32],
	Float:pos_x,
	Float:pos_y,
	Float:pos_z,
	Float:pos_a,
	interior,
	price
}

new house_interiors[MAX_HOUSE_INTERIORS][house_interiorsINFO];
new total_house_interiors;

// ������

new origins[5][24]={
	"NULL","������������","����������","������������","��������������"
};// ���� ����������

new characters[5][3][16]={
	{{NULL},{NULL},{NULL}},// ������� ������
	{{NULL},{6,23,26,32,46,82,101,188,259,299,20,29,45,184},{12,31,41,55,88,91,233}},// ������������ �������/�������
	{{NULL},{83,183,221,7,14,21,4,76},{9,40,211,215}},// ���������� �������/�������
	{{NULL},{229,44,58,170,210,229},{56,141,193,224,225}},// ������������ �������/�������
	{{NULL},{26,32,37,46,82,94,101,188,242,259,299,20,29,72,97,184},{12,41,55,91,191,233}}// �������������� �������/�������
};// ����� ����������

enum paydayINFO{
	time,//�����
	salary,//��������
	bool:taken//��������, �������� �� ��������
}

new payday[MAX_PLAYERS][paydayINFO];

enum entranceINFO{
	id,//���������� ����� �����
	description[64],//��������
	locked,//������ �����
	Float:enter_x,//���������� ����� - �
	Float:enter_y,//���������� ����� - y
	Float:enter_z,//���������� ����� - z
	Float:enter_a,//���� �������� ��������� ��� ������
	Float:exit_x,//���������� ������ - �
	Float:exit_y,//���������� ������ - y
	Float:exit_z,//���������� ������ - z
	Float:exit_a,//���� �������� ��������� ��� �����
	interior,//��������
	virtualworld,//����������� ���
	pickupid[2],//ID �������
	Text3D:labelid[2]//ID 3� �������
}

new entrance[MAX_ENTRANCE][entranceINFO];
new total_entrance;//����� ���������� ��������� ������

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
	skin[11],
	leader[MAX_PLAYER_NAME],
	sub_leader[MAX_PLAYER_NAME],
	pickupid,
}

new faction[MAX_FACTIONS][factionINFO];
new total_factions;
new faction_ranks[MAX_FACTIONS][11][24];

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
	APANEL
}

static const admin_commands[MAX_ADMIN_COMMANDS][24]={
	"/admins","/makeleader","/achat","/find","/apanel"
};

/*      ��������    */

public OnGameModeInit(){// ��������� ������� ���
	mysql_connection=mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DATABASE,MYSQL_PASSWORD);// ����������� � ���� ������
	switch(mysql_errno(mysql_connection)){// ��������� ����������� �� ������
	    case 0:{//���� ����������� ��� ������
	        print(""MYSQL_DATABASE": ����������� � '"MYSQL_HOST"' - �������");
	    }
	    default:{// ���� ���� ������ � ������������
	        printf(""MYSQL_DATABASE": ������ ����������� � '"MYSQL_HOST"' (#%i)",mysql_errno(mysql_connection));// ������� ��������� �� ������ � � �����
	        return true;// ������� �� �������
	    }
	}
	DisableInteriorEnterExits();//���������� ����������� �������
	mysql_log(LOG_DEBUG);//�������� ����� �����
	mysql_set_charset("cp1251",mysql_connection);
	new Cache:cache_general=mysql_query(mysql_connection,"select*from`general`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    print(""MYSQL_DATABASE": �������� ������ �� ������� `general`");
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
	    printf(""MYSQL_DATABASE": ������ �� ������� `general` ��������� �� %ims",GetTickCount()-temp_time);
	}
	else{
	    print(""MYSQL_DATABASE": ������ � ������� `general` �� �������!");
	}
	cache_delete(cache_general,mysql_connection);
	new Cache:cache_entrance=mysql_query(mysql_connection,"select*from`entrance`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>=MAX_ENTRANCE){
	        printf(""MYSQL_DATABASE": � ������� `entrance` ������ �������� ��� � ��������� (%i/%i)",cache_get_row_count(mysql_connection),MAX_ENTRANCE);
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
	            printf(""MYSQL_DATABASE": `id` = '%i' ����� ����������� ����������: x%f|y%f|z%f|x%f|y%f|z%f",i+1,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z]);
	        }
	        else{
	            entrance[i][pickupid][0]=CreateDynamicPickup(1318,23,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],0,0);
	            entrance[i][pickupid][1]=CreateDynamicPickup(1318,23,entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z],entrance[i][virtualworld],entrance[i][interior]);
	            new temp_enter[64];
	            format(temp_enter,sizeof(temp_enter),"%s\n%s",entrance[i][description],entrance[i][locked]?""RED"�������":""GREEN"�������");
	            entrance[i][labelid][0]=CreateDynamic3DTextLabel(temp_enter,0xFFFFFFFF,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
	            entrance[i][labelid][1]=CreateDynamic3DTextLabel("�����",0xFFFFFFFF,entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,entrance[i][virtualworld],entrance[i][interior]);
				total_entrance++;
	        }
	    }
	    printf(""MYSQL_DATABASE": ������ �� ������� `entrance` ��������� �� %ims (%i ��)",GetTickCount()-temp_time,total_entrance);
	}
	else{
	    print(""MYSQL_DATABASE": ������ � ������� `entrance` �� �������!");
	}
	cache_delete(cache_entrance,mysql_connection);
	new Cache:cache_actors=mysql_query(mysql_connection,"select*from`actors`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>=MAX_ACTORS){
	        printf(""MYSQL_DATABASE": � ������� `actors` ������ �������� ��� � ��������� (%i/%i)",cache_get_row_count(mysql_connection),MAX_ENTRANCE);
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
	            printf(""MYSQL_DATABASE": `id` = '%i' ����� ������������ ����������: x%f|y%f|z%f|a%f",i+1,actor[i][pos_x],actor[i][pos_y],actor[i][pos_z],actor[i][pos_a]);
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
	    printf(""MYSQL_DATABASE": ������ �� ������� `actors` ��������� �� %ims (%i ��)",GetTickCount()-temp_time,total_actors);
	}
	else{
	    print(""MYSQL_DATABASE": ������ � ������� `actors` �� �������!");
	}
	cache_delete(cache_actors,mysql_connection);
	new Cache:cache_house_interiors=mysql_query(mysql_connection,"select*from`house_interiors`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_HOUSE_INTERIORS){
	        printf(""MYSQL_DATABASE": � ������� `house_interiors` ������ �������� ��� � ��������� (%i/%i)",cache_get_row_count(mysql_connection),MAX_HOUSE_INTERIORS);
		}
		for(new i=0; i<cache_get_row_count(mysql_connection); i++){
		    house_interiors[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
		    cache_get_field_content(i,"description",house_interiors[i][description],mysql_connection,32);
		    new temp_pos[64];
		    cache_get_field_content(i,"pos",temp_pos,mysql_connection,sizeof(temp_pos));
			sscanf(temp_pos,"p<|>ffff",house_interiors[i][pos_x],house_interiors[i][pos_y],house_interiors[i][pos_z],house_interiors[i][pos_a]);
			house_interiors[i][interior]=cache_get_field_content_int(i,"interior",mysql_connection);
			house_interiors[i][price]=cache_get_field_content_int(i,"price",mysql_connection);
			total_house_interiors++;
		}
		printf(""MYSQL_DATABASE": ������ �� ������� `house_interiors` ��������� �� %ims (%i ��)",GetTickCount()-temp_time,total_house_interiors);
	}
    else{
        print(""MYSQL_DATABASE": ������ � ������� `house_interiors` �� �������!");
    }
    cache_delete(cache_house_interiors,mysql_connection);
	new Cache:cache_houses=mysql_query(mysql_connection,"select*from`houses`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>=MAX_HOUSES){
            printf(""MYSQL_DATABASE": � ������� `houses` ������ �������� ��� � ��������� (%i/%i)",cache_get_row_count(mysql_connection),MAX_HOUSES);
	    }
	    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
	        house[i][id]=cache_get_field_content_int(i,"id",mysql_connection);
	        cache_get_field_content(i,"owner",house[i][owner],mysql_connection,MAX_PLAYER_NAME);
	        new temp_pos[64];
	        cache_get_field_content(i,"enter_pos",temp_pos,mysql_connection,sizeof(temp_pos));
	        sscanf(temp_pos,"p<|>ffff",house[i][enter_x],house[i][enter_y],house[i][enter_z],house[i][enter_a]);
	        house[i][house_interior]=cache_get_field_content_int(i,"house_interior",mysql_connection);
	        house[i][lock]=cache_get_field_content_int(i,"lock",mysql_connection);
	        house[i][cost]=cache_get_field_content_int(i,"cost",mysql_connection);
	        if(!house[i][enter_x]||!house[i][enter_y]||!house[i][enter_z]||!house[i][house_interior]){
                printf(""MYSQL_DATABASE": `id` = '%i' ����� ������������ ����������: x%f|y%f|z%f|hi%i",i+1,house[i][enter_x],house[i][enter_y],house[i][enter_z],house[i][house_interior]);
	        }
	        else{
				new string[16-2+11];
				format(string,sizeof(string),"����� ���� - %i",house[i][id]);
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
	    printf(""MYSQL_DATABASE": ������ �� ������� `houses` ��������� �� %ims (%i ��)",GetTickCount()-temp_time,total_houses);
	}
	else{
	    print(""MYSQL_DATABASE": ������ � ������� `houses` �� �������!");
	}
	cache_delete(cache_houses,mysql_connection);
	new Cache:cache_factions=mysql_query(mysql_connection,"select*from`factions`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    if(cache_get_row_count(mysql_connection)>MAX_FACTIONS){
            printf(""MYSQL_DATABASE": � ������� `factions` ������ �������� ��� � ��������� (%i/%i)",cache_get_row_count(mysql_connection),MAX_FACTIONS);
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
	        new temp_rank[274];
	        cache_get_field_content(i,"rank",temp_rank,mysql_connection,sizeof(temp_rank));
	        sscanf(temp_rank,"p<|>a<s[24]>[11]",faction_ranks[i]);
	        cache_get_field_content(i,"leader",faction[i][leader],mysql_connection,MAX_PLAYER_NAME);
	        cache_get_field_content(i,"sub_leader",faction[i][sub_leader],mysql_connection,MAX_PLAYER_NAME);
			if(!faction[i][spawn_x] || !faction[i][spawn_y] || !faction[i][spawn_z] || !faction[i][spawn_a]){
                printf(""MYSQL_DATABASE": `id` = '%i' ����� ������������ ����������: x%f|y%f|z%f|a%f",i+1,faction[i][spawn_x],faction[i][spawn_y],faction[i][spawn_z],faction[i][spawn_a]);
			}
			else{
			    if(!faction[i][clothes_x] || !faction[i][clothes_y] || !faction[i][clothes_z]){
                    printf(""MYSQL_DATABASE": `id` = '%i' ����� ������������ ����������: x%f|y%f|z%f",i+1,faction[i][clothes_x],faction[i][clothes_y],faction[i][clothes_z]);
			    }
			    else{
			        new temp_var;
			        for(new j=0; j<11; j++){
			            if(!faction[i][skin][j] || faction[i][skin][j]>311){
							printf(""MYSQL_DATABASE": `id` = '%i' ����� ������������ ��������: 0-%i|1-%i|2-%i|3-%i|4-%i|5-%i|6-%i|7-%i|8-%i|9-%i|10-%i",i+1,faction[i][skin][0],faction[i][skin][1],faction[i][skin][2],faction[i][skin][3],faction[i][skin][4],faction[i][skin][5],faction[i][skin][6],faction[i][skin][7],faction[i][skin][8],faction[i][skin][9],faction[i][skin][10]);
							temp_var++;
							break;
			            }
			        }
			        if(!temp_var){
						faction[i][pickupid]=CreateDynamicPickup(1275,23,faction[i][clothes_x],faction[i][clothes_y],faction[i][clothes_z],faction[i][virtualworld],faction[i][interior]);
				        total_factions++;
			        }
			    }
			}
	    }
        printf(""MYSQL_DATABASE": ������ �� ������� `factions` ��������� �� %ims (%i ��)",GetTickCount()-temp_time,total_factions);
	}
	else{
	    print(""MYSQL_DATABASE": ������ � ������� `factions` �� �������!");
	}
	cache_delete(cache_factions,mysql_connection);
	SetGameModeText("Doshirak v0.002");//������ �������� ���� ��� �������
	SendRconCommand("hostname Doshirak Role Play - 0.3.7");//������ �������� ������� ��� ������� ����� RCON
	SetTimer("@__general_timer",1000,false);
	LoadObjects();
	Load3DTexts();
	LoadPickups();
	return true;
}

public OnPlayerConnect(playerid){// ������������ � �������
	new temp_ip[16];//������ ���������� ��� ������ IP ������
	GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));//���������� IP ����� � ����������
	for(new i=0; i!=MAX_PLAYERS; i++){//�������� �� ����� �������, ����� 1000 ��������
		if(!strcmp(check_ip_for_reconnect[i],temp_ip)){//���� ���� �� �������� � ���������� ������� � ���������� ����������
		    if(gettime()-check_ip_for_reconnect_time[i]<20){//� ���� ���������� ����� ��������� ������ 20-��, ��...
		        SendClientMessage(playerid,C_RED,"[����������] �� ���� ������� ��������! �������: Anti Reconnect");
		        SetTimerEx("@__kick_player",250,false,"i",playerid);//������ ������
		        break;//������� �� �������
		    }
		}
	}
	SetPVarInt(playerid,"PasswordAttempts",3);
	GetPlayerIp(playerid,check_ip_for_reconnect[playerid],16);//���������� IP ����� � ���������� ����������
	GetPlayerName(playerid,player[playerid][name],MAX_PLAYER_NAME);//������� ������� ������ � ����������33
	new query[36-2+MAX_PLAYER_NAME];// ��������� ���������� ��� �������
	mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",player[playerid][name]);// ����������� "����������" ������ � ���� ������
	new Cache:cache_users=mysql_query(mysql_connection,query);// ���������� ������ � ���� ������
	new temp_hour;
	gettime(temp_hour,_,_);
	new temp_type_of_day[13];
	switch(temp_hour){
	    case 23,0..5:{
	        temp_type_of_day="������ ����";
	    }
	    case 6..11:{
	        temp_type_of_day="������ ����";
	    }
	    case 12..17:{
	        temp_type_of_day="������ ����";
	    }
	    case 18..22:{
	        temp_type_of_day="������ �����";
	    }
	}
	new string[125-2-2+MAX_PLAYER_NAME+sizeof(temp_type_of_day)];
	if(cache_get_row_count(mysql_connection)){// ���� � ���� ���� ������ ���� ����� � ���������� ���������
		format(string,sizeof(string),"\n"WHITE"%s, "BLUE"%s\n\n"WHITE"����� ���������� �� "BLUE"Doshirak RP!"WHITE"\n��� ���������� ��������������!\n\n",temp_type_of_day,player[playerid][name]);//����������� �����
		ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");
	}
	else{// ���� � ���� ��� �� ������ ���� � ���������
	    format(string,sizeof(string),"\n"WHITE"%s, "BLUE"%s\n\n"WHITE"����� ���������� �� "BLUE"Doshirak RP!"WHITE"\n��� ���������� ������������������!\n\n",temp_type_of_day,player[playerid][name]);
	    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");
	}
	cache_delete(cache_users,mysql_connection);
	RemovePlayerObjects(playerid);//������� ������� ��� ������ (doshirak\objects)
	TogglePlayerSpectating(playerid,true);//��������� ������ � ����� ��������
	return true;
}

public OnPlayerDisconnect(playerid,reason){
	#pragma unused reason
	if(GetPVarInt(playerid,"PlayerLogged")){
		new temp_payday[24];
		format(temp_payday,sizeof(temp_payday),"%i|%i|%i",payday[playerid][time],payday[playerid][salary],payday[playerid][taken]);
	    new query[96-2-2-2-2-2-2-2-2+16+16+sizeof(temp_payday)+11];
	    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`payday`='%e'where`id`='%i'",temp_payday,player[playerid][id]);
	    mysql_query(mysql_connection,query);
	    if(attached_3dtext[playerid]){
	        Delete3DTextLabel(attach_3dtext_labelid[playerid]);
	        attached_3dtext[playerid]=false;
	    }
	    player[playerid][id]=0;
		player[playerid][name][0]=EOS;
		player[playerid][email][0]=EOS;
		player[playerid][referal_name][0]=EOS;
		player[playerid][age]=0;
		player[playerid][origin]=0;
		player[playerid][gender]=0;
		player[playerid][character]=0;
		player[playerid][level]=0;
		player[playerid][experience]=0;
		player[playerid][reg_ip][0]=EOS;
		player[playerid][reg_date][0]=EOS;
		player[playerid][money]=0;
		player[playerid][passport_id]=0;
		player[playerid][description][0]=EOS;
		player[playerid][faction_id]=0;
		player[playerid][rank_id]=0;
		payday[playerid][time]=0;
		payday[playerid][salary]=0;
		payday[playerid][taken]=false;
		for(new i=0; i<MAX_OWNED_HOUSES; i++){
		    owned_house_id[playerid][i]=0;
		}
	}
	check_ip_for_reconnect_time[playerid]=gettime();//���������� ����� ������ � ������� (�������� ������!)
	return true;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	while(strfind(inputtext,"%s",true)!=-1){//���� � ������ ��������� �������������, ����������� ����
		strdel(inputtext,strfind(inputtext,"%s",true),strfind(inputtext,"%s",true)+2);//���� ������ �������������, �� ������� ���
	}
	switch(dialogid){//��������� �������� ��� ������ � ���������(��������) ��������
	    case dRegistration:{//���� dialogid ����� �������, �� ��������� � ����
	        if(response){// ���� ����� ������� ����� ������(����� ������ �������), ��
				new sscanf_password[MAX_PASSWORD_LEN]/*���������� ��� ������ ������*/, string[122-2+MAX_PLAYER_NAME+77]/*���������� ��� �������������� ������*/;// ��������� ����������
    			format(string,sizeof(string),"\n"WHITE"����� ���������� �� "BLUE"Doshirak RP!"WHITE"\n��� ���������� ������������������!\n��� �����: "BLUE"%s\n\n",player[playerid][name]);// ����������� �����
				if(sscanf(inputtext,"s[128]",sscanf_password)){// ���� ��� ������ ����� ����, �� ������� ������ � ����
				    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");// ���������� ������ � ����� ��������������� �������
				    return true;// ������� �� �������
				}
				new strlen_text=sizeof(string);// ����� ���������� �������� � ����� ��������������� ������
				if(strlen(sscanf_password)<MIN_PASSWORD_LEN || strlen(sscanf_password)>MAX_PASSWORD_LEN){// ���� ������ ������ ��������� �������� ��� ������ ��������� ��������, �� ������� ������ � ����
					strcat(string,""RED"����� ������ ����� ���� �� ������ 4-� � �� ������ 24-� ��������!\n\n");// ��������� �������������� ����� � ���������������
				    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");// ���������� ������ � ���������� �������
				    strdel(string,strlen_text,sizeof(string));// ������� �����, ������� ����� ��������� � ���������������
				    return true;// ������� �� �������
				}
                if(!regex_match(sscanf_password,"[a-zA-Z0-9]+")){//���� ������������ �������� ����������� ��������� ����� ����� ����(���), �� ������� ������ � ����
                    strcat(string,""RED"� ������ ������������ ������������ �������!\n\n");// ��������� �������������� ����� � ���������������
                    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");// ���������� ������ � ���������� �������
                    strdel(string,strlen_text,sizeof(string));// ������� �����, ������� ����� ��������� � ���������������
                    return true;// ������� �� �������
                }
                new query[69-2-2+MAX_PLAYER_NAME+MAX_PASSWORD_LEN+16];// ��������� ���������� ��� ����������� ������� � ���� ������
                new temp_ip[16];
			    GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
                mysql_format(mysql_connection,query,sizeof(query),"insert into`users`(`name`,`password`,`reg_ip`)values('%e','%e','%e')",player[playerid][name],sscanf_password,temp_ip);// ����������� "����������" ������ �������� ������ � ���� ������
                mysql_query(mysql_connection,query);// ���������� ������ � ���� ������
				player[playerid][id]=cache_insert_id(mysql_connection);//������ �������� ���� ����������� �� ���� ������ � ���������� ������
				ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n","������","����������");// ���������� ������ ����� ����������� �����
				SendClientMessage(playerid,C_BLUE,"[����������] ��� ������� ����� � ���� ������ �������!");//������� ��������� �� �������� �������� ��������
	        }
	        else{// ���� ����� ������� ����� ���(������ ������ �������), ��
				SendClientMessage(playerid,C_RED,"[����������] �� ���������� �� ����������� � ���� �������!");// ������� ��������� � ���
				SetTimerEx("@__kick_player",250,false,"i",playerid);// ����������� ������ � ������� ��� ��������
	        }
	    }
	    case dRegistrationEmail:{//���� dialogid ����� ������, �� ��������� � ����
	        if(response){//���� ����� �� ������� ����� ������� (����� ������), ��...
	            new sscanf_email[MAX_EMAIL_LEN];//��������� ���������� ��� ������ ��. �����
				if(sscanf(inputtext,"s[128]",sscanf_email)){//���� ���� ����� ��������� ������, ��...
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n","������","����������");
				    return true;//������� �� �������
				}
				if(strlen(sscanf_email)<MIN_EMAIL_LEN || strlen(sscanf_email)>MAX_EMAIL_LEN){//���� ����� ������ ������ n, � ������ n, ��...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n"RED"����� ������ ����������� ����� ����� �� ������ 4-� � �� ������ 32-� ��������!","������","����������");
				    return true;//������� �� �������
				}
				if(!regex_match(sscanf_email,"[a-zA-Z0-9_\\.-]+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z]{2,4}")){//���� ������������ �������� ����������� ��������� ����� ����� ����(���), �� ������� ������ � ����
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n"RED"� ������ ����������� ����� ������� ������������ �������!","������","����������");
				    return true;//������� �� �������
				}
				new query[35-2-2+MAX_EMAIL_LEN+11];//��������� ���������� ��� ������ ������� � ��
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`email`='%e'",sscanf_email);//����������� ������ � ������������ ������
				new Cache:cache_users=mysql_query(mysql_connection,query);// ���������� ������ � ��
				if(cache_get_row_count(mysql_connection)){// ���� ����� ����� �������, ���� ������, ��...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n"RED"��������� ����������� ����� ��� ��������������� � �������!","������","����������");
					//���������� ��� �� ������
				}
				else{//���� ����� ����� ���, ���� ����, ��...
				    strins(player[playerid][email],sscanf_email,0,sizeof(sscanf_email));//���������� ��������� ���� ����� � ����������
				    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`email`='%e'where`id`='%i'",player[playerid][email],player[playerid][id]);//����������� ������ � ����������� ������
					mysql_query(mysql_connection,query);//���������� ������
                    ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n","������","����������");
					//���������� ������ � ������ ������/���������
				}
				cache_delete(cache_users,mysql_connection);
	        }
	        else{//���� ����� ������� ����� ��� (������ ������), ��...
	            ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n","������","����������");
                //���������� ������ � ������ ������/���������
	        }
	    }
		case dRegistrationReferal:{// ���� dialogid ����� ������, ��...
		    if(response){//���� ����� ������� ����� ������ (����� ������), ��...
		        new sscanf_referal_name[MAX_PROMOCODE_LEN];//��������� ���������� ��� ������ ������/���������
		        if(sscanf(inputtext,"s[128]",sscanf_referal_name)){//���� ���� ����� ��������� ������, ��...
		            ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n","������","����������");
		            return true;//������� �� �������
		        }
				new query[53-2+MAX_PROMOCODE_LEN];//��������� ���������� ��� �������������� �������
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",sscanf_referal_name);//����������� ������ � ������������ ������
				new Cache:cache_users=mysql_query(mysql_connection,query);//���������� ������ � ��
				if(cache_get_row_count(mysql_connection)){// ���� ����� ����� �������, ���� ������, ��...
				    new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'and`reg_ip`='%e'",sscanf_referal_name,temp_ip);
					new Cache:cache__users=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n","������","����������");
						SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������� ���� �������!");
					    return true;
					}
					cache_delete(cache__users,mysql_connection);
				    strins(player[playerid][referal_name],sscanf_referal_name,0);//���������� �������� ���� ����� � ����������
				    SendClientMessage(playerid,C_BLUE,"[����������] �� ���� ���������� ������� �� ��������!");//������� ��������� � ������� � ���� ������
                    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ���������� ������� ������� ������ ���������\n"BLUE"������: (16 - 60)\n\n","������","�����");
					//������� ������ � ������ �������� ���������
				}
				else{//���� ����� ����� ���, ��...
				    mysql_format(mysql_connection,query,sizeof(query),"select`creator`from`promocodes`where`promocode`='%e'",sscanf_referal_name);//����������� ������ � ������������ ������
				    new Cache:cache_promocodes=mysql_query(mysql_connection,query);// ���������� ������
				    if(cache_get_row_count(mysql_connection)){// ���� ����� ����� �������, ���� ������, ��...
				        new temp_ip[16],temp_name[MAX_PLAYER_NAME];
						GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
				        cache_get_field_content(0,"name",temp_name,mysql_connection,sizeof(temp_name));
				        mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'and`reg_ip`='%e'",temp_name,temp_ip);
				        mysql_query(mysql_connection,query);
				        if(cache_get_row_count(mysql_connection)){
				            ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n","������","����������");
							SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������� ���� ��������!");
						    return true;
				        }
				        if(!regex_match(sscanf_referal_name,"[a-zA-Z0-9_#@!-]+") || strlen(sscanf_referal_name)<MIN_PROMOCODE_LEN || strlen(sscanf_referal_name)>MAX_PROMOCODE_LEN){
				            //���� ������������ �������� ����������� ��������� ����� ����� ����(���), �� ������� ������ � ���� ��� ����� ������ ������ n ��� ����� ������ ������ n
	                        ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n"RED"� �������� ��������� ������� ������������ �������!\n\n","������","����������");
		          		    return true;//������� �� �������
		          		}
						strins(player[playerid][referal_name],sscanf_referal_name,0);//���������� �������� ���� ����� � ����������
						SendClientMessage(playerid,C_BLUE,"[����������] �� ���� ���������� ������� �� ���������!");//������� ��������� � ������� � ���� ������
						ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ���������� ������� ������� ������ ���������\n"BLUE"������: (16 - 60)\n\n","������","�����");
						//������� ������ � ������ �������� ���������
				    }
				    else{//���� ����� ����� ���, ��...
				        //���������� ��� �� ������
                        ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n"RED"��������� �������/�������� �� ������!\n\n","������","����������");
                        return true;//������� �� �������
				    }
				    cache_delete(cache_promocodes,mysql_connection);
				}
				cache_delete(cache_users,mysql_connection);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`referal_name`='%e'where`id`='%i'",player[playerid][referal_name],player[playerid][id]);//����������� ������ � ����������� �����
				mysql_query(mysql_connection,query);//���������� ������
		    }
		    else{//���� ����� ������� ����� ��� (������ ������), ��...
                ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ���������� ������� ������� ������ ���������\n"BLUE"������: (16 - 60)\n\n","������","�����");
		    }
		}
		case dRegistrationAge:{
		    if(response){
		        new sscanf_age;
		        if(sscanf(inputtext,"i",sscanf_age)){
		            ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ���������� ������� ������� ������ ���������\n"BLUE"������: (16 - 60)\n\n","������","�����");
		            return true;
		        }
				if(sscanf_age<16 || sscanf_age>60){
				    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ���������� ������� ������� ������ ���������\n"RED"������: (16 - 60)\n\n","������","�����");
				    return true;
				}
				player[playerid][age]=sscanf_age;
				new query[41-2-2+3+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`age`='%i'where`id`='%i'",player[playerid][age],player[playerid][id]);
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,dRegistrationOrigin,DIALOG_STYLE_TABLIST_HEADERS,"�����������",""BLUE"�������� ���� ������ ���������:"WHITE"\n[0] ������������\n[1] ����������\n[2] ������������\n[3] ��������������","������","�����");
		    }
		    else{
		        SendClientMessage(playerid,C_RED,"[����������] �� ���������� �� ����������� � ���� �������!");// ������� ��������� � ���
				SetTimerEx("@__kick_player",250,false,"i",playerid);// ����������� ������ � ������� ��� ��������
		    }
		}
		case dRegistrationOrigin:{
		    if(response){
				player[playerid][origin]=listitem+1;
				player[playerid][level]=1;
				new string[34-2+24];
				format(string,sizeof(string),"[����������] �� ������� ���� - %s",origins[player[playerid][origin]]);
				SendClientMessage(playerid,C_BLUE,string);
				new query[44-2-2+1+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`origin`='%i'where`id`='%i'",player[playerid][origin],player[playerid][id]);
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,dRegistrationGender,DIALOG_STYLE_MSGBOX,"�����������","\n"WHITE"�������� ��� ������ ���������\n\n","�������","�������");
		    }
		    else{
                SendClientMessage(playerid,C_RED,"[����������] �� ���������� �� ����������� � ���� �������!");// ������� ��������� � ���
				SetTimerEx("@__kick_player",250,false,"i",playerid);// ����������� ������ � ������� ��� ��������
		    }
		}
		case dRegistrationGender:{
		    player[playerid][gender]=response?1:2;
		    TogglePlayerSpectating(playerid,false);
		    SetPVarInt(playerid,"PlayerChoiceCharacter",1);
		    SetPVarInt(playerid,"PlayerChoiceCharacterNumber",1);
		    new query[44-2-2+1+11];
			mysql_format(mysql_connection,query,sizeof(query),"update`users`set`gender`='%i'where`id`='%i'",player[playerid][gender],player[playerid][id]);
			mysql_query(mysql_connection,query);
			mysql_format(mysql_connection,query,sizeof(query),"select`reg_date`from`users`where`id`='%i'",player[playerid][id]);
			new Cache:cache_users=mysql_query(mysql_connection,query);
			cache_get_field_content(0,"reg_date",player[playerid][reg_date],mysql_connection,20);
			cache_delete(cache_users,mysql_connection);
		    SendClientMessage(playerid,-1,"[����������] ��� ������ ����� ����� ����������� ������� "BLUE"(NUM4) "WHITE"� "BLUE"(NUM6)");
		    SendClientMessage(playerid,-1,"[����������] ����� ��������� ��������� ����, ����������� ������� "BLUE"(SPACE)");
			SetSpawnInfo(playerid,0,player[playerid][character]=characters[player[playerid][origin]][player[playerid][gender]][GetPVarInt(playerid,"PlayerChoiceCharacterNumber")],0.0,0.0,0.0,0.0,0,0,0,0,0,0);
			SpawnPlayer(playerid);
		}
		case dAuthorization:{
		    if(response){
		        new sscanf_password[MAX_PASSWORD_LEN], string[118-2+MAX_PLAYER_NAME+77];
                format(string,sizeof(string),"\n"WHITE"����� ���������� �� "BLUE"Doshirak RP!"WHITE"\n��� ���������� ��������������!\n��� �����: "BLUE"%s\n\n",player[playerid][name]);
                if(sscanf(inputtext,"s[128]",sscanf_password)){
                    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");
                    return true;
                }
                new strlen_text=sizeof(string);// ����� ���������� �������� � ����� ��������������� ������
				if(strlen(sscanf_password)<MIN_PASSWORD_LEN || strlen(sscanf_password)>MAX_PASSWORD_LEN){// ���� ������ ������ ��������� �������� ��� ������ ��������� ��������, �� ������� ������ � ����
					strcat(string,""RED"����� ������ ����� ���� �� ������ 4-� � �� ������ 24-� ��������!\n\n");// ��������� �������������� ����� � ���������������
				    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");// ���������� ������ � ���������� �������
				    strdel(string,strlen_text,sizeof(string));// ������� �����, ������� ����� ��������� � ���������������
				    return true;// ������� �� �������
				}
                if(!regex_match(sscanf_password,"[a-zA-Z0-9]+")){//���� ������������ �������� ����������� ��������� ����� ����� ����(���), �� �������� ������ � ����
                    strcat(string,""RED"� ������ ������������ ������������ �������!\n\n");// ��������� �������������� ����� � ���������������
                    ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");// ���������� ������ � ���������� �������
                    strdel(string,strlen_text,sizeof(string));// ������� �����, ������� ����� ��������� � ���������������
                    return true;// ������� �� �������
                }
				new query[53-2-2+MAX_PLAYER_NAME+MAX_PASSWORD_LEN];
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`password`='%e'and`name`='%e'",sscanf_password,player[playerid][name]);
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
					SendClientMessage(playerid,C_GREEN,"�� ������� ��������������!");
					mysql_format(mysql_connection,query,sizeof(query),"select`id`from`houses`where`owner`='%e'",player[playerid][name]);
					new Cache:cache_houses=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    new temp_id;
					    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
					        temp_id=cache_get_field_content_int(i,"id",mysql_connection);
					        owned_house_id[playerid][i]=temp_id;
					        new stringg[12];
					        format(stringg,sizeof(stringg),"%i",owned_house_id[playerid][i]);
					        SendClientMessage(playerid,-1,stringg);
					    }
					}
					cache_delete(cache_houses,mysql_connection);
					cache_set_active(cache_users,mysql_connection);
					new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"insert into`connects`(`id`,`ip`)values('%i','%e')",player[playerid][id],temp_ip);
					mysql_query(mysql_connection,query);
					mysql_format(mysql_connection,query,sizeof(query),"select`id`,`commands`,`password`from`admins`where`name`='%e'limit 1",player[playerid][name]);
					new Cache:cache_admins=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    new temp_commands[16];
					    admin[playerid][id]=cache_get_field_content_int(0,"id",mysql_connection);
					    cache_get_field_content(0,"commands",temp_commands,mysql_connection,sizeof(temp_commands));
					    sscanf(temp_commands,"p<|>a<i>[5]",admin[playerid][commands]);
					    cache_get_field_content(0,"password",admin[playerid][password],mysql_connection,16);
					    if(!strcmp(admin[playerid][password],"-")){
					        ShowPlayerDialog(playerid,dAdminPasswordCreate,DIALOG_STYLE_INPUT,""BLUE"��������� ������ ��������������","\n"WHITE"������� �������� ������ ��� ����������� � �����-������\n\n","������","�����");
					    }
					    else{
					        ShowPlayerDialog(playerid,dAdminPasswordInput,DIALOG_STYLE_INPUT,""BLUE"����������� � �����-������","\n"WHITE"������� ������ ��� ����������� � �����-������\n\n","������","�����");
					    }
					    return true;
					}
					cache_delete(cache_admins,mysql_connection);
					cache_set_active(cache_users,mysql_connection);
					SetPVarInt(playerid,"PlayerLogged",1);
					TogglePlayerSpectating(playerid,false);
					SpawnPlayer(playerid);
				}
				else{
					new inc_string[40-2+1];
					format(inc_string,sizeof(inc_string),""WHITE"������������ ������! (%d/3)\n\n",GetPVarInt(playerid,"PasswordAttempts"));
					strcat(string,inc_string);
					ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");
					strdel(string,strlen_text,sizeof(string));
					SetPVarInt(playerid,"PasswordAttempts",GetPVarInt(playerid,"PasswordAttempts")-1);
					if(!GetPVarInt(playerid,"PasswordAttempts")){
					    ShowPlayerDialog(playerid,NULL,NULL,"","","","");
					    SendClientMessage(playerid,C_RED,"[����������] �� ����� ������������ ������ ��� ���� � ���� �������!");
					    SetTimerEx("@__kick_player",250,false,"i",playerid);
					    return true;
					}
				}
				cache_delete(cache_users,mysql_connection);
		    }
		    else{
				SendClientMessage(playerid,C_RED,"[����������] �� ���������� �� ����������� � ���� �������!");
				SetTimerEx("@__kick_player",250,false,"i",playerid);
		    }
		}
		case dMainMenu:{
		    if(response){
		        switch(listitem){
		            case 0:{
						ShowPlayerDialog(playerid,dMainMenuInfAboutPers,DIALOG_STYLE_LIST,""BLUE"���������� � ���������","[0] ���������� � ���������\n[1] ���������� �� ��������\n[2] ���������� � ��������� ������������\n[3] ������ ���������� ������","�������","�����");
		            }
		            case 1:{
		                ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"����������� �������","[0] ����������\n[1] �������\\������� ��������\n[2] ���������� � ���������\n[3] ������ ���, ��� ��� ��� ��������\n[4] ������ ���, ��� ��� ��� �������","�������","�����");
		            }
		            case 2:{
		                ShowPlayerDialog(playerid,dMainMenuHelp,DIALOG_STYLE_LIST,""BLUE"������ �� �������","[0] ������� �������","�����","�����");
		            }
		        }
		    }
		}
		case dMainMenuReferalSystem:{
			if(response){
			    switch(listitem){
			        case 0:{//���������� � ����������� �������
						static string[492];
						strcat(string,"\n"WHITE"�� ������� ��������� ������������������� ����������� �������.\n");
						strcat(string,"�� ������ ������� ���� �������� � ������������ ���������� � ����������������.\n");
						strcat(string,"��� �������� ���������, �� ������ ��������� �������, ��� ���������� ��������\n");
						strcat(string,"����� ����� �������� ����������� ��������������.(������,����)\n");
						strcat(string,"������������� ��������� ������, ������ ��������� ��������.\n");
						strcat(string,"\n"GREY"�� ��������� �� ��������!\n");
						//strcat(string,"�������� ����� ������� ������ � VIP ���������!\n"); - � ��������� �����������
						strcat(string,"��� ����� ��������� ��� �������� �� IP!\n\n");
						ShowPlayerDialog(playerid,dMainMenuReferalSystemInfo,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ����������� �������",string,"�����","");
						string="";
			        }
			        case 1:{//��������/�������� ���������
						new query[53-2+MAX_PLAYER_NAME];
						mysql_format(mysql_connection,query,sizeof(query),"select`promocode`from`promocodes`where`creator`='%e'",player[playerid][name]);
						new Cache:cache_promocodes=mysql_query(mysql_connection,query);
						if(cache_get_row_count(mysql_connection)){
							new temp[MAX_PROMOCODE_LEN];
							cache_get_field_content(0,"promocode",temp,mysql_connection,sizeof(temp));
							SetPVarString(playerid,"rs_promocode",temp);
							new string[72-2+MAX_PROMOCODE_LEN];
							format(string,sizeof(string),"\n"WHITE"� ��� ��� ���� �������� - "BLUE"%s\n"WHITE"�� ������ ������� ���?\n\n",temp);
							ShowPlayerDialog(playerid,dMainMenuReferalSystemDelete,DIALOG_STYLE_MSGBOX,""BLUE"�������� ���������",string,"��","���");
						}
						else{
						    ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� �������� ������ ���������\n\n","������","�����");
						}
						cache_delete(cache_promocodes,mysql_connection);
			        }
			        case 2:{//���������� � ���������
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
                            format(string,sizeof(string),"\n"WHITE"ID ��������� -\t\t"BLUE"%d\n"WHITE"�������� ��������� -\t"BLUE"%s\n"WHITE"���� �������� -\t\t"BLUE"%s\n\n"GREY"������:\n"WHITE"��������� ������� -\t"BLUE"%d\n"WHITE"���������� ����� -\t\t"BLUE"%d\n"WHITE"���������� ����� -\t\t"BLUE"%d\n\n"GREY"���������� �������, ������� ����� �������� - %d\n\n",temp_id,temp_promocode,temp_created,temp_level,temp_money,temp_experience,cache_get_row_count(mysql_connection));
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ���������",string,"�������","");
							string="";
			            }
			            else{
			                if(!strlen(player[playerid][referal_name])){
			                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"� ��� ��� ������\\������������ ���������!\n\n","�������","");
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
								format(string,sizeof(string),"\n"WHITE"ID ��������� -\t\t"BLUE"%d\n"WHITE"�������� ��������� -\t"BLUE"%s\n"WHITE"��������� -\t\t\t"BLUE"%s\n"WHITE"���� �������� -\t\t"BLUE"%s\n\n"GREY"���������� �������, ������� ����� �������� - %d\n\n",temp_id,temp_promocode,temp_creator,temp_created,cache_get_row_count(mysql_connection));
								ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ���������",string,"�������","");
								string="";
							}
							else{
							    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
							}
							cache_delete(cache__promocodes,mysql_connection);
			            }
			            cache_delete(cache_promocodes,mysql_connection);
			        }
			        case 3:{//������ ���, ��� ��� ��������
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
			                    string=""BLUE"�������\t"BLUE"������ �����������\t"BLUE"�����\n";
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
			                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"������ �������, ��� ��� ��������",string,"�������","");
			                    string="";
			                }
			                else{
                                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������","\n"WHITE"��� �������� ��� ����� �� ��������!\n\n","�������","");
			                }
			                cache_delete(cache_users,mysql_connection);
			                cache_set_active(cache_promocodes,mysql_connection);
			            }
			            else{
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"� ��� ��� ���������� ���������!\n\n","�������","");
			            }
			            cache_delete(cache_promocodes,mysql_connection);
			        }
			        case 4:{//������ ���, ��� ��� �������
			            new query[56-2+MAX_PLAYER_NAME];
			            mysql_format(mysql_connection,query,sizeof(query),"select`name`,`level`from`users`where`referal_name`='%e'",player[playerid][name]);
			            new Cache:cache_users=mysql_query(mysql_connection,query);
			            if(cache_get_row_count(mysql_connection)){
			                static string[512+61];
							string=""BLUE"�������\t"BLUE"������ �����������\t"BLUE"�����\n";
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
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"������ �������, ��� ��� �������",string,"�������","");
							string="";
			            }
			            else{
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������","\n"WHITE"��� ������� ��� ����� �� ��������!\n\n","�������","");
			            }
			            cache_delete(cache_users,mysql_connection);
			        }
			    }
			}
			else{
			    cmd::menu(playerid);
			}
		}
		case dMainMenuReferalSystemInfo:{
		    if(response || !response){
		        ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"����������� �������","[0] ����������\n[1] �������\\������� ��������\n[2] ���������� � ���������\n[3] ������ ���, ��� ��� ��� ��������\n[4] ������ ���, ��� ��� ��� �������","�������","�����");
		    }
		}
		case dMainMenuReferalSystemDelete:{
		    if(response){
		        new temp[MAX_PROMOCODE_LEN];
				GetPVarString(playerid,"rs_promocode",temp,sizeof(temp));
				if(!strlen(temp)){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
				    return true;
				}
				new query[45-2+MAX_PROMOCODE_LEN];
				mysql_format(mysql_connection,query,sizeof(query),"delete from`promocodes`where`promocode`='%e'",temp);
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������","\n"WHITE"�� ������� ��� ��������!\n\n","�������","");
		    }
		    else{
		        ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"����������� �������","[0] ����������\n[1] �������\\������� ��������\n[2] ���������� � ���������\n[3] ������ ���, ��� ��� ��� ��������\n[4] ������ ���, ��� ��� ��� �������","�������","�����");
		        DeletePVar(playerid,"rs_promocode");
		    }
		}
		case dMainMenuReferalSystemCreate:{
			if(response){
			    new sscanf_promocode[MAX_PROMOCODE_LEN];
			    if(sscanf(inputtext,"s[128]",sscanf_promocode) || strlen(inputtext)<MIN_PROMOCODE_LEN || strlen(inputtext)>MAX_PROMOCODE_LEN){
			        ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� �������� ������ ���������\n\n","������","�����");
			        return true;
			    }
                if(!regex_match(sscanf_promocode,"[a-zA-Z0-9#-]+")){
                    ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"RED"������� ������������ �������!\n\n"WHITE"������� �������� ������ ���������\n\n","������","�����");
                    return true;
                }
				SetPVarString(playerid,"cp_promocode",sscanf_promocode);
				ShowPlayerDialog(playerid,dMainMenuReferalSystemCrLevel,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� �������, �������� ����� �������, ����� �������� ��������������\n\n","������","�����");
			}
			else{
			    ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"����������� �������","[0] ����������\n[1] �������\\������� ��������\n[2] ���������� � ���������\n[3] ������ ���, ��� ��� ��� ��������\n[4] ������ ���, ��� ��� ��� �������","�������","�����");
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
		            ShowPlayerDialog(playerid,dMainMenuReferalSystemCrLevel,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� �������, �������� ����� �������, ����� �������� ��������������\n\n","������","�����");
		            return true;
		        }
		        SetPVarInt(playerid,"cp_level",sscanf_level);
                ShowPlayerDialog(playerid,dMainMenuReferalSystemCrMoney,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� ����� �����, ������� ����� ����������\n\n","������","�����");
		    }
		    else{
		        ShowPlayerDialog(playerid,dMainMenuReferalSystemCreate,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� �������� ������ ���������\n\n","������","�����");
		        DeletePVar(playerid,"cp_level");
		    }
		}
		case dMainMenuReferalSystemCrMoney:{
		    if(response){
				new sscanf_money;
				if(sscanf(inputtext,"d",sscanf_money) || strval(inputtext)<0 || strval(inputtext)>50000){
                    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrMoney,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� ����� �����, ������� ����� ����������\n\n","������","�����");
				    return true;
				}
				SetPVarInt(playerid,"cp_money",sscanf_money);
				ShowPlayerDialog(playerid,dMainMenuReferalSystemCrExp,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� ���������� �����, ������� ����� ����������\n\n","������","�����");
		    }
			else{
			    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrLevel,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� �������, �������� ����� �������, ����� �������� ��������������\n\n","������","�����");
                DeletePVar(playerid,"cp_money");
			}
		}
		case dMainMenuReferalSystemCrExp:{
			if(response){
			    new sscanf_experience;
			    if(sscanf(inputtext,"d",sscanf_experience) || strval(inputtext)>24){
			        ShowPlayerDialog(playerid,dMainMenuReferalSystemCrExp,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� ���������� �����, ������� ����� ����������\n\n","������","�����");
			        return true;
			    }
			    SetPVarInt(playerid,"cp_experience",sscanf_experience);
			    new temp[MAX_PROMOCODE_LEN];
			    GetPVarString(playerid,"cp_promocode",temp,sizeof(temp));
			    new temp_money[16];
			    if(GetPVarInt(playerid,"cp_money")){
					format(temp_money,sizeof(temp_money),"$%d",GetPVarInt(playerid,"cp_money"));
			    }
			    else{
			        temp_money="���";
			    }
			    new temp_experience[16];
			    if(sscanf_experience){
			        format(temp_experience,sizeof(temp_experience),"%d",sscanf_experience);
			    }
			    else{
			        temp_experience="���";
			    }
			    new string[122-2-2-2-2+MAX_PROMOCODE_LEN+16+16+4];
			    format(string,sizeof(string),"\n"WHITE"�������� - "BLUE"%s\n"WHITE"������� - "BLUE"%d\n"WHITE"������ - "BLUE"%s\n"WHITE"���� - "BLUE"%s\n\n",temp,GetPVarInt(playerid,"cp_level"),temp_money,temp_experience);
			    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrConfirm,DIALOG_STYLE_MSGBOX,""BLUE"�������� ���������",string,"������","�����");
			}
			else{
			    ShowPlayerDialog(playerid,dMainMenuReferalSystemCrMoney,DIALOG_STYLE_INPUT,""BLUE"�������� ���������","\n"WHITE"������� ����� �����, ������� ����� ����������\n\n","������","�����");
			    DeletePVar(playerid,"cp_experience");
			}
		}
		case dMainMenuReferalSystemCrConfirm:{
			if(response){
			    new temp_promocode[MAX_PROMOCODE_LEN];
			    GetPVarString(playerid,"cp_promocode",temp_promocode,sizeof(temp_promocode));
			    if(!strlen(temp_promocode) || !GetPVarInt(playerid,"cp_level")){
			        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
			        return true;
			    }
			    new query[108-2-2-2-2-2+MAX_PLAYER_NAME+MAX_PROMOCODE_LEN+4+11+11];
			    mysql_format(mysql_connection,query,sizeof(query),"insert into`promocodes`(`creator`,`promocode`,`level`,`money`,`experience`)values('%e','%e','%d','%d','%d')",player[playerid][name],temp_promocode,GetPVarInt(playerid,"cp_level"),GetPVarInt(playerid,"cp_money"),GetPVarInt(playerid,"cp_experience"));
			    mysql_query(mysql_connection,query);
			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������","\n"WHITE"�� ������� ���� ��������!\n\n","�������","");
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
		case dMainMenuInfAboutPers:{
		    if(response){
		        switch(listitem){
			        case 0:{
			            new string[113-2-2-2-2+3+24+8+11];
			            new temp_gender[8];
			            temp_gender=player[playerid][gender]?"�������":"�������";
			            format(string,sizeof(string),"\n"WHITE"������� - "BLUE"%i ���\n"WHITE"���� - "BLUE"%s\n"WHITE"��� - "BLUE"%s\n\n"WHITE"������ - "GREEN"$%i\n\n",player[playerid][age],origins[player[playerid][origin]],temp_gender,player[playerid][money]);
			            ShowPlayerDialog(playerid,dMainMenuInfAboutPersCharacter,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ���������",string,"�����","");
			        }
			        case 1:{
			            new string[195-2-2-2-2-2+11+MAX_PLAYER_NAME+MAX_EMAIL_LEN+MAX_PROMOCODE_LEN+20];
			            new temp_email[MAX_EMAIL_LEN];
			            if(!strlen(player[playerid][email])){
			                temp_email="�� ���������";
			            }
			            else{
			                format(temp_email,sizeof(temp_email),player[playerid][email]);
			            }
			            new temp_referal_name[MAX_PROMOCODE_LEN];
			            if(!strlen(player[playerid][referal_name])){
			                temp_referal_name="�� ������";
			            }
			            else{
			                format(temp_referal_name,sizeof(temp_referal_name),player[playerid][referal_name]);
			            }
			            format(string,sizeof(string),"\n"WHITE"����� �������� - "BLUE"%i\n"WHITE"������� - "BLUE"%s\n\n"WHITE"����������� ����� - "GREY"%s\n"WHITE"�������\\�������� - "GREY"%s\n\n"WHITE"���� ����������� - "BLUE"%s\n\n",player[playerid][id],player[playerid][name],temp_email,temp_referal_name,player[playerid][reg_date]);
			            ShowPlayerDialog(playerid,dMainMenuInfAboutPersAccount,DIALOG_STYLE_MSGBOX,""BLUE"���������� �� ��������",string,"�����","");
					}
					case 2:{//���������� � ��������� ������������
						new query[73-2+11];
						mysql_format(mysql_connection,query,sizeof(query),"select`date`,`ip`from`connects`where`id`='%i'order by`date`desc limit 15",player[playerid][id]);
						new Cache:cache_connects=mysql_query(mysql_connection,query);
						if(cache_get_row_count(mysql_connection)){
						    new temp_date[32],temp_ip[16],temp_string[45-2-2-2+11+32+16];
						    new temp_ip_color[24];
						    static string[sizeof(temp_string)*15];
						    string=""WHITE"�\t"WHITE"����\t"WHITE"IP �����\n";
						    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
								cache_get_field_content(i,"date",temp_date,mysql_connection,sizeof(temp_date));
								cache_get_field_content(i,"ip",temp_ip,mysql_connection,sizeof(temp_ip));
								if(!strcmp(temp_ip,player[playerid][reg_ip])){
								    format(temp_ip_color,sizeof(temp_ip_color),""GREEN"%s",temp_ip);
								}
								else{
								    format(temp_ip_color,sizeof(temp_ip_color),""RED"%s",temp_ip);
								}
								format(temp_string,sizeof(temp_string),""WHITE"%i\t%s\t%s\n",i,temp_date,temp_ip_color);
								strcat(string,temp_string);
						    }
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"���������� � ��������� ������������",string,"�������","");
						    string="";
						}
						else{
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
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
							string=""BLUE"��������\t"BLUE"����� �����\n";
					        new temp_string[9-2-2+32+11];
							for(new i=0; i<cache_get_row_count(mysql_connection); i++){
							    temp_id=cache_get_field_content_int(i,"id",mysql_connection);
							    cache_get_field_content(i,"description",temp_description,mysql_connection,sizeof(temp_description));
							    format(temp_string,sizeof(temp_string),"%s\t%i\n",temp_description,temp_id);
							    strcat(string,temp_string);
							}
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"������ ���������� ������",string,"�������","");
							string="";
					    }
					    else{
					        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"� ��� ��� ��� ��������� ���������� ������!\n\n","��","");
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
		                ShowPlayerDialog(playerid,dMainMenuHelpCommands,DIALOG_STYLE_LIST,""BLUE"������� �������","[0] ������� ��� ����\n[1] ������� ��� �������\n[2] ������� ��� ����","�������","�����");
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
						static string[322];
						strcat(string,"\n"BLUE"/todo "WHITE"- ��������� � ���������\n");
						strcat(string,""BLUE"/me "WHITE"- �������� ���������\n");
						strcat(string,""BLUE"/do "WHITE"- �������� �� �������� ����\n");
						strcat(string,""BLUE"/try(/coin) "WHITE"- ������� ��������\n");
						strcat(string,""BLUE"/shout "WHITE"- ��������\n");
						strcat(string,""BLUE"/whisper "WHITE"- ���������� ��������� ������\n");
						strcat(string,""BLUE"/n(/b) "WHITE"- OOC ���������\n\n");
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������� ��� ����",string,"�������","");
						string="";
		            }
		            case 1:{
		                static string[303];
		                strcat(string,"\n"BLUE"/faction(/f) "WHITE"- ��� �������\n");
		                strcat(string,""BLUE"/find "WHITE"- ������ �������\n\n");
		                strcat(string,""GREY"������� ��� ������ � �����������\n\n");
		                strcat(string,""BLUE"/invite "WHITE"- ���������� ������ �� �������\n");
		                strcat(string,""BLUE"/uninvite "WHITE"- ������� ������ �� �������\n");
		                strcat(string,""BLUE"/giverank "WHITE"- ��������/�������� ���������\n\n");
                        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������� ��� �������",string,"�������","");
                        string="";
		            }
		            case 2:{
		                static string[130];
		                strcat(string,"\n"BLUE"/home(/hm - /hmenu - /hpanel) "WHITE"- ������ ���������� �����\n");
		                strcat(string,""BLUE"/sellhome(/sellhouse) "WHITE"- ������� ����\n");
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������� ��� ����",string,"�������","");
		                string="";
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
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
				    return true;
				}
		        SetPVarInt(playerid,"Bank_CreatingAccount",1);
		        ShowPlayerDialog(playerid,dBankCreateAccountDescription,DIALOG_STYLE_INPUT,""BLUE"�������� ����������� �����","\n"WHITE"������� �������� ��� ������ ������ �����\n\n","������","������");
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
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            return true;
		        }
		        new temp_description[32];
		        if(sscanf(inputtext,"s[128]",temp_description)){
		            ShowPlayerDialog(playerid,dBankCreateAccountDescription,DIALOG_STYLE_INPUT,""BLUE"�������� ����������� �����","\n"WHITE"������� �������� ��� ������ ������ �����\n\n","������","������");
		            return true;
		        }
		        SetPVarString(playerid,"Bank_CreatingAccountDescription",temp_description);
		        new string[99-2+32];
		        format(string,sizeof(string),"\n"GREY"�������� ����������� ����� - %s\n\n"WHITE"���������� ������ ��� ������ ������ �����\n\n",temp_description);
		        ShowPlayerDialog(playerid,dBankCreateAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"�������� ����������� �����",string,"������","������");
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
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            return true;
		        }
		        new sscanf_password[32];
				if(sscanf(inputtext,"s[128]",sscanf_password) || !regex_match(sscanf_password,"[a-zA-Z0-9]+")){
				    new string[99-2+32];
			        format(string,sizeof(string),"\n"GREY"�������� ����������� ����� - %s\n\n"WHITE"���������� ������ ��� ������ ������ �����\n\n",temp_description);
			        ShowPlayerDialog(playerid,dBankCreateAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"�������� ����������� �����",string,"������","������");
				    return true;
				}
				SetPVarString(playerid,"Bank_CreatingAccountPassword",sscanf_password);
				new string[87-2-2+32+32];
				format(string,sizeof(string),"\n"WHITE"�������� - %s\n������ - %s\n\n"GREY"�� ������ ������� ���������� ����?\n\n",temp_description,sscanf_password);
				ShowPlayerDialog(playerid,dBankCreateAccountConfirm,DIALOG_STYLE_MSGBOX,""BLUE"�������� ����������� �����",string,"��","���");
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
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            return true;
		        }
		        ShowPlayerDialog(playerid,dBankCreateAccountSignConfirm,DIALOG_STYLE_INPUT,""BLUE"���������� ����","\n"WHITE"��� �������� �����, ��� ���������� ��������� ���� �������"GREY"(�� ��������)\n\n","������","������");
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
                    ShowPlayerDialog(playerid,dBankCreateAccountSignConfirm,DIALOG_STYLE_INPUT,""BLUE"���������� ����","\n"WHITE"��� �������� �����, ��� ���������� ��������� ���� �������"GREY"(�� ��������)\n\n","������","������");
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
	                format(string,sizeof(string),"[����������] ����� ������ ������ ����� - %i",temp_id);
					SendClientMessage(playerid,C_GREEN,string);
					SendClientMessage(playerid,C_BLUE,"[����������] ����������� ����� ����� � ������ � ������� ��� ��������!");
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"������","\n"WHITE"�� ������� ������������ �������!\n\n","�������","");
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
				    ShowPlayerDialog(playerid,dBankAccountInput,DIALOG_STYLE_INPUT,""BLUE"���������� ����","\n"WHITE"������� ����� ������ ����������� �����\n\n"GREY"(( ���������: /menu [0] [3] ))\n\n","������","������");
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
					format(string,sizeof(string),"\n"WHITE"�������� ����������� ����� - %s\n��� ���������� ������ ������ ��� �������\n\n",temp_description);
					ShowPlayerDialog(playerid,dBankAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"���������� ����",string,"������","������");
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"���������� ����������� ����� �� ����������!\n\n","�������","");
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
					format(string,sizeof(string),"\n"WHITE"�������� ����������� ����� - %s\n��� ���������� ������ ������ ��� �������\n\n",temp_description);
					ShowPlayerDialog(playerid,dBankAccountPassword,DIALOG_STYLE_PASSWORD,""BLUE"���������� ����",string,"������","������");
		            return true;
		        }
				new query[58-2-2+32+11];
				mysql_format(mysql_connection,query,sizeof(query),"select*from`bank_accounts`where`password`='%e'and`id`='%i'",temp_password,GetPVarInt(playerid,"tempBankAccount"));
				new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] ���������� � �����\n[1] ��������� ������ �� ������ ����\n[2] ����� ������ �� �����\n[3] �������� ������ �� ����\n[4] ������� ����������","�������","�����");
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� ����� ������������ ������!\n\n","�������","");
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
		            case 0:{// ���������� � �����
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
							format(string,sizeof(string),"\n"WHITE"����� ����� - "BLUE"%i\n"WHITE"�������� ����� - "BLUE"%s\n"WHITE"�������� ����� - "BLUE"%s\n"WHITE"���� �������� - "BLUE"%s\n"WHITE"������ - "GREEN"$%i\n\n",temp_id,temp_description,temp_owner,temp_date,temp_money);
							ShowPlayerDialog(playerid,dBankAccountMenuInf,DIALOG_STYLE_MSGBOX,""BLUE"���������� � �����",string,"�����","");
							string="";
		                }
		                else{
		                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		                }
		                cache_delete(cache_bank_accounts,mysql_connection);
		            }
		            case 1:{// ��������� ������ �� ������ ����
						ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"��������� ������ �� ������ ����","\n"WHITE"������� ����� ����� � ����� �������� ����� �������\n\n"GREY"������: 12345,2000\n\n","������","�����");
		            }
					case 2:{//����� ������ �� �����
					    ShowPlayerDialog(playerid,dBankAccountMenuWithdraw,DIALOG_STYLE_INPUT,""BLUE"����� ������ �� �����","\n"WHITE"������� �����, ������� �� ������ ����� �� �����\n\n","������","�����");
					}
					case 3:{//�������� ������ �� ����
					    ShowPlayerDialog(playerid,dBankAccountMenuDeposit,DIALOG_STYLE_INPUT,""BLUE"�������� ������ �� ����","\n"WHITE"������� �����, ������� ������ �������� �� ����\n\n","������","�����");
					}
					case 4:{//������� ����������
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
										format(temp_string,sizeof(temp_string),""WHITE"TRANSFER | ID - %i | ���� - %s | %s | ����� ����� - %i\n",temp_transaction_id,temp_date,temp_money_color,temp_transfer_id);
								    }
								    case WITHDRAW_FROM_ACCOUNT:{
								        format(temp_string,sizeof(temp_string),""WHITE"WITHDRAW | ID - %i | ���� - %s | %s | ����� �������� - %i\n",temp_transaction_id,temp_date,temp_money_color,temp_transfer_id);
								    }
								    case DEPOSIT_TO_ACCOUNT:{
								        format(temp_string,sizeof(temp_string),""WHITE"DEPOSIT | ID - %i | ���� - %s | %s | ����� �������� - %i\n",temp_transaction_id,temp_date,temp_money_color,temp_transfer_id);
								    }
								}
								strcat(string,temp_string);
							}
							ShowPlayerDialog(playerid,dBankAccountMenuInf,DIALOG_STYLE_MSGBOX,""BLUE"������� ����������",string,"�����","");
							string="";
					    }
					    else{
                            ShowPlayerDialog(playerid,dBankAccountMenuInf,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"���������� � ����� ������ �� �������!\n\n","�����","");
					    }
					    cache_delete(cache_ba_transactions,mysql_connection);
					}
		        }
		    }
		    else{
                DeletePVar(playerid,"tempBankAccount");
		    }
		}
		case dBankAccountMenuInf:{
			if(response || !response){
                ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] ���������� � �����\n[1] ��������� ������ �� ������ ����\n[2] ����� ������ �� �����\n[3] �������� ������ �� ����\n[4] ������� ����������","�������","�����");
			}
		}
		case dBankAccountMenuTransfer:{
			if(response){
			    new sscanf_id,sscanf_money;
			    if(sscanf(inputtext,"p<,>ii",sscanf_id,sscanf_money)){
				    ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"��������� ������ �� ������ ����","\n"WHITE"������� ����� ����� � ����� �������� ����� �������\n\n"GREY"������: 12345,2000\n\n","������","�����");
				    return true;
				}
				new query[61-2+11];
				mysql_format(mysql_connection,query,sizeof(query),"select`money`from`bank_accounts`where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
				new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
					new temp_money;
					temp_money=cache_get_field_content_int(0,"money",mysql_connection);
					if(sscanf_money>temp_money){
                        ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"��������� ������ �� ������ ����","\n"RED"�� ����� ����� ��� ������� �������!\n\n"WHITE"������� ����� ����� � ����� �������� ����� �������\n\n"GREY"������: 12345,2000\n\n","������","�����");
					    return true;
					}
				}
				else{
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
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
					format(string,sizeof(string),"\n"WHITE"����� ����� - "BLUE"%i\n"WHITE"�������� ����� - "BLUE"%s\n"WHITE"�������� - "BLUE"%s\n"WHITE"����� �������� - "GREEN"$%i\n\n"WHITE"�� ������ ��������� ������ �� ��������� ����?\n\n",sscanf_id,temp_description,temp_owner,sscanf_money);
					ShowPlayerDialog(playerid,dBankAccountMenuTransferConfirm,DIALOG_STYLE_MSGBOX,""BLUE"��������� ������ �� ������ ����",string,"��","���");
					string="";
				}
				else{
                    ShowPlayerDialog(playerid,dBankAccountMenuTransfer,DIALOG_STYLE_INPUT,""BLUE"��������� ������ �� ������ ����","\n"RED"��������� ���������� ���� �� ������!\n\n"WHITE"������� ����� ����� � ����� �������� ����� �������\n\n"GREY"������: 12345,2000\n\n","������","�����");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
			}
			else{
                ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] ���������� � �����\n[1] ��������� ������ �� ������ ����[2] ����� ������ �� �����\n[3] �������� ������ �� ����\n[4] ������� ����������","�������","�����");
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
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            return true;
		        }
				new temp_playerid;
				sscanf(temp_owner,"u",temp_playerid);
				if(GetPVarInt(temp_playerid,"PlayerLogged")){
				    new string[91-2-2+11+11];
				    format(string,sizeof(string),"[����������] �� ��� ���� ���� ���������� "GREEN"$%i"BLUE". ����� ����� ����������� - %i",GetPVarInt(playerid,"tempBankAccountTransferMoney"),GetPVarInt(playerid,"tempBankAccount"));
				    SendClientMessage(temp_playerid,C_BLUE,string);
				}
				new query[103-2-2-2-2-2+11+11+11+16+11];
			    mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`+'%i'where`id`='%i'",GetPVarInt(playerid,"tempBankAccountTransferMoney"),GetPVarInt(playerid,"tempBankAccountTransfer"));
				mysql_query(mysql_connection,query);
				mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`-'%i'where`id`='%i'",GetPVarInt(playerid,"tempBankAccountTransferMoney"),GetPVarInt(playerid,"tempBankAccount"));
				mysql_query(mysql_connection,query);
				new temp_ip[16];
				GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
				mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','-%i','%e','%i')",GetPVarInt(playerid,"tempBankAccount"),FROM_ACCOUNT_TO_ACCOUNT,GetPVarInt(playerid,"tempBankAccountTransferMoney"),temp_ip,GetPVarInt(playerid,"tempBankAccountTransfer"));
				mysql_query(mysql_connection,query);
				mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','%i','%e','%i')",GetPVarInt(playerid,"tempBankAccountTransfer"),FROM_ACCOUNT_TO_ACCOUNT,GetPVarInt(playerid,"tempBankAccountTransferMoney"),temp_ip,GetPVarInt(playerid,"tempBankAccount"));
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� ������� �������� ������ �� ������ ����!\n\n","�������","");
				DeletePVar(playerid,"tempBankAccountTransfer");
		        DeletePVar(playerid,"tempBankAccountTransferMoney");
		        DeletePVar(playerid,"tempBankAccountTransferOwner");
		        DeletePVar(playerid,"tempBankAccount");
		    }
		    else{
		        DeletePVar(playerid,"tempBankAccountTransfer");
		        DeletePVar(playerid,"tempBankAccountTransferMoney");
		        ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] ���������� � �����\n[1] ��������� ������ �� ������ ����\n[2] ����� ������ �� �����\n[3] �������� ������ �� ����\n[4] ������� ����������","�������","�����");
		    }
		}
		case dBankAccountMenuWithdraw:{
		    if(response){
		        new sscanf_money;
		        if(sscanf(inputtext,"i",sscanf_money)){
		            ShowPlayerDialog(playerid,dBankAccountMenuWithdraw,DIALOG_STYLE_INPUT,""BLUE"����� ������ �� �����","\n"WHITE"������� �����, ������� �� ������ �����\n\n","������","�����");
		            return true;
		        }
		        new query[103-2-2-2-2-2+11+11+11+16+11];
		        mysql_format(mysql_connection,query,sizeof(query),"select`money`from`bank_accounts`where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
		        new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
		        if(cache_get_row_count(mysql_connection)){
					new temp_money;
					temp_money=cache_get_field_content_int(0,"money",mysql_connection);
					if(temp_money<sscanf_money){
					    ShowPlayerDialog(playerid,dBankAccountMenuWithdraw,DIALOG_STYLE_INPUT,""BLUE"����� ������ �� �����","\n"RED"�� ����� ����� ��� ������� �������!\n\n"WHITE"������� �����, ������� �� ������ �����\n\n","������","�����");
					    return true;
					}
					mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`=`money`+'%i'where`id`='%i'",sscanf_money,player[playerid][id]);
					mysql_query(mysql_connection,query);
					mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`-'%i'where`id`='%i'",sscanf_money,GetPVarInt(playerid,"tempBankAccount"));
					mysql_query(mysql_connection,query);
					new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','-%i','%e','%i')",GetPVarInt(playerid,"tempBankAccount"),WITHDRAW_FROM_ACCOUNT,sscanf_money,temp_ip,player[playerid][id]);
					mysql_query(mysql_connection,query);
					player[playerid][money]+=sscanf_money;
					ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid,player[playerid][money]);
					new string[81-2-2+11+11];
					format(string,sizeof(string),"\n"WHITE"�� ����� �� ����� "GREEN"$%i\n"WHITE"������� ����� - "GREEN"$%i\n\n",sscanf_money,temp_money-sscanf_money);
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����� ������ �� �����",string,"�������","");
					DeletePVar(playerid,"tempBankAccount");
		        }
				else{
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
		    }
		    else{
                ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] ���������� � �����\n[1] ��������� ������ �� ������ ����\n[2] ����� ������ �� �����\n[3] �������� ������ �� ����\n[4] ������� ����������","�������","�����");
		    }
		}
		case dBankAccountMenuDeposit:{
		    if(response){
		        new sscanf_money;
		        if(sscanf(inputtext,"i",sscanf_money)){
		            ShowPlayerDialog(playerid,dBankAccountMenuDeposit,DIALOG_STYLE_INPUT,""BLUE"�������� ������ �� ����","\n"WHITE"������� �����, ������� ������ �������� �� ����\n\n","������","�����");
		            return true;
		        }
		        if(player[playerid][money]<sscanf_money){
		            ShowPlayerDialog(playerid,dBankAccountMenuDeposit,DIALOG_STYLE_INPUT,""BLUE"�������� ������ �� ����","\n"RED"� ��� ��� ������� ������� �� �����!\n\n"WHITE"������� �����, ������� ������ �������� �� ����\n\n","������","�����");
		            return true;
		        }
				new query[104-2-2-2-2-2+11+11+11+16+11];
				mysql_format(mysql_connection,query,sizeof(query),"select`money`from`bank_accounts`where`id`='%i'",GetPVarInt(playerid,"tempBankAccount"));
				new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
				if(cache_get_row_count(mysql_connection)){
				    new temp_money;
				    temp_money=cache_get_field_content_int(0,"money",mysql_connection);
					mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money]-sscanf_money,player[playerid][id]);
					mysql_query(mysql_connection,query);
					mysql_format(mysql_connection,query,sizeof(query),"update`bank_accounts`set`money`=`money`+'%i'where`id`='%i'",sscanf_money,GetPVarInt(playerid,"tempBankAccount"));
					mysql_query(mysql_connection,query);
					new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"insert into`ba_transactions`(`ba_id`,`type`,`money`,`ip`,`transfer_id`)values('%i','%i','%i','%e','%i')",GetPVarInt(playerid,"tempBankAccount"),DEPOSIT_TO_ACCOUNT,sscanf_money,temp_ip,player[playerid][id]);
					mysql_query(mysql_connection,query);
					player[playerid][money]-=sscanf_money;
					ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid,player[playerid][money]);
					new string[86-2-2+11+11];
					format(string,sizeof(string),"\n"WHITE"�� �������� �� ���� "GREEN"$%i\n"WHITE"������� �� ����� - "GREEN"$%i\n\n",sscanf_money,temp_money+sscanf_money);
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"�������� ������ �� ����",string,"�������","");
					DeletePVar(playerid,"tempBankAccount");
				}
				else{
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
				}
				cache_delete(cache_bank_accounts,mysql_connection);
		    }
		    else{
                ShowPlayerDialog(playerid,dBankAccountMenu,DIALOG_STYLE_LIST,""BLUE"MainMenu of Bank Account","[0] ���������� � �����\n[1] ��������� ������ �� ������ ����\n[2] ����� ������ �� �����\n[3] �������� ������ �� ����\n[4] ������� ����������","�������","�����");
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
		                ShowPlayerDialog(playerid,dCityHallInfPassport,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"������� ����� �������� ������ � ���� �������\n\n","�������","");
		            }
					case 1:{
					    new Float:temp_x,Float:temp_y,Float:temp_z;
					    GetPlayerPos(playerid,temp_x,temp_y,temp_z);
					    InterpolateCameraPos(playerid,temp_x,temp_y,temp_z,1490.5195,-1760.0215,1009.5559,3000);
						InterpolateCameraLookAt(playerid,temp_x,temp_y,temp_z,1488.1479,-1758.4341,1009.5559,2500);
		                ShowPlayerDialog(playerid,dCityHallInfPassport,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"���������� �� ��������� ���� ����� �������� ������ � ���� �������\n\n","�������","");
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
		        ShowPlayerDialog(playerid,dCityHallTakePassportBirthday,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"������� ���� �������� ������ ���������\n\n"GREY"������: 25/05/1999\n\n","�����","������");
		    }
		}
		case dCityHallTakePassportBirthday:{
		    if(response){
		        new sscanf_day,sscanf_month,sscanf_year;
				if(sscanf(inputtext,"p</>iii",sscanf_day,sscanf_month,sscanf_year)){
                    ShowPlayerDialog(playerid,dCityHallTakePassportBirthday,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"������� ���� �������� ������ ���������\n\n"GREY"������: 25/05/1999\n\n","�����","������");
				    return true;
				}
				new temp_day,temp_month,temp_year;
				getdate(temp_year,temp_month,temp_day);
				if(temp_year-sscanf_year > 100 || sscanf_year < 1 || sscanf_year >= temp_year || temp_year-sscanf_year < 16){
				    ShowPlayerDialog(playerid,dCityHallTakePassportBirthday,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"������� ���� �������� ������ ���������\n\n"GREY"������: 25/05/1999\n\n","�����","������");
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
				ShowPlayerDialog(playerid,dCityHallTakePassportSignature,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"��� ����� ��������� �������\n\n"GREY"����������: ��� ����� �������������� � ���������\n������ ��������� ����� ��� ��������\n\n","������","������");
		    }
		}
		case dCityHallTakePassportSignature:{
		    if(response){
		        new sscanf_signature[16];
		        if(sscanf(inputtext,"s[128]",sscanf_signature) || strlen(inputtext)>16 || !regex_match(inputtext,"[a-zA-Z]+")){
		            ShowPlayerDialog(playerid,dCityHallTakePassportSignature,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"��� ����� ��������� �������\n\n"GREY"����������: ��� ����� �������������� � ���������\n������ ��������� ����� ��� ��������\n\n","������","������");
		            return true;
		        }
				SetPVarString(playerid,"passportSignature",sscanf_signature);
				ShowPlayerDialog(playerid,dCityHallTakePassportValidality,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"�� ����� ����(���) �� ������ ���������� �������?\n\n","������","������");
		    }
		    else{
				DeletePVar(playerid,"passportAge");
		    }
		}
		case dCityHallTakePassportValidality:{
		    if(response){
		        new sscanf_days;
		        if(sscanf(inputtext,"i",sscanf_days)){
		            ShowPlayerDialog(playerid,dCityHallTakePassportValidality,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"�� ����� ����(���) �� ������ ���������� �������?\n\n","������","������");
		            return true;
		        }
		        new temp_validality=gettime()+(SECONDS_IN_DAY*sscanf_days);
		        SetPVarInt(playerid,"passportDays",sscanf_days);
				SetPVarInt(playerid,"passportValidality",temp_validality);
				new temp_signature[16];
				GetPVarString(playerid,"passportSignature",temp_signature,sizeof(temp_signature));
				new temp_date[12];
				GetPVarString(playerid,"passportDate",temp_date,sizeof(temp_date));
				new string[122-2-2-2-2+sizeof(temp_date)+2+sizeof(temp_signature)+32];
				format(string,sizeof(string),"\n"WHITE"���� �������� - "BLUE"%s "GREY"(%i)\n"WHITE"������� - "BLUE"%s\n"WHITE"������������ �� - "BLUE"%s\n\n"WHITE"�� ������ �������� �������?\n\n",temp_date,GetPVarInt(playerid,"passportAge"),temp_signature,gettimestamp(temp_validality,1));
				ShowPlayerDialog(playerid,dCityHallTakePassportConfirm,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������",string,"��","���");
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
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"","\n"WHITE"��� ����� �������� ������� �� ��������� �������� � �����!\n\n","�������","");
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
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n�� �� �������� ������ �� ������ ������� �� �������!\n\n","�������","");
						    return true;
						}
						SetPVarInt(playerid,"TotalFeeForPassport",GetSVarInt("sFeeForPassport")*GetPVarInt(playerid,"passportDays"));
						new string[89-2+6];
						format(string,sizeof(string),"\n"WHITE"��� ����� �������� "GREEN"$%i"WHITE" �� ��������� ��������\n�� ��������?\n\n",GetPVarInt(playerid,"TotalFeeForPassport"));
						ShowPlayerDialog(playerid,dBankPaymentServiceTakePassport,DIALOG_STYLE_MSGBOX,""BLUE"������ ������� �� �������",string,"��","���");
		            }
					case 1:{
					    if(GetPVarInt(playerid,"PayFeeForPassport")!=2 || !GetPVarInt(playerid,"renewalPassportValidality") || !GetPVarInt(playerid,"renewalPassportDays")){
					        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� �� �������� ������ �� ������ ������� �� ��������� ��������!\n\n","�������","");
					        return true;
					    }
					    SetPVarInt(playerid,"TotalFeeForRenewalPassport",GetSVarInt("sFeeForPassport")*GetPVarInt(playerid,"renewalPassportDays"));
					    new string[87-2+6];
					    format(string,sizeof(string),"\n"WHITE"��� ����� �������� "GREEN"$%i"WHITE" �� ��������� ��������!\n�� ��������?\n\n",GetPVarInt(playerid,"TotalFeeForRenewalPassport"));
					    ShowPlayerDialog(playerid,dBankPaymentServiceRePassport,DIALOG_STYLE_MSGBOX,""BLUE"������ ������� �� ��������� ��������",string,"��","���");
					}
				}
		    }
		}
		case dBankPaymentServiceTakePassport:{
		    if(response){
		        if(GetPVarInt(playerid,"PayFeeForPassport")!=2 || !GetPVarInt(playerid,"passportValidality") || !GetPVarInt(playerid,"TotalFeeForRenewalPassport") || !GetPVarInt(playerid,"renewalPassportDays")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������\n\n","�������","");
		            return true;
		        }
		        if(player[playerid][money]<GetPVarInt(playerid,"TotalFeeForPassport")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"����������","\n"WHITE"� ��� ������������ �����!\n\n","�������","");
		            return true;
		        }
				player[playerid][money]-=GetPVarInt(playerid,"TotalFeeForPassport");
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				new query[105-2-2-2-2+MAX_PLAYER_NAME+16+16+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query);
				new temp_birthday[16];
				GetPVarString(playerid,"passportDate",temp_birthday,sizeof(temp_birthday));
				new temp_signature[16];
				GetPVarString(playerid,"passportSignature",temp_signature,sizeof(temp_signature));
				mysql_format(mysql_connection,query,sizeof(query),"insert into`passports`(`owner`,`taken`,`birthday`,`signature`,`valid_to`)values('%e','0','%e','%e','%i')",player[playerid][name],temp_birthday,temp_signature,GetPVarInt(playerid,"passportValidality"));
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������","\n"WHITE"��� ����� ��������� � �����, ��� ��������� ��������!\n\n","�������","");
		    }
		}
		case dBankPaymentServiceRePassport:{
		    if(response){
		        if(GetPVarInt(playerid,"PayFeeForPassport")!=2 || !GetPVarInt(playerid,"renewalPassportValidality") || !GetPVarInt(playerid,"TotalFeeForRenewalPassport") || !GetPVarInt(playerid,"renewalPassportDays")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������\n\n","�������","");
		            return true;
		        }
		        if(player[playerid][money]<GetPVarInt(playerid,"TotalFeeForRenewalPassport")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"����������","\n"WHITE"� ��� ������������ �����!\n\n","�������","");
		            return true;
		        }
		        player[playerid][money]-=GetPVarInt(playerid,"TotalFeeForRenewalPassport");
		        ResetPlayerMoney(playerid);
		        GivePlayerMoney(playerid,player[playerid][money]);
		        new query[50-2-2+11+11];
		        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
		        mysql_query(mysql_connection,query);
				mysql_format(mysql_connection,query,sizeof(query),"update`passports`set`valid_to`='%i'where`id`='%i'",GetPVarInt(playerid,"renewalPassportValidTo"),player[playerid][passport_id]);
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� �������� ���� �������� ��������!\n\n","�������","");
				DeletePVar(playerid,"PayFeeForPassport");
				DeletePVar(playerid,"renewalPassportValidality");
				DeletePVar(playerid,"TotalFeeForRenewalPassport");
				DeletePVar(playerid,"renewalPassportDays");
				DeletePVar(playerid,"renewalPassportValidTo");
		    }
		}
		case dCityHallRenewalPassport:{
			if(response){
				ShowPlayerDialog(playerid,dCityHallRenewalPassportValid,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"�� ����� ����(���) �� ������ �������� �������?\n\n","������","������");
				return true;
			}
		}
		case dCityHallRenewalPassportValid:{
			if(response){
			    if(!GetPVarInt(playerid,"renewalPassportValidality")){
			        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
					return true;
		        }
			    new sscanf_days;
			    if(sscanf(inputtext,"i",sscanf_days)){
			        ShowPlayerDialog(playerid,dCityHallRenewalPassportValid,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"�� ����� ����(���) �� ������ �������� �������?\n\n","������","������");
			        return true;
				}
				SetPVarInt(playerid,"renewalPassportDays",sscanf_days);
				new renewal_valid_to=GetPVarInt(playerid,"renewalPassportValidality")+(SECONDS_IN_DAY*sscanf_days);
				new string[52-2+31];
				format(string,sizeof(string),"\n"WHITE"������� ����� ������ �� - "BLUE"%s\n\n",gettimestamp(renewal_valid_to));
				ShowPlayerDialog(playerid,dCityHallRenewalPassportConfirm,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������",string,"������","������");
				SetPVarInt(playerid,"renewalPassportValidTo",renewal_valid_to);
			}
			else{
			    DeletePVar(playerid,"renewalPassportValidality");
			}
		}
		case dCityHallRenewalPassportConfirm:{
		    if(response){
		        if(!GetPVarInt(playerid,"renewalPassportValidality") || !GetPVarInt(playerid,"renewalPassportValidTo")){
			        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
					return true;
		        }
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������","\n"WHITE"��� ����� �������� ������� � �����!\n\n","�������","");
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
                ShowPlayerDialog(playerid,dCityHallRenewalPassportValid,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"�� ����� ����(���) �� ������ �������� �������?\n\n","������","������");
		    }
			else{
			    new query[48-2+11];
		        mysql_format(mysql_connection,query,sizeof(query),"delete from`passports`where`id`='%i'",player[playerid][passport_id]);
		        mysql_query(mysql_connection,query);
		        player[playerid][passport_id]=0;
		        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`passport_id`='0'where`id`='%i'",player[playerid][id]);
		        mysql_query(mysql_connection,query);
		        ShowPlayerDialog(playerid,dCityHallTakePassport,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������","\n"WHITE"��� ��������� ��������, ���������� ��������� ��������� ������\n�� ������ ����������?\n\n","��","���");
			}
		}
		case dDescription:{
		    if(response){
		        switch(listitem){
		            case 0:{
						ShowPlayerDialog(playerid,dDescriptionTempDesc,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"������� �����, ������� ����� ������������ �� ���������\n\n","�����","�����");
		            }
		            case 1:{
                        ShowPlayerDialog(playerid,dDescriptionSaveDesc,DIALOG_STYLE_INPUT,""BLUE"��������� � ���������� ��������","\n"WHITE"������� �����, ������� ����� ������������ �� ���������\n\n"GREY"����������: ��� ����� ���������\n\n","�����","�����");
		            }
		            case 2:{
		                if(!strcmp(player[playerid][description],"-") || !strlen(player[playerid][description])){
		                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"� ��� ��� ����������� �������� ���������!\n\n","�������","");
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
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� ���������� ���������� ��������!\n\n","�������","");
		            }
		            case 3:{
		                new string[75-2+64];
		                format(string,sizeof(string),"\n"WHITE"������� ����� �������� ���������\n������� �������� - "BLUE"%s\n\n",player[playerid][description]);
		                ShowPlayerDialog(playerid,dDescriptionEditDesc,DIALOG_STYLE_INPUT,""BLUE"�������� ��������",string,"������","�����");
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
				    ShowPlayerDialog(playerid,dDescriptionTempDesc,DIALOG_STYLE_INPUT,""BLUE"��������� ��������","\n"WHITE"������� �����, ������� ����� ������������ �� ���������\n\n","�����","�����");
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
		            ShowPlayerDialog(playerid,dDescriptionSaveDesc,DIALOG_STYLE_INPUT,""BLUE"��������� � ���������� ��������","\n"WHITE"������� �����, ������� ����� ������������ �� ���������\n\n"GREY"����������: ��� ����� ���������\n\n","�����","�����");
		            return true;
		        }
		        new query[49-2-2+64+11];
		        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`description`='%e'where`id`='%i'",sscanf_description,player[playerid][id]);
		        mysql_query(mysql_connection,query);
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
	                format(string,sizeof(string),"\n"WHITE"������� ����� �������� ���������\n������� �������� - "BLUE"%s\n\n",player[playerid][description]);
	                ShowPlayerDialog(playerid,dDescriptionEditDesc,DIALOG_STYLE_INPUT,""BLUE"�������� ��������",string,"������","�����");
		            return true;
		        }
		        new query[49-2-2+64+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`description`='%e'where`id`='%i'",sscanf_description,player[playerid][id]);
				mysql_query(mysql_connection,query);
				strins(player[playerid][description],sscanf_description,0);
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� �������� �������� ���������!\n\n","�������","");
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
		        mysql_query(mysql_connection,query);
		        new string[70-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME];
		        new player_id=GetPVarInt(playerid,"invitePlayerId");
		        format(string,sizeof(string),"[F] "WHITE"%s"BLUE" ��������� ������ "WHITE"%s"BLUE" �� �������",player[player_id][name],player[playerid][name]);
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
				        format(string,sizeof(string),"%s ��� ���� � ����� ������!",player[temp_playerid][name]);
				        SendClientMessage(playerid,C_WHITE,string);
						SendClientMessage(temp_playerid,C_BLUE,"�� ���� ����� � ����� ������!");
						strdel(faction[i][leader],0,MAX_PLAYER_NAME);
						mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`leader`='-'where`id`='%i'",i+1);
						mysql_query(mysql_connection,query);
				        break;
				    }
				}
				player[temp_playerid][faction_id]=listitem+1;
				player[temp_playerid][rank_id]=11;
				strdel(faction[listitem][leader],0,MAX_PLAYER_NAME);
				strins(faction[listitem][leader],player[temp_playerid][name],0);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`faction_id`='%i',`rank_id`='11'where`id`='%i'",player[temp_playerid][faction_id],player[temp_playerid][id]);
				mysql_query(mysql_connection,query);
				mysql_format(mysql_connection,query,sizeof(query),"update`factions`set`leader`='%e'where`id`='%i'",player[temp_playerid][name],listitem+1);
				mysql_query(mysql_connection,query);
				format(string,sizeof(string),"�� ���� ��������� ������� ������� - "WHITE"%s",faction[listitem][name]);
				SendClientMessage(temp_playerid,C_BLUE,string);
				format(string,sizeof(string),"�� ��������� ������ "WHITE"%s"BLUE" ������� ������� - "WHITE"%s",player[temp_playerid][name],faction[listitem][name]);
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
				    format(string,sizeof(string),"�� ������� ������ � ������� "WHITE"(%s)"BLUE" �������������� "WHITE"%s",admin_commands[listitem],player[temp_playerid][name]);
				    format(temp_string,sizeof(string),"� ��� ������� ������ � ������� "WHITE"(%s)",admin_commands[listitem]);
				    admin[temp_playerid][commands][listitem]=0;
				}
				else{
				    format(string,sizeof(string),"�� ������ ������ � ������� "WHITE"(%s)"BLUE" �������������� "WHITE"%s",admin_commands[listitem],player[temp_playerid][name]);
				    format(temp_string,sizeof(string),"��� ������ ������ � ������� "WHITE"(%s)",admin_commands[listitem]);
				    admin[temp_playerid][commands][listitem]=1;
				}
				SendClientMessage(playerid,C_BLUE,string);
				SendClientMessage(temp_playerid,C_BLUE,temp_string);
				new temp_commands_ex[4];
				new temp_commands[sizeof(temp_commands_ex)*MAX_ADMIN_COMMANDS];
				for(new i=0; i<MAX_ADMIN_COMMANDS; i++){
				    if(i==MAX_ADMIN_COMMANDS-1){
				        format(temp_commands_ex,sizeof(temp_commands_ex),"%i",admin[temp_playerid][commands][i]);
				    }
				    else{
				        format(temp_commands_ex,sizeof(temp_commands_ex),"%i|",admin[temp_playerid][commands][i]);
				    }
				    strcat(temp_commands,temp_commands_ex);
				}
				new query[46-2-2+16+2];
				mysql_format(mysql_connection,query,sizeof(query),"update`admins`set`commands`='%s'where`id`='%i'",temp_commands,admin[temp_playerid][id]);
				mysql_query(mysql_connection,query);
	            DeletePVar(playerid,"giveaccessPlayerId");
		    }
		    else{
                DeletePVar(playerid,"giveaccessPlayerId");
		    }
		}
		case dFind:{
		    if(response){
		        if(!admin[playerid][commands][FIND]){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
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
		        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������� ������� ������",string,"�������","");
		        string="";
		    }
		}
		case dAdminPasswordCreate:{
 			if(response){
		        new sscanf_password[16];
				if(sscanf(inputtext,"s[128]",sscanf_password) || strlen(inputtext)<4 || strlen(inputtext)>16){
				    ShowPlayerDialog(playerid,dAdminPasswordCreate,DIALOG_STYLE_INPUT,""BLUE"��������� ������ ��������������","\n"WHITE"������� �������� ������ ��� ����������� � �����-������\n\n","������","�����");
				    return true;
				}
				new query[47-2-2+16+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`admins`set`password`='%e'where`id`='%i'",sscanf_password,admin[playerid][id]);
				mysql_query(mysql_connection,query);
				SendClientMessage(playerid,C_GREEN,"�� ���������� ������ ��� ����������� � �����-������!");
				SendClientMessage(playerid,C_GREEN,"��� ���������� ��������� �� ������!");
				SetTimerEx("@__kick_player",200,false,"i",playerid);
		    }
		    else{
		        SetTimerEx("@__kick_player",200,false,"i",playerid);
		    }
		}
		case dAdminPasswordInput:{
		    if(response){
		        new sscanf_password[16];
		        if(sscanf(inputtext,"s[128]",sscanf_password)){
		            ShowPlayerDialog(playerid,dAdminPasswordInput,DIALOG_STYLE_INPUT,""BLUE"����������� � �����-������","\n"WHITE"������� ������ ��� ����������� � �����-������\n\n","������","�����");
		            return true;
		        }
		        if(!strcmp(sscanf_password,admin[playerid][password])){
			        if(!strcmp(player[playerid][name],DEVELOPER)){
					    SendClientMessage(playerid,C_BLUE,"�� �������������� ��� ����������� �������!");
					    SetPVarInt(playerid,"IsPlayerDeveloper",1);
					}
					else{
						SendClientMessage(playerid,C_BLUE,"�� �������������� ��� ������������� �������!");
					}
					SetPVarInt(playerid,"PlayerLogged",1);
					TogglePlayerSpectating(playerid,false);
					SpawnPlayer(playerid);
				}
				else{
				    SendClientMessage(playerid,C_RED,"[����������] �� ����� ������������ ������ ��� ����������� � �����-������!");
                    SetTimerEx("@__kick_player",200,false,"i",playerid);
				}
		    }
		    else{
                SetTimerEx("@__kick_player",200,false,"i",playerid);
		    }
		}
		case dHome:{
		    if(response){
          		new cmdtext[2];
	            format(cmdtext,sizeof(cmdtext),"%i",listitem);
	            dc_cmd:home(playerid,cmdtext);
		    }
		}
		case dHomeMenu:{
		    if(response){
		        new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSelectedHouseid")];
				if(!owned_house_id[playerid][GetPVarInt(playerid,"tempSelectedHouseid")]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
				    DeletePVar(playerid,"tempSelectedHouseid");
				    return true;
				}
		        switch(listitem){
		            case 0:{
		                new string[77-2-2+4+11];
		                format(string,sizeof(string),"\n"WHITE"����� ���� - "BLUE"%i\n\n"WHITE"��������������� ���� - "BLUE"%i\n\n",houseid,house[houseid-1][cost]);
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ����",string,"�������","");
		            }
		            case 1:{
		                house[houseid-1][lock]=house[houseid-1][lock]?0:1;
		                new query[43-2-2+1+4];
		                mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`lock`='%i'where`id`='%i'",house[houseid-1][lock],houseid);
		                mysql_query(mysql_connection,query);
		                new cmdtext[2];
			            format(cmdtext,sizeof(cmdtext),"%i",GetPVarInt(playerid,"tempSelectedHouseid"));
			            dc_cmd:home(playerid,cmdtext);
		            }
		        }
		    }
		    else{
		        DeletePVar(playerid,"tempSelectedHouseid");
		    }
		}
		case dSellhome:{
		    if(response){
				SetPVarInt(playerid,"tempSellhomeHouseId",listitem);
		        ShowPlayerDialog(playerid,dSellhomeSelect,DIALOG_STYLE_LIST,""BLUE"������� ���","[0] ������� ��� ������\n[1] ������� ��� �����������","�������","������");
		    }
		}
		case dSellhomeSelect:{
		    if(response){
		        switch(listitem){
		            case 0:{
		                ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"������� ��� ������","\n"WHITE"������� ID ������ � ���� ����� �������\n\n"GREY"������: 25,25000\n\n","������","�����");
		            }
		            case 1:{
		                new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSellhomeHouseId")];
						new string[81-2+11];
						format(string,sizeof(string),"\n"WHITE"�� ������ ������� ��� �����������?\n\n���. ���� ���� - "GREEN"$%i\n\n",house[houseid-1][cost]);
						ShowPlayerDialog(playerid,dSellhomeState,DIALOG_STYLE_MSGBOX,""BLUE"������� ��� �����������",string,"��","���");
		            }
		        }
		    }
		}
		case dSellhomeWhom:{
		    if(response){
		        new sscanf_player, sscanf_cost;
		        if(sscanf(inputtext,"p<,>ui",sscanf_player,sscanf_cost)){
		            ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"������� ��� ������","\n"WHITE"������� ID ������ � ���� ����� �������\n\n"GREY"������: 25,25000\n\n","������","�����");
		            return true;
		        }
				if(owned_house_id[sscanf_player][MAX_OWNED_HOUSES-1]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"����� ������� ������������ ����������� �����!\n\n","�������","");
				    return true;
				}
		        if(sscanf_cost < 1 || sscanf_cost > 1000000){
		            ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"������� ��� ������","\n"WHITE"������� ID ������ � ���� ����� �������\n\n"GREY"������: 25,25000\n\n","������","�����");
		            return true;
		        }
		        if(sscanf_cost > player[sscanf_player][money]){
		            ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"������� ��� ������","\n"RED"� ������ ��� ������� �����!\n\n"WHITE"������� ID ������ � ���� ����� �������\n\n"GREY"������: 25,25000\n\n","������","�����");
		            return true;
		        }
				if(!GetPVarInt(sscanf_player,"PlayerLogged")){
				    ShowPlayerDialog(playerid,dSellhomeWhom,DIALOG_STYLE_INPUT,""BLUE"������� ��� ������","\n"RED"����� �� ��������� � �������!\n\n"WHITE"������� ID ������ � ���� ����� �������\n\n"GREY"������: 25,25000\n\n","������","�����");
				    return true;
				}
		        SetPVarInt(playerid,"tempSellhomePlayer",sscanf_player);
		        SetPVarInt(playerid,"tempSellhomeCost",sscanf_cost);
		        new string[135-2-2+MAX_PLAYER_NAME+4];
		        format(string,sizeof(string),"\n"WHITE"�� ����������� ������� ���� ��� ������ "BLUE"%s"WHITE" �� "GREEN"$%i\n\n"WHITE"�� ������������� ������ ������� ���?\n\n",player[sscanf_player][name],sscanf_cost);
		        ShowPlayerDialog(playerid,dSellhomeWhomConfirm,DIALOG_STYLE_MSGBOX,""BLUE"������� ���� ������",string,"��","���");
		    }
		}
		case dSellhomeWhomConfirm:{
		    if(response){
		        if(!GetPVarInt(playerid,"tempSellhomeCost")){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            DeletePVar(playerid,"tempSellhomePlayer");
					DeletePVar(playerid,"tempSellhomeCost");
					DeletePVar(playerid,"tempSellhomeHouseId");
		            return true;
		        }
				new player_id=GetPVarInt(playerid,"tempSellhomePlayer");
				if(!GetPVarInt(player_id,"PlayerLogged")){
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"������ ���� �������!\n����� ����� �� ����!\n\n","�������","");
					DeletePVar(playerid,"tempSellhomePlayer");
					DeletePVar(playerid,"tempSellhomeCost");
					DeletePVar(playerid,"tempSellhomeHouseId");
				    return true;
				}
				if(owned_house_id[player_id][MAX_OWNED_HOUSES-1]){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"����� ������� ������������ ����������� �����!\n\n","�������","");
				    DeletePVar(playerid,"tempSellhomePlayer");
					DeletePVar(playerid,"tempSellhomeCost");
					DeletePVar(playerid,"tempSellhomeHouseId");
				    return true;
				}
				SetPVarInt(player_id,"tempSellhomePlayerid",playerid);
				new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSellhomeHouseId")];
				new string[113-2-2-2+MAX_PLAYER_NAME+4+11];
				format(string,sizeof(string),"\n"BLUE"%s"WHITE" ���������� ��� ������ ��� ��� "BLUE"�%i"WHITE" �� "GREEN"$%i\n\n"WHITE"�� ��������?\n\n",player[playerid][name],houseid,GetPVarInt(playerid,"tempSellhomeCost"));
				ShowPlayerDialog(player_id,dSellhomeWhomConfirmPlayer,DIALOG_STYLE_MSGBOX,""BLUE"������� ����",string,"��","���");
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������� ����","\n"WHITE"������ �� ������� ���� ������� ������ ����������!\n\n","�������","");
		    }
		    else{
				DeletePVar(playerid,"tempSellhomePlayer");
				DeletePVar(playerid,"tempSellhomeCost");
				DeletePVar(playerid,"tempSellhomeHouseId");
		    }
		}
		case dSellhomeWhomConfirmPlayer:{
		    if(response){
				new player_id=GetPVarInt(playerid,"tempSellhomePlayerid");
				if(!GetPVarInt(player_id,"tempSellhomeCost") || !GetPVarInt(playerid,"PlayerLogged") || !GetPVarInt(player_id,"PlayerLogged")){
                    DeletePVar(playerid,"tempSellhomePlayerid");
	                DeletePVar(player_id,"tempSellhomePlayer");
					DeletePVar(player_id,"tempSellhomeCost");
					DeletePVar(player_id,"tempSellhomeHouseId");
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
				    ShowPlayerDialog(player_id,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
				    return true;
				}
				new string[75-2-2+MAX_PLAYER_NAME+11];
				format(string,sizeof(string),"\n"WHITE"�� ������ ��� � ������ "BLUE"%s"WHITE" �� "GREEN"$%i\n\n",player[player_id][name],GetPVarInt(player_id,"tempSellhomeCost"));
				ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������",string,"�������","");
				format(string,sizeof(string),"\n"WHITE"�� ������� ���� ��� ������ "BLUE"%s"WHITE" �� "GREEN"$%i\n\n",player[playerid][name],GetPVarInt(player_id,"tempSellhomeCost"));
				ShowPlayerDialog(player_id,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������",string,"�������","");
                new houseid=owned_house_id[player_id][GetPVarInt(player_id,"tempSellhomeHouseId")];
                strdel(house[houseid-1][owner],0,MAX_PLAYER_NAME);
                strins(house[houseid-1][owner],player[playerid][name],0);
				new query[44-2-2+MAX_PLAYER_NAME+4];
				mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`owner`='%e'where`id`='%i'",player[playerid][name],houseid);
				mysql_query(mysql_connection,query);
				player[playerid][money]-=GetPVarInt(player_id,"tempSellhomeCost");
				ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,player[playerid][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query);
				player[player_id][money]+=GetPVarInt(player_id,"tempSellhomeCost");
				ResetPlayerMoney(player_id);
				GivePlayerMoney(player_id,player[player_id][money]);
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[player_id][money],player[player_id][id]);
				mysql_query(mysql_connection,query);
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
				DeletePVar(player_id,"tempSellhomeHouseId");
		    }
			else{
			    new player_id=GetPVarInt(playerid,"tempSellhomePlayerid");
			    DeletePVar(playerid,"tempSellhomePlayerid");
                DeletePVar(player_id,"tempSellhomePlayer");
				DeletePVar(player_id,"tempSellhomeCost");
				DeletePVar(player_id,"tempSellhomeHouseId");
			}
		}
		case dSellhomeState:{
		    if(response){
		        new houseid=owned_house_id[playerid][GetPVarInt(playerid,"tempSellhomeHouseId")];
                strdel(house[houseid-1][owner],0,MAX_PLAYER_NAME);
                strins(house[houseid-1][owner],"-",0);
                DestroyDynamicPickup(house[houseid-1][pickupid]);
                house[houseid-1][pickupid]=CreateDynamicPickup(1273,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z]);
                new query[43-2+4];
				mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`owner`='-'where`id`='%i'",houseid);
				mysql_query(mysql_connection,query);
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
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            return true;
		        }
		        if(owned_house_id[playerid][MAX_OWNED_HOUSES-1]){
		            return true;
		        }
				if(!IsPlayerInRangeOfPoint(playerid,1.5,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z])){
				    return true;
				}
				if(player[playerid][money]<house[houseid-1][cost]){
                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"��������, �� � ��� ��� ������� �����!\n\n","�������","");
				    return true;
				}
				strdel(house[houseid-1],0,MAX_PLAYER_NAME);
				strins(house[houseid-1][owner],player[playerid][name],0);
				DestroyDynamicPickup(house[houseid-1][pickupid]);
				house[houseid-1][pickupid]=CreateDynamicPickup(1272,23,house[houseid-1][enter_x],house[houseid-1][enter_y],house[houseid-1][enter_z]);
				new query[44-2-2+MAX_PLAYER_NAME+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`owner`='%e'where`id`='%i'",player[playerid][name],houseid);
				mysql_query(mysql_connection,query);
				for(new i=0; i<MAX_OWNED_HOUSES; i++){
				    if(owned_house_id[playerid][i]){
				        continue;
				    }
				    owned_house_id[playerid][i]=houseid;
				    break;
				}
				player[playerid][money]-=house[houseid-1][cost];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query);
				SendClientMessage(playerid,C_BLUE,"[����������] �����������, �� ������ ���!");
				SendClientMessage(playerid,C_WHITE,"[����������] (( ������� ��� ���������� ����� /home (/hpanel - /hm - hmenu) ))");
				DeletePVar(playerid,"buyhomeHouseId");
		    }
		    else{
		        DeletePVar(playerid,"buyhomeHouseId");
		    }
		}
		case dCityHallAddHouse:{
		    if(response){
		        new string[180-2-2-2-2-2+(11*5)];
		        format(string,sizeof(string),"\n"WHITE"�������� ����� ��� ������ ����:\n\n1. A - "GREEN"$%i\n"WHITE"2. B - "GREEN"$%i\n"WHITE"3. C - "GREEN"$%i\n"WHITE"4. D - "GREEN"$%i\n"WHITE"5. E - "GREEN"$%i\n\n",GetSVarInt("Houses_Class_A"),GetSVarInt("Houses_Class_B"),GetSVarInt("Houses_Class_C"),GetSVarInt("Houses_Class_D"),GetSVarInt("Houses_Class_E"));
				ShowPlayerDialog(playerid,dCityHallAddHouseClass,DIALOG_STYLE_INPUT,""BLUE"���������� ����",string,"������","������");
			}
		}
		case dCityHallAddHouseClass:{
		    if(response){
		        new sscanf_class;
		        if(sscanf(inputtext,"i",sscanf_class) || strval(inputtext) < 1 || strval(inputtext) > 5){
		            new string[180-2-2-2-2-2+(11*5)];
			        format(string,sizeof(string),"\n"WHITE"�������� ����� ��� ������ ����:\n\n1. A - "GREEN"$%i\n"WHITE"2. B - "GREEN"$%i\n"WHITE"3. C - "GREEN"$%i\n"WHITE"4. D - "GREEN"$%i\n"WHITE"5. E - "GREEN"$%i\n\n",GetSVarInt("Houses_Class_A"),GetSVarInt("Houses_Class_B"),GetSVarInt("Houses_Class_C"),GetSVarInt("Houses_Class_D"),GetSVarInt("Houses_Class_E"));
					ShowPlayerDialog(playerid,dCityHallAddHouseClass,DIALOG_STYLE_INPUT,""BLUE"���������� ����",string,"������","������");
		            return true;
		        }
		        SetPVarInt(playerid,"AddHouse_Class",sscanf_class);
		        new temp_string[29-2+2+32+11];
		        static string[49+sizeof(temp_string)*MAX_HOUSE_INTERIORS+43];
		        strcat(string,"\n"WHITE"�������� �������� ��� ������ ����:\n\n");
		        for(new i=0; i<total_house_interiors; i++){
		            format(temp_string,sizeof(temp_string),""WHITE"%i. %s - "GREEN"$%i\n",i+1,house_interiors[i][description],house_interiors[i][price]);
		            strcat(string,temp_string);
		        }
		        strcat(string,"\n\n"GREY"�������� ����� �����������\n\n");
		        ShowPlayerDialog(playerid,dCityHallAddHouseInterior,DIALOG_STYLE_INPUT,""BLUE"���������� ����",string,"������","������");
		        string="\0";
		    }
		}
		case dCityHallAddHouseInterior:{
		    if(response){
				new sscanf_interior;
				if(sscanf(inputtext,"i",sscanf_interior)){
                    new temp_string[29-2+2+32+11];
			        static string[49+sizeof(temp_string)*MAX_HOUSE_INTERIORS+43];
			        strcat(string,"\n"WHITE"�������� �������� ��� ������ ����:\n\n");
			        for(new i=0; i<total_house_interiors; i++){
			            format(temp_string,sizeof(temp_string),""WHITE"%i. %s - "GREEN"$%i\n",i+1,house_interiors[i][description],house_interiors[i][price]);
			            strcat(string,temp_string);
			        }
			        strcat(string,"\n\n"GREY"�������� ����� �����������\n\n");
			        ShowPlayerDialog(playerid,dCityHallAddHouseInterior,DIALOG_STYLE_INPUT,""BLUE"���������� ����",string,"������","������");
			        string="\0";
				    return true;
				}
				SetPVarInt(playerid,"AddHouse_Interior",sscanf_interior);
				ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"���������� ����","[0] ����������� ��������� ��������\n[1] ������� ���� ��������\n[2] ��������� �������","������","������");
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
						SendClientMessage(playerid,-1,"[����������] ��� ������ �� ��������� ���������, ������� /exit_preview");
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
						format(string,sizeof(string),"\n"WHITE"����� ���� �� ��� �������� "GREEN"$%i\n\n"WHITE"�� ������ ����������?\n\n",GetPVarInt(playerid,"AddHouse_TotalCost"));
						ShowPlayerDialog(playerid,dCityHallAddHouseTotalCost,DIALOG_STYLE_MSGBOX,""BLUE"���������� ����",string,"��","���");
		            }
		            case 2:{
                        new temp_string[29-2+2+32+11];
				        static string[49+sizeof(temp_string)*MAX_HOUSE_INTERIORS+43];
				        strcat(string,"\n"WHITE"�������� �������� ��� ������ ����:\n\n");
				        for(new i=0; i<total_house_interiors; i++){
				            format(temp_string,sizeof(temp_string),""WHITE"%i. %s - "GREEN"$%i\n",i+1,house_interiors[i][description],house_interiors[i][price]);
				            strcat(string,temp_string);
				        }
				        strcat(string,"\n\n"GREY"�������� ����� �����������\n\n");
				        ShowPlayerDialog(playerid,dCityHallAddHouseInterior,DIALOG_STYLE_INPUT,""BLUE"���������� ����",string,"������","������");
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
					SendClientMessage(playerid,C_RED,"[����������] � ��� ��� ������� �����!");
					ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"���������� ����","[0] ����������� ��������� ��������\n[1] ������� ���� ��������\n[2] ��������� �������","������","������");
				    return true;
				}
				SendClientMessage(playerid,C_GREEN,"[����������] ��� ����� ������� �������������� ��� ������ �������� ����!");
				SendClientMessage(playerid,-1,"[����������] ��� ��������� ��������������, ����������� ������� /take_house");
				SetPVarInt(playerid,"AddHouse_SetHPos",1);
		    }
		    else{
                ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"���������� ����","[0] ����������� ��������� ��������\n[1] ������� ���� ��������\n[2] ��������� �������","������","������");
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
       			    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
					return true;
       			}
				strins(house[total_houses][owner],player[playerid][name],0);
       			house[total_houses][house_interior]=GetPVarInt(playerid,"AddHouse_Interior");
       			house[total_houses][enter_x]=GetPVarFloat(playerid,"AddHouse_HPosX");
       			house[total_houses][enter_y]=GetPVarFloat(playerid,"AddHouse_HPosY");
       			house[total_houses][enter_z]=GetPVarFloat(playerid,"AddHouse_HPosZ");
       			house[total_houses][enter_a]=GetPVarFloat(playerid,"AddHouse_HPosA");
       			house[total_houses][lock]=true;
       			house[total_houses][confirmed]=false;
       			house[total_houses][class]=GetPVarInt(playerid,"AddHouse_Class");
       			house[total_houses][cost]=GetPVarInt(playerid,"AddHouse_TotalCost");
       			new query[114-2-2-2-2-2-2-2-2+MAX_PLAYER_NAME+(11*4)+2+11+2];
       			mysql_format(mysql_connection,query,sizeof(query),"insert into`houses`(`owner`,`enter_pos`,`house_interior`,`cost`,`class`)values('%e','%f|%f|%f|%f','%i','%i','%i')",house[total_houses][owner],house[total_houses][enter_x],house[total_houses][enter_y],house[total_houses][enter_z],house[total_houses][enter_a],house[total_houses][house_interior],house[total_houses][class],house[total_houses][cost]);
       			mysql_query(mysql_connection,query);
       			house[total_houses][id]=cache_insert_id(mysql_connection);
       			new string[86-2+MAX_PLAYER_NAME];
				format(string,sizeof(string),"����� ���� - %i",house[total_houses][id]);
				house[total_houses][labelid]=CreateDynamic3DTextLabel(string,0xFFFFFFFF,house[total_houses][enter_x],house[total_houses][enter_y],house[total_houses][enter_z],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,0);
				house[total_houses][pickupid]=CreateDynamicPickup(1272,23,house[total_houses][enter_x],house[total_houses][enter_y],house[total_houses][enter_z],0,0);
				player[playerid][money]-=house[total_houses][cost];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`money`='%i'where`id`='%i'",player[playerid][money],player[playerid][id]);
				mysql_query(mysql_connection,query);
				for(new i=0; i<MAX_OWNED_HOUSES; i++){
		            if(owned_house_id[playerid][i]){
		                continue;
		            }
		            owned_house_id[playerid][i]=house[total_houses][id];
		            break;
		        }
		        format(string,sizeof(string),"[A][HOUSES]: ����� %s ��������� ����� ��� � �����! ���������� ����������� ����������!",player[playerid][name]);
		        SendAdminsMessage(C_RED,string);
       			total_houses++;
       			ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� ����","\n"WHITE"�� ���������� ����� ��� � �����!\n\n"GREY"����� ��� �������������� ������ ����������� �������������� ����\n\n","�������","");
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
		        ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� ����","\n"WHITE"�� ��������� ���������� ����!\n\n","�������","");
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
		                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_LIST,""BLUE"�������� �������",string,"�������","");
		            }
		            case 1:{
		                ShowPlayerDialog(playerid,dApanelProperty,DIALOG_STYLE_LIST,""BLUE"���������� �����������","[0] ���������� �����\n[1] ������������� ��������� �����","�������","�����");
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
						new Cache:cache_houses=mysql_query(mysql_connection,"select`cost`from`houses`");
						new total_cost=0;
						if(cache_get_row_count(mysql_connection)){
						    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
							    total_cost+=cache_get_field_content_int(i,"cost",mysql_connection);
							}
						}
						new average_cost=total_cost/cache_get_row_count(mysql_connection);
						new temp_string[55-2+11];
						new string[(42-2+11)+(55-2+11)+(53-2+11)+(52-2+11)+(55-2+11)];
						format(temp_string,sizeof(temp_string),"\n"WHITE"���������� ����� - "BLUE"%i\n\n",cache_get_row_count(mysql_connection));
						strcat(string,temp_string);
						cache_delete(cache_houses,mysql_connection);
						format(temp_string,sizeof(temp_string),""WHITE"��������� ��������� ���� ����� - "GREEN"$%i\n",total_cost);
						strcat(string,temp_string);
						format(temp_string,sizeof(temp_string),""WHITE"������� ��������� ���� ����� - "GREEN"$%i\n",average_cost);
						strcat(string,temp_string);
						cache_houses=mysql_query(mysql_connection,"select`cost`from`houses`order by`cost`asc limit 1");
						new lower_cost=0;
						if(cache_get_row_count(mysql_connection)){
						    lower_cost=cache_get_field_content_int(0,"cost",mysql_connection);
						}
						format(temp_string,sizeof(temp_string),""WHITE"����� ������ ��������� ���� - "GREEN"$%i\n",lower_cost);
						strcat(string,temp_string);
						cache_delete(cache_houses);
						cache_houses=mysql_query(mysql_connection,"select`cost`from`houses`order by`cost`desc limit 1");
						new higher_cost=0;
						if(cache_get_row_count(mysql_connection)){
						    higher_cost=cache_get_field_content_int(0,"cost",mysql_connection);
						}
						format(temp_string,sizeof(temp_string),""WHITE"����� ������� ��������� ���� - "GREEN"$%i\n\n",higher_cost);
						strcat(string,temp_string);
						cache_delete(cache_houses);
						ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� �����",string,"�������","");
				    }
				    case 1:{
				        new temp_string[7-2+4];
				        static string[8+sizeof(temp_string)*100]=""WHITE"";
						new Cache:cache_houses=mysql_query(mysql_connection,"select`id`from`houses`where`confirmed`='0'order by`id`asc limit 100");
						new temp_id;
						if(cache_get_row_count(mysql_connection)){
						    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
						        temp_id=cache_get_field_content_int(i,"id",mysql_connection);
						        format(temp_string,sizeof(temp_string),!(i % 5) ? "\n%i\t" : "%i\t",temp_id);
						        strcat(string,temp_string);
						    }
						}
						strcat(string,"\n\n������� ID ������ �� �����:\n\n");
						ShowPlayerDialog(playerid,dApanelPropertyConfirmList,DIALOG_STYLE_INPUT,""BLUE"������������� ��������� �����",string,"�������","�����");
						cache_delete(cache_houses,mysql_connection);
						string="\0";
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
		            new temp_string[7-2+4];
			        static string[8+sizeof(temp_string)*100]=""WHITE"";
					new Cache:cache_houses=mysql_query(mysql_connection,"select`id`from`houses`where`confirmed`='0'order by`id`asc limit 100");
					new temp_id;
					if(cache_get_row_count(mysql_connection)){
					    for(new i=0; i<cache_get_row_count(mysql_connection); i++){
					        temp_id=cache_get_field_content_int(i,"id",mysql_connection);
					        format(temp_string,sizeof(temp_string),!(i % 5) ? "\n%i\t" : "%i\t",temp_id);
					        strcat(string,temp_string);
					    }
					}
					strcat(string,"\n\n������� ID ������ �� �����:\n\n");
					ShowPlayerDialog(playerid,dApanelPropertyConfirmList,DIALOG_STYLE_INPUT,""BLUE"������������� ��������� �����",string,"�������","�����");
					cache_delete(cache_houses,mysql_connection);
					string="\0";
		            return true;
		        }
		        SetPVarInt(playerid,"ApanelConfirm_HouseId",sscanf_houseid);
		        ShowPlayerDialog(playerid,dApanelPropertyConfirmMenu,DIALOG_STYLE_LIST,""BLUE"������������� ��������� �����","[0] ����������������� � ����\n[1] �������� ���������� ����\n[2] ����������� ���������� ����","�������","�����");
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
		                SendClientMessage(playerid,-1,"[����������] ��� ��������� ����� ���������, ����������� ������� /change_house");
		            }
		            case 2:{
		                new query[73-2-2-2-2-2+(11*5)];
						if(GetPVarInt(playerid,"ApanelConfirm_ChangeHouse")){
						    house[houseid-1][enter_x]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseX");
						    house[houseid-1][enter_y]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseY");
						    house[houseid-1][enter_z]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseZ");
						    house[houseid-1][enter_a]=GetPVarFloat(playerid,"ApanelConfirm_ChangeHouseA");
						    mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`enter_pos`='%f|%f|%f|%f',`confirmed`='1'where`id`='%i'",house[houseid-1][enter_x],house[houseid-1][enter_x],house[houseid-1][enter_x],house[houseid-1][enter_x],house[houseid-1][id]);
						}
						else{
						    mysql_format(mysql_connection,query,sizeof(query),"update`houses`set`confirmed`='%i'where`id`='%i'",house[houseid-1][id]);
						}
						house[houseid-1][confirmed]=1;
						mysql_query(mysql_connection,query);
		            }
		        }
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
	    SetPlayerVirtualWorld(playerid,1+random(MAX_PLAYERS));
	    SetPlayerInterior(playerid,5);
		SetPlayerSkin(playerid,player[playerid][character]=characters[player[playerid][origin]][player[playerid][gender]][GetPVarInt(playerid,"PlayerChoiceCharacterNumber")]);
	    return true;
	}
	if(!GetPVarInt(playerid,"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[����������] �� ������ ��������������!");
	    SetTimerEx("@__kick_player",250,false,"i",playerid);
	    return true;
	}
	if(GetPVarInt(playerid,"InteriorID")!=-1){
	    SetPVarInt(playerid,"InteriorID",-1);
	}
	SetPlayerPos(playerid,1895.7316,-1682.5453,13.4989);
	SetPlayerFacingAngle(playerid,90.0);
	SetPlayerSkin(playerid,player[playerid][character]);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,player[playerid][money]);
	SetPlayerScore(playerid,player[playerid][level]);
	#if defined SERVER_OBT
	    SendClientMessage(playerid,-1,"����������� ����� ���!");
	    SendClientMessage(playerid,-1,"��������� ������� - /setmoney /payday_time /giveadmin /givecmd /givecmd_id");
	#endif
	return true;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys){
	#pragma unused oldkeys
	if((gettime()-GetPVarInt(playerid,"FloodKeyState"))<1){
	    return true;
	}
	SetPVarInt(playerid,"FloodKeyState",gettime());
	if(newkeys & KEY_ANALOG_LEFT){
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
	else if(newkeys & KEY_ANALOG_RIGHT){
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
	else if(newkeys & KEY_CTRL_BACK){
	    if(!IsPlayerInAnyVehicle(playerid)){
		    for(new i=0; i<total_entrance; i++){
		        if(IsPlayerInRangeOfPoint(playerid,1.5,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z]) && GetPVarInt(playerid,"InteriorID")==-1){
					if(entrance[i][locked]){
					    SendClientMessage(playerid,C_RED,"[����������] ����� �������!");
						break;
					}
		            SetPlayerPos(playerid,entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z]);
		            SetPlayerFacingAngle(playerid,entrance[i][enter_a]);
		            SetPlayerInterior(playerid,entrance[i][interior]);
		            SetPlayerVirtualWorld(playerid,entrance[i][virtualworld]);
		            SetCameraBehindPlayer(playerid);
					SetPVarInt(playerid,"InteriorID",i);
		            break;
		        }
		        else if(IsPlayerInRangeOfPoint(playerid,1.5,entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z]) && GetPVarInt(playerid,"InteriorID")==i){
		            if(entrance[i][locked]){
					    SendClientMessage(playerid,C_RED,"[����������] ����� �������!");
						break;
					}
					SetPlayerPos(playerid,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z]);
		            SetPlayerFacingAngle(playerid,entrance[i][exit_a]);
		            SetPlayerInterior(playerid,0);
		            SetPlayerVirtualWorld(playerid,0);
		            SetCameraBehindPlayer(playerid);
		            SetPVarInt(playerid,"InteriorID",-1);
		            break;
		        }
		    }
			if(IsPlayerInRangeOfPoint(playerid,1.5,1410.7482,-1689.8737,39.6919)){
				if(GetPVarInt(playerid,"Bank_CreatingAccount")){
				    DeletePVar(playerid,"Bank_CreatingAccount");
	                DeletePVar(playerid,"Bank_CreatingAccountDescription");
	                DeletePVar(playerid,"Bank_CreatingAccountPassword");
				}
				if(player[playerid][passport_id]<100000){
				    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"� ��� ��� ��������!\n\n","�������","");
				    return true;
				}
			    new query[47-2+MAX_PLAYER_NAME];
			    mysql_format(mysql_connection,query,sizeof(query),"select`id`from`bank_accounts`where`owner`='%e'",player[playerid][name]);
			    new Cache:cache_bank_accounts=mysql_query(mysql_connection,query);
			    new string[96-2+11];
			    format(string,sizeof(string),cache_get_row_count(mysql_connection)?"\n"WHITE"�� ������ ������� ����� ���������� ����?\n\n"GREY"������� ���������� ������ - %i\n\n":"\n"WHITE"�� ������ ������� ����� ���������� ����?\n\n",cache_get_row_count(mysql_connection));
				ShowPlayerDialog(playerid,dBankCreateAccount,DIALOG_STYLE_MSGBOX,""BLUE"�������� ����������� �����",string,"��","���");
				cache_delete(cache_bank_accounts,mysql_connection);
			    return true;
			}
			if((IsPlayerInRangeOfPoint(playerid,1.0,1409.9199,-1673.3026,39.6990) || IsPlayerInRangeOfPoint(playerid,1.0,1409.9199,-1676.4822,39.6990) || IsPlayerInRangeOfPoint(playerid,1.0,1409.9199,-1679.5331,39.6990))){
				if(GetPVarInt(playerid,"tempBankAccount")){
					DeletePVar(playerid,"tempBankAccount");
				}
				ShowPlayerDialog(playerid,dBankAccountInput,DIALOG_STYLE_INPUT,""BLUE"���������� ����","\n"WHITE"������� ����� ������ ����������� �����\n\n"GREY"(( ���������: /menu [0] [3] ))\n\n","������","������");
				return true;
			}
			for(new i=0; i<total_houses; i++){
                if(IsPlayerInRangeOfPoint(playerid,1.5,house[i][enter_x],house[i][enter_y],house[i][enter_z])){
                    if(house[i][lock]){
                        SendClientMessage(playerid,C_RED,"[����������] ����� �������!");
                        break;
                    }
                    new hi_id=house[i][house_interior]-1;
					SetPlayerPos(playerid,house_interiors[hi_id][pos_x],house_interiors[hi_id][pos_y],house_interiors[hi_id][pos_z]);
					SetPlayerFacingAngle(playerid,house_interiors[hi_id][pos_a]);
					SetPlayerInterior(playerid,house_interiors[hi_id][interior]);
					SetPVarInt(playerid,"HouseID",i);
					new string[32-2+MAX_PLAYER_NAME];
					if(strcmp(house[i][owner],"-")){
						format(string,sizeof(string),"[����������] �������� ���� - %s",house[i][owner]);
						SendClientMessage(playerid,C_GREEN,string);
					}
					break;
                }
			}
			for(new i=0; i<total_house_interiors; i++){
                if(IsPlayerInRangeOfPoint(playerid,1.5,house_interiors[i][pos_x],house_interiors[i][pos_y],house_interiors[i][pos_z])){
                    new hi_id=GetPVarInt(playerid,"HouseID");
                    SetPlayerPos(playerid,house[hi_id][enter_x],house[hi_id][enter_y],house[hi_id][enter_z]);
                    SetPlayerFacingAngle(playerid,house[hi_id][enter_a]);
                    SetPlayerInterior(playerid,0);
                    DeletePVar(playerid,"HouseID");
                    break;
                }
			}
			if(IsPlayerInRangeOfPoint(playerid,1.5,1489.6801,-1774.6840,1006.0600)){
				ShowPlayerDialog(playerid,dCityHallInf,DIALOG_STYLE_LIST,""BLUE"����������","[0] ��������� ��������\n[1] ��������� ���������� �� ��������� ����","�������","������");
			    return true;
			}
			if(IsPlayerInRangeOfPoint(playerid,1.5,1488.3724,-1794.8727,1009.5559)){
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
					mysql_query(mysql_connection,query);
					mysql_format(mysql_connection,query,sizeof(query),"update`passports`set`taken`='1'where`id`='%i'",temp_id);
					mysql_query(mysql_connection,query);
					new string[78-2+11];
					format(string,sizeof(string),"\n"WHITE"����������� � ���������� ��������!\n����� �������� - "BLUE"%i\n\n",temp_id);
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������",string,"�������","");
					DeletePVar(playerid,"passportAge");
	                DeletePVar(playerid,"passportSignature");
	                DeletePVar(playerid,"passportDate");
	                DeletePVar(playerid,"passportValidality");
	                DeletePVar(playerid,"passportDays");
			        return true;
			    }
			    else if(GetPVarInt(playerid,"PayFeeForPassport")==1 || GetPVarInt(playerid,"PayFeeForPassport")==2){//������� � ���� �� �������
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� ������ �������� ������� �� ������� � �����!\n\n","�������","");
					return true;
				}
			    else if(!GetPVarInt(playerid,"PayFeeForPassport") && !player[playerid][passport_id]){
			    	ShowPlayerDialog(playerid,dCityHallTakePassport,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������","\n"WHITE"��� ��������� ��������, ���������� ��������� ��������� ������\n�� ������ ����������?\n\n","��","���");
			    	return true;
				}
				else if(player[playerid][passport_id] && cache_get_row_count(mysql_connection) && temp_taken){
				    new temp_valid_to;
				    temp_valid_to=cache_get_field_content_int(0,"valid_to",mysql_connection);
				    SetPVarInt(playerid,"renewalPassportValidality",temp_valid_to);
				    if(gettime()>=temp_valid_to){
						ShowPlayerDialog(playerid,dCityHallDelOrRenewalPassport,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������","\n"WHITE"���� �������� ������ �������� ����!\n�� ������ �������� ���, ���� �������� �����!\n\n","��������","�����");
				    }
			    	else{
				        new string[55-2+31];
					    format(string,sizeof(string),"\n"WHITE"��� ������� ������������ �� - "BLUE"%s\n\n",gettimestamp(temp_valid_to));
						ShowPlayerDialog(playerid,dCityHallRenewalPassport,DIALOG_STYLE_MSGBOX,""BLUE"��������� ��������",string,"��������","������");
				    }
				}
				cache_delete(cache_passports,mysql_connection);
			    return true;
			}
			if(IsPlayerInRangeOfPoint(playerid,1.5,1406.3860,-1689.8207,39.6919)){
			    ShowPlayerDialog(playerid,dBankPaymentService,DIALOG_STYLE_LIST,""BLUE"������ �����","[0] ������ ������� �� �������\n[1] ������ ������� �� ��������� ��������","�������","������");
				return true;
			}
		    if(IsPlayerInRangeOfPoint(playerid,1.0,faction[player[playerid][faction_id]][clothes_x],faction[player[playerid][faction_id]][clothes_y],faction[player[playerid][faction_id]][clothes_z])){
		        switch(GetPVarInt(playerid,"factionDuty")){
		            case 0:{
		                SetPVarInt(playerid,"factionDuty",1);
		                SendClientMessage(playerid,C_GREEN,"[����������] �� ������ ������� ����!");
		                SetPlayerSkin(playerid,faction[player[playerid][faction_id]][skin][player[playerid][rank_id]-1]);
		                return true;
		            }
		            case 1:{
		                SetPVarInt(playerid,"factionDuty",0);
		                SendClientMessage(playerid,C_GREEN,"[����������] �� ��������� ������� ����!");
		                SetPlayerSkin(playerid,player[playerid][character]);
						return true;
		            }
		        }
		    }
		    if(IsPlayerInRangeOfPoint(playerid,1.5,1486.1400,-1759.5725,1009.5559)){
		        if(player[playerid][passport_id]<100000){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"� ��� ��� ��������!\n\n","�������","");
		            return true;
		        }
		        if(owned_house_id[playerid][MAX_OWNED_HOUSES-1]){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"WHITE"�� ������ ������������ ���������� ��������� �����!\n\n","�������","");
		            return true;
		        }
		        if(GetPVarInt(playerid,"AddHouse_SetHPos") && (!GetPVarFloat(playerid,"AddHouse_HPosX") || !GetPVarFloat(playerid,"AddHouse_HPosY") || !GetPVarFloat(playerid,"AddHouse_HPosZ"))){
					ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� ����","\n"WHITE"�� ��� �� ��������� ���������� ��� �������� ����!\n\n","�������","");
		            return true;
		        }
		        if(GetPVarInt(playerid,"AddHouse_SetHPos") && GetPVarFloat(playerid,"AddHouse_HPosX") && GetPVarFloat(playerid,"AddHouse_HPosY") && GetPVarFloat(playerid,"AddHouse_HPosZ")){
		            new string[104-2+11];
		            format(string,sizeof(string),"\n"WHITE"�� ������ ���������� ��� � ��������� �����������?\n\n��� ���������� ��������� "GREEN"$%i\n\n",GetPVarInt(playerid,"AddHouse_TotalCost"));
		            ShowPlayerDialog(playerid,dCityHallAddHouseConfirm,DIALOG_STYLE_MSGBOX,""BLUE"���������� ����",string,"��","���");
		            return true;
		        }
		        ShowPlayerDialog(playerid,dCityHallAddHouse,DIALOG_STYLE_MSGBOX,""BLUE"���������� ����","\n"WHITE"�� ������ ���������� ����� ��� � �����?\n\n","��","���");
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
	new string[17-2-2+128+MAX_PLAYER_NAME];
	format(string,sizeof(string),"- %s - ������ %s",text,player[playerid][name]);
	ProxDetector(15.0,playerid,string,-1,-1,-1,-1,-1);
	return false;
}

/*      ��������� ��������      */

@__kick_player(playerid);
@__kick_player(playerid){
	Kick(playerid);
	return true;
}

@__general_timer();
@__general_timer(){
	foreach(new i:Player){
	    if(GetPVarInt(i,"PlayerLogged")){
	        if(payday[i][time]>=PAYDAY_TIME && !payday[i][taken]){
				SendClientMessage(i,C_GREEN,"[����������] �� ������ ������� ���� ��������!");
				SendClientMessage(i,-1,"[����������] (( ������� /takecheque ��� ��������� �������� ))");
				payday[i][taken]=true;
			}
	        if(!payday[i][taken]){
				payday[i][time]++;
			}
	    }
	}
	SetTimer("@__general_timer",1000,false);
	return true;
}

@__payday(playerid);
@__payday(playerid){
	if(GetPVarInt(playerid,"PlayerLogged")){
		if(payday[playerid][time]<PAYDAY_TIME && !payday[playerid][taken]){
		    return true;
		}
	    new string_promocode[36-2+MAX_PROMOCODE_LEN];
	    new string_new_level[24];
	    player[playerid][experience]++;
	    payday[playerid][time]=0;
		payday[playerid][taken]=false;
	    if(player[playerid][experience]>=player[playerid][level]*NEEDED_EXPERIENCE){
			strins(string_new_level,"��� ������� �������\n",0,sizeof(string_new_level));
			player[playerid][experience]=(player[playerid][experience]-(player[playerid][level]*NEEDED_EXPERIENCE));
	        player[playerid][level]++;
			SetPlayerScore(playerid,player[playerid][level]);
	        if(strlen(player[playerid][referal_name])>=MIN_PROMOCODE_LEN){
	            new query[84-2+MAX_PROMOCODE_LEN];
	            if(player[playerid][level]==NEEDED_LEVEL_FOR_REFERAL_TO_TAKE_MONEY && !player[playerid][experience]){
					mysql_format(mysql_connection,query,sizeof(query),"select`payday`,`name`from`users`where`name`='%e'",player[playerid][referal_name]);
					new Cache:cache_users=mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
						new temp_payday[24], temp_name[MAX_PLAYER_NAME], arr_payday[3];
						cache_get_field_content(0,"payday_money",temp_payday,mysql_connection,sizeof(temp_payday));
						sscanf(temp_payday,"p<|>i[3]",arr_payday);
						cache_get_field_content(0,"name",temp_name,mysql_connection,sizeof(temp_name));
						new temp_playerid;
						sscanf(temp_name,"u",temp_playerid);
						if(GetPVarInt(temp_playerid,"PlayerLogged")){
						    format(string_promocode,sizeof(string_promocode),"�� �������� ����� �� ������������� ������ - %s\n",player[playerid][name]);
						    payday[temp_playerid][salary]+=50000;
						    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`payday`='%i|%i|%i'where`id`='%i'",payday[temp_playerid][time],payday[temp_playerid][salary],payday[temp_playerid][taken],player[temp_playerid][id]);
						}
						else{
						    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`payday`='%i|%i|%i'where`name`='%e'",arr_payday[0],arr_payday[1]+50000,arr_payday[2],temp_name);
						}
						mysql_query(mysql_connection,query);
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
						format(string_experience,sizeof(string_experience),temp_experience?" %i �����":"",temp_experience);
						format(string_promocode,sizeof(string_promocode),"�� �������� ����� [%s%s ] �� ��������� - %s\n",temp_money,temp_experience,temp_promocode);
	                }
	            }
	            cache_delete(cache_promocodes,mysql_connection);
	        }
	        new query[43-2-2+11+11];
	        mysql_format(mysql_connection,query,sizeof(query),"update`users`set`level`='%i'where`id`='%i'",player[playerid][level],player[playerid][id]);
	        mysql_query(mysql_connection,query);
	    }
	    new string[92-2-2-2-2+11+11+sizeof(string_promocode)+sizeof(string_new_level)];
	    format(string,sizeof(string),"\n\n"GREY"\t[ ����� ���� �%i ]\n\n"WHITE"��������\t%i\n\n"GREY"�������������:\n%s%s\n",GetSVarInt("sCheque"),payday[playerid][salary],string_promocode,string_new_level);
	    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������",string,"�������","");
	    new query[74-2-2-2-2+5+11+11+11];
	    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`experience`='%i',`payday`='0|%i|0'where`id`='%i'",player[playerid][experience],payday[playerid][salary],player[playerid][id]);
	    mysql_query(mysql_connection,query);
	    SetSVarInt("sCheque",GetSVarInt("sCheque")+1);
	    mysql_format(mysql_connection,query,sizeof(query),"update`general`set`cheque`='%i'",GetSVarInt("sCheque"));
	    mysql_query(mysql_connection,query);
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

forward OnPlayerCommandReceived(playerid, cmdtext[]);
public OnPlayerCommandReceived(playerid, cmdtext[]){
    if(!GetPVarInt(playerid,"PlayerLogged")){
        return false;
    }
    return true;
}

gettimestamp (timestamp, _form=0)
{
    new
        year=1970, day=0, month=0, hour=0, mins=0, sec=0,
		days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 },
    	names_of_month[12][10] = {"January","February","March","April","May","June","July","August","September","October","November","December"},
    	returnstring[32];

    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) timestamp -= 86400;
        year++;
    }

    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;


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

/*      ------------------      */

/*      ������� �������         */

CMD:menu(playerid){
	ShowPlayerDialog(playerid,dMainMenu,DIALOG_STYLE_LIST,""BLUE"Main Menu","[0] ���������� � ���������\n[1] ����������� �������\n[2] ������ �� �������","�������","������");
	return true;
}

ALTX:menu("/mn","/mm");

CMD:takecheque(playerid){
	if(!payday[playerid][taken] && payday[playerid][time]<PAYDAY_TIME){
	    SendClientMessage(playerid,C_RED,"[����������] �� ���� ��� �� ��������� �����!");
	    return true;
	}
	@__payday(playerid);
	return true;
}

CMD:todo(playerid,params[]){
	new text[64],action[64];
	if(sscanf(params,"p<*>s[128]s[128]",text,action)){
	    SendClientMessage(playerid,C_GREY,"�����������: /todo [ ���������*�������� ]");
	    return true;
	}
	static string[22+64+64-2-2-2+MAX_PLAYER_NAME+9];
	format(string,sizeof(string),"- %s - ������ %s - "RED"%s",text,player[playerid][name],action);
	ProxDetector(15.0,playerid,string,-1,-1,-1,-1,-1);
	format(string,sizeof(string),"%s "RED"* %s",text,action);
	SetPlayerChatBubble(playerid,string,-1,15.0,4000);
	string="";
	return true;
}

CMD:me(playerid,params[]){
	if(sscanf(params,"s[128]",params[0])){
        SendClientMessage(playerid,C_GREY,"�����������: /me [ �������� ]");
	    return true;
	}
	new string[8-2-2+MAX_PLAYER_NAME+128];
	format(string,sizeof(string),"%s - %s",player[playerid][name],params[0]);
	ProxDetector(15.0,playerid,string,C_RED,C_RED,C_RED,C_RED,C_RED);
	SetPlayerChatBubble(playerid,string,C_RED,15.0,4000);
	return true;
}

CMD:do(playerid,params[]){
	if(sscanf(params,"s[128]",params[0])){
        SendClientMessage(playerid,C_GREY,"�����������: /do [ �������� �� �������� ���� ]");
	    return true;
	}
	new string[14-2-2+128+MAX_PLAYER_NAME];
	format(string,sizeof(string),"%s - (( %s ))",params[0],player[playerid][name]);
	ProxDetector(15.0,playerid,string,C_RED,C_RED,C_RED,C_RED,C_RED);
	format(string,sizeof(string),"(( %s ))",params[0]);
	SetPlayerChatBubble(playerid,string,C_RED,15.0,4000);
	return true;
}

CMD:try(playerid,params[]){
	if(sscanf(params,"s[128]",params[0])){
	    SendClientMessage(playerid,C_GREY,"�����������: /try [ �������� ]");
	    return true;
	}
	new rand=random(2);
	new string[21-2-2-2+MAX_PLAYER_NAME+128+10];
	format(string,sizeof(string),"%s - %s | "GREY"%s",player[playerid][name],params[0],rand?"������":"�� ������");
    ProxDetector(15.0,playerid,string,C_RED,C_RED,C_RED,C_RED,C_RED);
    format(string,sizeof(string),"%s | "GREY"%s",params[0],rand?"������":"�� ������");
    SetPlayerChatBubble(playerid,string,C_RED,15.0,4000);
	return true;
}

ALTX:try("/coin");

CMD:shout(playerid,params[]){
	if(sscanf(params,"s[128]",params[0])){
	    SendClientMessage(playerid,C_GREY,"�����������: /shout [ ��������� ] "WHITE"- ��������");
	    return true;
	}
	new string[17-2-2+MAX_PLAYER_NAME+128];
	format(string,sizeof(string),"- %s - ������� %s",params[0],player[playerid][name]);
	ProxDetector(25.0,playerid,string,-1,-1,-1,-1,-1);
	format(string,sizeof(string),"[S] %s",params[0]);
	SetPlayerChatBubble(playerid,string,-1,25.0,4000);
	return true;
}

ALTX:shout("/s");

CMD:whisper(playerid,params[]){
	new text[64];
	if(sscanf(params,"is[128]",params[0],text)){
	    SendClientMessage(playerid,C_GREY,"�����������: /whisper [ id ������ ] [ ��������� ] "WHITE"- ����������");
	    return true;
	}
	if(params[0] == playerid){
	    return true;
	}
	new Float:temp_x,Float:temp_y,Float:temp_z;
	GetPlayerPos(params[0],temp_x,temp_y,temp_z);
	if(!IsPlayerInRangeOfPoint(playerid,2.0,temp_x,temp_y,temp_z)){
	    SendClientMessage(playerid,C_RED,"[����������] �� ���������� ������ �� ������!");
	    return true;
	}
	new string[24-2-2+64+MAX_PLAYER_NAME];
	format(string,sizeof(string),"- %s - ��� ��������� %s",text,player[playerid][name]);
	SendSplitClientMessage(params[0],C_GREEN,string);
	format(string,sizeof(string),"- %s - �� ���������� %s",text,player[params[0]][name]);
	SendSplitClientMessage(playerid,C_GREEN,string);
	return true;
}

ALTX:whisper("/w");

CMD:n(playerid,params[]){
	if(sscanf(params,"s[128]",params[0])){
        SendClientMessage(playerid,C_GREY,"�����������: /n [ ��������� ] "WHITE"- OOC ����������");
	    return true;
	}
	new string[23-2-2+128+MAX_PLAYER_NAME];
	format(string,sizeof(string),"(( - %s - ������ %s ))",params[0],player[playerid][name]);
	ProxDetector(15.0,playerid,string,C_GREY,C_GREY,C_GREY,C_GREY,C_GREY);
	format(string,sizeof(string),"(( %s ))",params[0]);
	SetPlayerChatBubble(playerid,string,C_GREY,15.0,4000);
	return true;
}

ALTX:n("/b");

CMD:description(playerid){
	ShowPlayerDialog(playerid,dDescription,DIALOG_STYLE_LIST,""BLUE"�������� ���������","[0] ���������� ��������� ��������\n[1] ���������� � ��������� ��������\n[2] ���������� ���������� ��������\n[3] �������� ��������\n[4] ������ ��������","�������","������");
	return true;
}

ALTX:description("/desc");

// ������� ��� �������

CMD:invite(playerid,params[]){
	if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[����������] �� ������ ���������� �� �������!");
	    return true;
	}
	if(player[playerid][rank_id]!=11){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ����� �������!");
	    return true;
	}
	if(sscanf(params,"u",params[0])){
	    SendClientMessage(playerid,C_GREY,"�����������: /invite [ id ������/����� ���� ] "WHITE"- ���������� ������ �� �������");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[����������] ����� �� ����������� �� �������!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������� �� ������� ������ ����!");
	    return true;
	}
	new Float:temp_x,Float:temp_y,Float:temp_z;
	GetPlayerPos(params[0],temp_x,temp_y,temp_z);
	if(!IsPlayerInRangeOfPoint(playerid,5.0,temp_x,temp_y,temp_z)){
	    SendClientMessage(playerid,C_RED,"[����������] ����� ��������� ������ �� ���!");
	    return true;
	}
	if(player[params[0]][faction_id]){
	    SendClientMessage(playerid,C_RED,"[����������] ����� ��� ��������� �� �������!");
	    return true;
	}
	SetPVarInt(params[0],"invitePlayerId",playerid);
	SetPVarInt(params[0],"inviteFactionId",player[playerid][faction_id]);
	new string[84-2-2+MAX_PLAYER_NAME+32];
	format(string,sizeof(string),"\n"WHITE"�� ���� ���������� ������� "BLUE"%s"WHITE" �� ������� - "BLUE"%s\n\n",player[playerid][name],faction[player[playerid][faction_id]][name]);
	ShowPlayerDialog(params[0],dInviteConfirm,DIALOG_STYLE_MSGBOX,""BLUE"����������� �� �������",string,"�������","����������");
	return true;
}

CMD:uninvite(playerid,params[]){
    if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[����������] �� ������ ���������� �� �������!");
	    return true;
	}
	if(player[playerid][rank_id]!=11){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ����� �������!");
	    return true;
	}
	new reason[32];
	if(sscanf(params,"us[128]",params[0],reason)){
	    SendClientMessage(playerid,C_GREY,"�����������: /uninvite [ id ������/����� ���� ] [ ������� ] "WHITE"- ������� ������ �� �������");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[����������] ����� �� ����������� �� �������!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������� �� ������� ������ ����!");
	    return true;
	}
	if(player[params[0]][faction_id]!=player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[����������] ����� ��������� �� � ����� �������!");
	    return true;
	}
	new string[81-2-2-2+MAX_PLAYER_NAME+MAX_PLAYER_NAME+sizeof(reason)];
	format(string,sizeof(string),"[F] "WHITE"%s"BLUE" ������ ������ "WHITE"%s"BLUE" �� �������. �������: "WHITE"%s",player[playerid][name],player[params[0]][name],reason);
	SendFactionMessage(player[playerid][faction_id],C_BLUE,string);
	player[params[0]][faction_id]=0;
	player[params[0]][rank_id]=0;
	new query[61-2+11];
	mysql_format(mysql_connection,query,sizeof(query),"update`users`set`faction_id`='0',`rank_id`='0'where`id`='%i'",player[params[0]][id]);
	mysql_query(mysql_connection,query);
	return true;
}

CMD:giverank(playerid,params[]){
    if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[����������] �� ������ ���������� �� �������!");
	    return true;
	}
	if(player[playerid][rank_id]!=11){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ����� �������!");
	    return true;
	}
	new rank[2];
	if(sscanf(params,"us[128]",params[0],rank)){
	    SendClientMessage(playerid,C_GREY,"�����������: /giverank [ id ������/����� ���� ] [ + / - ]");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[����������] ����� �� ����������� �� �������!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ��������/�������� ������ ����!");
	    return true;
	}
	if(player[params[0]][faction_id]!=player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[����������] ����� ��������� �� � ����� �������!");
	    return true;
	}
	if(!strcmp(rank,"+")){
	    if(player[params[0]][rank_id]==9){
	        SendClientMessage(playerid,C_RED,"[����������] ����� ����� ��� ������������ ��������� �� �������!");
	        return true;
		}
		player[params[0]][rank_id]++;
		new string[75-2-2-2+MAX_PLAYER_NAME+24+2];
		format(string,sizeof(string),"�� �������� ������ "WHITE"%s"BLUE" �� ��������� "WHITE"%s "GREY"(%i)",player[params[0]][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(playerid,C_BLUE,string);
		format(string,sizeof(string),"%s "BLUE"������� ��� �� ��������� "WHITE"%s "GREY"(%i)",player[playerid][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(params[0],C_WHITE,string);
	}
	else if(!strcmp(rank,"-")){
		if(player[params[0]][rank_id]==1){
		    SendClientMessage(playerid,C_RED,"[����������] ����� ����� ��� ����������� ��������� �� �������!");
		    return true;
		}
		player[params[0]][rank_id]--;
		new string[75-2-2-2+MAX_PLAYER_NAME+24+2];
		format(string,sizeof(string),"�� �������� ������ "WHITE"%s"BLUE" �� ��������� "WHITE"%s "GREY"(%i)",player[params[0]][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(playerid,C_BLUE,string);
		format(string,sizeof(string),"%s "BLUE"������� ��� �� ��������� "WHITE"%s "GREY"(%i)",player[playerid][name],faction_ranks[player[params[0]][faction_id]-1][player[params[0]][rank_id]-1],player[params[0]][rank_id]);
		SendClientMessage(params[0],C_WHITE,string);
	}
	else{
	    SendClientMessage(playerid,C_GREY,"�����������: /giverank [ id ������/����� ���� ] [ + / - ]");
	    return true;
	}
	new query[45-2-2+2+11];
	mysql_format(mysql_connection,query,sizeof(query),"update`users`set`rank_id`='%i'where`id`='%i'",player[params[0]][rank_id],player[params[0]][id]);
	mysql_query(mysql_connection,query);
	return true;
}

CMD:faction(playerid,params[]){
    if(!player[playerid][faction_id]){
	    SendClientMessage(playerid,C_RED,"[����������] �� ������ ���������� �� �������!");
	    return true;
	}
	if(sscanf(params,"s[128]",params[0])){
	    SendClientMessage(playerid,C_GREY,"�����������: /faction [ ��������� ]");
	    return true;
	}
	new string[11-2-2-2+24+MAX_PLAYER_NAME+128];
	format(string,sizeof(string),"[F] %s %s: %s",faction_ranks[player[playerid][faction_id]-1][player[playerid][rank_id]-1],player[playerid][name],params[0]);
	SendFactionMessage(player[playerid][faction_id],C_BLUE,string);
	return true;
}

ALTX:faction("/f");

CMD:find(playerid){
	if(!admin[playerid][commands][FIND]){
	    if(!player[playerid][faction_id]){
		    SendClientMessage(playerid,C_RED,"[����������] �� ������ ���������� �� �������!");
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
		ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������� ������� ������",string,"�������","");
		string="";
	}
	else{
	    new temp_string[10-2-2+2+24];
	    static string[sizeof(temp_string)*MAX_FACTIONS];
		for(new i=0; i<total_factions; i++){
		    format(temp_string,sizeof(temp_string),"[%i] %s\n",i+1,faction[i][name]);
		    strcat(string,temp_string);
		}
		ShowPlayerDialog(playerid,dFind,DIALOG_STYLE_LIST,""BLUE"�������� ������� �������",string,"�������","������");
		string="";
	}
	return true;
}

ALTX:find("/members");

// ������� ��� ���������� �����

CMD:home(playerid,params[]){
	if(!owned_house_id[playerid][0]){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� �������� ����!");
	   	return true;
	}
	if(sscanf(params,"i",params[0])){
		new temp_string[11-2-2+1+4];
		new string[sizeof(temp_string)*MAX_OWNED_HOUSES];
		for(new i=0; i<MAX_OWNED_HOUSES; i++){
		    if(!owned_house_id[playerid][i]){
		        continue;
		    }
			format(temp_string,sizeof(temp_string),"[%i] �%i\n",i,owned_house_id[playerid][i]);
			strcat(string,temp_string);
		}
		ShowPlayerDialog(playerid,dHome,DIALOG_STYLE_LIST,""BLUE"������ ���������� �����",string,"�������","������");
		return true;
	}
	if(!owned_house_id[playerid][params[0]]){
	    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
	    return true;
	}
	new temp_lock[16];
	new string[67-2+sizeof(temp_lock)];
	new houseid=owned_house_id[playerid][params[0]];
	temp_lock=house[houseid-1][lock]?""RED"������":""GREEN"������";
    format(string,sizeof(string),"[0] ���������� � ����\n[1] ����� - %s",temp_lock);
    SetPVarInt(playerid,"tempSelectedHouseid",params[0]);
    ShowPlayerDialog(playerid,dHomeMenu,DIALOG_STYLE_LIST,""BLUE"������ ���������� �����",string,"�������","������");
	return true;
}

ALTX:home("/hmenu","/hpanel","/hm");

CMD:sellhome(playerid){
	if(!owned_house_id[playerid][0]){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� �������� ����!");
	    return true;
	}
	new temp_string[11-2-2+1+4];
	new string[sizeof(temp_string)*MAX_OWNED_HOUSES];
	for(new i=0; i<MAX_OWNED_HOUSES; i++){
		if(!owned_house_id[playerid][i]){
		    continue;
		}
		format(temp_string,sizeof(temp_string),"[%i] �%i\n",i,owned_house_id[playerid][i]);
		strcat(string,temp_string);
	}
	ShowPlayerDialog(playerid,dSellhome,DIALOG_STYLE_LIST,""BLUE"������� ���",string,"�������","������");
	return true;
}

ALTX:sellhome("/sellhouse");

CMD:buyhome(playerid){
	if(owned_house_id[playerid][MAX_OWNED_HOUSES-1]){
	    SendClientMessage(playerid,C_RED,"[����������] �� �������� ������������ ����������� �����!");
	    return true;
	}
	new string[132-2-2+4+11];
	for(new i=0; i<total_houses; i++){
	    if(IsPlayerInRangeOfPoint(playerid,1.5,house[i][enter_x],house[i][enter_y],house[i][enter_z])){
	        new houseid=i+1;
			format(string,sizeof(string),"\n"WHITE"�� ����������� ������ ��� "BLUE"�%i\n"WHITE"��������������� ���� - "GREEN"$%i\n"WHITE"�� ������ ������ ���� ���?\n\n",houseid,house[i][cost]);
			ShowPlayerDialog(playerid,dBuyhome,DIALOG_STYLE_MSGBOX,""BLUE"������� ����",string,"��","���");
			SetPVarInt(playerid,"buyhomeHouseId",houseid);
		}
	}
	return true;
}

ALTX:buyhome("/buyhouse");

CMD:exit_preview(playerid){
	if(!GetPVarInt(playerid,"AddHouse_Preview")){
	    return true;
	}
	if(!GetPVarFloat(playerid,"AddHouse_PPosX") || !GetPVarFloat(playerid,"AddHouse_PPosY") || !GetPVarFloat(playerid,"AddHouse_PPosZ")){
		ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""RED"������!",""WHITE"��������, ��������� ������!","�������","");
		DeletePVar(playerid,"AddHouse_Preview");
		DeletePVar(playerid,"AddHouse_PPosX");
		DeletePVar(playerid,"AddHouse_PPosY");
		DeletePVar(playerid,"AddHouse_PPosZ");
		DeletePVar(playerid,"AddHouse_PPosA");
		SpawnPlayer(playerid);
	    return true;
	}
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,1);//����������� ��� �����
	SetPlayerPos(playerid,GetPVarFloat(playerid,"AddHouse_PPosX"),GetPVarFloat(playerid,"AddHouse_PPosY"),GetPVarFloat(playerid,"AddHouse_PPosZ"));
	SetPlayerFacingAngle(playerid,GetPVarFloat(playerid,"AddHouse_PPosA"));
    DeletePVar(playerid,"AddHouse_Preview");
	DeletePVar(playerid,"AddHouse_PPosX");
	DeletePVar(playerid,"AddHouse_PPosY");
	DeletePVar(playerid,"AddHouse_PPosZ");
	DeletePVar(playerid,"AddHouse_PPosA");
	ShowPlayerDialog(playerid,dCityHallAddHousePreview,DIALOG_STYLE_LIST,""BLUE"���������� ����","[0] ����������� ��������� ��������\n[1] ������� ���� ��������\n[2] ��������� �������","������","������");
	return true;
}

CMD:take_house(playerid){
	if(!GetPVarInt(playerid,"AddHouse_SetHPos")){
	    return true;
	}
	if(GetPVarFloat(playerid,"AddHouse_HPosX") || GetPVarFloat(playerid,"AddHouse_HPosY") || GetPVarFloat(playerid,"AddHouse_HPosZ") || GetPVarFloat(playerid,"AddHouse_HPosA")){
	    SendClientMessage(playerid,C_RED,"[����������] �� ��� ��������� ���������� ��� ������ ����!");
	    return true;
	}
	if(GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid)){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ���������� ���� � ��������� ��� ����. ����!");
	    return true;
	}
	for(new i=0; i<total_houses; i++){
		if(IsPlayerInRangeOfPoint(playerid,2.5,house[i][enter_x],house[i][enter_y],house[i][enter_z])){
		    SendClientMessage(playerid,C_RED,"[����������] �� ������ ���������� ���� � ���� �����!");
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
	ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� ����","\n"WHITE"��� ����� ��������� ������� � �����!\n\n","�������","");
	return true;
}

//������� ��� ���������������

CMD:admins(playerid){
	if(!admin[playerid][commands][ADMINS]){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������� � ���� �������!");
	    return true;
	}
	new Cache:admins=mysql_query(mysql_connection,"select`name`from`admins");
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
		ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"�������������� �������",string,"�������","");
		string="";
	}
	else{
	    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"����������","\n"BLUE"��������, ��������� ������!\n\n","�������","");
	}
	cache_delete(admins,mysql_connection);
	return true;
}

CMD:makeleader(playerid,params[]){
	if(!admin[playerid][commands][MAKELEADER]){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������ � ���� �������!");
	    return true;
	}
	if(sscanf(params,"u",params[0])){
	    SendClientMessage(playerid,C_GREY,"�����������: /makeleader [ id ������/����� ���� ]");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[����������] ����� �� ����������� �� �������!");
	    return true;
	}
	if(params[0] == playerid){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ��������� ������� ������ ����!");
	    return true;
	}
	SetPVarInt(playerid,"makeleaderPlayerId",params[0]);
	new temp_string[13-2-2-2+2+32+MAX_PLAYER_NAME];
	static string[sizeof(temp_string)*MAX_FACTIONS];
	for(new i=0; i<total_factions; i++){
	    format(temp_string,sizeof(temp_string),"%i\t%s\t%s\n",i+1,faction[i][name],faction[i][leader]);
		strcat(string,temp_string);
	}
	ShowPlayerDialog(playerid,dMakeleader,DIALOG_STYLE_LIST,""BLUE"���������� ������ �� ���� ������",string,"�������","������");
	string="";
	return true;
}

CMD:achat(playerid,params[]){
	if(!admin[playerid][commands][ACHAT]){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������ � ���� �������!");
	    return true;
	}
	if(sscanf(params,"s[128]",params[0])){
	    SendClientMessage(playerid,C_GREY,"�����������: /achat [ ��������� ]");
	    return true;
	}
	new string[16-2-2-2+MAX_PLAYER_NAME+4+128];
	format(string,sizeof(string),"[A] %s [%i]: %s",player[playerid][name],playerid,params[0]);
	SendAdminsMessage(C_RED,string);
	return true;
}

CMD:giveaccess(playerid,params[]){
	if(!GetPVarInt(playerid,"IsPlayerDeveloper")){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������ � ���� �������!");
	    return true;
	}
	if(sscanf(params,"u",params[0])){
	    SendClientMessage(playerid,C_GREY,"�����������: /giveaccess [ id ������/����� ���� ]");
	    return true;
	}
	if(!GetPVarInt(params[0],"PlayerLogged")){
	    SendClientMessage(playerid,C_RED,"[����������] ����� �� ����������� �� �������!");
	    return true;
	}
	SetPVarInt(playerid,"giveaccessPlayerId",params[0]);
	new temp_string[13-2-2-2+2+16+24];
	static string[sizeof(temp_string)*MAX_ADMIN_COMMANDS];
	new temp_access[24];
	for(new i=0; i<MAX_ADMIN_COMMANDS; i++){
	    temp_access=admin[params[0]][commands][i]?""GREEN"[���� ������]":""RED"[��� �������]";
	    format(temp_string,sizeof(temp_string),"[%i] %s %s\n",i,admin_commands[i],temp_access);
	    strcat(string,temp_string);
	}
	ShowPlayerDialog(playerid,dGiveaccess,DIALOG_STYLE_LIST,""BLUE"������ ������ � �������",string,"�������","������");
	string="";
	return true;
}

CMD:apanel(playerid){
	if(!admin[playerid][commands][APANEL]){
	    SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������ � ���� �������!");
	    return true;
	}
	ShowPlayerDialog(playerid,dApanel,DIALOG_STYLE_LIST,""BLUE"������ ��������������","[0] ��������� �������\n[1] ���������� �����������","�������","������");
	return true;
}

CMD:change_house(playerid){
	if(admin[playerid][commands][APANEL]){
        SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������ � ���� �������!");
	    return true;
	}
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
	SendClientMessage(playerid,C_GREEN,"[����������] �� ���������� ����� ���������� ��� ����!");
	return true;
}

//////////////////////////////////////////////// ������� ��� ������

#if defined SERVER_OBT

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
	    SendClientMessage(playerid,-1,"OBT: � ��� ��� ���� ����� ��������������!");
	    SendClientMessage(playerid,-1,"OBT: ����������� /givecmd");
	}
	else{
	    mysql_format(mysql_connection,query,sizeof(query),"insert into`admins`(`name`)values('%e')",player[playerid][name]);
	    mysql_query(mysql_connection,query);
		admin[playerid][id]=cache_insert_id(mysql_connection);
	    SendClientMessage(playerid,-1,"OBT: ��� ������ ����� ��������������!");
	    SendClientMessage(playerid,-1,"OBT: ����������� /givecmd");
	}
	cache_delete(cache_admins,mysql_connection);
	return true;
}

CMD:givecmd(playerid,params[]){
    if(!admin[playerid][id]){
	    SendClientMessage(playerid,-1,"OBT: �� �� �������������! (/giveadmin)");
	    return true;
	}
	if(sscanf(params,"i",params[0])){
	    SendClientMessage(playerid,-1,"OBT: /givecmd [ command id(/givecmd_id) ]");
	    return true;
	}
	new temp_access[8];
	temp_access=admin[playerid][commands][params[0]]?"�������":"������";
	admin[playerid][commands][params[0]]=admin[playerid][commands][params[0]]?0:1;
	new string[31-2-2+8+sizeof(admin_commands)];
	format(string,sizeof(string),"OBT: �� %s ������ � ������� %s",temp_access,admin_commands[params[0]]);
	SendClientMessage(playerid,-1,string);
	return true;
}

CMD:givecmd_id(playerid){
	new temp_string[8-2-2+2+sizeof(admin_commands)];
	new string[sizeof(temp_string)*MAX_ADMIN_COMMANDS];
	for(new i=0; i<MAX_ADMIN_COMMANDS; i++){
	    format(temp_string,sizeof(temp_string),"[%i] %s",i,admin_commands[i]);
	    strcat(string,temp_string);
	}
	ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST,""BLUE"������� ��������������",string,"�������","");
	return true;
}

#endif

CMD:tp(playerid){
	SetPlayerPos(playerid,1491.8193,-1774.6887,1006.0600);
	SetPlayerFacingAngle(playerid,91.0740);
	return true;
}
