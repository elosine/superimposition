(
s.waitForBoot {
	fork {
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
			arg buf, spd=1, bus, numbts=1.0, start=0.0, end=1.0, kbus, t_tr=0, pos=0;
			var indexer, indexnorm;
			//create an audio rate indexer using the Phasor object
			indexer = Phasor.ar(t_tr, BufRateScale.kr(buf)*spd, start*BufFrames.kr(buf), end*BufFrames.kr(buf), pos*BufFrames.kr(buf));
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
		0.1.wait;
		(~numtrx+1).do{ |ix| ~ixsynths[ix] = Synth(\bufidx, [\buf, ~ixbufs[ix], \spd, 0, \pos, 0.75, \t_tr, 1, \bus, ~ixbuses[ix], \kbus, ~ixkbuses[ix]], ~ixgr) };
		0.1.wait;



		//Function to run through score numbers to a point in score - system 1 is evens
		~srun = {|endnum|
			fork{
				~proc.sendMsg("/clrall");
				0.1.wait;
				if(endnum.even,{ ~proc.sendMsg("/togcsr", 0); ~ixsynths[0].set(\t_tr, 1, \pos, 0.75, \spd, 0 );},
					{~proc.sendMsg("/togcsr", 1); ~ixsynths[0].set(\t_tr, 1, \pos, 0.75, \spd, 0 );});
				0.1.wait;
				endnum.do{|ix|
					~proc.sendMsg("/scrnum", ix);
					0.2.wait
				};
		}};



~srun.value(1);

		//GUI
		0.5.wait;
		{~w = Window.new( "Score Control", bounds:Rect(20,950,200,80) ).layout_(
			HLayout(
				~b= Button()
				.states_([ ["Go", Color.black, Color.green],
					["Stop", Color.black, Color.red] ])
				.action_({|bt|~ixsynths[0].set(\spd, bt.value)})
				.minHeight_(80),
				TextField().action_({|tf|~srun.value(tf.value.asInteger);~b.value_(0)})
				.font_(Font("Monaco", 33))
				.minHeight_(80)
			)
		).front}.defer;

	} //end fork
}//end s.WaitForBoot
)




