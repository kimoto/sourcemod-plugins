#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <tf2>

#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo =  
{
  name = "TF2 Glowing Red Team",
  author = "kimoto",
  description = "Wall through glowing red team players",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

public OnPluginStart()
{
  RegServerCmd("sm_tf2_glow_red_team", Command_GlowPlayer);
  HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_PostNoCopy);
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
  new client = GetClientOfUserId(GetEventInt(event, "userid"));
  if(IsRedTeamPlayer(client)){
    SetGlow(client, true);
  }
}

public Action:Command_GlowPlayer(args)
{
  for(new i=1; i<=MaxClients; i++){
    if(IsRedTeamPlayer(i)){
      SetGlow(i, true);
    }
  }
}

void:SetGlow(client, bool:status)
{
  SetEntProp(client, Prop_Send, "m_bGlowEnabled", status == true ? 1 : 0);
}

bool:IsRedTeamPlayer(client)
{
  return (IsClientInGame(client) && GetClientTeam(client) == _:TFTeam_Red);
}


