noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Boundary = require '../components/Boundary.coffee'
else
  Boundary = require 'noflo-math/components/Boundary.js'

describe 'Boundary component', ->
  c = null
  vin = null
  vout = null
  vmax = null
  vmin = null
  beforeEach ->
    c = Boundary.getComponent()
    vin = noflo.internalSocket.createSocket()
    vout = noflo.internalSocket.createSocket()
    vmax = noflo.internalSocket.createSocket()
    vmin = noflo.internalSocket.createSocket()
    c.inPorts.in.attach vin
    c.inPorts.max.attach vmax
    c.inPorts.min.attach vmin
    c.outPorts.out.attach vout

  describe 'when instantiated', ->
    it 'should calculate out=10 with min=5 max=15 in=10', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 10
        done()
      vmin.send 5
      vmax.send 10
      vin.send 10
    it 'should calculate out=0 with min=0 max=10 in=-1', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 0
        done()
      vmin.send 0
      vmax.send 10
      vin.send -1
    it 'should calculate out=25 with min=0 max=25 in=200', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 25
        done()
      vmin.send 0
      vmax.send 25
      vin.send 200
    it 'should not affect the value if no min/max given', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 42
        done()
      vin.send 42
    it 'should only apply min if just min is given', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 10
        done()
      vmin.send 10
      vin.send 2
    it 'should only apply min if just min is given (2)', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 20
        done()
      vmin.send 10
      vin.send 20
    it 'should only apply max if just max is given', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 20
        done()
      vmax.send 20
      vin.send 40
    it 'should only apply max if just max is given (2)', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 10
        done()
      vmax.send 20
      vin.send 10
