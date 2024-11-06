 // the default is 8192 which is quite little
s.boot;

s.waitForBoot({

s = Server.default;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
//s.options.maxLogins = 4; // should match the settings on the remote sclang
//s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server

s.options.numDigitalChannels = 16;
s.options.pgaGainLeft = 10;     // sets the gain for the left audio input to 4 dB
s.options.pgaGainRight = 10;    // sets the gain for the left audio input to 5 dB
s.options.headphoneLevel = -6; // sets the headphone level to -6 dB
s.options.speakerMuted = 0;    // enable the speaker amp
s.options.dacLevel = 0;       // sets the gain of the dac to 0 dB
s.options.adcLevel = 0;       // sets the gain of the adc to 0 dB
s.options.numMultiplexChannels = 0; // do not enable multiplexer channels

s.options.blockSize = 16;
// number of audio channels: values greater than 2 will use the first few analog
// channels as audio channels.
// Any additional analog channels will be available through the AnalogIn/Out Ugens
// e.g.:
// s.options.numInputBusChannels = 4;
// means that bus in 0/1 are the audio L/R channels and 2/3 are the analog inputs 0/1
// analog inputs 2-7 will still be available through the AnalogIn Ugen.
s.options.numInputBusChannels = 2; // Use only the L/R audio channels
s.options.numOutputBusChannels = 2; // Use only the L/R audio channels
s.options.memSize = 8192 * 16; // the default is 8192 which is quite little


SynthDef(\trillcraft, {|t_recalibrate=0.0|
		var i2c_bus = 1;
		var i2c_address = 0x30;
		var noiseThreshold = 0.06; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 7; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var out, ping;
		centroids = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		SendReply.kr(Impulse.kr(10), "/craft", centroids);
	}).store;

SynthDef(\trillflex1, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x49;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var rawvals;
		var out, ping;
		centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		//rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_updateTrill);
		SendReply.kr(Impulse.kr(10), "/flex1", centroids);
	}).store;

SynthDef(\trillflex2, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x48;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var rawvals;
		var out, ping;
		centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		//rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_updateTrill);
		SendReply.kr(Impulse.kr(10), "/flex2", centroids);
	}).store;

SynthDef(\trillflex3, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x4B;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var rawvals;
		var out, ping;
		centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		//rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_updateTrill);
		SendReply.kr(Impulse.kr(10), "/flex3", centroids);
	}).store;

SynthDef(\trillflex4, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x4A;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var rawvals;
		var out, ping;
		centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		//rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_updateTrill);
		SendReply.kr(Impulse.kr(10), "/flex4", centroids);
	}).store;


SynthDef(\radio_sampler, {|out=0 amp=0.15 bufnum rateBus envbuf dur=0.1 posBus overlap=1|
		var env, sig, rate, pos;
	    rate = In.kr(rateBus, 1);
	    pos = In.kr(posBus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.ir(bufnum) * pos,loop: 0);
		Out.ar(out, Pan2.ar(sig*env*overlap.reciprocal*amp)); }).store;

SynthDef(\grain_eq, {|out=0 in amp=1 ffreq=800 rq=0.3|
	var in_sig, sigL, sigR;
	in_sig = In.ar(in, 2);
	sigL = BLowPass4.ar(in_sig[0], ffreq*0.9, rq*1.05, rq.reciprocal);
	sigL = BPeakEQ.ar(sigL, 90, 0.5, 5, amp);
		//sigL = Compander.ar(sigL, sigL, 0.1,1.0,0.1, 0.001,0.1,5);
	sigR = BLowPass4.ar(in_sig[1], ffreq*1.05, rq*0.95, rq.reciprocal);
	sigR = BPeakEQ.ar(sigL, 110, 0.5, 5,amp);
		//sigR = Compander.ar(sigR, sigR, 0.1,1.0,0.1, 0.001,0.1,5);
	Out.ar(out, [ sigL, sigR ] );
}).store;

SynthDef(\grainSampler, {|out amp=0.75 posBus durBus rateBus envbuf bufnum gate=1 release=0.01 rate=1|
		var env, sig, pos, dur, trate;
		//env = Osc1.ar(envbuf, 1);
		pos = In.kr(posBus, 1);
		dur = In.kr(durBus, 1);
		rate = In.kr(rateBus, 1);
		env = EnvGen.ar(Env.adsr(0.01, 0.1,1,release), gate, doneAction: 2);
		//env = EnvGen.ar(Env.perc(0.001,release), 1, doneAction: 2);
		//env = Osc1.ar(envbuf, 1);
		//sig = GrainBuf.ar(1, Impulse.ar(trate), dur, bufnum, BufRateScale.kr(bufnum)*rate, BufFrames.ir(bufnum)*pos, -1);
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, 1, BufFrames.ir(bufnum)*pos, loop: 1);
		sig = Mix(sig);

		Out.ar(out, sig*env*amp ); }).store;

