#pragma semicolon 1
#include <sourcemod>
#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo =  
{
  name = "TF2 Event Logger",
  author = "kimoto",
  description = "TF2 Event Logger",
  version = PLUGIN_VERSION,
  url = "http://kymt.me/"
};

new bool:gEnabled = false;

//===================================================
//  General Callbacks
//===================================================
// Called once, after the plugin has been fully initialized and can proceed to load.
// Any run-time errors in this function will cause the plugin to fail to load. This is paired with OnPluginEnd(). 
public OnPluginStart()
{
  LogMessage("OnPluginStart");
  RegServerCmd("sm_tf2_event_logger", Command_ToggleEventLogger);
}

public Action:Command_ToggleEventLogger(args)
{
  if(gEnabled == false){
    LogMessage("Starting TF2 Event Logger");
    HookTF2Events();
    gEnabled = true;
  }else{
    LogMessage("Ended TF2 Event Logger");
    UnHookTF2Events();
    gEnabled = false;
  }
}

// Called every time the map loads. If the plugin is loaded late, and the map has already started,
// this function is called anyway after load, in order to preserve pairing. This function is paired with OnMapEnd().
public OnMapStart()
{
  LogMessage("OnMapStart");
}

// Called when the map is about to end. At this point, all clients are disconnected, but TIMER_NO_MAPCHANGE timers are not yet destroyed.
// This function is paired to OnMapStart().
public OnMapEnd()
{
  LogMessage("OnMapEnd");
}

// Called once per map-change after servercfgfile (usually server.cfg), sourcemod.cfg, and all plugin config files have finished executing.
// If a plugin is loaded after this has happened, the callback is called anyway, in order to preserve pairing. This function is paired with OnMapEnd().
public OnConfigsExecuted()
{
  LogMessage("OnConfigsExecuted");
}

// Called once, immediately before the plugin is unloaded. This function is paired to OnPluginStart().
public OnPluginEnd()
{
  LogMessage("OnPluginEnd");
}

//===================================================
//  Client Callbacks
//===================================================
// Called when a player initiates a connection. This is paired with OnClientDisconnect() for successful connections only.
public bool:OnClientConnect(client, String:rejectmsg[], maxlen)
{
  LogMessage("OnClientConnect");
  return true;
}

public OnClientAuthorized(client, const String:auth[])
{
  LogMessage("OnClientAuthorized");
}

public OnClientPutInServer(client)
{
  LogMessage("OnClientPutInServer");
}

public OnClientPostAdminCheck(client)
{
  LogMessage("OnClientPostAdminCheck");
}

public OnClientDisconnect(client)
{
  LogMessage("OnClientDisconnect");
}

