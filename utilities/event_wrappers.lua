---@class ComponentAddedEvent This signal is queued by the [computer](https://ocdoc.cil.li/block:case "block:case") or [robot](https://ocdoc.cil.li/block:robot "block:robot") when a new component is attached to it.<br/>Note: do not use this directly when possible, but use `component_available` instead, which is queued by the [component library](https://ocdoc.cil.li/api:component "api:component") when a *primary* component was added / the primary component changed.
---@field address string The `address` is the address of the added component
---@field componentType string The `componentType` is the type of the component (e.g. `redstone` or `gpu`)

---@class ComponentRemovedEvent This signal is queued by the [computer](https://ocdoc.cil.li/block:case "block:case") or [robot](https://ocdoc.cil.li/block:robot "block:robot") when a component is removed from it.<br/>Note: do not use this directly when possible, but use `component_unavailable` instead, which is queued by the [component library](https://ocdoc.cil.li/api:component "api:component") when a *primary* component is removed.
---@field address string The `address` is the address of the removed component.
---@field componentType string The `componentType` is the type of the component (e.g. `redstone` or `gpu`).

---@class ComponentAvailableEvent This signal is queued by the [component library](https://ocdoc.cil.li/api:component "api:component") when a *primary* component was added / the primary component changed. It is generally preferred to use this over `component_added`, to avoid conflicts with the component library.
---@field componentType string

---@class ComponentUnavailableEvent This signal is queued by the component library when a primary component is removed. It is generally preferred to use this over component_removed, to avoid conflicts with the component library.
---@field componentType string

---@class TermAvailableEvent This signal is queued by the [term library](https://ocdoc.cil.li/api:term "api:term") when both a [GPU](https://ocdoc.cil.li/item:graphics_card "item:graphics_card") *and* [screen](https://ocdoc.cil.li/block:screen "block:screen") become available in a computer. This is useful to determine whether it is now possible to print text to an attached screen.

---@class TermUnavailableEvent This signal is queued by the [term library](https://ocdoc.cil.li/api:term "api:term") when either the primary [GPU](https://ocdoc.cil.li/item:graphics_card "item:graphics_card") or [screen](https://ocdoc.cil.li/block:screen "block:screen") becomes unavailable in a computer. This is useful to determine when it becomes impossible to print text to an attached screen.

---@class ScreenResizedEvent This signal is queued by [screens](https://ocdoc.cil.li/block:screen "block:screen") when their resolution changes, for example because it was manually set via a [GPU](https://ocdoc.cil.li/component:gpu "component:gpu").
---@field screenAddress string The address is the address of the screen that queued the signal.
---@field newWidth number
---@field newHeight number

---@class TouchEvent This signal is queued by screens of tier two and tier three when they are clicked. This includes left clicks in the GUI (i.e. when a keyboard is attached) or when right-clicking/activating them in the world directly (i.e. when no keyboard is attached or when sneak-activating).<br/>Note on the player name: I'll probably add an option to disable this argument in the future, for those who think it's too... unrealistic. It's just quite handy for multi-user programs, so I left it in for now.<br/>*Important*: this signal is *checked*, i.e. it is only queued on a computer if the player that caused it is [registered as a user](https://ocdoc.cil.li/computer_users "computer_users") on the computer (or there are no users registered on the computer).
---@field screenAddress string The address is the address of the screen the queued the signal.
---@field x number The x and y coordinates are in "letters" (meaning they map directly to `term.setCursor` or `gpu.set`, for example).
---@field y number The x and y coordinates are in "letters" (meaning they map directly to `term.setCursor` or `gpu.set`, for example).
---@field button number
---@field playerName string The player name is the user name of the player that triggered the event.

---@class DragEvent This signal is almost equivalent to the `touch` signal. The only difference is the implicit meaning: when this signal is fired, it "belongs" to a `touch` signal that was fired earlier. This can only be triggered by dragging in the GUI.
---@field screenAddress string The address is the address of the screen the queued the signal.
---@field x number The x and y coordinates are in "letters" (meaning they map directly to `term.setCursor` or `gpu.set`, for example).
---@field y number The x and y coordinates are in "letters" (meaning they map directly to `term.setCursor` or `gpu.set`, for example).
---@field button number
---@field playerName string The player name is the user name of the player that triggered the event.

---@class DropEvent This signal is triggered when the player releases the mouse button after a `touch` signal. Despite the name, it does not necessarily follow a `drag` signal.
---@field screenAddress string The address is the address of the screen the queued the signal.
---@field x number The x and y coordinates are in "letters" (meaning they map directly to `term.setCursor` or `gpu.set`, for example).
---@field y number The x and y coordinates are in "letters" (meaning they map directly to `term.setCursor` or `gpu.set`, for example).
---@field button number
---@field playerName string The player name is the user name of the player that triggered the event.

---@class ScrollEvent This signal is queued by screens of tier two and tier three when the player uses the mouse wheel in the GUI. Note that this may differ based on the client's operating system and/or driver configuration.
---@field screenAddress string The address is the address of the screen the queued the signal.
---@field x number The x and y coordinates are the cursor location when the scroll occurred and are, like the `touch` signal, in "letters".
---@field y number The x and y coordinates are the cursor location when the scroll occurred and are, like the `touch` signal, in "letters".
---@field direction number The `direction` indicates which way to scroll, where a positive value usually means "up", whereas a negative value means "down".
---@field playerName string The player name is the user name of the player that triggered the event. The same considerations apply to the player name parameter as in `touch`.

---@class WalkEvent This signal is queued by screens of tier two and tier three when a player or other entity walks on them. Unlike clicks, this can be triggered for regions of the screen where nothing is displayed based on the current resolution, so keep that in mind.\
---@field screenAddress string The address is the address of the screen the queued the signal.
---@field x number The x and y coordinates are *the coordinates of the sub-block* of the multi-block screen that queued the event. Use [gpu.getSize()](https://ocdoc.cil.li/component:gpu "component:gpu") to figure out which area of the display that actually represents.
---@field y number The x and y coordinates are *the coordinates of the sub-block* of the multi-block screen that queued the event. Use [gpu.getSize()](https://ocdoc.cil.li/component:gpu "component:gpu") to figure out which area of the display that actually represents.
---@field playerName string The player name is the user name of the player that triggered the event. The same considerations apply to the player name parameter as in `touch`.

---@class KeyDownEvent This signal is queued by [keyboards](https://ocdoc.cil.li/block:keyboard "block:keyboard") when a user inputs something on the screen it's attached to, more specifically when the user *presses* a key. This event may be repeated if the user keeps pressing the key.<br/>*Important*: this signal is *checked*, i.e. it is only queued on a computer if the player that caused it is [registered as a user](https://ocdoc.cil.li/computer_users "computer_users") on the computer (or there are no users registered on the computer).
---@field keyboardAddress string
---@field char number
---@field code number
---@field playerName string

---@class KeyUpEvent This signal is queued by [keyboards](https://ocdoc.cil.li/block:keyboard "block:keyboard") when a user inputs something on the screen it's attached to, more specifically when the user *releases* a key.<br/>Note that although most cases where a player can be "removed" from a screen without releasing the key before-hand *should* be handled (I think) there may still be cases where this fails. Meaning this feature is more or less in an... observation stage, and may be removed at a later point if it proves infeasible.<br/>*Important*: this signal is *checked*, i.e. it is only queued on a computer if the player that caused it is [registered as a user](https://ocdoc.cil.li/computer_users "computer_users") on the computer (or there are no users registered on the computer).
---@field keyboardAddress string
---@field char number
---@field code number
---@field playerName string

---@class ClipboardEvent This signal is queued by [keyboards](https://ocdoc.cil.li/block:keyboard "block:keyboard") when a user pastes text from the clipboard (Shift+Ins or middle mouse button). Note that the maximum length of the text that can be pasted is limited (can be changed in the config). *Important*: this signal is *checked*, i.e. it is only queued on a computer if the player that caused it is [registered as a user](https://ocdoc.cil.li/computer_users "computer_users") on the computer (or there are no users registered on the computer).
---@field keyboardAddress string
---@field value string
---@field playerName string

---@class RedstoneChangedEvent This signal is queued by [redstone components](https://ocdoc.cil.li/component:redstone "component:redstone") when an incoming signal changes. This is relative to the container of the component, so for computers and robots this depends on which way they are facing.
---@field address string The address is of the [Redstone I/O block](https://ocdoc.cil.li/block:redstone_io "block:redstone_io") or that of the [redstone card](https://ocdoc.cil.li/item:redstone_card "item:redstone_card") installed in the machine where the redstone signal was detected. For Redstone I/O blocks this is always the absolute side.
---@field side number The side is one of the [sides](https://ocdoc.cil.li/api:sides "api:sides") constants and indicates on which side the signal changed.
---@field oldValue number
---@field newValue number
---@field color number|nil The color is only included with bundled inputs, referring to which color of input changed.

---@class MotionEvent Fired by the [motion sensor](https://ocdoc.cil.li/block:motion_sensor "block:motion_sensor") when a living entity in its line of sight moves faster than the configured sensitivity.
---@field address string
---@field relativeX number
---@field relativeY number
---@field relativeZ number
---@field entityName string

---@class ModemMessageEvent This signal is queued by [network cards](https://ocdoc.cil.li/item:lan_card "item:lan_card") (including wireless ones) when they receive a message on an open port.
---@field receiverAddress string The first address is the address of the network card that received the message.
---@field senderAddress string The second the address is the address from where the message was sent. Note that the sender address may differ from the card that originally sent the message when it passed through one or more [switches](https://ocdoc.cil.li/block:switch "block:switch").
---@field port number The port is the port on which the message was received.
---@field distance number This distance is the distance only set when receiving *wireless* network messages, in which case it is the distance to the wireless network card that sent the message. For normal network cards the distance will always be zero.
---@field data (nil|boolean|number|string)[] All further parameters are user defined and correspond to what the sender specified in [modem.send()](https://ocdoc.cil.li/component:modem "component:modem") or `modem.broadcast()` as the message's payload.

---@class InventoryChangedEvent This signal is queued by robots when their inventory changes. Note that this only includes changes to the kind of item stored in a slot. For example, increasing or decreasing the size of an already present stack does not trigger this signal. However, swapping one item with another (say, torches with sticks) by hand will actually trigger *two* signals: one for the removal of the torches, one for putting the sticks into the temporarily empty slot. Swapping items using [robot.transferTo()](https://ocdoc.cil.li/api:robot "api:robot") will even trigger *four* signals - the same thing, but for the two slots involved in the swap.<br/>Also, this only fires for the actually addressable inventory of the robot, i.e. it does not trigger for changes in equipment (tool, card, upgrade).
---@field slot number

---@class BusMessageEvent
---@field protocolId number The `protocolId` is the protocol version that was used.
---@field senderAddress number The `senderAddress` is the address of the device sending the message.
---@field targetAddress number The `targetAddress` is the address of the device that the messages was intended for (-1 for network broadcasts).
---@field data table The `data` is a table of the data that was sent.
---@field metadata table The `metadata` is a table of data that are unique to the device that send the address.

---@class EventWrappers Used to wrap all standard events in custom wrappers.
---@field component_added fun(name:string,address:string,componentType:string):ComponentAddedEvent
---@field component_removed fun(name:string,address:string,componentType:string):ComponentRemovedEvent
---@field component_available fun(name:string,componentType:string):ComponentAvailableEvent
---@field component_unavailable fun(name:string,componentType:string):ComponentAvailableEvent
---@field term_available fun(name:string):TermAvailableEvent
---@field term_unavailable fun(name:string):TermUnavailableEvent
---@field screen_resized fun(name:string,screenAddress:string,newWidth:number,newHeight:number):ScreenResizedEvent
---@field touch fun(name:string,screenAddress:string,x:number,y:number,button:number,playerName:string):TouchEvent
---@field drag fun(name:string,screenAddress:string,x:number,y:number,button:number,playerName:string):DragEvent
---@field drop fun(name:string,screenAddress:string,x:number,y:number,button:number,playerName:string):DropEvent
---@field scroll fun(name:string,screenAddress:string,x:number,y:number,direction:number,playerName:string):ScrollEvent
---@field walk fun(name:string,screenAddress:string,x:number,y:number,playerName:number):WalkEvent
---@field key_down fun(name:string,keyboardAddress:string,char:number,code:number,playerName:string):KeyDownEvent
---@field key_up fun(name:string,keyboardAddress:string,char:number,code:number,playerName:string):KeyUpEvent
---@field clipboard fun(name:string,keyboardAddress:string,value:string,playerName:string):ClipboardEvent
---@field redstone_changed fun(name:string,address:string,side:number,oldValue:number,newValue:number,color:string|nil):RedstoneChangedEvent
---@field motion fun(name:string,address:string,relativeX:number,relativeY:number,relativeZ:number,entityName:string):MotionEvent
---@field modem_message fun(name:string,receiverAddress:string,senderAddress:string,port:number,distance:number,...:nil|boolean|number|string):ModemMessageEvent
---@field inventory_changed fun(name:string,slot:number):InventoryChangedEvent
---@field bus_message fun(name:string,protocolId:number,senderAddress:number,targetAddress:number,data:table,metadata:table):BusMessageEvent
---@field getWrapperByName fun(name:string,...:any):table Wraps an event based on its name
---@field __index fun(i:string):fun(...:any):table
local event_wrappers
---@type EventWrappers
event_wrappers = {
  component_added = function(name, address,componentType) return {address = address, componentType = componentType} end,
  component_removed = function(name, address, componentType) return {address = address, componentType = componentType} end,
  component_available = function(name, componentType) return {componentType = componentType} end,
  component_unavailable = function(name, componentType) return {componentType = componentType} end,
  term_available = function(name) return {} end,
  term_unavailable = function(name) return {} end,
  screen_resized = function(name, screenAddress, newWidth, newHeight) return {screenAddress = screenAddress, newWidth = newWidth, newHeight = newHeight} end,
  touch = function(name, screenAddress, x, y, button, playerName) return {screenAddress = screenAddress, x = x, y = y, button = button, playerName = playerName} end,
  drag = function(name, screenAddress, x, y, button, playerName) return {screenAddress = screenAddress, x = x, y = y, button = button, playerName = playerName} end,
  drop = function(name, screenAddress, x, y, button, playerName) return {screenAddress = screenAddress, x = x, y = y, button = button, playerName = playerName} end,
  scroll = function(name, screenAddress, x, y, direction, playerName) return {screenAddress = screenAddress, x = x, y = y, direction = direction, playerName} end,
  walk = function(name, screenAddress, x, y, playerName) return {screenAddress = screenAddress, x = x, y = y, playerName = playerName} end,
  key_down = function(name, keyboardAddress, char, code, playerName) return {keyboardAddress = keyboardAddress, char = char, code = code, playerName = playerName} end,
  key_up = function(name, keyboardAddress, char, code, playerName) return {keyboardAddress = keyboardAddress, char = char, code = code, playerName = playerName} end,
  clipboard = function(name, keyboardAddress, value, playerName) return {keyboardAddress = keyboardAddress, value = value, playerName = playerName} end,
  redstone_changed = function(name, address, side, oldValue, newValue, color) return {address = address, side = side, oldValue = oldValue, newValue = newValue, color=color} end,
  motion = function(name, address, relativeX, relativeY, relativeZ, entityName) return {address = address, relativeX = relativeX, relativeY = relativeY, relativeZ = relativeZ, entityName = entityName} end,
  modem_message = function(name, receiverAddress, senderAddress, port, distance, ...) return {receiverAddress = receiverAddress, senderAddress = senderAddress, port = port, distance = distance, data = {...}} end,
  bus_message = function(name, protocolId, senderAddress, targetAddress, data, metadata) return {protocolId = protocolId, senderAddress = senderAddress, targetAddress = targetAddress, data = data, metadata = metadata} end,
  getWrapperByName = function(name, ...) if event_wrappers[name] ~= nil then return event_wrappers[name](name, ...) end return nil end,
}

return event_wrappers