/*
2 ins - live in
make a separate processor for sample player/recorder
1 effects bus
pass thru synthdef
*/

(
s.options.memSize = 245760;
s.waitForBoot{
	fork{
		var g0 = Group.new(s);
		var g1 = Group.after(g0);
		var ab = {Bus.audio(s)}!2;
		var audioInBusses = {Bus.audio(s)}!2;
		var proc = NetAddr("127.0.0.1", 12321);
		var freezebufs = {Buffer.alloc(s, s.sampleRate*2)}!20; //buffer for freeze effect
		var freezebufinc = 0;
		var envbufs = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/superimposition/grainEnv/*");
		//Sample Player
		var stereosamps = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/DSP_Framework/stereosamples/*");
		var monosamps = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/DSP_Framework/monosamples/*");
		var sampnames = Array.newClear(0); //array of all the soundfile names
		var mono2stereosamps, stereo2monosamps, samples, sampdurs;
		// For Live Sampling /////////////////////////////////////////
		var numsamps = 8;
		var maxsamplength = 16.0;
		var idxbufs = {Buffer.alloc(s, s.sampleRate*maxsamplength, 1)}!numsamps; //buffers to hold sample index
		var sampbufs = {Buffer.alloc(s, s.sampleRate * maxsamplength, 1)}!numsamps; //buffers to hold sample audio
		var idxAbusses = {Bus.audio(s)}!numsamps; //audio rate busses to hold index location
		var idxKbusses = {Bus.control(s)}!numsamps; //control rate busses to hold index location, for waveform display
		var iIdxnode = 3000;  // initial node for index synths
		var irecnode = 4000;  // initial node for index synths
		var iplaynode = 5000;  // initial node for index synths
		var recstartidxval = 0.0!numsamps;
		var recendidxval = 1.0!numsamps;
		var idxgr = Group.new(); //index group before all groups
		var recgr = Group.after(idxgr); //in group for incomming (rec) audio
		var playgr = Group.after(recgr); //out group for outgoing (play) audio
		var waveformFunc;
		var freezeinc = 0;
		var petalsinc = 0;
		var playmodes = 0!numsamps;
		var impulses = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/sc_concepts_utilities/ConvolutionReverb/impulses/*");
		var newimpulse, cr;

		0.5.wait;

		//Convolution Reverb Function
		//NEW IMPULSE FUNCTION
		newimpulse = { |inum|
			fork{
				cr.free; cr=nil;
				cr = EZConv(impulses[inum].path);
				//INSPECT
				cr.numChannels;
				cr.irSpectrum;
				//USE IN SYNTH DEF
				SynthDef(\convRev, {
					arg obs=0, sourcebuf, sourcegain=1, gain=0.5, spd=1, start=0.0, end=1.0, gate=1;
					var source, bufindexer, convolve, env;
					env = EnvGen.ar(Env.asr(), gate, doneAction:2);
					bufindexer = Phasor.ar( 0, BufRateScale.kr(sourcebuf)*spd, start*BufFrames.kr(sourcebuf), end*BufFrames.kr(sourcebuf) );
					source = BufRd.ar(2, sourcebuf, bufindexer);
					convolve = cr.ar(source*sourcegain, leak: 0.1, mul:gain);
					Out.ar(obs, convolve*env);
				}).add;
				//LIVE IN SYNTH DEF (USE HEADPHONES)
				SynthDef(\convRevLive, {
					arg ibs=0, obs=0, sourcegain=1, gain=0.5,gate=1;
					var source, convolve, env;
					env = EnvGen.ar(Env.asr(), gate, doneAction:2);
					source = In.ar(ibs);
					convolve = cr.ar(source*sourcegain, leak: 0.1, mul:gain);
					Out.ar(obs, convolve*env);
				}).add;
			}//end fork
		};//end ~newimpulse function

		//Convert Sound Files Stereo2Mono or Mono2Stereo
		//create an array of strings that hold all of the soundfile names incl the converted stereo-to-mono ones
		stereosamps.do{ |it ix| var nm = it.path.split($/); sampnames = sampnames.add(nm[nm.size-1].asString) };
		monosamps.do{ |it ix| var nm = it.path.split($/); sampnames = sampnames.add(nm[nm.size-1].asString) };
		//Convert mono soundfiles to stereo
		mono2stereosamps = Array.newClear(0);
		monosamps.do{ |it ix| mono2stereosamps = mono2stereosamps.add( Buffer.readChannel(s, it.path, channels:[0,0]) ) };

		/*
		//Convert stereo soundfiles to mono and combine all in samples
		stereo2monosamps = Array.newClear(stereosamps.size);
		stereosamps.do{ |it ix|
		it.loadToFloatArray(action: {
		arg array;
		var ar = array;
		stereo2monosamps[ix] = Buffer.loadCollection(s, ar.unlace(2).sum*0.5);
		})};
		2.wait;
		samples = monosamps.addAll(stereo2monosamps);
		*/

		1.wait;

		samples = stereosamps.addAll(mono2stereosamps);
		sampdurs = Array.newClear(0);//Create an array to hold sample durations
		samples.do{|it ix| sampdurs = sampdurs.add((it.numFrames/it.sampleRate).asFloat)};

		// SYNTH DEFS ///////////////////////////////////////////////////////////
		//INPUTS
		SynthDef(\micin, {
			arg ibs=0, obs=0, atk=0.01, rel=0.1, crv= -3, gate=1;
			var env, in;
			env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
			in = SoundIn.ar(ibs);
			Out.ar(obs, in*env);
		}).add;

		SynthDef(\sampM, {
			arg buf, obs=0, atk=0.01, rel=0.1, crv= -3, gate=1, amp=1, rate=1, start=0, loop=0;
			var env, in;
			env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
			in = PlayBuf.ar(1, buf, rate,\t_tr.kr(1,0),start,loop) ;
			Out.ar(obs, in*env*amp);
		}).add;

		SynthDef(\sampS, {
			arg buf, obs=0, atk=0.01, rel=0.1, crv= -3, gate=1, amp=1, rate=1, start=0, loop=0, t_tr=1;
			var env, in;
			env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
			in = PlayBuf.ar(2, buf, rate,t_tr,start,loop) ;
			Out.ar(obs, in*env*amp);
		}).add;

		// DSP
		SynthDef(\amplify,{
			arg ibs, obs=0, gate=1, amp=1;
			var env;
			env = EnvGen.ar(Env.asr(releaseTime:0.1),gate, doneAction:2);
			Out.ar(obs, In.ar(ibs)*env*amp);
		}).add;

		//ringmod
		SynthDef(\rm,{
			arg buf, ibs, obs=0, inamp=1, amp=1, mix=0.5, bend=1, lf1f=0.2, gate=1,
			atk=0.01, rel=0.2, crv= -4;
			var in, dfreq, hasFreq, damp, mod, rm, lf1, env;
			env = EnvGen.ar(Env.asr(atk,1,rel,crv),gate, doneAction:2);
			in = In.ar(ibs);
			in = in*inamp;
			# dfreq, hasFreq = Tartini.kr(in);
			damp = Amplitude.kr(in);
			lf1 = LFTri.kr(lf1f)*bend;
			mod = SinOsc.ar( (dfreq.cpsmidi+lf1).midicps )*damp;
			rm = DiodeRingMod.ar(in, mod);
			Out.ar(obs, rm*amp*env);
		}).add;

		//freeze
		SynthDef(\icy_live, {
			arg ibs, obs=0,buf=0, envbuf = -1, pitchshift=1, winsz=0.8, overlaps=40, resettrig=0, startpos=0.0, endpos=1.0, rand=0.1, ratemin=1.0, ratemax=0.00001, indur=1, ingate=1, dur=5, rel=1.2, crv = -6;
			var sig, ix, krate, in, writehead, whenv, durenv;
			durenv = EnvGen.ar(Env.linen(0.01, dur, rel, curve: crv),1,doneAction:2);
			writehead = Phasor.ar(0, BufRateScale.kr(buf), 0, BufFrames.kr(buf));
			whenv = EnvGen.ar(Env.linen(0.0, indur, 0.0), ingate);
			in = BufWr.ar(In.ar(ibs), buf, writehead*whenv);
			krate = \rate.kr(1, 0.05).linlin(0.0, 1.0, ratemin, ratemax);
			ix = Phasor.kr(resettrig, ((1.0/ControlRate.ir)/(BufFrames.kr(buf)/SampleRate.ir))*krate, startpos, endpos);
			sig = Warp1.ar(1, buf, ix, pitchshift, winsz, envbuf, overlaps,rand);
			Out.ar(obs, sig*durenv);
		}).add;

		//// Petals Of Resonance
		SynthDef("petalsOfResonance", {

			arg masteramp=0.5, inamp=1.0, ibs=0, obs=0, fund=200, firstPartial=2, bank2MidiOffset=0.25, spread=0.33, ringL1=7.75, ringL2=9.5, inputLen=1, trig=0;
			var	pAmp, partialTunedA, partialTunedB, input, output, outArrayA, outArrayA1, outArrayA2, outArray, inenv, ltdOutput, masterEnv, finalOut,
			p1a, p2a, p3a, p4a, p5a, p6a, p7a, p8a, p9a, p10a, p11a, p12a, p13a,
			p1b, p2b, p3b, p4b, p5b, p6b, p7b, p8b, p9b, p10b, p11b, p12b, p13b,
			resA1, resA2, resA3, resA4, resA5, resA6, resA7, resA8, resA9, resA10, resA11, resA12, resA13,
			resB1, resB2, resB3, resB4, resB5, resB6, resB7, resB8, resB9, resB10, resB11, resB12, resB13;
			var outenv;

			pAmp = -40.dbamp;

			//Two functions to create two sets of partials
			partialTunedA = 	{
				arg partialNum;
				var freq, freqMidi, tuner, freqTunedMidi, freqTuned;
				//firstPartial allows you to start the series at a higher partial than the fund
				//the fund and spread work together (maybe redundantly)
				//to determine the space between each partial
				freq = fund *( firstPartial + (spread*partialNum) );
				freqMidi = freq.cpsmidi;
				//constantly shifting tuner for each partial
				//so the sound is constantly shifting
				tuner = SinOsc.kr(rrand(0.07, 0.013), 0, 0.5);
				freqTunedMidi = freqMidi + tuner;
				freqTuned = freqTunedMidi.midicps;
			};

			partialTunedB = 	{
				arg partialNum;
				var freq, freqMidi, tuner, freqTunedMidi, freqTuned;
				freq = fund *( firstPartial + (spread*partialNum) );
				freqMidi = freq.cpsmidi;
				tuner = SinOsc.kr(rrand(0.07, 0.013), 0, 0.5);
				freqTunedMidi = freqMidi + tuner + bank2MidiOffset;
				freqTuned = freqTunedMidi.midicps;
			};

			p1a= partialTunedA.value(0);
			p2a= partialTunedA.value(1);
			p3a= partialTunedA.value(2);
			p4a= partialTunedA.value(3);
			p5a= partialTunedA.value(4);
			p6a= partialTunedA.value(5);
			p7a= partialTunedA.value(6);
			p8a= partialTunedA.value(7);
			p9a= partialTunedA.value(8);
			p10a= partialTunedA.value(9);
			p11a= partialTunedA.value(10);
			p12a= partialTunedA.value(11);
			p13a= partialTunedA.value(12);

			p1b= partialTunedB.value(0);
			p2b= partialTunedB.value(1);
			p3b= partialTunedB.value(2);
			p4b= partialTunedB.value(3);
			p5b= partialTunedB.value(4);
			p6b= partialTunedB.value(5);
			p7b= partialTunedB.value(6);
			p8b= partialTunedB.value(7);
			p9b= partialTunedB.value(8);
			p10b= partialTunedB.value(9);
			p11b= partialTunedB.value(10);
			p12b= partialTunedB.value(11);
			p13b= partialTunedB.value(12);

			input = In.ar(ibs);
			inenv = EnvGen.ar( Env.perc(0.02, inputLen, 1.0, -1), trig);
			input =  input * inamp * inenv;
			//input = PinkNoise.ar(0.5) * Decay2.ar(Impulse.ar(0.15), 0.15, 0.75);

			//Form 13 resonators for each bank/spectrum
			resA1 = DynKlank.ar(`[[p1a], nil, [rrand(ringL1, ringL2)]], input);
			resA2 = DynKlank.ar(`[[p2a], nil, [rrand(ringL1, ringL2)]], input);
			resA3 = DynKlank.ar(`[[p3a], nil, [rrand(ringL1, ringL2)]], input);
			resA4 = DynKlank.ar(`[[p4a], nil, [rrand(ringL1, ringL2)]], input);
			resA5 = DynKlank.ar(`[[p5a], nil, [rrand(ringL1, ringL2)]], input);
			resA6 = DynKlank.ar(`[[p6a], nil, [rrand(ringL1, ringL2)]], input);
			resA7 = DynKlank.ar(`[[p7a], nil, [rrand(ringL1, ringL2)]], input);
			resA8 = DynKlank.ar(`[[p8a], nil, [rrand(ringL1, ringL2)]], input);
			resA9 = DynKlank.ar(`[[p9a], nil, [rrand(ringL1, ringL2)]], input);
			resA10 = DynKlank.ar(`[[p10a], nil, [rrand(ringL1, ringL2)]], input);
			resA11 = DynKlank.ar(`[[p11a], nil, [rrand(ringL1, ringL2)]], input);
			resA12 = DynKlank.ar(`[[p12a], nil, [rrand(ringL1, ringL2)]], input);
			resA13 = DynKlank.ar(`[[p13a], nil, [rrand(ringL1, ringL2)]], input);

			resB1 = DynKlank.ar(`[[p1b], nil, [rrand(ringL1, ringL2)]], input);
			resB2 = DynKlank.ar(`[[p2b], nil, [rrand(ringL1, ringL2)]], input);
			resB3 = DynKlank.ar(`[[p3b], nil, [rrand(ringL1, ringL2)]], input);
			resB4 = DynKlank.ar(`[[p4b], nil, [rrand(ringL1, ringL2)]], input);
			resB5 = DynKlank.ar(`[[p5b], nil, [rrand(ringL1, ringL2)]], input);
			resB6 = DynKlank.ar(`[[p6b], nil, [rrand(ringL1, ringL2)]], input);
			resB7 = DynKlank.ar(`[[p7b], nil, [rrand(ringL1, ringL2)]], input);
			resB8 = DynKlank.ar(`[[p8b], nil, [rrand(ringL1, ringL2)]], input);
			resB9 = DynKlank.ar(`[[p9b], nil, [rrand(ringL1, ringL2)]], input);
			resB10 = DynKlank.ar(`[[p10b], nil, [rrand(ringL1, ringL2)]], input);
			resB11 = DynKlank.ar(`[[p11b], nil, [rrand(ringL1, ringL2)]], input);
			resB12 = DynKlank.ar(`[[p12b], nil, [rrand(ringL1, ringL2)]], input);
			resB13 = DynKlank.ar(`[[p13b], nil, [rrand(ringL1, ringL2)]], input);

			//Make an array of resonators and scramble them up
			outArrayA = [ resA1*pAmp, resA2*pAmp, resA3*pAmp, resA4*pAmp, resA5*pAmp, resA6*pAmp, resA7*pAmp, resA8*pAmp, resA9*pAmp, resA10*pAmp,
				resA11*pAmp, resA12*pAmp, resA13*pAmp, resB1*pAmp, resB2*pAmp, resB3*pAmp, resB4*pAmp, resB5*pAmp, resB6*pAmp, resB7*pAmp,
				resB8*pAmp, resB9*pAmp, resB10*pAmp, resB11*pAmp, resB12*pAmp, resB13*pAmp ].scramble;

			//For Stereo or Multichannel
			//outArrayA1 = outArrayA.copyRange(0, (outArrayA.size/2).asInteger);
			//outArrayA2 = outArrayA.copyRange((outArrayA.size/2).asInteger, outArray.size);
			//outArrayA1 = Mix.ar(outArrayA1);
			//outArrayA2 = Mix.ar(outArrayA2);

			//Mixes resonators to a mono channel
			outArrayA = Mix.ar(outArrayA);

			ltdOutput = Limiter.ar(outArrayA, 0.98, 0.01);
			outenv = EnvGen.ar(Env.linen(0.01, ringL2, 0.3), 1, doneAction:2);

			Out.ar(obs, ltdOutput*masteramp*outenv);

			}, [0.069]
		).add;

		//Grainy
		SynthDef(\grainy, {
			arg gdur=1, grate=1, gspd=1, envbuf,
			gdur2=1, grate2=1, gspd2=1,  envbuf2,
			gdur3=1, grate3=1, gspd3=1,  envbuf3,
			gdur4=1, grate4=1, gspd4=1,  envbuf4,
			mrate=1, start=0, end=1, buf, scrub=0, amp=0.85, gate=1, gate2=1,
			atk=1.5, rel=3, crv=0;
			var sig, env2, envmain;
			var gfreq, mph, gr;
			var gfreq2, mph2, gr2;
			var gfreq3, mph3, gr3;
			var gfreq4, mph4, gr4;
			envmain = EnvGen.ar(Env.asr(atk,1,rel,crv), gate, doneAction:2);
			env2 = EnvGen.ar(Env.asr(atk,1,rel,crv), gate2);
			gfreq = 1.0/grate;
			gfreq2 = 1.0/grate2;
			gfreq3 = 1.0/grate3;
			gfreq4 = 1.0/grate4;
			mph = Phasor.ar( \t_tr.kr(1, 0), (1.0/BufFrames.kr(buf))*mrate, start, end, start );
			mph = (mph+scrub)%1;
			mph2 = (mph+0.25)%1;
			mph3 = (mph+0.5)%1;
			mph4 = (mph+0.75)%1;
			gr = GrainBuf.ar(1, Impulse.ar(gfreq),gdur, buf, gspd, mph,envbufnum:envbuf);
			gr2 = GrainBuf.ar(1, Impulse.ar(gfreq2),gdur2, buf, gspd2, mph,envbufnum:envbuf2);
			gr3 = GrainBuf.ar(1, Impulse.ar(gfreq3),gdur3, buf, gspd3, mph,envbufnum:envbuf3);
			gr4 = GrainBuf.ar(1, Impulse.ar(gfreq4),gdur4, buf, gspd4, mph,envbufnum:envbuf4);
			sig = Mix.ar([gr*0.25, gr2*0.25, gr3*0.25, gr4*0.25]);
			Out.ar(0, sig*amp*envmain*env2);
		}).add;

		//// CONVOLUTION REVERB ///////////////////////////////////////////////////////////////////////////////////
		cr = EZConv(impulses[0].path);
		0.1.wait;
		//INSPECT
		cr.numChannels;
		cr.irSpectrum;
		0.1.wait;
		SynthDef(\convRev, {
			arg obs=0, sourcebuf, sourcegain=1, gain=0.5, spd=1, start=0.0, end=1.0, gate=1;
			var source, bufindexer, convolve, env;
			env = EnvGen.ar(Env.asr(), gate, doneAction:2);
			bufindexer = Phasor.ar( 0, BufRateScale.kr(sourcebuf)*spd, start*BufFrames.kr(sourcebuf), end*BufFrames.kr(sourcebuf) );
			source = BufRd.ar(2, sourcebuf, bufindexer);
			convolve = cr.ar(source*sourcegain, leak: 0.1, mul:gain);
			Out.ar(obs, convolve*env);
		}).add;
		//LIVE IN SYNTH DEF (USE HEADPHONES)
		SynthDef(\convRevLive, {
			arg ibs=0, obs=0, sourcegain=1, gain=0.5,gate=1;
			var source, convolve, env;
			env = EnvGen.ar(Env.asr(), gate, doneAction:2);
			source = In.ar(ibs);
			convolve = cr.ar(source*sourcegain, leak: 0.1, mul:gain);
			Out.ar(obs, convolve*env);
		}).add;

		//// LIVE SAMPLING ///////////////////////////////////////////////////////////////////////////////////
		SynthDef(\bufidx,{
			arg buf, spd=1, bus, start=0.0, end=1.0, kbus;
			var indexer, indexnorm;
			//create an audio rate indexer using the Phasor object
			indexer = Phasor.ar(trig:0, rate:BufRateScale.kr(buf)*spd, start:start*BufFrames.kr(buf), end:end*BufFrames.kr(buf));
			//normalize the index
			indexnorm = indexer.linlin(0.0, BufFrames.kr(buf), 0.0, 1.0);
			//send the index out to both a control and audio rate bus
			Out.ar(bus, indexer);
			Out.kr(kbus, indexnorm);
		}).add;

		SynthDef(\bufrec, {
			arg ich=0, idxbus, buf, gate=1;
			var in, idx, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.08, curve:0),gate, doneAction:2);
			idx = In.ar(idxbus);
			in = SoundIn.ar(ich);
			BufWr.ar(in*env, buf, idx);
		}).add;

		SynthDef(\bufpl, {
			arg idxbus, obs=0, buf, gate=1;
			var idx, sig, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.08, curve:0),gate, doneAction:2);
			idx = In.ar(idxbus);
			sig = BufRd.ar(1, buf, idx);
			Out.ar(obs, sig*env);
		}).add;

		//OSCdefs
		//Send soundfile names on demand
		OSCdef(\sfnames, {
			var bnd, durs;
			bnd = Array.newFrom(sampnames);
			bnd.insert(0,sampnames.size);
			bnd.insert(0, "/sfs");
			~proc.sendBundle(0.0, bnd);
			durs = Array.newFrom(sampdurs);
			durs.insert(0,sampdurs.size.asInteger);
			durs.insert(0, "/sdurs");
			~proc.sendBundle(0.0, durs);
		}, "/sfnames");

		OSCdef(\playsamp, {|msg| msg.postln;s.sendMsg(\n_set, 7000, \t_tr, 1, \buf, samples[msg[1].asInteger].bufnum, \gate, 1)}, "/playsamp");

		//live mic effects
		////amplify
		OSCdef(\Amplify, { |msg|
			var player, mode;
			player = msg[1].asInteger;
			mode = msg[2].asInteger;
			if(mode==1,
				{s.sendMsg(\s_new, \amplify, 5100+player, 0, g1.nodeID, \ibs, audioInBusses[player].index, \obs, player)},
				{s.sendMsg(\n_set, 5100+player, \gate, 0)}
		)}, "/Amplify");

		////ringmod1
		OSCdef(\RingMod1, { |msg|
			var player, mode;
			player = msg[1].asInteger;
			mode = msg[2].asInteger;
			if(mode==1,
				{s.sendMsg(\s_new, \rm, 5200+player, 0, g1.nodeID, \ibs, audioInBusses[player].index, \obs, player, \bend, 5, \lf1f, 0.2, \inamp, 2, \rel, 0.2)},
				{s.sendMsg(\n_set, 5200+player, \gate, 0)}
		)}, "/RingMod1");

		////ringmod2
		OSCdef(\RingMod2, { |msg|
			var player, mode;
			player = msg[1].asInteger;
			mode = msg[2].asInteger;
			if(mode==1,
				{s.sendMsg(\s_new, \rm, 5300+player, 0, g1.nodeID, \ibs, audioInBusses[player].index, \obs, player, \bend, 0.5, \lf1f, 0.02, \inamp, 2, \rel, 0.2)},
				{s.sendMsg(\n_set, 5300+player, \gate, 0)}
		)}, "/RingMod2");

		////IR
		OSCdef(\IR, { |msg|
			var player, mode;
			var imp = impulses.size.rand.round; //choose impulse at random
			fork{
				player = msg[1].asInteger;
				mode = msg[2].asInteger;
				if(mode==1, {
					s.sendMsg(\n_free, 5600+player); //free any previously exsisting synth
					newimpulse.value(imp); //prepare a new randomly chosen impulse
					postln(impulses[imp]);//print out which impulse you are using
					0.1.wait;
					s.sendMsg(\s_new, \convRevLive, 5600+player, 0, g1.nodeID, \ibs, audioInBusses[player].index, \obs, player)}, //end if mode==1, then
					{s.sendMsg(\n_set, 5600+player, \gate, 0)} //end if mode==1 else
				)//end if mode==1
			}//end fork
		}, "/IR");

		////Freeze
		OSCdef(\Freeze, { |msg|
			var player, mode;
			player = msg[1].asInteger;
			mode = msg[2].asInteger;
			if(mode==1,
				{s.sendMsg(\s_new, \icy_live, 5400+(freezeinc%100), 0, g1.nodeID, \ibs, audioInBusses[player].index, \obs, player, \buf, freezebufs[freezebufinc%20].bufnum, \winsz, 0.6, \overlaps, 17, \rand, 0.5, \envbuf, envbufs[3].bufnum, \dur, 13, \indur, 2, \rate, 0.97, \rel, 3, \crv, -3 ); freezeinc = freezeinc+1;freezebufinc = freezebufinc+1}
		)}, "/Freeze");

		////Petals of Resonance
		OSCdef(\Petals, { |msg|
			var player, mode;
			player = msg[1].asInteger;
			mode = msg[2].asInteger;
			if(mode==1,
				{s.sendMsg(\s_new, \petalsOfResonance, 5500+(petalsinc%100), 0, g1.nodeID, \ibs, audioInBusses[player].index, \obs, player, \trig, 1, \fund, rrand(35.0, 150.0), \firstPartial, rrand(2.0, 5.0), \bank2MidiOffset, rrand(2.0, 8.0), \masteramp, 1.5, \spread, 1.33, \ringL1, 7.0, \ringL2, 15 ); petalsinc = petalsinc+1}
		)}, "/Petals");

		//// LIVE SAMPLING - OSCdefs //////////////////////////////////////////////////////////////////////////////////////
		OSCdef(\rec, { |msg|
			var sampnum = msg[1].asInteger; //which bank
			var state = msg[2].asInteger; //1 or 0 record on or off
			var ch = msg[3].asInteger; //which channel to record from
			var recnode = irecnode+sampnum; //node for record synth
			var idxnode = iIdxnode+sampnum; //node of idx synth
			var playnode = iplaynode+sampnum; //node for bufplay synth
			fork{
				if(sampnum<numsamps,{ //is the sampnum less than the allocated num samples
					if(state==1, { //if state1, record
						//Stop any playback
						if(playmodes[sampnum]==0, {s.sendMsg(\n_set, playnode, \gate, 0)});
						//Make a new index synth, kill old index synth
						s.sendMsg(\n_free, idxnode);
						s.sendMsg(\s_new, \bufidx, idxnode, 0, idxgr.nodeID, \buf, idxbufs[sampnum].bufnum, \bus, idxAbusses[sampnum].index, \kbus, idxKbusses[sampnum].index, \start, 0.0);
						//Make a new record synth - synthdefname, node number, , addaction (0=head of group)group, args
						s.sendMsg(\s_new, \bufrec, recnode, 0, recgr.nodeID, \ich, ch, \idxbus, idxAbusses[sampnum].index, \buf, sampbufs[sampnum].bufnum);
						recstartidxval[sampnum] = idxKbusses[sampnum].getSynchronous.asFloat;
						}, { // end if state = 1, begin else (state=0), stop recording
							s.sendMsg(\n_set, recnode, \gate, 0); //set gate of recording synth to 0, doneAction:2 will auto kill synth
							s.sendMsg(\n_set, idxnode, \end, idxKbusses[sampnum].getSynchronous.asFloat); //set index end time to the time you end the recording
							recendidxval[sampnum] = idxKbusses[sampnum].getSynchronous.asFloat+ (0.08/maxsamplength); //store end time
							s.sendMsg(\n_set, playnode, \start, recstartidxval[sampnum], \end, recendidxval[sampnum], \t_tr, 1);
							waveformFunc.value(sampnum);
							0.1.wait;
							proc.sendMsg("/renderwf", sampnum);
					}); // end else if state != 1 (state=0 or off)
				})//end if sampnum<numsamps
			}//end fork
		}, "/rec"); //end oscdef

		OSCdef(\getwavfrm,{ |msg|
			waveformFunc.value(msg[1].asInteger);
		}, "/getwavfrm");

		OSCdef(\playmode, {|msg|
			var sampnum = msg[1].asInteger; //which bank
			var mode = msg[2].asInteger; //which playmode
			var playnode = iplaynode+sampnum; //node for bufplay synth
			playmodes[sampnum] = mode;
			fork{
				switch(mode,
					0, { s.sendMsg(\n_set, playnode, \gate, 0) }, //kill exsisting play synth
					1, {
						s.sendMsg(\n_set, playnode, \gate, 0); //kill exsisting play synth
						0.1.wait;
						s.sendMsg(\n_free, playnode); //make sure its gone
						//create new synth with gate 0 to be started with play
						s.sendMsg(
							\s_new, \grainy, playnode, 0, playgr.nodeID,
							\buf, sampbufs[sampnum].bufnum, \mrate, -0.03, \scrub, 0.0, \amp, 0.8,
							\gate2, 0, \start, recstartidxval[sampnum], \end, recendidxval[sampnum],
							\grate, 0.08, \gdur, 0.1, \gspd,1, \envbuf, envbufs[6].bufnum,
							\grate2, 0.07, \gdur2, 0.4, \gspd2, 1, \envbuf2, envbufs[6].bufnum,
							\grate3, 0.06, \gdur3, 0.7, \gspd3, 1, \envbuf3, envbufs[6].bufnum,
							\grate4, 0.05, \gdur4, 0.5, \gspd4, 1, \envbuf4, envbufs[6].bufnum
						)
					},
					2, {
						s.sendMsg(\n_set, playnode, \gate, 0); //kill exsisting play synth
						3.wait;
						s.sendMsg(\n_free, playnode); //make sure its gone
						//create new synth with gate 0 to be started with play
						s.sendMsg(
							\s_new, \grainy, playnode, 0, playgr.nodeID,
							\buf, sampbufs[sampnum].bufnum, \mrate, 15.03, \scrub, 0.0, \amp, 0.8,
							\gate2, 0, \start, recstartidxval[sampnum], \end, recendidxval[sampnum],
							\grate, 0.1, \gdur, 0.83, \gspd,1, \envbuf, envbufs[6].bufnum,
							\grate2, 0.41, \gdur2, 0.74, \gspd2, 1, \envbuf2, envbufs[6].bufnum,
							\grate3, 0.13, \gdur3, 0.87, \gspd3, 1, \envbuf3, envbufs[6].bufnum,
							\grate4, 0.08, \gdur4, 0.42, \gspd4, 1, \envbuf4, envbufs[6].bufnum
						)
					},
					3, {
						s.sendMsg(\n_set, playnode, \gate, 0); //kill exsisting play synth
						3.wait;
						s.sendMsg(\n_free, playnode); //make sure its gone
						//create new synth with gate 0 to be started with play
						s.sendMsg(
							\s_new, \grainy, playnode, 0, playgr.nodeID,
							\buf, sampbufs[sampnum].bufnum, \mrate, -0.02, \scrub, 0.0, \amp, 1,
							\gate2, 0, \start, recstartidxval[sampnum], \end, recendidxval[sampnum],
							\grate, 0.13, \gdur, 0.34, \gspd,1, \envbuf, envbufs[3].bufnum,
							\grate2, 0.673, \gdur2, 0.35, \gspd2, 1, \envbuf2, envbufs[8].bufnum,
							\grate3, 0.71, \gdur3, 0.52, \gspd3, 1, \envbuf3, envbufs[3].bufnum,
							\grate4, 0.1435, \gdur4, 0.27, \gspd4, 1, \envbuf4, envbufs[8].bufnum
						)
					} //end 3,
				)//end switch(mode)
			}//end fork
		}, "/playmode");

		OSCdef(\play, { |msg|
			var sampnum = msg[1].asInteger; //which bank
			var state = msg[2].asInteger; //1 or 0 play on or off
			var ch = msg[3].asInteger; //which channel to play out
			var playnode = iplaynode+sampnum; //node for bufplay synth
			if(sampnum<numsamps,{ //is the sampnum less than the allocated num samples
				if(state==1, { //if state1, play
					//Make a new play synth - synthdefname, node number, addaction (0=head of group), group, args
					if( playmodes[sampnum] == 0,{
						s.sendMsg(\s_new, \bufpl, playnode, 0, playgr.nodeID, \obs, ch, \idxbus, idxAbusses[sampnum].index, \buf, sampbufs[sampnum].bufnum)
						},
						{s.sendMsg(\n_set, playnode, \gate2, 1)}
					) //end if( playmodes[sampnum] == 0
					}, // end if state = 1
					{ // begin else (state=0), stop playing
						if( playmodes[sampnum] == 0,
							{s.sendMsg(\n_set, playnode, \gate, 0)}, //set gate of bufplay synth to 0, doneAction:2 will auto kill synth
							{s.sendMsg(\n_set, playnode, \gate2, 0)}
						) //end if( playmodes[sampnum] == 0
				}); // end else if state != 1 (state=0 or off)
			})//end if sampnum<numsamps
		}, "/play");

		OSCdef( \getidx,{|msg|
			var sampnum = msg[1].asInteger;
			var idxval = idxKbusses[sampnum].getSynchronous.asFloat;
			var end = recendidxval[sampnum];
			idxval = idxval.linlin(0.0, end, 0.0, 1.0);
			proc.sendMsg("/ix", sampnum, idxval)
		}, "/getidx");

		// FUNCTIONS ////////////////////////////////////////////////////////
		//Function to collect & send waveform display data
		waveformFunc = { |sampnum|
			var buf = sampbufs[sampnum];
			var count = recendidxval[sampnum]*(maxsamplength*44100.0);
			buf.loadToFloatArray(0, count, action:{
				arg array;
				var bufarray, sampsize, resamp, resampArray, ct;
				fork{
					bufarray = array;
					//RESAMPLE TO MANAGEABLE SIZE
					sampsize = 200; //Make sure to change this if you change pixel width of sampler
					resamp = (bufarray.size/sampsize).round;
					resampArray = Array.newClear(sampsize+2); //This is the new resampled array
					ct = 0; //A counter for the resampled array
					//RESAMPLE THE BUFFER ARRAY AND PUT THE VALUES INTO A NEW ARRAY AS FLOATS
					bufarray.do{ |it, ix| if( ix%resamp == 0, {resampArray[ct]=it.asFloat; ct = ct+1} ) };
					//ADD TRACK NUMBER AND OSC ADDRESS
					resampArray = resampArray.insert(0, sampnum.asInteger);
					resampArray = resampArray.insert(0, "/sbuf");
					resampArray.postln;
					//SEND TO PROCESSING
					proc.sendBundle(0.0, resampArray);
				}
			} );
		};

		0.5.wait;

		////START SYNTHS
		//start live mic
		s.sendMsg(\s_new, \micin, 11111, 0, g0.nodeID, \obs, audioInBusses[0].index, \ibs, 0);
		s.sendMsg(\s_new, \micin, 22222, 0, g0.nodeID, \obs, audioInBusses[1].index, /*\ibs, 1*/);
		//Start Sampler
		//s.sendMsg(\s_new, \sampS, 7000, 0, g0.nodeID, \obs, 2, \buf, samples[0].bufnum, \gate, 0);

	} //end fork
} //end s.waitForBoot
)
n=NetAddr("127.0.0.1", 57120);
n.sendMsg("/IR", 0, 1);
n.sendMsg("/IR", 0, 0);
s.meter;
n.sendMsg("/rec", 0, 1, 0);
n.sendMsg("/rec", 0, 0, 0);
n.sendMsg("/play", 0, 1, 0);
n.sendMsg("/play", 0, 0, 0);

n.sendMsg("/playmode", 0, 0);
n.sendMsg("/playmode", 0, 1);
n.sendMsg("/playmode", 0, 2);
n.sendMsg("/playmode", 0, 3);

fork{
	n.sendMsg("/rec", 0, 1, 0); "fds".postln; 0.3.wait; "ffffffff:.postln"; n.sendMsg("/rec", 0, 0, 0);
};

(fork{
	n.sendMsg("/rec", 0, 1, 0);
	"fds".postln;
	0.25.wait;
	"fffff".postln;
	n.sendMsg("/rec", 0, 0, 0);
})



