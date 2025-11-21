/// @description Set sprite for provided object
var _sprite_id = async_load[?"id"];
var status = async_load[?"status"];

if (status < 0) {
    // Negative statuses are errors
    struct_set(global.plm_ad_load_error, "error_status", status)
    var description = struct_get(image_load_error_map, $"e{status}")
    struct_set(global.plm_ad_load_error, "description", description)
}
else if (_sprite_id == ad_sprite)
{
    global.plm_ad_object.sprite_index = _sprite_id;
    global.plm_ad_loaded = true
}
else
{
    // Shouldn't be possible to reach here, but report it if it does
    struct_set(global.plm_ad_load_error, "description", "The image load said it was successful, but the image id did not match.")
}