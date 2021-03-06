
// Doshirak RP - D1maz. - vk.com/d1maz.myzt3ry

/*      �������     */

#include <a_samp>
main();
#include <a_mysql>
#include <sscanf2>
#include <regex>
#include <crashdetect>
#include <streamer>
#include <doshirak\objects>
#include <dc_cmd>
#include <doshirak\textdraws>
#include <foreach>
#include <doshirak\colors>
#include <doshirak\3dtexts>
#include <doshirak\pickups>

/*      �������     */

// ��������� ����������� � ��

#define MYSQL_HOST "localhost" // ������, � �������� ����� ������������
#define MYSQL_USER "root" // ������������, ��� ������� ����� ��������
#define MYSQL_DATABASE "doshirak" // ����, ������� �����������
#define MYSQL_PASSWORD "" // ������ �� ������������
new mysql_connection; // ������ �����������

// ������

#undef MAX_PLAYERS // ������� ������
#define MAX_PLAYERS (1000) // ������ ������, ������ 1000
#define MAX_ENTRANCE (32) // ������������ ���������� ������

#define MAX_PASSWORD_LEN (24) // ������������ ����� ������
#define MIN_PASSWORD_LEN (4) // ����������� ����� ������
#define MAX_EMAIL_LEN (32) // ������������ ����� �����
#define MIN_EMAIL_LEN (10) // ����������� ����� �����
#define MAX_PROMOCODE_LEN (32) // ������������ ����� ���������
#define MIN_PROMOCODE_LEN (4) // ����������� ����� ���������

#define PAYDAY_TIME (30*60) // �����, ����������� ��� ��������� ��������
#define NEEDED_EXPERIENCE (3) // ���������� �����, ����������� ��� ��������� ������

/*      ����������  */

// �������� �� IP

new check_ip_for_reconnect[MAX_PLAYERS][16],//������� ���������� ���������� ��� ������ IP ������
	check_ip_for_reconnect_time[MAX_PLAYERS];//���������� ���������� ��� ������ �������

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
	reg_ip[16],// ��������������� IP =
	reg_date[32],// ���� �����������
	money,//������ ���������
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
	dMainMenuReferalSystem,
	dMainMenuReferalSystemInfo,
	dMainMenuReferalSystemDelete,
	dMainMenuReferalSystemCreate,
	dMainMenuReferalSystemCrLevel,
	dMainMenuReferalSystemCrMoney,
	dMainMenuReferalSystemCrExp,
	dMainMenuReferalSystemCrConfirm,
	dMainMenuInfAboutPers,
	dMainMenuInfAboutPersCharacter,
	dMainMenuInfAboutPersAccount,
	dMainMenuInfAboutPersConnects,
	dBankCreateAccount,
	dBankCreateAccountDescription,
	dBankCreateAccountPassword,
	dBankCreateAccountConfirm
}

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
	time,
	salary,
	bool:taken
}

new payday[MAX_PLAYERS][paydayINFO];

enum entranceINFO{
	id,
	description[64],
	locked,
	Float:enter_x,
	Float:enter_y,
	Float:enter_z,
	Float:enter_a,
	Float:exit_x,
	Float:exit_y,
	Float:exit_z,
	Float:exit_a,
	interior,
	virtualworld,
	pickupid[2],
	Text3D:labelid[2]
}

