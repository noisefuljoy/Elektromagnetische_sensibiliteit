/* pitch / rhythmic sequences */
/* sequence + drone combi ? */

s = Server.local;

~radio_files = "D:/Samples/radiosamples/*.wav".pathMatch;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });
~env_buf = Buffer.sendCollection(s, Env.perc.discretize, 1);
v = Signal.sineFill( 1024, 1.0/#[ 1, 2, 3, 5, 8, 13, 21, 34, 55 ].scramble );
t = Signal.sineFill( 1024, 1.0/#[ 1, 2, 3, 5, 8, 13, 21, 34, 55 ].scramble );
t.put(t.size-1, 0);
v.put(v.size-1, 0);
~sine_env = Buffer.sendCollection(s, t, 1);

SynthDef(\radio_sampler, {|out=0 amp=1 bufnum rateBus envbuf dur=0.1 posBus overlap=1|
		var env, sig, rate, pos;
	    rate = In.kr(rateBus, 1);
	    pos = In.kr(posBus, 1);
	    //overlap = In.kr(overlapBus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.ir(bufnum) * pos,loop: 1);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;

SynthDef(\grain_eq, {|out=0 in amp=1 ffreq=800 rq=0.3|
	var in_sig, sigL, sigR;
	in_sig = In.ar(in, 2);
	sigL = BLowPass4.ar(in_sig[0], ffreq*0.9, rq*1.05, rq.reciprocal);
	sigL = BPeakEQ.ar(sigL, 90, 0.5, 5, amp);
	sigR = BLowPass4.ar(in_sig[1], ffreq*1.05, rq*0.95, rq.reciprocal);
	sigR = BPeakEQ.ar(sigL, 110, 0.5, 5,amp);
	Out.ar(out, [ sigL, sigR ] );
}).store;


~grain_group = Group.new;
~graineq_group = Group.after(~grain_group);
~graineq_bus = Bus.audio(s, 2);


~grain_clock = TempoClock.new(1);
~grain_rhythms = [0.1,0.1,0.2,0.3,0.5,0.3,0.2];
~grain_pitches = [0.1,0.1,0.2,0.3,0.5,0.3,0.2];

~grain_rhythms2 = Array.linrand(30, 0.025,0.5);
~grain_pitches2 = Array.linrand(30, 0, 287);
~grain_pitches2 = ~grain_pitches2.scramble;


~grain_pitches = ~grain_pitches.scramble;
~grain_rhythms = ~grain_rhythms.scramble;
~partch_tuning = ~partch_tuning.scramble;

~grain_pos = 0.1;
~grain_rate = 1;
~grainPosBus = Array.fill(4, {  Bus.control(s, 1).set(0.25); });
~grainpitchBus = Array.fill(4, { Bus.control(s, 1).set(1); });
~overlapBus = Bus.control(s, 1).set(0.5);

~grainPosBus[0].set(0.15);

~grainpitchBus[0].set(0.1);

fork{ var overlapratio = 0.7;
~overlapBus.set(overlapratio);
~graineq_group.set(\amp, overlapratio.reciprocal);
};


t = ScalaTunings.at('partch_41comb');
~partch_41comb = Tuning.partch_41comb;

fork{
var sc = ~partch_41comb;

~partch_tuning = Array.fill(287, {|i|
	var octave = i / 41;
	case
	{ octave < 1; } { sc.ratios.wrapAt(i) * 0.25 }
	{ ((octave == 1) or: (octave > 1)) and: (octave < 2) } { sc.ratios.wrapAt(i) * 0.5 }
	{ ((octave == 2) or: (octave > 2)) and: (octave < 3)  } { sc.ratios.wrapAt(i) * 1  }
	{ ((octave == 3) or: (octave > 3)) and: (octave < 4)  } { sc.ratios.wrapAt(i) * 2 }
	{ ((octave == 4) or: (octave > 4)) and: (octave < 5)  } { sc.ratios.wrapAt(i) * 4 }
	{ ((octave == 5) or: (octave > 5)) and: (octave < 6)  } { sc.ratios.wrapAt(i) * 8 }
	{ ((octave == 6) or: (octave > 6)) and: (octave < 7)  } { sc.ratios.wrapAt(i) * 16 }
});
};

~partch_tuning_specs = [287, 0, -4, 1].asSpec;
//~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(msg[6])));
~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(0.15)));



Synth(\grain_eq, [\in, ~graineq_bus,\rq,0.1,\ffreq,750, \out, 0],  ~graineq_group );
~graineq_group.set(\rq, 0.15);
~graineq_group.set(\ffreq, 900);
~graineq_group.freeAll

	~grain_routine = Routine({ inf.do{
	7.do{|j| var dur = ~grain_rhythms[j];
		~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(~grain_pitches[j])));
	Synth(\radio_sampler, [\envbuf, ~envbuf, \bufnum, ~radio_samples[2],\rateBus, ~grainpitchBus[0].index, \dur, dur, \posBus, ~grainPosBus[0].index, \overlap, 1,\out, ~graineq_bus ], ~grain_group );
		dur.wait; }; } }).play(~grain_clock);

	~grain_routine2 = Routine({ inf.do{
	30.do{|j| var dur = ~grain_rhythms2[j];
		~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(~grain_pitches2[j])));
		Synth(\radio_sampler, [\envbuf, ~sine_env, \amp,0.2,\bufnum, ~radio_samples[2],\rateBus, ~grainpitchBus[0].index, \dur, dur, \posBus, ~grainPosBus[0].index, \overlap, 1,\out, ~graineq_bus ], ~grain_group );
		dur.wait; }; } }).play(~grain_clock);






~grain_clock.tempo = 0.5;
~grain_routine.stop;
~grain_routine2.stop;
