~synthGroup = Group.new;
~effectGroup = Group.after(~synthGroup);


~radio_files = "D:/Samples/radiosamples/richer/*.wav".pathMatch;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });

//~winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
//~winenv = Signal.sineFill( 1024, 1.0/#[ 1, 2, 3, 5, 8, 13, 21, 34, 55 ].scramble ).plot;

~hanning = Signal.hanningWindow(1024);
~hanning_env = Buffer.sendCollection(s, ~hanning, 1);

~hamming = Signal.hammingWindow(1024);
~hamming_env = Buffer.sendCollection(s, ~hamming, 1);


~graineq_bus = Bus.audio(s, 1);

~johnston = Tuning.johnston;

~micro_tuning = Array.fill(30, {|i|
		if ( i < 25 , {
			~johnston.ratios.wrapAt( i ) * 0.5 }, {
			~johnston.ratios.wrapAt( i ) * 1
		});

	});

~micro_tuning_scene2 = Array.fill(30, {|i|
		if ( i < 25 , {
			~johnston.ratios.wrapAt( i ) * 1 }, {
			~johnston.ratios.wrapAt( i ) * 2
		});

	});

//~micro_tuning[25]
/* BUSES */
/* SCENE 0. 0: pitch_grain0 1: pitch_grain1 2: pitch_grain2 3:pitch_grain4  4: startpos 5: looplength */
	~scene2_buses = Array.fill(6, {|i|

		Bus.control(s, 1).set(
			case
		    { i == 0} { ~micro_tuning[23]; }
		    { i == 1 } { ~micro_tuning[25]; }
		    { i == 2 } { ~micro_tuning[27]; }
		    { i == 3 } { ~micro_tuning[29]; }
			{ i == 4 } { 0 }
			{ i == 5 } { 1 }; );
	});

~scene2_buses[0].set(1);

~scene2_buses[4].set(0.25);

~scene2_buses[0].set(~micro_tuning[0]);

~scene2_buses[1].set(~micro_tuning[1]*2);

~scene2_buses[2].set(~micro_tuning[2]*2);

~scene2_buses[3].set(~micro_tuning[3]*2);

~effectGroup.set(\boostfreq, 200);
~effectGroup.set(\cutfreq, 1500);

Synth(\grain_eq, [\in, ~graineq_bus,\rq,0.15,\boostfreq,300,\cutfreq,3000, \out, 0 ],  ~effectGroup, \addToHead );
//~effectGroup.freeAll
SynthDef(\grain_eq, {|out=0 in amp=1 boostfreq=300 cutfreq=800 rq=0.5|
	var sig, in_sig, sigL, sigR;
	in_sig = In.ar(in, 2);
	//in_sig = Compander.ar(in_sig, in_sig, 0.1,1.0,0.1,0.001,0.1,10);
	sigL = BLowPass4.ar(in_sig[0], cutfreq*1.1, rq*1.05, rq.reciprocal*0.1);
	sigL = BPeakEQ.ar(sigL, boostfreq, 0.7, 6, amp);
		//sigL = Compander.ar(sigL, sigL, 0.1,1.0,0.1, 0.001,0.1,5);
	sigR = BLowPass4.ar(in_sig[1], cutfreq*0.9, rq*0.95, rq.reciprocal*0.1);
	sigR = BPeakEQ.ar(sigL, boostfreq, 0.7, 6,amp);
	sig = FreeVerb2.ar(sigL, sigR, 0.1,0.9,0.6);
		//sigR = Compander.ar(sigR, sigR, 0.1,1.0,0.1, 0.001,0.1,5);
	Out.ar(out,sig );
}).store;

SynthDef(\radio_sampler, {|out=0 amp=0.8 bufnum rateBus envbuf dur=0.1 posBus overlap=1|
		var env, sig, rate, pos;
	    rate = In.kr(rateBus, 1);
	    pos = In.kr(posBus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * pos,loop: 0);
	//sig = MidEQ.ar(sig, 1000, 0.1,9);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;

/* locked duration */
~flex_gates = Array.fill(4, { \closed });

/* cool durs: (0.05,0.1) */

~grain_routine = Routine({ inf.do{ var dur = 1, overlap=rrand(1,0.2);
	if ( ~flex_gates[0] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur,
			\rateBus, ~scene2_buses[0].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
	if ( ~flex_gates[1] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur,
			\rateBus, ~scene2_buses[1].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
	if ( ~flex_gates[2] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur,
			\rateBus, ~scene2_buses[2].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
	if ( ~flex_gates[3] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur,
			\rateBus, ~scene2_buses[3].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });

	dur.wait;
}; }).play;

~flex_gates[0] = \open;
~flex_gates[1] = \open;
~flex_gates[2] = \open;
~flex_gates[3] = \open;

~grain_routine.stop;



~grain_routine = Routine({ inf.do{ var dur = rrand(0.05,0.1), overlap=rrand(1,0.2);
	if ( ~flex_gates[0] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[0],\dur,dur,
			\rateBus, ~scene2_buses[0].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
	if ( ~flex_gates[1] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[0],\dur,dur,
			\rateBus, ~scene2_buses[1].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
	if ( ~flex_gates[2] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[0],\dur,dur,
			\rateBus, ~scene2_buses[2].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
	if ( ~flex_gates[3] == \open, {
	Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[0],\dur,dur,
			\rateBus, ~scene2_buses[3].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });

	dur.wait;
}; }).play;

Server.killAll