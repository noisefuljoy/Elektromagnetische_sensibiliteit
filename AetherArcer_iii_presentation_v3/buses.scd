"loading buses".postln;

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

/* SCENE 5. 0: pitch_grain0 1: pitch_grain1 2: pitch_grain2 3:pitch_grain4  4: startpos 5: looplength */
	~scene5_buses = Array.fill(9, {|i|
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

/* SCENE 6. 0: pitch_grain0 1: pitch_grain1 2: pitch_grain2 3:pitch_grain4  4: startpos 5: looplength */
	~scene6_buses = Array.fill(9, {|i|
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

~scene7_buses = Array.fill(12, {|i|

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
	~scene8_buses = Array.fill(12, {|i|
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