#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0.0"
#define UNDEFINED_VALUE -1

public Plugin:myinfo =  
{
  name = "Spectate setpos",
  author = "kimoto",
  description = "Spectate setpos",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

public OnPluginStart()
{
  RegConsoleCmd("spec_getpos", Command_SpectateGetPos);
  RegConsoleCmd("spec_setpos", Command_SpectateSetPos);
  RegConsoleCmd("spec_setang", Command_SpectateSetAngle);
}

public Action:Command_SpectateGetPos(client, args)
{
  if(!IsSpectator(client)){
    NotifySpectatorOnly(client);
    return;
  }

  new Float:origin[3];
  new Float:angles[3];
  GetClientAbsOrigin(client, origin);
  GetClientEyeAngles(client, angles);
  ReplyToCommand(client, "spec_setpos %f %f %f; spec_setang %f %f %f",
    origin[0], origin[1], origin[2], angles[0], angles[1], angles[2]);
}

public Action:Command_SpectateSetPos(client, args)
{
  if(!ValidArgs(client, args)){
    return;
  }
  new Float:origin[3];
  CmdArgsToVector(origin);
  TeleportEntity(client, origin, NULL_VECTOR, NULL_VECTOR);
}

public Action:Command_SpectateSetAngle(client, args)
{
  if(!ValidArgs(client, args)){
    return;
  }
  new Float:angles[3];
  CmdArgsToVector(angles);
  TeleportEntity(client, NULL_VECTOR, angles, NULL_VECTOR);
}

bool:ValidArgs(client, args)
{
  if(args != 3){
    decl String:buffer[256];
    GetCmdArg(0, buffer, sizeof(buffer));
    ReplyToCommand(client, "%s vec1 vec2 vec3", buffer);
    return false;
  }
  if(!IsSpectator(client)){
    NotifySpectatorOnly(client);
    return false;
  }
  return true;
}

NotifySpectatorOnly(client)
{
  ReplyToCommand(client, "This command spectator only");
}

bool:IsSpectator(client)
{
  return (GetClientTeam(client) == 1);
}

CmdArgsToVector(Float:angles[3])
{
  new String:buffer[32];
  GetCmdArg(1, buffer, sizeof(buffer));
  angles[0] = StringToFloat(buffer);
  GetCmdArg(2, buffer, sizeof(buffer));
  angles[1] = StringToFloat(buffer);
  GetCmdArg(3, buffer, sizeof(buffer));
  angles[2] = StringToFloat(buffer);
}
