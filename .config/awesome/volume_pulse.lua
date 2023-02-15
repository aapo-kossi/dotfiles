
-- custom volume widget using the pulseaudio cli
-- instead of amixer like the widget included in vicious
-- code is modified from vicious implementation

local type = type
local tonumber = tonumber
local string = { find = string.find }

local helpers = require("vicious.helpers")
local spawn = require("vicious.spawn")
volume_pulse = {}


local function parse(stdout, stderr, exitreason, exitcode)
  local _, _, vol  = string.find(stdout, " (%d+)%% ")
  local _, _, mute = string.find(stdout, " Mute: %l+")
  mute = mute == "yes" or vol == "0"

  -- if vol == nil then return {} end
  -- return {50, false}
  return { tonumber(vol), mute }
end

function volume_pulse.async(format, warg, callback)
  if not warg then return callback{} end
  spawn.easy_async("pactl get-sink-volume "..warg.." & pactl get-sink-mute "..warg,
                   function (...) callback(parse(...)) end)
end

return helpers.setasyncall(volume_pulse)
