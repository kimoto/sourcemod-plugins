//
//  Name: everywhere ghost respawn SourceMod plugin
//  History:
//    ver0.2:
//      cleanup source code
//      added debug mode
//      added keyconfig
//    ver0.1:
//      first release
//
#include <sourcemod>
#define PLUGIN_VERSION "0.2"
#define TEAM_INFECTED 3
#define PLUGIN_FILENAME "everywhereghostrespawn"

new Handle:g_hEnable = INVALID_HANDLE;
new Handle:g_hDebug = INVALID_HANDLE;
new Handle:g_hSelectKey = INVALID_HANDLE;
new bool:g_bEnable = true;
new bool:g_bDebug = true;
new g_iSelectKey = 0;

public Plugin:myinfo = 
{
  name = "everywhere ghost respawn",
  author = "kimoto",
  description = "everywhere ghost respawn plugin",
  version = PLUGIN_VERSION,
  url = ""
}

public OnPluginStart()
{
  CreateConVar("egr_version", PLUGIN_VERSION, "everywhere ghost respawn plugin version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
  g_hEnable   = CreateConVar("egr_enable", "1", "Enable/Disable everywhere ghost respawn plugin", FCVAR_PLUGIN);
  g_hDebug    = CreateConVar("egr_debug", "1", "Enable/Disable everywhere ghost respawn plugin debug show", FCVAR_PLUGIN);
  g_hSelectKey  = CreateConVar("egr_select_key", "3", "Key binding for ghost respawn. (1=MELEE, 2=RELOAD, 3=ZOOM)", FCVAR_PLUGIN, true, 1.0, true, 3.0);
  // default is zoom key
  
  HookConVarChange(g_hEnable, OnConVarsChanged);
  HookConVarChange(g_hDebug, OnConVarsChanged);
  HookConVarChange(g_hSelectKey, OnConVarsChanged);

  AutoExecConfig(true, PLUGIN_FILENAME);
  ReloadConvars();
}

// modify convars
public OnConVarsChanged(Handle:hConVar, const String:oldValue[], const String:newValue[])
{
  ReloadConvars();
}

public ReloadConvars()
{
  // reload convars
  g_bEnable = GetConVarBool(g_hEnable);
  g_bDebug = GetConVarBool(g_hDebug);
  g_iSelectKey = GetConVarInt(g_hSelectKey);
  DebugPrint("convar reloaded");
}

public SelectKey(inputKey){
  switch(inputKey)
  {
    case 1:
    {
      return IN_ATTACK2;
    }
    case 2:
    {
      return IN_RELOAD;
    }
    case 3:
    {
      return IN_ZOOM;
    }
    default:
    {
      return 0;
    }
  }
  return 0; // not reached
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
    // Is client human infected
    if (IsClientInGame(client) && GetClientTeam(client) == TEAM_INFECTED && IsPlayerAlive(client) && g_bEnable)
    {
      // Is client not ghost
        if (GetEntProp(client, Prop_Send, "m_isGhost") == 0) {
          // Is client press zoom key
          if (buttons & SelectKey(g_iSelectKey))
          {
            SetEntProp(client,Prop_Send,"m_isCulling",1,1);
            ClientCommand(client,"+use");
            return Plugin_Continue;
          }
        }
  }
  return Plugin_Continue;
}

public DebugPrint(const String:Message[], any:...)
{
  if (g_bDebug)
  {
    decl String:DebugBuff[128];
    VFormat(DebugBuff, sizeof(DebugBuff), Message, 2);
    LogMessage(DebugBuff);
  }
}