//===================================================
//  TF2 Events
//===================================================
public HookTF2Events()
{
  HookEvent("intro_finish", Event_intro_finish);
  HookEvent("intro_nextcamera", Event_intro_nextcamera);
  HookEvent("mm_lobby_chat", Event_mm_lobby_chat);
  HookEvent("mm_lobby_member_join", Event_mm_lobby_member_join);
  HookEvent("mm_lobby_member_leave", Event_mm_lobby_member_leave);
  HookEvent("player_changeclass", Event_player_changeclass);
  HookEvent("player_death", Event_player_death);
  HookEvent("object_removed", Event_object_removed);
  HookEvent("object_destroyed", Event_object_destroyed);
  HookEvent("tf_map_time_remaining", Event_tf_map_time_remaining);
  HookEvent("tf_game_over", Event_tf_game_over);
  HookEvent("ctf_flag_captured", Event_ctf_flag_captured);
  HookEvent("controlpoint_initialized", Event_controlpoint_initialized);
  HookEvent("controlpoint_updateimages", Event_controlpoint_updateimages);
  HookEvent("controlpoint_updatelayout", Event_controlpoint_updatelayout);
  HookEvent("controlpoint_updatecapping", Event_controlpoint_updatecapping);
  HookEvent("controlpoint_updateowner", Event_controlpoint_updateowner);
  HookEvent("controlpoint_starttouch", Event_controlpoint_starttouch);
  HookEvent("controlpoint_endtouch", Event_controlpoint_endtouch);
  HookEvent("controlpoint_pulse_element", Event_controlpoint_pulse_element);
  HookEvent("controlpoint_fake_capture", Event_controlpoint_fake_capture);
  HookEvent("controlpoint_fake_capture_mult", Event_controlpoint_fake_capture_mult);
  HookEvent("teamplay_round_selected", Event_teamplay_round_selected);
  HookEvent("teamplay_round_start", Event_teamplay_round_start);
  HookEvent("teamplay_round_active", Event_teamplay_round_active);
  HookEvent("teamplay_waiting_begins", Event_teamplay_waiting_begins);
  HookEvent("teamplay_waiting_ends", Event_teamplay_waiting_ends);
  HookEvent("teamplay_waiting_abouttoend", Event_teamplay_waiting_abouttoend);
  HookEvent("teamplay_restart_round", Event_teamplay_restart_round);
  HookEvent("teamplay_ready_restart", Event_teamplay_ready_restart);
  HookEvent("teamplay_round_restart_seconds", Event_teamplay_round_restart_seconds);
  HookEvent("teamplay_team_ready", Event_teamplay_team_ready);
  HookEvent("teamplay_round_win", Event_teamplay_round_win);
  HookEvent("teamplay_update_timer", Event_teamplay_update_timer);
  HookEvent("teamplay_round_stalemate", Event_teamplay_round_stalemate);
  HookEvent("teamplay_overtime_begin", Event_teamplay_overtime_begin);
  HookEvent("teamplay_overtime_end", Event_teamplay_overtime_end);
  HookEvent("teamplay_suddendeath_begin", Event_teamplay_suddendeath_begin);
  HookEvent("teamplay_suddendeath_end", Event_teamplay_suddendeath_end);
  HookEvent("teamplay_game_over", Event_teamplay_game_over);
  HookEvent("teamplay_map_time_remaining", Event_teamplay_map_time_remaining);
  HookEvent("teamplay_broadcast_audio", Event_teamplay_broadcast_audio);
  HookEvent("teamplay_timer_flash", Event_teamplay_timer_flash);
  HookEvent("teamplay_timer_time_added", Event_teamplay_timer_time_added);
  HookEvent("teamplay_point_startcapture", Event_teamplay_point_startcapture);
  HookEvent("teamplay_point_captured", Event_teamplay_point_captured);
  HookEvent("teamplay_point_locked", Event_teamplay_point_locked);
  HookEvent("teamplay_point_unlocked", Event_teamplay_point_unlocked);
  HookEvent("teamplay_capture_broken", Event_teamplay_capture_broken);
  HookEvent("teamplay_capture_blocked", Event_teamplay_capture_blocked);
  HookEvent("teamplay_flag_event", Event_teamplay_flag_event);
  HookEvent("teamplay_win_panel", Event_teamplay_win_panel);
  HookEvent("teamplay_teambalanced_player", Event_teamplay_teambalanced_player);
  HookEvent("teamplay_setup_finished", Event_teamplay_setup_finished);
  HookEvent("teamplay_alert", Event_teamplay_alert);
  HookEvent("training_complete", Event_training_complete);
  HookEvent("show_freezepanel", Event_show_freezepanel);
  HookEvent("hide_freezepanel", Event_hide_freezepanel);
  HookEvent("freezecam_started", Event_freezecam_started);
  HookEvent("localplayer_changeteam", Event_localplayer_changeteam);
  HookEvent("localplayer_score_changed", Event_localplayer_score_changed);
  HookEvent("localplayer_changeclass", Event_localplayer_changeclass);
  HookEvent("localplayer_respawn", Event_localplayer_respawn);
  HookEvent("building_info_changed", Event_building_info_changed);
  HookEvent("localplayer_changedisguise", Event_localplayer_changedisguise);
  HookEvent("player_account_changed", Event_player_account_changed);
  HookEvent("spy_pda_reset", Event_spy_pda_reset);
  HookEvent("flagstatus_update", Event_flagstatus_update);
  HookEvent("player_stats_updated", Event_player_stats_updated);
  HookEvent("playing_commentary", Event_playing_commentary);
  HookEvent("player_chargedeployed", Event_player_chargedeployed);
  HookEvent("player_builtobject", Event_player_builtobject);
  HookEvent("player_upgradedobject", Event_player_upgradedobject);
  HookEvent("player_carryobject", Event_player_carryobject);
  HookEvent("player_dropobject", Event_player_dropobject);
  HookEvent("achievement_earned", Event_achievement_earned);
  HookEvent("spec_target_updated", Event_spec_target_updated);
  HookEvent("tournament_stateupdate", Event_tournament_stateupdate);
  HookEvent("player_calledformedic", Event_player_calledformedic);
  HookEvent("localplayer_becameobserver", Event_localplayer_becameobserver);
  HookEvent("player_ignited_inv", Event_player_ignited_inv);
  HookEvent("player_ignited", Event_player_ignited);
  HookEvent("player_extinguished", Event_player_extinguished);
  HookEvent("player_teleported", Event_player_teleported);
  HookEvent("player_healedmediccall", Event_player_healedmediccall);
  HookEvent("localplayer_chargeready", Event_localplayer_chargeready);
  HookEvent("localplayer_winddown", Event_localplayer_winddown);
  HookEvent("player_invulned", Event_player_invulned);
  HookEvent("escort_speed", Event_escort_speed);
  HookEvent("escort_progress", Event_escort_progress);
  HookEvent("escort_recede", Event_escort_recede);
  HookEvent("gameui_activated", Event_gameui_activated);
  HookEvent("gameui_hidden", Event_gameui_hidden);
  HookEvent("player_escort_score", Event_player_escort_score);
  HookEvent("player_healonhit", Event_player_healonhit);
  HookEvent("player_stealsandvich", Event_player_stealsandvich);
  HookEvent("show_class_layout", Event_show_class_layout);
  HookEvent("show_vs_panel", Event_show_vs_panel);
  HookEvent("player_damaged", Event_player_damaged);
  HookEvent("player_hurt", Event_player_hurt);
  HookEvent("arena_player_notification", Event_arena_player_notification);
  HookEvent("arena_match_maxstreak", Event_arena_match_maxstreak);
  HookEvent("arena_round_start", Event_arena_round_start);
  HookEvent("arena_win_panel", Event_arena_win_panel);
  HookEvent("pve_win_panel", Event_pve_win_panel);
  HookEvent("air_dash", Event_air_dash);
  HookEvent("landed", Event_landed);
  HookEvent("player_damage_dodged", Event_player_damage_dodged);
  HookEvent("player_stunned", Event_player_stunned);
  HookEvent("scout_grand_slam", Event_scout_grand_slam);
  HookEvent("scout_slamdoll_landed", Event_scout_slamdoll_landed);
  HookEvent("arrow_impact", Event_arrow_impact);
  HookEvent("player_jarated", Event_player_jarated);
  HookEvent("player_jarated_fade", Event_player_jarated_fade);
  HookEvent("player_shield_blocked", Event_player_shield_blocked);
  HookEvent("player_pinned", Event_player_pinned);
  HookEvent("player_healedbymedic", Event_player_healedbymedic);
  HookEvent("player_spawn", Event_player_spawn);
  HookEvent("player_sapped_object", Event_player_sapped_object);
  HookEvent("item_found", Event_item_found);
  HookEvent("show_annotation", Event_show_annotation);
  HookEvent("hide_annotation", Event_hide_annotation);
  HookEvent("post_inventory_application", Event_post_inventory_application);
  HookEvent("controlpoint_unlock_updated", Event_controlpoint_unlock_updated);
  HookEvent("deploy_buff_banner", Event_deploy_buff_banner);
  HookEvent("player_buff", Event_player_buff);
  HookEvent("medic_death", Event_medic_death);
  HookEvent("overtime_nag", Event_overtime_nag);
  HookEvent("teams_changed", Event_teams_changed);
  HookEvent("halloween_pumpkin_grab", Event_halloween_pumpkin_grab);
  HookEvent("rocket_jump", Event_rocket_jump);
  HookEvent("rocket_jump_landed", Event_rocket_jump_landed);
  HookEvent("sticky_jump", Event_sticky_jump);
  HookEvent("sticky_jump_landed", Event_sticky_jump_landed);
  HookEvent("medic_defended", Event_medic_defended);
  HookEvent("localplayer_healed", Event_localplayer_healed);
  HookEvent("player_destroyed_pipebomb", Event_player_destroyed_pipebomb);
  HookEvent("object_deflected", Event_object_deflected);
  HookEvent("player_mvp", Event_player_mvp);
  HookEvent("raid_spawn_mob", Event_raid_spawn_mob);
  HookEvent("raid_spawn_squad", Event_raid_spawn_squad);
  HookEvent("nav_blocked", Event_nav_blocked);
  HookEvent("path_track_passed", Event_path_track_passed);
  HookEvent("num_cappers_changed", Event_num_cappers_changed);
  HookEvent("player_regenerate", Event_player_regenerate);
  HookEvent("update_status_item", Event_update_status_item);
  HookEvent("stats_resetround", Event_stats_resetround);
  HookEvent("achievement_earned_local", Event_achievement_earned_local);
  HookEvent("player_healed", Event_player_healed);
  HookEvent("item_pickup", Event_item_pickup);
  HookEvent("duel_status", Event_duel_status);
  HookEvent("fish_notice", Event_fish_notice);
  HookEvent("fish_notice__arm", Event_fish_notice__arm);
  HookEvent("pumpkin_lord_summoned", Event_pumpkin_lord_summoned);
  HookEvent("pumpkin_lord_killed", Event_pumpkin_lord_killed);
  HookEvent("eyeball_boss_summoned", Event_eyeball_boss_summoned);
  HookEvent("eyeball_boss_stunned", Event_eyeball_boss_stunned);
  HookEvent("eyeball_boss_killed", Event_eyeball_boss_killed);
  HookEvent("eyeball_boss_killer", Event_eyeball_boss_killer);
  HookEvent("eyeball_boss_escape_imminent", Event_eyeball_boss_escape_imminent);
  HookEvent("eyeball_boss_escaped", Event_eyeball_boss_escaped);
  HookEvent("npc_hurt", Event_npc_hurt);
  HookEvent("controlpoint_timer_updated", Event_controlpoint_timer_updated);
  HookEvent("player_highfive_start", Event_player_highfive_start);
  HookEvent("player_highfive_cancel", Event_player_highfive_cancel);
  HookEvent("player_highfive_success", Event_player_highfive_success);
  HookEvent("player_bonuspoints", Event_player_bonuspoints);
  HookEvent("player_upgraded", Event_player_upgraded);
  HookEvent("player_buyback", Event_player_buyback);
  HookEvent("player_used_powerup_bottle", Event_player_used_powerup_bottle);
  HookEvent("christmas_gift_grab", Event_christmas_gift_grab);
  HookEvent("player_killed_achievement_zone", Event_player_killed_achievement_zone);
  HookEvent("party_updated", Event_party_updated);
  HookEvent("lobby_updated", Event_lobby_updated);
  HookEvent("mvm_mission_update", Event_mvm_mission_update);
  HookEvent("recalculate_holidays", Event_recalculate_holidays);
  HookEvent("player_currency_changed", Event_player_currency_changed);
  HookEvent("doomsday_rocket_open", Event_doomsday_rocket_open);
  //HookEvent("remove_nemesis_relationship", Event_remove_nemesis_relationship);
  HookEvent("mvm_creditbonus_wave", Event_mvm_creditbonus_wave);
  HookEvent("mvm_creditbonus_all", Event_mvm_creditbonus_all);
  HookEvent("mvm_creditbonus_all_advanced", Event_mvm_creditbonus_all_advanced);
  HookEvent("mvm_quick_sentry_upgrade", Event_mvm_quick_sentry_upgrade);
  HookEvent("mvm_tank_destroyed_by_players", Event_mvm_tank_destroyed_by_players);
  HookEvent("mvm_kill_robot_delivering_bomb", Event_mvm_kill_robot_delivering_bomb);
  HookEvent("mvm_pickup_currency", Event_mvm_pickup_currency);
  HookEvent("mvm_bomb_carrier_killed", Event_mvm_bomb_carrier_killed);
  HookEvent("mvm_sentrybuster_detonate", Event_mvm_sentrybuster_detonate);
  HookEvent("mvm_scout_marked_for_death", Event_mvm_scout_marked_for_death);
  HookEvent("mvm_medic_powerup_shared", Event_mvm_medic_powerup_shared);
  HookEvent("mvm_begin_wave", Event_mvm_begin_wave);
  HookEvent("mvm_wave_complete", Event_mvm_wave_complete);
  HookEvent("mvm_mission_complete", Event_mvm_mission_complete);
  HookEvent("mvm_bomb_reset_by_player", Event_mvm_bomb_reset_by_player);
  HookEvent("mvm_bomb_alarm_triggered", Event_mvm_bomb_alarm_triggered);
  HookEvent("mvm_bomb_deploy_reset_by_player", Event_mvm_bomb_deploy_reset_by_player);
}

