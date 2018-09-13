(
SynthDef( \chariots, {
	arg atk=0.1, rel=2, crv = 0, gate=1, lffreq=0.06, detune = 0.06,
	lpfreq=6000, fatk=1.6, frel=7.7, fcrv=0,
	mix=0.7, rm=0.9, dmp=0.07;
	var osc1, osc2, freq1, freq2, env, pitch, amp, sig, lfo1, pitch2,
	fenv;
	fenv = EnvGen.ar( Env.asr(fatk, 1, frel, fcrv), gate );
	lfo1 = SinOsc.kr(lffreq);
	pitch = \note.kr(60, 0.017);
	pitch2 = pitch + (lfo1*detune) ;
	amp = \amp.kr(0.85, 0.017);
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate , doneAction:2);
	freq1 = pitch.midicps;
	freq2 = pitch2.midicps;
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	sig = Mix.ar( [osc1, osc2] );
	sig = RLPF.ar(sig, (lpfreq*fenv)+100 );
	//sig = FreeVerb2.ar(sig, sig, mix, rm, dmp);
	sig = JPverb.ar(sig, 4, 0, 4);
	Out.ar(0, sig*amp*env);
}).add;
)
a = Synth(\chariots);
a.set(\gate, 0);
a.set(\gate, 1, \note, 60);
a.set(\gate, 1, \note, 64);
a.set(\gate, 1, \note, 43);
a.set(\gate, 1, \note, 36);
a.free;
s.options.memSize = 819200;

(
 Pbind(
  \instrument, \chariots,
	\note,  Pseq( [ 64, \rest, 66,  69, \rest,  68, 66, 68, 71, 73, 70, 66, 69, 76 ], 1 ),
	\dur,  Pseq(  [ 1, Rest(1.0), 1, 1, Rest(3.5), 0.25, 0.25, 4, 3.5, 0.5, 4, 1, 2,8], 1  ),
	\rel,  Pseq(  [ 4, \rest, 2, 6, \rest, 0.5, 0.5, 4, 4, 2, 2, 2, 4, 12], 1  ),
 \amp,  Pseq(  [ 0.4 ], inf  )
).play ( TempoClock(70/60) );
)