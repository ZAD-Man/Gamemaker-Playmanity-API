/// @description Handle various callbacks from calling the Playmanity API

var request_id = async_load[? "id"]

// Initialize Authorization Call
if (request_id == global.plm_auth_init_request)
{
    if (async_load[? "status"] == 0)
    {
        var result_string = async_load[? "result"];
        var result = json_parse(result_string)
        var plm_auth_url = struct_get(result, "auth_url")
        plm_auth_id = struct_get(result, "auth_id")
        url_open(plm_auth_url)
        alarm[0] = 60 // Once per second, check whether they've signed in
    } else {
        // By default, this error message will appear and the game will end, if Playmanity cannot be reached
        // You can change this behavior as needed
        show_message("Could not connect to Playmanity, please try again.")
        game_end()
    }
}

// Authorization Status Call
if (request_id == plm_auth_status_request)
{
    if (async_load[? "status"] == 0)
    {
        var result_string = async_load[? "result"]
        if (result_string != "") {
            var result = json_parse(result_string)
            var status = struct_get(result, "status")
            if (status == "valid") {
                global.plm_auth_token  = struct_get(result, "auth_token")
                alarm[1] = 0 // Stop checking for sign in since it just succeeded
                
                global.plm_user_logged_in = true // Check this to see whether the user has logged in
                
                var session_create_url = "https://app.playmanity.net/api/games/sessions/initiate"
                var session_create_json_data = json_stringify({"auth_token": global.plm_auth_token})
                
                global.plm_session_create_request = http_request(session_create_url, "POST", global.plm_url_headers, session_create_json_data)
            } else {
                global.plm_user_logged_in = false
            }
        }
    }
}

// Game Session Creation Call
if (request_id == global.plm_session_create_request) {
    if (async_load[? "status"] == 0)
    {
        var result_string = async_load[? "result"];
        var result = json_parse(result_string)
        var success = struct_get(result, "success")
        if (success) {
            alarm[1] = 60 * 8.5 // Start sending a heartbeat every 8.5 seconds to keep session alive
            global.plm_game_session_active = true // Your code can check this to make sure the session is active
        } else {
            var error = struct_get(result, "error")
            var error_code = struct_get(error, "code")
            if (error_code == "ALREADY_IN_GAME") {
            	alarm[1] = 60 * 8.5 // Session already exists, so start sending more heartbeats
                global.plm_game_session_active = true
            } else {
                // If a session was not created, try again
                global.plm_game_session_active = false
                
                var session_create_url = "https://app.playmanity.net/api/games/sessions/initiate"
                var session_create_json_data = json_stringify({"auth_token": global.plm_auth_token})
                
                global.plm_session_create_request = http_request(session_create_url, "POST", global.plm_url_headers, session_create_json_data)
            }
        }
    }
}

// Game Session Heartbeat Call
if (request_id == plm_session_heartbeat_request) {
    if (async_load[? "status"] == 0)
    {
        var result_string = async_load[? "result"];
        var result = json_parse(result_string)
        var success = struct_get(result, "success")
        if (success) {
            global.plm_game_session_active = true
            alarm[1] = 60 * 8.5 // Send another heartbeat in 8.5 seconds
        } else {
            // If the heartbeat comes back with an error, a new session needs to be created
            global.plm_game_session_active = false
            
            var session_create_url = "https://app.playmanity.net/api/games/sessions/initiate"
            var session_create_json_data = json_stringify({"auth_token": global.plm_auth_token})
            
            global.plm_session_create_request = http_request(session_create_url, "POST", global.plm_url_headers, session_create_json_data)
        }
    }
}

// Get Ad Call
if (request_id == global.plm_ad_request)
{
    if (async_load[? "status"] == 0)
    {
        var result_string = async_load[? "result"];
        if (result_string != "") {
        	var result = json_parse(result_string)
            try {
            	var ad_data = struct_get(result, "ad")
                var ad_click_url = struct_get(ad_data, "url")
                var ad_image_url = struct_get(ad_data, "media")
                var ad_description = string_upper(struct_get(ad_data, "description"))
                
                struct_set(global.plm_ad_struct, "url", ad_click_url)
                struct_set(global.plm_ad_struct, "media_url", ad_image_url)
                struct_set(global.plm_ad_struct, "description", ad_description)
                
                ad_sprite = sprite_add_ext(ad_image_url, 1, 0, 0, true);
            }
            catch (error) {
                var error = struct_get(result, "error")
                var error_code = struct_get(error, "code")
                struct_set(global.plm_ad_load_error, "error_status", error_code)
                var description = struct_get(error, "message")
                struct_set(global.plm_ad_load_error, "description", description)
            }
        }
    } else {
        // Something went wrong, try again
        var ad_url = "https://app.playmanity.net/api/advertisements"
        var ad_json_data = json_stringify({"game_uuid": global.plm_uuid, "auth_token": global.plm_auth_token})
        
        global.plm_ad_request = http_request(ad_url, "POST", global.plm_url_headers, ad_json_data)
    }
}