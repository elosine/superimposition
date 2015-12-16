
(
s.options.memSize = 81920;
s.waitForBoot{
	fork{
		// VARIABLES ///////////////////
		var proc = NetAddr("127.0.0.1", 12321);
		var procfx = NetAddr("127.0.0.1", 12322);
		var g0 = Group.new(s);
		var g0b = Group.after(g0);
		var g1 = Group.after(g0b);
		var g2 = Group.after(g1);
		//Score Index/Cursor
		var scorerunfunc, scrctlwin, scrctlbut;
		var scoreixbuf = Buffer.alloc(s, s.sampleRate*16);
		var scoreixAbus = Bus.audio(s);
		var scoreixKbus = Bus.control(s);
		//Live Processing
		var sampbus = {Bus.audio(s, 1)}!20;
		var ixabus = {Bus.audio(s, 1)}!20;
		var ixkbus = {Bus.control(s, 1)}!20;
		var kbus = {Bus.control(s, 33)}!20;
		var bufnames = Array.newClear(0);
		var bufdurs = Array.newClear(0);
		var samps = SoundFile.collectIntoBuffers( "/Users/jyang/GitHub/OSCgui/samples/*");
		var numlivesamps = 2;
		var wff = {
			arg buf, numpx, pl;
			buf.loadToFloatArray(action:{
				arg array;
				var bufarray = array.copyRange(0, array.size-1);
				var newsampsize = numpx;
				var newsamplerate = (bufarray.size/newsampsize).round;
				var resampedArray = Array.newClear(newsampsize+3);
				var ct = 0;
				bufarray.do{ arg it, ix;
					if( ix%newsamplerate == 0, {
						resampedArray[ct] = it.asFloat;
						ct = ct+1;
					}); //end if statement: if( ix%newsamplerate == 0
				}; //end for loop bufarray.do{
				resampedArray = resampedArray.insert(0, pl.asInteger);
				resampedArray = resampedArray.insert(0, numpx.asInteger);
				resampedArray = resampedArray.insert(0, "/wavfrm");
				procfx.sendBundle(0.0, resampedArray);
			}); //end b.loadToFloatArray(action:{
		}; //end wff function
		samps.do{ |it ix| var nm = it.path.split($/); bufnames = bufnames.add(nm[nm.size-1].asString) }; //get buf names
		samps.do{|it ix| bufdurs = bufdurs.add((it.numFrames/it.sampleRate).asFloat)}; //get buf durs
		//Add Live Sampling Buffers & Update bufnames and bufdurs
		numlivesamps.do{|ix|
			samps = samps.add( Buffer.alloc(s, s.sampleRate*16.0) );
			bufnames = bufnames.add("livesampling"++ix);
			bufdurs = bufdurs.add(16.0);
		};
		scoreixAbus.index.postln;
		~g0c = Group.after(g0);
		//SYNTH DEFS
		SynthDef(\indexer, {
			arg buf, spd=1, start=0, end=1, abus=99, kbus, t_tr=0, pos=0;
			var index, indexnorm;
			index = Phasor.ar(t_tr, BufRateScale.kr(buf)*spd, start*BufFrames.kr(buf), end*BufFrames.kr(buf), pos*BufFrames.kr(buf));
			indexnorm = index.linlin(0.0, BufFrames.kr(buf), 0.0, 1.0);
			Out.ar(abus, index);
			Out.kr(kbus, indexnorm);
		}).add;
		SynthDef(\sampplay, {
			arg idxbus, obs=0, buf, gate=1;
			var index, samp, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.01, curve:0),gate);
			index = In.ar(idxbus).poll;
			samp = BufRd.ar(1, buf, index);
			Out.ar(obs, samp*env);
		}).add;
		SynthDef(\bufrec, {
			arg ich=0, idxbus, buf, gate=1;
			var in, idx, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.01, curve:0),gate, doneAction:2);
			idx = In.ar(idxbus);
			in = SoundIn.ar(ich);
			BufWr.ar(in*env, buf, idx);
		}).add;
		//// FXs ////////////////////////////////
		SynthDef(\amplify, {
			arg ibs, obs=0, gate=1;
			var src, sig, env, amp;
			amp = \amp.kr(0.85, 0.03);
			env = EnvGen.ar(Env.asr(releaseTime:0.1),gate,doneAction:2);
			src = In.ar(ibs);
			sig = src;
			Out.ar(obs, sig*env*amp);
		}).add;
		SynthDef(\greyhole, {
			arg ibs, obs=0, gate=1, rel=0.7;
			var del=\del.kr(2, 0.03), damp=\damp.kr(0, 0.03), size=\size.kr(1, 0.03),
			diff=\diff.kr(0.707, 0.03), fb=\fb.kr(0.9, 0.03), moddepth=\moddepth.kr(0.1, 0.03), modfreq=\modfreq.kr(2, 0.03);
			var source, sig, env, amp;
			amp = \amp.kr(0.8, 0.03);
			env = EnvGen.ar(Env.asr(releaseTime:rel), gate, doneAction:2);
			source = In.ar(ibs);
			sig = Greyhole.ar(source, del, damp, size, diff, fb, moddepth, modfreq);
			Out.ar(obs, sig*env*amp);
		}).add;
		//// OSC DEFS ////////////////////////////////
		////// INS //////////////
		OSCdef(\mklivesamp, {|msg|
			var gr = msg[1].asInteger;
			var pl = msg[2].asInteger;
			var lbl = msg[3].asString;
			var mode = msg[4].asInteger;
			var buf;
			if( mode==1, { //mode=1, on
				//look up buffernumber by label and set buf to bufnumber
				bufnames.do{|it ix| if(it==lbl,{buf=samps[ix].bufnum})};
				buf.postln;
				gr.postln;
				//start a buf record at node 7000+gr into buf
				s.sendMsg( \s_new, \bufrec, 7000+gr, 0, g0b.nodeID, \buf, buf, \ich, gr, \idxbus, scoreixAbus.index, \gate, 1); //scoreixAbus.index
				},
				{ //mode=0, off

			});
		}, "/mklivesamp");
		0.1.wait;
		//Score IX //////////////////////////
		OSCdef( \getscoreidx,{ scoreixKbus.get({arg val; proc.sendMsg("/scoreix", val)}) }, "/getscoreidx");
		////// Sampling IX //////////////
		OSCdef(\getix, {|msg|
			var pl = msg[1].asInteger;
			ixkbus[pl].get({ |val| procfx.sendMsg("/ix", pl, val.asFloat) });
		}, "/getix");
		OSCdef(\setix, {|msg|
			var pl = msg[1].asInteger;
			var sampnum = msg[2].asInteger;
			var start = msg[3].asFloat;
			var end = msg[4].asFloat;
			s.sendMsg( \n_set, 3000+pl, \start, start, \end, end );
		}, "/setix");
		OSCdef(\getwf, { |msg|
			var pl = msg[1].asInteger;
			var bufnum = msg[2].asInteger;
			var numpx = msg[3].asInteger;
			//change buffer of index/play synths if currently playing
			s.sendMsg( \n_set, 3000+pl, \buf, samps[bufnum].bufnum );
			s.sendMsg( \n_set, 4000+pl, \buf, samps[bufnum].bufnum );
			wff.value(samps[bufnum], numpx, pl);
		}, "/getwf");
		OSCdef(\getlivewf, { |msg|
			var pl = msg[1].asInteger;
			var bufnum = msg[2].asInteger;
			var numpx = msg[3].asInteger;
			//change buffer of index/play synths if currently playing
			s.sendMsg( \n_set, 8000+pl, \buf, samps[bufnum].bufnum );
			wff.value(samps[bufnum], numpx, pl);
		}, "/getlivewf");
		OSCdef(\getsampnames, { |msg|
			var pl = msg[1].asInteger;
			var sn = bufnames.copyRange(0, bufnames.size-1);
			var numbufs = sn.size.asInteger;
			sn = sn.insert(0, pl);
			sn = sn.insert(0, numbufs);
			sn = sn.insert(0, "/sampnames");
			procfx.sendBundle(0.0, sn);
		}, "/getsampnames");
		OSCdef(\playsamp, { |msg|
			var pl = msg[1].asInteger;
			var sampnum = msg[2].asInteger;
			var type = msg[3].asInteger;
			var mode = msg[4].asInteger;
			fork{
				switch( mode,
					0, {
						s.sendMsg( \n_set, 3000+pl, \spd, 0);
						s.sendMsg( \n_set, 4000+pl, \gate, 0);
					},
					1, { if(type==0,{
						s.sendMsg( \s_new, \indexer, 3000+pl, 0, g0.nodeID, \buf, samps[sampnum].bufnum, \abus, ixabus[pl].index, \kbus, ixkbus[pl].index);
						s.sendMsg( \s_new, \sampplay, 4000+pl, 0, g1.nodeID, \obs, sampbus[pl].index, \buf, samps[sampnum].bufnum, \idxbus, ixabus[pl].index) },
						{s.sendMsg( \s_new, \indexer, 3000+pl, 0, g0.nodeID, \buf, samps[sampnum].bufnum, \abus, scoreixAbus.index, \kbus, scoreixKbus.index);
						s.sendMsg( \s_new, \sampplay, 4000+pl, 0, g1.nodeID, \obs, sampbus[pl].index, \buf, samps[sampnum].bufnum, \idxbus, scoreixAbus.index)});


						s.sendMsg( \n_set, 3000+pl, \spd, 1);
						s.sendMsg( \n_set, 4000+pl, \gate, 1);

					}
				);
			}
		}, "/playsamp");

		OSCdef(\sl, {|msg|
			var gr = msg[1].asInteger;
			var pl = msg[2].asInteger;
			var lbl = msg[3].asSymbol;
			var val = msg[4].asFloat;
			kbus[gr].setAt(pl, val);
		}, "/sl");
		OSCdef(\amplify, {|msg|
			var gr = msg[1].asInteger;
			var pl = msg[2].asInteger;
			var lbl = msg[3].asSymbol;
			var mode = msg[4].asInteger;
			fork{
				switch( mode,
					0, {
						s.sendMsg(\n_set, 5000+gr, \gate, 0);
						procfx.sendMsg("/slclear");
					},
					1, {
						s.sendMsg( \s_new, lbl, 5000+gr, 0, g2.nodeID, \ibs, sampbus[gr].index); //start amplify synth
						procfx.sendMsg("/slclear");
						procfx.sendMsg("/mksl2", 0, 50, 350, "amp", 0.0, 1.0, 34);
						//index+0 0 corresponds to slider created in line above
						s.sendMsg(\n_map, 5000+gr, \amp, kbus[gr].index+0);
						//Presets
						procfx.sendMsg("/slchg", 0, 0.95);
					}
				)//end switch
			}//end fork
		}, "/amplify"); //end OSCdef
		OSCdef(\greyhole, {|msg|
			var gr = msg[1].asInteger;
			var pl = msg[2].asInteger;
			var lbl = msg[3].asSymbol;
			var mode = msg[4].asInteger;
			fork{
				switch( mode,
					0, {
						s.sendMsg(\n_set, 6000+gr, \gate, 0);
						procfx.sendMsg("/slclear");
					},
					1, {
						s.sendMsg( \s_new, lbl, 6000+gr, 0, g2.nodeID, \ibs, sampbus[gr].index);
						procfx.sendMsg("/slclear");
						procfx.sendMsg("/mksl2", 0, 50, 350, "amp", 0.0, 1.0, 34);
						procfx.sendMsg("/mksl2", 1, 120, 350, "delay", 0.1, 9.0, 7);
						procfx.sendMsg("/mksl2", 2, 190, 350, "damp", 0.0, 1.0, 8);
						procfx.sendMsg("/mksl2", 3, 260, 350, "size", 0.5, 5.0, 9);
						procfx.sendMsg("/mksl2", 4, 330, 350, "diff", 0.0, 1.0, 14);
						procfx.sendMsg("/mksl2", 5, 400, 350, "feedback", 0.0, 1.0, 27);
						procfx.sendMsg("/mksl2", 6, 470, 350, "modDepth", 0.0, 1.0, 32);
						procfx.sendMsg("/mksl2", 7, 540, 350, "modFreq", 0.0, 10.0, 10);
						//index+0 0 corresponds to slider created in line above
						s.sendMsg(\n_map, 6000+pl, \amp, kbus[gr].index+0);
						s.sendMsg(\n_map, 6000+pl, \del, kbus[gr].index+1);
						s.sendMsg(\n_map, 6000+pl, \damp, kbus[gr].index+2);
						s.sendMsg(\n_map, 6000+pl, \size, kbus[gr].index+3);
						s.sendMsg(\n_map, 6000+pl, \diff, kbus[gr].index+4);
						s.sendMsg(\n_map, 6000+pl, \fb, kbus[gr].index+5);
						s.sendMsg(\n_map, 6000+pl, \moddepth, kbus[gr].index+6);
						s.sendMsg(\n_map, 6000+pl, \modfreq, kbus[gr].index+7);
						//Presets
						//procfx.sendMsg("/slchg", 0, 0.95);
					}
				)//end switch
			}//end fork
		}, "/greyhole"); //end OSCdef

		//Set Up Score Controls
		//Function to run through score numbers to a point in score - system 1 is evens
		scorerunfunc = {|endnum|
			fork{
				proc.sendMsg("/clrall");
				0.1.wait;
				if(endnum.even,{proc.sendMsg("/togcsr", 0);s.sendMsg(\n_set,99999,\t_tr, 1,\pos, 0.75,\spd, 0)},
					{proc.sendMsg("/togcsr", 1); s.sendMsg(\n_set,99999,\t_tr, 1, \pos, 0.75, \spd, 0)});
				0.1.wait;
				endnum.do{|ix|proc.sendMsg("/scrnum", ix);0.2.wait};
		}}; //end fork & scorerunfunc
		scorerunfunc.value(1); //set score to beginning position
		//SCORE CONTROL GUI
		0.5.wait;
		{ scrctlwin = Window.new( "Score Control", bounds:Rect(20,950,200,80) ).layout_(HLayout(
			scrctlbut = Button()
			.states_([ ["Go", Color.black, Color.green],
				["Stop", Color.black, Color.red] ])
			.action_({ |bt| s.sendMsg(\n_set,99999,\spd, bt.value/*0.667*/) })
			.minHeight_(80),
			TextField().action_({|tf|scorerunfunc.value(tf.value.asInteger);scrctlbut.value_(0)})
			.font_(Font("Monaco", 33))
			.minHeight_(80)
		)).front }.defer;
		//Start Main Cursor/IX Synth
		0.1.wait;
		s.sendMsg( \s_new, \indexer, 99999, 0, g0.nodeID, \buf, scoreixbuf.bufnum, \spd, 0, \pos, 0.75, \t_tr, 1, \bus, scoreixAbus.index, \kbus, scoreixKbus.index);

	}//end fork
}//end s.waitForBoot
)
s.meter;
n=NetAddr("127.0.0.1", 57120);
n.sendMsg("/mklivesamp", 0, 0, "livesampling0", 1);
	s.queryAllNodes