

/*
- compose transition sounds to go from one scene to the other
- compose microtonal patterns that are transposable
- 2 patterns interplay with two flexes and one parameter flex
- use one button for pattern scramble
- velocity aan de hand van drukvoltage

*/

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

//s.options.belaMaxScopeChannels = 8;
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


SynthDef(\transition_sound,{|out amp=0.125 attack=0.01 release=0.01 bufnum rate=1 gate=1 gen_index=0.3 cutfreq=4000|

					var env = EnvGen.ar(Env.adsr(attack,0.0,1,release,curve: 3.0),gate,doneAction:2);
					var vib = Gendy1.kr(1,1,1,1,0.1, 10.0,mul:gen_index,add:1);


					var sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate * vib, 0, 0,1) * 1;
		sig = RHPF.ar(sig, cutfreq, 0.9 );
		Out.ar(out, Pan2.ar(sig * env,LFNoise0.kr(6.4).range(-1.0,1.0) ));
				}).store;
SynthDef(\transition_sound_low,{|out amp=0.125 attack=0.01 release=0.01 bufnum rate=1 gate=1 gen_index=0.3 cutfreq=4000|

					var env = EnvGen.ar(Env.adsr(attack,0.0,1,release,curve: 3.0),gate,doneAction:2);
					var vib = Gendy1.kr(1,1,1,1,0.01, 15.0,mul:gen_index,add:1);


					var sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate * vib, 0, 0,1) * 1;
		sig = RLPF.ar(sig, cutfreq, 0.9 );
		Out.ar(out, Pan2.ar(sig * env,LFNoise0.kr(6.4).range(-1.0,1.0) ));
				}).store;

/*
SynthDef(\transition_sound, {|out=0 amp=0.125 bufnum attack=12.0 release=10.0 gate=1|
	var env, mod, freq, ampMod, sig;
	env = EnvGen.ar(Env.adsr(attack, 0.0, 1.0, release, curve: 1.0), gate, doneAction: 2);
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * Gendy1.ar(
	// src * LFPulse.ar(10);
	Out.ar(out, Pan2.ar(sig*env*amp));

}).store;
*/

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

/* SET PRESCALER TO 5 TO FIX DEAD ZONES ON FLEX */
SynthDef(\trillflex1, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x49;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 5; // int: 1-8 with 1 being the highest sensitivity
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


SynthDef(\radio_looper, {|out=0 amp=0.25 bufnum rate=1 envbuf startpos=0 looprange=0.25 overlap=0 t_trig=0 gate=1|
		var sig1_OR_sig2, sig1,sig2,start1,start2,phasor1,phasor2,end1,end2,
	    kill_env, env, frames,endpos, dur, crossfade;
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
	    //env = EnvGen.ar(Env.new([0,1,1,0],[0,dur,0]),t_trig);
		kill_env = EnvGen.ar(Env.adsr(0.01,0.0,1,0.01),gate, doneAction: 2);
		env = EnvGen.ar(Env.linen(dur*0.1,dur*0.99,dur*0.01+(dur*overlap) ),t_trig);
	    //env = EnvGen.ar(Env.perc(dur*0.01,dur*0.99),t_trig);
		phasor1 = Phasor.ar(sig1_OR_sig2, rate, start1*frames,end1*frames+(overlap*frames), start1*frames );
	    phasor2 = Phasor.ar(1 - sig1_OR_sig2, rate, start2*frames,end2*frames+(overlap*frames), start2*frames );
		//sigenv = EnvGen.ar(Env.linen(0.1*dur,0.8*dur,0.1*dur),\trig.tr(1));
		sig1 = BufRd.ar(1, bufnum, phasor1, interpolation: 1);
	    sig2 = BufRd.ar(1, bufnum, phasor2, interpolation: 1);
	Out.ar(out, Pan2.ar( (crossfade*sig1) + ( ( 1 - crossfade ) * sig2) * env * kill_env * amp) );
	    }).store;

/*
SynthDef(\radio_sampler, {|out=0 amp=0.15 bufnum rateBus envbuf dur=0.1 posBus overlap=1|
		var env, sig, rate, pos;
	    rate = In.kr(rateBus, 1);
	    pos = In.kr(posBus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.ir(bufnum) * pos,loop: 0);
		Out.ar(out, Pan2.ar(sig*env*overlap.reciprocal*amp)); }).store;
*/
SynthDef(\radio_sampler, {|out=0 amp=0.2 bufnum rateBus envbuf dur=0.1 posBus overlap=1|
		var env, sig, rate, pos;
	    rate = In.kr(rateBus, 1);
	    pos = In.kr(posBus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * pos,loop: 0);
	//sig = MidEQ.ar(sig, 1000, 0.1,9);
		Out.ar(out, Pan2.ar(sig*env*amp)); }).store;


SynthDef(\grain_eq, {|out=0 in amp=1 ffreq=800 rq=0.3|
	var in_sig, sigL, sigR;
	in_sig = In.ar(in, 2);
	//in_sig = Compander.ar(in_sig, in_sig, 0.1,1.0,0.1,0.001,0.1,10);
	sigL = BLowPass4.ar(in_sig[0], ffreq*0.9, rq*1.05, rq.reciprocal*0.6);
	sigL = BPeakEQ.ar(sigL, 90, 0.5, 5, amp);
		//sigL = Compander.ar(sigL, sigL, 0.1,1.0,0.1, 0.001,0.1,5);
	sigR = BLowPass4.ar(in_sig[1], ffreq*1.05, rq*0.95, rq.reciprocal*0.6);
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
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, 1, BufFrames.kr(bufnum)*pos, loop: 1);
		sig = Mix(sig);

		Out.ar(out, sig*env*amp ); }).store;




