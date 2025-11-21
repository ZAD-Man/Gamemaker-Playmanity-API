/// @description Vars for holding request IDs
plm_auth_status_request = -1
plm_session_heartbeat_request = -1
global.plm_session_create_request = -1
plm_auth_id = -1
global.plm_ad_request = -1
ad_sprite = -999

// Error descriptions from Playmanity's docs
//ad_request_error_map = {
    //"INVALID_IDENTIFIER": "The provided game UUID is invalid",
    //"NO_ACTIVE_SESSION": "No active session found for this user",
    //"INVALID_TOKEN": "The provided authorization token is invalid",
    //"PREMIUM_USER": "The current user has premium status and should not receive advertisements",
    //"NO_ACTIVE_CAMPAIGNS": "No active advertising campaigns are available",
    //"NO_ACTIVE_ADS": "No active advertisements are available in the current campaigns",
    //"ERR_TIMEOUT": "Request timed out, try again later",
    //"INTERNAL_SERVER_ERROR": "Internal server error"
//}

// Error descriptions from the manual page for sprite_add_ext()
image_load_error_map = {
    "e-1": "This is a generic error code when none of the others apply.",
    "e-2": "This constant indicates that the request was cancelled while it was in progress.",
    "e-3": "This constant indicates that a sprite was removed somehow partway through the loading process.",
    "e-4": "This constant indicates that a file loading operation failed.",
    "e-5": "This constant indicates that image decompression failed (which could be due to e.g. a corrupted file or unsupported image format).",
    "e-6": "Indicates that, even though all data was loaded and decompressed, sprite resource creation itself failed."
}