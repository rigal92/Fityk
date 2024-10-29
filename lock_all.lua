-- Lua script for Fityk.
data_id = 0
lock = true



ff = F:get_components(data_id)

for i,f in F:get_components(data_id)
do
  counter = 0
  while(counter > -1)
  do
    s = f:get_param(counter)
    if (s == "")
    then
      counter = -1
    else
      name = "$" .. f:var_name(s)
      val = f:get_param_value(s)
      if lock == false
      then
        val = "~{"..val.."}"
      else 
        val = "{"..val.."}"
      end
      F:execute(name .. "=" .. val) 
      counter = counter + 1
    end
  end
end