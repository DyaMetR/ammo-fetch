--[[------------------------------------------------------------------
	DyaMetR's ammunition fetch
	May 14th, 2022
	Functions that simplify the process of retrieving player ammunition
	counts for client-side displaying.
]]--------------------------------------------------------------------

local version = 1 -- current version of the script

-- check whether there's a newer version of this script
if AmmoFetch and AmmoFetch >= version then return end

-- update version number
AmmoFetch = version

-- get player meta table
local Player = FindMetaTable('Player')

--[[------------------------------------------------------------------
	Whether the player has a valid active weapon.
	@return {boolean} is active weapon valid
]]--------------------------------------------------------------------
function Player:HasActiveWeapon()
	return IsValid(self:GetActiveWeapon())
end

--[[------------------------------------------------------------------
	Fetches the current weapon or vehicle's primary ammunition.
	@return {boolean} can ammunition be displayed (at all)
	@return {number|nil} primary ammunition type
	@return {number|nil} primary reserve ammunition
	@return {number|nil} maximum primary reserve ammunition
	@return {number|nil} clip1
	@return {number|nil} clip1 size
	@return {number|nil} clip2
	@return {number|nil} clip2 size
]]--------------------------------------------------------------------
function Player:GetPrimaryAmmoDisplay()
	-- check whether our vehicle has a weapon and fetch its ammunition
	if self:InVehicle() and not self:GetAllowWeaponsInVehicle() then
		local ammo, max, amount = self:GetVehicle():GetAmmo()
		return ammo > 0, ammo, amount, max
	else
		local weapon = self:GetActiveWeapon()

		-- check whether the weapon is invalid
		if not IsValid(weapon) then return false end

		-- check whether it's a SWEP with a custom ammo display
		if weapon:IsScripted() then
			local custom = weapon:CustomAmmoDisplay()

			-- use custom ammo display if valid
			if custom then
				local clip, reserve = custom.PrimaryClip, custom.PrimaryAmmo

				-- if there's no reserve, use the clip ammunition as such
				if not reserve then
					return custom.Draw, 0, clip, 0
				else
					-- if the clip is -1, ignore it
					if clip <= -1 then
						return custom.Draw, 0, reserve, 0
					else
						return custom.Draw, 0, reserve, 0, clip, 0
					end
				end
			end
		end

		-- fetch ammunition types
		local primary, secondary = weapon:GetPrimaryAmmoType(), weapon:GetSecondaryAmmoType()

		-- check whether it has valid ammunition types
		if primary <= 0 and secondary <= 0 then return false end

		-- replace primary ammunition if weapon only holds secondary
		if primary > 0 then
			-- fetch clips
			local clip1, maxClip1, clip2, maxClip2 = weapon:Clip1(), weapon:GetMaxClip1(), weapon:Clip2(), weapon:GetMaxClip2()

			-- is clip1 valid
			if clip1 <= -1 then
				clip1 = nil
				maxClip1 = nil
			end

			-- is clip2 valid
			if clip2 <= -1 then
				clip2 = nil
				maxClip2 = nil
			end

			return true, primary, self:GetAmmoCount(primary), game.GetAmmoMax(primary), clip1, maxClip1, clip2, maxClip2
		else
			return true, secondary, self:GetAmmoCount(secondary), game.GetAmmoMax(secondary)
		end
	end
end

--[[------------------------------------------------------------------
	Fetches the current weapon's secondary ammunition.
	@return {boolean} can secondary ammunition be displayed
	@return {number|nil} secondary ammunition type
	@return {number|nil} secondary reserve ammunition
	@return {number|nil} maximum secondary reserve ammunition
]]--------------------------------------------------------------------
function Player:GetSecondaryAmmoDisplay()
	local weapon = self:GetActiveWeapon()

	-- check if our weapon is invalid or if we're in a vehicle
	if not IsValid(weapon) or (self:InVehicle() and not self:GetAllowWeaponsInVehicle()) then return false end

	-- check if primary ammunition displayed has been replaced
	if weapon:GetPrimaryAmmoType() <= 0 then return false end

	-- check whether it's a SWEP with a custom ammo display
	if weapon:IsScripted() then
		local custom = weapon:CustomAmmoDisplay()

		-- use custom ammo display if valid
		if custom then
			-- check whether the custom display has secondary ammo
			if not custom.SecondaryAmmo or custom.SecondaryAmmo < 0 then return false end

			-- otherwise, return it
			return custom.Draw, 0, custom.SecondaryAmmo, 0
		end
	end

	-- check if active weapon has secondary ammunition
	local ammo = weapon:GetSecondaryAmmoType()
	if ammo <= 0 then return false end

	return true, ammo, self:GetAmmoCount(ammo), game.GetAmmoMax(ammo)
end
