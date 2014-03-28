noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Round = require '../components/Round.coffee'
else
  Round = require 'noflo-math/components/Round.js'

describe 'Round component', ->
  c = null
  vin = null
  vout = null
  beforeEach ->
    c = Round.getComponent()
    vin = noflo.internalSocket.createSocket()
    vout = noflo.internalSocket.createSocket()
    c.inPorts.in.attach vin
    c.outPorts.out.attach vout

  describe 'when instantiated', ->
    it 'should calculate 5.4 = 5', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 5
        done()
      vin.send 5.4
    it 'should calculate 2.6 = 3', (done) ->
      vout.once 'data', (res) ->
        chai.expect(res).to.equal 3
        done()
      vin.send 2.6
