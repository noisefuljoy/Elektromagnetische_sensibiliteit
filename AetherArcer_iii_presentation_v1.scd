/*
AetherArcer_iii_presentation_semiDef_v1

extra fingers implementeren bij
scene 3 + 4
tempoclocks afmaken bij scene 3
*/

s.boot;

s.waitForBoot({

s = Server.default;

~debug = true;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
s.options.numDigitalChannels = 16;
s.options.pgaGainLeft = 10;     // sets the gain for the left audio input to 4 dB
s.options.pgaGainRight = 10;    // sets the gain for the left audio input to 5 dB
s.options.headphoneLevel = 0; // sets the headphone level to -6 dB
s.options.speakerMuted = 0;    // enable the speaker amp
s.options.dacLevel = 6;       // sets the gain of the dac to 0 dB
s.options.adcLevel = 6;       // sets the gain of the adc to 0 dB
s.options.numMultiplexChannels = 0; // do not enable multiplexer channels
s.options.blockSize = 16;

s.options.numInputBusChannels = 2; // Use only the L/R audio channels
s.options.numOutputBusChannels = 2; // Use only the L/R audio channels
s.options.memSize = 8192 * 16; // the default is 8192 which is quite little


SynthDef(\sine_short, {|out=0 amp=0.5 freq=440 rel=0.1|
	var env, sig;
	env = EnvGen.ar(Env.perc(0.010,rel), doneAction: 2);
	sig = SinOsc.ar(freq * LFSaw.ar(Rand(90.0,150.0),0, 0.25, 1), LFPar.kr(Rand(0.1,10.0)).range(-2pi, 2pi) );
	sig = sig ring1: VarSaw.ar(freq * LFTri.ar(Rand(9.0,15.0),0, 0.9, 1),0, LFPar.kr(Rand(0.1,10.0)).range(0.1, 0.9));
	sig = sig ring1: Gendy1.ar;
	Out.ar(out, Pan2.ar(sig*env*amp)); }).store;

SynthDef(\sine_short_low, {|out=0 amp=0.5 freq=440 rel=0.1|
	var env, sig;
	env = EnvGen.ar(Env.perc(0.010,rel), doneAction: 2);
	sig = SinOsc.ar((freq * 0.25) *  LFSaw.ar(Rand(90.0,150.0),0, 0.25, 1), LFPar.kr(Rand(0.1,10.0)).range(-2pi, 2pi) );
	sig = sig ring1: VarSaw.ar(freq * 0.25 * LFTri.ar(Rand(9.0,15.0),0, 0.9, 1),0, LFPar.kr(Rand(0.1,10.0)).range(0.1, 0.9));
	sig = sig ring1: Gendy1.ar;
	sig = RLPF.ar(sig, 400, 0.5);
	Out.ar(out, Pan2.ar(sig*env*amp)); }).store;


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


SynthDef(\radio_looper, {|out=0 amp=0.25 bufnum rate=1 envbuf startpos=0 looprange=0.25 overlap=0 t_trig=0 gate=1 srate=48000 bits=24 transposeBus|
		var totsig, sig1_OR_sig2, sig1,sig2,start1,start2,phasor1,phasor2,end1,end2,
	    kill_env, env, frames,endpos, dur, crossfade,transpose;
	    endpos =  (startpos + looprange);
	    sig1_OR_sig2 = ToggleFF.kr(t_trig);
	    start1 = Latch.kr(startpos, sig1_OR_sig2);
	    end1 = Latch.kr(endpos, sig1_OR_sig2);
	    start2 = Latch.kr(startpos, 1 - sig1_OR_sig2);
	    end2 = Latch.kr(endpos, 1 - sig1_OR_sig2);
	    crossfade = Lag.ar(K2A.ar(sig1_OR_sig2), 0.001);
		transpose = In.kr(transposeBus, 1);

	    rate = rate * BufRateScale.kr(bufnum);
	    frames = BufFrames.kr(bufnum);
	    //startpos = In.kr(startposBus, 1) * frames;
		//looprange = In.kr(looprangeBus, 1);
	    //startpos = startpos * frames;
	    dur = (looprange * frames ) / rate.abs / 48000;

	    //env = EnvGen.ar(Env.new([0,1,1,0],[0,dur,0]),t_trig);
		kill_env = EnvGen.ar(Env.adsr(0.01,0.0,1,0.01),gate, doneAction: 2);
		env = EnvGen.ar(Env.linen(dur*0.1,dur*0.99,dur*0.01+(dur*overlap) ),t_trig);
	    //env = EnvGen.ar(Env.perc(dur*0.01,dur*0.99),t_trig);
		phasor1 = Phasor.ar(sig1_OR_sig2, rate * transpose, start1*frames,end1*frames+(overlap*frames), start1*frames );
	    phasor2 = Phasor.ar(1 - sig1_OR_sig2, rate * transpose, start2*frames,end2*frames+(overlap*frames), start2*frames );
		//sigenv = EnvGen.ar(Env.linen(0.1*dur,0.8*dur,0.1*dur),\trig.tr(1));
		sig1 = BufRd.ar(1, bufnum, phasor1, interpolation: 1);
	    sig2 = BufRd.ar(1, bufnum, phasor2, interpolation: 1);
		totsig = (crossfade*sig1) + ( ( 1 - crossfade ) * sig2);
		totsig = Decimator.ar(totsig, srate, bits);
	//Out.ar(out, Pan2.ar( totsig * env * kill_env * amp) );
		Out.ar(out, totsig * env * kill_env * amp );
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
SynthDef(\radio_sampler, {|out=0 amp=0.4 bufnum rateBus envbuf dur=0.1 posBus ratemod_index_bus overlap=1 pan=0 minFreq=0.15 maxFreq=4 mix=0|
		var env, sig,proc_sig, rate, pos, ratemod_index;
	    rate = In.kr(rateBus, 1);
		rate = Lag.kr(rate, 0.05);
	    pos = In.kr(posBus, 1);
		ratemod_index = In.kr(ratemod_index_bus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		//rate = rate * Gendy1.kr(1,1,1,1,minFreq, maxFreq,mul:ratemod_index, add: 1);

		rate = rate * (1 + ratemod_index);

		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * pos,loop: 1);
		//sig = RLPF.ar(sig, 50 + (rate * 3000),0.6);
		//sig = HPF.ar(sig, 25);
		sig = Decimator.ar(sig, rrand(5000,1000), Rand(2,4),mix, sig * (1-mix));
	    //sig = MidEQ.ar(sig, 1000, 0.1,9);
		Out.ar(out, Pan2.ar(sig*env*amp*2, pan)); }).store;

SynthDef(\radio_sampler_scene3, {|out=0 amp=0.4 bufnum rate envbuf dur=0.1 posBus overlap=1 pan=0|
		var env, sig, pos;
	    pos = In.kr(posBus, 1);
		env = Osc1.ar(envbuf, dur*overlap);
		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * pos,loop: 0);
	    //sig = MidEQ.ar(sig, 1000, 0.1,9);
		Out.ar(out, Pan2.ar(sig*env*amp, pan)); }).store;

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

SynthDef(\buf_grain, { |out, gate = 1, gen_index_bus, durmod_index_bus, ampBus, rateBus, trateBus,durBus, transposeBus, bufnum,posBus,envbuf, mainVolume=1|
    var vib, sig, pan, env, freqdev, rate, trate, dur, pos, amp, gen_index,durmod_index, transpose;
	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);
	amp = In.kr(ampBus, 1);
	gen_index = In.kr(gen_index_bus, 1);
	durmod_index = In.kr(durmod_index_bus, 1);
	transpose = In.kr(transposeBus, 1);
    vib = Gendy1.kr(1,1,1,1,0.125, 8,mul:gen_index,add:1);
		rate = (rate * vib) * transpose;
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 0.01], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
		sig = GrainBuf.ar(2, Impulse.kr(trate), dur * (1 + SinOsc.kr(LFNoise2.kr(0.4).range(3.0,80.0),0,durmod_index).range(0.0,0.3)), bufnum, rate  * BufRateScale.kr(bufnum),
					BufFrames.kr(bufnum) * pos, 2, 0, envbuf);
    Out.ar(out, sig * amp * 2 * env * mainVolume);
}).store;

SynthDef(\buf_grain_double, { |out, gate = 1, gen_index_bus,durmod_index_bus, ampBus, mainAmp=1 rateBus, trateBus,durBus, transposeBus, bufnum,posBus,envbuf, mainVolume=1|
    var vib,sig, pan, env, freqdev, rate, trate, dur, pos, amp, gen_index, durmod_index, transpose;
	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);
	amp = In.kr(ampBus, 1);
	gen_index = In.kr(gen_index_bus, 1);
	durmod_index = In.kr(durmod_index_bus, 1);
	transpose = In.kr(transposeBus, 1);

	 vib = Gendy1.kr(1,2,1,1,0.0625, 1,mul:gen_index,add:1);
	rate = (rate * vib) * transpose;

    env = EnvGen.kr(
        Env([0, 1, 0], [1, 0.01], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
		sig = GrainBuf.ar(2, Impulse.kr(trate), dur * (1 + SinOsc.kr(LFNoise0.kr(3.4).range(3.0,80.0),0,durmod_index).range(0.0,0.4)), bufnum, rate * 1  * BufRateScale.kr(bufnum),
					BufFrames.kr(bufnum) * pos, 2, 0, envbuf);
	sig = RLPF.ar(sig, Lag.kr(3000 * rate + 50,0.4),0.8);
	sig = HPF.ar(sig, 25);
    Out.ar(out, sig * amp * 1.6 * env * mainVolume);
}).store;

SynthDef(\buf_grain_double_high, { |out, gate = 1, gen_index_bus,durmod_index_bus, ampBus, mainAmp=1 rateBus, trateBus,durBus, transposeBus, bufnum,posBus,envbuf, mainVolume=1|
    var vib, sig, pan, env, freqdev, rate, trate, dur, pos, amp, gen_index,durmod_index, transpose;

	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);
	amp = In.kr(ampBus, 1);
	gen_index = In.kr(gen_index_bus, 1);
	durmod_index = In.kr(durmod_index_bus, 1);
	transpose = In.kr(transposeBus, 1);


	vib = Gendy1.kr(1,1,1,1,0.5, 20.0,mul:gen_index,add:1);
    rate = (rate * vib) * transpose;
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 0.01], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
		sig = GrainBuf.ar(2, Impulse.kr(trate), dur * (1 + SinOsc.kr(LFNoise0.kr(3.4).range(3.0,80.0),0,durmod_index).range(0.0,0.4)), bufnum, rate * 1  * BufRateScale.kr(bufnum),
					BufFrames.kr(bufnum) * pos, 2, 0, envbuf);
		sig = RLPF.ar(sig, Lag.kr(3000 * rate + 50,0.4),0.8);
		sig = HPF.ar(sig, 25);


    Out.ar(out, sig * amp * 1.6 * env * mainVolume);
}).store;



