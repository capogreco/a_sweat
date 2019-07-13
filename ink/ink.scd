"ink_midi.scd".loadRelative;
"ink_synths.scd".loadRelative;
"ink_patterns.scd".loadRelative;

(
g = Group.new;
// Pdef (\clave).play;
// Pdef (\ink_sine).play;
Pdef (\quavers).play;
)

~pattern = Ppar ([ Pdef (\ink_sine), Pdef (\quavers), Pdef (\clave) ], inf);

(
g = Group.new;
~pattern.play;
)

