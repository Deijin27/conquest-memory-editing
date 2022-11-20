
--[[

On the warrior 'list', select a warrior in the list (don't actually click through to their page)
Run the script and the values should be shown on screen.

LeftArrowKey = decrease exp once per click
RightArrowKey = increase exp once per click
K = decrease exp once per frame while key is held
L = increase exp once per frame while key is held

I have already used this to get the exact exps for link X.00 values if this is what you want
https://pastebin.com/r6ys0P3Z

--]]

local selectedWarriorOffset = 0x22EA160
local warriorInfoOffset = 0x022797F0
local scenarioWarriorLength = 0x20
local scenarioPokemonOffset = 0x022724F8
local scenarioPokemonLength = 0x8
local lock = false

while true do
    local selectedWarrior = memory.readbyte(selectedWarriorOffset)
    local selectedWarriorInfoOffset = warriorInfoOffset + selectedWarrior * scenarioWarriorLength
    local firstPokemon = memory.readword(selectedWarriorInfoOffset + 14)
    local pokeOffset = scenarioPokemonOffset + firstPokemon * scenarioPokemonLength
    local exp = memory.readword(pokeOffset + 2)

    local keys= input.get()
    if keys.K then
        exp = exp - 1
        memory.writeword(pokeOffset + 2, exp)
    elseif keys.L then
        exp = exp + 1
        memory.writeword(pokeOffset + 2, exp)
    else
        if keys.left then
            if lock == false then
                lock = true
                exp = exp - 1
                memory.writeword(pokeOffset + 2, exp)
            end
        elseif keys.right then
            if lock == false then
                lock = true
                exp = exp + 1
                memory.writeword(pokeOffset + 2, exp)
            end
        else
            lock = false
        end
    end

    gui.text(10, 10, "Warrior: " .. tostring(selectedWarrior), "white")
    gui.text(10, 20, "Pokemon: " .. tostring(firstPokemon), "white")
    gui.text(10, 30, "EXP    : " .. tostring(exp), "white")

    emu.frameadvance()
end
