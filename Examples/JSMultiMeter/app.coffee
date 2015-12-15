

connections = require './lib/ws-server'

###
meter = require './lib/meter', (display) ->
  for c in connections
    c.sendUTF "\"msgtype\": \"data\", \"sensortype\":\"temperature\", 
               \"sensorid\":\"123\", \"value\":"' + sensorValue + '" }');
###
