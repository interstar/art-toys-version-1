# Pure Data synth.

A simple 6 voice monophonic synthesizer built with PureData, which is used to play the notes produced by the "music toys" in this Art Toys Example sketches.

Communication between Processing and PureData is over [Open Sound Control](http://en.wikipedia.org/wiki/Open_Sound_Control) so you will need [PureData Extended](http://puredata.info/downloads/pd-extended) which includes the Mrpeach library for OSC.


## Getting Started
Run PD separataly from Processing.

In the pd sub-directory of the sketch simply type :

    pd art_toys.pd 
    
Note that once the synth is running, you will need to make the synths playable. (They currently default to being silent.)

You will need to

a) turn up the master volume control (slider at the top of the screen marked vol_1).
b) turn up the volume of the particular voice you are playing ( last slider in each voice's box, labeled "vol_XXXX" where XXXX is the uid of the voice)
c) turn up the attack and/or delay of the envelope of the voice. If they're both zero, the sound will have a zero duration!
d) shift the filter_res slider somewhere to the right. This controls the filter resonance, but its default far-left position will leave the voice silent.
e) turn on the Pure Data DSP (under the "Media" menu at the top of the window).

The synth should now be ready to make sounds when it receives messages from the Processing sketch 

## Synth Details

This synthesizer was made using [Gates of Dawn](https://github.com/interstar/gates-of-dawn), Python library for generating PureData sketches. PD is a great, free-software, synth-building kit, but I don't actually like the GUI interface much. So I made a library that lets me generate PD files programmatically from Python.

The source-code to generate the synth in Python is in gatesofdawn/arttoys.py under this pd directory and should give you an idea what's involved in using Gates of Dawn to create a synthesizer like this. The library is still pretty embrionic, but I find it a convenient way to get a crude working synth up and running fairly quickly.

You *can* of course edit the synth in PD in the normal way.

Or use any other synth that can receive OSC messages. Currently OSC communication is hardwired to send messages to localhost:9004 with the path "channel0", "channel1" etc. for each separate voice controlled by Processing. However, this can be changed in the Processing code. 
