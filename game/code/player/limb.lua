local class = require('code.libs.middleclass')
local bit = require('plugin.bit')
local band, bor, bxor, bnot, rshift = bit.band, bit.bor, bit.bxor, bit.bnot, bit.rshift

local Limb = class('Limb')
Limb.flags = {
  arm_left =  2^0,
  arm_right = 2^1,
  leg_left =  2^2,
  leg_right = 2^3,
}

function Limb:initialize()
  self.flags = {maim = 0, decay = 0}
end

function Limb:countFlags(category)
  local count, bits = 0, self.flags[category]
  while bits > 0 do
    count = count + band(bits, 1)
    bits = rshift(bits, 1)
  end  
  return count
end

function Limb:check(category, flag) return band(self.flags[category], flag) == flag end

function Limb:add(category)
  local limb_options = {}
  for limb, flag in pairs(Limb.flags) do 
    if not Limb:check(category, flag) then limb_options[#limb_options + 1] = limb end
  end

  local selected_limb = limb_options[math.random(1, #limb_options)]
  self.flags[category] = bor(self.flags[category], Limb.flags[selected_limb]) 
  return selected_limb
end

return Limb