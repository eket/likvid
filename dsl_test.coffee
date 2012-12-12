___ = -> console.log arguments...

dsl = require('./dsl')
[wait, seq, par, cron] = [dsl.wait, dsl.seq, dsl.par, dsl.cron]


class Actor
  move: -> seq [
    -> @ani 'move'
    -> wait 2
    -> @ani 'idle'
  ]
  ani: (name) ->
    ___ 'ani', name


cron
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
