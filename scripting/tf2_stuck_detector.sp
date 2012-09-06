#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0.0"

// 配列の配列
new Handle:positions = INVALID_HANDLE;
new Handle:timers[MAXPLAYERS+1];

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
  LogMessage("stuck detector start");
  positions = CreateArray(3, MAXPLAYERS+1);
  HookEvent("player_death", OnPlayerDeath);
  HookEvent("player_spawn", OnPlayerSpawn);
  StartStuckDetectorAll();
}

// playerの接続と認証が確認取れたあと
public OnClientPostAdminCheck(client)
{
  StartStuckDetector(client);
}

public StartStuckDetectorAll()
{
  for(new i=1; i<=MaxClients; i++){
    LogMessage("check client: %d", i);
    StartStuckDetector(i);
  }
}

// すでに検査中のBOTについてはなんもしない
public StartStuckDetector(client)
{
  // BOTのときはスタックを検知開始します
  if(IsClientInGame(client) && IsClientBot(client)){
    // すべてのプレイヤーに対して位置情報記録タイマーを仕込む
    // 10秒に一回更新。で位置が一切かわってなかったらstuck detectedと画面に表示する
    LogMessage("************* ingame and this is bot");
    LogMessage("client: %d", client);

    // 10秒後に再検査します。timerを生成します
    // すでにタイマーがあったら検査中なので放置します
    if(timers[client] == INVALID_HANDLE){
      // 座標を取得します
      new Float:origin[3];
      GetClientAbsOrigin(client, origin);

      // その座標を記録します
      SetArrayArray(positions, client, origin);
      LogMessage("pushed origin: %f %f %f", origin[0], origin[1], origin[2]);

      timers[client] = CreateTimer(10.0, Timer_StuckTest, client, TIMER_REPEAT);
    }
  }
}

public Action:OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
  new userid = GetEventInt(event, "userid");
  new client = GetClientOfUserId(userid);
  LogMessage("death: %d", client);

  if(timers[client] != INVALID_HANDLE){
    KillTimer(timers[client]);
    timers[client] = INVALID_HANDLE;
  }
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
  new userid = GetEventInt(event, "userid");
  new client = GetClientOfUserId(userid);
  LogMessage("spawn: %d", client);
  StartStuckDetector(client);
}

public OnClientDisconnect(client)
{
  // 切断時にはそのBOTの後処理します
  if(timers[client] != INVALID_HANDLE){
    KillTimer(timers[client]);
    timers[client] = INVALID_HANDLE;
  }
}

public IsClientBot(client)
{
  decl String:SteamID[64];
  GetClientAuthString(client, SteamID, sizeof(SteamID));
  return (StrEqual(SteamID, "BOT"));
}

public Action:Timer_StuckTest(Handle:timer, any:client)
{
  LogMessage("each timer: %d", client);

  if(!IsPlayerAlive(client)){
    // 死んでたらタイマー外して即抜けします
    KillTimer(timers[client]);
    timers[client] = INVALID_HANDLE;
    return;
  }

  if(IsPlayerAlive(client)){
    new Float:origin[3];
    new Float:now_origin[3];

    LogMessage("timer: %d", client);
    GetArrayArray(positions, client, origin);

    LogMessage("before origin: %f %f %f", origin[0], origin[1], origin[2]);

    // 現在位置を取得する
    GetClientAbsOrigin(client, now_origin);
    LogMessage("now origin: %f %f %f", now_origin[0], now_origin[1], now_origin[2]);

    // n秒前と位置が一緒?
    if(origin[0] == now_origin[0] && origin[1] == now_origin[1] && origin[2] == now_origin[2]){
      new String:name[32];
      GetClientName(client, name, sizeof(name));

      PrintToChatAll("[システム] BOTのスタックを検知しました。(%s) ...", name);
      FakeClientCommand(client, "kill");
      PrintToChatAll("[システム] KILLしました");

      // KILLしたはずなのでtimer殺して終了処理します
      KillTimer(timers[client]);
      timers[client] = INVALID_HANDLE;
      return;
    }

    // 現在位置を過去の位置として保存
    SetArrayArray(positions, client, now_origin);
  }else{
    KillTimer(timers[client]);
    timers[client] = INVALID_HANDLE;
    return;
  }
}
