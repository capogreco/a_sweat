SynthDef (\sine_block) {
	arg freq_1 = 330, freq_2 = 220, amp = 1, pan = 0,
	static_time = 1, slide_time = 2, total_time = 4, holo_harm = 0, detune = 0;

	var env, freq_env, sine, saw, sig, harm_number;

	env = Env.step (amp.asArray, total_time.asArray);
	env = EnvGen.kr (env, doneAction: 2);

	freq_env = Env.step ([ freq_1, freq_2 ], [ static_time, total_time - static_time  ]);
	freq_env = EnvGen.kr (freq_env);

	freq_env = Lag.kr (freq_env, slide_time);
	holo_harm = Lag.kr (holo_harm, 0.05);

	harm_number = 64;
	sig = [ 0, 0 ];
	harm_number.do {
		arg i;
		var amp, detune_sig, pan_sig;
		amp = (1 / (i + 1)) * Clip.kr (((holo_harm * (harm_number - 1)) + 1) - i, 0, 1);
		detune_sig = SinOsc.ar (freq_env * (i + 1) / 4096, Rand (0.0, 2 * pi), detune, 1) ** (i / harm_number);
		pan_sig = SinOsc.ar (freq_env * (i + 1) / 4096, Rand (0.0, 2 * pi), detune) * (i / harm_number);
		detune_sig = SinOsc.ar (freq_env * (i + 1) * detune_sig, 0, amp);
		detune_sig = Pan2.ar (detune_sig, pan_sig);
		sig = sig + detune_sig;
	};
	sig = sig * env;
	Out.ar (0, sig);
}.add;

SynthDef (\kick) {
	arg len = 0.3, pan = 0, amp = 1, freq = 55, juice = 0, decimate = 0.3;
	var sig, env_amp, env_freq;

	env_amp  = Env.perc (0.01, len - 0.01, amp);
	env_amp  = EnvGen.kr (env_amp, doneAction: 2);

	env_freq = Env.perc (0, 0.02, 1);
	env_freq = EnvGen.ar (env_freq);

	juice = Lag.kr (juice, 0.05);
	decimate = Lag.kr (decimate, 0.05);

	sig = SinOsc.ar (freq + (44100 ** env_freq), 0, env_amp);
	sig = Decimator.ar (sig, freq * 256 * (2 ** (decimate * -8)));

	sig = SoftClipAmp8.ar (sig, (64 ** juice));

	sig = sig * (64 ** juice);
	sig = sig.softclip * env_amp;

	sig = Pan2.ar (sig, pan);

	Out.ar (0, sig);
}.add;

SynthDef (\tri_drum) {
	arg freq = 660, length = 0.1, hh_amp = 1, pan = 0;
	var sig, env;
	env = Env.perc (0, length, hh_amp / 50);
	env = EnvGen.kr (env, doneAction: 2);
	freq = freq * WhiteNoise.ar (1, 1);
	sig = LFTri.ar (freq);
	// sig = Saw.ar (freq);
	// sig = PinkNoise.ar ();
	sig = Pan2.ar (sig, pan, env);
	Out.ar (0, sig);
}.add;

// 8.do {
// 	sig = AllpassN.ar (sig, 0.1, [ 0.1.rand, 0.1.rand ], 1);
// };
