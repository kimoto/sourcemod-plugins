#pragma semicolon 1

#include <sourcemod>
#include <tf2>
#define PLUGIN_VERSION "1.0.0"
#define TIMER_INTERVAL 20.0

new Handle:g_hTimer = INVALID_HANDLE;

public Plugin:myinfo =  
{
  name = "Map Auto Shuffle",
  author = "kimoto",
  description = "Map Auto Shuffle",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

public OnPluginStart()
{
  LogMessage("start");
  HookEvent("teamplay_round_active", hook_RoundActive, EventHookMode_Post);
}

public OnMapEnd()
{
    KillTimer(g_hTimer);
    g_hTimer = INVALID_HANDLE;
}

public hook_RoundActive(Handle:event, const String:name[], bool:dontBroadcast)
{
  if(g_hTimer == INVALID_HANDLE)
    g_hTimer = CreateTimer(TIMER_INTERVAL, Timer_Count, 0, TIMER_REPEAT);
}

public Action:Timer_Count(Handle:timer, any:client)
{
  if(IsServerEmpty()){
    LogMessage("server is empty. try to change randommap");
    ServerCommand("randommap");
    KillTimer(g_hTimer);
    g_hTimer = INVALID_HANDLE;
  }
}

public IsClientBot(client)
{
  new String:SteamID[256];
  GetClientAuthString(client, SteamID, sizeof(SteamID));
  if (StrEqual(SteamID, "BOT"))
    return true;
  return false;
}

public IsServerEmpty()
{
  for(new i=1; i<GetMaxClients(); i++){
    if( IsClientInGame(i) && !IsClientBot(i) ){ // human player & in game
      return false;
    }
  }
  return true;
}