SynthDef(\buf_grain, { |out, gate = 1, gen_index_bus,  ampBus, rateBus, trateBus,durBus,bufnum,posBus,envbuf|
    var vib, sig, pan, env, freqdev, rate, trate, dur, pos, amp, gen_index;
	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);
	amp = In.kr(ampBus, 1);
	gen_index = In.kr(gen_index_bus, 1);
	//gen_index.poll;

    vib = Gendy1.kr(1,1,1,1,0.125, 8,mul:gen_index,add:1);
	vib.poll;
    rate = rate * vib;
	rate.poll;


    env = EnvGen.kr(
        Env([0, 1, 0], [1, 0.01], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
	sig = GrainBuf.ar(2, Impulse.kr(trate), dur, bufnum, rate * BufRateScale.kr(bufnum),
					BufFrames.kr(bufnum) * pos, 2, 0, envbuf);
    Out.ar(out, sig * amp * 2 * env);
}).store;

SynthDef(\buf_grain_double, { |out, gate = 1, gen_index_bus, ampBus, mainAmp=1 rateBus, trateBus,durBus,bufnum,posBus,envbuf|
    var vib,sig, pan, env, freqdev, rate, trate, dur, pos, amp, gen_index;
	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);
	amp = In.kr(ampBus, 1);
	gen_index = In.kr(gen_index_bus, 1);

	 vib = Gendy1.kr(1,2,1,1,0.0625, 1,mul:gen_index,add:1);
	rate = rate * vib;

    env = EnvGen.kr(
        Env([0, 1, 0], [1, 0.01], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
		sig = GrainBuf.ar(2, Impulse.kr(trate), dur*SinOsc.kr(LFNoise0.kr(0.8)).range(1.0,1.4), bufnum, rate * 0.5 * BufRateScale.kr(bufnum),
					BufFrames.kr(bufnum) * pos, 2, 0, envbuf);
    Out.ar(out, sig * amp * mainAmp * env);
}).store;

SynthDef(\buf_grain_double_high, { |out, gate = 1, gen_index_bus, ampBus, mainAmp=1 rateBus, trateBus,durBus,bufnum,posBus,envbuf|
    var vib, sig, pan, env, freqdev, rate, trate, dur, pos, amp, gen_index;

	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);
	amp = In.kr(ampBus, 1);
	gen_index = In.kr(gen_index_bus, 1);

	vib = Gendy1.kr(1,1,1,1,0.5, 20.0,mul:gen_index,add:1);
    rate = rate * vib;
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 0.01], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
		sig = GrainBuf.ar(2, Impulse.kr(trate), dur*SinOsc.kr(LFNoise0.kr(3.2)).range(0.25,0.9), bufnum, rate * 2 * BufRateScale.kr(bufnum),
					BufFrames.kr(bufnum) * pos, 2, 0, envbuf);
    Out.ar(out, sig * amp * mainAmp * env);
}).store;



