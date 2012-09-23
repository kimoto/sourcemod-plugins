#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#define PLUGIN_VERSION "1.0.0"
#define INVALID_EFFECT -1
new g_Effects[MAXPLAYERS+1];

public Plugin:myinfo =
{
  name = "Sushi Effects",
  author = "kimoto",
  description = "Sushi Effects",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

public OnPluginStart()
{
  for(new i=0; i<sizeof(g_Effects); i++){
    g_Effects[i] = INVALID_EFFECT;
  }
  RegConsoleCmd("sm_baloon", Command_ToggleBaloon);
  RegConsoleCmd("sm_jet", Command_ToggleJet);
  HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
}

public OnPluginEnd()
{
  for(new i=0; i<sizeof(g_Effects); i++){
    Effect_Stop(i);
  }
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
  new client = GetClientOfUserId(GetEventInt(event, "userid"));
  Effect_Stop(client);
}

public Action:Command_ToggleBaloon(client, args)
{
  if(g_Effects[client] != INVALID_EFFECT){
    Effect_Stop(client);
  }else{
    Effect_Baloon(client);
  }
}

public Action:Command_ToggleJet(client, args)
{
  if(g_Effects[client] != INVALID_EFFECT){
    Effect_Stop(client);
  }else{
    Effect_Jet(client);
  }
}

public Effect_Baloon(client)
{
  Effect_Stop(client);
  new Float:pos[3];
  GetClientAbsOrigin(client, pos);
  pos[2] += 70.0;
  g_Effects[client] = AttachParticle(client, "bday_confetti", pos);
}

public Effect_Jet(client)
{
  Effect_Stop(client);
  new Float:pos[3];
  GetClientAbsOrigin(client, pos);
  pos[2] += 70.0;
  g_Effects[client] = AttachParticle(client, "smoke_rocket_steam", pos);
}

public Effect_Stop(client)
{
  if(g_Effects[client] != INVALID_EFFECT){
    RemoveEdict(g_Effects[client]);
    g_Effects[client] = INVALID_EFFECT;
  }
}

AttachParticle(ent, String:effect_name[], Float:pos[3])
{
  new particle = CreateParticle(effect_name, pos);
  if(particle == INVALID_EFFECT){
    return INVALID_EFFECT;
  }
  decl String:name[128];
  Format(name, sizeof(name), "target%i", ent);
  DispatchKeyValue(ent, "targetname", name);
  DispatchKeyValue(particle, "parentname", name);
  SetVariantString(name);
  AcceptEntityInput(particle, "SetParent", particle, particle, 0);
  AcceptEntityInput(particle, "SetParentAttachment", particle, particle, 0);
  CreateTimer(0.1, Timer_Unko, ent);
  return particle;
}

public Action:Timer_Unko(Handle:timer, any:client)
{
  new particle = g_Effects[client];
  if(particle == INVALID_EFFECT){
    return;
  }else{
    AcceptEntityInput(particle, "start");
    CreateTimer(0.3, Timer_Unko2, client);
  }
}

public Action:Timer_Unko2(Handle:timer, any:client)
{
  new particle = g_Effects[client];
  if(particle == INVALID_EFFECT){
    return;
  }else{
    AcceptEntityInput(particle, "stop");
    CreateTimer(0.3, Timer_Unko, client);
  }
}

CreateParticle(String:effect_name[], Float:position[3])
{
  new ent = CreateEntityByName("info_particle_system");
  TeleportEntity(ent, position, NULL_VECTOR, NULL_VECTOR);
  decl String:name[128];
  Format(name, sizeof(name), "sushi_effect_%i", ent);
  DispatchKeyValue(ent, "targetname", "tf2particle");
  DispatchKeyValue(ent, "effect_name", effect_name);
  if( DispatchSpawn(ent) == true ){
    SetVariantString(name);
    SetVariantString("flag");
    ActivateEntity(ent);
    AcceptEntityInput(ent, "start");
    return ent;
  }else{
    return INVALID_EFFECT;
  }
}