SynthDef(\recorder, {|in=0 fftbuf recbuf thresh=0.3|
var input = SoundIn.ar(in);
var chain = FFT(fftbuf, input);
var onsets = Onsets.kr(chain,thresh);
//input = Compander.ar(input, input, 0.01,1,0.01,0.005,0.1,25);

	RecordBuf.ar(input, recbuf,loop:0,trigger:onsets);
 }).store;


SynthDef(\filter, {|in out=0 modfreq=0.01 mix=0 dec=6|
		var sig,sigL,sigL_low,sigL_mid,sigL_hi, sigR,sigR_low,sigR_mid,sigR_hi,delsigL,delsigR;
		sig = In.ar(in, 2);
		sigL_low = MoogFF.ar(sig[0], SinOsc.kr(LFNoise0.kr(0.2).range(modfreq*0.5,modfreq)).range(25, 900), 3);
		//sigL_low = HPF.ar(LPF.ar(sigL_low, 405),25);
		sigL_mid = MoogFF.ar(sig[0], SinOsc.kr(LFNoise0.kr(0.4).range(modfreq*0.25,modfreq*0.5),-0.25).range(900, 3000), 3);
		//sigL_mid = HPF.ar(LPF.ar(sigL_mid, 1100),490);
		//sigL_hi = MoogFF.ar(sig[0], SinOsc.kr(modfreq*0.25,0.4).range(900, 5000), 3);
		//sigL_hi = HPF.ar(LPF.ar(sigL_hi, 50050),890);

		sigR_low = MoogFF.ar(sig[1], SinOsc.kr(LFNoise0.kr(0.4).range(modfreq*0.5,modfreq*2),-2pi).range(35, 1000), 3);
		//sigR_low = HPF.ar(LPF.ar(sigR_low, 405),25);
		sigR_mid = MoogFF.ar(sig[1], SinOsc.kr(LFNoise0.kr(0.1).range(modfreq*0.125,modfreq*0.25),pi).range(1000, 9000), 3);
		//sigR_mid = HPF.ar(LPF.ar(sigR_mid, 1100),490);
		//sigR_hi = MoogFF.ar(sig[1], SinOsc.kr(modfreq*0.25,0.1).range(900, 5000), 3);
		//sigR_hi = HPF.ar(LPF.ar(sigR_hi, 50050),890);

		sigL = Mix([sigL_low, sigL_mid]);
		delsigL = sigL;
		3.do{|i|
			n = (i + 1) * 0.1;
			o = (i + 1) * 0.01;
			e = (i + 1) * 0.1;

			delsigL = CombC.ar(delsigL, 0.2, SinOsc.kr(0.001+o,-2pi,0.25).range(0.01, n), e + dec, 1, delsigL*0.33);
		};

		sigR = Mix([sigR_low, sigR_mid]);
		delsigR = sigR;
		3.do{|i|
			n = (i + 1) * 0.09;
			o = (i + 1) * 0.01;
			e = (i + 1) * 0.14;

			delsigR = CombC.ar(delsigR, 0.2, SinOsc.kr(0.004+o,pi,0.35).range(0.01, n), e + dec, 1, delsigR*0.33);
		};
		sigL = (delsigL * mix) + (sigL * ( 1 - mix) );
		sigR = (delsigR * mix) + (sigR * ( 1 - mix) );

		Out.ar(out, [sigL, sigR] ); }).store;

SynthDef(\grain_eq, {|out=0 in amp=1 boostfreq=300 cutfreq=3000 rq=0.5 gate=1 mix=0.1|
	var env, sig, in_sig, sigL, sigR;
	in_sig = In.ar(in, 2);
	//in_sig = Compander.ar(in_sig, in_sig, 0.1,1.0,0.1,0.001,0.1,10);
		sigL = in_sig[0];
	sigL = BLowPass4.ar(sigL, cutfreq*1.1, rq*1.05, 1);
	sigL = BPeakEQ.ar(sigL, boostfreq, 0.7, 5, amp);


	sigR = in_sig[1];
	sigR = BLowPass4.ar(sigR, cutfreq*0.9, rq*0.95, 1);
	sigR = BPeakEQ.ar(sigL, boostfreq, 0.7, 5,amp);
	env = EnvGen.ar(Env.adsr(1.0, 0.0,1,3.0),gate, doneAction: 2);
	sig = FreeVerb2.ar(sigL, sigR, mix,0.9,0.6);

	//sig = [sigL, sigR];
		//sigR = Compander.ar(sigR, sigR, 0.1,1.0,0.1, 0.001,0.1,5);
	Out.ar(out,sig*env );
}).store;

SynthDef(\combc_new, {|in out=0 delmod=0.001 dec=0.001 mix=0.05 gate=1|
		var env,sig,delsig;
		sig = In.ar(in, 2);
		//sig = Compander.ar(sig, sig, 0.001,1.0,0.001,0.001,0.1,100);
		delsig = sig;


		3.do{|i|
			n = (i + 1) * 0.025;
			o = (i + 1) * 0.01;
			e = (i + 1) * 1;
			delsig = CombC.ar(delsig, 0.075, n, 1+e, 0.15, delsig * 0.85);
			//delsig = CombC.ar(sig, 0.2, SinOsc.kr(delmod+o).range(0.01, n), e + dec, 0.3, delsig*0.7);
		};


		sig = (delsig * mix) + (sig * ( 1 - mix) );
		env = EnvGen.ar(Env.adsr(1.0, 0.0,1,3.0),gate, doneAction: 2);
		//sig = LPF.ar(sig, 800);
		Out.ar(out, sig*env ); }).store;

SynthDef(\allpassc, {|in out=0 delmod=0.001 dec=8 mix=0.4 gate=1|
		var env, sig,delsig;
		sig = In.ar(in, 2);

		delsig = sig;
		3.do{|i|
			n = (i + 1) * 0.1;
			o = (i + 1) * 0.01;
			e = (i + 1) * 0.1;

			delsig = AllpassC.ar(sig, 0.2, SinOsc.kr(delmod+o).range(0.01, n), e + dec, 1, delsig*0.9);
		};

		sig = (delsig * mix) + (sig * ( 1 - mix) );
		env = EnvGen.ar(Env.adsr(1.0, 0.0,1,3.0),gate, doneAction: 2);
		//sig = LPF.ar(sig, 800);
		Out.ar(out, sig ); }).store;

SynthDef(\stereo_verb, {|in out=0 mix=0.0 gate=1|
		var env,sig;
		sig = In.ar(in, 1);
		//sig = Compander.ar(sig, sig, 0.001,1.0,0.001,0.001,0.1,100);
		//sig = FreeVerb2.ar(sig[0], sig[1], mix: mix,room: 0.9,damp: 0.6);
		sig = FreeVerb.ar(sig, mix: mix,room: 0.9,damp: 0.6);
		env = EnvGen.ar(Env.adsr(1.0, 0.0,1,3.0),gate, doneAction: 2);
		Out.ar(out, sig*env); }).store;

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
4.0.wait;

/* CRAFT SYNTH */
~trill_craft = Synth(\trillcraft);
3.0.wait;

/* BUFFERS*/
~radio_files = "/home/radiosamples/*.wav".pathMatch;
//2.0.wait;
~radiofiles.postln;
~radio_samples = ~radio_files.collect({|item| Buffer.read(s, item); });

~craft_fftbuf_left = Buffer.alloc(s, 512);
~craft_fftbuf_right = Buffer.alloc(s, 512);


6.0.wait;
~radio_samples.postln;
"radio samples loaded".postln;
/*GROUPS AND BUSES */
~synthGroup = Group.new;

~scene0_groups = Array.fill( 4, { Group.new(~synthGroup); });

~scene1_groups = Array.fill( 3, { Group.new(~synthGroup); });

/*
~scene1_group = Group.new(~synthGroup);
~scene1doubler_group = Group.new(~synthGroup);
~scene1doublerhigh_group = Group.new(~synthGroup);
*/

~transition_group = Group.new(~synthGroup);
~grainbufGroup = Group.new(~synthGroup);
~grainbufGroup2 = Group.new(~synthGroup);
~grainbufGroup3 = Group.new(~synthGroup);
~grainbufGroup4 = Group.new(~synthGroup);
~craftGroups = Array.fill(16, { Group.new(~synthGroup); });
~effectGroup = Group.after(~synthGroup);
~effectGroups = Array.fill(5, { Group.head(~effectGroup); });

~grain_group = Group.new(~synthGroup);
~graineq_group = Group.before(~effect_group);
~graineq_bus = Bus.audio(s, 2);

~nyquist = s.sampleRate * 0.5;

	~filtBus = Bus.audio(s, 2);
~combBus = Bus.audio(s, 2);
~allpassBus = Bus.audio(s, 2);
~verbBus = Bus.audio(s, 1);

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

Synth(\stereo_verb, [\in, ~verbBus, \mix, 0.0], ~effectGroups[0], \addToTail);
//Synth(\allpassc, [\in, ~allpassBus, \mix, 0.25 ], ~effectGroup[1],\addToTail);
//Synth(\grain_eq, [\in, ~graineq_bus,\rq,0.75,\boostfreq,500,\cutfreq,5000,\amp,1, \out, 0 ],  ~effectGroups[2], \addToHead );
//Synth(\combc_new, [\in, ~combBus,\dec,0, \mix, 0.05], ~effectGroups[3],\addToTail);
//Synth(\filter, [\in, ~filtBus, \modfreq, 0.1], ~effectGroups[4], \addToTail);

~grainbuf_switch = 0;
~grainbuf_switch2 = 0;
~grainbuf_switch3 = 0;
~grainbuf_switch4 = 0;

~winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
~grainbufenv = Buffer.sendCollection(s, ~winenv.discretize, 1);
~env_buf = Buffer.sendCollection(s, Env.perc.discretize, 1);

~hanning = Signal.hanningWindow(1024);
~hanning_env = Buffer.sendCollection(s, ~hanning, 1);

~rect = Signal.rectWindow(1024);
~rect_env = Buffer.sendCollection(s, ~rect, 1);

~welch = Signal.welchWindow(1024);
~welch_env = Buffer.sendCollection(s, ~welch, 1);

~trateBus = Array.fill(4, { Bus.control(s, 1).set(10); });
~durBus = Array.fill(4, { Bus.control(s, 1).set(0.25); });

