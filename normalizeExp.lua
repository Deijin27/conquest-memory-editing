--[[

Makes the exp (which determines link) of all pokemon of a warrior equal to that
of the pokemon with the highest exp.

To use, on the warrior "lists" page, select a warrior, then run this script.

--]]

local linkToExp = {
    [0]=0,
    [1]=100,
    [2]=200,
    [3]=300,
    [4]=402,
    [5]=502,
    [6]=604,
    [7]=708,
    [8]=810,
    [9]=914,
    [10]=1020,
    [11]=1124,
    [12]=1232,
    [13]=1340,
    [14]=1448,
    [15]=1558,
    [16]=1670,
    [17]=1784,
    [18]=1898,
    [19]=2014,
    [20]=2132,
    [21]=2250,
    [22]=2372,
    [23]=2494,
    [24]=2620,
    [25]=2748,
    [26]=2876,
    [27]=3008,
    [28]=3142,
    [29]=3278,
    [30]=3416,
    [31]=3556,
    [32]=3700,
    [33]=3846,
    [34]=3996,
    [35]=4148,
    [36]=4302,
    [37]=4460,
    [38]=4620,
    [39]=4784,
    [40]=4952,
    [41]=5122,
    [42]=5296,
    [43]=5474,
    [44]=5654,
    [45]=5840,
    [46]=6028,
    [47]=6220,
    [48]=6416,
    [49]=6616,
    [50]=6820,
    [51]=7028,
    [52]=7240,
    [53]=7458,
    [54]=7678,
    [55]=7904,
    [56]=8134,
    [57]=8368,
    [58]=8608,
    [59]=8852,
    [60]=9100,
    [61]=9354,
    [62]=9612,
    [63]=9876,
    [64]=10146,
    [65]=10420,
    [66]=10700,
    [67]=10984,
    [68]=11274,
    [69]=11570,
    [70]=11872,
    [71]=12180,
    [72]=12492,
    [73]=12812,
    [74]=13136,
    [75]=13468,
    [76]=13806,
    [77]=14148,
    [78]=14498,
    [79]=14854,
    [80]=15216,
    [81]=15586,
    [82]=15962,
    [83]=16344,
    [84]=16732,
    [85]=17128,
    [86]=17530,
    [87]=17940,
    [88]=18358,
    [89]=18782,
    [90]=19212,
    [91]=19652,
    [92]=20098,
    [93]=20550,
    [94]=21012,
    [95]=21480,
    [96]=21956,
    [97]=22440,
    [98]=22932,
    [99]=23432,
    [100]=23942
}

local selectedWarriorOffset = 0x22EA160
local warriorInfoOffset = 0x022797F0
local scenarioWarriorLength = 0x20
local scenarioPokemonOffset = 0x022724F8
local scenarioPokemonLength = 0x8
local maxLinkTableOffset = 0x02287BA0
local pokemonCount = 200

-- locate the selected warrior
local selectedWarrior = memory.readbyte(selectedWarriorOffset)
local selectedWarriorInfoOffset = warriorInfoOffset + selectedWarrior * scenarioWarriorLength

-- what base warrior is this?
local warriorId = memory.readbyte(selectedWarriorInfoOffset)

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
    local pokemonSpecies = memory.readbyte(pokeOffset)
    -- maxLink is stored as link integer, but we need the equivalent exp
    local maxLink = linkToExp[memory.readbyte(maxLinkTableOffset + pokemonCount * warriorId + pokemonSpecies)]
    if maxExp > maxLink then
        memory.writeword(pokeOffset + 2, maxLink)
    else
        memory.writeword(pokeOffset + 2, maxExp)
    end
end
