var createServer, misc, net, repl;

net = require('net');

repl = require('repl');

misc = require('../utils/misc');

exports.init = function(ss) {
  var context;
  context = {
    ss: ss.api
  };
  return {
    setContext: function(ctx) {
      context = ctx;
      return this;
    },
    addContext: function(ctx) {
      misc.extend(context, ctx);
      return this;
    },
    listen: function(port) {
      return createServer(port, context);
    }
  };
};

createServer = function(port, context) {
  var server;
  server = net.createServer(function(socket) {
    var k, rconsole, v, _results;
    rconsole = repl.start('', socket, void 0, true);
    _results = [];
    for (k in context) {
      v = context[k];
      _results.push(rconsole.context[k] = v);
    }
    return _results;
  });
  return server.listen(port);
};
