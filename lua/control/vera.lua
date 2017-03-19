local http = require 'http'

local vera = { params = {} }

function vera:init(params)
	self.params = params
end

function vera:close()
	if self.req then
		self.req:close()
	end
end

function vera:getVariable(params)
	local url = string.format('http://%s:3480/data_request?id=variableget&DeviceNum=%s&serviceId=%s&Variable=%s',
		self.params.address, params.deviceId, params.serviceId, params.variable)
	local done = (type(params.done) == 'function') and params.done or (function() end)
	local fail = (type(params.fail) == 'function') and params.fail or (function() end)
	self.req = http.get({
		url = url,
		done = function(result)
			if (result.status_code ~= 200) then
				fail('error', {})
			else
				done({ value = result.content })
			end
		end,
		fail = function(err, result)
			fail(err, result)
		end
	})
end

local function encode(arguments)
	local result = ''
	for key, value in pairs(arguments) do
		result = result .. '&' .. key .. '=' .. value
	end
	return result
end

function vera:callAction(params)
	local url = string.format('http://%s:3480/data_request?id=lu_action&DeviceNum=%s&serviceId=%s&action=%s',
		self.params.address, params.deviceId, params.serviceId, params.action)
	url = url .. encode(params.arguments)
	local done = (type(params.done) == 'function') and params.done or (function() end)
	local fail = (type(params.fail) == 'function') and params.fail or (function() end)
	self.req = http.get({
		url = url,
		done = function(result)
			if (result.status_code ~= 200) then
				fail('error', {})
			else
				print(result.content)
				local jobId = result.content:match('<JobID>(%d+)<') or result.content:match('<OK>OK<')
				-- analyse de la sortie à faire
				if jobId then
					done()
				else
					fail('can not call action')
				end
			end
		end,
		fail = function(err, result)
			fail(err, result)
		end
	})
end

function vera:runScene(params)
	
end

return vera
