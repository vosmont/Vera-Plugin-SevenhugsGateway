local common = require 'common'
local http = require 'http'
local cc = require 'control.vera_binarylight'

params = {
    address = '192.168.1.4',
    deviceId = 10006,
}
commands = {
    set = 1,
}
command, command_args = common.argparse(params, commands, arg)

c = cc(params)
http.run()
if command then
    c[command](c, common.ui, table.unpack(command_args))
    http.run()
end
c:query(common.ui)
http.run()
