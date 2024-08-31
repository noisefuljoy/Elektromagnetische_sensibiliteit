



 ~radio_files = "D:/Samples/radiosamples/*.wav".pathMatch;
 ~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });
~env_buf = Buffer.sendCollection(s, Env.perc.discretize, 1);

SynthDef(\radio_sampler, {|out=0 amp=0.5 bufnum rate=1 envbuf dur=0.1 pos=0 release=0.5|
		var env, sig;
		env = Osc1.ar(envbuf, dur);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.ir(bufnum) * pos,loop: 1);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).add;

~grain_routine = Routine({ inf.do{ var dur = rrand(0.1, 0.11), overlap = rrand(1.0, 1.4);
	Synth(\radio_sampler, [\envbuf, ~envbuf, \bufnum, ~radio_samples[2],\rate, 1, \dur, dur, \pos, 0, \release, overlap]);
	dur.wait; } }).play;

~grain_routine.stop;

