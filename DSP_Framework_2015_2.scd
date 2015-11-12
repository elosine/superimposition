/*
2 ins - live in
make a separate processor for sample player/recorder
1 effects bus
pass thru synthdef
*/

(
s.waitForBoot{
	fork{
		~g0 = Group.new(s);
		~g1 = Group.after(~g0);
		~ab = {Bus.audio(s)}!2;
		~proc = NetAddr("127.0.0.1", 12321);
		//buffer for freeze
		~fb = Buffer.alloc(s, s.sampleRate*2);
		~eb = SoundFile.collectIntoBuffers("/Volumes/Ute/Freeze/grainEnv/" ++ "*");
		//Sample Player
		~sts = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/DSP_Framework/stereosamples/*");
		~ms = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/DSP_Framework/monosamples/*");
		~sn = Array.newClear(0); //array of all the soundfile names
		0.5.wait;
		//create an array of strings that hold all of the soundfile names incl the converted stereo-to-mono ones
		~sts.do{ |it ix| var nm = it.path.split($/); ~sn = ~sn.add(nm[nm.size-1].asString) };
		~ms.do{ |it ix| var nm = it.path.split($/); ~sn = ~sn.add(nm[nm.size-1].asString) };
		//Convert mono soundfiles to stereo
		~m2sz = Array.newClear(0);
		~ms.do{ |it ix| ~m2sz = ~m2sz.add( Buffer.readChannel(s, it.path, channels:[0,0]) ) };
		/*
		//Convert stereo soundfiles to mono and combine all in ~samps
		~s2mbz = Array.newClear(~sts.size);
		~sts.do{ |it ix|
		it.loadToFloatArray(action: {
		arg array;
		var ar = array;
		~s2mbz[ix] = Buffer.loadCollection(s, ar.unlace(2).sum*0.5);
		})};
		2.wait;
		~samps = ~ms.addAll(~s2mbz);
		*/
		1.wait;
		~samps = ~sts.addAll(~m2sz);
		//Create an array to hold sample durations
		~sdur = Array.newClear(0);
		~samps.do{|it ix| ~sdur = ~sdur.add((it.numFrames/it.sampleRate).asFloat)};

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

		//OSCdefs
		//Send soundfile names on demand
		OSCdef(\sfnames, {
			var bnd, durs;
			bnd = Array.newFrom(~sn);
			bnd.insert(0,~sn.size);
			bnd.insert(0, "/sfs");
			~proc.sendBundle(0.0, bnd);
			durs = Array.newFrom(~sdur);
			durs.insert(0,~sdur.size.asInteger);
			durs.insert(0, "/sdurs");
			~proc.sendBundle(0.0, durs);

		}, "/sfnames");
		OSCdef(\playsamp, {|msg| msg.postln;s.sendMsg(\n_set, 7000, \t_tr, 1, \buf, ~samps[msg[1].asInteger].bufnum, \gate, 1)}, "/playsamp");
		//live mic effects
		////amplify
		OSCdef(\liveampon, { |msg| s.sendMsg(\s_new, \amplify, 5010, 0, ~g1.nodeID, \ibs, ~ab[0].index) }, "/liveampon");
		OSCdef(\liveampoff, { |msg| s.sendMsg(\n_set, 5010, \gate, 0) }, "/liveampoff");
		////ringmod1
		OSCdef(\liverm1on, { |msg| s.sendMsg(\s_new, \rm, 5020, 0, ~g1.nodeID, \ibs, ~ab[0].index, \bend, 5, \lf1f, 0.2, \inamp, 2, \rel, 0.2) }, "/liverm1on");
		OSCdef(\liverm1off, { |msg| s.sendMsg(\n_set, 5020, \gate, 0) }, "/liverm1off");
		////ringmod2
		OSCdef(\liverm2on, { |msg| s.sendMsg(\s_new, \rm, 5021, 0, ~g1.nodeID, \ibs, ~ab[0].index, \bend, 0.5, \lf1f, 0.02, \inamp, 2, \rel, 0.2) }, "/liverm2on");
		OSCdef(\liverm2off, { |msg| s.sendMsg(\n_set, 5021, \gate, 0) }, "/liverm2off");
		////freeze
		OSCdef(\livefreezeon, { |msg| s.sendMsg(\s_new, \icy_live, 5030, 0, ~g1.nodeID, \ibs, ~ab[0].index, \buf, ~fb.bufnum, \winsz, 0.6, \overlaps, 17, \rand, 0.5, \envbuf, ~eb[3].bufnum, \dur, 13, \indur, 2, \rate, 0.97, \rel, 3, \crv, -3 ) }, "/livefreezeon"); //kills itself
		0.5.wait;
		////START SYNTHS
		//start live mic
		s.sendMsg(\s_new, \micin, 11111, 0, ~g0.nodeID, \obs, ~ab[0].index);
		//Start Sampler
		s.sendMsg(\s_new, \sampS, 7000, 0, ~g0.nodeID, \obs, 0, \buf, ~samps[0].bufnum, \gate, 0);

	}
}
)


PETALS OF RESONANCE
GREYHOLE ET AL

MAKE OSCDEF FOR THIS ONE AND FIND SOME GOOD PRESETS
ALLOCATE BUFFER ON THE FLY IN OSCDEF
GET SOME KOTO AND SHANI SAMPLES AND PROCESS FOR TRIGGERED SAMPLES
RANDOM SAMPLE TRIGGERING BUTTON

//allocate buffer on the fly in the oscdef
SynthDef(\selfsamp, {
	arg buf, rdur=3, rretrigt=10, pretrigt = 3;
	var rix, rixenv, rgate, pix, pixenv, pgate, play,rretrigf, pretrigf, pdur, pst, pnd, penv;
	rretrigf = 1.0/rretrigt;
	pretrigf = 1.0/pretrigt;
	rgate = Dust.kr(rretrigf);
	pgate = DelayL.kr(Dust.kr(pretrigf),10, rdur);
	pdur = TRand.kr(0.05/rdur, 1, pgate);
	pst = TRand.kr(0.0, 1-pdur, pgate);
	rixenv = EnvGen.ar(Env.linen(0, rdur, 0),rgate);
	rix = Phasor.ar(rgate, BufRateScale.kr(buf), 0, BufFrames.kr(buf));
	BufWr.ar(SoundIn.ar(0), buf, rix*rixenv);
	pixenv = EnvGen.ar(Env.linen(0, pdur*rdur, 0),pgate);
	penv = EnvGen.ar(Env.linen(0.05, pdur*rdur, 0.05),pgate);
	pix = Phasor.ar(pgate, BufRateScale.kr(buf), pst*BufFrames.kr(buf), BufFrames.kr(buf)*(pst+pdur));
	play = BufRd.ar(1, buf, pix*penv);
	//play = RLPF.ar(play, 1000);
	Out.ar(0, play*pixenv);
}).add;



