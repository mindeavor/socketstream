url = require('url')

exports.parsePortOrAddr = (portOrAddr) ->
  if portOrAddr.match /^\d+$/
    # port only
    { host:'localhost', port:portOrAddr }
  else if (matches = portOrAddr.match /^([\w\.]+):(\w+)$/)
    # host:port without protocol
    { host:matches[1], port:matches[2] }
  else
    p = url.parse portOrAddr
    { host:"#{p.protocol}//#{p.hostname}", port:p.port }
