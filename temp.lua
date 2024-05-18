function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

file = io.open("/home/rgalafassi/Desktop/Temp/temp.txt")

c = nil
for l in file:lines() do
	-- print(l)
	if(not (string.sub(l,1,1) == "#")) then
		c = l
		break
	end
end
splitted = Split(c,"\t")
n = #splitted

print(#splitted)