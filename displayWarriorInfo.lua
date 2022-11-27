--[[

On the warrior "lists" page, this displays the
exp and IVs of the first pokemon of the selected warrior.

--]]

local selectedWarriorOffset = 0x22EA160
local warriorInfoOffset = 0x022797F0
local scenarioWarriorLength = 0x20
local scenarioPokemonOffset = 0x022724F8
local scenarioPokemonLength = 0x8

function displayWarriorInfo()
    local selectedWarrior = memory.readbyte(selectedWarriorOffset)
    local selectedWarriorInfoOffset = warriorInfoOffset + selectedWarrior * scenarioWarriorLength
    local firstPokemon = memory.readword(selectedWarriorInfoOffset + 14)
    local pokeOffset = scenarioPokemonOffset + firstPokemon * scenarioPokemonLength
    local exp = memory.readword(pokeOffset + 2)
    local ivs = memory.readdword(pokeOffset + 4)
    local hpIv = bit.band(ivs, 0x1F)
    local atkIv = bit.band(bit.rshift(ivs, 5), 0x1F)
    local defIv = bit.band(bit.rshift(ivs, 10), 0x1F)
    local speIv = bit.band(bit.rshift(ivs, 15), 0x1F)

    gui.text(10, 10, "Warrior: " .. tostring(selectedWarrior), "white")
    gui.text(10, 20, "Pokemon: " .. tostring(firstPokemon), "white")
    gui.text(10, 30, "EXP    : " .. tostring(exp), "white")
    gui.text(10, 40, string.format("IVs    : HP%d/Atk%d/Def%d/Spe%d", hpIv, atkIv, defIv, speIv))
    gui.text(10, 50, "Species: " .. tostring(memory.readbyte(pokeOffset)), "white")
end

gui.register(displayWarriorInfo)
