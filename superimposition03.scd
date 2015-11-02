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

//ix, track, on/off
~proc.sendMsg("/drh", 0, 0, 1);
//ix, num of partials to sustain
~proc.sendMsg("/mksus", 0, 8);
//ix, pitch distribution mode, colon delimited string of args
////mode 0 - jumping around: rangepct:tessaturamin:tessaturamax
~proc.sendMsg("/mkpitch", 0, 0, "0.05:0.0:1.0");
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
//int ryhthmix, int dynamics mode, int pitch class mode, String args
//MODE 0 - Random Jumps: String "init dynamic, num jumps, min num of inc, max num of inc"
~proc.sendMsg("/mkdyn", 0, 0, 0, "5:7:3:5");
//MODE 1 - Crescendos: String "init dynamic, num cres, min num of dynamic inc, max num of dynamic inc, min length-beats, max length-beats, max beats between cres"
~proc.sendMsg("/mkdyn", 0, 1, 0, "1:7:2:5:1.0:2.75:1.0");
//MODE 2 - Decrescendos: String "init dynamic, num cres, min num of dynamic inc, max num of dynamic inc, min length-beats, max length-beats, max beats between cres"
~proc.sendMsg("/mkdyn", 0, 2, 0, "7:11:6:6:1.0:5.75:0.5");
//MODE 3 - Hairpins: String "init dynamic, num cres, min num of dynamic inc, max num of dynamic inc, min length-beats, max length-beats, max beats between cres, crescendo:decrescendo ratio in decimal percentage"
~proc.sendMsg("/mkdyn", 0, 3, 0, "1:11:6:6:1.0:5.75:0.5:0.6");

//make pitch sets
//int ix, int numchgs, String pitchsets
~proc.sendMsg("/mkpitchset", 0, 1, "1:2:3:4");




~proc.sendMsg("/dtup", 70109014, 0,0);
~proc.sendMsg("/dtup", 1708, 0,1);

~proc.sendMsg("/drhset", 0, 1, 1);
~proc.sendMsg("/drh", 0, 0, 1);





//These make the rhythm trees sets
//ix, nbts, div, startbt(float), end(float), track
//make 8th notes - 0
~proc.sendMsg("/mktup1", 0, 1, 2, 0.0, 16.0);
//make 7:3 notes - 1
~proc.sendMsg("/mktup1", 1, 3, 7, 0.0, 16.0);
//make 17:7 notes - 2
~proc.sendMsg("/mktup1", 2, 7, 17, 0.0, 16.0);
//make 3:5, 11:7 notes - 3
~proc.sendMsg("/mktup2", 3, 5, 3, 7, 11, 0.0, 16.0);

//make rhythm
// /mkrhythm: mk(int ix, int tr)
// This creates a rhythmic set
// /adrhythm: ad(int ix, float st, float end, int tix)
// This adds rhythms from the above rhythm trees: start beat & end beat
~proc.sendMsg("/mkrhythm", 0, 0); //- 8th
~proc.sendMsg("/adrhythm", 0, 0.0, 16.0, 0);
~proc.sendMsg("/mkrhythm", 1, 0); //- 7:3
~proc.sendMsg("/adrhythm", 1, 0.0, 16.0, 1);
~proc.sendMsg("/mkrhythm", 2, 0); //- 17:7
~proc.sendMsg("/adrhythm", 2, 0.0, 16.0, 2);
~proc.sendMsg("/mkrhythm", 3, 0); //- 3:5, 11:7
~proc.sendMsg("/adrhythm", 3, 0.0, 16.0, 3);
~proc.sendMsg("/mkrhythm", 100, 1); //- 8th
~proc.sendMsg("/adrhythm", 100, 0.0, 16.0, 0);
~proc.sendMsg("/mkrhythm", 101, 1); //- 7:3
~proc.sendMsg("/adrhythm", 101, 0.0, 16.0, 1);
~proc.sendMsg("/mkrhythm", 102, 1); //- 17:7
~proc.sendMsg("/adrhythm", 102, 0.0, 16.0, 2);
~proc.sendMsg("/mkrhythm", 103, 1); //- 3:5, 11:7
~proc.sendMsg("/adrhythm", 103, 0.0, 16.0, 3);


