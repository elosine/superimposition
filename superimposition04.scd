(
fork {
	s.waitForBoot {
		////VARIABLES////
		~numtrx = 4;
		~ixsynths = Array.newClear(~numtrx+1);
		~ixbufs = {Buffer.alloc(s, s.sampleRate*16.0, 1)}!(~numtrx+1); //buffers to hold current index location, notice it is 16 seconds long, or 4 4_4 bars at bpm=60 (s.sampleRate*16.0);
		~ixbuses = {Bus.audio(s)}!(~numtrx+1); //audio rate busses to hold index location
		~ixkbuses = {Bus.control(s)}!(~numtrx+1); //control rate busses to hold index location, for waveform display
		~ixgr = Group.new(); //ix group before all groups
		~proc = NetAddr("127.0.0.1", 12321); //net sender to processing

		////SYNTHDEFS////
		//synthdef to control the indexes
		SynthDef(\bufidx,{
			arg buf, spd=1, bus, numbts=1.0, start=0.0, end=1.0, kbus;
			var indexer, indexnorm;
			//create an audio rate indexer using the Phasor object
			indexer = Phasor.ar(trig:0, rate:BufRateScale.kr(buf)*spd, start:start*BufFrames.kr(buf), end:end*BufFrames.kr(buf));
			//normalize the index
			indexnorm = indexer.linlin(0.0, BufFrames.kr(buf), 0.0, numbts);
			//send the index out to both a control and audio rate bus
			Out.ar(bus, indexer);
			Out.kr(kbus, indexnorm);
		}).add;

		////OSCDEFS////
		//On Demand normalized index
		OSCdef( \getidx,{ ~ixkbuses[0].get({arg val; ~proc.sendMsg("/ix", val)}) }, "/getidx");
		OSCdef( \gettridx,{
			arg msg;
			var tr = msg[1].asInteger;
			~ixkbuses[tr+1].get({arg val; ~proc.sendMsg("/trix", tr, val.asFloat)}) ;
		}, "/gettridx");

		OSCdef( \setidx,{
			arg msg;
			var trnum, start, end, spd;
			trnum = msg[1].asInteger;
			start = msg[2].asFloat;
			end = msg[3].asFloat;
			spd = msg[4].asFloat;
			~ixsynths[trnum+1].set(\start,  start); //trnum+1because ix track 0 is master track
			~ixsynths[trnum+1].set(\end,  end);
			~ixsynths[trnum+1].set(\spd,  spd);
			~playsynths[trnum].set(\idxbus, ~ixbuses[trnum+1]);
		}, "/setidx");

		OSCdef(\stop, {
			~numtrx.do{|ix| ~recsynths[ix].free; ~playsynths[ix].free; ~ixsynths[ix].free};
			~trx.do{|it| it.free};
			~trx = nil;
		}, "/stop");

		OSCdef(\restart, {
			~trx = {Buffer.alloc(s, s.sampleRate * 16.0, 1)}!16;
			~numtrx.do{ |ix|
				~ixsynths[ix] = Synth(\bufidx, [\buf, ~ixbufs[ix], \bus, ~ixbuses[ix], \kbus, ~ixkbuses[ix]], ~ixgr);
				~recsynths[ix] = Synth(\bufrec, [\idxbus,~ixbuses[0], \buf, ~trx[ix]], ~ingr);
				~playsynths[ix] = Synth(\bufpl, [\idxbus, ~ixbuses[0], \buf, ~trx[ix]], ~ogr)
			};
		}, "/restart");

		0.5.wait;


		(~numtrx+1).do{ |ix| ~ixsynths[ix] = Synth(\bufidx, [\buf, ~ixbufs[ix], \bus, ~ixbuses[ix], \kbus, ~ixkbuses[ix]], ~ixgr) };
	}
}
)


//notation

//SUPERIMPOSITION DRAFT 1
( //1
//INITIAL RHYTHMS WITH OPEN PITCH
//Med-Sparce Density
~proc.sendMsg("/drh", 2, 0, 1);
~proc.sendMsg("/drh", 9, 1, 1);
//Swap on second half
~proc.sendMsg("/drh", 1009, 2, 1);
~proc.sendMsg("/drh", 1002, 3, 1);
)

(//2
//PITCH CONTOUR WITH OPEN PITCH
//Compressed range w/outliers & open pitch
~proc.sendMsg("/mkpitch", 2, 3, "0.05:0.4:0.6:2:4");
~proc.sendMsg("/mkpitch", 9, 3, "0.05:0.4:0.6:2:4");
)
(
~proc.sendMsg("/mkpitch", 1002, 3, "0.05:0.4:0.6:2:4");
~proc.sendMsg("/mkpitch", 1009, 3, "0.05:0.4:0.6:2:4");
)

(//3
//ADD SUSTAINED NOTES
~proc.sendMsg("/mksus", 2, 5);
~proc.sendMsg("/mksus", 9, 3);
)
(
~proc.sendMsg("/mksus", 1009, 4);
~proc.sendMsg("/mksus", 1002, 2);
)

(//4
//CHANGE PITCH CONTOUR
~proc.sendMsg("/mkpitch", 2, 0, "0.05:0.1:0.9");
~proc.sendMsg("/mkpitch", 9, 0, "0.05:0.1:0.9");
)
(
~proc.sendMsg("/mkpitch", 1009, 0, "0.05:0.1:0.9");
~proc.sendMsg("/mkpitch", 1002, 0, "0.05:0.1:0.9");
)