~global_freeze = \off;

~tuning_map = [0, 29, \linear, 1].asSpec;
~tuning_map_v2 = [0, 29, -2, 1].asSpec;
~tuning_map_v3 = [0, 29, 2, 1].asSpec;
~scene0_srateSpec = [10, 9000, \linear,1].asSpec;
~scene0_bitSpec = [3, 24, \linear,1].asSpec;
~scene0_srate = 48000;
~scene0_prev_srate = 48000;

~scene0_bits = 24;
~scene0_prev_bits = 24;



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


~micro_tuning_low_scene1 = Array.fill(30, {|i|
		if ( i < 25 , {
			~johnston.ratios.wrapAt( i ) * 0.25 }, {
			~johnston.ratios.wrapAt( i ) * 0.5
		});

	});

~micro_tuning_scene2 = Array.fill(30, {|i|
		if ( i < 25 , {
			~johnston.ratios.wrapAt( i ) * 0.5 }, {
			~johnston.ratios.wrapAt( i ) * 1
		});

	});

/*tuning scene 2 */
~sc2_tuningMap_first = [0, 29, \linear, 2].asSpec;
~sc2_tuningMap_second = [29, 5, \linear, 1].asSpec;
~sc2_tuningMap_third = [7, 29, \linear, 1].asSpec;
~sc2_tuningMap_four = [29, 0, \linear, 2].asSpec;

~sc3_tuningMap_first = [0, 29, \linear, 2].asSpec;
~sc3_tuningMap_second = [29, 5, \linear, 1].asSpec;
~sc3_tuningMap_third = [7, 29, \linear, 1].asSpec;
~sc3_tuningMap_four = [29, 0, \linear, 2].asSpec;

t = ScalaTunings.at('eikosany');
~eikosany = Tuning.eikosany;
~eikosany_tuning = Array.fill(60, {|i|

	case
	{ i < 20 } { ~eikosany.ratios.wrapAt( i ) * 0.5 }
	{ i >= 20 and: i < 40 } { ~eikosany.ratios.wrapAt( i ) * 1 }
	{ i >= 40 and: i < 60 } { ~eikosany.ratios.wrapAt( i ) * 2 }

	});


t = ScalaTunings.at('pentatetra1');
~pentatetra = Tuning.pentatetra1;

~pentatetra_tuning = Array.fill(30, {|i|
		case
	    { i < 9 } { ~pentatetra.ratios.wrapAt( i ) * 0.5 }
	    { i >= 9 and: i < 18 } { ~pentatetra.ratios.wrapAt( i ) * 1 }
	    { i >= 18 and: i < 27 } { ~pentatetra.ratios.wrapAt( i ) * 2 }
	    { i >= 27 and: i < 36} { ~pentatetra.ratios.wrapAt( i ) * 4 }
		{ i >= 36 and: i < 45} { ~pentatetra.ratios.wrapAt( i ) * 8 }
		{ i >= 45 and: i < 54} { ~pentatetra.ratios.wrapAt( i ) * 16 }
		{ i >= 54 } { ~pentatetra.ratios.wrapAt( i ) * 32 };

		});

/* BUSES */
/* SCENE 0. 0: pitch 1: startpos 2: looplength 3: overlap 4: rate scene0doubler_group*/
	~scene0_buses = Array.fill(12, {|i|

		Bus.control(s, 1).set(
			case
			{ i == 0} { ~micro_tuning[0];  }
			{ i == 1 } { 0 }
			{ i == 2 } { 1 }
			{ i == 3 } { 0 }
			{ i == 4 } { ~micro_tuning_low[12];  }
			{ i == 5 } { 0.25 }
			{ i == 6 } { 0.25 }
			{ i == 8 } { 1 }
			{ i == 9 } { 1 }
			{ i == 10 } { 1 }
			{ i == 11 } { 1 };

		);
	});
/* SCENE 1. 0:pitch 1:pos 2:trate 3:dur 4:overlap 5: rate doubler 6: rate doubler high 7:gendy index   11:overlap  */
	~scene1_buses = Array.fill(12, {|i|
		Bus.control(s, 1).set(
			case
			{ i == 0} { ~micro_tuning[0] }
			{ i == 1 } { 0 }
			{ i == 2 } { 1 }
		    { i == 3 } { 0.1 }
			{ i == 4 } { 0 }
			{ i == 5 } { ~micro_tuning_low[5] }
			{ i == 6 } { ~micro_tuning_low[12]  }
			{ i == 7 } { 0.0 }
			{ i == 8 } { 1 }
			{ i == 9 } { 1 }
			{ i == 10} { 1 }
			{ i == 11 } { 0 };
		);
	});


/* SCENE 2. 0: pitch_grain0 1: pitch_grain1 2: pitch_grain2 3:pitch_grain4  4: startpos 5: dur 6: ratemodindex */
	~scene2_buses = Array.fill(10, {|i|
		Bus.control(s, 1).set(
			case
		    { i == 0} { ~pentatetra_tuning[0]; }
		    { i == 1 } { ~pentatetra_tuning[1]; }
		    { i == 2 } { ~pentatetra_tuning[2]; }
		    { i == 3 } { ~pentatetra_tuning[3]; }
			{ i == 4 } { 0.0 }
			{ i == 5 } { 1 }
		    { i == 6 } { 0 }
			{ i == 7 } { 0 }
			{ i == 8 } { 0 }
			{ i == 9 } { 0 };
		)
	});

/* SCENE 3. 0: pitch_grain0 1: pitch_grain1 2: pitch_grain2 3:pitch_grain4  4: startpos 5: looplength */
	~scene3_buses = Array.fill(9, {|i|
		Bus.control(s, 1).set(
			case
		    { i == 0} {  ~eikosany_tuning[0]; }
		    { i == 1 } { ~eikosany_tuning[1]; }
		    { i == 2 } { ~eikosany_tuning[2]; }
		    { i == 3 } { ~eikosany_tuning[3]; }
			{ i == 4 } { 0.0 }
			{ i == 5 } { 1 }
			{ i == 6 } { 1 }
			{ i == 7 } { 1 }
			{ i == 8 } { 1 };

		);
	});

