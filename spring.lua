require("model.commonModel")

function CurrentTime()
    return os.clock() * 1000
end

function Sleep(milliseconds)
    milliseconds = milliseconds or 0
    if milliseconds <= 0 then
        return
    end
    Delay(milliseconds)
end

---@param path string
---@param frame Rect
---@return number, number
function FindBmpInRect(path, frame)
    return FindBmp(path,
    frame.origin.x,
    frame.origin.y,
    frame.size.width,
    frame.size.height)
end

---创建枚举
---@param tbl table
---@param index integer | nil
---@return table
function CreatEnumTable(tbl, index)
    --assert(IsTable(tbl))
    local enumtbl = {}
    local enumindex = index or 0
    for i, v in ipairs(tbl) do
        enumtbl[v] = enumindex + i
    end
    return enumtbl
end

function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end
