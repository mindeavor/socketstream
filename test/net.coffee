netUtil = require('../lib/utils/net')


describe 'parsePortOrAddr', ->
  it 'should accept port numbers', ->
    result = netUtil.parsePortOrAddr('9999')
    result.should.have.property 'host', 'localhost'
    result.should.have.property 'port', '9999'


  it 'should accept the host:port format with no protocol', ->
    result = netUtil.parsePortOrAddr('localhost:9999')
    result.should.have.property 'host', 'localhost'
    result.should.have.property 'port', '9999'

    result = netUtil.parsePortOrAddr('127.0.0.1:9999')
    result.should.have.property 'host', '127.0.0.1'
    result.should.have.property 'port', '9999'


  it 'should accept formats with protocols', ->
    result = netUtil.parsePortOrAddr('http://cool.com:9999')
    result.should.have.property 'host', 'http://cool.com'
    result.should.have.property 'port', '9999'
