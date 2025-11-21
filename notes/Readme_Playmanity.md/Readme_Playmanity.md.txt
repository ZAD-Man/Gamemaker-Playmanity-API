Welcome to the Gamemaker-Playmanity API!

This module aims to make the process of connecting to and gettings ads from Playmanity as simple as possible. First, there are a few necessary pre-requisites:
1. Get a page set up on Playmanity for your game and get your "Production UUID" (see the [docs](https://app.playmanity.net/docs) if you haven't done this yet)
2. In the "playmanity_API" script, place your game's UUID in the `plm_prod_uuid` assignment on line 4
3. (Recommended) Read through the [docs](https://app.playmanity.net/docs) so you have a general idea of the API's flow

---

When you are ready to start a game session, call `playmanity_start_game_session()`. If this is the first time you call it, a page will open in the user's browser, prompting them to login. Either way, a new game session will start and "heartbeats" will be sent to Playmanity to keep the session alive.

Your game can then check `global.plm_user_logged_in` and `global.plm_game_session_active` to see whether the user has logged in and whether a game session is currently active, respectively.

---

With a session active, you can then call `playmanity_get_ad()`. Since the ad download is asynchronous, you will need to provide an object where the ad will be stored as its sprite and a struct which will be populated with information about the ad.

Your game can then check `global.plm_ad_loaded` to see whether the ad has successfully loaded (it can take some time), and check the struct in `global.plm_ad_load_error` to see information about any errors that occurred with the ad.

NOTE: If an error occurs, you will need to either try again or skip the ad. This function will not retry automatically.

The ad information struct will be populated with:
* `url` - the url where the ad was downloaded from
* `media_url` - the url that should open when the user clicks the ad
* `description` - the ad's description, to be displayed alongside it.

---

When the game session ends, be sure to call `playmanity_end_game_session()`, which will clean up the session on Playmanity's end.

**Use the functions as-is while testing, but once you're ready to make a production build, call `playmanity_use_prod()` before you make any other function calls.**

---

If you found this useful, or if you encounter any issues, I'd love to hear from you! You can find me on Twitter or Bluesky, or comment on Github.

* [Twitter](https://twitter.com/ZADMan)
* [Bluesky](https://bsky.app/profile/zad-man.bsky.social)
* [Github Link] -  PRs are welcome as well!


Disclaimer: This project is not officially associated with, nor supported by, Playmanity.