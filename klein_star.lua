--[[
    Sums up all EMC in klein stars using the plethora neural interface, printing it.
]]

local brain = peripheral.find("neuralInterface")
if brain == nil then
    error("requires neural interface")
end

if not brain.hasModule("plethora:introspection") then
    error("requires introspection module")
end

local inv = brain.getInventory()
local STAR_EIN_EMC = 50000

while true do
    local stars = {}
    local total_max_emc = 0
    local total_emc = 0

    for i,_ in pairs(inv.list()) do
        local item = inv.getItemMeta(i)
        if item ~= nil and string.match(item.name, "^projecte:item.pe_klein_star") ~= nil then
            local level = string.match(item.rawName, "%d+$")
            local max_emc = STAR_EIN_EMC * 4^(level -1)
            local emc = (1-(item.durability or 1)) * max_emc

            total_max_emc = total_max_emc + max_emc
            total_emc = total_emc + emc

            item.slot = i
            item.level = level
            item.emc = emc
            table.insert(stars, item)
        end
    end

    local perc = total_emc/total_max_emc
    print(("%i/%i %.1f%% emc, in %i star(s)"):format(
        total_emc,
        total_max_emc,
        math.floor(perc * 10000 + .5)/100,
        #stars
    ))

    -- TODO let player know when it is low

    sleep(10)
end
