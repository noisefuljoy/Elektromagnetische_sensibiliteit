


s = Server.default;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
s.options.maxLogins = 4; // should match the settings on the remote sclang
s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server

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
s.options.belaMaxScopeChannels = 4; // allow to send some channels to the Bela scope

s.options.memSize = 8192*2; // the default is 8192 which is quite little
s.boot;

s.waitForBoot({

s = Server.default;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
s.options.maxLogins = 4; // should match the settings on the remote sclang
s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server

s.options.numDigitalChannels = 16;
s.options.pgaGainLeft = 10;     // sets the gain for the left audio input to 4 dB
s.options.pgaGainRight = 10;    // sets the gain for the left audio input to 5 dB
s.options.headphoneLevel = -6; // sets the headphone level to -6 dB
s.options.speakerMuted = 0;    // enable the speaker amp
s.options.dacLevel = 0;       // sets the gain of the dac to 0 dB
s.options.adcLevel = 0;       // sets the gain of the adc to 0 dB
s.options.numMultiplexChannels = 0; // do not enable multiplexer channels

s.options.blockSize = 512;
// number of audio channels: values greater than 2 will use the first few analog
// channels as audio channels.
// Any additional analog channels will be available through the AnalogIn/Out Ugens
// e.g.:
// s.options.numInputBusChannels = 4;
// means that bus in 0/1 are the audio L/R channels and 2/3 are the analog inputs 0/1
// analog inputs 2-7 will still be available through the AnalogIn Ugen.
s.options.numInputBusChannels = 2; // Use only the L/R audio channels
s.options.numOutputBusChannels = 2; // Use only the L/R audio channels
s.options.belaMaxScopeChannels = 4; // allow to send some channels to the Bela scope

s.options.memSize = 8192 * 16; // the default is 8192 which is quite little
s.boot;


//code for receiving external numpad
//"systemctl start ext_numpad".unixCmd;

//o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/key');
//n = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/key/released');

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


SynthDef(\rightarm, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x48;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var out, ping;
		//centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		centroids = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_updateTrill);

		SendReply.kr(Impulse.kr(10), "/rightarm", centroids);
	}).store;

SynthDef(\leftarm, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x4b;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var rawvals;
		var out, ping;
		centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		//rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_updateTrill);
		SendReply.kr(Impulse.kr(10), "/leftarm", centroids);
	}).store;

SynthDef(\rightleg, {|t_recalibrate=0.0 t_updateTrill=1.0|
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
		SendReply.kr(Impulse.kr(10), "/righleg", centroids);
	}).store;

