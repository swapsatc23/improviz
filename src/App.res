%%raw(`import './App.css';`)

open Belt

type pattern = {
  color: string,
  fundamental: Note.note,
}

type dimensions = {width: int, height: int}
type grid = {cols: array<int>, rows: array<int>}

let flatMap = (xs, f) => Array.reduce(xs, [], (acc, x) => Array.concat(acc, f(x)))

let unsafeGetValue: ReactEvent.Form.t => string = %raw(`(event) => event.target.value`)

@react.component
let make = () => {
  let (pattern, setPattern) = React.useState(() => {
    fundamental: G,
    color: "#3988FF",
  })

  let (instrumentName, setInstrumentName) = React.useState(() => Instrument.LeftHandedGuitar)
  let (scaleName, setScaleName) = React.useState(() => Scale.Ionian)

  let instrument = Instrument.fromName(instrumentName)
  let scale = Scale.getScale(scaleName)

  let (winWidth, winHeight) = Hooks.useWindowSize()

  let width = winWidth - 60
  let height = min(winHeight - 100, 400)

  let target = {width: 90, height: 70}

  let grid = Instrument.getGrid(instrument)

  Js.Console.log(grid)
  Js.Console.log(instrument)

  let firstRow = grid->Array.get(0)->Option.getWithDefault([])

  let cell = {
    width: width / firstRow->Array.length,
    height: height / Array.length(grid),
  }

  <div className="App">
    <div className="container">
      <div
        className="gridContainer"
        style={ReactDOM.Style.make(
          ~width=`${Int.toString(width)}px`,
          ~height=`${Int.toString(height)}px`,
          (),
        )}>
        {// vertical lines
        firstRow
        ->Array.mapWithIndex((i, _) =>
          i === 0
            ? React.null
            : <div
                key={Int.toString(i)}
                className="vertLine"
                style={ReactDOM.Style.make(
                  ~transform=`translateX(${Int.toString(i * cell.width - 3)}px)`,
                  (),
                )}
              />
        )
        ->React.array}
        {// horizontal lines
        grid
        ->Array.mapWithIndex((i, _) =>
          i === 0
            ? React.null
            : <div
                key={Int.toString(i)}
                className="horizontalLine"
                style={ReactDOM.Style.make(
                  ~transform=`translateY(${Int.toString(i * cell.height - 6)}px)`,
                  (),
                )}
              />
        )
        ->React.array}
        {grid
        ->Array.mapWithIndex((rowIndex, cells) =>
          cells
          ->Array.mapWithIndex((cellIndex, {note, octave}) => {
            let fundamentalIndex = Note.getIndexFromNote(pattern.fundamental)

            let halfTonesFromFundamental = Note.sanitizeNoteIndex(
              Note.getIndexFromNote(note) - fundamentalIndex,
            )

            let opacity = scale[halfTonesFromFundamental]->Option.getWithDefault(0.0)
            let rgb = Color.hexToRgb(pattern.color)

            <div
              key={Note.toString(note) ++ "-" ++ Int.toString(octave)}
              className="noteContainer"
              style={ReactDOM.Style.make(
                ~width=`${Int.toString(cell.width)}px`,
                ~height=`${Int.toString(cell.height)}px`,
                ~transform=`translate(${Int.toString(cell.width * cellIndex)}px, ${Int.toString(
                    cell.height * rowIndex,
                  )}px)`,
                ~backgroundColor=if opacity === 0.0 {
                  "transparent"
                } else {
                  Color.rgbaToString(rgb, 0.03)
                },
                (),
              )}>
              <div
                className="noteDot"
                style={ReactDOM.Style.make(
                  ~backgroundColor=if opacity === 0.0 {
                    "transparent"
                  } else {
                    Color.rgbaToString(rgb, opacity)
                  },
                  (),
                )}>
                {if opacity === 0.0 {
                  React.null
                } else {
                  note->Note.toString->React.string
                }}
              </div>
            </div>
          })
          ->React.array
        )
        ->React.array}
      </div>
      <div style={ReactDOM.Style.make(~marginTop="15px", ())}>
        <select
          value={Instrument.toString(instrumentName)}
          onChange={e =>
            switch e->unsafeGetValue->Instrument.fromString {
            | Some(instrumentName) => setInstrumentName(_ => instrumentName)
            | None => ()
            }}>
          {Instrument.allInstruments
          ->Array.map(name =>
            <option value={Instrument.toString(name)}>
              {name->Instrument.toString->React.string}
            </option>
          )
          ->React.array}
        </select>
        <select
          value={Scale.toString(scaleName)}
          onChange={e =>
            switch e->unsafeGetValue->Scale.fromString {
            | Some(scaleName) => setScaleName(_ => scaleName)
            | None => ()
            }}>
          {Scale.allScales
          ->Array.map(name =>
            <option value={Scale.toString(name)}> {name->Scale.toString->React.string} </option>
          )
          ->React.array}
        </select>
        <input
          defaultValue={pattern.fundamental->Note.toString}
          className="input"
          onChange={e =>
            switch e->unsafeGetValue->Note.fromString {
            | Some(note) => setPattern(pattern => {...pattern, fundamental: note})
            | None => ()
            }}
        />
      </div>
    </div>
  </div>
}
