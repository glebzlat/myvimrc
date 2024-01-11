---Creates pretty formatted object's representation string
---@param obj any object to inspect
---@param tab string indentation string; by default two spaces
function Inspect(obj, tab)
  tab = tab or "  "
  if type(obj) == "table" then
    local s = "{\n"
    for k, v in pairs(obj) do
      if type(k) == "number" then k = '"' .. k .. '"' end
      s = s .. tab .. "[" .. k .. "] = "
      tab = ((type(v) == "table") and tab .. "  " or tab)
      s = s .. Inspect(v, tab) .. ",\n"
    end
    tab = string.sub(tab, 1, string.len(tab) - 2)
    return s .. tab .. "}"
  else
    return tostring(obj)
  end
end

---Creates object's representation string and prints it
---@param obj any object to inspect
---@param tab string indentation string; by default two spaces
function Dump(obj, tab)
  print(Inspect(obj, tab))
end
