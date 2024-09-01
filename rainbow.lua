--[[
    RGBs all connected computronics colourful lamps.
]]

-- https://stackoverflow.com/a/71365991
local function hsv2rgb(h, s, v)
    local k1 = v*(1-s)
    local k2 = v-k1

    local r = math.min(math.max(3*math.abs(((h      )/180)%2-1)-1, 0), 1)
    local g = math.min(math.max(3*math.abs(((h  -120)/180)%2-1)-1, 0), 1)
    local b = math.min(math.max(3*math.abs(((h  +120)/180)%2-1)-1, 0), 1)

    return k1 + k2 * r, k1 + k2 * g, k1 + k2 * b
end

local lamps = {}
for _,name in pairs(peripheral.getNames()) do
    if peripheral.getType(name) == "colorful_lamp" then
        table.insert(lamps, peripheral.wrap(name))
    end
end

if #lamps == 0 then
    error("Could not find any connected colourful lamps")
end

print("Rainbowing "..#lamps.." lamps")
print("Hold ctrl+T to terminate")

local hue = 0
while true do
    local r,g,b = hsv2rgb(hue, 1, 1)
    local c =
        bit.blshift(b*31, 10)
        + bit.blshift(g*31, 5)
        + r*31

    for _,lamp in pairs(lamps) do
        lamp.setLampColor(c)
    end

    hue = (hue + 10) % 360
    sleep(0.125)
end
