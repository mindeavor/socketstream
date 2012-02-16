# Remote Console
# -----------------
# Starts a console that connects to a running SocketStream server

require('colors')
log = console.log

net = require('net')
repl = require('repl')
netUtil = require('../utils/net')


exports.Console = class Client

  constructor: ->
    @cbStack = []
    return this


  connect: (portOrAddr) ->
    {@port, @host} = netUtil.parsePortOrAddr(portOrAddr)
    log "Connecting to #{@host} on port #{@port}...".green

    @client = net.connect(@port, @host)
    @client.on 'data', (data) =>
      cb = @cbStack.pop()
      cb data.toString().replace(/\n$/, '')
    @client.on 'end', -> log 'Disconnected from server.'.red

    return this


  connectWithRepl: (portOrAddr) ->
    @connect(portOrAddr)
    evalFunc = createEvalFunc(@client, @cbStack)
    repl.start "#{@host}:#{@port} > ", undefined, evalFunc
    return this


# Helper methods

createEvalFunc = (client, cbStack) ->
  (code, context, file, cb) ->
    cbStack.push(cb)
    # strip repl string wrapping before sending
    code = code.substring(1, code.length - 2)
    client.write(code)

