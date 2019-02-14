
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

#define MAX_PASSWORD_LEN (24) // ������������ ����� ������
#define MIN_PASSWORD_LEN (4) // ����������� ����� ������
#define MAX_EMAIL_LEN (32) // ������������ ����� ������
#define MIN_EMAIL_LEN (10) // ����������� ����� ������
#define MAX_PROMOCODE_LEN (32) // ������������ ����� ���������
#define MIN_PROMOCODE_LEN (4) // ����������� ����� ���������

#define KEY_NUM4 (8192) // ID ������� - NUM4
#define KEY_NUM6 (16384) // ID ������� - NUM6

// �����

#define C_BLUE 0x5495FFFF // �������� ����� ������� - �����
#define C_RED 0xF45F5FFF // �������

#define BLUE "{5495ff}" // ����� ��� ������������� � ������ � ��������
#define RED "{f45f5f}" // ������� ��� ������������� � ������ � ��������
#define WHITE "{ffffff}" // ����� ��� ������������� � ������ � ��������

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
	referal_money,//������, ���������� � ������������ �������
	age,//������� ���������
	origin,//���� ���������
	gender,//��� ���������
	character//���� ���������
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
	dAuthorization//������ �����������
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
	mysql_log(LOG_DEBUG);//�������� ����� �����
	SetGameModeText("Doshirak v0.001");//������ �������� ���� ��� �������
	SendRconCommand("hostname Doshirak Role Play - 0.3.7");//������ �������� ������� ��� ������� ����� RCON
	LoadObjects();
	return true;
}

