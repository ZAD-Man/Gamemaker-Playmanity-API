/// @description Check for a successful authorization
var auth_status_url = $"https://app.playmanity.net/api/games/auth/status/{plm_auth_id}"

plm_auth_status_request = http_get(auth_status_url)

alarm[0] = 60 // Check again in 1 second if not stopped (by receiving a success response)