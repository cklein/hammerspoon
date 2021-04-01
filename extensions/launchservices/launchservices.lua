--- === hs.launchservices ===
---
--- Interface to Launch Services

local module = require("hs.liblaunchservices")

--- hs.launchservices.open(url) -> nil
--- Function
--- Opens the location at the specified URL.
---
--- Parameters:
---  * url - A URL specifying the location to open.
---
--- Returns:
--- * true if the location was successfully opened; otherwise, false
module.open = function(url)
  return module._open(url)
end


--- hs.launchservices.openWithAppAndConfig(url, app, args, env) -> nil
--- Function
--- Opens the location in the specified app using the provided options.
---
--- Parameters:
---  * url - A URL specifying the location to open
---  * app - A URL specifying the location of the app in the file system
---  * args - a list of arguments for the app
---  * env - defines the environment variables for the new proces
---
--- Returns:
---  * None
module.openWithAppAndConfig = function(url, app, args, env)
  module._openWithAppAndConfig(url, app, args, env)
end

return module