SynthDef(\recorder, {|in=0 fftbuf recbuf thresh=0.3|
var input = SoundIn.ar(in);
var chain = FFT(fftbuf, input);
var onsets = Onsets.kr(chain,thresh);
//input = Compander.ar(input, input, 0.01,1,0.01,0.005,0.1,25);
//amplitude.poll;
	RecordBuf.ar(input, recbuf,loop:0,trigger:onsets);
 }).store;

SynthDef(\combc, {|in out=0 delmod=0.001 dec=8 mix=0.05|
		var sig,delsig;
		sig = In.ar(in, 1);
		//sig = Compander.ar(sig, sig, 0.001,1.0,0.001,0.001,0.1,100);
		delsig = sig;
		3.do{|i|
			n = (i + 1) * 0.1;
			o = (i + 1) * 0.01;
			e = (i + 1) * 0.1;
			delsig = CombC.ar(Decay.ar(delsig, 0.2), 0.2, n, e + dec, 0.3, delsig * 0.7);
			//delsig = CombC.ar(sig, 0.2, SinOsc.kr(delmod+o).range(0.01, n), e + dec, 0.3, delsig*0.7);
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
		sig = Compander.ar(sig, sig, 0.001,1.0,0.001,0.001,0.1,100);
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

~scene0_group = Group.new(~synthGroup);
~scene0doubler_group = Group.new(~synthGroup);

~scene1_group = Group.new(~synthGroup);
~scene1doubler_group = Group.new(~synthGroup);
~scene1doublerhigh_group = Group.new(~synthGroup);

~transition_group = Group.new(~synthGroup);
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
~endposBus = Bus.control(s, 1).set( 1.0 );

~rateBus = Array.fill(16, {|i| Bus.control(s, 1).set(1); });

~comb_synth = Synth(\combc, [\in, ~combBus, \mix, 0.1], ~effectGroup,\addToTail);
~allpass_synth = Synth(\allpassc, [\in, ~allpassBus, \mix, 0.25 ], ~effectGroup,\addToTail);
~stereoverb_synth = Synth(\stereo_verb, [\in, ~verbBus, \mix, 0.15], ~effectGroup, \addToTail);
Synth(\grain_eq, [\in, ~graineq_bus,\rq,0.15,\ffreq,1500, \out, 0 ],  ~effectGroup, \addToHead );

~grainbuf_switch = 0;
~grainbuf_switch2 = 0;
~grainbuf_switch3 = 0;
~grainbuf_switch4 = 0;

~winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
~grainbufenv = Buffer.sendCollection(s, ~winenv.discretize, 1);
~env_buf = Buffer.sendCollection(s, Env.perc.discretize, 1);

~hanning = Signal.hanningWindow(1024);
~hanning_env = Buffer.sendCollection(s, ~hanning, 1);


~trateBus = Array.fill(4, { Bus.control(s, 1).set(10); });
~durBus = Array.fill(4, { Bus.control(s, 1).set(0.25); });

~global_freeze = \off;

~tuning_map = [0, 29, \linear, 1].asSpec;

t = ScalaTunings.at('partch_41comb');
~partch_41comb = Tuning.partch_41comb;

~johnston = Tuning.johnston;

~micro_tuning = Array.fill(30, {|i|
		if ( i < 25 , {
			~johnston.ratios.wrapAt( i ) * 0.5 }, {
			~johnston.ratios.wrapAt( i ) * 1
		});

	});

~micro_tuning_low = Array.fill(30, {|i|
		if ( i < 25 , {
			~johnston.ratios.wrapAt( i ) * 0.125 }, {
			~johnston.ratios.wrapAt( i ) * 0.25
		});

	});


/* BUSES */
/* SCENE 0. 0: pitch 1: startpos 2: looplength 3: overlap 4: rate scene0doubler_group*/
	~scene0_buses = Array.fill(5, {|i|

		Bus.control(s, 1).set(
			case
			{ i == 0} { 1 }
			{ i == 1 } { 0 }
			{ i == 2 } { 1 }
			{ i == 3 } { 0 }
			{ i == 4 } { 0.25 };

		);
	});
/* SCENE 1. 0:pitch 1:pos 2:trate 3:dur 4:overlap 5: rate doubler 6: rate doubler high 7:gendy index   */
	~scene1_buses = Array.fill(8, {|i|
		Bus.control(s, 1).set(
			case
			{ i == 0} { 1 }
			{ i == 1 } { 0 }
			{ i == 2 } { 1 }
		    { i == 3 } { 0.1 }
			{ i == 4 } { 0}
			{ i == 5 } { 0}
			{ i == 6 } { 4}
			{ i == 7 } { 0.0};

		);
	});

/* SCENE 2. 0: pitch_grain0 1: pitch_grain1 2: pitch_grain2 3:pitch_grain4  4: startpos 5: looplength */
	~scene2_buses = Array.fill(6, {|i|
		Bus.control(s, 1).set(
			case
		    { i == 0} { ~micro_tuning[23]; }
		    { i == 1 } { ~micro_tuning[25]; }
		    { i == 2 } { ~micro_tuning[27]; }
		    { i == 3 } { ~micro_tuning[29]; }
			{ i == 4 } { 0.25 }
			{ i == 5 } { 1 }; );
	});


/*specs*/
/* scene 0 */
~startPosSpec = [0.0, 0.75, \linear, 0.001].asSpec;
~looprangeSpec = [0.0175, 0.9, 8, 0.01].asSpec;
~overlapSpec = [0,1.5,9, 0.001].asSpec;


/* scene 1 */
~grainPosBus = Array.fill(4, {  Bus.control(s, 1).set(0.0); });
~grainpitchBus = Array.fill(4, { Bus.control(s, 1).set(1); });
~grainampBus = Array.fill(4, { Bus.control(s, 1).set(0.75); });
//~trateSpec = [0.1, 30.0, \linear, 0.01].asSpec;
~trateSpec = [0.01, 15.0, \linear, 0.01].asSpec;
//~durSpec = [2.0, 0.01, -4, 0.001].asSpec;
~durSpec = [3.0, 0.01, -4, 0.001].asSpec;
~gendy_index_spec = [0.00, 0.1, 2, 0.001].asSpec;


~grainPosSpec = [0.0, 0.9, \linear, 0.001].asSpec;
~grainAmpSpec = [0.75, 1.5, \linear, 0.001].asSpec;
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

~scene = 0;

~grain_clock = TempoClock.new(1);
~grain_rhythms = [0.1,0.1,0.2,0.3,0.5,0.3,0.2];
~grain_rhythms2 = [0.25,0.25,0.5,1.0,2.0,0.125,0.125,0.125,0.125];

~grain_rhythms3 = ~grain_rhythms2.scramble;

~grain_pos = 0.1;
~grain_rate = 1;
~grain_overlap = 0.1;



	/*
~micro_tuning = Array.fill(30, {|i| 0.75 + (i*0.03444) });
//~micro_tuning_low = Array.fill(30, {|i| ( 0.75 + (i*0.03444)) * 0.5;    });
	~micro_tuning_low = [ 0.3, 0.313776, 0.327552, 0.341328, 0.355104, 0.36888, 0.382656, 0.423984, 0.465312, 0.50664, 0.547968, 0.589296, 0.630624, 0.671952, 0.685728, 0.75, 0.78444, 0.81888, 0.85332, 0.88776, 0.9222, 0.95664, 1.05996, 1.16328,  1.2666, 1.36992,  1.47324,  1.57656, 1.67988, 1.71432 ];
*/


fork{
var sc = ~partch_41comb;
~partch_tuning = Array.fill(30, {|i|
	sc.ratios.wrapAt(i) * 1
});
};


~scene0_waittime = 0.1;
~scene0_startpos = 0.0;
~scene0_looprange = 0.25;
~scene0_overlap = 0.0;
~scene0_rate = 1;
	~scene0_doublerate = 1;
	~doubler = \off;
	~doubler_high = \off;

	~flex_gates = Array.fill(4, { \closed });

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
					fork{
						~scene0_buses[0].get{|item| ~scene0_rate = item; };
						~scene0_buses[1].get{|item| ~scene0_startpos = item; };
						~scene0_buses[2].get{|item| ~scene0_looprange = item; };
						~scene0_buses[3].get{|item| ~scene0_overlap = item; };
						~scene0_buses[4].get{|item| ~scene0_doublerate = item; };

						Synth(\radio_looper, [\bufnum, ~radio_samples[0],\amp,0.25,\rate,~scene0_rate, \startpos, ~scene0_startpos,\overlap, ~scene0_overlap,
							\looprange, ~scene0_looprange,\out, ~verbBus ], ~scene0_group);

						Synth(\radio_looper, [\bufnum, ~radio_samples[0],\amp, if ( ~flex_gates[1] == \open, { 0.25 } , { 0 });,
								\rate,~scene0_doublerate, \startpos, ~scene0_startpos,\overlap, ~scene0_overlap,
							\looprange, ~scene0_looprange,\out, ~graineq_bus ], ~scene0doubler_group);

					};

					~scene0_retrig_routine = Routine({inf.do{ var length, break;
						~scene0_buses[0].get{|item| ~scene0_rate = item; };
						~scene0_buses[1].get{|item| ~scene0_startpos = item; };
						~scene0_buses[2].get{|item| ~scene0_looprange = item; };
						~scene0_buses[3].get{|item| ~scene0_overlap = item; };
						~scene0_buses[4].get{|item| ~scene0_doublerate = item; };
                        //("loop_range : "++~scene0_looprange).postln;
						~scene0_group.set(\t_trig, 1, \rate,~scene0_rate,\startpos, ~scene0_startpos, \looprange, ~scene0_looprange,\overlap,~scene0_overlap);

				        ~scene0doubler_group.set(\t_trig, 1, \amp,  if ( ~flex_gates[1] == \open, { 0.25 } , { 0 });,\rate,~scene0_doublerate,\startpos, ~scene0_startpos, \looprange, ~scene0_looprange,\overlap,~scene0_overlap);

				        //length = 0.25;
						length = ( ~scene0_looprange * ~radio_samples[0].numFrames) / 48000;
						break = ( ( ~scene0_overlap * ~radio_samples[0].numFrames) / 48000 ) * 0.5;
						//("overlap : "++~scene0_overlap).postln;
						//("length : "++length).postln;
						(length+break).wait;     }; }).play;

				}
					{ ~scene == 1 }
					{

				Synth(\buf_grain, [\bufnum, ~radio_samples[0], \envbuf, ~hanning_env,
					\trateBus, ~scene1_buses[2].index, \durBus,~scene1_buses[3].index,
					\posBus, ~scene1_buses[1].index, \rateBus, ~scene1_buses[0].index, \ampBus,~scene1_buses[4].index,
						\gen_index_bus, ~scene1_buses[7].index,
						\out, ~allpassBus ],~scene1_group);

					Synth(\buf_grain_double, [\bufnum, ~radio_samples[0], \envbuf, ~hanning_env,
					\trateBus, ~scene1_buses[2].index, \durBus,~scene1_buses[3].index,
						\mainAmp, if ( ~flex_gates[1]  == \open, { 0.5 } , { 0 }); ,
					\posBus, ~scene1_buses[1].index, \rateBus, ~scene1_buses[5].index, \ampBus,~scene1_buses[4].index,
						\gen_index_bus, ~scene1_buses[7].index,
						\out, ~graineq_bus ],~scene1doubler_group);

					Synth(\buf_grain_double_high, [\bufnum, ~radio_samples[2], \envbuf, ~hanning_env,
					\trateBus, ~scene1_buses[2].index, \durBus,~scene1_buses[3].index,
						\mainAmp, if ( ~flex_gates[3] == \open, { 1 } , { 0 }); ,
					\posBus, ~scene1_buses[1].index, \rateBus, ~scene1_buses[6].index, \ampBus,~scene1_buses[4].index,
						\gen_index_bus, ~scene1_buses[7].index,
						\out, ~allpassBus ],~scene1doublerhigh_group);


					~scene1doubler_check = Routine({inf.do{
					    if ( ~flex_gates[1] == \open, { ~scene1doubler_group.set(\mainAmp,0.5);  } , { ~scene1doubler_group.set(\mainAmp,0);  });
						if ( ~flex_gates[3] == \open, { ~scene1doublerhigh_group.set(\mainAmp,1);  } , { ~scene1doublerhigh_group.set(\mainAmp,0);  });

						0.1.wait; }; }).play;


					}
					{ ~scene == 2 }
					{
						~scene2_grain_routine = Routine({ inf.do{ var dur = 1, overlap=rrand(1,0.2);
							if ( ~flex_gates[0] == \open, {
								Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur*0.9,
									\rateBus, ~scene2_buses[0].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
							if ( ~flex_gates[1] == \open, {
								Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur*0.75,
									\rateBus, ~scene2_buses[1].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
							if ( ~flex_gates[2] == \open, {
								Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur*0.6,
									\rateBus, ~scene2_buses[2].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });
							if ( ~flex_gates[3] == \open, {
								Synth(\radio_sampler, [\envbuf, ~hanning_env, \bufnum, ~radio_samples[1],\dur,dur*0.5,
									\rateBus, ~scene2_buses[3].index, \posBus, ~scene2_buses[4].index, \out,0 ], ~synthGroup); });

							dur.wait;
						}; }).play;

					}
					{ ~scene == 3 }
					{

					}
					{ ~scene == 4 }
					{

					};


			});
		}, {

			if ( ~global_freeze == \off, {

			if ( ~synth_gates[~scene] == \on, {

				case
				{ ~scene == 0 } {
					~scene0_group.set(\gate,0);
					~scene0doubler_group.set(\gate,0);
					~scene0_retrig_routine.stop;
				}
				{ ~scene == 1 } {
				~scene1_group.set(\gate,0);
				~scene1doubler_group.set(\gate,0);
				~scene1doublerhigh_group.set(\gate,0);


				~scene1doubler_check.stop;
					   }
				{ ~scene == 2 } {
				~scene2_grain_routine.stop; }
                { ~scene == 3 } { ~grain_routine2.stop; }
				{ ~scene == 4 } { ~grain_routine3.stop; };


			"synth off".postln;
			~synth_gates[~scene] = \off;
			});
			});
		});
		0.01.wait; }; }).play;