SynthDef(\leftleg, {|t_recalibrate=0.0 t_updateTrill=1.0|
		var i2c_bus = 1;
		var i2c_address = 0x4a;
		var noiseThreshold = 0.045; // float: 0-0.0625, with 0.0625 being the highest noise thresh
		var prescalerOpt = 4; // int: 1-8 with 1 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(3); // use 3 touches
		var centroids;
		var rawvals;
		var out, ping;
		centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);
		//rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_updateTrill);
		SendReply.kr(Impulse.kr(10), "/leftleg", centroids);
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

SynthDef(\buf_grain, { |out, gate = 1, amp = 1.0, rateBus, trateBus,durBus,sndbuf,posBus,envbuf|
    var sig, pan, env, freqdev, rate, trate, dur, pos;
	trate = In.kr(trateBus, 1);
	dur = In.kr(durBus, 1);
	pos = In.kr(posBus, 1);
	rate = In.kr(rateBus, 1);

	pan = SinOsc.kr(LFNoise1.kr(0.4).range(13.0,50.0)).range(-1.0,1.0);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
	sig = GrainBuf.ar(2, Impulse.kr(trate), dur, sndbuf,
				LFNoise1.kr.range(0.4).range(0.99, 1.01) * rate * BufRateScale.kr(sndbuf),
					BufFrames.ir(sndbuf) * pos, 2, pan, envbuf);
    Out.ar(out, sig * 1.5 * env);
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




		2.0.wait;
/*for selecting scale */

/*TRILL SYNTHS */
//~trill_craft = Synth(\trillcraft);
~right_arm = Synth(\rightarm);
~left_arm = Synth(\leftarm);
~right_leg = Synth(\rightleg);
//~left_leg = Synth(\leftleg);

/* BUFFERS*/
//~toybox = Buffer.read(s, "/root/Bela/projects/craft_livecoding/Psalt_sound.wav");
//~sus = Buffer.read(s, "/root/Bela/projects/craft_livecoding/Sus_sound2.wav");
/*8 buffers voor links + 8 voor rechts met verschillende thresholds */


~craft_buffer_left = Buffer.readChannel(s, "/root/radiosamples/gqrx-sample-01-001.wav", channels: [0]);
~craft_buffer_right = Buffer.readChannel(s, "/root/radiosamples/gqrx-sample-01-002.wav", channels:[0]);
~radiosample3 = Buffer.readChannel(s, "/root/radiosamples/gqrx-sample-01-003.wav", channels: [0]);
~radiosample4 = Buffer.readChannel(s, "/root/radiosamples/gqrx-sample-01-004.wav", channels:[0]);


//~craft_buffer_left = Buffer.alloc(s, 22050*1, 1);
//~craft_buffer_right = Buffer.alloc(s, 22050*2, 1);

~craft_fftbuf_left = Buffer.alloc(s, 512);
~craft_fftbuf_right = Buffer.alloc(s, 512);

5.0.wait;



/*RECORDER SYNTHS*/
//Synth(\recorder, [\in, 0, \thresh, 0.35, \fftbuf, ~craft_fftbuf_left, \recbuf, ~craft_buffer_left]);

//Synth(\recorder, [\in, 0, \thresh, 0.6, \fftbuf, ~craft_fftbuf_right, \recbuf, ~craft_buffer_right]);






/*GROUPS AND BUSES */
~synthGroup = Group.new;
	~grainbufGroup = Array.fill(4, { Group.new(~synthGroup); });
~craftGroups = Array.fill(16, { Group.new(~synthGroup); });
~effectGroup = Group.after(~synthGroup);
~nyquist = s.sampleRate * 0.5;

~combBus = Bus.audio(s, 1);
~allpassBus = Bus.audio(s, 1);
	~verbBuses = Array.fill(4, {Bus.audio(s, 2);});

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

~comb_synth = Synth(\combc, [\in, ~combBus, \mix, 0.0 ], ~effectGroup);
~allpass_synth = Synth(\allpassc, [\in, ~allpassBus, \mix, 0.0 ], ~effectGroup);
	~stereoverb_synths = Array.fill(4, {|i| Synth(\stereo_verb, [\in, ~verbBuses[i], \mix, 0.0], ~effectGroup); });
//s.sync;
~checkRoutine = Routine({ inf.do{
		~button_gates.do{|item, i| if ( item == 1, { (" button still pressed : "++i).postln;  }); };
		0.1.wait;
	};
	}).play;




~winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
~grainbufenv = Buffer.sendCollection(s, ~winenv.discretize, 1);

~durBuses =Array.fill(4, { Bus.control(s, 1).set(0.25); });
~grainPosBuses = Array.fill(4, { Bus.control(s, 1).set(0.25); });
	~trateBuses = Array.fill(4, { Bus.control(s, 1).set(10); });
	~durBuses = Array.fill(4, { Bus.control(s, 1).set(0.25); });
	~grainPosBuses = Array.fill(4, { Bus.control(s, 1).set(0.25); });
	~grainpitchBuses = Array.fill(4, { Bus.control(s, 1).set(1); });
	~grainampBuses = Array.fill(4, { Bus.control(s, 1).set(0.75); });
~trateSpec = [0.1, 50.0, -4, 0.1].asSpec;
~durSpec = [2.0, 0.0001, -4, 0.001].asSpec;
~grainPosSpec = [0.0, 0.9, \linear, 0.001].asSpec;
~grainAmpSpec = [0.75, 4.0, -4, 0.001].asSpec;


~grainbuf_switch = [0,0,0,0];
~grainFreezeSwitch = [0,0,0,0];
~grainFreeze = [0,0,0,0];

OSCdef(\flex_rightarm, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			if ( ~grainbuf_switch[0] == 0, {

				Synth(\buf_grain, [\sndbuf, ~craft_buffer_left, \envbuf, ~grainbufenv, \trateBus, ~trateBuses[0].index, \durBus,~durBuses[0].index,\posBus, ~grainPosBuses[0].index, \rateBus, ~grainpitchBuses[0].index, \ampBus,~grainampBuses[0].index, \out, ~verbBuses[0] ], ~grainbufGroup[0]);

				~grainbuf_switch.put(0, 1); "switch grainbuf on".postln; }); },
			    {
			         if ( ~grainbuf_switch[0] == 1, {

				if ( ~grainFreeze[0] != 1, {
					~grainbufGroup[0].set(\gate, 0);
					~grainbuf_switch.put(0, 0); "switch grainbuf off".postln;

					});
				 });
			    });
			if ( fingers > 1, {
			~grainPosBuses[0].set(~grainPosSpec.map(msg[6])); ~grainpitchBuses[0].set(msg[6]*10); });
			if ( fingers > 2, {
			~stereoverb_synths[0].set(\mix, msg[8]); });
			if ( fingers > 3, {
			if ( ~grainFreezeSwitch[0] == 0, {
				if ( ~grainFreeze[0] == 0, {
					~grainFreeze.put(0,1); ~grainFreezeSwitch.put(0,1); "grainfreeze on".postln;

						}, {
					~grainFreeze.put(0,0); ~grainFreezeSwitch.put(0,1); "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
			if ( ~grainFreezeSwitch[0] == 1, { ~grainFreezeSwitch.put(0,0);   });

		});

			//msg.postln;
		if ( ~grainFreeze[0] != 1, {
			~trateBuses[0].set(~trateSpec.map(x_val));
			~durBuses[0].set(~durSpec.map(x_val));
			~grainampBuses[0].set(~grainAmpSpec.map(y_val));
			});

		}, '/rightarm');

OSCdef(\flex_leftarm, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			if ( ~grainbuf_switch[1] == 0, {

				Synth(\buf_grain, [\sndbuf, ~craft_buffer_right, \envbuf, ~grainbufenv, \trateBus, ~trateBuses[1].index, \durBus,~durBuses[1].index,\posBus, ~grainPosBuses[1].index, \rateBus, ~grainpitchBuses[1].index, \ampBus,~grainampBuses[1].index, \out, ~verbBuses[1] ], ~grainbufGroup[1]);

				~grainbuf_switch.put(1, 1); "switch grainbuf on".postln; }); },
			    {
			         if ( ~grainbuf_switch[1] == 1, {

				if ( ~grainFreeze[1] != 1, {
					~grainbufGroup[1].set(\gate, 0);
					~grainbuf_switch.put(1, 0); "switch grainbuf off".postln;

					});
				 });
			    });
			if ( fingers > 1, {
			~grainPosBuses[1].set(~grainPosSpec.map(msg[6])); ~grainpitchBuses[1].set(msg[6]*10); });
			if ( fingers > 2, {
			~stereoverb_synths[1].set(\mix, msg[8]); });
			if ( fingers > 3, {
			if ( ~grainFreezeSwitch[1] == 0, {
				if ( ~grainFreeze[1] == 0, {
					~grainFreeze.put(1,1); ~grainFreezeSwitch.put(1,1); "grainfreeze on".postln;

						}, {
					~grainFreeze.put(1,0); ~grainFreezeSwitch.put(1,1); "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
			if ( ~grainFreezeSwitch[1] == 1, { ~grainFreezeSwitch.put(1,0);   });

		});

			//msg.postln;
		if ( ~grainFreeze[1] != 1, {
			~trateBuses[1].set(~trateSpec.map(x_val));
			~durBuses[1].set(~durSpec.map(x_val));
			~grainampBuses[1].set(~grainAmpSpec.map(y_val));
			});

		}, '/leftarm');

OSCdef(\flex_rightleg, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			if ( ~grainbuf_switch[2] == 0, {

				Synth(\buf_grain, [\sndbuf, ~radiosample3, \envbuf, ~grainbufenv, \trateBus, ~trateBuses[2].index, \durBus,~durBuses[2].index,\posBus, ~grainPosBuses[2].index, \rateBus, ~grainpitchBuses[2].index, \ampBus,~grainampBuses[2].index, \out, ~verbBuses[2] ], ~grainbufGroup[2]);

				~grainbuf_switch.put(2, 1); "switch grainbuf on".postln; }); },
			    {
			         if ( ~grainbuf_switch[2] == 1, {

				if ( ~grainFreeze[2] != 1, {
					~grainbufGroup[2].set(\gate, 0);
					~grainbuf_switch.put(2, 0); "switch grainbuf off".postln;

					});
				 });
			    });
			if ( fingers > 1, {
			~grainPosBuses[2].set(~grainPosSpec.map(msg[6])); ~grainpitchBuses[2].set(msg[6]*10); });
			if ( fingers > 2, {
			~stereoverb_synths[2].set(\mix, msg[8]); });
			if ( fingers > 3, {
			if ( ~grainFreezeSwitch[2] == 0, {
				if ( ~grainFreeze[2] == 0, {
					~grainFreeze.put(2,1); ~grainFreezeSwitch.put(2,1); "grainfreeze on".postln;

						}, {
					~grainFreeze.put(2,0); ~grainFreezeSwitch.put(2,1); "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
			if ( ~grainFreezeSwitch[2] == 1, { ~grainFreezeSwitch.put(2,0);   });

		});

			//msg.postln;
		if ( ~grainFreeze[2] != 1, {
			~trateBuses[2].set(~trateSpec.map(x_val));
			~durBuses[2].set(~durSpec.map(x_val));
			~grainampBuses[2].set(~grainAmpSpec.map(y_val));
			});

		}, '/rightleg');


OSCdef(\flex_leftleg, {|msg|
			var fingers = msg[3];
			var x_val = msg[4];
			var y_val = msg[5];
			if ( fingers > 0, {
			if ( ~grainbuf_switch[3] == 0, {

				Synth(\buf_grain, [\sndbuf, ~radiosample3, \envbuf, ~grainbufenv, \trateBus, ~trateBuses[3].index, \durBus,~durBuses[3].index,\posBus, ~grainPosBuses[3].index, \rateBus, ~grainpitchBuses[3].index, \ampBus,~grainampBuses[3].index, \out, ~verbBuses[3] ], ~grainbufGroup[3]);

				~grainbuf_switch.put(3, 1); "switch grainbuf on".postln; }); },
			    {
			         if ( ~grainbuf_switch[3] == 1, {

				if ( ~grainFreeze[3] != 1, {
					~grainbufGroup[3].set(\gate, 0);
					~grainbuf_switch.put(3, 0); "switch grainbuf off".postln;

					});
				 });
			    });
			if ( fingers > 1, {
			~grainPosBuses[3].set(~grainPosSpec.map(msg[6])); ~grainpitchBuses[3].set(msg[6]*10); });
			if ( fingers > 2, {
			~stereoverb_synths[3].set(\mix, msg[8]); });
			if ( fingers > 3, {
			if ( ~grainFreezeSwitch[3] == 0, {
				if ( ~grainFreeze[3] == 0, {
					~grainFreeze.put(3,1); ~grainFreezeSwitch.put(3,1); "grainfreeze on".postln;

						}, {
					~grainFreeze.put(3,0); ~grainFreezeSwitch.put(3,1); "grainfreeze off".postln;
						});

					})
				 });

			if ( fingers < 4, {
			if ( ~grainFreezeSwitch[3] == 1, { ~grainFreezeSwitch.put(3,0);   });

		});

			//msg.postln;
		if ( ~grainFreeze[3] != 1, {
			~trateBuses[3].set(~trateSpec.map(x_val));
			~durBuses[3].set(~durSpec.map(x_val));
			~grainampBuses[3].set(~grainAmpSpec.map(y_val));
			});

		}, '/leftleg');


});