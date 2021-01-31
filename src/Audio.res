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
let start: (gain, oscillator, audioContext) => unit = %raw(`(g, o, context) => {
    g.gain.value = 0.2;
    g.gain.exponentialRampToValueAtTime(0.00001, context.currentTime + 2)
    o.start(0);
}`)

let play = (c, frequency) => {
  let o = createOscillator(c)
  let g = createGain(c)
  o->oscillatorConnect(g)
  g->gainConnect(c)
  o->setFrequency(frequency)
  g->start(o, c)
}
