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
		var scoreixbuf = Buffer.alloc(s, s.sampleRate*16);
		var scoreixAbus = Bus.audio(s);
		var scoreixKbus = Bus.control(s);
		//Loop Index/Cursor
		var loopixbuf = Buffer.alloc(s, s.sampleRate*16);
		var loopixAbus = Bus.audio(s);
		var loopixKbus = Bus.control(s);
		//Sample Buffer
		var liveprocbuf = Buffer.alloc(s, s.sampleRate*44100);



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
			index = In.ar(idxbus);
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
		OSCdef(\getix, {|msg|
			var pl = msg[1].asInteger;
			scoreixKbus.get({ |val|
 				liveprocbuf.get( (val*(44100*16)).round, { |msg| procfx.sendMsg("/ix", pl, val.asFloat, msg.asFloat) });
			});
		}, "/getix");
		OSCdef(\getloopix, {|msg|
			var pl = msg[1].asInteger;
			loopixKbus.get({ |val| procfx.sendMsg("/loopix", pl, val.asFloat) });
		}, "/getloopix");
		OSCdef(\setix, {|msg|
			var pl = msg[1].asInteger;
			var start = msg[2].asFloat;
			var end = msg[3].asFloat;
			s.sendMsg(\n_free, 6000+pl);
			s.sendMsg( \s_new, \indexer, 6000+pl, 0, g0.nodeID, \buf, loopixbuf.bufnum, \spd, 1, \start, start,
				\end, end, \abus, loopixAbus.index, \kbus, loopixKbus.index);
			s.sendMsg( \n_set, 5000+pl, \idxbus, loopixAbus.index );
		}, "/setix");
		OSCdef(\mainix, {|msg|
			var pl = msg[1].asInteger;
			s.sendMsg(\n_free, 6000+pl);
			s.sendMsg( \n_set, 5000+pl, \idxbus, scoreixAbus.index );
		}, "/mainix");

		5.wait;
		s.sendMsg( \s_new, \indexer, 3000, 0, g0.nodeID, \buf, scoreixbuf.bufnum, \spd, 1, \pos, 0.75, \t_tr, 1, \abus, scoreixAbus.index, \kbus, scoreixKbus.index);
		s.sendMsg( \s_new, \bufrec, 4000, 0, g0b.nodeID, \ich, 0, \idxbus, scoreixAbus.index, \buf, liveprocbuf.bufnum );
		s.sendMsg( \s_new, \sampplay, 5000, 0, g1.nodeID, \obs, 0, \idxbus, scoreixAbus.index, \buf, liveprocbuf.bufnum );



	}
}
)


Send to processing and create alternative cursor
//off button right click

