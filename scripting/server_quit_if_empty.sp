#pragma semicolon 1
#include <sourcemod>
#include <steamtools>
#define PLUGIN_VERSION "1.0.0"
#define TIMER_INTERVAL 30.0

public Plugin:myinfo =  
{
  name = "Server Quit If Empty",
  author = "kimoto",
  description = "Server Quit If Empty",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

new Handle:g_timer = INVALID_HANDLE;

public Action:Timer_ServerQuit(Handle:timer, any:client)
{
  ServerQuitIfEmpty();
}

public OnPluginStart()
{
  RegServerCmd("server_quit_if_empty", Command_ServerQuitIfEmpty);
  RegServerCmd("server_quit_next_empty", Command_ServerQuitNextEmpty);
}

public Action:Steam_RestartRequested()
{
  LogMessage("SteamUpdate Detected");
  Command_ServerQuitNextEmpty(1);
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

public ServerQuitIfEmpty()
{
  if( IsServerEmpty() ){
    LogMessage("Server is Empty");
    if( g_timer != INVALID_HANDLE){
      KillTimer(g_timer);
      g_timer = INVALID_HANDLE;
    }
    LogMessage("Sending quit command");
    ServerCommand("quit");
  }else{
    LogMessage("Server is not Empty");
  }
}

public ServerQuitNextEmpty()
{
  if(g_timer == INVALID_HANDLE){
    ServerQuitIfEmpty();
    g_timer = CreateTimer(TIMER_INTERVAL, Timer_ServerQuit, 0, TIMER_REPEAT);
  }else{
    LogMessage("Already Executed!");
  }
}

public Action:Command_ServerQuitIfEmpty(args)
{
  ServerQuitIfEmpty();
}

public Action:Command_ServerQuitNextEmpty(args)
{
  ServerQuitNextEmpty();
}

