# Magic Path
# ----------
# Allows paths to be supplied as specific files (with file extensions) or as directories
# (in which case the contents of the dir will be expanded and served in alphanumeric order)

require('colors')
pathlib = require('path')
fileUtils = require('../utils/file')

exports.files = (prefix, paths = ['/']) ->
  files = []
  numRootFolders = prefix.split('/').length

  paths = [paths] unless paths instanceof Array

  paths.forEach (path) ->
    fullPath = pathlib.join(prefix, path)
    basename = pathlib.basename(fullPath)

    if (path.charAt(path.length-1) == '/') && fileUtils.isDir(fullPath)
      # path is a specified directory
      if tree = fileUtils.readDirSync(fullPath)
        tree.files.sort().forEach (file) ->
          files.push(file.split('/').slice(numRootFolders).join('/'))
      else
        console.log("!  error - /#{dir} directory not found".red)
    else if basename.indexOf('.') == -1
      # path is a file with no specific ext
      ext = fileUtils.findExtForBasePath(fullPath)
      files.push(path + ext) if ext
    else if basename.indexOf('.') > 0
      # path is a single specified file
      files.push(path)
  files