new entrance[MAX_ENTRANCE][entranceINFO];
new total_entrance;

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
	mysql_set_charset("cp1251",mysql_connection);
	mysql_log(LOG_DEBUG);//�������� ����� �����
	mysql_query(mysql_connection,"select*from`general`");
	if(cache_get_row_count(mysql_connection)){
	    new temp_time=GetTickCount();
	    print(""MYSQL_DATABASE": �������� ������ �� ������� `general`");
	    new temp_cheque;
	    temp_cheque=cache_get_field_content_int(0,"cheque",mysql_connection);
	    printf("\t- `cheque` = '%i'",temp_cheque);
	    SetSVarInt("sCheque",temp_cheque);
	    printf(""MYSQL_DATABASE": ������ �� ������� `general` ��������� �� %ims",GetTickCount()-temp_time);
	}
	else{
	    print(""MYSQL_DATABASE": ������ � ������� `general` �� �������!");
	}
	mysql_query(mysql_connection,"select*from`entrance`");
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
	            printf(""MYSQL_DATABASE": `id` = '%i' ����� ����������� ����������: x%f|y%f|z%f|x%f|y%f|z%f",i,entrance[i][enter_x],entrance[i][enter_y],entrance[i][enter_z],entrance[i][exit_x],entrance[i][exit_y],entrance[i][exit_z]);
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
	SetGameModeText("Doshirak v0.001");//������ �������� ���� ��� �������
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
	GetPlayerIp(playerid,check_ip_for_reconnect[playerid],16);//���������� IP ����� � ���������� ����������
	GetPlayerName(playerid,player[playerid][name],MAX_PLAYER_NAME);//������� ������� ������ � ����������
	new query[36-2+MAX_PLAYER_NAME];// ��������� ���������� ��� �������
	mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",player[playerid][name]);// ����������� "����������" ������ � ���� ������
	mysql_query(mysql_connection,query);// ���������� ������ � ���� ������
	if(cache_get_row_count(mysql_connection)){// ���� � ���� ���� ������ ���� ����� � ���������� ���������
		new string[118-2+MAX_PLAYER_NAME];// ������ ���������� ��� ��������������
		format(string,sizeof(string),"\n"WHITE"����� ���������� �� "BLUE"Doshirak RP!"WHITE"\n��� ���������� ��������������!\n��� �����: "BLUE"%s\n\n",player[playerid][name]);//����������� �����
		ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");
	}
	else{// ���� � ���� ��� �� ������ ���� � ���������
	    new string[122-2+MAX_PLAYER_NAME];
	    format(string,sizeof(string),"\n"WHITE"����� ���������� �� "BLUE"Doshirak RP!"WHITE"\n��� ���������� ������������������!\n��� �����: "BLUE"%s\n\n",player[playerid][name]);
	    ShowPlayerDialog(playerid,dRegistration,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");
	}
	RemovePlayerObjects(playerid);//������� ������� ��� ������ (doshirak\objects)
	TogglePlayerSpectating(playerid,true);//��������� ������ � ����� ��������
	return true;
}

