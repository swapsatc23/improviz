type scale =
  | Ionian
  | Dorian
  | Phrygian
  | Lydian
  | Mixolydian
  | Aeolian
  | Locrian
  | Diminished
  | Pentatonic
  | Blues
  | MelodicMinor
  | Everything

let allScales = [
  Ionian,
  Dorian,
  Phrygian,
  Lydian,
  Mixolydian,
  Aeolian,
  Locrian,
  Diminished,
  Pentatonic,
  Blues,
  MelodicMinor,
  Everything,
]

let toString = scale =>
  switch scale {
  | Ionian => "Ionian"
  | Dorian => "Dorian"
  | Phrygian => "Phrygian"
  | Lydian => "Lydian"
  | Mixolydian => "Mixolydian"
  | Aeolian => "Aeolian"
  | Locrian => "Locrian"
  | Diminished => "Diminished"
  | Pentatonic => "Pentatonic"
  | Blues => "Blues"
  | MelodicMinor => "MelodicMinor"
  | Everything => "Everything"
  }

let fromString = str =>
  switch str {
  | "Ionian" => Some(Ionian)
  | "Dorian" => Some(Dorian)
  | "Phrygian" => Some(Phrygian)
  | "Lydian" => Some(Lydian)
  | "Mixolydian" => Some(Mixolydian)
  | "Aeolian" => Some(Aeolian)
  | "Locrian" => Some(Locrian)
  | "Diminished" => Some(Diminished)
  | "Pentatonic" => Some(Pentatonic)
  | "Blues" => Some(Blues)
  | "MelodicMinor" => Some(MelodicMinor)
  | "Everything" => Some(Everything)
  | _ => None
  }

let getScale = scale =>
  switch scale {
  | Ionian => [1., 0., 0.6, 0., 0.6, 0.15, 0., 0.6, 0., 0.6, 0., 0.15]
  | Dorian => [1., 0., 0.6, 0.15, 0., 0.6, 0., 0.6, 0., 0.15, 0.6, 0.]
  | Phrygian => [1., 0.15, 0., 0.6, 0., 0.6, 0., 0.15, 0.6, 0., 0.6, 0.]
  | Lydian => [1., 0., 0.6, 0., 0.6, 0., 0.15, 0.6, 0., 0.6, 0., 0.15]
  | Mixolydian => [1., 0., 0.6, 0., 0.15, 0.6, 0., 0.6, 0., 0.6, 0.15, 0.]
  | Aeolian => [1., 0., 0.15, 0.6, 0., 0.6, 0., 0.6, 0.15, 0., 0.6, 0.]
  | Locrian => [1., 0.15, 0., 0.6, 0., 0.6, 0.15, 0., 0.6, 0., 0.6, 0.]
  | Diminished => [1., 0., 0.15, 0.6, 0., 0.15, 0.6, 0., 0.15, 0.6, 0., 0.15]
  | Pentatonic => [1., 0., 0., 0.6, 0., 0.6, 0., 0.6, 0., 0., 0.6, 0.]
  | Blues => [1., 0., 0., 0.6, 0., 0.6, 0.15, 0.6, 0., 0., 0.6, 0.]
  | MelodicMinor => [1., 0., 0.15, 0.6, 0., 0.6, 0., 0.6, 0., 0.6, 0., 0.15]
  | Everything => [1., 0.08, 0.17, 0.25, 0.33, 0.42, 0.5, 0.58, 0.67, 0.75, 0.83, 0.92]
  }
