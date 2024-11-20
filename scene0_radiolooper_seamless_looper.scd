Server.killAll

~radio_files = "D:/Samples/radiosamples/shorter/*.wav".pathMatch;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });

//~winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
~winenv = Signal.sineFill( 1024, 1.0/#[ 1, 2, 3, 5, 8, 13, 21, 34, 55 ].scramble );
~winenv.put(~winenv.size-1, 0);
~grainbufenv = Buffer.sendCollection(s, ~winenv, 1);

/* BUSES */
/* SCENE 0. 0: pitch 1: startpos 2: looplength */
	~scene2_buses = Array.fill(3, {|i|

		Bus.control(s, 1).set(
			case
			{ i == 0} { 1 }
			{ i == 1 } { 0 }
			{ i == 2 } { 1 }; );
	});

~scene2_buses[0].set(0.125);

SynthDef(\radio_sampler, {|out=0 amp=0.3 bufnum rateBus envbuf dur=0.1 posBus overlap=1|
		var env, sig, rate, pos;
	    rate = In.kr(rateBus, 1);
	    pos = In.kr(posBus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * pos,loop: 0);
	//sig = MidEQ.ar(sig, 1000, 0.1,9);
		Out.ar(out, Pan2.ar(sig*env*overlap.reciprocal*amp)); }).store;

~grain_routine = Routine({ inf.do{ var dur = rrand(0.25,0.5), overlap=rrand(0.0,0.2);
	Synth(\radio_sampler, [\envbuf, ~grainbufenv, \bufnum, ~radio_samples[0],\dur,dur+overlap, \rateBus, ~scene2_buses[0], \posBus, ~scene2_buses[1]]);
	dur.wait;
}; }).play;

~grain_routine.stop;

~radio_samples.size
SynthDef(\transition_sound,{|out amp=0.125 bufnum rate=1 gate=1 gen_index=0.3|

					var env = EnvGen.ar(Env.adsr(\attack.kr(2),0.0,1,\release.kr(0.5),curve: 3.0),gate,doneAction:2);
					var vib = Gendy1.kr(1,1,1,1,0.5, 90,mul:gen_index,add:1);


					var dsig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate * vib, 0, 0,1) * 1;
					Out.ar(out, dsig * env );
				}).store;

a = Synth(\transition_sound, [\bufnum, ~radio_samples[5] ]);

a.set(\gen_index, 0.5);

a.set(\gate,0);

~grainbufGroup = Group.new;

/* BUSES */
/* SCENE 0. 0: pitch 1: startpos 2: looplength */
	~scene0_buses = Array.fill(3, {|i|

		Bus.control(s, 1).set(
			case
			{ i == 0} { 1 }
			{ i == 1 } { 0 }
			{ i == 2 } { 1 }; );
	});

SynthDef(\radio_looper, {|out=0 amp=0.5 bufnum rateBus envbuf startposBus looprangeBus gate=1|
		var sigenv, env, sig, phasor, rate, startpos, dur,looprange;
	    rate = In.kr(rateBus, 1);
	    startpos = In.kr(startposBus, 1);
		looprange = In.kr(looprangeBus, 1);

		env = EnvGen.ar(Env.adsr(0.01, 0.0,1, 0.1),gate, doneAction: 2);

		phasor = Phasor.ar(0, rate * BufRateScale.kr(bufnum), startpos * BufFrames.kr(bufnum), (startpos + looprange) * BufFrames.kr(bufnum));
	    dur = (looprange * BufFrames.kr(bufnum) ) / 48000;
		//sigenv = EnvGen.ar(Env.linen(0.1*dur,0.8*dur,0.1*dur),\trig.tr(1));
		sig = BufRd.ar(1, bufnum, phasor);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;


SynthDef(\radio_looper, {|out=0 amp=0.25 bufnum rate=1 envbuf startpos=0 looprange=0.25 t_trig=0 |
		var sig1_OR_sig2, sig1,sig2,start1,start2,phasor1,phasor2,end1,end2,
	    sigenv, env, frames,endpos, dur, crossfade;

	    endpos =  (startpos + looprange);
	    sig1_OR_sig2 = ToggleFF.kr(t_trig);
	    //sig1_OR_sig2.poll;
	    start1 = Latch.kr(startpos, sig1_OR_sig2);
	    end1 = Latch.kr(endpos, sig1_OR_sig2);
	    start2 = Latch.kr(startpos, 1 - sig1_OR_sig2);
	    end2 = Latch.kr(endpos, 1 - sig1_OR_sig2);
	    crossfade = Lag.ar(K2A.ar(sig1_OR_sig2), 0.001);

	    rate = rate * BufRateScale.kr(bufnum);
	    frames = BufFrames.kr(bufnum);
	    //startpos = In.kr(startposBus, 1) * frames;
		//looprange = In.kr(looprangeBus, 1);
	    //startpos = startpos * frames;
	    dur = (looprange * frames ) / rate.abs / 48000;
	    //dur.poll;
	    env = EnvGen.ar(Env.new([0,1,1,0],[0,dur,0]),t_trig);
	    //env = EnvGen.ar(Env.linen(dur*0.1,dur*0.8,dur*0.1),t_trig);
	    env = EnvGen.ar(Env.perc(dur*0.01,dur*0.99),t_trig);
		phasor1 = Phasor.ar(sig1_OR_sig2, rate, start1*frames,end1*frames, start1*frames );
	    phasor2 = Phasor.ar(1 - sig1_OR_sig2, rate, start2*frames,end2*frames, start2*frames );
		//sigenv = EnvGen.ar(Env.linen(0.1*dur,0.8*dur,0.1*dur),\trig.tr(1));
		sig1 = BufRd.ar(1, bufnum, phasor1, interpolation: 1);
	    sig2 = BufRd.ar(1, bufnum, phasor2, interpolation: 1);
	Out.ar(out, Pan2.ar( (crossfade*sig1) + ( ( 1 - crossfade ) * sig2) * env * amp) );
	    }).store;


fork{ var rate, start_pos, loop_range;
	~scene0_buses[0].get{|item| rate = item; };
	~scene0_buses[1].get{|item| start_pos = item; };
	~scene0_buses[2].get{|item| loop_range = item; };

	Synth(\radio_looper, [\bufnum, ~radio_samples[4],\rate,rate, \startpos, start_pos, \looprange, loop_range,\out, ~verb ], ~grainbufGroup);

};


r = Routine({inf.do{ var rate, start_pos, loop_range,length;
	~scene0_buses[0].get{|item| rate = item; };
	~scene0_buses[1].get{|item| start_pos = item; };
	~scene0_buses[2].get{|item| loop_range = item; };

	~grainbufGroup.set(\t_trig, 1, \rate,rate,\startpos, start_pos, \looprange, loop_range);

	length = loop_range * ~radio_samples[4].numFrames / 48000;
	length.wait;
}; }).play;








r.stop;
~grainbufGroup.freeAll


~grainbufGroup.set(\gate,0);



{ SinOsc.ar(440,0,0.25)!2 }.play;



Server.default.makeGui



