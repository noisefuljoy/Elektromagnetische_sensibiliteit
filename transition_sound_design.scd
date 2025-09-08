

~sample_files = "D:/Jottabox/AETHER_ARCER/radio_samples/*.wav".pathMatch;

~samples = ~sample_files.collect{|i| Buffer.read(s, i); };

SynthDef(\transition_sound, {|out=0 amp=0.4 bufnum rate=0.5 dur=2.0 attack=0.3 release=6.0|
		var gate, env, sig;
	    gate = EnvGen.kr(Env([1,0], [dur]),1);
	    env = EnvGen.ar(Env.adsr(attack, 0.05,1.0,release,curve: \sine),gate, doneAction: 2);
		//rate = rate * Gendy1.kr(1,1,1,1,minFreq, maxFreq,mul:ratemod_index, add: 1);

		//sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * 0,loop: 0);
	sig = BufRd.ar(1, bufnum,LFTri.ar(Rand(5,500)) * BufFrames.ir(bufnum)) * env;
	sig = PitchShift.ar(sig, 0.2, Rand(0.125,0.5),0.1,0.3,0.75,sig*0.25);
	sig = AllpassC.ar(sig, 0.1,Rand(0.05,0.1),Rand(2,4),0.25, sig*0.75);
		//sig = Decimator.ar(sig, rrand(5000,1000), Rand(2,4),mix, sig * (1-mix));
		Out.ar(out, Pan2.ar(sig*amp*2, 0)); }).store;

a = Synth(\transition_sound,[\bufnum, ~samples.choose ]);
a.free

Server.killAll