OSCdef(\trillflex1, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			     ~all_fingers.put(0,1);
			if ( ~flex_gates[0] == \closed, { ~flex_gates[0] = \open; });

		     }, { ~all_fingers.put(0,0);
			if ( ~flex_gates[0] == \open, { ~flex_gates[0] = \closed; });
		});

			if ( fingers > 1, {


		});
			if ( fingers > 2, {
				//~stereoverb_synth.set(\mix, msg[8]);
		});

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

			if ( x_val > 0.02, {

				case
				{ ~scene == 0 } {
					~scene0_buses[2].set(~looprangeSpec.map(x_val).postln; );
				}
				{ ~scene == 1 } {
					~scene1_buses[2].set(~trateSpec.map(x_val) );
					~scene1_buses[3].set(~durSpec.map(x_val));
					~scene1_buses[4].set(~grainAmpSpec.map(x_val));
				}
				{ ~scene == 2 } {
					~scene2_buses[2].set(~overlapSpec.map(msg[4].postln; ));

					~scene2_buses[0].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));

				};

				//~grain_clock.tempo = ~grainclockSpec.map(x_val);
				//~overlapBus.set(~grainoverlapSpec.map(x_val) );

				// ~trateBus[0].set(~trateSpec.map(x_val) );
			    // ~durBus[0].set(~durSpec.map(x_val));
			    //  ~grainampBus[0].set(~grainAmpSpec.map(x_val));
			//if ( y_val > 0.1, {  ~grainampBus[0].set(~grainAmpSpec.map(y_val));  });

			}); });

		}, '/flex1');



