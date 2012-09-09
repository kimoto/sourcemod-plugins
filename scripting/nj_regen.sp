// player_hurt trigger version
#pragma semicolon 1
#include <sourcemod>
#include <tf2>

#define PLUGIN_VERSION "0.0.3"

public Plugin:myinfo = 
{
  name = "nj_Regen",
  author = "god",
  description = "regen command",
  version = PLUGIN_VERSION,
  url = "http://github.com/withgod/sm-nj_regen"
};

public OnPluginStart()
{
  CreateConVar("nj_regen_version", PLUGIN_VERSION, "nj Regen Command Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
  RegConsoleCmd("nj_regen_on", Command_RegenOn);
  RegConsoleCmd("nj_regen_off", Command_RegenOff);
  RegConsoleCmd("nj_regen", Command_RegenHandle);
}

public Action:Command_RegenHandle(client, args)
{
  new String:arg[128];
  GetCmdArg(1, arg, sizeof(arg));
  if (StrEqual(arg, "on"))
  {
    Command_RegenOn(client, args);
  } 
  else if (StrEqual(arg, "off"))
  {
    Command_RegenOff(client, args);
  }
  else
  {
    PrintToChat(client, "[nj]invalid parameter. this plugin accept on/off");
  }
}

public Action:Command_RegenOn(client, args)
{
  PrintToChat(client, "[nj][regen on]activate regen mode");
  HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
}

public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
  TF2_RegeneratePlayer(GetClientOfUserId(GetEventInt(event, "userid")));
  return Plugin_Continue;
}

public Action:Command_RegenOff(client, args)
{
  PrintToChat(client, "[nj][regen off]deactivate regen mode");
  UnhookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
}

