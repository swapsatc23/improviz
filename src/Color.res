open Belt

@bs.val external parseInt: (string, int) => int = "parseInt"
type rgb = {r: int, g: int, b: int}

let rgbaToString = ({r, g, b}, opacity) =>
  `rgba(${Int.toString(r)},${Int.toString(g)},${Int.toString(b)}, ${Float.toString(opacity)})`

let hexToRgb = hex =>
  Js.Re.exec_(%re("/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i"), hex)
  ->Option.map(result => result->Js.Re.captures->Array.map(Js.Nullable.toOption))
  ->Option.flatMap(result =>
    switch result {
    | [_, Some(r), Some(g), Some(b)] =>
      Some({
        r: parseInt(r, 16),
        g: parseInt(g, 16),
        b: parseInt(b, 16),
      })
    | _ => None
    }
  )
  ->Option.getWithDefault({r: 0, g: 0, b: 0})

module Palette = {
  let backgroundColor = "rgba(57, 136, 255, 0.3)"

  let coldToHot = [
    "#005d87",
    "#4463a2",
    "#8064af",
    "#ba5faa",
    "#e95a94",
    "#ff6470",
    "#ff8045",
    "#ffa600",
  ]

  let cold = [
    "#005d87",
    "#2a6198",
    "#4c64a5",
    "#6f64ad",
    "#9163b0",
    "#b25fac",
    "#d05ca3",
    "#e95a94",
  ]

  let getColor = (value, ~palette=cold, ()) => {
    let index = Js.Math.ceil(palette->Array.length->Float.fromInt *. value) - 1
    palette->Array.getUnsafe(index)
  }
}
