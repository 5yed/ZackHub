local placeId = game.PlaceId

if placeId == 891852901 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/5yed/ZackHub/refs/heads/main/GV.lua"))()
elseif placeId == 136020512003847 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/5yed/ZackHub/refs/heads/main/SDBR.lua"))()
else
    warn("Unsupported game:", placeId)
end
