type note =
  | A
  | ASharp
  | B
  | C
  | CSharp
  | D
  | DSharp
  | E
  | F
  | FSharp
  | G
  | GSharp

type octave = int

let toString = note =>
  switch note {
  | A => "A"
  | ASharp => "A#"
  | B => "B"
  | C => "C"
  | CSharp => "C#"
  | D => "D"
  | DSharp => "D#"
  | E => "E"
  | F => "F"
  | FSharp => "F#"
  | G => "G"
  | GSharp => "G#"
  }

let fromString = str =>
  switch str {
  | "A" => Some(A)
  | "A#" => Some(ASharp)
  | "B" => Some(B)
  | "C" => Some(C)
  | "C#" => Some(CSharp)
  | "D" => Some(D)
  | "D#" => Some(DSharp)
  | "E" => Some(E)
  | "F" => Some(F)
  | "F#" => Some(FSharp)
  | "G" => Some(G)
  | "G#" => Some(GSharp)
  | _ => None
  }

let notes = [A, ASharp, B, C, CSharp, D, DSharp, E, F, FSharp, G, GSharp]

let noteLength = notes->Array.length

let sanitizeNoteIndex = index =>
  // Add notes.length to support negative indices
  mod(noteLength + mod(index, noteLength), noteLength)

let getNoteFromIndex = index => notes[sanitizeNoteIndex(index)]
let getOctaveFromIndex = index => index / noteLength
let getIndexFromNote = note => Js.Array.indexOf(note, notes)