public UnHookTF2Events()
{
  UnhookEvent("intro_finish", Event_intro_finish);
  UnhookEvent("intro_nextcamera", Event_intro_nextcamera);
  UnhookEvent("mm_lobby_chat", Event_mm_lobby_chat);
  UnhookEvent("mm_lobby_member_join", Event_mm_lobby_member_join);
  UnhookEvent("mm_lobby_member_leave", Event_mm_lobby_member_leave);
  UnhookEvent("player_changeclass", Event_player_changeclass);
  UnhookEvent("player_death", Event_player_death);
  UnhookEvent("object_removed", Event_object_removed);
  UnhookEvent("object_destroyed", Event_object_destroyed);
  UnhookEvent("tf_map_time_remaining", Event_tf_map_time_remaining);
  UnhookEvent("tf_game_over", Event_tf_game_over);
  UnhookEvent("ctf_flag_captured", Event_ctf_flag_captured);
  UnhookEvent("controlpoint_initialized", Event_controlpoint_initialized);
  UnhookEvent("controlpoint_updateimages", Event_controlpoint_updateimages);
  UnhookEvent("controlpoint_updatelayout", Event_controlpoint_updatelayout);
  UnhookEvent("controlpoint_updatecapping", Event_controlpoint_updatecapping);
  UnhookEvent("controlpoint_updateowner", Event_controlpoint_updateowner);
  UnhookEvent("controlpoint_starttouch", Event_controlpoint_starttouch);
  UnhookEvent("controlpoint_endtouch", Event_controlpoint_endtouch);
  UnhookEvent("controlpoint_pulse_element", Event_controlpoint_pulse_element);
  UnhookEvent("controlpoint_fake_capture", Event_controlpoint_fake_capture);
  UnhookEvent("controlpoint_fake_capture_mult", Event_controlpoint_fake_capture_mult);
  UnhookEvent("teamplay_round_selected", Event_teamplay_round_selected);
  UnhookEvent("teamplay_round_start", Event_teamplay_round_start);
  UnhookEvent("teamplay_round_active", Event_teamplay_round_active);
  UnhookEvent("teamplay_waiting_begins", Event_teamplay_waiting_begins);
  UnhookEvent("teamplay_waiting_ends", Event_teamplay_waiting_ends);
  UnhookEvent("teamplay_waiting_abouttoend", Event_teamplay_waiting_abouttoend);
  UnhookEvent("teamplay_restart_round", Event_teamplay_restart_round);
  UnhookEvent("teamplay_ready_restart", Event_teamplay_ready_restart);
  UnhookEvent("teamplay_round_restart_seconds", Event_teamplay_round_restart_seconds);
  UnhookEvent("teamplay_team_ready", Event_teamplay_team_ready);
  UnhookEvent("teamplay_round_win", Event_teamplay_round_win);
  UnhookEvent("teamplay_update_timer", Event_teamplay_update_timer);
  UnhookEvent("teamplay_round_stalemate", Event_teamplay_round_stalemate);
  UnhookEvent("teamplay_overtime_begin", Event_teamplay_overtime_begin);
  UnhookEvent("teamplay_overtime_end", Event_teamplay_overtime_end);
  UnhookEvent("teamplay_suddendeath_begin", Event_teamplay_suddendeath_begin);
  UnhookEvent("teamplay_suddendeath_end", Event_teamplay_suddendeath_end);
  UnhookEvent("teamplay_game_over", Event_teamplay_game_over);
  UnhookEvent("teamplay_map_time_remaining", Event_teamplay_map_time_remaining);
  UnhookEvent("teamplay_broadcast_audio", Event_teamplay_broadcast_audio);
  UnhookEvent("teamplay_timer_flash", Event_teamplay_timer_flash);
  UnhookEvent("teamplay_timer_time_added", Event_teamplay_timer_time_added);
  UnhookEvent("teamplay_point_startcapture", Event_teamplay_point_startcapture);
  UnhookEvent("teamplay_point_captured", Event_teamplay_point_captured);
  UnhookEvent("teamplay_point_locked", Event_teamplay_point_locked);
  UnhookEvent("teamplay_point_unlocked", Event_teamplay_point_unlocked);
  UnhookEvent("teamplay_capture_broken", Event_teamplay_capture_broken);
  UnhookEvent("teamplay_capture_blocked", Event_teamplay_capture_blocked);
  UnhookEvent("teamplay_flag_event", Event_teamplay_flag_event);
  UnhookEvent("teamplay_win_panel", Event_teamplay_win_panel);
  UnhookEvent("teamplay_teambalanced_player", Event_teamplay_teambalanced_player);
  UnhookEvent("teamplay_setup_finished", Event_teamplay_setup_finished);
  UnhookEvent("teamplay_alert", Event_teamplay_alert);
  UnhookEvent("training_complete", Event_training_complete);
  UnhookEvent("show_freezepanel", Event_show_freezepanel);
  UnhookEvent("hide_freezepanel", Event_hide_freezepanel);
  UnhookEvent("freezecam_started", Event_freezecam_started);
  UnhookEvent("localplayer_changeteam", Event_localplayer_changeteam);
  UnhookEvent("localplayer_score_changed", Event_localplayer_score_changed);
  UnhookEvent("localplayer_changeclass", Event_localplayer_changeclass);
  UnhookEvent("localplayer_respawn", Event_localplayer_respawn);
  UnhookEvent("building_info_changed", Event_building_info_changed);
  UnhookEvent("localplayer_changedisguise", Event_localplayer_changedisguise);
  UnhookEvent("player_account_changed", Event_player_account_changed);
  UnhookEvent("spy_pda_reset", Event_spy_pda_reset);
  UnhookEvent("flagstatus_update", Event_flagstatus_update);
  UnhookEvent("player_stats_updated", Event_player_stats_updated);
  UnhookEvent("playing_commentary", Event_playing_commentary);
  UnhookEvent("player_chargedeployed", Event_player_chargedeployed);
  UnhookEvent("player_builtobject", Event_player_builtobject);
  UnhookEvent("player_upgradedobject", Event_player_upgradedobject);
  UnhookEvent("player_carryobject", Event_player_carryobject);
  UnhookEvent("player_dropobject", Event_player_dropobject);
  UnhookEvent("achievement_earned", Event_achievement_earned);
  UnhookEvent("spec_target_updated", Event_spec_target_updated);
  UnhookEvent("tournament_stateupdate", Event_tournament_stateupdate);
  UnhookEvent("player_calledformedic", Event_player_calledformedic);
  UnhookEvent("localplayer_becameobserver", Event_localplayer_becameobserver);
  UnhookEvent("player_ignited_inv", Event_player_ignited_inv);
  UnhookEvent("player_ignited", Event_player_ignited);
  UnhookEvent("player_extinguished", Event_player_extinguished);
  UnhookEvent("player_teleported", Event_player_teleported);
  UnhookEvent("player_healedmediccall", Event_player_healedmediccall);
  UnhookEvent("localplayer_chargeready", Event_localplayer_chargeready);
  UnhookEvent("localplayer_winddown", Event_localplayer_winddown);
  UnhookEvent("player_invulned", Event_player_invulned);
  UnhookEvent("escort_speed", Event_escort_speed);
  UnhookEvent("escort_progress", Event_escort_progress);
  UnhookEvent("escort_recede", Event_escort_recede);
  UnhookEvent("gameui_activated", Event_gameui_activated);
  UnhookEvent("gameui_hidden", Event_gameui_hidden);
  UnhookEvent("player_escort_score", Event_player_escort_score);
  UnhookEvent("player_healonhit", Event_player_healonhit);
  UnhookEvent("player_stealsandvich", Event_player_stealsandvich);
  UnhookEvent("show_class_layout", Event_show_class_layout);
  UnhookEvent("show_vs_panel", Event_show_vs_panel);
  UnhookEvent("player_damaged", Event_player_damaged);
  UnhookEvent("player_hurt", Event_player_hurt);
  UnhookEvent("arena_player_notification", Event_arena_player_notification);
  UnhookEvent("arena_match_maxstreak", Event_arena_match_maxstreak);
  UnhookEvent("arena_round_start", Event_arena_round_start);
  UnhookEvent("arena_win_panel", Event_arena_win_panel);
  UnhookEvent("pve_win_panel", Event_pve_win_panel);
  UnhookEvent("air_dash", Event_air_dash);
  UnhookEvent("landed", Event_landed);
  UnhookEvent("player_damage_dodged", Event_player_damage_dodged);
  UnhookEvent("player_stunned", Event_player_stunned);
  UnhookEvent("scout_grand_slam", Event_scout_grand_slam);
  UnhookEvent("scout_slamdoll_landed", Event_scout_slamdoll_landed);
  UnhookEvent("arrow_impact", Event_arrow_impact);
  UnhookEvent("player_jarated", Event_player_jarated);
  UnhookEvent("player_jarated_fade", Event_player_jarated_fade);
  UnhookEvent("player_shield_blocked", Event_player_shield_blocked);
  UnhookEvent("player_pinned", Event_player_pinned);
  UnhookEvent("player_healedbymedic", Event_player_healedbymedic);
  UnhookEvent("player_spawn", Event_player_spawn);
  UnhookEvent("player_sapped_object", Event_player_sapped_object);
  UnhookEvent("item_found", Event_item_found);
  UnhookEvent("show_annotation", Event_show_annotation);
  UnhookEvent("hide_annotation", Event_hide_annotation);
  UnhookEvent("post_inventory_application", Event_post_inventory_application);
  UnhookEvent("controlpoint_unlock_updated", Event_controlpoint_unlock_updated);
  UnhookEvent("deploy_buff_banner", Event_deploy_buff_banner);
  UnhookEvent("player_buff", Event_player_buff);
  UnhookEvent("medic_death", Event_medic_death);
  UnhookEvent("overtime_nag", Event_overtime_nag);
  UnhookEvent("teams_changed", Event_teams_changed);
  UnhookEvent("halloween_pumpkin_grab", Event_halloween_pumpkin_grab);
  UnhookEvent("rocket_jump", Event_rocket_jump);
  UnhookEvent("rocket_jump_landed", Event_rocket_jump_landed);
  UnhookEvent("sticky_jump", Event_sticky_jump);
  UnhookEvent("sticky_jump_landed", Event_sticky_jump_landed);
  UnhookEvent("medic_defended", Event_medic_defended);
  UnhookEvent("localplayer_healed", Event_localplayer_healed);
  UnhookEvent("player_destroyed_pipebomb", Event_player_destroyed_pipebomb);
  UnhookEvent("object_deflected", Event_object_deflected);
  UnhookEvent("player_mvp", Event_player_mvp);
  UnhookEvent("raid_spawn_mob", Event_raid_spawn_mob);
  UnhookEvent("raid_spawn_squad", Event_raid_spawn_squad);
  UnhookEvent("nav_blocked", Event_nav_blocked);
  UnhookEvent("path_track_passed", Event_path_track_passed);
  UnhookEvent("num_cappers_changed", Event_num_cappers_changed);
  UnhookEvent("player_regenerate", Event_player_regenerate);
  UnhookEvent("update_status_item", Event_update_status_item);
  UnhookEvent("stats_resetround", Event_stats_resetround);
  UnhookEvent("achievement_earned_local", Event_achievement_earned_local);
  UnhookEvent("player_healed", Event_player_healed);
  UnhookEvent("item_pickup", Event_item_pickup);
  UnhookEvent("duel_status", Event_duel_status);
  UnhookEvent("fish_notice", Event_fish_notice);
  UnhookEvent("fish_notice__arm", Event_fish_notice__arm);
  UnhookEvent("pumpkin_lord_summoned", Event_pumpkin_lord_summoned);
  UnhookEvent("pumpkin_lord_killed", Event_pumpkin_lord_killed);
  UnhookEvent("eyeball_boss_summoned", Event_eyeball_boss_summoned);
  UnhookEvent("eyeball_boss_stunned", Event_eyeball_boss_stunned);
  UnhookEvent("eyeball_boss_killed", Event_eyeball_boss_killed);
  UnhookEvent("eyeball_boss_killer", Event_eyeball_boss_killer);
  UnhookEvent("eyeball_boss_escape_imminent", Event_eyeball_boss_escape_imminent);
  UnhookEvent("eyeball_boss_escaped", Event_eyeball_boss_escaped);
  UnhookEvent("npc_hurt", Event_npc_hurt);
  UnhookEvent("controlpoint_timer_updated", Event_controlpoint_timer_updated);
  UnhookEvent("player_highfive_start", Event_player_highfive_start);
  UnhookEvent("player_highfive_cancel", Event_player_highfive_cancel);
  UnhookEvent("player_highfive_success", Event_player_highfive_success);
  UnhookEvent("player_bonuspoints", Event_player_bonuspoints);
  UnhookEvent("player_upgraded", Event_player_upgraded);
  UnhookEvent("player_buyback", Event_player_buyback);
  UnhookEvent("player_used_powerup_bottle", Event_player_used_powerup_bottle);
  UnhookEvent("christmas_gift_grab", Event_christmas_gift_grab);
  UnhookEvent("player_killed_achievement_zone", Event_player_killed_achievement_zone);
  UnhookEvent("party_updated", Event_party_updated);
  UnhookEvent("lobby_updated", Event_lobby_updated);
  UnhookEvent("mvm_mission_update", Event_mvm_mission_update);
  UnhookEvent("recalculate_holidays", Event_recalculate_holidays);
  UnhookEvent("player_currency_changed", Event_player_currency_changed);
  UnhookEvent("doomsday_rocket_open", Event_doomsday_rocket_open);
  //UnhookEvent("remove_nemesis_relationship", Event_remove_nemesis_relationship);
  UnhookEvent("mvm_creditbonus_wave", Event_mvm_creditbonus_wave);
  UnhookEvent("mvm_creditbonus_all", Event_mvm_creditbonus_all);
  UnhookEvent("mvm_creditbonus_all_advanced", Event_mvm_creditbonus_all_advanced);
  UnhookEvent("mvm_quick_sentry_upgrade", Event_mvm_quick_sentry_upgrade);
  UnhookEvent("mvm_tank_destroyed_by_players", Event_mvm_tank_destroyed_by_players);
  UnhookEvent("mvm_kill_robot_delivering_bomb", Event_mvm_kill_robot_delivering_bomb);
  UnhookEvent("mvm_pickup_currency", Event_mvm_pickup_currency);
  UnhookEvent("mvm_bomb_carrier_killed", Event_mvm_bomb_carrier_killed);
  UnhookEvent("mvm_sentrybuster_detonate", Event_mvm_sentrybuster_detonate);
  UnhookEvent("mvm_scout_marked_for_death", Event_mvm_scout_marked_for_death);
  UnhookEvent("mvm_medic_powerup_shared", Event_mvm_medic_powerup_shared);
  UnhookEvent("mvm_begin_wave", Event_mvm_begin_wave);
  UnhookEvent("mvm_wave_complete", Event_mvm_wave_complete);
  UnhookEvent("mvm_mission_complete", Event_mvm_mission_complete);
  UnhookEvent("mvm_bomb_reset_by_player", Event_mvm_bomb_reset_by_player);
  UnhookEvent("mvm_bomb_alarm_triggered", Event_mvm_bomb_alarm_triggered);
  UnhookEvent("mvm_bomb_deploy_reset_by_player", Event_mvm_bomb_deploy_reset_by_player);
}

