-- Vera control.
local control = require 'sevenhugs.remote.control'
local vera_binarylight = control.class()

vera_binarylight.description = {
	capability = 'light.switch'
}

local http = require 'http'
local vera = require 'control.vera'

function vera_binarylight:init()
	vera:init({ address = self.params.address })
end

function vera_binarylight:close()
	vera:close()
end

function vera_binarylight:query(ui)
	vera:getVariable({
		deviceId = self.params.deviceId,
		serviceId = 'urn:upnp-org:serviceId:SwitchPower1',
		variable = 'Status',
		done = function(result)
			ui:state(result.value)
		end,
		fail = function(err, result)
			ui:error(err)
		end
	})
end

function vera_binarylight:set(ui, state)
	vera:callAction({
		deviceId = self.params.deviceId,
		serviceId = 'urn:upnp-org:serviceId:SwitchPower1',
		action = 'SetTarget',
		arguments = { newTargetValue = (state and "1" or "0") },
		done = function(result)
			ui:state(state)
		end,
		fail = function(err, result)
			ui:error(err)
		end
	})
end

return vera_binarylight
