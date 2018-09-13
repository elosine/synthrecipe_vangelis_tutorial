SynthDef(\sub, {} ).add;
(
SynthDef(\sub, {
	arg oscamp1=0.2, oscamp2 = 0.2, pitch=60, detunelforate=0.082, detune=0.01;
	var sig, osc1, osc2, detunelfo;
	detunelfo = SinOsc.kr(detunelforate).range(0.005, 0.02); //modulates pitch with Low Frequency Oscillator; modulating midi value
	osc1 = Saw.ar( pitch.midicps ); //oscillators sawtooth wave; pitch.midicps is frequency converted from midi pitch to Hz
	osc2 = Saw.ar(  (pitch+detunelfo).midicps); //oscillators sawtooth wave
	// osc2 = Saw.ar(  (pitch+detune).midicps); //oscillators sawtooth wave
	sig = Mix.ar( [osc1*oscamp1, osc2*oscamp2] ); //combining 2 oscillators into one signal + volume control over both oscillators
	Out.ar( 0, sig);
}).add;
)
Env.perc(0.05, 0.1, 1, 4).plot
(
SynthDef(\sub, {
	arg oscamp1=0.2, oscamp2 = 0.2, pitch=60, detunelforate=0.082, detune=0.01,
	gate=1, atk=0.41, decay=0, sus=1, rel=4, crv= 0, atk2=0.51, decay2=0, sus2=1, rel2=2.2, crv2= 0,
	ffreq=100, fres=0.75, amp=0.85, haas=0.01, rtail=1, sz=1;
	var sig, osc1, osc2, detunelfo, envA, envB, sig2;
	envA = EnvGen.ar( Env.adsr(atk, decay, sus, rel, 1, crv), gate);
	envB = EnvGen.ar( Env.adsr(atk2, decay2, sus2, rel2, 1, crv2), gate).range(300, 10000);
	detunelfo = SinOsc.kr(detunelforate).range(0.005, 0.02); //modulates pitch with Low Frequency Oscillator; modulating midi value
	osc1 = Saw.ar( pitch.midicps ); //oscillators sawtooth wave; pitch.midicps is frequency converted from midi pitch to Hz
	osc2 = Saw.ar(  (pitch+detunelfo).midicps); //oscillators sawtooth wave
	// osc2 = Saw.ar(  (pitch+detune).midicps); //oscillators sawtooth wave
	sig = Mix.ar( [osc1*oscamp1, osc2*oscamp2] ); //combining 2 oscillators into one signal + volume control over both oscillators
	sig = MoogLadder.ar(sig, envB, fres);
	// sig = RLPF.ar(sig, envB, fres);
	//sig2 = DelayC.ar(sig, 0.2, haas); //haas effect!!!
	// Out.ar( 0, [sig, sig2]*envA*amp);
	sig = JPverb.ar( sig, rtail, 0, sz);
	// sig = FreeVerb.ar(sig, 0.5, room);
	Out.ar( 0, sig*envA*amp);
}).add;
)
a = Synth(\sub);

a.set(\gate,1);
a.set(\gate, 0);
a.set(\haas, 0.01);
a.set(\ffreq, 300);
a.set(\fres, 0.75);

s.options.memSize = 819200;

(
 Pbind(
  \instrument, \sub,
	\pitch,  Pseq( [ 64, \rest, 66,  69, \rest,  68, 66, 68, 71, 73, 70, 66, 69, 76 ], 1 ),
	\dur,  Pseq(  [ 1, Rest(1.0), 1, 1, Rest(3.5), 0.25, 0.25, 4, 3.5, 0.5, 4, 1, 2,8], 1  ),
	\rel,  Pseq(  [ 4, \rest, 2, 6, \rest, 0.5, 0.5, 4, 4, 2, 2, 2, 4, 12], 1  ),
 \amp,  Pseq(  [ 0.4 ], inf  )
).play ( TempoClock(70/60) );
)



a.set(\detunelforate, 1.5);
a.set(\detune, 0.002);
a.set(\oscamp1, 0.0);
a.set(\detune, 0.02); 0.005 - 0.02