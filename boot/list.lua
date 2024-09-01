--[[
    Simply lists all the run records made by record.lua,
    in /data/startup_records.b
]]

local file = fs.open("/data/startup_records.b", "r")

local line = file.read(8)
local full = {}

while line ~= "" and line ~= nil and #line == 8 do
    local time = os.date(
        "!%Y/%m/%d %H:%M:%S UTC",
        string.unpack("I8", line) / 1000
    )

    table.insert(full, time)
    line = file.read(8)
end

file.close()

-- reverse list
-- https://stackoverflow.com/a/72784448
for i = 1, math.floor(#full/2), 1 do
    full[i], full[#full-i+1] = full[#full-i+1], full[i]
end

local _,y = term.getCursorPos()

textutils.pagedPrint(
    table.concat(full, "\n"),
    y-2
)
