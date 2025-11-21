// NOTE: Playmanity is often abbreviated as "plm" in this script

plm_test_uuid = "404e1b2b-de1b-4988-8cc8-94239dc482b3"
plm_prod_uuid = "?" // TODO: Place your game's production UUID here
global.plm_uuid = plm_test_uuid

global.plm_user_logged_in = false // Check this to see whether the user has logged in
global.plm_game_session_active = false // Check this to see whether there is an active game session
global.plm_ad_loaded = false // Check this to see whether the requested ad has been loaded
global.plm_ad_load_error = {"error_status": -999, "description": ""} // Any errors while loading ads will be stored here

global.plm_url_headers = ds_map_create()
ds_map_add(global.plm_url_headers, "Content-Type", "application/json")

/// @description    Makes future Playmanity API calls use your game's production UUID
function playmanity_use_prod() {
    global.plm_uuid = plm_prod_uuid
}

/// @description    Starts a new game session (prompting the user to log in, if needed), then keeps it alive in the background
function playmanity_start_game_session() {
    if (!instance_exists(obj_playmanity)) {
        instance_create_depth(0, 0, 0, obj_playmanity) // Object instance to handle callbacks
    }
    
    if (!global.plm_user_logged_in) {
        var auth_init_url = "https://app.playmanity.net/api/games/auth/initiate"
        var auth_init_json_data = json_stringify({"game_uuid": global.plm_uuid})
        
        global.plm_auth_init_request = http_request(auth_init_url, "POST", global.plm_url_headers, auth_init_json_data)
    } else {
        var session_create_url = "https://app.playmanity.net/api/games/sessions/initiate"
        var session_create_json_data = json_stringify({"auth_token": global.plm_auth_token})
        
        global.plm_session_create_request = http_request(session_create_url, "POST", global.plm_url_headers, session_create_json_data)
    }
}

/// @description    Gets an ad and asynchronously sets it as the given object's sprite (will take some time to load)
/// @param {Id.Instance} _ad_object  The object which the ad sprite will be assigned to
/// @param {struct} _ad_data_struct  A struct which will be populated with ad data: {url, media_url, description}
function playmanity_get_ad(_ad_object, _ad_data_struct) {
    // NOTE: Currently, only image ads are supported by Playmanity. If video support is added, this function will be updated.
    global.plm_ad_loaded = false
    global.plm_ad_load_error = {"error_status": -999, "description": ""}
    global.plm_ad_object = _ad_object
    global.plm_ad_struct = _ad_data_struct
    
    var ad_url = "https://app.playmanity.net/api/advertisements"
    var ad_json_data = json_stringify({"game_uuid": global.plm_uuid, "auth_token": global.plm_auth_token})
    
    global.plm_ad_request = http_request(ad_url, "POST", global.plm_url_headers, ad_json_data)
}

/// @description    Ends the currently active game session
function playmanity_end_game_session() {
    var session_end_url = "https://app.playmanity.net/api/games/sessions/end"
    var session_end_json_data = json_stringify({"auth_token": global.plm_auth_token})
    http_request(session_end_url, "POST", global.plm_url_headers, session_end_json_data)
    global.plm_game_session_active = false
}