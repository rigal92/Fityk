
function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end




filename = "/home/riccardo/Documents/Research/SPIN/Experiment/Transfer/Marzia/24-10-08_MoS2@Ag-CaF2/Raman/Data/map_sample.txt"

file = io.open(filename)

if file then
  c = nil
  for l in file:lines() do
      -- print(l)
      if(not (string.sub(l,1,1) == "#")) then
          c = l
          break
      end
  end


  splitted = Split(c,"\t")
  ncols = #splitted

  for i=2401, ncols do
      -- if you need to get only a part of the spectra
      if i >2402 then break end
      -- create dataset
      s = "@+ < '"..filename..":1:"..i.."::' _ decimal_comma"
      F:execute(s)
      -- rename dataset
      n = F:get_dataset_count()
      s = splitted[i]:gsub(",",":"):gsub("%.",",")
      s = "@" ..(n-1).. ":title = '" ..s.."'"
      F:execute(s)

  end
  
  
else
  print("!!! FILE NOT FOUND !!!")
end
