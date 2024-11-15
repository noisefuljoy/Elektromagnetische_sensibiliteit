Server.killAll



~grainbufGroup = Group.new;

~radiotone = Buffer.read(s, "D:/Samples/radiosamples/shorter/radiotone.wav");


(~radiotone.numFrames * 1)/s.sampleRate


SynthDef(\radio_patternsampler, {|out=0 amp=0.5 bufnum rateBus envbuf startposBus durBus overlapBus trig=0|
		var gate_env, envlength, env, sig, phasor, rate, startpos, looprange, dur, overlap;
	    rate = In.kr(rateBus, 1);
	    startpos = In.kr(startposBus, 1);
		dur = In.kr(durBus, 1);
	    overlap = In.kr(overlapBus, 1);
	    envlength = (BufFrames.kr(bufnum) * dur) / s.sampleRate;
	    //envlength.poll;
	    gate_env = EnvGen.ar(Env([1,0],[envlength]),1);
		env = EnvGen.ar(Env.adsr(0.1, 0.0,1, overlap),gate_env, doneAction: 2);
		phasor = Phasor.ar(0, rate * BufRateScale.kr(bufnum), startpos * BufFrames.kr(bufnum), (startpos + dur) * BufFrames.kr(bufnum));
	   // dur = (looprange * BufFrames.kr(bufnum) ) / 48000;
	    //sigenv = EnvGen.ar(Env.perc(0.001, dur*0.9),phasor);
		sig = BufRd.ar(1, bufnum, phasor,0);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;

~radiopattern_buses = Array.fill(4, {|i|  Bus.control(s, 1).set(

	case { i == 0 } { 1 }
	{ i == 1 } {  0 }
	{ i == 2 } { 1 }
	{ i == 3 } { 0.001 }; ); });





~scaleWhole = Scale.leadingWhole(\michael_harrison);
~scale = ~scaleWhole.ratios.scramble

~pattern_routine = Routine({ inf.do{ var wait_time;

	5.do{|i|
		~radiopattern_buses[0].set( ~scale[i]* 0.0625 );

Synth(\radio_patternsampler, [\bufnum, ~radiotone,
		            \rateBus, ~radiopattern_buses[0].index, \startposBus, ~radiopattern_buses[1].index,
					\durBus,~radiopattern_buses[2].index,
		\overlapBus, ~radiopattern_buses[3].index, \out, 0 ],~grainbufGroup);
	~radiopattern_buses[2].get{|item| wait_time = (item * ~radiotone.numFrames) / s.sampleRate; };
	0.05.wait;
	wait_time.wait;
	};

}; }).play;

~pattern_routine.stop;

~radiopattern_buses[1].set(0.001);
~radiopattern_buses[2].set(0.025);
~radiopattern_buses[3].set(0.01);



Bus