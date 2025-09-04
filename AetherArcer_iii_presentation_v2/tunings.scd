"loading tunings".postln;

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
