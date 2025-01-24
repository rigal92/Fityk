
function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end




filename = "/home/riccardo/Documents/Research/SPIN/Experiment/Exfoliation/MoS2/Gold_assisted/Raman/MoS2GE43_onSi/Data/Map_PL.txt"

file = io.open(filename)

if file then
  c = nil
  for i=0, 12 do
    file:read("*line")
  end
  -- for l in file:lines() do
  --     print(l)
  --     if(not (string.sub(l,1,1) == "#")) then
  --         c = l
  --         break
  --     end
  -- end
  x = Split(file:read("*line"),"\t")
  y = Split(file:read("*line"),"\t")
  table.remove(x,1)
  table.remove(y,1)

  ncols = #x

  for i=2, ncols+1 do
      -- if you need to get only a part of the spectra
      -- if i > 500 then break end
      -- create dataset
      s = "@+ < '"..filename..":1:"..i.."::' _ decimal_comma"
      F:execute(s)
      -- rename dataset
      n = math.floor(F:get_dataset_count())
      s = x[i-1]..":"..y[i-1]
      print(n)
      s = "@" ..(n-1).. ":title = '" ..s.."'"
      F:execute(s)
  end
  
else
  print("!!! FILE NOT FOUND !!!")
end
