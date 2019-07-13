MIDIClient.init;              //  tells supercollider we wnat to do MIDI stuff
MIDIIn.connectAll;            //  connects to any usb-MIDI controllers present
MIDIdef.cc (\a_sweat_lpd8_control) {  //  function to execute when recieving a cc msg
	arg ...args;
	var k, v, p;
	k = args[1];
	v = args[0];
	p = Pseq (v.asArray, inf);

	switch (k)
	{ 1 }  {
		Pdefn (\knob_1) { p };
		g.set (\holo_harm, v / 127);
	}
	{ 5 }  {
		Pdefn (\knob_5) { p };
		g.set (\detune, (v / 127) ** 4);
	}

	{ 2 }  {
		Pdefn (\knob_2) { p };
		g.set (\juice, v / 127);
	}
	{ 6 }  {
		Pdefn (\knob_6) { p };
		g.set (\decimate, v / 127);
	}

	{ 3 }  {
		Pdefn (\knob_3) { p };
	}
	{ 7 }  { Pdefn (\knob_7) { p } }

	{ 4 }  {
		Pdefn (\knob_4) { p };
		g.set (\hh_amp) {
			Pseq (0.1.asArray, inf);
		};
	}
	{ 8 }  {
		Pdefn (\knob_8) { p };
	};

	("k " ++ k ++ ", v " ++ v).postln;
}.permanent_ (true);

MIDIdef.noteOn (\a_sweat_lpd8_note_on) {
	arg ...args;
	var p;
	p = args[1];
	("note on: " + p).postln;

	switch (p)
	{ 40 } {
		Pdefn (\quaver_amp) {
			Pseq (0.2.asArray, inf);
		}
	}
	{41} {
		g = Group.new;
		~pattern.play;
	}
	{ 43 } {
		// Synth (\kick);
		Pdef (\quavers) {
			Pbind (
				\instrument, \tri_drum,
				\group, g,
				\delta, Pdefn (\quaver_delta),
				\length, Pkey (\delta) / 4,
				\freq, Pdefn (\root_freq) * (2 ** (42 / 12)),
				\amp, 1,
				\pan, Pdefn (\quaver_pan),
			);
		}.quant_ (2.20116);
	}
}.permanent_ (true);