#pragma semicolon 1
#include <sourcemod>
#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo =  
{
  name = "test",
  author = "kimoto",
  description = "test",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

public OnPluginStart()
{
  RegServerCmd("sm_uncheat", Command_UnCheat);
}

public Action:Command_UnCheat(args)
{
  if(args != 1){
    PrintToServer("Usage: sm_uncheat command_name");
    return;
  }
  new String:cmd[64];
  GetCmdArg(1, cmd, sizeof(cmd));
  SetCommandFlags(cmd, GetCommandFlags(cmd) & ~FCVAR_CHEAT);
}