~proc.sendMsg("/mkrhythm", 4, 0); // 4 - composit
~proc.sendMsg("/adrhythm", 4, 0.0, 16.0, 3);
~proc.sendMsg("/adrhythm", 4, 0.0, 16.0, 2);

~proc.sendMsg("/mkrhythm", 14, 1); // 4 - composit
~proc.sendMsg("/adrhythm", 14, 0.0, 16.0, 3);
~proc.sendMsg("/adrhythm", 14, 0.0, 16.0, 2);

~proc.sendMsg("/mkrhythm", 104, 1); // 104 - composit
~proc.sendMsg("/adrhythm", 104, 0.0, 16.0, 3);
~proc.sendMsg("/adrhythm", 104, 0.0, 16.0, 2);


~proc.sendMsg("/mkrhythm", 5, 0); // 5 - composit
~proc.sendMsg("/adrhythm", 5, 0.0, 16.0, 3);
~proc.sendMsg("/adrhythm", 5, 0.0, 16.0, 2);
~proc.sendMsg("/adrhythm", 5, 0.0, 16.0, 1);

~proc.sendMsg("/mkrhythm", 105, 1); // 105 - composit
~proc.sendMsg("/adrhythm", 105, 0.0, 16.0, 3);
~proc.sendMsg("/adrhythm", 105, 0.0, 16.0, 2);
~proc.sendMsg("/adrhythm", 105, 0.0, 16.0, 1);

//makes a set by skipping x number of the set
//"2,3,5" gets numbers 2,5,10,12,15,20,22...
~proc.sendMsg("/alset", 4, "2,0,4,6,0,1");
~proc.sendMsg("/alset", 14, "1");
~proc.sendMsg("/alset", 104, "5,2,2,7,1");
~proc.sendMsg("/alset", 5, "6,3,4,8,2,3,1,0,5");
~proc.sendMsg("/alset", 105, "3,7,2");


~proc.sendMsg("/alset", 0, "2,3,5");



~proc.sendMsg("/alset", 4, "5,2,2,7,1");

~proc.sendMsg("/drtog", 23, 0);
~proc.sendMsg("/drtog", 22, 0);



//8th
~proc.sendMsg("/drtog", 0, 1);
~proc.sendMsg("/drtog", 0, 0);

~proc.sendMsg("/drtog", 100, 1);
~proc.sendMsg("/drtog", 100, 0);

//7:3
~proc.sendMsg("/drtog", 1, 1);
~proc.sendMsg("/drtog", 1, 0);

~proc.sendMsg("/drtog", 101, 1);
~proc.sendMsg("/drtog", 101, 0);

//17:7
~proc.sendMsg("/drtog", 2, 1);
~proc.sendMsg("/drtog", 2, 0);

~proc.sendMsg("/drtog", 102, 1);
~proc.sendMsg("/drtog", 102, 0);

//3:5, 11:7
~proc.sendMsg("/drtog", 3, 1);
~proc.sendMsg("/drtog", 3, 0);

~proc.sendMsg("/drtog", 103, 1);
~proc.sendMsg("/drtog", 103, 0);

//combo 1
~proc.sendMsg("/drtog", 4, 1);
~proc.sendMsg("/drtog", 4, 0);
~proc.sendMsg("/drtog", 14, 1);
~proc.sendMsg("/drtog", 14, 0);

~proc.sendMsg("/drtog", 104, 1);
~proc.sendMsg("/drtog", 104, 0);

//combo 2
~proc.sendMsg("/drtog", 5, 1);
~proc.sendMsg("/drtog", 5, 0);

~proc.sendMsg("/drtog", 105, 1);
~proc.sendMsg("/drtog", 105, 0);


//fix add rhythm so that no conflict with start and end beats
//add algorithms and a draw set



