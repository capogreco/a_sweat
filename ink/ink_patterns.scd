Pdefn (\bar_length) {
	var length = 2.20116;
	Pseq (length.asArray, inf);
};

Pdefn (\root_freq) {
	var freq = 87.307057858251; // F
	Pseq (freq.asArray, inf);
};


Pdef (\ink_sine) {
	Pbind (
		\instrument, \sine_block,
		\group, g,
		\delta, Pdefn (\bar_length),
		\total_time, Pdefn (\bar_length) * 3 / 4,
		\static_time, Pdefn (\bar_length) / 4,
		\slide_time, Pdefn (\bar_length) / 4,
		\freq_1, Pdefn (\root_freq),
		\freq_2, Pkey (\freq_1) / 2,
		\amp, 0.3,
		\holo_harm, Pdefn (\knob_1) / 127,
		\detune, (Pdefn (\knob_5) / 127) ** 4,
	)
};

Pdef (\clave) {
	Pbind (
		\instrument, \kick,
		\group, g,
		\delta, Pseq ([ 3, 3, 2 ] / 8, inf) * Pdefn (\bar_length),
		\len, Pdefn (\bar_length) * 3 / 8,
		\freq, Pdefn (\root_freq) / 2,
		\amp, 1,
		\juice, Pdefn (\knob_2) / 127,
		\decimate, Pdefn (\knob_6) / 127,
	)
};

Pdefn (\quaver_pan) {
	var pan_amount, min_rate, max_rate, pan_rate;
	pan_amount = Pdefn (\knob_7) / 127;
	pan_amount = pan_amount ** 2.reciprocal;
	min_rate = Pdefn (\root_freq) / 256;
	min_rate = min_rate * (1 - pan_amount);
	max_rate = 16 / Pdefn (\bar_length);
	max_rate = max_rate * pan_amount;
	pan_rate = min_rate + max_rate;
	pan_amount * sin (Ptime () * pi * 2 * pan_rate);
};

Pdefn (\quaver_delta) {
	var amount, min, max, dif, dur;
	amount = Pdefn (\knob_3) / 127;
	amount = amount ** 2.reciprocal;
	min = Pdefn (\bar_length) / 16;
	max = Pdefn (\root_freq) * 3 / 2;
	max = max.reciprocal;
	dif = min - max;
	dif = dif * amount;
	dur = min - dif;
};

Pdefn (\quaver_amp) {
	Pseq (0.asArray, inf);
};

Pdef (\quavers) {
	Pbind (
		\instrument, \tri_drum,
		\group, g,
		\delta, Pdefn (\quaver_delta),
		\length, Pkey (\delta) / 16,
		\freq, Pdefn (\root_freq) * (2 ** (42 / 12)),
		\hh_amp, Pdefn (\knob_4 / 127),
		\pan, Pdefn (\quaver_pan),
	);
}.quant_ (2.20116);