open Belt

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

let getNoteFromIndex = index => notes->Array.getUnsafe(sanitizeNoteIndex(index))
let getOctaveFromIndex = index => index / noteLength
let getIndexFromNote = note => Js.Array.indexOf(note, notes)

let getBaseFrequency = note => {
  switch note {
  | A => 220.00
  | ASharp => 233.08
  | B => 246.94
  | C => 261.63
  | CSharp => 277.18
  | D => 293.66
  | DSharp => 311.13
  | E => 329.63
  | F => 349.23
  | FSharp => 369.99
  | G => 392.00
  | GSharp => 415.30
  }
}

let getFrequency = (note, octave) => {
  getBaseFrequency(note) *. 2.0 ** Float.fromInt(octave)
}
