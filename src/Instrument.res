open Belt

type halfTone = int

type layout = {
  firstNote: Note.note,
  firstOctave: int,
  x: array<halfTone>,
  y: array<halfTone>,
}

type xDirection = Left | Right
type yDirection = Up | Down

type directions = {
  x: xDirection,
  y: yDirection,
}

type instrument = {
  directions: directions,
  layout: layout,
}

type instruments = Guitar | Bass | Harpejji | LeftHandedGuitar | LeftHandedBass | Cello

let allInstruments = [Guitar, Bass, Harpejji, LeftHandedGuitar, LeftHandedBass, Cello]

let toString = name =>
  switch name {
  | Guitar => "Guitar"
  | Bass => "Bass"
  | Harpejji => "Harpejji"
  | LeftHandedGuitar => "LeftHandedGuitar"
  | LeftHandedBass => "LeftHandedBass"
  | Cello => "Cello"
  }

let fromString = name =>
  switch name {
  | "Bass" => Some(Bass)
  | "Harpejji" => Some(Harpejji)
  | "Guitar" => Some(Guitar)
  | "LeftHandedGuitar" => Some(LeftHandedGuitar)
  | "LeftHandedBass" => Some(LeftHandedBass)
  | "Cello" => Some(Cello)
  | _ => None
  }

let fromName = name =>
  switch name {
  | Guitar => {
      directions: {
        x: Right,
        y: Up,
      },
      layout: {
        firstNote: E,
        firstOctave: -2,
        x: Array.concat([0], Array.range(0, 20)->Array.map(_ => 1)),
        y: [0, 5, 5, 5, 4, 5],
      },
    }
  | Bass => {
      directions: {
        x: Right,
        y: Up,
      },
      layout: {
        firstNote: E,
        firstOctave: -3,
        x: Array.concat([0], Array.range(0, 20)->Array.map(_ => 1)),
        y: [0, 5, 5, 5],
      },
    }
  | Harpejji => {
      directions: {
        x: Right,
        y: Up,
      },
      layout: {
        firstNote: E,
        firstOctave: -1,
        x: Array.concat([0], Array.range(0, 12)->Array.map(_ => 2)),
        y: Array.concat([0], Array.range(0, 16)->Array.map(_ => 1)),
      },
    }
  | LeftHandedGuitar => {
      directions: {
        x: Left,
        y: Up,
      },
      layout: {
        firstNote: E,
        firstOctave: -2,
        x: Array.concat([0], Array.range(0, 20)->Array.map(_ => 1)),
        y: [0, 5, 5, 5, 4, 5],
      },
    }
  | LeftHandedBass => {
      directions: {
        x: Left,
        y: Up,
      },
      layout: {
        firstNote: E,
        firstOctave: -3,
        x: Array.concat([0], Array.range(0, 20)->Array.map(_ => 1)),
        y: [0, 5, 5, 5],
      },
    }
  | Cello => {
      directions: {
        x: Right,
        y: Up,
      },
      layout: {
        firstNote: C,
        firstOctave: 0,
        x: Array.concat([0], Array.range(0, 20)->Array.map(_ => 1)),
        y: [0, 7, 7, 7],
      },
    }
  }

type gridItem = {note: Note.note, octave: Note.octave}

let getGrid = ({directions, layout}) => {
  let gridYScale = switch directions.y {
  | Down => layout.y
  | Up => layout.y->Array.reverse
  }

  let gridXScale = switch directions.x {
  | Left => layout.x->Array.reverse
  | Right => layout.x
  }

  let firstNoteIndex = Note.getIndexFromNote(layout.firstNote)

  let (rowReduce, rowConcat) = switch directions.y {
  | Down => (Array.reduce, (xs, x) => Array.concat(xs, [x]))
  | Up => (Array.reduceReverse, (xs, x) => Array.concat([x], xs))
  }

  let (cellReduce, cellConcat) = switch directions.x {
  | Right => (Array.reduce, (xs, x) => Array.concat(xs, [x]))
  | Left => (Array.reduceReverse, (xs, x) => Array.concat([x], xs))
  }

  gridYScale
  ->rowReduce((firstNoteIndex, []), ((prevRowDistance, grid), rowDiff) => {
    let rowDistance = prevRowDistance + rowDiff

    let cellList =
      gridXScale
      ->cellReduce((rowDistance, []), ((prevCellDistance, cells), cellDiff) => {
        let cellDistance = prevCellDistance + cellDiff
        let note = Note.getNoteFromIndex(cellDistance)
        let octave = layout.firstOctave + Note.getOctaveFromIndex(cellDistance)
        (cellDistance, cellConcat(cells, {note: note, octave: octave}))
      })
      ->snd

    (rowDistance, rowConcat(grid, cellList))
  })
  ->snd
}