/* SCENE 4. 0: pitch_grain0 1: pitch_grain1 2: pitch_grain2 3:pitch_grain4  4: startpos 5: looplength */
	~scene4_buses = Array.fill(9, {|i|
		Bus.control(s, 1).set(
			case
		    { i == 0} {  ~eikosany_tuning[0]; }
		    { i == 1 } { ~eikosany_tuning[1]; }
		    { i == 2 } { ~eikosany_tuning[2]; }
		    { i == 3 } { ~eikosany_tuning[3]; }
			{ i == 4 } { 0.0 }
			{ i == 5 } { 1 }
			{ i == 6 } { 1 }
			{ i == 7 } { 1 }
			{ i == 8 } { 1 };

		);
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

/* scene 2 */

~scene2_clock = TempoClock.new(0.75);
~scene2_dur = 1;
~sc2_posSpec = [0.0, 0.8, \linear, 0.01].asSpec;
~sc2_clockindex = [0, 29, \linear, 1].asSpec;
~sc2_durindex = [0, 29, -2, 1].asSpec;
~latoo_ratemod_spec = [0.1, 0.5, \linear, 0.01].asSpec;
~sc2_clock_arr = Array.fill(30, {|i| (i+ 1) * 0.125 });
~sc2_dur_arr = Array.fill(30, {|i| 4 - (i* 0.13620689655172); });


//~sc2_dur_arr.wrapAt(~sc2_durindex.map(0.75));
/* scene 3 */
	~scene3_rates1 = Array.fill(30,
		{|i|
			Array.fill(5, {|j|
				~eikosany_tuning.wrapAt(j+i); });    });
		30.do{|i| ~scene3_rates1[i] = ~scene3_rates1[i].scramble; };

	~scene3_rates2 = Array.fill(30,
		{|i|
			Array.fill(5, {|j|
				~eikosany_tuning.wrapAt(j+ (i*2) ); });    });
		30.do{|i| ~scene3_rates2[i] = ~scene3_rates2[i].scramble; };

	~scene3_rate3 = Array.fill(30,
		{|i|
			Array.fill(5, {|j|
				~eikosany_tuning.wrapAt(59-(j+i)); });    });
	30.do{|i| ~scene3_rate3[i] = ~scene3_rate3[i].scramble * 0.5 };

	~scene3_rate4 = Array.fill(30,
		{|i|
			Array.fill(5, {|j|
				~eikosany_tuning.wrapAt( 59 - ( j+ (i*2) ) ); });    });
	30.do{|i| ~scene3_rate4[i] = ~scene3_rate4[i].scramble * 0.25 };

~scene3_melody_spec = [0, 29,\linear, 1].asSpec;
~scene3_melody_selector = 0;

~scene3_rhythm = Array.fib(5,0.03125,0.0125);

~scene3_durs = [~scene3_rhythm,~scene3_rhythm,~scene3_rhythm,~scene3_rhythm];
~scene3_rates = [~scene3_rates1,~scene3_rates2,~scene3_rate3,~scene3_rate4];

	~sc3_dur_arr = Array.geom(30,0.025, 1.2);
	~sc3_dur_index1_spec = [0.25, 1.0, -4, 0.1].asSpec;
	~sc3_dur_index2_spec = [0.25, 1.0, 4, 0.1].asSpec;
	~sc3_dur_index3_spec = [0.25, 1.0, 1, 0.1].asSpec;
	~sc3_dur_index4_spec = [0.25, 1.0, -1, 0.1].asSpec;

//~scene3_clock = TempoClock.new(0.6);
	~scene3_clocks = Array.fill(4, { TempoClock.new(0.6); });

~scene3_durSpec = [2.0, 0.001, 1, 0.001].asSpec;
~scene3_posSpec = [0.0, 0.75, 1, 0.01].asSpec;
~scene3_clockSpec = [0.1, 3.0, 1, 0.001].asSpec;


/* scene 4 */
	~scene4_rates1 = Array.fill(30,
		{|i|
			Array.fill(8, {|j|
				~eikosany_tuning.wrapAt(j+i); });    });
		30.do{|i| ~scene3_rates1[i] = ~scene3_rates1[i].scramble; };

	~scene4_rates2 = Array.fill(30,
		{|i|
			Array.fill(8, {|j|
				~eikosany_tuning.wrapAt(j+ (i*2) ); });    });
		30.do{|i| ~scene3_rates2[i] = ~scene3_rates2[i].scramble; };

	~scene4_rate3 = Array.fill(30,
		{|i|
			Array.fill(8, {|j|
				~eikosany_tuning.wrapAt(59-(j+i)); });    });
	30.do{|i| ~scene3_rate3[i] = ~scene3_rate3[i].scramble * 0.5 };

	~scene4_rate4 = Array.fill(30,
		{|i|
			Array.fill(8, {|j|
				~eikosany_tuning.wrapAt( 59 - ( j+ (i*2) ) ); });    });
	30.do{|i| ~scene3_rate4[i] = ~scene3_rate4[i].scramble * 0.25 };

~scene4_melody_spec = [0, 29,\linear, 1].asSpec;
~scene4_melody_selector = 0;


~scene4_rhythm = Array.fib(8,0.03125,0.0125);
~scene4_rhythm1 = ~scene4_rhythm.scramble;
~scene4_rhythm2 = ~scene4_rhythm.scramble;
~scene4_rhythm3 = ~scene4_rhythm.scramble;
~scene4_rhythm4 = ~scene4_rhythm.scramble;

~scene4_durs = [~scene4_rhythm1,~scene4_rhythm2,~scene4_rhythm3,~scene4_rhythm4];
~scene4_rates = [~scene4_rates1,~scene4_rates2,~scene4_rate3,~scene4_rate4];

	~sc4_dur_arr = Array.geom(30,0.025, 1.2);
	~sc4_dur_index1_spec = [0.0625, 0.4, -4, 0.001].asSpec;
	~sc4_dur_index2_spec = [0.0625, 0.4, 4, 0.001].asSpec;
	~sc4_dur_index3_spec = [0.0625, 0.4, 1, 0.001].asSpec;
	~sc4_dur_index4_spec = [0.0625, 0.4, -1, 0.001].asSpec;

	~scene4_clocks = Array.fill(4, { TempoClock.new(0.8); });
~scene4_durSpec = [2.0, 0.001, 1, 0.001].asSpec;
~scene4_posSpec = [0.0, 0.75, 1, 0.01].asSpec;
~scene4_clockSpec = [0.1, 3.0, 1, 0.001].asSpec;


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
~synth_gates = [\off, \off, \off, \off, \off];

~scene = 0;

~grain_clock = TempoClock.new(1);
~grain_rhythms = [0.1,0.1,0.2,0.3,0.5,0.3,0.2];
~grain_rhythms2 = [0.25,0.25,0.5,1.0,2.0,0.125,0.125,0.125,0.125];

~grain_rhythms3 = ~grain_rhythms2.scramble;

~grain_pos = 0.1;
~grain_rate = 1;
~grain_overlap = 0.1;

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
~scene0_rates = [0, 0, 0, 0];

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

				if ( ~debug, {
					"synth on".postln; });
				~synth_gates[~scene] = \on;
				case
				{ ~scene == 0 }
				{
					fork{
						~scene0_buses[0].get{|item| ~scene0_rates[0] = item; };
						~scene0_buses[1].get{|item| ~scene0_startpos = item; };
						~scene0_buses[2].get{|item| ~scene0_looprange = item; };
						~scene0_buses[3].get{|item| ~scene0_overlap = item; };
						~scene0_buses[4].get{|item| ~scene0_rates[1] = item; };
						~scene0_buses[5].get{|item| ~scene0_rates[2] = item; };
						~scene0_buses[6].get{|item| ~scene0_rates[3] = item; };

						Synth(\radio_looper, [\bufnum, ~radio_samples[0],\amp,0.6,\rate,~scene0_rates[0], \startpos, ~scene0_startpos,\overlap, ~scene0_overlap,
							\looprange, ~scene0_looprange,\srate, if ( ~flex_gates[2] == \open, { ~scene0_srate; }, { 48000});, \bits, if ( ~flex_gates[2] == \open, { ~scene0_bits; }, { 24});,
							\transposeBus, ~scene0_buses[8].index,
							\out, ~verbBus ], ~scene0_groups[0]);

						Synth(\radio_looper, [\bufnum, ~radio_samples[0],\amp, 0.6,
								\rate,~scene0_rates[1], \startpos, ~scene0_startpos,\overlap, ~scene0_overlap,
							\looprange, ~scene0_looprange,\srate, if ( ~flex_gates[2] == \open, { ~scene0_srate; }, { 48000});, \bits, if ( ~flex_gates[2] == \open, { ~scene0_bits; }, { 24});,
								\transposeBus, ~scene0_buses[9].index,
							\out, ~verbBus ], ~scene0_groups[1]);

						Synth(\radio_looper, [\bufnum, ~radio_samples[0],\amp,0.6,\rate,~scene0_rates[2], \startpos, ~scene0_startpos,\overlap, ~scene0_overlap,
							\looprange, ~scene0_looprange,\srate, if ( ~flex_gates[3] == \open, { ~scene0_srate; }, { 48000});, \bits,  if ( ~flex_gates[3] == \open, { ~scene0_bits; }, { 24});,
								\transposeBus, ~scene0_buses[10].index, \out, ~verbBus ], ~scene0_groups[2]);

						Synth(\radio_looper, [\bufnum, ~radio_samples[0],\amp, 0.6,
								\rate,~scene0_rates[3], \startpos, ~scene0_startpos,\overlap, ~scene0_overlap,
							\looprange, ~scene0_looprange,\srate, if ( ~flex_gates[3] == \open, { ~scene0_srate; }, { 48000});, \bits, if ( ~flex_gates[3] == \open, { ~scene0_bits; }, { 24});,
							\transposeBus, ~scene0_buses[11].index,
							\out, ~verbBus ], ~scene0_groups[3] );

					};
					~scene0_bitcrush_routine = Routine({inf.do{ var srate, bits;
						~scene0_prev_srate = ~scene0_srate;
						~scene0_prev_bits = ~scene0_bits;

						if ( ~flex_gates[2] == \open, {
							//if ( (~scene0_srate != ~scene0_prev_srate) or: ( ~scene0_bits != ~scene0_prev_bits ),{

									~scene0_groups[0].set(\srate, ~scene0_srate, \bits, ~scene0_bits);
									~scene0_groups[1].set(\srate, ~scene0_srate, \bits, ~scene0_bits);
							//});

						}, { srate = 48000; bits = 24;

							~scene0_groups[0].set(\srate, 48000, \bits, 24);
								~scene0_groups[1].set(\srate, 48000, \bits, 24);  });


						if ( ~flex_gates[3] == \open, {
							//if ( (~scene0_srate != ~scene0_prev_srate) or: ( ~scene0_bits != ~scene0_prev_bits ),
								//{

									~scene0_groups[2].set(\srate, ~scene0_srate, \bits, ~scene0_bits);
									~scene0_groups[3].set(\srate, ~scene0_srate, \bits, ~scene0_bits);
							//});

						}, { srate = 48000; bits = 24;

							    ~scene0_groups[2].set(\srate, 48000, \bits, 24);
								~scene0_groups[3].set(\srate, 48000, \bits, 24);  });

						0.1.wait; }; }).play;


					~scene0_retrig_routine = Routine({inf.do{ var length, break;
						~scene0_buses[0].get{|item| ~scene0_rates[0] = item; };
						~scene0_buses[1].get{|item| ~scene0_startpos = item; };
						~scene0_buses[2].get{|item| ~scene0_looprange = item; };
						~scene0_buses[3].get{|item| ~scene0_overlap = item; };
						~scene0_buses[4].get{|item| ~scene0_rates[1] = item; };
						~scene0_buses[5].get{|item| ~scene0_rates[2] = item; };
						~scene0_buses[6].get{|item| ~scene0_rates[3] = item; };
                        //("loop_range : "++~scene0_looprange).postln;
						~scene0_groups[0].set(\t_trig, 1, \rate,~scene0_rates[0],\startpos, ~scene0_startpos, \looprange, ~scene0_looprange,\overlap,~scene0_overlap);
				        ~scene0_groups[1].set(\t_trig, 1, \rate,~scene0_rates[1],\startpos, ~scene0_startpos, \looprange, ~scene0_looprange,\overlap,~scene0_overlap);
						~scene0_groups[2].set(\t_trig, 1, \rate,~scene0_rates[2],\startpos, ~scene0_startpos, \looprange, ~scene0_looprange,\overlap,~scene0_overlap);
				        ~scene0_groups[3].set(\t_trig, 1, \rate,~scene0_rates[3],\startpos, ~scene0_startpos, \looprange, ~scene0_looprange,\overlap,~scene0_overlap);

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
					\trateBus, ~scene1_buses[2].index, \durBus,~scene1_buses[3].index,\durmod_index_bus,	~scene1_buses[11].index,
					\posBus, ~scene1_buses[1].index, \rateBus, ~scene1_buses[0].index, \ampBus,~scene1_buses[4].index,
						\transposeBus, ~scene1_buses[8].index,
						\gen_index_bus, ~scene1_buses[7].index,
						\out, ~allpassBus, \mainVolume, if ( ~flex_gates[0]  == \open, { 1 } , { 0 }); ],~scene1_groups[0] );

					Synth(\buf_grain_double, [\bufnum, ~radio_samples[0], \envbuf, ~hanning_env,
					\trateBus, ~scene1_buses[2].index, \durBus,~scene1_buses[3].index, \durmod_index_bus,	~scene1_buses[11].index,
						\mainVolume, if ( ~flex_gates[1]  == \open, { 1 } , { 0 }); ,
					\posBus, ~scene1_buses[1].index, \rateBus, ~scene1_buses[5].index, \ampBus,~scene1_buses[4].index,
						\transposeBus, ~scene1_buses[9].index,
						\gen_index_bus, ~scene1_buses[7].index,
						\out, ~allpassBus ],~scene1_groups[1] );

					Synth(\buf_grain_double_high, [\bufnum, ~radio_samples[2], \envbuf, ~hanning_env,
					\trateBus, ~scene1_buses[2].index, \durBus,~scene1_buses[3].index, \durmod_index_bus,	~scene1_buses[11].index,
						\mainVolume, if ( ~flex_gates[3] == \open, { 1 } , { 0 }); ,
					\posBus, ~scene1_buses[1].index, \rateBus, ~scene1_buses[6].index, \ampBus,~scene1_buses[4].index,
						\gen_index_bus, ~scene1_buses[7].index,
						\transposeBus, ~scene1_buses[10].index,
						\out, 0],~scene1_groups[2] );

					~scene1doubler_check = Routine({inf.do{
						 if ( ~flex_gates[0] == \open, { ~scene1_groups[0].set(\mainVolume,1);  } , { ~scene1_groups[0].set(\mainVolume,0);  });
					    if ( ~flex_gates[1] == \open, { ~scene1_groups[1].set(\mainVolume,1);  } , { ~scene1_groups[1].set(\mainVolume,0);  });
						if ( (~flex_gates[2] == \open) or: (~flex_gates[3] == \open), { ~scene1_groups[2].set(\mainVolume, 1);  });
						if ( ~flex_gates[2] == \closed, { if ( ~flex_gates[3] == \closed, {  ~scene1_groups[2].set(\mainVolume,0); });  });

						0.1.wait; }; }).play;


					}
					{ ~scene == 2 }
					{
					   ~scene2_durcheck_routine = Routine({ inf.do{
						         ~scene2_buses[5].get{|item| ~scene2_dur = item};
						0.1.wait; }; }).play;

						~scene2_grain_routine = Routine({ inf.do{ var dur = 1, overlap=rrand(1,0.2), mix1=0, mix2=0, mix3=0, mix4=0;

							if (  ~fingers_amount[0] < 2, { mix1 = 0; }, {
							mix1 = rrand(0.5, 1.0);
							});
						    if (  ~fingers_amount[1] < 2, { mix2 = 0; }, {
							mix2 = rrand(0.5, 1.0);
							});
						    if (  ~fingers_amount[2] < 2, { mix3 = 0; }, {
							mix3 = rrand(0.5, 1.0);
							});
                            if (  ~fingers_amount[3] < 2, { mix4 = 0; }, {
							mix4 = rrand(0.5, 1.0);
							});


						if ( ~global_freeze == \off, {
							if ( ~flex_gates[0] == \open, {
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,0.75,\bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[0].index, \posBus, ~scene2_buses[4].index,\mix, mix1,
								\ratemod_index_bus, ~scene2_buses[6].index, \minFreq, 0.15, \maxFreq, 8,
								\out,~graineq_bus ], ~synthGroup); });
							if ( ~flex_gates[1] == \open, {
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,0.25,\bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[1].index, \posBus, ~scene2_buses[4].index,\mix, mix2,
									\ratemod_index_bus, ~scene2_buses[7].index, \minFreq, 8, \maxFreq, 30.0,
								\out,~graineq_bus ], ~synthGroup); });
							if ( ~flex_gates[2] == \open, {
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,-0.25, \bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[2].index, \posBus, ~scene2_buses[4].index,\mix, mix3,
									\ratemod_index_bus, ~scene2_buses[8].index, \minFreq, rrand(50,80), \maxFreq, rrand(100, 1000),
								\out,~graineq_bus ], ~synthGroup); });
							if ( ~flex_gates[3] == \open, {
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,-0.75, \bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[3].index, \posBus, ~scene2_buses[4].index, \mix, mix4,
								\ratemod_index_bus, ~scene2_buses[9].index,  \minFreq, rrand(80,100), \maxFreq, rrand(500, 3000),
								\out,~graineq_bus ], ~synthGroup); });
						}, {
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,0.75,\bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[0].index, \posBus, ~scene2_buses[4].index,\mix, mix1,
								\ratemod_index_bus, ~scene2_buses[6].index, \minFreq, 0.15, \maxFreq, 8,
								\out,~graineq_bus ], ~synthGroup);
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,0.25,\bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[1].index, \posBus, ~scene2_buses[4].index, \mix, mix2,
								\ratemod_index_bus, ~scene2_buses[7].index, \minFreq, 8, \maxFreq, 30.0,
								\out,~graineq_bus ], ~synthGroup);
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,-0.25, \bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[2].index, \posBus, ~scene2_buses[4].index, \mix, mix3,
								\ratemod_index_bus, ~scene2_buses[8].index,  \minFreq, rrand(50,80), \maxFreq, rrand(100, 1000),
								\out,~graineq_bus ], ~synthGroup);
								Synth(\radio_sampler, [\amp,0.5,\envbuf, ~hanning_env, \pan,-0.75, \bufnum, ~radio_samples[5],\dur,~scene2_dur,
									\rateBus, ~scene2_buses[3].index, \posBus, ~scene2_buses[4].index,\mix, mix4,
								\ratemod_index_bus, ~scene2_buses[9].index, \minFreq, rrand(80,100), \maxFreq, rrand(500, 3000),
								\out,~graineq_bus ], ~synthGroup);
							});

						});

							~scene2_dur.wait;
					}; }).play(~scene2_clock);

					}
					{ ~scene == 3 }
					{
					/*
					 ~scene3_durcheck_routine = Routine({ inf.do{
						~scene3_buses[5].get{|item| ~scene3_durs[0] = item};
						~scene3_buses[6].get{|item| ~scene3_durs[1] = item};
						~scene3_buses[7].get{|item| ~scene3_durs[2] = item};
						~scene3_buses[8].get{|item| ~scene3_durs[3] = item};
						0.1.wait; }; }).play;
					*/

						~scene3_pat1_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[4], transpose;
						5.do{|i| var pan = [-1.0, 0.5, 0, 0.5, 1.0];
							if (  ~fingers_amount[0] < 2, { transpose = 1; }, {
								transpose = [-1.99,-4.02,-7.99,-16].choose;
							});



							//~scene2_dur.postln;
						if ( ~global_freeze == \off, {
							if ( ~flex_gates[0] == \open, {
									Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene3_durs[0][i],
										\rate, ~scene3_rates[0][~scene3_melody_selector][i]*transpose, \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,0.75,\bufnum, sample,\dur,~scene3_durs[0][i],
									\rate, ~scene3_rates[0][~scene3_melody_selector][i]*transpose, \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene3_durs[0][i].wait;
						};
					}; }).play(~scene3_clocks[0]);

					~scene3_pat2_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[4], transpose;
						5.do{|i| var pan = [1.0, 0.5, 0, -0.5, -1.0];

							if (  ~fingers_amount[1] < 2, { transpose = 1; }, {
								transpose = [-1.99,-4.02,-7.99].choose;
							});
						//~scene2_dur.postln;
						if ( ~global_freeze == \off, {
							if ( ~flex_gates[1] == \open, {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene3_durs[1][i],
									\rate, ~scene3_rates[1][~scene3_melody_selector][i]*transpose, \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene3_durs[1][i],
									\rate, ~scene3_rates[1][~scene3_melody_selector][i]*transpose, \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene3_durs[1][i].wait;
							};
					}; }).play(~scene3_clocks[1]);

					~scene3_pat3_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[4],transpose;
						5.do{|i| var pan = [0.5, 0.25, 0, -0.25, -0.5];

							if (  ~fingers_amount[2] < 2, { transpose = 1; }, {
								transpose = [-0.48,-1.99,-4.02].choose;
							});
						//~scene2_dur.postln;
						if ( ~global_freeze == \off, {
							if ( ~flex_gates[2] == \open, {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene3_durs[2][i],
									\rate, ~scene3_rates[2][~scene3_melody_selector][i]*transpose,  \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene3_durs[2][i],
									\rate, ~scene3_rates[2][~scene3_melody_selector][i]*transpose, \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene3_durs[2][i].wait;
						};
					}; }).play(~scene3_clocks[2]);

					~scene3_pat4_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[4],transpose;
						5.do{|i| var pan = [-0.5, -0.25, 0, 0.25, -0.5];

							if (  ~fingers_amount[3] < 2, { transpose = 1; }, {
								transpose = [-0.25,-0.48,-1.99,-4.02].choose;
							});
						//~scene2_dur.postln;
						if ( ~global_freeze == \off, {
							if ( ~flex_gates[3] == \open, {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene3_durs[3][i],
									\rate, ~scene3_rates[3][~scene3_melody_selector][i]*transpose,  \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum,sample,\dur,~scene3_durs[3][i],
									\rate, ~scene3_rates[3][~scene3_melody_selector][i]*transpose,  \posBus, ~scene3_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene3_durs[3][i].wait;
						};
					}; }).play(~scene3_clocks[3]);

					}
					{ ~scene == 4 }
					{

					if ( ~debug, { "start scene 4 patterns".postln; });

						~scene4_pat1_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[6], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
						8.do{|i| var pan = [-1.0, 0.5, 0, 0.5, 1.0];

							if ( ~fingers_amount[0] < 2, { transpose=1; dur_divide=1; }, { transpose = [ 2,4,8,16].choose; dur_divide=rrand(0.24,0.27); });

						//~scene2_dur.postln;
						if ( ~global_freeze == \off, {

								if ( ~flex_gates[0] == \open, {
									Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,pan[i],\bufnum, sample,
										\dur,durs[0][i]*0.9*dur_divide,
										\rate, rates[0][~scene3_melody_selector][i]*transpose, \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,0.75,\bufnum, sample,\dur,durs[0][i]*0.9*dur_divide,
									\rate, rates[0][~scene3_melody_selector][i]*transpose, \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
							});
							durs[0][i].wait;
						};
					}; }).play(~scene4_clocks[0]);

					~scene4_pat2_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[3], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
						8.do{|i| var pan = [1.0, 0.5, 0, -0.5, -1.0];
						//~scene2_dur.postln;
							if ( ~fingers_amount[1] < 2, { transpose=1; dur_divide=1; }, { transpose = [ 2,4,8].choose; dur_divide=rrand(0.24,0.27); });

						if ( ~global_freeze == \off, {
							if ( ~flex_gates[1] == \open, {
								Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,pan[i],\bufnum, sample,\dur,durs[1][i]*0.9*dur_divide,
									\rate, rates[1][~scene4_melody_selector][i]*transpose, \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,pan[i],\bufnum, sample,\dur,durs[1][i]*0.9*dur_divide,
									\rate, rates[1][~scene4_melody_selector][i]*transpose, \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
							});
							durs[1][i].wait;
							};
					}; }).play(~scene4_clocks[1]);

					~scene4_pat3_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[3], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
						8.do{|i| var pan = [0.5, 0.25, 0, -0.25, -0.5];
						//~scene2_dur.postln;
							if ( ~fingers_amount[2] < 2, { transpose=1; dur_divide=1; }, { transpose = [ 2,4,8].choose; dur_divide=rrand(0.24,0.27); });

						if ( ~global_freeze == \off, {
							if ( ~flex_gates[2] == \open, {
								Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,pan[i],\bufnum, sample,\dur,durs[2][i]*0.9*dur_divide,
									\rate, rates[2][~scene4_melody_selector][i]*transpose,  \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,pan[i],\bufnum, sample,\dur,durs[2][i]*0.9*dur_divide,
									\rate, rates[2][~scene4_melody_selector][i]*transpose, \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
							});
							durs[2][i].wait;
						};
					}; }).play(~scene4_clocks[2]);

					~scene4_pat4_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[3], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
						8.do{|i| var pan = [-0.5, -0.25, 0, 0.25, -0.5];
						//~scene2_dur.postln;
							if ( ~fingers_amount[3] < 2, { transpose=1; dur_divide=1; }, { transpose = [ 2,4,8].choose; dur_divide=rrand(0.24,0.27); });

						if ( ~global_freeze == \off, {
							if ( ~flex_gates[3] == \open, {
								Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,pan[i],\bufnum, sample,\dur,durs[3][i]*0.9*dur_divide,
									\rate, rates[3][~scene4_melody_selector][i]*transpose,  \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,2,\envbuf, ~welch_env, \pan,pan[i],\bufnum,sample,\dur,durs[3][i]*0.9*dur_divide,
									\rate, rates[3][~scene4_melody_selector][i]*transpose,  \posBus, ~scene4_buses[4].index, \out,~filtBus ], ~synthGroup); });
							});
							durs[3][i].wait;
						};
					}; }).play(~scene4_clocks[3]);


					};


			});
		}, {

			if ( ~synth_gates[~scene] == \on, {

				case
				{ ~scene == 0 } {
					if ( ~global_freeze == \off, {

					~scene0_groups.do{|item| item.set(\gate,0); };
					~scene0_retrig_routine.stop;
					~scene0_bitcrush_routine.stop;
					});
				}
				{ ~scene == 1 } {
					if ( ~global_freeze == \off, {



				~scene1_groups[0].set(\gate,0);
				~scene1_groups[1].set(\gate,0);
				~scene1_groups[2].set(\gate,0);
				//~scene1doubler_group.set(\gate,0);
				//~scene1doublerhigh_group.set(\gate,0);
				~scene1doubler_check.stop;
					});
					   }
				{ ~scene == 2 } {
				~scene2_grain_routine.stop;
				~scene2_durcheck_routine.stop;
					}
                { ~scene == 3 } {
					~scene3_pat1_grain_routine.stop;
					~scene3_pat2_grain_routine.stop;
					~scene3_pat3_grain_routine.stop;
					~scene3_pat4_grain_routine.stop;
					   }
				{ ~scene == 4 } {

					~scene4_pat1_grain_routine.stop;
					~scene4_pat2_grain_routine.stop;
					~scene4_pat3_grain_routine.stop;
					~scene4_pat4_grain_routine.stop;


				};
				if ( ~debug, { "synth off".postln; });
			~synth_gates[~scene] = \off;
			});

		});
		0.01.wait; }; }).play;

