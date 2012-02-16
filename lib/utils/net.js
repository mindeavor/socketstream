var url;

url = require('url');

exports.parsePortOrAddr = function(portOrAddr) {
  var matches, p;
  if (portOrAddr.match(/^\d+$/)) {
    return {
      host: 'localhost',
      port: portOrAddr
    };
  } else if ((matches = portOrAddr.match(/^([\w\.]+):(\w+)$/))) {
    return {
      host: matches[1],
      port: matches[2]
    };
  } else {
    p = url.parse(portOrAddr);
    return {
      host: "" + p.protocol + "//" + p.hostname,
      port: p.port
    };
  }
};
