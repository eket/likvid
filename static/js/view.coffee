[API, _, VH, S] =
  [window._view = {},
  window._,
  window._view_helper,
  window._sprite]

# canvas width in pixels
API.a = null

canvas = null
API.context = null

resize = ->
  API.a = _.min [window.innerWidth, window.innerHeight]
  [canvas.width, canvas.height] = [API.a, API.a]
  ___ "resized canvas to #{API.a}x#{API.a}"

API.sprites = []
# set up the html5 canvas and callbacks
API.init = ->
  window.addEventListener 'resize', resize, no
  canvas = document.getElementById 'view-canvas'
  API.context = canvas.getContext '2d'
  resize()

  VH.add_event_listener canvas, 'move', on_move

  API.sprites.push S.get_sprite API.context, 'forma'
  _loop()

recording = off
replaying = off
API.preset = []
API.replay = ->
  API.preset = API.preset.reverse()
  replaying = on
_loop = ->
  VH.clr API.context, API.a

  _.each API.sprites, (sprite) ->
    {x:x, y:y, w:w, h:h, img:img} = sprite
    if recording
      API.preset.push {x:x, y:y, w:w, h:h, img:img}
    else if replaying
      frame = API.preset.pop()
      if frame?
        x = frame.x
        y = frame.y
      else replaying = off

    API.context.drawImage img, x, y, w, h

  webkitRequestAnimationFrame _loop

on_move = (e) ->
  sprite = API.sprites[0]
  sprite.x = VH.get_x e
  sprite.y = VH.get_y e
  recording = e.which is 1