OSCdef(\trillflex2, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			~all_fingers.put(1,1);
			if ( ~flex_gates[1] == \closed, { ~flex_gates[1] = \open; });

		     }, { ~all_fingers.put(1,0);
			if ( ~flex_gates[1] == \open, {

			if ( ~global_freeze == \off, {

				~flex_gates[1]  = \closed; "doubler off".postln;

			});

		}); });

			if ( fingers > 1, {
				//~grainPosBus[1].set(~grainPosSpec.map(msg[6]));
				//~grainpitchBus[1].set(~tone_collection.wrapAt(~tuner.map(msg[6])));

			});
			if ( fingers > 2, {
				//~stereoverb_synth.set(\mix, msg[8]);

		});
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

				if ( msg[4] > 0.01, {
				case
				{ ~scene == 0 } {
					~scene0_buses[1].set(~startPosSpec.map(msg[4]).postln; );
					~scene0_buses[3].set( ~overlapSpec.map(msg[4]).postln; );
					if ( ~doubler == \on, {
					~scene0_buses[4].set(~micro_tuning_low.wrapAt(~tuning_map.map(msg[4])));
					});

				}
				{ ~scene == 1 }  {
					~scene1_buses[1].set(~grainPosSpec.map(msg[4].postln; ));

					~scene1_buses[0].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));
					~scene1_buses[7].set(~gendy_index_spec.map(msg[4]).postln; );



				}
					{ ~scene == 2 }  {
					~scene2_buses[1].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])) * 2);

				};





			    });
			});

		}, '/flex2');




