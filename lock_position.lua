-- Lua script for Fityk.
data_id = 0
lock = false



ff = F:get_components(data_id)

for i,f in F:get_components(data_id)
do
  s = f:get_param(1)
  val = f:get_param_value("center")
  name = "$" .. f:var_name("center")
  if lock == false
  then
  val = "~{"..val.."}"
  else 
  val = "{"..val.."}"
  end
  F:execute(name .. "=" .. val) 
end