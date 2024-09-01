--[[
    Randomly selects a computronics tape from any connected inventory and places it in the last tape drive it finds, playing it.
    Stop the tape drive to skip the song.
]]

local drive = nil
local invs = {}
for ,side in pairs(peripheral.getNames()) do
    local obj = peripheral.wrap(side)
    if peripheral.getType(side) == "tapedrive" then
        drive = obj
    else
        if obj.list ~= nil and obj.size ~= nil then
            obj.name = side
            table.insert(invs, obj)
        end
    end
end
if drive == nil then
    error("requires tape drive")
end
if #invs <= 0 then
    error("requires inventory for tapes, but found none")
end


local function has_tape()
    return drive.getItem(1) ~= nil
end

local function remove_tape()
    if not has_tape() then
        return
    end

    for ,inv in pairs(invs) do
        local items = inv.list()
        local foundspot = #items < inv.size()

        if foundspot then
            repeat
                drive.pushItems(inv.name, 1)
                sleep(1)
            until not has_tape()
            return
        end
    end
    error("could not find a space to move the played tape to")
end

local function tape_has_ended()
    local PEEKSIZE = 1024

    if drive.isEnd() or not has_tape() then
        return true
    end

    local peek = drive.read(PEEKSIZE)
    drive.seek(–#peek) — use actual peek size

    return peek:match("^\000+$") ~= nil
end

local function compile_tapes()
    local tapes = {}
    for ,inv in pairs(invs) do
        for slot,item in pairs(inv.list()) do
            local meta = inv.getItemMeta(slot)
            if meta.name == "computronics:tape" then
                table.insert(tapes, {
                    title = meta.media.label,
                    inv = inv.name,
                    slot = slot
                })
            end
        end
    end
    return tapes
end


-- continue previous tape
drive.play()

while true do
    if not tape_has_ended() and drive.getState() ~= "STOPPED" then
        sleep(5)
    else
        if not tape_has_ended() then
            print("Skipped song")
        end

        local tapes = compile_tapes()
        remove_tape()
        local chosentape = tapes[math.random(#tapes)]

        repeat
            drive.pullItems(chosentape.inv, chosentape.slot)
            sleep(1)
        until has_tape()

        local MAXSIZE = 999999999999999999999999999999999999

        drive.seek(-MAXSIZE)
        print(("Playing %s"):format(chosentape.title))
        drive.play()
    end
end
