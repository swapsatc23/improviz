open Webapi.Dom

let useWindowSize = () => {
  let (size, setSize) = React.useState(() => (
    Window.innerWidth(window),
    Window.innerHeight(window),
  ))

  React.useEffect0(() => {
    let handler = _ => setSize(_ => (Window.innerWidth(window), Window.innerHeight(window)))
    Window.addEventListener("resize", handler, window)
    Some(() => Window.removeEventListener("resize", handler, window))
  })

  size
}
