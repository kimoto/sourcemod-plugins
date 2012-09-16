#pragma semicolon 1

#include <sourcemod>
#include <string>
#include <halflife>

#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo =  
{
	name = "TF2 MvM Auto Popfile",
	author = "kimoto",
	description = "TF2 MvM Auto Popfile ",
	version = PLUGIN_VERSION,
	url = "http://kymt.me/"
};

public OnPluginStart()
{
  LogMessage("autopop plugin loaded");
}

public OnMapStart()
{
  decl String:map[256];
  GetCurrentMap(map, sizeof(map));
  LogMessage("map name: %s", map);
  ServerCommand("tf_mvm_popfile %s", map);
}