public OnPlayerConnect(playerid){// ������������ � �������
	new temp_ip[16];//������ ���������� ��� ������ IP ������
	GetPlayerIp(playerid,temp_ip,sizeof(temp_ip));//���������� IP ����� � ����������
	for(new i=0; i!=MAX_PLAYERS; i++){//�������� �� ����� �������, ����� 1000 ��������
		if(!strcmp(check_ip_for_reconnect[i],temp_ip)){//���� ���� �� �������� � ���������� ������� � ���������� ����������
		    if(gettime()-check_ip_for_reconnect_time[i]<20){//� ���� ���������� ����� ��������� ������ 20-��, ��...
		        SendClientMessage(playerid,C_RED,"�� ���� ������� ��������! �������: Anti Reconnect");
		        SetTimerEx("@__kick_player",250,false,"i",playerid);//������ ������
		        return true;//������� �� �������
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
    			format(string,sizeof(string),"\n{ffffff}����� ���������� �� "BLUE"Doshirak RP!"WHITE"\n��� ���������� ������������������!\n��� �����: "BLUE"%s\n\n",player[playerid][name]);// ����������� �����
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
                new query[55-2-2+MAX_PLAYER_NAME+MAX_PASSWORD_LEN];// ��������� ���������� ��� ����������� ������� � ���� ������
                mysql_format(mysql_connection,query,sizeof(query),"insert into`users`(`name`,`password`)values('%e','%e')",player[playerid][name],sscanf_password);// ����������� "����������" ������ �������� ������ � ���� ������
                mysql_query(mysql_connection,query);// ���������� ������ � ���� ������
				player[playerid][id]=cache_insert_id(mysql_connection);//������ �������� ���� ����������� �� ���� ������ � ���������� ������
				ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n{ffffff}��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n","������","����������");// ���������� ������ ����� ����������� �����
				SendClientMessage(playerid,C_BLUE,"��� ������� ����� � ���� ������ �������!");//������� ��������� �� �������� �������� ��������
	        }
	        else{// ���� ����� ������� ����� ���(������ ������ �������), ��
				SendClientMessage(playerid,C_RED,"�� ���������� �� ����������� � ���� �������!");// ������� ��������� � ���
				SetTimerEx("@__kick_player",250,false,"i",playerid);// ����������� ������ � ������� ��� ��������
	        }
	    }
	    case dRegistrationEmail:{//���� dialogid ����� ������, �� ��������� � ����
	        if(response){//���� ����� �� ������� ����� ������� (����� ������), ��...
	            new sscanf_email[MAX_EMAIL_LEN];//��������� ���������� ��� ������ ��. �����
				if(sscanf(inputtext,"s[128]",sscanf_email)){//���� ���� ����� ��������� ������, ��...
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n{ffffff}��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n","������","����������");
				    return true;//������� �� �������
				}
				if(strlen(sscanf_email)<MIN_EMAIL_LEN || strlen(sscanf_email)>MAX_EMAIL_LEN){//���� ����� ������ ������ n, � ������ n, ��...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n{ffffff}��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n"RED"����� ������ ����������� ����� ����� �� ������ 4-� � �� ������ 32-� ��������!","������","����������");
				    return true;//������� �� �������
				}
				if(!regex_match(sscanf_email,"[a-zA-Z0-9_\\.-]+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z]{2,4}")){//���� ������������ �������� ����������� ��������� ����� ����� ����(���), �� ������� ������ � ����
				    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n{ffffff}��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n"RED"� ������ ����������� ����� ������� ������������ �������!","������","����������");
				    return true;//������� �� �������
				}
				new query[35-2-2+MAX_EMAIL_LEN+11];//��������� ���������� ��� ������ ������� � ��
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`email`='%e'",sscanf_email);//����������� ������ � ������������ ������
				mysql_query(mysql_connection,query);// ���������� ������ � ��
				if(cache_get_row_count(mysql_connection)){// ���� ����� ����� �������, ���� ������, ��...
                    ShowPlayerDialog(playerid,dRegistrationEmail,DIALOG_STYLE_INPUT,"�����������","\n{ffffff}��� ����������� ����������� ����������\n������� ����� ����������� �����\n\n"RED"��������� ����������� ����� ��� ��������������� � �������!","������","����������");
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
				new query[45-2+MAX_PROMOCODE_LEN];//��������� ���������� ��� �������������� �������
				mysql_format(mysql_connection,query,sizeof(query),"select*from`users`where`name`='%e'",sscanf_referal_name);//����������� ������ � ������������ ������
				mysql_query(mysql_connection,query);//���������� ������ � ��
				if(cache_get_row_count(mysql_connection)){// ���� ����� ����� �������, ���� ������, ��...
				    strins(player[playerid][referal_name],sscanf_referal_name,0);//���������� �������� ���� ����� � ����������
				    SendClientMessage(playerid,C_BLUE,"�� ���� ���������� ������� �� ��������!");//������� ��������� � ������� � ���� ������
                    ShowPlayerDialog(playerid,dRegistrationAge,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"��� ���������� ������� ������� ������ ���������\n"BLUE"������: (16 - 60)\n\n","������","�����");
					//������� ������ � ������ �������� ���������
				}
				else{//���� ����� ����� ���, ��...
				    mysql_format(mysql_connection,query,sizeof(query),"select*from`promocodes`where`promocode`='%e'",sscanf_referal_name);//����������� ������ � ������������ ������
				    mysql_query(mysql_connection,query);// ���������� ������
				    if(cache_get_row_count(mysql_connection)){// ���� ����� ����� �������, ���� ������, ��...
				        if(!regex_match(sscanf_referal_name,"[a-zA-Z0-9_#@!]+") || strlen(sscanf_referal_name)<MIN_PROMOCODE_LEN || strlen(sscanf_referal_name)>MAX_PROMOCODE_LEN){
				            //���� ������������ �������� ����������� ��������� ����� ����� ����(���), �� ������� ������ � ���� ��� ����� ������ ������ n ��� ����� ������ ������ n
	                        ShowPlayerDialog(playerid,dRegistrationReferal,DIALOG_STYLE_INPUT,"�����������","\n"WHITE"���� �� ������ �� ������ �� �����������,\n�� ������ ������� ������� ��� ��������\n\n"RED"� �������� ��������� ������� ������������ �������!\n\n","������","����������");
		          		    return true;//������� �� �������
		          		}
						strins(player[playerid][referal_name],sscanf_referal_name,0);//���������� �������� ���� ����� � ����������
						SendClientMessage(playerid,C_BLUE,"�� ���� ���������� ������� �� ���������!");//������� ��������� � ������� � ���� ������
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
		        SendClientMessage(playerid,C_RED,"�� ���������� �� ����������� � ���� �������!");// ������� ��������� � ���
				SetTimerEx("@__kick_player",250,false,"i",playerid);// ����������� ������ � ������� ��� ��������
		    }
		}
		case dRegistrationOrigin:{
		    if(response){
				player[playerid][origin]=listitem+1;
				new string[21-2+24];
				format(string,sizeof(string),"�� ������� ���� - %s",origins[player[playerid][origin]]);
				SendClientMessage(playerid,C_BLUE,string);
				new query[44-2-2+1+11];
				mysql_format(mysql_connection,query,sizeof(query),"update`users`set`origin`='%i'where`id`='%i'",player[playerid][origin],player[playerid][id]);
				mysql_query(mysql_connection,query);
				ShowPlayerDialog(playerid,dRegistrationGender,DIALOG_STYLE_MSGBOX,"�����������","\n"WHITE"�������� ��� ������ ���������\n\n","�������","�������");
		    }
		    else{
                SendClientMessage(playerid,C_RED,"�� ���������� �� ����������� � ���� �������!");// ������� ��������� � ���
				SetTimerEx("@__kick_player",250,false,"i",playerid);// ����������� ������ � ������� ��� ��������
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
		    SendClientMessage(playerid,-1,"��� ������ ����� ����� ����������� ������� "BLUE"(NUM4) "WHITE"� "BLUE"(NUM6)");
		    SendClientMessage(playerid,-1,"����� ��������� ��������� ����, ����������� ������� "BLUE"(SPACE)");
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
					format(inc_string,sizeof(inc_string),"{ffffff}������������ ������! (%d/3)\n\n",GetPVarInt(playerid,"PasswordAttempts"));
					strcat(string,inc_string);
					ShowPlayerDialog(playerid,dAuthorization,DIALOG_STYLE_INPUT,"�����������",string,"������","�����");
					strdel(string,strlen_text,sizeof(string));
					SetPVarInt(playerid,"PasswordAttempts",GetPVarInt(playerid,"PasswordAttempts")-1);
					if(GetPVarInt(playerid,"PasswordAttempts")<=0){
					    ShowPlayerDialog(playerid,NULL,NULL,"","","","");
					    SendClientMessage(playerid,C_RED,"�� ����� ������������ ������ ��� ���� � ���� �������!");
					    SetTimerEx("@__kick_player",250,false,"i",playerid);
					    return true;
					}
				}
		    }
		    else{
				SendClientMessage(playerid,C_RED,"�� ���������� �� ����������� � ���� �������!");
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
	    SendClientMessage(playerid,C_RED,"�� ������ ��������������!");
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

/*      ��������� ��������      */

@__kick_player(playerid);
@__kick_player(playerid){
	Kick(playerid);
	return true;
}

/*      ------------------      */