~transpose_gates = [0,0];
~transpose_gates_scene1 = [0,0,0,0];
~transpose_gates_scene3 = [0,0,0,0];
~transpose_gates_scene4 = [0,0,0,0];


~fingers_amount = [0,0,0,0];



	~henon_buses = Array.fill( 4, { Bus.control(s, 1); });
	{ Out.kr(~henon_buses[0], Henon2DC.kr(minfreq: 500, maxfreq: 3000, mul: 2, add: 4 );  ); }.play(s);
	{ Out.kr(~henon_buses[1], Henon2DC.kr(minfreq: 50, maxfreq: 300, mul: 0.8, add: 2 );  ); }.play(s);
	{ Out.kr(~henon_buses[2], Henon2DC.kr(minfreq: 5, maxfreq: 30, mul: 0.4, add: 1 );  ); }.play(s);
    { Out.kr(~henon_buses[3], Henon2DC.kr(minfreq: 0.5, maxfreq: 13, mul: 0.2, add: 0.25 );  ); }.play(s);




	~ratemodRoutine = Routine({
		inf.do{
		   case
		{ ~scene == 2 } {
			if ( ~fingers_amount[0] == 2, {

						~henon_buses[0].get{|i| ~scene2_buses[6].set(i); };


				});
				if ( ~fingers_amount[0] < 2, {
					~scene2_buses[6].set(0);

				});

				if ( ~fingers_amount[1] == 2, {

						~henon_buses[1].get{|i| ~scene2_buses[7].set(i); };


				});
				if ( ~fingers_amount[1] < 2, {
					~scene2_buses[7].set(0);

				});

				if ( ~fingers_amount[2] == 2, {

						~henon_buses[2].get{|i| ~scene2_buses[8].set(i); };


				});
				if ( ~fingers_amount[2] < 2, {
					~scene2_buses[8].set(0);

				});

				if ( ~fingers_amount[3] == 2, {

						~henon_buses[3].get{|i| ~scene2_buses[9].set(i); };


				});
				if ( ~fingers_amount[3] < 2, {
					~scene2_buses[9].set(0);

				});
		};

	   0.1.wait;

	};
	}).play;

