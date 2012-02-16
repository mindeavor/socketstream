var Client, createEvalFunc, log, net, netUtil, repl;

require('colors');

log = console.log;

net = require('net');

repl = require('repl');

netUtil = require('../utils/net');

exports.Console = Client = (function() {

  function Client() {
    this.cbStack = [];
    return this;
  }

  Client.prototype.connect = function(portOrAddr) {
    var _ref,
      _this = this;
    _ref = netUtil.parsePortOrAddr(portOrAddr), this.port = _ref.port, this.host = _ref.host;
    log(("Connecting to " + this.host + " on port " + this.port + "...").green);
    this.client = net.connect(this.port, this.host);
    this.client.on('data', function(data) {
      var cb;
      cb = _this.cbStack.pop();
      return cb(data.toString().replace(/\n$/, ''));
    });
    this.client.on('end', function() {
      return log('Disconnected from server.'.red);
    });
    return this;
  };

  Client.prototype.connectWithRepl = function(portOrAddr) {
    var evalFunc;
    this.connect(portOrAddr);
    evalFunc = createEvalFunc(this.client, this.cbStack);
    repl.start("" + this.host + ":" + this.port + " > ", void 0, evalFunc);
    return this;
  };

  return Client;

})();

createEvalFunc = function(client, cbStack) {
  return function(code, context, file, cb) {
    cbStack.push(cb);
    code = code.substring(1, code.length - 2);
    return client.write(code);
  };
};
