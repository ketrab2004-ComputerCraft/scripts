--[[
    Eats food for you using the plethora neural interface.
    Chooses the worst food by default, but the food with the most saturation when hurt.
]]

local brain = peripheral.find("neuralInterface")
if brain == nil then
    error("requires neural interface")
end

if not brain.hasModule("plethora:introspection") then
    error("requires introspection module")
end

local inv = brain.getInventory()

local function find_food()
    local list = {}
    local total_heal = 0
    local total_saturation = 0
    local total_items = 0

    for i,_ in pairs(inv.list()) do
        local meta = inv.getItemMeta(i)
        if meta ~= nil and meta.heal ~= nil and meta.heal > 0 then
            local wrap = inv.getItem(i)
            if wrap.consume ~= nil then
                for k,v in pairs(wrap) do
                    meta[k] = v
                end
                table.insert(list, meta)
                total_heal = total_heal + meta.heal * meta.count
                total_saturation = total_saturation + (meta.saturation or 0) * meta.count
                total_items = total_items + meta.count
            end
        end
    end
    print(("found %.f2 heal and %.2f saturation in %i items"):format(total_heal, total_saturation, total_items))
    return list
end

while true do
    local owner = brain.getMetaOwner()
    local is_hurt = owner.health < owner.maxHealth

    if owner.food.hungry then
        local foods = find_food()

        if #foods <= 0 then
            print("no food found...")
        else
            if is_hurt then
                table.sort(foods, function(a, b)
                    return a.saturation > b.saturation
                end)
            else
                table.sort(foods, function(a, b)
                    return a.heal < b.heal
                end)
            end

            local chosen = foods[1]
            chosen.consume()
            print(("ate %s (%s)"):format(
                chosen.displayName,
                chosen.name
            ))
        end
    end

    sleep(1)
end
