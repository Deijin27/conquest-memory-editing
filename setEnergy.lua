--[[
This script sets the energy of all pokemon to the configured value
It is for use in PVP multiplayer, and is only tested in this circumstance.
It edits the memory of the running game, Desmume > lua scripting

Launch the game, then run the script when you are in the overworld (viewing kingdoms)

Edit the variable "ENERGY" to your desired value

N Energy  Multiplier
4 Highest 1.1
3 High    1.05
2 Neutral 1
1 Low     0.95
0 Lowest  0.9

--]]

local ENERGY = 2

function setEnergy(offset, energy)
  -- the 7th byte in a scenario pokemon contains the energy
  local currentVal = memory.readbyte(offset + 7)
  local newVal = bit.bor(bit.band(currentVal, 0x1F), bit.lshift(energy, 5))
  memory.writebyte(offset + 7, newVal)
end

-- this offset is what you get doing a RAM search for 0x5CC71000 (the start of eevee's data)
local startOffset = 0x022724F8
-- there can probably be more pokemon than this, but this covers what we need
local numPokemon = 174
-- 8 is the length in bytes of a scenario pokemon
for relativeOffset=0, numPokemon * 8, 8 do
  setEnergy(startOffset + relativeOffset, ENERGY)
end