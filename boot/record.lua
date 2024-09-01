--[[
    Records each time it is run in /data/startup_records.b,
    for example to be run in startup
]]

local file = fs.open("/data/startup_records.b", "a")

local time = os.epoch("utc")

local packed = string.pack("I8", time)

file.write(packed)
file.flush()
file.close()
