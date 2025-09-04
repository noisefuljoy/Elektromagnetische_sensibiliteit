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


Require("synthdefs.scd");
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

Require("tunings.scd");
Require("buses.scd");
Require("specs.scd");

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
~synth_gates = Array.fill(10, { \off });


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
						var sample = ~radio_samples[7], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
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
						var sample = ~radio_samples[7], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
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
						var sample = ~radio_samples[7], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
						8.do{|i| var pan = [0.5, 0.25, 0, -0.25, -0.5];
						//~scene2_dur.postln;
							if ( ~fingers_amount[2] < 2, { transpose=1; dur_divide=1; }, { transpose = [ -0.7,-0.49,-0.25,-0.125].choose; dur_divide=rrand(0.24,0.27); });

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
						var sample = ~radio_samples[7], durs = ~scene4_durs, rates = ~scene4_rates, transpose=1, dur_divide=1;
						8.do{|i| var pan = [-0.5, -0.25, 0, 0.25, -0.5];
						//~scene2_dur.postln;
							if ( ~fingers_amount[3] < 2, { transpose=1; dur_divide=1; }, { transpose = [ -0.7,-0.49,-0.25,-0.125].choose; dur_divide=rrand(0.24,0.27); });

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


					}
				{ ~scene == 5 }
				{

						/* FLEX 1 */
						~scene5_pat1_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[9], transpose;
						9.do{|i| var pan = [-1.0, 0.5, 0, 0.5, 1.0,-1.0, 0.5, 0, 0.5, 1.0];
							if (  ~fingers_amount[0] < 2, { transpose = 1; }, {
								transpose = [1.97,-1.99,4.01,-4.02,8.01,-8.04,1.97,-1.99,4.01].choose;
							});

						if ( ~global_freeze == \off, {
							if ( ~flex_gates[0] == \open, {
									Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene5_durs[0][i],
										\rate, ~scene5_rates[0][~scene5_melody_selector][i]*transpose, \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,0.75,\bufnum, sample,\dur,~scene5_durs[0][i],
									\rate, ~scene5_rates[0][~scene5_melody_selector][i]*transpose, \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene5_durs[0][i].wait;
						};
					}; }).play(~scene5_clocks[0]);

					/* FLEX 2 */
					~scene5_pat2_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[9], transpose;
						9.do{|i| var pan = [-1.0, 0.5, 0, 0.5, 1.0,-1.0, 0.25, 0.125, 0.25, 1.0];

							if (  ~fingers_amount[1] < 2, { transpose = 1; }, {
								transpose = [-1.99,-4.02,-7.99].choose;
							});

						if ( ~global_freeze == \off, {
							if ( ~flex_gates[1] == \open, {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene5_durs[1][i],
									\rate, ~scene5_rates[1][~scene5_melody_selector][i]*transpose, \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene3_durs[1][i],
									\rate, ~scene5_rates[1][~scene5_melody_selector][i]*transpose, \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene5_durs[1][i].wait;
							};
					}; }).play(~scene5_clocks[1]);

					~scene5_pat3_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[9],transpose;
						9.do{|i| var pan = [-1.0, 0.5, 0, 0.5, 1.0,-1.0, 0.25, 0.125, 0.25, 1.0];

							if (  ~fingers_amount[2] < 2, { transpose = 1; }, {
								transpose = [-0.48,-1.99,-4.02].choose;
							});
						//~scene2_dur.postln;
						if ( ~global_freeze == \off, {
							if ( ~flex_gates[2] == \open, {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene5_durs[2][i],
									\rate, ~scene5_rates[2][~scene5_melody_selector][i]*transpose,  \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene5_durs[2][i],
									\rate, ~scene5_rates[2][~scene5_melody_selector][i]*transpose, \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene5_durs[2][i].wait;
						};
					}; }).play(~scene5_clocks[2]);

					~scene5_pat4_grain_routine = Routine({ inf.do{
						var sample = ~radio_samples[9],transpose;
						9.do{|i| var pan = [-1.0, 0.5, 0, 0.5, 1.0,-1.0, 0.25, 0.125, 0.25, 1.0];

							if (  ~fingers_amount[3] < 2, { transpose = 1; }, {
								transpose = [-0.25,-0.48,-1.99,-4.02].choose;
							});
						//~scene2_dur.postln;
						if ( ~global_freeze == \off, {
							if ( ~flex_gates[3] == \open, {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum, sample,\dur,~scene5_durs[3][i],
									\rate, ~scene5_rates[3][~scene5_melody_selector][i]*transpose,  \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
						},
						{
							if ( (~flex_gates[0] == \open) or: (~flex_gates[1] == \open) or: (~flex_gates[2] == \open) or: (~flex_gates[3] == \open) , {
								Synth(\radio_sampler_scene3, [\amp,0.8,\envbuf, ~rect_env, \pan,pan[i],\bufnum,sample,\dur,~scene5_durs[3][i],
									\rate, ~scene5_rates[3][~scene5_melody_selector][i]*transpose,  \posBus, ~scene5_buses[4].index, \out,~combBus ], ~synthGroup); });
							});
							~scene5_durs[3][i].wait;
						};
					}; }).play(~scene5_clocks[3]);


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


				}
				{ ~scene == 5 } {
					~scene5_pat1_grain_routine.stop;
					~scene5_pat2_grain_routine.stop;
					~scene5_pat3_grain_routine.stop;
					~scene5_pat4_grain_routine.stop;
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
~transpose_gates_scene5 = [0,0,0,0];

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

			}
			{ ~scene == 5 } {

			if ( ~transpose_gates_scene5[0] == 0, {

				~scene5_clocks[0].tempo = 5;
				~effectGroups[5].set(\mix, rrand(0.3, 0.5));
					~transpose_gates_scene5[0] = 1 });
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

				}
				{ ~scene == 3 } {

					~scene5_durs[0] = ~scene5_rhythm * ~sc5_dur_index1_spec.map(msg[4]);
					~scene5_durs[1] = ~scene5_rhythm * ~sc5_dur_index2_spec.map(msg[4]);
					~scene5_durs[2] = ~scene5_rhythm * ~sc5_dur_index3_spec.map(msg[4]);
					~scene5_durs[3] = ~scene5_rhythm * ~sc5_dur_index4_spec.map(msg[4]);


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

			}
			{ ~scene == 5 } {
				if ( ~transpose_gates_scene5[1] == 0, {

					~scene5_clocks[1].tempo = 8;
					~transpose_gates_scene5[1] = 1;
						~effectGroups[5].set(\mix, 0.085, \modFreq, rrand(0.25,1.5) );


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

			}
			{ ~scene == 5 } {
				if ( ~transpose_gates_scene5[1] == 0, {
				~scene5_clocks[1].tempo = 4;
				~effectGroups[5].set(\mix,rrand(0.3, 0.6) );
					~transpose_gates_scene5[1] = 1; });
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

			}
			{ ~scene == 5 } {
				if ( ~transpose_gates_scene5[1] == 1, {

					//~scene5_clocks[1].tempo = 0.8;

					~effectGroups[5].set(\mix, 0.0,  \modFreq, rrand(0.01,0.05) );

					~transpose_gates_scene5[1] = 0;

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



				}
				{ ~scene == 5 }  {


					~scene5_buses[4].set(~sc2_posSpec.map(msg[4]); );

						//~scene3_durs[0] = ~scene3_rhythm * ~sc3_dur_index1_spec.map(msg[4]);
					    //~scene3_durs[1] = ~scene3_rhythm * ~sc3_dur_index2_spec.map(msg[4]);
	                    //~scene3_durs[2] = ~scene3_rhythm * ~sc3_dur_index3_spec.map(msg[4]);
	                    //~scene3_durs[3] = ~scene3_rhythm * ~sc3_dur_index4_spec.map(msg[4]);


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
						~effectGroups[4].set(\mix, 0.3, \modFreq, rrand(10.0,15.0) );

					~transpose_gates_scene4[2] = 1; });

			}
		{ ~scene == 5 } {



				if ( ~transpose_gates_scene5[2] == 0, {
				~scene5_clocks[2].tempo = 5;
				~effectGroups[5].set(\mix,rrand(0.3,0.7) );
					~transpose_gates_scene5[2] = 1; });
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
					~effectGroups[4].set(\mix, 0.0,  \modFreq, rrand(0.01,0.05) );
					~transpose_gates_scene4[2] = 0; });

			}
		{ ~scene == 5 } {

				~scene5_clocks[0].tempo = ~scene5_clockSpec.map(x_val);
				~scene5_clocks[1].tempo = ~scene5_clockSpec.map(x_val);
				~scene5_clocks[2].tempo = ~scene5_clockSpec.map(x_val);
				~scene5_clocks[3].tempo = ~scene5_clockSpec.map(x_val);

				if ( ~transpose_gates_scene5[2] == 1, {

					//~scene5_clocks[2].tempo = 0.9;

					~effectGroups[5].set(\mix, 0.0,  \modFreq, rrand(0.01,0.05) );
					~transpose_gates_scene5[2] = 0; });

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

				}
				{ ~scene == 4 } {

						~scene4_melody_selector = ~scene4_melody_spec.map(msg[4]);

				}
				{ ~scene == 5 } {

					~scene5_melody_selector = ~scene5_melody_spec.map(msg[4]);

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
					~effectGroups[4].set(\mix, 0.1, \modFreq, rrand(15.0,20.0) );

					~transpose_gates_scene4[3] = 1; });

			}
		{ ~scene == 5 } {
				if ( ~transpose_gates_scene5[3] == 0, {
				~scene5_clocks[3].tempo = 7;
				~effectGroups[5].set(\mix,rrand(0.3,0.7) );
					~transpose_gates_scene5[3] = 1; });
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

			}
			{ ~scene == 5 } {

				~scene5_clocks[0].tempo = ~scene5_clockSpec.map(x_val);
				~scene5_clocks[1].tempo = ~scene5_clockSpec.map(x_val);
				~scene5_clocks[2].tempo = ~scene5_clockSpec.map(x_val);
				~scene5_clocks[3].tempo = ~scene5_clockSpec.map(x_val);


				if ( ~transpose_gates_scene5[3] == 1, {
				//~scene5_clocks[3].tempo = 6;
				~effectGroups[5].set(\mix,0.05 );
					~transpose_gates_scene5[3] = 0; });
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

				}
				{ ~scene == 4 } {

					~scene4_melody_selector = ~scene4_melody_spec.map(msg[4]);
				}
					{ ~scene == 3 } {

					 	~scene5_melody_selector = ~scene5_melody_spec.map(msg[4]);

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


				Synth(\transition_sound,[\bufnum, ~radio_samples.choose, \rate, rrand(0.25,0.5),\dur, rrand(4.0,6.0)]);
				/*
				~trans_routine = Routine({
	20.do{ var dur = [0.2,0.6,0.33,0.1].choose;
		dur = dur * 0.05;
		Synth(\sine_short,[\freq, 3000 * ~pentatetra_tuning.choose, \rel, dur * rrand(1,1.5) ]);

		dur.wait; };
}).play;
			*/

			if (~scene != 5, { ~scene = ~scene + 1;  }, { ~scene = 0; });
			case
				{ ~scene == 0 } { ~effectGroups[5].set(\gate, 0); 	Synth(\stereo_verb, [\in, ~verbBus, \mix, 0.0], ~effectGroups[0], \addToTail); }
				{ ~scene == 1 } { ~effectGroups[0].set(\gate, 0); Synth(\allpassc, [\in, ~allpassBus, \mix, 0.1, \dec,2 ], ~effectGroups[1],\addToTail); }
				{ ~scene == 2 } { ~effectGroups[1].set(\gate, 0);  Synth(\grain_eq, [\in, ~graineq_bus,\rq,0.75,\boostfreq,500,\cutfreq,5000,\amp,1,\mix,0.1, \out, 0 ],  ~effectGroups[2], \addToTail ); }
				{ ~scene == 3 } { ~effectGroups[2].set(\gate, 0); Synth(\combc_new, [\in, ~combBus,\dec,0, \mix, 0.05], ~effectGroups[3],\addToTail); }
				{ ~scene == 4 } { ~effectGroups[3].set(\gate, 0); Synth(\filter, [\in, ~filtBus, \modfreq, 0.1,\mix,0.0 ], ~effectGroups[4], \addToTail); }
				{ ~scene == 5 } { ~effectGroups[4].set(\gate, 0); Synth(\combc_new, [\in, ~combBus,\dec,0, \mix, 0.05], ~effectGroups[4], \addToTail); };



				/* test if this can be deleted */
				/*
			if ( ~synth_gates[~prev_scene] == \on, {
				             case
				{ ~prev_scene == 0 } { ~grainbufGroup.set(\gate, 0);     }
				{ ~prev_scene == 1 } { ~grainbufGroup.set(\gate, 0);     }
				{ ~prev_scene == 2 } { ~grain_routine1.stop;   }
				{ ~prev_scene == 3 } {  ~grain_routine2.stop;  }
				{ ~prev_scene == 4 } {  ~grain_routine3.stop;  };

				~synth_gates[~prev_scene] = \off;
			                       });  */



				if ( ~debug, { ("scene "++~scene).postln; });
			});
		}, {    if ( ~b2_denoise_gate == \closed, {  ~b2_denoise_gate = \open;  	if ( ~debug, {  "b2 gate open".postln; });  });             });

			}, '/craft');




});