public OnPlayerDisconnect(playerid,reason){
	if(GetPVarInt(playerid,"PlayerLogged")){
		new temp_payday[24];
		format(temp_payday,sizeof(temp_payday),"%i|%i|%i",payday[playerid][time],payday[playerid][salary],payday[playerid][taken]);
	    new query[96-2-2-2-2-2-2-2-2+16+16+sizeof(temp_payday)+11];
	    mysql_format(mysql_connection,query,sizeof(query),"update`users`set`payday`='%e'where`id`='%i'",temp_payday,player[playerid][id]);
	    mysql_query(mysql_connection,query);
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
                new temp_ip[16],temp_day,temp_month,temp_year,temp_hour,temp_minute;
			    GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
			    getdate(temp_year,temp_month,temp_day);
			    gettime(temp_hour,temp_minute,_);
                mysql_format(mysql_connection,query,sizeof(query),"insert into`users`(`name`,`password`,`reg_ip`,`reg_date`)values('%e','%e','%e','%02i/%02i/%d %02i:%02i')",player[playerid][name],sscanf_password,temp_ip,temp_day,temp_month,temp_year,temp_hour,temp_minute);// ����������� "����������" ������ �������� ������ � ���� ������
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
				mysql_query(mysql_connection,query);// ���������� ������ � ��
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
				mysql_query(mysql_connection,query);//���������� ������ � ��
				if(cache_get_row_count(mysql_connection)){// ���� ����� ����� �������, ���� ������, ��...
				    new temp_ip[16];
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'and`reg_ip`='%e'",sscanf_referal_name,temp_ip);
					mysql_query(mysql_connection,query);
					if(cache_get_row_count(mysql_connection)){
					    ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n","������","����������");
						SendClientMessage(playerid,C_RED,"[����������] �� �� ������ ������� ���� �������!");
					    return true;
					}
				    strins(player[playerid][referal_name],sscanf_referal_name,0);//���������� �������� ���� ����� � ����������
				    SendClientMessage(playerid,C_BLUE,"[����������] �� ���� ���������� ������� �� ��������!");//������� ��������� � ������� � ���� ������
                    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ���������� ������� ������� ������ ���������\n"BLUE"������: (16 - 60)\n\n","������","�����");
					//������� ������ � ������ �������� ���������
				}
				else{//���� ����� ����� ���, ��...
				    mysql_format(mysql_connection,query,sizeof(query),"select`creator`from`promocodes`where`promocode`='%e'",sscanf_referal_name);//����������� ������ � ������������ ������
				    mysql_query(mysql_connection,query);// ���������� ������
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
				        if(!regex_match(sscanf_referal_name,"[a-zA-Z0-9_#@!]+") || strlen(sscanf_referal_name)<MIN_PROMOCODE_LEN || strlen(sscanf_referal_name)>MAX_PROMOCODE_LEN){
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
				}
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
				mysql_query(mysql_connection,query);
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
					SetPVarInt(playerid,"PlayerLogged",1);
					new temp_ip[16],temp_day,temp_month,temp_year,temp_hour,temp_minute;
					GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));
					getdate(temp_year,temp_month,temp_day);
					gettime(temp_hour,temp_minute,_);
					mysql_format(mysql_connection,query,sizeof(query),"insert into`connects`(`id`,`date`,`ip`)values('%i','%02i/%02i/%i %02i:%02i','%e')",player[playerid][id],temp_day,temp_month,temp_year,temp_hour,temp_minute,temp_ip);
					mysql_query(mysql_connection,query);
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
					if(GetPVarInt(playerid,"PasswordAttempts")<=0){
					    ShowPlayerDialog(playerid,NULL,NULL,"","","","");
					    SendClientMessage(playerid,C_RED,"[����������] �� ����� ������������ ������ ��� ���� � ���� �������!");
					    SetTimerEx("@__kick_player",250,false,"i",playerid);
					    return true;
					}
				}
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
						ShowPlayerDialog(playerid,dMainMenuInfAboutPers,DIALOG_STYLE_LIST,""BLUE"���������� � ���������","[0] ���������� � ���������\n[1] ���������� �� ��������\n[2] ���������� � ��������� ������������","�������","�����");
		            }
		            case 1:{
		                ShowPlayerDialog(playerid,dMainMenuReferalSystem,DIALOG_STYLE_LIST,""BLUE"����������� �������","[0] ����������\n[1] �������\\������� ��������\n[2] ���������� � ���������\n[3] ������ ���, ��� ��� ��� ��������\n[4] ������ ���, ��� ��� ��� �������","�������","�����");
		            }
		        }
		    }
		}
		case dMainMenuReferalSystem:{
			if(response){
			    switch(listitem){
			        case 0:{
						new string[492];
						strcat(string,"\n"WHITE"�� ������� ��������� ������������������� ����������� �������.\n");
						strcat(string,"�� ������ ������� ���� �������� � ������������ ���������� � ����������������.\n");
						strcat(string,"��� �������� ���������, �� ������ ��������� �������, ��� ���������� ��������\n");
						strcat(string,"����� ����� �������� ����������� ��������������.(������,����)\n");
						strcat(string,"������������� ��������� ������, ������ ��������� ��������.\n");
						strcat(string,"\n"GREY"�� ��������� �� ��������!\n");
						strcat(string,"�������� ����� ������� ������ � VIP ���������!\n");
						strcat(string,"��� ����� ��������� ��� �������� �� IP!\n\n");
						ShowPlayerDialog(playerid,dMainMenuReferalSystemInfo,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ����������� �������",string,"�����","");
			        }
			        case 1:{
						new query[53-2+MAX_PLAYER_NAME];
						mysql_format(mysql_connection,query,sizeof(query),"select`promocode`from`promocodes`where`creator`='%e'",player[playerid][name]);
						mysql_query(mysql_connection,query);
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
			        }
			        case 2:{
			            new query[45-2+MAX_PROMOCODE_LEN];
			            mysql_format(mysql_connection,query,sizeof(query),"select*from`promocodes`where`creator`='%e'",player[playerid][name]);
			            mysql_query(mysql_connection,query);
			            if(cache_get_row_count(mysql_connection)){
							new temp_id,temp_money,temp_experience,temp_level,temp_created[24],temp_promocode[MAX_PROMOCODE_LEN];
                            temp_id=cache_get_field_content_int(0,"id",mysql_connection);
                            temp_money=cache_get_field_content_int(0,"money",mysql_connection);
                            temp_experience=cache_get_field_content_int(0,"experience",mysql_connection);
                            temp_level=cache_get_field_content_int(0,"level",mysql_connection);
                            cache_get_field_content(0,"created",temp_created,mysql_connection,sizeof(temp_created));
                            cache_get_field_content(0,"promocode",temp_promocode,mysql_connection,MAX_PROMOCODE_LEN);
                            mysql_format(mysql_connection,query,sizeof(query),"select`referal_name`from`users`where`referal_name`='%e'",temp_promocode);
                            mysql_query(mysql_connection,query);
                            new string[327-2-2-2-2-2-2-2+11+MAX_PROMOCODE_LEN+24+4+5+3+11];
                            format(string,sizeof(string),"\n"WHITE"ID ��������� -\t\t"BLUE"%d\n"WHITE"�������� ��������� -\t"BLUE"%s\n"WHITE"���� �������� -\t\t"BLUE"%s\n\n"GREY"������:\n"WHITE"��������� ������� -\t"BLUE"%d\n"WHITE"���������� ����� -\t\t"BLUE"%d\n"WHITE"���������� ����� -\t\t"BLUE"%d\n\n"GREY"���������� �������, ������� ����� �������� - %d\n\n",temp_id,temp_promocode,temp_created,temp_level,temp_money,temp_experience,cache_get_row_count(mysql_connection));
							ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ���������",string,"�������","");
			            }
			            else{
			                if(!strlen(player[playerid][referal_name])){
			                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"� ��� ��� ������\\������������ ���������!\n\n","�������","");
			                }
							mysql_format(mysql_connection,query,sizeof(query),"select*from`promocodes`where`promocode`='%e'",player[playerid][referal_name]);
							mysql_query(mysql_connection,query);
							if(cache_get_row_count(mysql_connection)){
								new temp_id,temp_creator[MAX_PLAYER_NAME],temp_promocode[MAX_PROMOCODE_LEN],temp_created[24];
								temp_id=cache_get_field_content_int(0,"id",mysql_connection);
								cache_get_field_content(0,"creator",temp_creator,mysql_connection,MAX_PLAYER_NAME);
								cache_get_field_content(0,"promocode",temp_promocode,mysql_connection,MAX_PROMOCODE_LEN);
								cache_get_field_content(0,"created",temp_created,mysql_connection,sizeof(temp_created));
								mysql_format(mysql_connection,query,sizeof(query),"select`referal_name`from`users`where`referal_name`='%e'",temp_promocode);
								mysql_query(mysql_connection,query);
								new string[208-2-2-2-2-2+11+MAX_PROMOCODE_LEN+MAX_PLAYER_NAME+24+11+4+8];
								format(string,sizeof(string),"\n"WHITE"ID ��������� -\t\t"BLUE"%d\n"WHITE"�������� ��������� -\t"BLUE"%s\n"WHITE"��������� -\t\t\t"BLUE"%s\n"WHITE"���� �������� -\t\t"BLUE"%s\n\n"GREY"���������� �������, ������� ����� �������� - %d\n\n",temp_id,temp_promocode,temp_creator,temp_created,cache_get_row_count(mysql_connection));
								ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ���������",string,"�������","");
							}
							else{
							    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
							}
			            }
			        }
			        case 3:{//������ ���, ��� ��� ��������
			            new query[61-2+MAX_PROMOCODE_LEN];
			            mysql_format(mysql_connection,query,sizeof(query),"select`promocode`,`level`from`promocodes`where`creator`='%e'",player[playerid][name]);
			            mysql_query(mysql_connection,query);
			            if(cache_get_row_count(mysql_connection)){
			                new temp_promocode[MAX_PROMOCODE_LEN], temp_plevel;
			                cache_get_field_content(0,"promocode",temp_promocode,mysql_connection,sizeof(temp_promocode));
			                temp_plevel=cache_get_field_content_int(0,"level",mysql_connection);
			                mysql_format(mysql_connection,query,sizeof(query),"select`name`,`level`from`users`where`referal_name`='%e'",temp_promocode);
			                mysql_query(mysql_connection,query);
			                if(cache_get_row_count(mysql_connection)){
			                    new string[512+61]=""BLUE"�������\t"BLUE"������ �����������\t"BLUE"�����\n";
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
			                        format(temp_string,sizeof(temp_string),""WHITE"%s\t%s[%d]\t%s\n",temp_name,temp_playerid,temp_connect,temp_bonus);
			                        strcat(string,temp_string);
			                    }
			                    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"������ �������, ��� ��� ��������",string,"�������","");
			                }
			                else{
                                ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������","\n"WHITE"��� �������� ��� ����� �� ��������!\n\n","�������","");
			                }
			            }
			            else{
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"� ��� ��� ���������� ���������!\n\n","�������","");
			            }
			        }
			        case 4:{//������ ���, ��� ��� �������
			            new query[56-2+MAX_PLAYER_NAME];
			            mysql_format(mysql_connection,query,sizeof(query),"select`name`,`level`from`users`where`referal_name`='%e'",player[playerid][name]);
			            mysql_query(mysql_connection,query);
			            if(cache_get_row_count(mysql_connection)){
			                new string[512+61]=""BLUE"�������\t"BLUE"������ �����������\t"BLUE"�����\n";
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
			            }
			            else{
                            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"��������","\n"WHITE"��� ������� ��� ����� �� ��������!\n\n","�������","");
			            }
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
			    new day,month,year,hour,minute;
			    getdate(year,month,day);
				gettime(hour,minute,_);
			    new query[108-2-2-2-2-2+MAX_PLAYER_NAME+MAX_PROMOCODE_LEN+4+11+11];
			    mysql_format(mysql_connection,query,sizeof(query),"insert into`promocodes`(`creator`,`promocode`,`level`,`money`,`experience`,`created`)values('%e','%e','%d','%d','%d','%02d/%02d/%d %02d:%02d')",player[playerid][name],temp_promocode,GetPVarInt(playerid,"cp_level"),GetPVarInt(playerid,"cp_money"),GetPVarInt(playerid,"cp_experience"),day,month,year,hour,minute);
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
			            new string[1];
			            format(string,sizeof(string),"");
			            ShowPlayerDialog(playerid,dMainMenuInfAboutPersCharacter,DIALOG_STYLE_MSGBOX,""BLUE"���������� � ���������",string,"�����","");
			        }
			        case 1:{

					}
					case 2:{//���������� � ��������� ������������
						new query[46-2+11];
						mysql_format(mysql_connection,query,sizeof(query),"select`date`,`ip`from`connects`where`id`='%i'",player[playerid][id]);
						mysql_query(mysql_connection,query);
						if(cache_get_row_count(mysql_connection)){
						    new temp_date[32],temp_ip[16],temp_string[25-2-2+32+16];
						    new string[sizeof(temp_string)*15]=""WHITE"����\t"WHITE"IP �����\n"WHITE"";
						    for(new i=cache_get_row_count(mysql_connection)>=15?cache_get_row_count(mysql_connection)-15:0; i<cache_get_row_count(mysql_connection); i++){
								cache_get_field_content(i,"date",temp_date,mysql_connection,sizeof(temp_date));
								cache_get_field_content(i,"ip",temp_ip,mysql_connection,sizeof(temp_ip));
								format(temp_string,sizeof(temp_string),"%s\t%s\n",temp_date,temp_ip);
								strcat(string,temp_string);
						    }
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_TABLIST_HEADERS,""BLUE"���������� � ��������� ������������",string,"�������","");
						}
						else{
						    ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
						}
					}
				}
		    }
		    else{
		        cmd::menu(playerid);
		    }
		}
		case dBankCreateAccount:{
		    if(response){
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
		        if(!GetPVarInt(playerid,"Bank_CreatingAccount")){
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
		        if(!GetPVarInt(playerid,"Bank_CreatingAccount") && !strlen(temp_description)){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            return true;
		        }
		        new sscanf_password[32];
				if(sscanf(inputtext,"s[128]",sscanf_password)){
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
		        if(!GetPVarInt(playerid,"Bank_CreatingAccount") && !strlen(temp_description) && !strlen(temp_password)){
		            ShowPlayerDialog(playerid,NULL,DIALOG_STYLE_MSGBOX,""BLUE"������","\n"WHITE"��������, ��������� ������!\n\n","�������","");
		            return true;
		        }
		        new temp_day,temp_month,temp_year,temp_hour,temp_minute;
		        getdate(temp_year,temp_month,temp_day);
		        gettime(temp_hour,temp_minute,_);
		        new temp_date[32];
		        format(temp_date,sizeof(temp_date),"%02i/%02i/%i %02i:%02i",temp_day,temp_month,temp_year,temp_hour,temp_minute);
				new query[95-2-2-2-2+MAX_PLAYER_NAME+32+32+32];
				mysql_format(mysql_connection,query,sizeof(query),"insert into`bank_accounts`(`owner`,`password`,`description`,`date`)values('%e','%e','%e','%e')",player[playerid][name],temp_password,temp_description,temp_date);
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
                DeletePVar(playerid,"Bank_CreatingAccount");
                DeletePVar(playerid,"Bank_CreatingAccountDescription");
                DeletePVar(playerid,"Bank_CreatingAccountPassword");
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
	GivePlayerMoney(playerid,player[playerid][money]);
	SetPlayerScore(playerid,player[playerid][level]);
	return true;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys){
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
		            SetPVarInt(playerid,"InteriorID",-1);
		            break;
		        }
				break;
		    }
			if(IsPlayerInRangeOfPoint(playerid,1.5,1410.7482,-1689.8737,39.6919)){
			    new query[47-2+MAX_PLAYER_NAME];
			    mysql_format(mysql_connection,query,sizeof(query),"select`id`from`bank_accounts`where`owner`='%e'",player[playerid][name]);
			    mysql_query(mysql_connection,query);
			    new string[96-2+11];
			    format(string,sizeof(string),cache_get_row_count(mysql_connection)?"\n"WHITE"�� ������ ������� ����� ���������� ����?\n\n"GREY"������� ���������� ������ - %i\n\n":"\n"WHITE"�� ������ ������� ����� ���������� ����?\n\n",cache_get_row_count(mysql_connection));
				ShowPlayerDialog(playerid,dBankCreateAccount,DIALOG_STYLE_MSGBOX,""BLUE"�������� ����������� �����",string,"��","���");
			    return true;
			}
		}
	    return true;
	}
	return true;
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
	            if(player[playerid][level]==3 && !player[playerid][experience]){
					mysql_format(mysql_connection,query,sizeof(query),"select`payday`,`name`from`users`where`name`='%e'",player[playerid][referal_name]);
					mysql_query(mysql_connection,query);
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
				}
	            mysql_format(mysql_connection,query,sizeof(query),"select`level`,`promocode`,`money`,`experience`from`promocodes`where`promocode`='%e'",player[playerid][referal_name]);
	            mysql_query(mysql_connection,query);
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
	    format(string,sizeof(string),"%i/%i %i",player[playerid][experience],player[playerid][level]*NEEDED_EXPERIENCE,player[playerid][level]);
	    SendClientMessage(playerid,-1,string);
	}
	return true;
}