OSCdef(\trillflex1, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
		//msg[6].postln;
		   ~fingers_amount[0] = fingers;

		if ( ~fingers_amount[0] == 2, {

			case
			{ ~scene == 0 } {
		    if ( ~transpose_gates[0] == 0, {
					if ( ~debug, { "open transpose gate".postln; });
				~effectGroups[0].set(\mix, 0.5);
				~scene0_buses[8].set( [1.98, 2.01,3.97, 8.03].choose; );
				~scene0_buses[9].set( [1.98, 2.01,3.97, 8.03].choose; );
				~transpose_gates[0] = 1;


			});  }
			{ ~scene == 1 } {
				if ( ~transpose_gates_scene1[0] == 0, {
					if ( ~debug, { "open transpose gate scene 1".postln; });
				~scene1_buses[8].set( [1.98, 2.01,3.97].choose; );
				~effectGroups[1].set(\mix, 0.7, \dec, 8);

					~scene1_groups[1].set( \out,0 );
					    ~scene1_groups[2].set( \out,0 );

				~transpose_gates_scene1[0] = 1;
					~scene1_buses[11].set(1);
				});
			}
		{ ~scene == 2 } {

			//~scene2_buses[6].set(~latoo_ratemod_spec.map(msg[6]));
			//	~effectGroups[2].set(\mix, 0.75);

		}
			{ ~scene == 3 } {

			if ( ~transpose_gates_scene3[0] == 0, {

				~scene3_clocks[0].tempo = 1.2;
				~effectGroups[3].set(\mix, rrand(0.3, 0.5));
					~transpose_gates_scene3[0] = 1 });
			}
			{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[0] == 0, {

					~scene4_clocks[0].tempo = 3.2;
					~transpose_gates_scene4[0] = 1;
					~effectGroups[4].set(\mix, 0.05, \modFreq, rrand(1.0,5.0) );
				});

			};


		});

		if ( ~fingers_amount[0] < 2, {

			case
			{ ~scene == 0 } {

				if ( ~transpose_gates[0] == 1, { 	if ( ~debug, { "close transpose gate".postln; });
				~effectGroups[0].set(\mix, 0.0);
					~scene0_buses[8].set(1);
				     ~scene0_buses[9].set(1);
				~transpose_gates[0] = 0;
			     });
			}
			{ ~scene == 1 }
			{
				if ( ~transpose_gates_scene1[0] == 1, { 	if ( ~debug, { "close transpose gate".postln; });
					~effectGroups[1].set(\mix, 0.25, \dec, 2);
					~scene1_buses[8].set( 1 );

					~scene1_groups[1].set( \out,0 );
					    ~scene1_groups[2].set( \out,0 );


					~transpose_gates_scene1[0] = 0;
					~scene1_buses[11].set(0);
				});

			}
		{ ~scene == 2 } {

		//~scene2_buses[6].set(0);
		//~effectGroups[2].set(\mix, 0.1);


		}
			{ ~scene == 3 } {

				if ( ~transpose_gates_scene3[0] == 1, {
				~scene3_clocks[0].tempo = 0.6;
				~effectGroups[3].set(\mix,0.05);
					~transpose_gates_scene3[0]  = 0; });

			}
			{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[0] == 1, {


					~effectGroups[4].set(\mix, 0.025,  \modFreq, rrand(0.01,0.05) );

					~scene4_clocks[0].tempo = 0.8;
					~transpose_gates_scene4[0] = 0; });

			};


		});



			if ( fingers > 0, {
			     ~all_fingers.put(0,1);
			if ( ~flex_gates[0] == \closed, { ~flex_gates[0] = \open; });

		     }, { ~all_fingers.put(0,0);

				if ( ~flex_gates[0] == \open, { ~flex_gates[0] = \closed; });
		});


			if ( fingers > 3, {
					if ( ~grainFreezeSwitch == 0, {
						if ( ~grainFreeze == 0, {
					~grainFreeze = 1; ~grainFreezeSwitch = 1; 	if ( ~debug, { "grainfreeze on".postln; });

						}, {
					~grainFreeze = 0; ~grainFreezeSwitch = 1; 	if ( ~debug, { "grainfreeze off".postln; });
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
					~scene0_buses[2].set(~looprangeSpec.map(x_val); );
					~scene0_bits = ~scene0_bitSpec.map(x_val);
				}
				{ ~scene == 1 } {
					~scene1_buses[2].set(~trateSpec.map(x_val) );
					~scene1_buses[3].set(~durSpec.map(x_val));
					~scene1_buses[4].set(~grainAmpSpec.map(x_val));
				}
				{ ~scene == 2 } {

					~scene2_buses[4].set(~sc2_posSpec.map(x_val); );
					//~scene2_buses[2].set(~overlapSpec.map(msg[4].postln; ));

					//~scene2_buses[0].set(~micro_tuning_scene2.wrapAt(~tuning_map.map(msg[4])));

				}
				{ ~scene == 3 } {

					~scene3_durs[0] = ~scene3_rhythm * ~sc3_dur_index1_spec.map(msg[4]);
					~scene3_durs[1] = ~scene3_rhythm * ~sc3_dur_index2_spec.map(msg[4]);
					~scene3_durs[2] = ~scene3_rhythm * ~sc3_dur_index3_spec.map(msg[4]);
					~scene3_durs[3] = ~scene3_rhythm * ~sc3_dur_index4_spec.map(msg[4]);
					//~scene2_buses[2].set(~overlapSpec.map(msg[4].postln; ));
					//~scene3_buses[0].set(~micro_tuning_scene2.wrapAt(~tuning_map.map(msg[4])));

				}
				{ ~scene == 4 } {

					~scene4_durs[0] = ~scene4_rhythm1 * ~sc4_dur_index1_spec.map(msg[4]);
					~scene4_durs[1] = ~scene4_rhythm2 * ~sc4_dur_index2_spec.map(msg[4]);
					~scene4_durs[2] = ~scene4_rhythm3 * ~sc4_dur_index3_spec.map(msg[4]);
					~scene4_durs[3] = ~scene4_rhythm4 * ~sc4_dur_index4_spec.map(msg[4]);
					//~scene2_buses[2].set(~overlapSpec.map(msg[4].postln; ));
					//~scene3_buses[0].set(~micro_tuning_scene2.wrapAt(~tuning_map.map(msg[4])));

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

		   ~fingers_amount[1] = fingers;

		if ( ~fingers_amount[1] == 3, {

			case
				{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[1] == 0, {

					~scene4_clocks[1].tempo = 4.8;
					~transpose_gates_scene4[1] = 1;
						~effectGroups[4].set(\mix, 0.085, \modFreq, rrand(0.25,1.5) );


				});

			};

		});

		if ( ~fingers_amount[1] == 2, {

			case
			{ ~scene == 0 } {

			  if ( ~transpose_gates[1] == 0, {
					if ( ~debug, { "open transpose gate".postln; });
				~scene0_buses[10].set( [0.48, 0.33, 0.248].choose; );
				~scene0_buses[11].set( [0.51, 0.33, 0.251, ].choose; );
				~transpose_gates[1] = 1;
			 });
			}
			{ ~scene == 1 } {
				if ( ~transpose_gates_scene1[1] == 0, {
					if ( ~debug, { "open transpose gate scene 1".postln; });
				~scene1_buses[9].set( [1.98, 2.01,3.97].choose; );
				~effectGroups[1].set(\mix, 0.75, \dec, 8);
					~scene1_groups[1].set( \out,0 );
					~scene1_groups[2].set( \out,0 );
				~transpose_gates_scene1[1] = 1;
					~scene1_buses[11].set(1);
				});
			}

			{ ~scene == 2 } {
			//~scene2_buses[7].set(~latoo_ratemod_spec.map(msg[4]));
				//~effectGroups[2].set(\mix, 0.75);


		}
		{ ~scene == 3 } {
				if ( ~transpose_gates_scene3[1] == 0, {
				~scene3_clocks[1].tempo = 1.2;
				~effectGroups[3].set(\mix,rrand(0.3, 0.6) );
					~transpose_gates_scene3[1] = 1; });
			}
			{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[1] == 0, {

					~scene4_clocks[1].tempo = 3.2;
					~transpose_gates_scene4[1] = 1;
						~effectGroups[4].set(\mix, 0.015, \modFreq, rrand(2.5,7.5) );


				});

			};



		     });

			if ( ~fingers_amount[1] < 2, {

			case
			{ ~scene == 0 } {
				if ( ~transpose_gates[1] == 1, { 	if ( ~debug, { "close transpose gate".postln; });

				~scene0_buses[10].set(1);
				~scene0_buses[11].set(1);
				~transpose_gates[1] = 0;
			     });
			}
			{ ~scene == 1 } {

				if ( ~transpose_gates_scene1[1] == 1, { 	if ( ~debug, { "close transpose gate".postln; });
					~effectGroups[1].set(\mix, 0.25, \dec, 2);
						~scene1_groups[1].set( \out,0 );
					    ~scene1_groups[2].set( \out,0 );

					~scene1_buses[8].set( 1 );
					~transpose_gates_scene1[1] = 0;
						~scene1_buses[11].set(0);
				});

			}
			{ ~scene == 2 } {
			//~scene2_buses[7].set(0);
					//~effectGroups[2].set(\mix, 0.1);
		}
		{ ~scene == 3 } {
				if ( ~transpose_gates_scene3[1] == 1, {
				~scene3_clocks[1].tempo = 0.6;
				~effectGroups[3].set(\mix,0.05 );
					~transpose_gates_scene3[1] = 0; });
			}
			{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[1] == 1, {

					~scene4_clocks[1].tempo = 0.8;

					~effectGroups[4].set(\mix, 0.0,  \modFreq, rrand(0.01,0.05) );

					~transpose_gates_scene4[1] = 0;

				});

			};

		});




		     if ( fingers < 1, {
	        });
			if ( fingers > 0, {
			~all_fingers.put(1,1);
			if ( ~flex_gates[1] == \closed, { ~flex_gates[1] = \open; });

		     }, { ~all_fingers.put(1,0);
			if ( ~flex_gates[1] == \open, {
				~flex_gates[1]  = \closed; 	if ( ~debug, { "doubler off".postln; });
		}); });

			if ( fingers > 1, {
			});
			if ( fingers > 2, {
				//~stereoverb_synth.set(\mix, msg[8]);

		});
			if ( fingers > 3, {
					if ( ~grainFreezeSwitch2 == 0, {
						if ( ~grainFreeze2 == 0, {
					~grainFreeze2 = 1; ~grainFreezeSwitch2 = 1; 	if ( ~debug, { "grainfreeze on".postln; });

						}, {
					~grainFreeze2 = 0; ~grainFreezeSwitch2 = 1; 	if ( ~debug, { "grainfreeze off".postln; });
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
					~scene0_buses[1].set(~startPosSpec.map(msg[4]); );
					~scene0_buses[3].set( ~overlapSpec.map(msg[4]); );
					~scene0_srate = ~scene0_srateSpec.map(msg[4]);
					//if ( ~doubler == \on, {
					//~scene0_buses[4].set(~micro_tuning_low.wrapAt(~tuning_map.map(msg[4])));
					//});

				}
				{ ~scene == 1 }  {

					~scene1_buses[1].set(~grainPosSpec.map(msg[4]; ));
					~scene1_buses[0].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));
					~scene1_buses[7].set(~gendy_index_spec.map(msg[4]); );



				}
					{ ~scene == 2 }  {
					//~scene2_clock.tempo = ~sc2_clock_arr.wrapAt(~sc2_clockindex.map(msg[4]) );
					~scene2_buses[5].set( ~sc2_dur_arr.wrapAt(~sc2_durindex.map(msg[4]) ));
					//~scene2_buses[1].set(~micro_tuning_scene2.wrapAt(~tuning_map.map(msg[4])));

				}
				{ ~scene == 3 }  {


					~scene3_buses[4].set(~sc2_posSpec.map(msg[4]); );

						//~scene3_durs[0] = ~scene3_rhythm * ~sc3_dur_index1_spec.map(msg[4]);
					    //~scene3_durs[1] = ~scene3_rhythm * ~sc3_dur_index2_spec.map(msg[4]);
	                    //~scene3_durs[2] = ~scene3_rhythm * ~sc3_dur_index3_spec.map(msg[4]);
	                    //~scene3_durs[3] = ~scene3_rhythm * ~sc3_dur_index4_spec.map(msg[4]);


				}
				{ ~scene == 4 }
				{

					~scene4_buses[4].set(~sc2_posSpec.map(msg[4]); );



				};





			    });
			});

		}, '/flex2');




