// GetPVarString

stock FIXES_GetPVarString(playerid, const varname[], string_return[], len)
{
	len = GetPVarString(playerid, varname, string_return, len);
	static i; i = -1;
	do {} while ((string_return[++i] &= 0xFF) != '\0');
	return len;
}

#if defined _ALS_GetPVarString
	#undef GetPVarString
#else
	#define _ALS_GetPVarString
#endif
#define GetPVarString( FIXES_GetPVarString(

// GetSVarString

stock FIXES_GetSVarString(const varname[], string_return[], len)
{
	len = GetSVarString(varname, string_return, len);
	static i; i = -1;
	do {} while ((string_return[++i] &= 0xFF) != '\0');
	return len;
}

#if defined _ALS_GetSVarString
	#undef GetSVarString
#else
	#define _ALS_GetSVarString
#endif
#define GetSVarString( FIXES_GetSVarString(

// strcmp

#if defined _ALS_strcmp
	#error _ALS_strcmp defined
#endif
native BAD_strcmp(const string1[], const string2[], bool:ignorecase=false, length=cellmax) = strcmp;

stock FIXES_strcmp(const string1[], const string2[], bool:ignorecase=false, length=cellmax)
{
	if (length == 0)
		return 0;
	if (string1[0])
	{
		if (string2[0])
		{
			return clamp(strcmp(string1, string2, ignorecase, length), -1, 1);
		}
		else
		{
			// Positive as st1 is greater (strcmp spec).
			return 1;
		}
	}
	else
	{
		if (string2[0])
		{
			// Negative as str2 is greater.
			return -1;
		}
		else
		{
			// The strings are the same (empty).
			return 0;
		}
	}
}

#define _ALS_strcmp
#define strcmp( FIXES_strcmp(

// Взято из инклуда fixes
