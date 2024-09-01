--[[
    Blaze rod EMC farm.
]]

local blazer = peripheral.wrap("bottom")

local function rod_count()
    local total = 0
    for _,v in pairs(blazer.list()) do
        if v.name == "minecraft:blaze_rod" then
            total = total + v.count
        end
    end
    return total
end

turtle.select(1)
print("hold ctrl+T to terminate")

local function do_macerator()
    while true do
        local pushed = true
        if turtle.getItemCount() > 0 then
            pushed = turtle.drop()
        end
        local sucked turtle.suckDown()

        if not pushed then
            pushed = turtle.dropUp()
        end
        if not sucked or not pushed then
            break
        end
    end
end

while true do
    if turtle.detect() then
        do_macerator()

        sleep(1)
    end

    turtle.turnRight()
end
