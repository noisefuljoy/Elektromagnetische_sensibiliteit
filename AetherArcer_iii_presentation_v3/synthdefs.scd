"loading synthdefs".postln;

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
/*
SynthDef(\transition_sound, {|out=0 amp=0.4 bufnum rate=0.5 dur=4.0 attack=0.1 release=6.0|
		var gate, env, sig;
	    gate = EnvGen.kr(Env([1,0], [dur]),1);
	    env = EnvGen.ar(Env.adsr(attack, 0.0,1.0,release),gate, doneAction: 2);
		//rate = rate * Gendy1.kr(1,1,1,1,minFreq, maxFreq,mul:ratemod_index, add: 1);

		sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * 0,loop: 0);

		//sig = Decimator.ar(sig, rrand(5000,1000), Rand(2,4),mix, sig * (1-mix));
		Out.ar(out, Pan2.ar(sig*env*amp*2, 0)); }).store;
*/
SynthDef(\transition_sound, {|out=0 amp=0.8 bufnum rate=0.5 dur=2.0 attack=0.1 release=2.0|
		var gate, env, sig;
	    gate = EnvGen.kr(Env([1,0], [dur]),1);
	    env = EnvGen.ar(Env.adsr(attack, 0.05,1.0,release,curve: \sine),gate, doneAction: 2);
		//rate = rate * Gendy1.kr(1,1,1,1,minFreq, maxFreq,mul:ratemod_index, add: 1);

		//sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum),1, BufFrames.kr(bufnum) * 0,loop: 0);
	sig = BufRd.ar(1, bufnum,LFSaw.ar(Rand(3,13.0)) * BufFrames.ir(bufnum)) * env;
	sig = PitchShift.ar(sig, 0.2, Rand(0.125,0.5),0.1,0.3,0.75,sig*0.25);
	sig = AllpassC.ar(sig, 0.1,Rand(0.05,0.1),Rand(2,4),0.25, sig*0.75);
		//sig = Decimator.ar(sig, rrand(5000,1000), Rand(2,4),mix, sig * (1-mix));
		Out.ar(out, Pan2.ar(sig*amp*2, 0)); }).store;

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
		sigL_low = MoogFF.ar(sig[0], SinOsc.kr(LFNoise0.kr(0.2).range(modfreq*0.5,modfreq)).range(25, 900), 2);
		sigL_mid = MoogFF.ar(sig[0], SinOsc.kr(LFNoise0.kr(0.4).range(modfreq*0.25,modfreq*0.5),-0.25).range(900, 3000), 2);

		sigR_low = MoogFF.ar(sig[1], SinOsc.kr(LFNoise0.kr(0.4).range(modfreq*0.5,modfreq*2),-2pi).range(35, 1000), 2);
		sigR_mid = MoogFF.ar(sig[1], SinOsc.kr(LFNoise0.kr(0.1).range(modfreq*0.125,modfreq*0.25),pi).range(1000, 9000), 2);


		sigL = Mix([sigL_low, sigL_mid]);
		delsigL = sigL;
		3.do{|i|
			n = (i + 1) * 0.1;
			o = (i + 1) * 0.01;
			e = (i + 1) * 0.3;

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

SynthDef(\allpassc2, {|in out=0 delmod=0.001 dec=1 mix=0.4 gate=1|
		var env, sig,delsig;
		sig = In.ar(in, 2);

	delsig = Decimator.ar(sig, LFNoise0.kr(0.05).range(4000,15000),6);

		3.do{|i|
			n = (i + 1) * 0.1;
			o = (i + 1) * 0.3;
			e = (i + 1) * 8;

			delsig = AllpassC.ar(sig, 0.3, SinOsc.kr(delmod+o).range(0.01, n), e + dec, 1, delsig*0.9).tanh;
		};

		sig = (delsig * mix) + (sig * ( 1 - mix) );
	    sig = sig * 2;
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
