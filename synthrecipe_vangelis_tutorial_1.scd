SynthDef(\sub, {} ).add;
(
SynthDef(\sub, {
	arg oscamp1=0.2, oscamp2 = 0.2, pitch=60, detunelforate=0.1;
	var sig, osc1, osc2, detunelfo;
	detunelfo = SinOsc.kr(detunelforate).range(0.005, 0.02);
	osc1 = Saw.ar(pitch.midicps);
	osc2 = Saw.ar(  (pitch+detunelfo).midicps);
	sig = Mix.ar( [osc1*oscamp1, osc2*oscamp2] );
	Out.ar( 0, sig);
}).add;
)
a = Synth(\sub);

a.set(\detunelforate, 0.05);
a.set(\oscamp1, 0.0);
a.set(\detune, 0.02); 0.005 - 0.02