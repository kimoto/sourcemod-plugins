#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <tf2>

#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo =  
{
  name = "Create Fake Spawn",
  author = "kimoto",
  description = "Create Fake Spawn",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

public OnPluginStart()
{
  RegServerCmd("create_fake_spawn", Command_CreateFakeSpawn);
}

public Action:Command_CreateFakeSpawn(args)
{
  if(args == 2){
    decl String:from[256];
    decl String:fake_name[256];
    GetCmdArg(1, from, sizeof(from));
    GetCmdArg(2, fake_name, sizeof(fake_name));
    LogMessage("arg1: %s", from);
    LogMessage("arg2: %s", fake_name);
    CreateFakeSpawnPoint(from, fake_name, Float:TFTeam_Red);
  }else{
    LogMessage("illegal arguments");
  }
}

CreateFakeSpawnPoint(String:ent_name[], String:new_name[], Float:team_flag)
{
  decl Float:pos[3]; decl Float:ang[3];
  new fake_ent = FindEntityByName("info_player_teamspawn", new_name);
  if(fake_ent == -1){
    new ent = FindEntityByName("info_player_teamspawn", ent_name);
    GetEntPropVector(ent, Prop_Send, "m_vecOrigin", pos);
    GetEntPropVector(ent, Prop_Send, "m_angRotation", ang);
    fake_ent = CreateSpawnPoint(new_name, team_flag);
    TeleportEntity(fake_ent, pos, ang, NULL_VECTOR);
    return fake_ent;
  }else{
    return fake_ent;
  }
}

FindEntityByName(String:entity_type[], String:name[])
{
  new ent = INVALID_ENT_REFERENCE;
  while((ent = FindEntityByClassname(ent, entity_type)) != INVALID_ENT_REFERENCE){
    decl String:buffer[256];
    GetEntPropString(ent, Prop_Data, "m_iName", buffer, sizeof(buffer));
    if(StrEqual(buffer, name)){
      LogMessage("found entity: %d", ent);
      return ent;
    }
  }
  return ent;
}

CreateSpawnPoint(String:name[], Float:team_flag)
{
  new entity = CreateEntityByName("info_player_teamspawn");
  DispatchKeyValue(entity, "targetname", name);
  DispatchKeyValueFloat(entity, "Team", Float:team_flag);
  DispatchSpawn(entity);
  return entity;
}

