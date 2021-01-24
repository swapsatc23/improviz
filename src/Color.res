open Belt

@bs.val external parseInt: (string, int) => int = "parseInt"
type rgb = {r: int, g: int, b: int}

let rgbaToString = ({r, g, b}, opacity: float) =>
  `rgba(${Int.toString(r)},${Int.toString(g)},${Int.toString(b)}, ${Float.toString(opacity)})`

let hexToRgb = (hex: string) =>
  (hex |> Js.Re.exec_(%re("/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i")))
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
