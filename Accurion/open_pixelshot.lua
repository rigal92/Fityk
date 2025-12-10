function split_to_floats(line)
    local parts = {}
    for part in line:gmatch("%S+") do  -- %S+ matches non-whitespace sequences
        table.insert(parts, tonumber(part))
    end
    return parts
end

local handle = io.popen('zenity --file-selection 2>/dev/null')
local filepath = handle:read("*a"):gsub("%s+$", "")  -- remove trailing newline
handle:close()

if filepath ~= "" then
    print("Selected file: " .. filepath)
else
    print("No file selected.")
end

filename = filepath:match("^.+/(.+)%.%w+$")
handle = io.popen("python3 /home/riccardo/Dev/Fityk/Accurion/split_pixelshot.py " .. filepath)
-- local result = handle:read("*a")

local count = 0
while true do
    local line = handle:read()
    if line == nil then break end
    lambda = split_to_floats(line)  
    delta = split_to_floats(handle:read())  
    psi = split_to_floats(handle:read())  
    ndata = math.floor(F:get_dataset_count())
    F:execute("@+=0")
    F:execute("@+=0")
    print("@"..ndata..":title=".. filename .. ":ROI".. count .. ":Delta")
    F:execute("@"..ndata..":title=".. filename .. ":ROI".. count .. ":Delta")
    F:execute("@"..(ndata+1)..":title=".. filename .. ":ROI".. count .. ":Psi")
    for i=1,#lambda do
        F:add_point(lambda[i],delta[i],1, ndata)
        F:add_point(lambda[i],psi[i],1, ndata+1)
    end
    count = count + 1
end
handle:close()

