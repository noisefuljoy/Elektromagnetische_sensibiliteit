


Server.killAll


t = ScalaTunings.at('pentatetra1');
~pentatetra = Tuning.pentatetra1;

~pentatetra_tuning = Array.fill(30, {|i|
		case
	    { i < 9 } { ~pentatetra.ratios.wrapAt( i ) * 0.5 }
	    { i >= 9 and: i < 18 } { ~pentatetra.ratios.wrapAt( i ) * 1 }
	    { i >= 18 and: i < 27 } { ~pentatetra.ratios.wrapAt( i ) * 2 }
	    { i >= 27 and: i < 36} { ~pentatetra.ratios.wrapAt( i ) * 4 }
		{ i >= 36 and: i < 45} { ~pentatetra.ratios.wrapAt( i ) * 8 }
		{ i >= 45 and: i < 54} { ~pentatetra.ratios.wrapAt( i ) * 16 }
		{ i >= 54 } { ~pentatetra.ratios.wrapAt( i ) * 32 };

		});



SynthDef(\sine_short, {|out=0 amp=0.5 freq=440 rel=0.1|
	var env, sig;
	env = EnvGen.ar(Env.perc(0.010,rel), doneAction: 2);
	sig = SinOsc.ar(freq * LFSaw.ar(Rand(90.0,150.0),0, 0.25, 1), LFPar.kr(Rand(0.1,10.0)).range(-2pi, 2pi) );
	sig = sig ring1: VarSaw.ar(freq * LFTri.ar(Rand(9.0,15.0),0, 0.9, 1),0, LFPar.kr(Rand(0.1,10.0)).range(0.1, 0.9));
	sig = sig ring1: Gendy1.ar;
	Out.ar(out, Pan2.ar(sig*env*amp)); }).add;



a = Synth(\sine_short);

~trans_routine = Routine({
	20.do{ var dur = [0.2,0.6,0.33,0.1].choose;
		dur = dur * 0.05;
		Synth(\sine_short,[\freq, 3000 * ~pentatetra_tuning.choose, \rel, dur * rrand(1,1.5) ]);

		dur.wait; };
}).play;


SynthDef(\sine_short_low, {|out=0 amp=0.5 freq=440 rel=0.1|
	var env, sig;
	env = EnvGen.ar(Env.perc(0.010,rel), doneAction: 2);
	sig = SinOsc.ar((freq * 0.25) *  LFSaw.ar(Rand(90.0,150.0),0, 0.25, 1), LFPar.kr(Rand(0.1,10.0)).range(-2pi, 2pi) );
	sig = sig ring1: VarSaw.ar(freq * 0.25 * LFTri.ar(Rand(9.0,15.0),0, 0.9, 1),0, LFPar.kr(Rand(0.1,10.0)).range(0.1, 0.9));
	sig = sig ring1: Gendy1.ar;
	sig = RLPF.ar(sig, 400, 0.5);
	Out.ar(out, Pan2.ar(sig*env*amp)); }).add;

~trans_routine = Routine({
	20.do{ var dur = [0.2,0.6,0.33,0.1].choose;
		dur = dur * 0.05;
		Synth(\sine_short_low,[\freq, 1000 * ~pentatetra_tuning.choose, \rel, dur * rrand(1,1.5) ]);

		dur.wait; };
}).play;
