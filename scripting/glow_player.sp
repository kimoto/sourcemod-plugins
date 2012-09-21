#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <string>
#include <halflife>
#include <logging>

#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo =  
{
	name = "Glow Player",
	author = "kimoto",
	description = "Glow Player",
	version = PLUGIN_VERSION,
	url = "http://kymt.me/"
};

public OnPluginStart()
{
  RegServerCmd("sm_glow_player", Command_GlowPlayer);
  HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_PostNoCopy);
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
  new i = GetClientOfUserId(GetEventInt(event, "userid"));
  if(IsClientInGame(i) && GetClientTeam(i) == 2){
    SetEntProp(i, Prop_Send, "m_bGlowEnabled", 1);
  }
}

public Action:Command_GlowPlayer(args)
{
  for(new i=1; i<=MaxClients; i++){
    if(IsClientInGame(i) && GetClientTeam(i) == 2){
      SetEntProp(i, Prop_Send, "m_bGlowEnabled", 1);
    }
  }
}

