"loading specs".postln;

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

/*scene 5 specs*/
	~scene5_rates1 = Array.fill(30,
		{|i|
			Array.fill(9, {|j|
				~eikosany_tuning.wrapAt(j+i); });    });
		30.do{|i| ~scene3_rates1[i] = ~scene3_rates1[i].scramble; };

	~scene5_rates2 = Array.fill(30,
		{|i|
			Array.fill(9, {|j|
				~eikosany_tuning.wrapAt(j+ (i*2) ); });    });
		30.do{|i| ~scene3_rates2[i] = ~scene3_rates2[i].scramble; };

	~scene5_rate3 = Array.fill(30,
		{|i|
			Array.fill(9, {|j|
				~eikosany_tuning.wrapAt(59-(j+i)); });    });
	30.do{|i| ~scene3_rate3[i] = ~scene3_rate3[i].scramble * 0.5 };

	~scene5_rate4 = Array.fill(30,
		{|i|
			Array.fill(9, {|j|
				~eikosany_tuning.wrapAt( 59 - ( j+ (i*2) ) ); });    });
	30.do{|i| ~scene3_rate4[i] = ~scene3_rate4[i].scramble * 0.25 };

~scene5_melody_spec = [0, 29,\linear, 1].asSpec;
~scene5_melody_selector = 0;

~scene5_rhythm = Array.fib(9,0.03125,0.0125);

~scene5_durs = [~scene5_rhythm,~scene5_rhythm.scramble,~scene5_rhythm.scramble,~scene5_rhythm.scramble];
~scene5_rates = [~scene5_rates1,~scene5_rates2,~scene5_rate3,~scene5_rate4];

	~sc5_dur_arr = Array.geom(30,0.025, 1.2);
	~sc5_dur_index1_spec = [0.2, 0.95, -4, 0.1].asSpec;
	~sc5_dur_index2_spec = [0.25, 0.97, 4, 0.1].asSpec;
	~sc5_dur_index3_spec = [0.3, 1.01, 1, 0.1].asSpec;
	~sc5_dur_index4_spec = [0.35, 1.15, -1, 0.1].asSpec;

//~scene3_clock = TempoClock.new(0.6);
	~scene5_clocks = Array.fill(4, { TempoClock.new(0.6); });

~scene5_durSpec = [2.5, 0.0005, 1, 0.001].asSpec;
~scene5_posSpec = [0.0, 0.75, 1, 0.01].asSpec;
~scene5_clockSpec = [2.0, 6.5, 1, 0.001].asSpec;
