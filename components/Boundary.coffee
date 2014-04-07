noflo = require 'noflo'

class Boundary extends noflo.Component
  constructor: ->
    @inPorts =
      min: new noflo.Port 'number'
      max: new noflo.Port 'number'
      in: new noflo.Port 'number'
    @outPorts =
      out: new noflo.Port 'number'

    @min = @max = null

    @inPorts.min.on 'data', (value) =>
      @min = value
    @inPorts.max.on 'data', (value) =>
      @max = value

    @inPorts.in.on 'begingroup', (group) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', (value) =>
      return unless @outPorts.out.isAttached()
      tmp = value
      tmp = Math.max(@min, tmp) if @min != null
      tmp = Math.min(@max, tmp) if @max != null
      @outPorts.out.send(tmp)
    @inPorts.in.on 'endgroup', =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.disconnect()

exports.getComponent = -> new Boundary
