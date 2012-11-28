[API, _] =
  [window._sprite = {},
  window._]

API.get_sprite = (ctx, name) ->
  img = document.getElementById "sprite-#{name}"
  sprite =
    x: 0
    y: 0
    w: img.width/10.0
    h: img.height/10.0
    img: img
