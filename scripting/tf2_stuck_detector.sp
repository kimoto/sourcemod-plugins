#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0.0"
#define STUCK_DETECTOR_INTERVAL 10.0

new Handle:g_hPositions = INVALID_HANDLE;
new Handle:g_hTimers[MAXPLAYERS+1];
new bool:g_bEnabled = false;

public Plugin:myinfo =  
{
  name = "TF2 Stuck Detector",
  author = "kimoto",
  description = "TF2 Stuck Detector",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

public OnPluginStart()
{
  RegServerCmd("sm_tf2_stuck_detector_enable", Command_ToggleStuckDetector);
}

public Action:Command_ToggleStuckDetector(args)
{
  ToggleStuckDetector();
}

public InitStuckDetector()
{
  g_hPositions = CreateArray(3, MAXPLAYERS+1);
  HookEvent("player_death", OnPlayerDeath);
  HookEvent("player_spawn", OnPlayerSpawn);
  StartStuckDetectorAll();
}

public DestroyStuckDetector()
{
  StopStuckDetectorAll();
  UnhookEvent("player_death", OnPlayerDeath);
  UnhookEvent("player_spawn", OnPlayerDeath);
  ClearArray(g_hPositions);
}

public ToggleStuckDetector()
{
  if(g_bEnabled){
    LogMessage("Disabled Stuck Detector");
    DestroyStuckDetector();
  }else{
    LogMessage("Enable Stuck Detector");
    InitStuckDetector();
  }
  g_bEnabled = !g_bEnabled;
}

// playerの接続と認証が確認取れたあと
public OnClientPostAdminCheck(client)
{
  if(g_bEnabled)
    StartStuckDetector(client);
}

public OnClientDisconnect(client)
{
  if(g_bEnabled)
    StopStuckDetector(client);
}

public StartStuckDetectorAll()
{
  for(new i=1; i<=MaxClients; i++){
    StartStuckDetector(i);
  }
}

public StopStuckDetectorAll()
{
  for(new i=1; i<MaxClients; i++){
    StopStuckDetector(i);
  }
}

public StartStuckDetector(client)
{
  // BOTのときはスタックを検知開始します
  if(IsClientInGame(client) && IsClientBot(client)){
    // すべてのプレイヤーに対して位置情報記録タイマーを仕込む
    // 10秒に一回更新。で位置が一切かわってなかったらstuck detectedと画面に表示する
    LogMessage("Start Stuck Detector client:%d", client);

    // 10秒後に再検査します。timerを生成します
    // すでにタイマーがあったら検査中なので放置します
    if( !IsStuckDetectorEnabled(client) ){
      // 座標を取得し座標を記録します
      new Float:origin[3];
      GetClientAbsOrigin(client, origin);
      SetArrayArray(g_hPositions, client, origin);
      LogMessage("Save current origin: %f %f %f", origin[0], origin[1], origin[2]);
      g_hTimers[client] = CreateTimer(STUCK_DETECTOR_INTERVAL, Timer_StuckTest, client, TIMER_REPEAT);
    }
  }
}

public bool:IsStuckDetectorEnabled(client)
{
  return (g_hTimers[client] != INVALID_HANDLE);
}

// 指定したclientの監視を外す
public StopStuckDetector(client){
  if( IsStuckDetectorEnabled(client) ){
    KillTimer(g_hTimers[client]);
    g_hTimers[client] = INVALID_HANDLE;
    SetArrayArray(g_hPositions, client, {0.0, 0.0, 0.0});
  }
}

public Action:OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
  new client = GetClientOfUserId( GetEventInt(event, "userid") );
  LogMessage("[event] player death: client %d", client);
  StopStuckDetector(client);
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
  new client = GetClientOfUserId( GetEventInt(event, "userid") );
  LogMessage("[event] player spawn: client %d", client);
  StartStuckDetector(client);
}

public IsClientBot(client)
{
  decl String:SteamID[64];
  GetClientAuthString(client, SteamID, sizeof(SteamID));
  return (StrEqual(SteamID, "BOT"));
}

public bool:IsSamePosition(Float:origin1[3], Float:origin2[3])
{
  return (origin1[0] == origin2[0] && origin1[1] == origin2[1] && origin1[2] == origin2[2]);
}

public Action:Timer_StuckTest(Handle:timer, any:client)
{
  LogMessage("stuck test timer: client %d", client);

  if( IsClientInGame(client) && IsPlayerAlive(client) ){
    // 指定されたクライアントの10秒前の座標を取得
    new Float:last_origin[3];
    GetArrayArray(g_hPositions, client, last_origin);
    LogMessage("Last time origin: %f %f %f", last_origin[0], last_origin[1], last_origin[2]);

    // 現在位置を取得する
    new Float:now_origin[3];
    GetClientAbsOrigin(client, now_origin);
    LogMessage("Currently origin: %f %f %f", now_origin[0], now_origin[1], now_origin[2]);

    // n秒前と位置が一緒?
    if( IsSamePosition(last_origin, now_origin) ){
      new String:name[64];
      GetClientName(client, name, sizeof(name));
      PrintToChatAll("[システム] BOTのスタックを検知しました。(%s) ...", name);
      FakeClientCommand(client, "kill");
      PrintToChatAll("[システム] KILLしました");
      LogMessage("Stuck Detected. Killed BOT: (%s)", name);
      StopStuckDetector(client);
    } else {
      // 現在位置を過去の位置として保存
      SetArrayArray(g_hPositions, client, now_origin);
    }
  }else{
    LogMessage("Player already dead: client %d", client);
    StopStuckDetector(client);
  }
}
