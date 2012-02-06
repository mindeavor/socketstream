magic = require('../lib/client_asset_manager/magic_path')

testPrefix = './test/testdata_files'

describe 'Magic Path', ->

  it 'should echo files specified with extensions', ->
    files = magic.files testPrefix, ['random.js', 'view.html']
    files.length.should.equal 2
    shouldIncludeAll(files, 'random.js', 'view.html')

  it 'should find extensions for files not specified with any', ->
    files = magic.files testPrefix, ['random', 'view']
    files.length.should.equal 2
    shouldIncludeAll(files, 'random.js', 'view.html')

  it 'should recursively find files in specified directories', ->
    files = magic.files testPrefix, ['foo/']
    files.length.should.equal 3
    shouldIncludeAll(files, 'one.js', 'two.html', 'bar/three.jade')

  it 'should be able to do all of the above in one call', ->
    files = magic.files testPrefix, ['random.js', 'view', 'foo/']
    files.length.should.equal 5

    shouldIncludeAll(files, 'random.js', 'view.html')
    shouldIncludeAll(files, 'one.js', 'two.html', 'bar/three.jade')

# Helper functions

shouldIncludeAll = (specimen, required...) ->
  specimen.should.include x for x in required
