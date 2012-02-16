net = require('net')
repl = require('repl')
misc = require('../utils/misc')

exports.init = (ss) ->
  context = ss:ss.api
  setContext: (ctx) -> context = ctx; this
  addContext: (ctx) -> misc.extend(context, ctx); this
  listen: (port) -> createServer port, context


createServer = (port, context) ->
  server = net.createServer (socket) ->
    rconsole = repl.start('', socket, undefined, true)
    rconsole.context[k] = v for k,v of context
  server.listen(port);
