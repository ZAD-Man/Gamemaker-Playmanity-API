/// @description Send heartbeats to Playmanity to keep the game session alive
if (global.plm_game_session_active) {
	var session_heartbeat_url = "https://app.playmanity.net/api/games/sessions/heartbeat"
    var session_heartbeat_json_data = json_stringify({"auth_token": global.plm_auth_token})
    
    plm_session_heartbeat_request = http_request(session_heartbeat_url, "POST", global.plm_url_headers, session_heartbeat_json_data)
}
