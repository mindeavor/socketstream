var fileUtils, pathlib;

require('colors');

pathlib = require('path');

fileUtils = require('../utils/file');

exports.files = function(prefix, paths) {
  var files, numRootFolders;
  if (paths == null) paths = ['/'];
  files = [];
  numRootFolders = prefix.split('/').length;
  if (!(paths instanceof Array)) paths = [paths];
  paths.forEach(function(path) {
    var basename, ext, fullPath, tree;
    fullPath = pathlib.join(prefix, path);
    basename = pathlib.basename(fullPath);
    if ((path.charAt(path.length - 1) === '/') && fileUtils.isDir(fullPath)) {
      if (tree = fileUtils.readDirSync(fullPath)) {
        return tree.files.sort().forEach(function(file) {
          return files.push(file.split('/').slice(numRootFolders).join('/'));
        });
      } else {
        return console.log(("!  error - /" + dir + " directory not found").red);
      }
    } else if (basename.indexOf('.') === -1) {
      ext = fileUtils.findExtForBasePath(fullPath);
      if (ext) return files.push(path + ext);
    } else if (basename.indexOf('.') > 0) {
      return files.push(path);
    }
  });
  return files;
};
