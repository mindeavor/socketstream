
exports.process = function(args) {
  var Console;
  switch (args[0]) {
    case 'new':
    case 'n':
      return require('./generate').generate(args[1]);
    case 'console':
    case 'c':
      Console = require('./console').Console;
      return new Console().connectWithRepl(args[1]);
    default:
      return console.log('Type "socketstream new <projectname>" to create a new application');
  }
};
