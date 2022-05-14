# Ammunition Fetch

## A tool to aid in developing ammunition displays.

### How to install

Place the script file inside a Lua environment folder (such as the lua folder or a game mode folder).

Then, include the file **client-side** wise as the script is _client-side only_. In case of manual inclusion, make sure your implementation is included _after_ you've included this script.

Alternatively, you can place it into `lua/autorun/client` for it to be included automatically.

### Functions that this script adds

`LocalPlayer():HasActiveWeapon()`

Whether the player has a valid active weapon.

**Returns:**

+ (boolean) _is the player's current weapon valid_

`LocalPlayer():GetPrimaryAmmoDisplay()`

Fetches the current weapon or vehicle's primary ammunition.

**Returns:**

+ (boolean) _whether ammunition should be drawn_
+ (number _or nil_) primary ammunition type
+ (number _or nil_) primary reserve ammunition count
+ (number _or nil_) maximum primary reserve ammunition
+ (number _or nil_) ammunition in clip (if used)
+ (number _or nil_) clip size
+ (number _or nil_) ammunition in clip2 (if used)
+ (number _or nil_) clip2 size

`LocalPlayer():GetSecondaryAmmoDisplay()`

Fetches the current weapon's secondary ammunition.

**Returns:**

+ (boolean) _whether secondary ammunition should be drawn_
+ (number _or nil_) secondary ammunition type
+ (number _or nil_) secondary reserve ammunition count
+ (number _or nil_) maximum secondary reserve ammunition
