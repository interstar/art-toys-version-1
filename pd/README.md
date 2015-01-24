# Pure Data synth.

A simple 6 voice synthesizer built with PureData which is used to play the notes produced by the "music toys" in this sketch.

Communication between Processing and PureData is over [Open Sound Control](http://en.wikipedia.org/wiki/Open_Sound_Control) so you will need [PureData Extended](http://puredata.info/downloads/pd-extended) which includes the Mrpeach library for OSC.

Run PD separataly from Processing.

In this directory simply type :

    pd art_toys.pd 
    
Note that once the synth is running, you will need to make the synths playable. (They currently default to being silent.)

You will need to

a) turn up the master volume control (slider at the top of the screen marked vol_1).
b) turn up the volume of the particular voice you are playing ( last slider in each voice's box, labeled "vol_XXXX" where XXXX is the uid of the voice)
c) turn up the attack and/or delay of the envelope of the voice. If they're both zero, the sound will have a zero duration!
d) shift the filter_res slider somewhere to the right. This controls the filter resonance, but its default far-left position will leave the voice silent.
e) turn on the Pure Data DSP (under the "Media" menu at the top of the window).

The synth should now be ready to make sounds when it receives messages from the Processing sketch 