OSCdef(\trillflex3, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
				if ( fingers > 0, {
			     ~all_fingers.put(2,1);
			     if ( ~flex_gates[2] == \closed, { ~flex_gates[2] = \open; });
		     }, { ~all_fingers.put(2,0);   if ( ~flex_gates[2] == \open, { ~flex_gates[2] = \closed; });   });
			if ( fingers > 1, {
			    "verb".postln;
                // ~stereoverb_synth.set(\mix, msg[4]);
				//~grainPosBus[2].set(~grainPosSpec.map(msg[6]));
			    //~grainpitchBus[2].set(~tone_collection.wrapAt(~tuner.map(msg[6])));
		   });

			if ( fingers > 2, {
				        });
			if ( fingers > 3, {
					if ( ~grainFreezeSwitch3 == 0, {
						if ( ~grainFreeze3 == 0, {
							~grainFreeze3 = 1; ~grainFreezeSwitch3 = 1; "grainfreeze on".postln;

						}, {
							~grainFreeze3 = 0; ~grainFreezeSwitch3 = 1; "grainfreeze off".postln; }); }); });
			if ( fingers < 4, {
					if ( ~grainFreezeSwitch3 == 1, { ~grainFreezeSwitch3 = 0;   });
			});

			//msg.postln;
			if ( ~grainFreeze3 != 1, {
				if ( msg[4] > 0.05, {


				case
				{ ~scene == 0 } {
					~scene0_buses[0].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));
				}
				{ ~scene == 1 } {
					~scene1_buses[5].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));



				}
				{ ~scene == 2 } {
				   ~scene2_buses[2].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])) * 2);
				}
				{ ~scene == 3 } {

				}
				{ ~scene == 4 } {

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

			 if ( ~flex_gates[3] == \closed, { ~flex_gates[3] = \open; });

		     }, { ~all_fingers.put(3,0);
			    if ( ~flex_gates[3] == \open, { ~flex_gates[3] = \closed; });
		});
			if ( fingers > 1, {
			"verb".postln;
			  //~stereoverb_synth.set(\mix, msg[4]);
		});
			if ( fingers > 2, {

			 });

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
				if ( msg[4] > 0.01, {

				case
				{ ~scene == 0 } {
					~scene0_buses[0].set(~micro_tuning_low.wrapAt(~tuning_map.map(msg[4])));
				}
				{ ~scene == 1 } {
					~scene1_buses[0].set(~micro_tuning_low.wrapAt(~tuning_map.map(msg[4])));
					~scene1_buses[6].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));
				}
				{ ~scene == 2 } {
				 ~scene2_buses[3].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])) * 2 );
				}
				{ ~scene == 3 } {

				}
				{ ~scene == 4 } {

				};


			})

			});

		}, '/flex4');


	~prev_scene = 0;


