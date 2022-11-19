--[[

Makes the exp (which determines link) of all pokemon of a warrior equal to that
of the pokemon with the highest exp.

To use, on the warrior "lists" page, select a warrior, then run this script.

--]]

local selectedWarriorOffset = 0x22EA160
local warriorInfoOffset = 0x022797F0
local scenarioWarriorLength = 0x20
local scenarioPokemonOffset = 0x022724F8
local scenarioPokemonLength = 0x8

-- locate the selected warrior
local selectedWarrior = memory.readbyte(selectedWarriorOffset)
local selectedWarriorInfoOffset = warriorInfoOffset + selectedWarrior * scenarioWarriorLength

-- find the warrior's pokemon
-- a warrior can have up to 8 pokemon. lua loops are end-inclusive
local warriorsPokemon = {}
for i = 0, 7 do
    local p = memory.readword(selectedWarriorInfoOffset + 14 + 2 * i)
    -- 1100 is the value of an empty pokemon slot on a warrior
    if p ~= 1100 then
        table.insert(warriorsPokemon, p)
    end
end

-- find the highest exp
local maxExp = 0
for _, p in ipairs(warriorsPokemon) do
    local pokeOffset = scenarioPokemonOffset + p * scenarioPokemonLength
    local exp = memory.readword(pokeOffset + 2)
    if exp > maxExp then
        maxExp = exp
    end
end

-- set the exp to the found highest value
for _, p in ipairs(warriorsPokemon) do
    local pokeOffset = scenarioPokemonOffset + p * scenarioPokemonLength
    memory.writeword(pokeOffset + 2, maxExp)
end
