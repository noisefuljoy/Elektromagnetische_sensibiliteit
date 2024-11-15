
~radio_files = "D:/Samples/radiosamples/*.wav".pathMatch;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });

~grainbufGroup = Group.new;

~trateBus = Array.fill(4, { Bus.control(s, 1).set(10); });
~durBus = Array.fill(4, { Bus.control(s, 1).set(0.25); });
~grainPosBus = Array.fill(4, {  Bus.control(s, 1).set(0.25); });
~grainpitchBus = Array.fill(4, { Bus.control(s, 1).set(1); });
~grainampBus = Array.fill(4, { Bus.control(s, 1).set(0.75); });
~posBus = Array.fill(16, {|i| Bus.control(s, 1).set(i*0.125); });
~endposBus = Bus.control(s, 1).set( 1.0 );
~endposBus.set(0.4);
/*
SynthDef(\radio_looper, {|out=0 amp=0.15 bufnum rateBus envbuf dur=0.1 posBus endposBus overlap=1 gate=1 trig=0|
		var sigenv, env, sig, rate, pos, endpos;
	    rate = In.kr(rateBus, 1);
	    pos = In.kr(posBus, 1);
		endpos = In.kr(endposBus, 1);
		//env = Osc1.ar(envbuf, dur*overlap);
		env = EnvGen.ar(Env.adsr(0.01, 0.0,1, 0.1),gate, doneAction: 2);
		//sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.ir(bufnum) * pos,loop: 0);
	    sigenv = EnvGen.ar(Env.perc(0.001, dur*0.9),trig);
		sig = BufRd.ar(1, bufnum, Phasor.ar(trig, rate * BufRateScale.kr(bufnum), pos * BufFrames.kr(bufnum), endpos * BufFrames.kr(bufnum),pos * BufFrames.kr(bufnum) ));
		Out.ar(out, Pan2.ar(sig*env*overlap.reciprocal*amp)); }).store;
*/
SynthDef(\radio_looper, {|out=0 amp=0.5 bufnum rateBus envbuf startposBus looprangeBus gate=1 trig=0|
		var sigenv, env, sig, phasor, rate, startpos, looprange, dur;
	    rate = In.kr(rateBus, 1);
	    startpos = In.kr(startposBus, 1);
		looprange = In.kr(looprangeBus, 1);
		env = EnvGen.ar(Env.adsr(0.01, 0.0,1, 0.1),gate, doneAction: 2);
		phasor = Phasor.ar(0, rate * BufRateScale.kr(bufnum), startpos * BufFrames.kr(bufnum), (startpos + looprange) * BufFrames.kr(bufnum));
	   // dur = (looprange * BufFrames.kr(bufnum) ) / 48000;
	    //sigenv = EnvGen.ar(Env.perc(0.001, dur*0.9),phasor);
		sig = BufRd.ar(1, bufnum, phasor);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;


Synth(\radio_looper, [\bufnum, ~radio_samples[2],
					\trateBus, ~trateBus[0].index, \durBus,~durBus[0].index,
					\startposBus, ~grainPosBus[0].index, \looprangeBus, ~endposBus.index, \rateBus, ~grainpitchBus[0].index, \ampBus,~grainampBus[0].index, \out, 0 ],~grainbufGroup);


(~radio_samples[2].numFrames * 0.1)/48000

~grainPosBus[0].set(0.0);
~endposBus.set(0.0005);

~grainbufGroup.set(\trig, 1);



~grainPosBus[0].set(0.5);
~endposBus.set(0.50);

~grainbufGroup.set(\gate,0);


Bus