public Action:Event_intro_finish(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("intro_finish"); }
public Action:Event_intro_nextcamera(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("intro_nextcamera"); }
public Action:Event_mm_lobby_chat(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mm_lobby_chat"); }
public Action:Event_mm_lobby_member_join(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mm_lobby_member_join"); }
public Action:Event_mm_lobby_member_leave(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mm_lobby_member_leave"); }
public Action:Event_player_changeclass(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_changeclass"); }
public Action:Event_player_death(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_death"); }
public Action:Event_object_removed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("object_removed"); }
public Action:Event_object_destroyed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("object_destroyed"); }
public Action:Event_tf_map_time_remaining(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("tf_map_time_remaining"); }
public Action:Event_tf_game_over(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("tf_game_over"); }
public Action:Event_ctf_flag_captured(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("ctf_flag_captured"); }
public Action:Event_controlpoint_initialized(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_initialized"); }
public Action:Event_controlpoint_updateimages(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_updateimages"); }
public Action:Event_controlpoint_updatelayout(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_updatelayout"); }
public Action:Event_controlpoint_updatecapping(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_updatecapping"); }
public Action:Event_controlpoint_updateowner(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_updateowner"); }
public Action:Event_controlpoint_starttouch(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_starttouch"); }
public Action:Event_controlpoint_endtouch(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_endtouch"); }
public Action:Event_controlpoint_pulse_element(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_pulse_element"); }
public Action:Event_controlpoint_fake_capture(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_fake_capture"); }
public Action:Event_controlpoint_fake_capture_mult(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_fake_capture_mult"); }
public Action:Event_teamplay_round_selected(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_round_selected"); }
public Action:Event_teamplay_round_start(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_round_start"); }
public Action:Event_teamplay_round_active(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_round_active"); }
public Action:Event_teamplay_waiting_begins(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_waiting_begins"); }
public Action:Event_teamplay_waiting_ends(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_waiting_ends"); }
public Action:Event_teamplay_waiting_abouttoend(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_waiting_abouttoend"); }
public Action:Event_teamplay_restart_round(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_restart_round"); }
public Action:Event_teamplay_ready_restart(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_ready_restart"); }
public Action:Event_teamplay_round_restart_seconds(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_round_restart_seconds"); }
public Action:Event_teamplay_team_ready(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_team_ready"); }
public Action:Event_teamplay_round_win(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_round_win"); }
public Action:Event_teamplay_update_timer(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_update_timer"); }
public Action:Event_teamplay_round_stalemate(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_round_stalemate"); }
public Action:Event_teamplay_overtime_begin(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_overtime_begin"); }
public Action:Event_teamplay_overtime_end(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_overtime_end"); }
public Action:Event_teamplay_suddendeath_begin(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_suddendeath_begin"); }
public Action:Event_teamplay_suddendeath_end(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_suddendeath_end"); }
public Action:Event_teamplay_game_over(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_game_over"); }
public Action:Event_teamplay_map_time_remaining(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_map_time_remaining"); }
public Action:Event_teamplay_broadcast_audio(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_broadcast_audio"); }
public Action:Event_teamplay_timer_flash(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_timer_flash"); }
public Action:Event_teamplay_timer_time_added(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_timer_time_added"); }
public Action:Event_teamplay_point_startcapture(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_point_startcapture"); }
public Action:Event_teamplay_point_captured(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_point_captured"); }
public Action:Event_teamplay_point_locked(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_point_locked"); }
public Action:Event_teamplay_point_unlocked(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_point_unlocked"); }
public Action:Event_teamplay_capture_broken(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_capture_broken"); }
public Action:Event_teamplay_capture_blocked(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_capture_blocked"); }
public Action:Event_teamplay_flag_event(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_flag_event"); }
public Action:Event_teamplay_win_panel(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_win_panel"); }
public Action:Event_teamplay_teambalanced_player(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_teambalanced_player"); }
public Action:Event_teamplay_setup_finished(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_setup_finished"); }
public Action:Event_teamplay_alert(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teamplay_alert"); }
public Action:Event_training_complete(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("training_complete"); }
public Action:Event_show_freezepanel(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("show_freezepanel"); }
public Action:Event_hide_freezepanel(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("hide_freezepanel"); }
public Action:Event_freezecam_started(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("freezecam_started"); }
public Action:Event_localplayer_changeteam(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_changeteam"); }
public Action:Event_localplayer_score_changed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_score_changed"); }
public Action:Event_localplayer_changeclass(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_changeclass"); }
public Action:Event_localplayer_respawn(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_respawn"); }
public Action:Event_building_info_changed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("building_info_changed"); }
public Action:Event_localplayer_changedisguise(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_changedisguise"); }
public Action:Event_player_account_changed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_account_changed"); }
public Action:Event_spy_pda_reset(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("spy_pda_reset"); }
public Action:Event_flagstatus_update(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("flagstatus_update"); }
public Action:Event_player_stats_updated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_stats_updated"); }
public Action:Event_playing_commentary(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("playing_commentary"); }
public Action:Event_player_chargedeployed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_chargedeployed"); }
public Action:Event_player_builtobject(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_builtobject"); }
public Action:Event_player_upgradedobject(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_upgradedobject"); }
public Action:Event_player_carryobject(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_carryobject"); }
public Action:Event_player_dropobject(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_dropobject"); }
public Action:Event_achievement_earned(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("achievement_earned"); }
public Action:Event_spec_target_updated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("spec_target_updated"); }
public Action:Event_tournament_stateupdate(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("tournament_stateupdate"); }
public Action:Event_player_calledformedic(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_calledformedic"); }
public Action:Event_localplayer_becameobserver(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_becameobserver"); }
public Action:Event_player_ignited_inv(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_ignited_inv"); }
public Action:Event_player_ignited(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_ignited"); }
public Action:Event_player_extinguished(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_extinguished"); }
public Action:Event_player_teleported(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_teleported"); }
public Action:Event_player_healedmediccall(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_healedmediccall"); }
public Action:Event_localplayer_chargeready(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_chargeready"); }
public Action:Event_localplayer_winddown(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_winddown"); }
public Action:Event_player_invulned(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_invulned"); }
public Action:Event_escort_speed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("escort_speed"); }
public Action:Event_escort_progress(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("escort_progress"); }
public Action:Event_escort_recede(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("escort_recede"); }
public Action:Event_gameui_activated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("gameui_activated"); }
public Action:Event_gameui_hidden(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("gameui_hidden"); }
public Action:Event_player_escort_score(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_escort_score"); }
public Action:Event_player_healonhit(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_healonhit"); }
public Action:Event_player_stealsandvich(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_stealsandvich"); }
public Action:Event_show_class_layout(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("show_class_layout"); }
public Action:Event_show_vs_panel(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("show_vs_panel"); }
public Action:Event_player_damaged(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_damaged"); }
public Action:Event_player_hurt(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_hurt"); }
public Action:Event_arena_player_notification(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("arena_player_notification"); }
public Action:Event_arena_match_maxstreak(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("arena_match_maxstreak"); }
public Action:Event_arena_round_start(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("arena_round_start"); }
public Action:Event_arena_win_panel(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("arena_win_panel"); }
public Action:Event_pve_win_panel(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("pve_win_panel"); }
public Action:Event_air_dash(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("air_dash"); }
public Action:Event_landed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("landed"); }
public Action:Event_player_damage_dodged(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_damage_dodged"); }
public Action:Event_player_stunned(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_stunned"); }
public Action:Event_scout_grand_slam(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("scout_grand_slam"); }
public Action:Event_scout_slamdoll_landed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("scout_slamdoll_landed"); }
public Action:Event_arrow_impact(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("arrow_impact"); }
public Action:Event_player_jarated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_jarated"); }
public Action:Event_player_jarated_fade(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_jarated_fade"); }
public Action:Event_player_shield_blocked(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_shield_blocked"); }
public Action:Event_player_pinned(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_pinned"); }
public Action:Event_player_healedbymedic(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_healedbymedic"); }
public Action:Event_player_spawn(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_spawn"); }
public Action:Event_player_sapped_object(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_sapped_object"); }
public Action:Event_item_found(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("item_found"); }
public Action:Event_show_annotation(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("show_annotation"); }
public Action:Event_hide_annotation(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("hide_annotation"); }
public Action:Event_post_inventory_application(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("post_inventory_application"); }
public Action:Event_controlpoint_unlock_updated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_unlock_updated"); }
public Action:Event_deploy_buff_banner(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("deploy_buff_banner"); }
public Action:Event_player_buff(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_buff"); }
public Action:Event_medic_death(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("medic_death"); }
public Action:Event_overtime_nag(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("overtime_nag"); }
public Action:Event_teams_changed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("teams_changed"); }
public Action:Event_halloween_pumpkin_grab(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("halloween_pumpkin_grab"); }
public Action:Event_rocket_jump(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("rocket_jump"); }
public Action:Event_rocket_jump_landed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("rocket_jump_landed"); }
public Action:Event_sticky_jump(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("sticky_jump"); }
public Action:Event_sticky_jump_landed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("sticky_jump_landed"); }
public Action:Event_medic_defended(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("medic_defended"); }
public Action:Event_localplayer_healed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("localplayer_healed"); }
public Action:Event_player_destroyed_pipebomb(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_destroyed_pipebomb"); }
public Action:Event_object_deflected(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("object_deflected"); }
public Action:Event_player_mvp(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_mvp"); }
public Action:Event_raid_spawn_mob(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("raid_spawn_mob"); }
public Action:Event_raid_spawn_squad(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("raid_spawn_squad"); }
public Action:Event_nav_blocked(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("nav_blocked"); }
public Action:Event_path_track_passed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("path_track_passed"); }
public Action:Event_num_cappers_changed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("num_cappers_changed"); }
public Action:Event_player_regenerate(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_regenerate"); }
public Action:Event_update_status_item(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("update_status_item"); }
public Action:Event_stats_resetround(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("stats_resetround"); }
public Action:Event_achievement_earned_local(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("achievement_earned_local"); }
public Action:Event_player_healed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_healed"); }
public Action:Event_item_pickup(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("item_pickup"); }
public Action:Event_duel_status(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("duel_status"); }
public Action:Event_fish_notice(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("fish_notice"); }
public Action:Event_fish_notice__arm(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("fish_notice__arm"); }
public Action:Event_pumpkin_lord_summoned(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("pumpkin_lord_summoned"); }
public Action:Event_pumpkin_lord_killed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("pumpkin_lord_killed"); }
public Action:Event_eyeball_boss_summoned(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("eyeball_boss_summoned"); }
public Action:Event_eyeball_boss_stunned(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("eyeball_boss_stunned"); }
public Action:Event_eyeball_boss_killed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("eyeball_boss_killed"); }
public Action:Event_eyeball_boss_killer(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("eyeball_boss_killer"); }
public Action:Event_eyeball_boss_escape_imminent(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("eyeball_boss_escape_imminent"); }
public Action:Event_eyeball_boss_escaped(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("eyeball_boss_escaped"); }
public Action:Event_npc_hurt(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("npc_hurt"); }
public Action:Event_controlpoint_timer_updated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("controlpoint_timer_updated"); }
public Action:Event_player_highfive_start(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_highfive_start"); }
public Action:Event_player_highfive_cancel(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_highfive_cancel"); }
public Action:Event_player_highfive_success(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_highfive_success"); }
public Action:Event_player_bonuspoints(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_bonuspoints"); }
public Action:Event_player_upgraded(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_upgraded"); }
public Action:Event_player_buyback(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_buyback"); }
public Action:Event_player_used_powerup_bottle(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_used_powerup_bottle"); }
public Action:Event_christmas_gift_grab(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("christmas_gift_grab"); }
public Action:Event_player_killed_achievement_zone(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_killed_achievement_zone"); }
public Action:Event_party_updated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("party_updated"); }
public Action:Event_lobby_updated(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("lobby_updated"); }
public Action:Event_mvm_mission_update(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_mission_update"); }
public Action:Event_recalculate_holidays(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("recalculate_holidays"); }
public Action:Event_player_currency_changed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("player_currency_changed"); }
public Action:Event_doomsday_rocket_open(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("doomsday_rocket_open"); }
public Action:Event_remove_nemesis_relationship(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("remove_nemesis_relationship"); }
public Action:Event_mvm_creditbonus_wave(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_creditbonus_wave"); }
public Action:Event_mvm_creditbonus_all(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_creditbonus_all"); }
public Action:Event_mvm_creditbonus_all_advanced(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_creditbonus_all_advanced"); }
public Action:Event_mvm_quick_sentry_upgrade(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_quick_sentry_upgrade"); }
public Action:Event_mvm_tank_destroyed_by_players(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_tank_destroyed_by_players"); }
public Action:Event_mvm_kill_robot_delivering_bomb(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_kill_robot_delivering_bomb"); }
public Action:Event_mvm_pickup_currency(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_pickup_currency"); }
public Action:Event_mvm_bomb_carrier_killed(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_bomb_carrier_killed"); }
public Action:Event_mvm_sentrybuster_detonate(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_sentrybuster_detonate"); }
public Action:Event_mvm_scout_marked_for_death(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_scout_marked_for_death"); }
public Action:Event_mvm_medic_powerup_shared(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_medic_powerup_shared"); }
public Action:Event_mvm_begin_wave(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_begin_wave"); }
public Action:Event_mvm_wave_complete(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_wave_complete"); }
public Action:Event_mvm_mission_complete(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_mission_complete"); }
public Action:Event_mvm_bomb_reset_by_player(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_bomb_reset_by_player"); }
public Action:Event_mvm_bomb_alarm_triggered(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_bomb_alarm_triggered"); }
public Action:Event_mvm_bomb_deploy_reset_by_player(Handle:event, const String:name[], bool:dontBroadcast){ LogMessage("mvm_bomb_deploy_reset_by_player"); }
