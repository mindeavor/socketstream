fs = require('fs')
should = require('should')
detective = require('detective')

depLib = null

rootDir = "#{__dirname}/testdata_files/requires"

testFiles = {}
for fileName in ['one','two','three','four']
  testFiles[fileName] = "./#{fileName}"



describe 'assertCorrectDepOrder', ->
  it 'should test dependencies correctly', ->
    assertCorrectDepOrder ['c','b','a'],
      a: ['b','c']
      b: ['c']
    assertCorrectDepOrder ['e','d','c','b','a'],
      a: ['d','c']
      c: ['e']
      d: ['e']



describe 'depLib', ->
  it 'should exist', ->
    should.exist(depLib)


  it 'should correctly order the deps of a single file', ->
    # one => a, b
    moduleOrder = depLib.analyze( rootDir, [testFiles.one] )
    assertCorrectDepOrder  moduleOrder, buildDepMap(testFiles.one)


  it 'should correctly order the deps of multiple files', ->
    # one => a, b
    # two => one, c
    moduleOrder = depLib.analyze( rootDir, [testFiles.one, testFiles.two] )
    assertCorrectDepOrder  moduleOrder, buildDepMap(testFiles.one, testFiles.two)

    moduleOrder = depLib.analyze( rootDir, [testFiles.two, testFiles.one] )
    assertCorrectDepOrder  moduleOrder, buildDepMap(testFiles.one, testFiles.two)


  it 'should handle multiple modules requiring the same dependency', ->
    # two => one, c
    # three => one, two
    moduleOrder = depLib.analyze( rootDir, [testFiles.two, testFiles.three] )
    assertDepsOrder  moduleOrder, buildDepMap(testFiles.two, testFiles.three)


  it 'should order deps correctly regardless of file order', ->
    # one => a, b
    # four => b, c
    moduleOrder = depLib.analyze( rootDir, [testFiles.one, testFiles.four] )
    assertCorrectDepOrder  moduleOrder, buildDepMap(testFiles.one, testFiles.four)

    moduleOrder = depLib.analyze( rootDir, [testFiles.four, testFiles.one] )
    assertCorrectDepOrder  moduleOrder, buildDepMap(testFiles.four, testFiles.one)



# Helper functions

getDeps = (fileOrModuleName) ->
  file = require.resolve(fileOrModuleName.replace /^\.\//, "#{rootDir}/")
  detective  fs.readFileSync(file)

buildDepMap = (files...) ->
  depMap = {}
  depMap[f] = getDeps(f) for f in files
  return depMap

assertCorrectDepOrder = (resultOrder, depMap) ->
  # Cycle through deps and make sure result is in a valid order
  for module, deps of depMap
    moduleIdx = resultOrder.indexOf(module)
    moduleIdx.should.be.above -1, "Module #{module} is not in the result!"
    for d in deps
      resultOrder.indexOf(d).should.be.below  moduleIdx,
        "Module `#{d}` does not come before module `#{module}`"
