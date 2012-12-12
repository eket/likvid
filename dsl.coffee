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
cron = (sch) ->
  actions = for time, action of sch
    ((time, action) ->
      -> seq [(-> ___ time), -> action()]) time, action
  seq actions


ctx = window? || module.exports = {}
ctx.seq = seq
ctx.par = par
ctx.wait = wait
ctx.cron = cron
