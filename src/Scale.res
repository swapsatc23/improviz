type scale =
  Ionian | Dorian | Phrygian | Lydian | Mixolydian | Aeolian | Locrian | Diminished | Blues

let allScales = [Ionian, Dorian, Phrygian, Lydian, Mixolydian, Aeolian, Locrian, Diminished, Blues]

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
  | Blues => "Blues"
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
  | "Blues" => Some(Blues)
  | _ => None
  }

let getScale = scale =>
  switch scale {
  | Ionian => [1.0, 0.0, 0.6, 0.0, 0.6, 0.15, 0.0, 0.6, 0.0, 0.6, 0.0, 0.15]
  | Dorian => [1.0, 0.0, 0.6, 0.15, 0.0, 0.6, 0.0, 0.6, 0.0, 0.15, 0.6, 0.0]
  | Phrygian => [1.0, 0.15, 0.0, 0.6, 0.0, 0.6, 0.0, 0.15, 0.6, 0.0, 0.6, 0.0]
  | Lydian => [1.0, 0.0, 0.6, 0.0, 0.6, 0.0, 0.15, 0.6, 0.0, 0.6, 0.0, 0.15]
  | Mixolydian => [1.0, 0.0, 0.6, 0.0, 0.15, 0.6, 0.0, 0.6, 0.0, 0.6, 0.15, 0.0]
  | Aeolian => [1.0, 0.0, 0.15, 0.6, 0.0, 0.6, 0.0, 0.6, 0.15, 0.0, 0.6, 0.0]
  | Locrian => [1.0, 0.15, 0.0, 0.6, 0.0, 0.6, 0.15, 0.0, 0.6, 0.0, 0.6, 0.0]
  | Diminished => [1.0, 0.0, 0.15, 0.6, 0.0, 0.15, 0.6, 0.0, 0.15, 0.6, 0.0, 0.15]
  | Blues => [1.0, 0.0, 0.0, 0.6, 0.0, 0.6, 0.15, 0.6, 0.0, 0.0, 0.6, 0.0]
  }