(//5
//DYNAMICS
~proc.sendMsg("/mkdyn", 2, 0,"2:15:1:7");
~proc.sendMsg("/mkdyn", 9, 0,"2:17:1:7");
)
(
~proc.sendMsg("/mkdyn", 1009, 0,"2:13:1:7");
~proc.sendMsg("/mkdyn", 1002, 0,"2:18:1:7");
)

(//6
//PITCH SETS
~proc.sendMsg("/mkpitchset", 2, 1, "1:3");
~proc.sendMsg("/mkpitchset", 9, 1, "1:3");
)
(
~proc.sendMsg("/mkpitchset", 1009, 1, "2:4");
~proc.sendMsg("/mkpitchset", 1002, 1, "2:4");
)

(//7
//ARTICULATIONS
~proc.sendMsg("/mkart", 2, 4, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg");
~proc.sendMsg("/mkart", 9, 4, "trill.svg:Bartok_pizz.svg:accent.svg:harmonics.svg:tongueslap.svg:multi.svg");
)
(
~proc.sendMsg("/mkart", 1009, 6, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg");
~proc.sendMsg("/mkart", 1002, 6, "trill.svg:Bartok_pizz.svg:accent.svg:harmonics.svg:tongueslap.svg:multi.svg");
)

//next section
med rhythms w/sustained notes
single pitchset & constricted contour
 crescendi&few articulations

change pitchset & contour
change pitchset with more changes
changes every 2 lengths

//final section of mvt 1
dense rhythms with all parameters
//change sustained notes
change articulations, more and more
hairpins
change dynamics
change pitchsets and contours
change with every track length

//unisons alternating with sustained notes

harp sustained notes enharmonic tremelo if possible










//ix, track, on/off
~proc.sendMsg("/drh", 0, 0, 1); //33 partials
~proc.sendMsg("/drh", 1, 0, 1); //15 partials
~proc.sendMsg("/drh", 2, 2, 1); //18 partials
~proc.sendMsg("/drh", 3, 3, 1);//34 partials
~proc.sendMsg("/drh", 4, 0, 1);//40 partials
~proc.sendMsg("/drh", 5, 1, 1);//42 partials
~proc.sendMsg("/drh", 6, 1, 1); //43 partials
~proc.sendMsg("/drh", 7, 1, 1); //31 partials
~proc.sendMsg("/drh", 8, 1, 1); //29 partials
~proc.sendMsg("/drh", 9, 1, 1); //21 partials
//ix, num of partials to sustain
~proc.sendMsg("/mksus", 0, 7);
//ix, pitch distribution mode, colon delimited string of args
////mode 0 - jumping around: rangepct:tessaturamin:tessaturamax
~proc.sendMsg("/mkpitch", 3, 0, "0.05:0.0:1.0");
~proc.sendMsg("/rmpitch", 0);
~proc.sendMsg("/mkpitch", 0, 0, "0.05:0.0:0.33");
~proc.sendMsg("/mkpitch", 0, 0, "0.05:0.33:0.33");
//mode 1 - ascending descending; range, tessatura-min, tessatura-max, rate-by-numpart
~proc.sendMsg("/mkpitch", 0, 1, "0.08:0.0:1.0:-1:7");
//mode 2 - random w/random range - range, tessatura-min, tessatura-max
~proc.sendMsg("/mkpitch", 0, 2, "0.25:0.2:0.8");
// mode 3 - //random w/outliers
//range, tessatura-min, tessatura-max, outlier-min-numpart, outlier-max-numpart
~proc.sendMsg("/mkpitch", 0, 3, "0.05:0.45:0.55:3:7");

//make dynamics
//int ryhthmix, int dynamics mode, String args
//MODE 0 - Random Jumps: String "init dynamic, num jumps, min num of inc, max num of inc"
~proc.sendMsg("/mkdyn", 0, 0, "5:7:3:5");
//MODE 1 - Crescendos: String "init dynamic, num cres, min num of dynamic inc, max num of dynamic inc, min length-beats, max length-beats, max beats between cres"
~proc.sendMsg("/mkdyn", 0, 1, "1:7:2:5:1.0:2.75:1.0");
//MODE 2 - Decrescendos: String "init dynamic, num cres, min num of dynamic inc, max num of dynamic inc, min length-beats, max length-beats, max beats between cres"
~proc.sendMsg("/mkdyn", 0, 2, "7:11:6:6:1.0:5.75:0.5");
//MODE 3 - Hairpins: String "init dynamic, num cres, min num of dynamic inc, max num of dynamic inc, min length-beats, max length-beats, max beats between cres, crescendo:decrescendo ratio in decimal percentage"
~proc.sendMsg("/mkdyn", 0, 3,"1:11:6:6:1.0:5.75:0.5:0.6");

//make pitch sets
//int ix, int numchgs, String pitchsets
~proc.sendMsg("/mkpitchset", 0, 1, "1:2:3:4");

//make articulations
//int ix, int numarticulations, String articulations to use
~proc.sendMsg("/mkart", 3, 13, "trill.svg:Bartok_pizz.svg:accent.svg:harmonics.svg:tongueslap.svg:flz.svg:multi.svg");



