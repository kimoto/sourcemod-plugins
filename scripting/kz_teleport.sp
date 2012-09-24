//
//  Name: kz_teleport plugin
//  Description:
//    HL2のkzmodにある、checkpointを作ってそこにワープするみたいなことが出来るようになるSourceMODプラグインです
//    主に斜面のバニホ練習で、簡単に元の位置に戻るためや
//    アクセルブーマーの練習で、元の位置に簡易に戻るために使用します
//
//    checkpoint - このコマンドを実行したときの場所とみている方向を保存します
//    teleport_to_checkpoint - 最後に保存されたcheckpointに移動します
//
//    これらのコマンドを任意のキーにbindするのを推奨します
//    例:
//      bind "p" "say !checkpoint; checkpoint"
//      bind "o" "teleport_to_checkpoint"
//  ChangeLog:
//    2011/03/14: v0.3 設計変更(すべてのプレイヤーの座標を保存するようにした)
//    2011/03/14: v0.2 source code cleanup
//    2010/**/**: v0.1 released
//
#include <sourcemod>
#include <sdktools>
#define PLUGIN_VERSION "0.3"
#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3
#define PLUGIN_FILENAME "kz_teleport"
#define DEBUG_STRING_BUFFER_SIZE 256

new Handle:g_hEnable = INVALID_HANDLE;
new Handle:g_hDebug = INVALID_HANDLE;
new bool:g_bEnable = true;
new bool:g_bDebug = true;

#define PLAYER_INFO_SIZE 7
new Handle:g_hPlayerInfo = INVALID_HANDLE;
new bool:savedFlag = false;

public Plugin:myinfo = 
{
  name = "kz_teleport",
  author = "kimoto",
  description = "kz style teleport plugin",
  version = PLUGIN_VERSION,
  url = "http://steamcommunity.com/id/kimoto"
}

public OnPluginStart()
{
  CreateConVar("kz_teleport_version", PLUGIN_VERSION, "kz style teleport plugin version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
  g_hEnable   = CreateConVar("kz_teleport_enable", "1", "Enable/Disable kz style teleport plugin", FCVAR_PLUGIN);
  g_hDebug    = CreateConVar("kz_teleport_debug", "0", "Enable/Disable kz style teleport plugin debug show", FCVAR_PLUGIN);
  
  HookConVarChange(g_hEnable, OnConVarsChanged);
  HookConVarChange(g_hDebug, OnConVarsChanged);
  
  AutoExecConfig(true, PLUGIN_FILENAME);
  ReloadConvars();
  
  RegConsoleCmd("checkpoint", Command_SetCheckpoint)
  RegConsoleCmd("teleport_to_checkpoint", Command_TeleportToCheckpoint)
}

#define MAX_LINE_WIDTH 64
public IsClientBot(client)
{
    decl String:SteamID[MAX_LINE_WIDTH];
    GetClientAuthString(client, SteamID, sizeof(SteamID));

    if (StrEqual(SteamID, "BOT"))
        return true;

    return false;
}

public DebugPrint(const String:Message[], any:...)
{
  if (g_bDebug)
  {
    decl String:DebugBuff[DEBUG_STRING_BUFFER_SIZE];
    VFormat(DebugBuff, sizeof(DebugBuff), Message, 2);
    LogMessage(DebugBuff);
  }
}

public Action:Command_SetCheckpoint(client, args)
{
  DebugPrint("checkpoint");
  new Float:origin[3];
  new Float:rotation[3];
  new Float:data[PLAYER_INFO_SIZE];
  
  g_hPlayerInfo = CreateArray(PLAYER_INFO_SIZE);
  ClearArray(g_hPlayerInfo);
  
  // すべてのプレイヤーの座標を取得する、そして保存する
  // BOTは保存対象から除外
  for(new i=1; i<=GetMaxClients(); i++) {
    // ingame and not bot player
    if(IsClientInGame(i) && !IsClientBot(i)) {
      DebugPrint("client: %d", i);
      DebugPrint("user id is: %d", GetClientUserId(i));
      
      GetClientAbsOrigin(i, origin);
      GetClientAbsAngles(i, rotation);
      
      DebugPrint("origin: %f %f %f", origin[0], origin[1], origin[2]);
      DebugPrint("rotation: %f %f %f", rotation[0], rotation[1], rotation[2]);
      
      data[0] = i; // client index
      data[1] = origin[0];
      data[2] = origin[1];
      data[3] = origin[2];
      data[4] = rotation[0];
      data[5] = rotation[1];
      data[6] = rotation[2];
      
      PushArrayArray(g_hPlayerInfo, data);
      DebugPrint("pushed array");
      
      savedFlag = true;
    }
  }
  return Plugin_Continue;
}

public Action:Command_TeleportToCheckpoint(client, args)
{
  new Float:origin[3];
  new Float:rotation[3];
  new Float:velocity[3];
  new Float:data[PLAYER_INFO_SIZE];

  DebugPrint("teleport_to_checkpoint");
  if( savedFlag )
  {
    for(new i=0; i<GetArraySize(g_hPlayerInfo); i++){
      GetArrayArray(g_hPlayerInfo, i, data);
      origin[0] = data[1];
      origin[1] = data[2];
      origin[2] = data[3];
      
      rotation[0] = data[4];
      rotation[1] = data[5];
      rotation[2] = data[6];
      
      velocity[0] = velocity[1] = velocity[2] = 0.0;
      DebugPrint("saved origin:\nclient(%d) %f %f %f\n%f %f %f", data[0], origin[0], origin[1], origin[2], rotation[0], rotation[1], rotation[2]);
        
      TeleportEntity(data[0], origin, rotation, velocity);
      DebugPrint("warped");
    }
  }
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
  DebugPrint("convar reloaded");
}