SynthDef(\buf_grain, { |out, gate = 1, ampBus, rateBus, trateBus,durBus,sndbuf,posBus,envbuf|
    var sig, pan, env, freqdev, rate, trate, dur, pos, amp;
	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);
		amp = In.kr(ampBus, 1);

	pan = SinOsc.kr(LFNoise1.kr(0.4).range(13.0,50.0)).range(-1.0,1.0);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
	sig = GrainBuf.ar(2, Impulse.kr(trate), dur, sndbuf,
				LFNoise1.kr.range(0.4).range(0.99, 1.01) * rate * BufRateScale.kr(sndbuf),
					BufFrames.ir(sndbuf) * pos, 2, pan, envbuf);
    Out.ar(out, sig * amp * 1.75 * env);
}).store;

SynthDef(\recorder, {|in=0 fftbuf recbuf thresh=0.3|
var input = SoundIn.ar(in);
var chain = FFT(fftbuf, input);
var onsets = Onsets.kr(chain,thresh);
//input = Compander.ar(input, input, 0.01,1,0.01,0.005,0.1,25);
//amplitude.poll;
	RecordBuf.ar(input, recbuf,loop:0,trigger:onsets);
 }).store;

SynthDef(\combc, {|in out=0 delmod=0.001 dec=8 mix=0.4|
		var sig,delsig;
		sig = In.ar(in, 1);

		delsig = sig;
		3.do{|i|
			n = (i + 1) * 0.1;
			o = (i + 1) * 0.01;
			e = (i + 1) * 0.1;
			delsig = CombC.ar(sig, 0.2, SinOsc.kr(delmod+o).range(0.01, n), e + dec, 0.3, delsig*0.7);
		};

		sig = (delsig * mix) + (sig * ( 1 - mix) );

		//sig = LPF.ar(sig, 800);
		Out.ar(out, sig!2 ); }).add;

SynthDef(\allpassc, {|in out=0 delmod=0.001 dec=8 mix=0.4|
		var sig,delsig;
		sig = In.ar(in, 1);

		delsig = sig;
		3.do{|i|
			n = (i + 1) * 0.1;
			o = (i + 1) * 0.01;
			e = (i + 1) * 0.1;

			delsig = AllpassC.ar(sig, 0.2, SinOsc.kr(delmod+o).range(0.01, n), e + dec, 1, delsig*0.9);
		};

		sig = (delsig * mix) + (sig * ( 1 - mix) );

		//sig = LPF.ar(sig, 800);
		Out.ar(out, sig!2 ); }).add;

SynthDef(\stereo_verb, {|in out=0 mix=0.0|
		var sig,delsig;
		sig = In.ar(in, 2);
		sig = FreeVerb2.ar(sig[0], sig[1], mix, 0.9, 0.6);
		Out.ar(out, sig); }).add;


3.wait;


~grain_clock = TempoClock.new(1);
~grain_rhythms = [0.1,0.1,0.2,0.3,0.5,0.3,0.2];
~grain_pitches = [0.1,0.1,0.2,0.3,0.5,0.3,0.2];

//~grain_pitches = ~grain_pitches.scramble;
//~grain_rhythms = ~grain_rhythms.scramble;
~grain_pos = 0.1;
~grain_rate = 1;
~grainPosBus = Array.fill(4, {  Bus.control(s, 1).set(0.25); });
~grainpitchBus = Array.fill(4, { Bus.control(s, 1).set(1); });
~overlapBus = Bus.control(s, 1).set(0.5);


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

/*41 tones per octave */
t = ScalaTunings.at('partch_41comb');
~partch_41comb = Tuning.partch_41comb;

