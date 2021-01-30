%%raw(`import './App.css';`)

open Belt

type dimensions = {width: int, height: int}
type grid = {cols: array<int>, rows: array<int>}

let unsafeGetValue: ReactEvent.Form.t => string = %raw(`(event) => event.target.value`)

let take = (xs, n) => Array.slice(xs, ~offset=0, ~len=n)
let takeRight = (xs, n) => Array.slice(xs, ~offset=-n, ~len=n)

@react.component
let make = () => {
  let (fundamental, setFundamental) = React.useState(() => Note.G)
  let (instrumentName, setInstrumentName) = React.useState(() => Instrument.LeftHandedGuitar)
  let (scaleName, setScaleName) = React.useState(() => Scale.Ionian)
  let (winWidth, winHeight) = Hooks.useWindowSize()

  let instrument = Instrument.fromName(instrumentName)
  let scale = Scale.getScale(scaleName)

  let maxWidth = winWidth - 60
  let maxHeight = winHeight - 100

  let targetCellDimensions = {width: 90, height: 70}
  let gridMaxCols = maxWidth / targetCellDimensions.width
  let gridMaxRows = maxHeight / targetCellDimensions.height

  let context = React.useMemo1(() => Audio.newAudioContext(), [])

  let play = Audio.play(context)

  let grid =
    Instrument.getGrid(instrument)
    ->switch instrument.directions.y {
    | Down => take(_, gridMaxRows)
    | Up => takeRight(_, gridMaxRows)
    }
    ->Array.map(
      switch instrument.directions.x {
      | Right => take(_, gridMaxCols)
      | Left => takeRight(_, gridMaxCols)
      },
    )

  let firstRow = grid->Array.get(0)->Option.getWithDefault([])

  let width = min(maxWidth, targetCellDimensions.width * firstRow->Array.length)
  let height = min(maxHeight, targetCellDimensions.height * grid->Array.length)

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
            let fundamentalIndex = Note.getIndexFromNote(fundamental)

            let halfTonesFromFundamental = Note.sanitizeNoteIndex(
              Note.getIndexFromNote(note) - fundamentalIndex,
            )

            let noteValue = scale[halfTonesFromFundamental]->Option.getWithDefault(0.0)
            let rgb = Color.hexToRgb(Color.Palette.backgroundColor)

            let isDisplayed = noteValue !== 0.0

            <div
              key={Note.toString(note) ++ "-" ++ Int.toString(octave)}
              onClick={_ => play(Note.getFrequency(note, octave))}
              className="noteContainer"
              style={ReactDOM.Style.make(
                ~width=`${Int.toString(cell.width)}px`,
                ~height=`${Int.toString(cell.height)}px`,
                ~transform=`translate(${Int.toString(cell.width * cellIndex)}px, ${Int.toString(
                    cell.height * rowIndex,
                  )}px)`,
                ~backgroundColor=isDisplayed ? Color.rgbaToString(rgb, 0.03) : "transparent",
                (),
              )}>
              <div
                className="noteDot"
                onMouseEnter={_ =>
                  if isDisplayed {
                    play(Note.getFrequency(note, octave))
                  }}
                style={ReactDOM.Style.make(
                  ~backgroundColor=isDisplayed ? Color.Palette.getColor(noteValue, ()) : "",
                  (),
                )}>
                {isDisplayed ? note->Note.toString->React.string : React.null}
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
            <option key={Instrument.toString(name)} value={Instrument.toString(name)}>
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
            <option key={Scale.toString(name)} value={Scale.toString(name)}>
              {name->Scale.toString->React.string}
            </option>
          )
          ->React.array}
        </select>
        <input
          defaultValue={fundamental->Note.toString}
          className="input"
          onChange={e =>
            switch e->unsafeGetValue->Note.fromString {
            | Some(note) => setFundamental(_ => note)
            | None => ()
            }}
        />
      </div>
    </div>
  </div>
}
