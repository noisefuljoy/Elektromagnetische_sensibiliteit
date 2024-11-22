
Server.killAll


~radio_files = "D:/Samples/radiosamples/richer/*.wav".pathMatch;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });



SynthDef(\radio_sampler_microtone, {|out=0 amp=0.8 bufnum rate=1 envbuf dur=0.1 pos overlap=1 gate=1|
		var env, sig;

	    env = EnvGen.ar(Env.adsr(0.1,0.0,1.0,1.0),gate, doneAction:2);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * pos,loop: 1);

		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;



~johnston = Tuning.johnston;


t = ScalaTunings.at('eikosany');
~eikosany = Tuning.eikosany;
~eikosany.ratios.size

t = ScalaTunings.at('eikoseven');
~eikoseven = Tuning.eikoseven;
~eikoseven.ratios

t = ScalaTunings.at('pentatetra1');
~pentatetra = Tuning.pentatetra1;


~pentatetra = Array.fill(30, {|i|
		case
	    { i < 9 } { ~pentatetra.ratios.wrapAt( i ) * 0.5 }
	    { i >= 9 and: i < 18 } { ~pentatetra.ratios.wrapAt( i ) * 1 }
	    { i >= 18 and: i < 27 } { ~pentatetra.ratios.wrapAt( i ) * 2 }
	    { i >= 27 } { ~pentatetra.ratios.wrapAt( i ) * 4 }

		});


t = ScalaTunings.at('eikosany');
~eikosany = Tuning.eikosany;
~eikosany_tuning = Array.fill(60, {|i|

	case
	{ i < 20 } { ~eikosany.ratios.wrapAt( i ) * 0.5 }
	{ i >= 20 and: i < 40 } { ~eikosany.ratios.wrapAt( i ) * 1 }
	{ i >= 40 and: i < 60 } { ~eikosany.ratios.wrapAt( i ) * 2 }

	});




~micro_tuning = Array.fill(30, {|i|
		if ( i < 20 , {
			~eikoseven.ratios.wrapAt( i ) * 0.5 }, {
			~eikoseven.ratios.wrapAt( i ) * 1
		});

	});



~micro_tuning = Array.fill(30, {|i|
		if ( i < 25 , {
			~johnston.ratios.wrapAt( i ) * 0.5 }, {
			~johnston.ratios.wrapAt( i ) * 1
		});

	});

Tuning.directory



~prime = Synth(\radio_sampler_microtone, [\bufnum, ~radio_samples[0], \rate, ~micro_tuning[0] ] );

~second = Synth(\radio_sampler_microtone, [\bufnum, ~radio_samples[0], \rate, ~micro_tuning[5] ] );

~third = Synth(\radio_sampler_microtone, [\bufnum, ~radio_samples[0], \rate, ~micro_tuning[12] ] );

~four = Synth(\radio_sampler_microtone, [\bufnum, ~radio_samples[0], \rate, ~micro_tuning[18] ] );


~prime.set(\gate,0 );
~second.set(\gate,0 );
~third.set(\gate,0 );
~four.set(\gate,0 );


~second.set(\rate, ~micro_tuning[5] );



~prime.set(\gate,0);

~prime.set(\rate, ~micro_tuning[2] );
~second.set(\rate, ~micro_tuning[3] );
~third.set(\rate, ~micro_tuning[4] );
~four.set(\rate, ~micro_tuning[5] );


~prime.set(\gate,0);
~second.set(\gate,0 );