fork{
var sc = ~partch_41comb;

~partch_41comb_ratios = Array.fill(287, {|i|
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
/* 22 tones per octave */
t = ScalaTunings.at('paulsmagic');
~pauls_magic = Tuning.paulsmagic;

fork{
var sc = ~pauls_magic;

~pauls_magic_ratios = Array.fill(154, {|i|
	var octave = i / 22;
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

/* 15 tones per octave */
t = ScalaTunings.at('pepper_sonic15');
~pepper_sonic15 = Tuning.pepper_sonic15;

fork{
var sc = ~pepper_sonic15;

~pepper_sonic15_ratios = Array.fill(105, {|i|
	var octave = i / 15;
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

/* 11 tones per octave */
t = ScalaTunings.at('pentatriad');
~pentatriad = Tuning.pentatriad;

fork{
var sc = ~pentatriad;

~pentatriad_ratios = Array.fill(77, {|i|
	var octave = i / 11;
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

/* 9 tones per octave */
t = ScalaTunings.at('pentatetra2');
~pentatetra2 = Tuning.pentatetra2;

fork{
var sc = ~pentatetra2;

~pentatetra2_ratios = Array.fill(63, {|i|
	var octave = i / 9;
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

		2.0.wait;
/*for selecting scale */
~scale_array = [ ~partch_41comb_ratios, ~pauls_magic_ratios,~pepper_sonic15_ratios,~pentatriad_ratios, ~pentatetra2_ratios];
~tone_collection = ~scale_array[0];
~partch_tuning_specs = [287, 0, -4, 1].asSpec;

/*FLEX SYNTHS */
~trill_flx = Synth(\trillflex1);
~trill_flx2 = Synth(\trillflex2);
~trill_flx3 = Synth(\trillflex3);
~trill_flx4 = Synth(\trillflex4);

2.0.wait;


/* BUFFERS*/

~radio_files = "~/radiosamples/*.wav".pathMatch;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });

~craft_fftbuf_left = Buffer.alloc(s, 512);
~craft_fftbuf_right = Buffer.alloc(s, 512);

5.0.wait;

/*GROUPS AND BUSES */
~synthGroup = Group.new;
~grainbufGroup = Group.new(~synthGroup);
~grainbufGroup2 = Group.new(~synthGroup);
~grainbufGroup3 = Group.new(~synthGroup);
~grainbufGroup4 = Group.new(~synthGroup);
~craftGroups = Array.fill(16, { Group.new(~synthGroup); });
~effectGroup = Group.after(~synthGroup);

~grain_group = Group.new(~synthGroup);
~graineq_group = Group.before(~effect_group);
~graineq_bus = Bus.audio(s, 2);

~nyquist = s.sampleRate * 0.5;

~combBus = Bus.audio(s, 1);
~allpassBus = Bus.audio(s, 1);
~verbBus = Bus.audio(s, 2);

~clocks = Array.fill(4, { TempoClock.new(1); });

~clockSpec = [0.125, 3.0, \exp].asSpec;
~lengthSpec = [0.999,0.01,\exp].asSpec;
~endSpec = [0.999,0.0001,\exp].asSpec;
~ampSpec = [0.15,6.0,-15].asSpec;
~octaveSpec = [0.0625,3.0,\exp, 0.0625,1].asSpec;
~relSpec = [0.1,0.5,\linear].asSpec;
~freqSpec = [10.0,300.0,\linear].asSpec;

~ampBuses = Array.fill(8, { Bus.control(s, 1).set(1.0); });
~ampBus = Array.fill(2, {  Bus.control(s,1).set(0.001); });


~octaveBus = Bus.control(s, 1).set(1);

~durBus = Bus.control(s, 1).set(0.25);
~trateBus = Bus.control(s, 1).set(80);

~sine = Env.sine.discretize(1024).putLast(0);
~sineEnv = Buffer.sendCollection(s, ~sine, 1);

~samNum1 = 0;
~samNum2 = 0;

~rec_gate = 0;
~comb_gate = 0;

~button_gates = Array.fill(16 , { 0 } );
~posBus = Array.fill(16, {|i| Bus.control(s, 1).set(i*0.125); });
~rateBus = Array.fill(16, {|i| Bus.control(s, 1).set(1); });

~comb_synth = Synth(\combc, [\in, ~combBus, \mix, 0.0 ], ~effectGroup,\addToTail);
~allpass_synth = Synth(\allpassc, [\in, ~allpassBus, \mix, 0.0 ], ~effectGroup,\addToTail);
~stereoverb_synth = Synth(\stereo_verb, [\in, ~verbBus, \mix, 0.0], ~effectGroup, \addToTail);
Synth(\grain_eq, [\in, ~graineq_bus,\rq,0.05,\ffreq,1500, \out, ~verbBus ],  ~effectGroup, \addToHead );

~tone_col_sel_spec = [0, 4, \linear, 1].asSpec;
~tune_specs = [ [287, 0, -4, 1].asSpec, [154, 0, -4, 1].asSpec,[105, 0, -4, 1].asSpec, [77, 0, -4, 1].asSpec, [63, 0, -4, 1].asSpec; ];

~tuner = ~tune_specs[0];
~tone_col_sel = 0;

~grainbuf_switch = 0;
~grainbuf_switch2 = 0;
~grainbuf_switch3 = 0;
~grainbuf_switch4 = 0;

~winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
~grainbufenv = Buffer.sendCollection(s, ~winenv.discretize, 1);
~env_buf = Buffer.sendCollection(s, Env.perc.discretize, 1);
~trateBus = Array.fill(4, { Bus.control(s, 1).set(10); });
~durBus = Array.fill(4, { Bus.control(s, 1).set(0.25); });
~grainPosBus = Array.fill(4, {  Bus.control(s, 1).set(0.25); });
~grainpitchBus = Array.fill(4, { Bus.control(s, 1).set(1); });
~grainampBus = Array.fill(4, { Bus.control(s, 1).set(0.75); });
~trateSpec = [0.1, 30.0, -4, 0.01].asSpec;
~durSpec = [2.0, 0.01, -4, 0.001].asSpec;
~grainPosSpec = [0.0, 0.9, \linear, 0.001].asSpec;
~grainAmpSpec = [0.75, 10.0, 4, 0.001].asSpec;
~grainclockSpec = [0.5, 15.0, 4, 0.001].asSpec;
~grainoverlapSpec = [1.25, 0.01, 4, 0.001].asSpec;
~graineqSpec = [3000, 200, \linear, 0.001].asSpec;
	~grainrqSpec = [0.4, 0.01, \linear, 0.001].asSpec;

~grainFreezeSwitch = 0;
~grainFreezeSwitch2 = 0;
~grainFreezeSwitch3 = 0;
~grainFreezeSwitch4 =0;

~grainFreeze = 0;
~grainFreeze2 = 0;
~grainFreeze3 = 0;
~grainFreeze4 = 0;

~fingers = \off;
~all_fingers = [0,0,0,0];
~synth_gates = [\off, \off, \off, \off];

~scene = 1;

~grain_clock = TempoClock.new(1);
~grain_rhythms = [0.1,0.1,0.2,0.3,0.5,0.3,0.2];
~grain_rhythms2 = [0.25,0.25,0.5,1.0,2.0,0.125,0.125,0.125,0.125];

~grain_rhythms3 = ~grain_rhythms2.scramble;

~grain_pos = 0.1;
~grain_rate = 1;
~grain_overlap = 0.1;

	~fingerchecker = Routine({ inf.do{
		if ( ( ~all_fingers[0] == 0 ) and: ( ~all_fingers[1] == 0 ) and: ( ~all_fingers[2] == 0 ) and: ( ~all_fingers[3] == 0 ) , {
			~fingers = \off;
			//"no fingers".postln;
			}, { ~fingers = \on;
			//"finger(s) detected".postln;
			});
		if ( ~fingers == \on, {

			if ( ~synth_gates[~scene] == \off, {
				"synth on".postln;
				~synth_gates[~scene] = \on;
				case
					{ ~scene == 0 }
					{
				Synth(\buf_grain, [\sndbuf, ~radio_samples[0], \envbuf, ~grainbufenv,
					\trateBus, ~trateBus[0].index, \durBus,~durBus[0].index,
					\posBus, ~grainPosBus[0].index, \rateBus, ~grainpitchBus[0].index, \ampBus,~grainampBus[0].index, \out, ~verbBus ],~grainbufGroup);
					}
					{ ~scene == 1 }
					{
						~grain_routine1 = Routine({ inf.do{
	7.do{|j| var dur = ~grain_rhythms[j], overlap;

			~overlapBus.get{|i| ~grain_overlap = i; };
							"overlap : ".postln;~grain_overlap.postln;

		//~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(~grain_pitches[j])));

	Synth(\radio_sampler, [\envbuf, ~env_buf, \bufnum, ~radio_samples[2],\rateBus, ~grainpitchBus[0].index,\amp, 0.4, \dur, dur, \posBus, ~grainPosBus[0].index, \overlap, ~grain_overlap,\out, ~graineq_bus ], ~grain_group );
		dur.wait; }; } }).play(~grain_clock);
					}
					{ ~scene == 2 }
					{
						~grain_routine2 = Routine({ inf.do{
	9.do{|j| var dur = ~grain_rhythms2[j], overlap;

			~overlapBus.get{|i| ~grain_overlap = i; };
							"overlap : ".postln;~grain_overlap.postln;

		//~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(~grain_pitches[j])));

	Synth(\radio_sampler, [\envbuf, ~env_buf, \bufnum, ~radio_samples[1],\rateBus, ~grainpitchBus[0].index,\amp, 0.4, \dur, dur, \posBus, ~grainPosBus[0].index, \overlap, ~grain_overlap,\out, ~graineq_bus ], ~grain_group );
		dur.wait; }; } }).play(~grain_clock);
					}
					{ ~scene == 3 }
					{
						~grain_routine3 = Routine({ inf.do{
	9.do{|j| var dur = ~grain_rhythms3[j], overlap;

			~overlapBus.get{|i| ~grain_overlap = i; };
							"overlap : ".postln;~grain_overlap.postln;

		//~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(~grain_pitches[j])));

	Synth(\radio_sampler, [\envbuf, ~env_buf, \bufnum, ~radio_samples[3],\rateBus, ~grainpitchBus[0].index,\amp, 0.4, \dur, dur, \posBus, ~grainPosBus[0].index, \overlap, ~grain_overlap,\out, ~graineq_bus ], ~grain_group );
		dur.wait; }; } }).play(~grain_clock);
					};


			});
		}, {
			if ( ~synth_gates[~scene] == \on, {

				case
				{ ~scene == 0 } {
					~grainbufGroup.set(\gate, 0);    }
				{ ~scene == 1 } { ~grain_routine1.stop; }
                { ~scene == 2 } { ~grain_routine2.stop; }
				{ ~scene == 3 } { ~grain_routine3.stop; };


			"synth off".postln;
			~synth_gates[~scene] = \off;
			});
		});
		0.01.wait; }; }).play;







OSCdef(\trillflex, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			     ~all_fingers.put(0,1);


		     }, { ~all_fingers.put(0,0);    });

			if ( fingers > 1, {


		});
			if ( fingers > 2, {
				~stereoverb_synth.set(\mix, msg[8]); });

			if ( fingers > 3, {
					if ( ~grainFreezeSwitch == 0, {
						if ( ~grainFreeze == 0, {
							~grainFreeze = 1; ~grainFreezeSwitch = 1; "grainfreeze on".postln;

						}, {
							~grainFreeze = 0; ~grainFreezeSwitch = 1; "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
					if ( ~grainFreezeSwitch == 1, { ~grainFreezeSwitch = 0;   });

			});

			//msg.postln;
			if ( ~grainFreeze != 1, {

			if ( x_val > 0.0125, {

				~grain_clock.tempo = ~grainclockSpec.map(x_val).postln;
				~overlapBus.set(~grainoverlapSpec.map(x_val) );

				 ~trateBus[0].set(~trateSpec.map(x_val) );
			     ~durBus[0].set(~durSpec.map(x_val));
			      ~grainampBus[0].set(~grainAmpSpec.map(x_val));
			//if ( y_val > 0.1, {  ~grainampBus[0].set(~grainAmpSpec.map(y_val));  });

			}); });

		}, '/flex');

OSCdef(\trillflex2, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			     ~all_fingers.put(1,1);
		     }, { ~all_fingers.put(1,0);    });

			if ( fingers > 1, {
				~grainPosBus[1].set(~grainPosSpec.map(msg[6]));
				//~grainpitchBus[1].set(~tone_collection.wrapAt(~tuner.map(msg[6])));

			});
			if ( fingers > 2, {
				~stereoverb_synth.set(\mix, msg[8]); });
			if ( fingers > 3, {
					if ( ~grainFreezeSwitch2 == 0, {
						if ( ~grainFreeze2 == 0, {
							~grainFreeze2 = 1; ~grainFreezeSwitch2 = 1; "grainfreeze on".postln;

						}, {
							~grainFreeze2 = 0; ~grainFreezeSwitch2 = 1; "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
					if ( ~grainFreezeSwitch2 == 1, { ~grainFreezeSwitch2 = 0;   });

			});

			//msg.postln;
			if ( ~grainFreeze2 != 1, {

				if ( msg[4] > 0.01, { ~grainPosBus[0].set(~grainPosSpec.map(msg[4].postln; )); 	"pos".postln; })


			});

		}, '/flex2');




OSCdef(\trillflex3, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
				if ( fingers > 0, {
			     ~all_fingers.put(2,1);
		     }, { ~all_fingers.put(2,0);    });
			if ( fingers > 1, {
				~grainPosBus[2].set(~grainPosSpec.map(msg[6]));
			    ~grainpitchBus[2].set(~tone_collection.wrapAt(~tuner.map(msg[6]))); });
			if ( fingers > 2, {
				~stereoverb_synth.set(\mix, msg[8]); });
			if ( fingers > 3, {
					if ( ~grainFreezeSwitch3 == 0, {
						if ( ~grainFreeze3 == 0, {
							~grainFreeze3 = 1; ~grainFreezeSwitch3 = 1; "grainfreeze on".postln;

						}, {
							~grainFreeze3 = 0; ~grainFreezeSwitch3 = 1; "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
					if ( ~grainFreezeSwitch3 == 1, { ~grainFreezeSwitch3 = 0;   });

			});

			//msg.postln;
			if ( ~grainFreeze3 != 1, {
				if ( msg[4] > 0.05, {

				case
				{ ~scene == 0 }
				{
					//~grainpitchBus[0].set(~tone_collection.wrapAt(~tuner.map(msg[4])));

				}
				{ ~scene == 1 }
				{

					"pitch".postln;
					if ( msg[4] > 0.01, {
				     ~grainpitchBus[0].set(~partch_tuning.wrapAt(~partch_tuning_specs.map(msg[4] )));
					~graineq_group.set(\ffreq, ~graineqSpec.map(msg[4]), \rq, ~grainrqSpec.map(msg[4]));
					});
				};




			})

			});

		}, '/flex3');



OSCdef(\trillflex4, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			     ~all_fingers.put(3,1);
		     }, { ~all_fingers.put(3,0);    });

			if ( fingers > 1, {


		});
			if ( fingers > 2, {
				~stereoverb_synth.set(\mix, msg[8]); });
			if ( fingers > 3, {
					if ( ~grainFreezeSwitch4 == 0, {
						if ( ~grainFreeze4 == 0, {
							~grainFreeze4 = 1; ~grainFreezeSwitch4 = 1; "grainfreeze on".postln;

						}, {
							~grainFreeze4 = 0; ~grainFreezeSwitch4 = 1; "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
					if ( ~grainFreezeSwitch4 == 1, { ~grainFreezeSwitch4 = 0;   });

			});

			//msg.postln;
			if ( ~grainFreeze4 != 1, {
				if ( msg[4] > 0.01, { 	~stereoverb_synth.set(\mix, msg[4]); "verb".postln;       })

			});

		}, '/flex4');


	~prev_scene = 3;

	~sceneRoutine = Routine({ inf.do{
		            4.do{|i| ~scene = i;
			               if ( ~synth_gates[~prev_scene] == \on, {
				             case
				{ ~prev_scene == 0 } { ~grainbufGroup.set(\gate, 0);     }
				{ ~prev_scene == 1 } { ~grain_routine1.stop;   }
				{ ~prev_scene == 2 } {  ~grain_routine2.stop;  }
				{ ~prev_scene == 3 } {  ~grain_routine3.stop;  };
				~synth_gates[~prev_scene] = \off;
			                       });
			                 ("scene : "++~scene).postln;

			         case
			{ ~scene == 1 } { ~grain_rhythms = ~grain_rhythms.scramble; ~partch_tuning = ~partch_tuning.scramble;
 }
			{ ~scene == 2 } { ~grain_rhythms2 = ~grain_rhythms2.scramble; ~partch_tuning = ~partch_tuning.scramble;
}
			{ ~scene == 3 } { ~grain_rhythms3 = ~grain_rhythms2.scramble; ~partch_tuning = ~partch_tuning.scramble;
};

			60.wait;
			~prev_scene = ~scene;
	}; }; }).play;





/* CRAFT SYNTH */
~trill_craft = Synth(\trillcraft);

OSCdef(\craft_osc, {|msg| var button1, button2;
			//msg.postln;

		    button1 = msg[11+3];
			button2 = msg[18+3];

		    if ( button1 != 0, {
			("button 1: "++button1).postln;     });

		    if ( button2 != 0, {
			("button 2: "++button2).postln;     });



			}, '/craft');


});