OSCdef(\trillflex3, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];


			   ~fingers_amount[2] = fingers;


		if ( ~fingers_amount[2] == 2, {

			case
			{ ~scene == 0 } {


			}
			{ ~scene == 1 } {
				if ( ~transpose_gates_scene1[2] == 0, {
					"open transpose gate scene 1".postln;
				//~scene1_buses[9].set( [1.98, 2.01,3.97].choose; );
				//~effectGroups[1].set(\mix, 0.75, \dec, 8);
					//~scene1_groups[1].set( \out,0 );
					//~scene1_groups[2].set( \out,0 );
					~scene1_buses[11].set(rrand(1,2) );
					~scene1_buses[7].set(rrand(0.5,2.0));
				~transpose_gates_scene1[2] = 1;

				});
			}
		{ ~scene == 2 } {
			//~scene2_buses[8].set(~latoo_ratemod_spec.map(msg[4]));

				//~effectGroups[2].set(\mix, 0.75);

		}
		{ ~scene == 3 } {
				if ( ~transpose_gates_scene3[2] == 0, {
				~scene3_clocks[2].tempo = 1.2;
				~effectGroups[3].set(\mix,rrand(0.3,0.7) );
					~transpose_gates_scene3[2] = 1; });
			}
		{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[2] == 0, {

					~scene4_clocks[2].tempo = 3.2;
						~effectGroups[4].set(\mix, 0.1, \modFreq, rrand(10.0,15.0) );

					~transpose_gates_scene4[2] = 1; });

			};

		     });

		if ( ~fingers_amount[2] < 2, {
			case
			{ ~scene == 0 } {


			}
			{ ~scene == 1 } {
					if ( ~transpose_gates_scene1[2] == 1, {
					if ( ~debug, { "close transpose gate scene 1".postln; });
					     ~scene1_buses[11].set(0);
					~scene1_buses[7].set(0);
						~transpose_gates_scene1[2] = 0;
				});
			}

			{ ~scene == 2 } {
			//~scene2_buses[8].set(0);
				//	~effectGroups[2].set(\mix, 0.1);
		}
		{ ~scene == 3 } {
					if ( ~transpose_gates_scene3[2] == 1, {
				~scene3_clocks[2].tempo = 0.6;
					~effectGroups[3].set(\mix,0.05);
					~transpose_gates_scene3[2] = 0; });
			}
		{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[2] == 1, {

					~scene4_clocks[2].tempo = 0.8;

					~effectGroups[4].set(\mix, 0.025,  \modFreq, rrand(0.01,0.05) );
					~transpose_gates_scene4[2] = 0; });

			};

		});

				if ( fingers > 0, {
			     ~all_fingers.put(2,1);
			     if ( ~flex_gates[2] == \closed, { ~flex_gates[2] = \open; });
		     }, { ~all_fingers.put(2,0);


				if ( ~flex_gates[2] == \open, { ~flex_gates[2] = \closed; });    });
			if ( fingers > 1, {


			   // "verb".postln;
                // ~stereoverb_synth.set(\mix, msg[4]);
				//~grainPosBus[2].set(~grainPosSpec.map(msg[6]));
			    //~grainpitchBus[2].set(~tone_collection.wrapAt(~tuner.map(msg[6])));
		   });

			if ( fingers > 2, {
				        });
			if ( fingers > 3, {
					if ( ~grainFreezeSwitch3 == 0, {
						if ( ~grainFreeze3 == 0, {
					~grainFreeze3 = 1; ~grainFreezeSwitch3 = 1; 	if ( ~debug, { "grainfreeze on".postln; });

						}, {
					~grainFreeze3 = 0; ~grainFreezeSwitch3 = 1; 	if ( ~debug, { "grainfreeze off".postln; }); }); }); });
			if ( fingers < 4, {
					if ( ~grainFreezeSwitch3 == 1, { ~grainFreezeSwitch3 = 0;   });
			});

			//msg.postln;
			if ( ~grainFreeze3 != 1, {
				if ( msg[4] > 0.05, {

				case
				{ ~scene == 0 } {
					~scene0_buses[0].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));
					~scene0_buses[4].set(~micro_tuning.wrapAt(~tuning_map_v2.map(msg[4])));
					//~scene0_buses[6].set(~micro_tuning.wrapAt(~tuning_map_v3.map(msg[4])));
				}
				{ ~scene == 1 } {
					~scene1_buses[5].set(~micro_tuning.wrapAt(~tuning_map.map(msg[4])));
					~scene1_buses[6].set(~micro_tuning.wrapAt(~tuning_map_v2.map(msg[4])));



				}
				{ ~scene == 2 } {


					~scene2_buses[0].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_first.map(msg[4])));
					~scene2_buses[1].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_second.map(msg[4])));
					~scene2_buses[2].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_third.map(msg[4])));
					~scene2_buses[3].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_four.map(msg[4])));


				}
				{ ~scene == 3 } {


					~scene3_melody_selector = ~scene3_melody_spec.map(msg[4]);

					//~scene3_buses[0].set(~eikosany_tuning.wrapAt(~sc3_tuningMap_first.map(msg[4])));
					//~scene3_buses[1].set(~eikosany_tuning.wrapAt(~sc3_tuningMap_second.map(msg[4])));
					//~scene3_buses[2].set(~eikosany_tuning.wrapAt(~sc3_tuningMap_third.map(msg[4])));
					//~scene3_buses[3].set(~eikosany_tuning.wrapAt(~sc3_tuningMap_four.map(msg[4])));



				}
				{ ~scene == 4 } {

						~scene4_melody_selector = ~scene4_melody_spec.map(msg[4]);

				};



			})

			});

		}, '/flex3');



