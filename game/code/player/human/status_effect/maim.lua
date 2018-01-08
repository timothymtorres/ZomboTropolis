local class = require('code.libs.middleclass')
local bit = require('plugin.bit')
local band, bor, bxor, bnot, rshift = bit.band, bit.bor, bit.bxor, bit.bnot, bit.rshift
table.shuffle = require('code.libs.shuffle')

local Maim = class('Maim')
Maim.flags ={
  arm_left =  2^0,
  leg_left =  2^1,
  leg_right = 2^2,
  arm_right = 2^3,
}

local opposite_limbs = {}
opposite_limbs[2^3] = 'arm_left'
opposite_limbs[2^2] = 'leg_left'
opposite_limbs[2^1] = 'leg_right'
opposite_limbs[2^0] = 'arm_right'

function Maim:initialize() self.limbs = 0 end

function Maim:countFlags()
  local count, bits = 0, self.limbs
  while bits > 0 do
    count = count + band(bits, 1)
    bits = rshift(bits, 1)
  end  
  return count
end

function Maim:check(flag) 
  local other_limb = opposite_limbs[self.limbs] -- gets the bitflag for the opposite limb
  local limb_set = bor(self.limbs, Maim.flags[other_limb]) -- this is to prevent both arms or both legs from being cutoff
  return band(limb_set, flag) == flag 
end

function Maim:delimb()
  local limb_options = {}
  for limb, flag in pairs(Maim.flags) do 
    if not Maim:check(flag) then limb_options[#limb_options + 1] = limb end
  end

  local selected_limb = limb_options[math.random(1, #limb_options)]
  self.limbs = bor(self.limbs, Maim.flags[selected_limb]) 
  return selected_limb
end

return Maim