/* CRAFT SYNTH */
~trill_craft = Synth(\trillcraft);

~b1_denoise_gate=\open;
~b2_denoise_gate=\open;

OSCdef(\craft_osc, {|msg| var button1, button2, b1_denoise_gate=\open, b2_denoise_gate=\open;
			//msg.postln;

		    button1 = msg[11+3];
			button2 = msg[18+3];

		    /* BUTTON 1`: FREEZE */
		     if ( button1 != 0, {
			if ( ~b1_denoise_gate == \open, { ~b1_denoise_gate = \closed; "b1 gate closed".postln;
				fork { var waitTime = 0.05;
				"transition sound on".postln;
					3.do{
						Synth(\transition_sound_low, [\attack, 0.001,\release, 0.25,\bufnum,~radio_samples[2],\gen_index, rrand(0.3,0.6),
							\rate,~micro_tuning.choose * 0.4, \cutfreq, rrand(900,1200), \res, waitTime*1.5, \out,~verbBus ],~transition_group);
					};
				waitTime.wait;
				"switching off transition sound".postln;
				~transition_group.set(\gate,0);

			};


				if ( ~global_freeze == \off, { ~global_freeze = \on; }, { ~global_freeze = \off; });
			("global freeze: "++~global_freeze).postln;
				//fork{ b1_denoise_gate = \closed; "b1 gate closed".postln; 1.wait; b1_denoise_gate = \open; "b1 gate open".postln; };

			});
		}, {  if ( ~b1_denoise_gate == \closed, {  ~b1_denoise_gate = \open;   "b1 gate open".postln;  }); });

		    /* BUTTON 2 : SCENE */
		    if ( button2 != 0, {
			~prev_scene = ~scene;
			if ( ~b2_denoise_gate == \open, { ~b2_denoise_gate = \closed; "b2 gate closed".postln;
			fork { var waitTime = 0.05;
				"transition sound on".postln;
					3.do{
						Synth(\transition_sound, [\attack, 0.001,\release, 0.25,\bufnum,~radio_samples[2],\gen_index, rrand(0.3,0.6),
							\rate,~micro_tuning.choose * 4, \cutfreq, rrand(6000,8000), \res, waitTime*1.5, \out,~verbBus ],~transition_group);
					};
				waitTime.wait;
				"switching off transition sound".postln;
				~transition_group.set(\gate,0);

			};

			if (~scene != 4, { ~scene = ~scene + 1;  }, { ~scene = 0; });
			if ( ~synth_gates[~prev_scene] == \on, {
				             case
				{ ~prev_scene == 0 } { ~grainbufGroup.set(\gate, 0);     }
				{ ~prev_scene == 1 } { ~grainbufGroup.set(\gate, 0);     }
				{ ~prev_scene == 2 } { ~grain_routine1.stop;   }
				{ ~prev_scene == 3 } {  ~grain_routine2.stop;  }
				{ ~prev_scene == 4 } {  ~grain_routine3.stop;  };
				~synth_gates[~prev_scene] = \off;
			                       });
			("scene "++~scene).postln;
			});
		}, {    if ( ~b2_denoise_gate == \closed, {  ~b2_denoise_gate = \open;   "b2 gate open".postln;  });             });





			}, '/craft');




});












