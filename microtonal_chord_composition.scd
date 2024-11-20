
Server.killAll


~radio_files = "D:/Samples/radiosamples/richer/*.wav".pathMatch;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });



SynthDef(\radio_sampler_microtone, {|out=0 amp=0.8 bufnum rate envbuf dur=0.1 pos overlap=1 gate=1|
		var env, sig;

	    env = EnvGen.ar(Env.adsr(0.1,0.0,1.0,1.0),gate, doneAction:2);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * pos,loop: 0);

		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;
