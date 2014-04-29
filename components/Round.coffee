noflo = require 'noflo'

class Round extends noflo.Component
  icon: 'circle-o'
  constructor: ->
    @inPorts =
      in: new noflo.Port 'number'
    @outPorts =
      out: new noflo.Port 'number'

    @inPorts.in.on 'begingroup', (group) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', (data) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.send Math.round data
    @inPorts.in.on 'endgroup', =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.disconnect()

exports.getComponent = -> new Round
