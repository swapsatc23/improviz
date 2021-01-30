type audioContext
type oscillator
type gain

let newAudioContext: unit => audioContext = %raw(`() => new AudioContext()`)
let createOscillator: audioContext => oscillator = %raw(`context => context.createOscillator()`)
let oscillatorConnect: (oscillator, gain) => unit = %raw(`(o, g) => o.connect(g)`)
let setFrequency: (oscillator, float) => unit = %raw(`(o, frequency) =>
    o.frequency.value = frequency
`)
let createGain: audioContext => gain = %raw(`context => context.createGain()`)
let gainConnect: (gain, audioContext) => unit = %raw(`(g, context) =>
    g.connect(context.destination)
`)
let start: oscillator => unit = %raw(`(o) => o.start(0)`)
let stop: (gain, audioContext) => unit = %raw(`(g, context) =>
    g.gain.exponentialRampToValueAtTime(0.00001, context.currentTime + 2)
`)

let play = (c, frequency) => {
  let o = createOscillator(c)
  let g = createGain(c)
  o->oscillatorConnect(g)
  g->gainConnect(c)
  o->setFrequency(frequency)
  o->start
  g->stop(c)
}
