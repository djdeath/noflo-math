noflo = require 'noflo'

class NanToZero extends noflo.Component
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
      @outPorts.out.send(if isNaN(data) then 0 else data)
    @inPorts.in.on 'endgroup', =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.disconnect()

exports.getComponent = -> new NanToZero
