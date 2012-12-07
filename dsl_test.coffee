_ = require('underscore')
_.mixin(require('underscore.deferred'))

___ = -> console.log arguments...

# promise to wait s seconds
wait = (s) ->
  deferred = _.Deferred()
  _.delay (-> deferred.resolve()), 1000*s
  deferred.promise()

# promise to perform actions in parallel
par = (actions) ->
  _.when [a() for a in actions]

# promise to perform actions in sequence
seq = (actions, deferred) ->
  deferred ?= new _.Deferred()
  if actions and actions.length
    action = actions[0]?()
    if action? and action.then
      action.then -> seq actions[1..], deferred
    else
      seq actions[1..], deferred
  else
    deferred.resolve()
  deferred.promise()

# promise to perform actions at given times
schedule = (sch) ->
  actions = for time, action of sch
    ((time, action) ->
      -> seq [(-> ___ time), -> action()]) time, action
  seq actions


class Actor
  move: -> seq [
    -> @ani 'move'
    -> wait 2
    -> @ani 'idle'
  ]
  ani: (name) ->
    ___ 'ani', name


schedule
  '00:22': -> seq [
    -> ___ 'step1'
    -> wait 0.5
    -> ___ 'step2'
    -> wait 0.5
    -> ___ 'step3'
    -> wait 0.5
  ]

  '01:01': -> seq [
    -> ___ 'lofasz'
    -> wait 0.5
    -> ___ 'kutyafasz'
  ]

  '03:45': -> par [
    -> seq [
      -> wait 1
      -> ___ 'parallel1'
    ]
    -> seq [
      -> wait 1
      -> ___ 'parallel2'
    ]
  ]
  '05:05': -> seq [
    -> Milkman.go_home
    -> Milkman_Light.turn_off
  ]

