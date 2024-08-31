/**
Four custom flex sensors
addresses: 0x48 0x49 0x4A 0x4B
(C) 2014 Sjoerd Leijten
**/

s = Server.default;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
s.options.numDigitalChannels = 16;
s.options.maxLogins = 8;

s.options.pgaGainLeft = 5;     // sets the pregain for the left audio input (dB)
s.options.pgaGainRight = 5;    // sets the pregain for the right audio input (dB)
s.options.headphoneLevel = -1; // sets the headphone level (-dB)
s.options.speakerMuted = 0;    // set true to mute the speaker amp and draw a little less power
s.options.dacLevel = 0;       // sets the gain of the stereo audio dac (+dB)
s.options.adcLevel = 0;       // sets the gain of the stereo audio adc (+dB)

s.options.blockSize = 16;
s.options.numInputBusChannels = 10;
s.options.numOutputBusChannels = 2;


s.waitForBoot {
	SynthDef(\flex_reader1, {|t_recalibrate=0.0 i2c_addr=0x48 osc_tag|
		var i2c_bus = 1;
		var noiseThreshold = 0.02; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity.
		// 4 is the best option for Flex.
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var out, ping;
		// returns an array with format: [num_active_touches, t1_pos, t1_size, t2_pos, t2_size, t3_pos, t3_size, t4_pos, t4_size, t5_pos, t5_size]
		centroids = TrillCentroids.kr(i2c_bus, i2c_addr, noiseThreshold, prescalerOpt, t_recalibrate);
		SendReply.kr(Impulse.kr(10), "/flex1" , centroids);
	}).add;
	SynthDef(\flex_reader2, {|t_recalibrate=0.0 i2c_addr=0x49 osc_tag|
		var i2c_bus = 1;
		var noiseThreshold = 0.02; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity.
		// 4 is the best option for Flex.
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var out, ping;
		// returns an array with format: [num_active_touches, t1_pos, t1_size, t2_pos, t2_size, t3_pos, t3_size, t4_pos, t4_size, t5_pos, t5_size]
		centroids = TrillCentroids.kr(i2c_bus, i2c_addr, noiseThreshold, prescalerOpt, t_recalibrate);
		SendReply.kr(Impulse.kr(10), "/flex2" , centroids);
	}).add;

	SynthDef(\flex_reader3, {|t_recalibrate=0.0 i2c_addr=0x4A osc_tag|
		var i2c_bus = 1;
		var noiseThreshold = 0.02; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity.
		// 4 is the best option for Flex.
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var out, ping;
		// returns an array with format: [num_active_touches, t1_pos, t1_size, t2_pos, t2_size, t3_pos, t3_size, t4_pos, t4_size, t5_pos, t5_size]
		centroids = TrillCentroids.kr(i2c_bus, i2c_addr, noiseThreshold, prescalerOpt, t_recalibrate);
		SendReply.kr(Impulse.kr(10), "/flex3" , centroids);
	}).add;

	SynthDef(\flex_reader4, {|t_recalibrate=0.0 i2c_addr=0x4B osc_tag|
		var i2c_bus = 1;
		var noiseThreshold = 0.02; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity.
		// 4 is the best option for Flex.
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var out, ping;
		// returns an array with format: [num_active_touches, t1_pos, t1_size, t2_pos, t2_size, t3_pos, t3_size, t4_pos, t4_size, t5_pos, t5_size]
		centroids = TrillCentroids.kr(i2c_bus, i2c_addr, noiseThreshold, prescalerOpt, t_recalibrate);
		SendReply.kr(Impulse.kr(10), "/flex4" , centroids);
	}).add;

	SynthDef(\radio_sampler, {|out=0 amp=0.5 bufnum rateBus envbuf dur=0.1 pos=0 release=0.5|
		var env, sig, rate;
		rate = In.kr(rateBus, 1);
		env = Osc1.ar(envbuf, dur);
		//env = EnvGen.ar(Env.perc(dur*0.5, dur*0.5),1, doneAction: 2);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.ir(bufnum) * pos,loop: 1);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).add;


	   ~radio_groups = Array.fill(4, { Group.new });
	   ~radio_files = "~/radiosamples/*.wav".pathMatch;
	   ~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });
		~radio_files.postln;
		~radio_samples.postln;
		2.wait;


	~env_buf = Buffer.sendCollection(s, Env.perc.discretize, 1);

	s.sync;
	  ~flex1 = Synth(\flex_reader1,[\i2c_addr, 0x48, \osc_tag, "/flex1" ]);
	  ~flex2 = Synth(\flex_reader2,[\i2c_addr, 0x49, \osc_tag, "/flex2"  ]);
	  ~flex3 = Synth(\flex_reader3,[\i2c_addr, 0x4A, \osc_tag, "/flex3"  ]);
	  ~flex4 = Synth(\flex_reader4,[\i2c_addr, 0x4B, \osc_tag, "/flex4"  ]);

	~sampler_state1 = \off;
	~sampler_state2 = \off;
	~sampler_state3 = \off;
	~sampler_state4 = \off;

	~rateBuses = Array.fill(4, { Bus.control(s, 1).set(1) });

	~rateSpec = [1,0.1, \linear, 0.01].asSpec;

	OSCdef(\flex1, {|msg|

		~rateBuses[0].set(~rateSpec.map(msg[4]));

		if ( (msg[3] > 0 and: ~sampler_state1 == \off), {
			"grainroutine on".postln;
			~grain_routine1 = Routine({ inf.do{ var dur = rrand(0.2, 0.4), overlap = rrand(1.0, 1.4);
	Synth(\radio_sampler, [\out,0, \rateBus, ~rateBuses[0].index, \amp, dur.reciprocal, \envbuf, ~envbuf, \bufnum, ~radio_samples[0],\rate, 1, \dur, dur, \pos, 0, \release, overlap]);
	dur.wait; } }).play;

			~sampler_state1 = \on;
		});

		if ( (msg[3] == 0 and: ~sampler_state1 == \on), {
				"grainroutine off".postln;
			~grain_routine1.stop;
			~sampler_state1 = \off; });

		//22.do{|i| if ( msg[i+3] > 0.0, { ("flex 1 : "++msg[3..]).postln; }); };
	}, "/flex1");

	OSCdef(\flex2, {|msg|

			~rateBuses[1].set(~rateSpec.map(msg[4]));

			if ( (msg[3] > 0 and: ~sampler_state2 == \off), {

			~grain_routine2 = Routine({ inf.do{ var dur = rrand(0.1, 0.11), overlap = rrand(1.0, 1.4);
	Synth(\radio_sampler, [\amp, dur.reciprocal,\rateBus, ~rateBuses[1].index, \envbuf, ~envbuf, \bufnum, ~radio_samples[1],\rate, 1, \dur, dur, \pos, 0, \release, overlap]);
	dur.wait; } }).play;

			~sampler_state2 = \on;
		});

		if ( (msg[3] == 0 and: ~sampler_state2 == \on), {
			~grain_routine2.stop;
			~sampler_state2 = \off; });

		22.do{|i| if ( msg[i+3] > 0.0, { ("flex 2 : "++msg[3..]).postln; }); };
	}, "/flex2");

	OSCdef(\flex3, {|msg|
			~rateBuses[2].set(~rateSpec.map(msg[4]));

		if ( (msg[3] > 0 and: ~sampler_state3 == \off), {

			~grain_routine3 = Routine({ inf.do{ var dur = rrand(0.1, 0.11), overlap = rrand(1.0, 1.4);
	Synth(\radio_sampler, [\amp, dur.reciprocal,\rateBus, ~rateBuses[2].index, \envbuf, ~envbuf, \bufnum, ~radio_samples[2],\rate, 1, \dur, dur, \pos, 0, \release, overlap]);
	dur.wait; } }).play;

			~sampler_state3 = \on;
		});

		if ( (msg[3] == 0 and: ~sampler_state3 == \on), {
			~grain_routine3.stop;
			~sampler_state3 = \off; });

		22.do{|i| if ( msg[i+3] > 0.0, { ("flex 3 : "++msg[3..]).postln; }); };
	}, "/flex3");

	OSCdef(\flex4, {|msg|
			~rateBuses[3].set(~rateSpec.map(msg[4]));

		if ( (msg[3] > 0 and: ~sampler_state4 == \off), {

			~grain_routine4 = Routine({ inf.do{ var dur = rrand(0.1, 0.11), overlap = rrand(1.0, 1.4);
	Synth(\radio_sampler, [\amp, dur.reciprocal,\rateBus, ~rateBuses[3].index, \envbuf, ~envbuf, \bufnum, ~radio_samples[3],\rate, 1, \dur, dur, \pos, 0, \release, overlap]);
	dur.wait; } }).play;

			~sampler_state4 = \on;
		});

		if ( (msg[3] == 0 and: ~sampler_state4 == \on), {
			~grain_routine4.stop;
			~sampler_state4 = \off; });

		22.do{|i| if ( msg[i+3] > 0.0, { ("flex 4 : "++msg[3..]).postln; }); };
	}, "/flex4");



	// Illustrates how to recalibrate the Trill sensor's baseline value if the touchpad configuration changes
	{
		loop {
			55.wait;
			"Reset baseline in 5s...".postln;
			5.wait;
			"Baseline reset!".postln;
			~flex1.set(\t_recalibrate, 1);
			~flex2.set(\t_recalibrate, 1);
			~flex3.set(\t_recalibrate, 1);
			~flex4.set(\t_recalibrate, 1);
		};
	}.fork;

};