/*      ------------------      */

/*      ������� �������         */

CMD:menu(playerid){
	ShowPlayerDialog(playerid,dMainMenu,DIALOG_STYLE_LIST,""BLUE"Main Menu","[0] ���������� � ���������\n[1] ����������� �������","�������","������");
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
	    SendClientMessage(playerid,C_GREY,"�����������: /todo ���������*��������");
	    return true;
	}
	new string[22+64+64-2-2-2+MAX_PLAYER_NAME+9];
	format(string,sizeof(string),"- %s - ������ %s - "RED"%s",text,player[playerid][name],action);
	SendClientMessage(playerid,-1,string);
	return true;
}

CMD:me(playerid,params[]){
	if(sscanf(params,"s[128]",params[0])){
        SendClientMessage(playerid,C_GREY,"�����������: /me ��������");
	    return true;
	}
	new string[8-2-2+MAX_PLAYER_NAME+128];
	format(string,sizeof(string),"%s - %s",player[playerid][name],params[0]);
	SendClientMessage(playerid,C_RED,string);
	return true;
}

CMD:do(playerid,params[]){
	if(sscanf(params,"s[128]",params[0])){
        SendClientMessage(playerid,C_GREY,"�����������: /do �������� �� �������� ����");
	    return true;
	}
	new string[14-2-2+128+MAX_PLAYER_NAME];
	format(string,sizeof(string),"%s - (( %s ))",params[0],player[playerid][name]);
	SendClientMessage(playerid,C_RED,string);
	return true;
}
////////////////////////////////////////////////
CMD:payday(playerid){
	@__payday(playerid);
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

CMD:tp(playerid){
	SetPlayerPos(playerid,1.0150,152.3207,1242.5679);
	return true;
}

CMD:bankaccount(playerid){
	new query[48-2+MAX_PLAYER_NAME];
	mysql_format(mysql_connection,query,sizeof(query),"insert into`bank_accounts`(`owner`)values('%e')",player[playerid][name]);
	mysql_query(mysql_connection,query);
	return true;
}
