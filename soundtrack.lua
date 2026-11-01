local kFadeSeconds = 0.6
local kHurtFadeSeconds = 0.2
local kRecoverFadeSeconds = 0.5
local kTracks = {
    overworld = "music/menu",
    w1 = "music/w1",
    w2 = "music/w2",
}

local function track_for(scene)
    if scene.name() == "overworld" then return kTracks.overworld end
    local world = CurrentStage and CurrentStage.map_name:match("(w%d)s%d+$")
    return kTracks[world]
end

function play_soundtrack(scene)
    if not music then return end
    local track = track_for(scene)
    if track then
        music.loop(track, kFadeSeconds)
    else
        music.stop(kFadeSeconds)
    end
end

local function has_channel_volume()
    return music ~= nil and music.volume ~= nil
end

function soundtrack_hurt()
    if not has_channel_volume() then return end
    music.volume(0.0, CH_1 | CH_2 | CH_6 | CH_7, kHurtFadeSeconds)
end

function soundtrack_recover()
    if not has_channel_volume() then return end
    music.volume(1.0, CH_ALL, kRecoverFadeSeconds)
end