OSCdef(\trillflex4, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];

		    ~fingers_amount[3] = fingers;

			if ( ~fingers_amount[3] == 2, {

			case
			{ ~scene == 0 } {


			}
			{ ~scene == 1 } {
				if ( ~transpose_gates_scene1[3] == 0, {
					if ( ~debug, { "open transpose gate scene 1".postln; });
				//~scene1_buses[9].set( [1.98, 2.01,3.97].choose; );
				//~effectGroups[1].set(\mix, 0.75, \dec, 8);
					//~scene1_groups[1].set( \out,0 );
					//~scene1_groups[2].set( \out,0 );
					~scene1_buses[11].set(rrand(1,2) );
					~scene1_buses[7].set(rrand(5.0,10.0) );
				~transpose_gates_scene1[3] = 1;

				});
			}
			{ ~scene == 2 } {
			//~scene2_buses[9].set(~latoo_ratemod_spec.map(msg[4]));
					//~effectGroups[2].set(\mix, 0.75);
		}
		{ ~scene == 3 } {
				if ( ~transpose_gates_scene3[3] == 0, {
				~scene3_clocks[3].tempo = 1.2;
				~effectGroups[3].set(\mix,rrand(0.3,0.7) );
					~transpose_gates_scene3[3] = 1; });
			}
		{ ~scene == 4 } {
				if ( ~transpose_gates_scene4[3] == 0, {

					~scene4_clocks[3].tempo = 3.2;
					~effectGroups[4].set(\mix, 0.15, \modFreq, rrand(15.0,20.0) );

					~transpose_gates_scene4[3] = 1; });

			};

		     });

		if ( ~fingers_amount[3] < 2, {
			case
			{ ~scene == 0 } {


			}
			{ ~scene == 1 } {
					if ( ~transpose_gates_scene1[3] == 1, {
					if ( ~debug, { "open transpose gate scene 1".postln; });
					     ~scene1_buses[11].set(0);
					~scene1_buses[7].set(0);
						~transpose_gates_scene1[3] = 0;
				});
			}
			{ ~scene == 2 } {
			//  ~scene2_buses[9].set(0);
				// ~effectGroups[2].set(\mix, 0.1);
			}
			{ ~scene == 3 } {
				if ( ~transpose_gates_scene3[3] == 1, {
				~scene3_clocks[3].tempo = 0.6;
				~effectGroups[3].set(\mix,0.05 );
					~transpose_gates_scene3[3] = 0; });
			}
			{ ~scene == 4 } {

				if ( ~transpose_gates_scene4[3] == 1, {

					~scene4_clocks[3].tempo = 0.8;
					~effectGroups[4].set(\mix, 0.025,  \modFreq, rrand(0.01,0.05) );
					~transpose_gates_scene4[3] = 0; });

			};

		});


			if ( fingers > 0, {
			     ~all_fingers.put(3,1);

			 if ( ~flex_gates[3] == \closed, { ~flex_gates[3] = \open; });

		     }, { ~all_fingers.put(3,0);


				if ( ~flex_gates[3] == \open, { ~flex_gates[3] = \closed; });
		});
			if ( fingers > 1, {
			//"verb".postln;
			  //~stereoverb_synth.set(\mix, msg[4]);
		});
			if ( fingers > 2, {

			 });

			if ( fingers > 3, {
					if ( ~grainFreezeSwitch4 == 0, {
						if ( ~grainFreeze4 == 0, {
					~grainFreeze4 = 1; ~grainFreezeSwitch4 = 1; 	if ( ~debug, { "grainfreeze on".postln; });

						}, {
					~grainFreeze4 = 0; ~grainFreezeSwitch4 = 1; 	if ( ~debug, { "grainfreeze off".postln; });
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
					//~scene0_buses[0].set(~micro_tuning_low.wrapAt(~tuning_map.map(msg[4])));
					~scene0_buses[5].set(~micro_tuning_low.wrapAt(~tuning_map_v2.map(msg[4])));
					~scene0_buses[6].set(~micro_tuning_low.wrapAt(~tuning_map_v3.map(msg[4])));


				}
				{ ~scene == 1 } {
					~scene1_buses[5].set(~micro_tuning_low_scene1.wrapAt(~tuning_map.map(msg[4])));
					~scene1_buses[6].set(~micro_tuning_low_scene1.wrapAt(~tuning_map_v2.map(msg[4])));
				}
				{ ~scene == 2 } {

					~scene2_buses[0].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_first.map(msg[4])));
					~scene2_buses[1].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_second.map(msg[4])));
					~scene2_buses[2].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_third.map(msg[4])));
					~scene2_buses[3].set(~pentatetra_tuning.wrapAt(~sc2_tuningMap_four.map(msg[4])));



					if ( ~global_freeze == \off, {


					},
					{

					});
				}
				{ ~scene == 3 } {

					 	~scene3_melody_selector = ~scene3_melody_spec.map(msg[4]);

					if ( ~global_freeze == \off, {

					},
					{

						//~scene3_clock.tempo = ~scene3_clockSpec.map(msg[4]);
						//~scene3_buses[5].set(~scene3_durSpec.map(msg[4]) );

					});

				}
				{ ~scene == 4 } {

					~scene4_melody_selector = ~scene4_melody_spec.map(msg[4]);
				};


			})

			});

		}, '/flex4');


~prev_scene = 0;



~b1_denoise_gate=\open;
~b2_denoise_gate=\open;

OSCdef(\craft_osc, {|msg| var button1, button2, b1_denoise_gate=\open, b2_denoise_gate=\open;
			//msg.postln;

		    button1 = msg[11+3];
			button2 = msg[18+3];

		    /* BUTTON 1`: FREEZE */
		     if ( button1 != 0, {
			if ( ~b1_denoise_gate == \open, { ~b1_denoise_gate = \closed; 	if ( ~debug, { "b1 gate closed".postln; });

				~trans_routine_low = Routine({
	20.do{ var dur = [0.2,0.6,0.33,0.1].choose;
		dur = dur * 0.05;
		Synth(\sine_short_low,[\freq, 1000 * ~pentatetra_tuning.choose, \rel, dur * rrand(1,1.5) ]);

		dur.wait; };
}).play;


				if ( ~global_freeze == \off, { ~global_freeze = \on; }, { ~global_freeze = \off; });
				if ( ~debug, { ("global freeze: "++~global_freeze).postln; });
				//fork{ b1_denoise_gate = \closed; "b1 gate closed".postln; 1.wait; b1_denoise_gate = \open; "b1 gate open".postln; };

			});
		}, {  if ( ~b1_denoise_gate == \closed, {  ~b1_denoise_gate = \open;  	if ( ~debug, { "b1 gate open".postln; }); }); });

		    /* BUTTON 2 : SCENE */
		    if ( button2 != 0, {
			~prev_scene = ~scene;
			if ( ~b2_denoise_gate == \open, { ~b2_denoise_gate = \closed; 	if ( ~debug, { "b2 gate closed".postln; });


				~trans_routine = Routine({
	20.do{ var dur = [0.2,0.6,0.33,0.1].choose;
		dur = dur * 0.05;
		Synth(\sine_short,[\freq, 3000 * ~pentatetra_tuning.choose, \rel, dur * rrand(1,1.5) ]);

		dur.wait; };
}).play;

			if (~scene != 4, { ~scene = ~scene + 1;  }, { ~scene = 0; });
			case
				{ ~scene == 0 } { ~effectGroups[4].set(\gate, 0); 	Synth(\stereo_verb, [\in, ~verbBus, \mix, 0.0], ~effectGroups[0], \addToTail); }
				{ ~scene == 1 } { ~effectGroups[0].set(\gate, 0); Synth(\allpassc, [\in, ~allpassBus, \mix, 0.1, \dec,2 ], ~effectGroups[1],\addToTail); }
				{ ~scene == 2 } { ~effectGroups[1].set(\gate, 0);  Synth(\grain_eq, [\in, ~graineq_bus,\rq,0.75,\boostfreq,500,\cutfreq,5000,\amp,1,\mix,0.1, \out, 0 ],  ~effectGroups[2], \addToTail ); }
				{ ~scene == 3 } { ~effectGroups[2].set(\gate, 0); Synth(\combc_new, [\in, ~combBus,\dec,0, \mix, 0.05], ~effectGroups[3],\addToTail); }
				{ ~scene == 4 } { ~effectGroups[3].set(\gate, 0); Synth(\filter, [\in, ~filtBus, \modfreq, 0.1,\mix,0.025], ~effectGroups[4], \addToTail); };










			if ( ~synth_gates[~prev_scene] == \on, {
				             case
				{ ~prev_scene == 0 } { ~grainbufGroup.set(\gate, 0);     }
				{ ~prev_scene == 1 } { ~grainbufGroup.set(\gate, 0);     }
				{ ~prev_scene == 2 } { ~grain_routine1.stop;   }
				{ ~prev_scene == 3 } {  ~grain_routine2.stop;  }
				{ ~prev_scene == 4 } {  ~grain_routine3.stop;  };
				~synth_gates[~prev_scene] = \off;
			                       });
				if ( ~debug, { ("scene "++~scene).postln; });
			});
		}, {    if ( ~b2_denoise_gate == \closed, {  ~b2_denoise_gate = \open;  	if ( ~debug, {  "b2 gate open".postln; });  });             });





			}, '/craft');




});












