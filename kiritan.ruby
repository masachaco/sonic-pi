# SonicPiの内臓音源を鳴らす
def playSonicPiInstruments(rootPattern, rithmPattern, numOfLoop, operation, length = 1, amp = 1)
  #指定した音を
  rootPattern.each do |pitch|
    #指定したリズムで弾く
    (1..numOfLoop).each do
      rithmPattern.each do |r|
        operation.call pitch, finish: length, amp: amp
        sleep r
      end
      
    end
  end
end

# MIDIを鳴らす 
def playMidiInstruments(rootPattern, rithmPattern, numOfLoop, operation, channel, port)
  rootPattern.each do |b|
    (1..numOfLoop).each do
      rithmPattern.each do |r|
        operation.call b, 110, port: port, channel: channel
        sleep r
        midi_note_off b
      end
    end
  end
end

use_bpm 170
def kick ()
  live_loop :bass_kick do
    playSonicPiInstruments([:drum_heavy_kick],[1],1, self.method(:sample),1)
    playSonicPiInstruments([:drum_heavy_kick],[1],1, self.method(:sample),1)
    playSonicPiInstruments([:drum_heavy_kick],[1],1, self.method(:sample),1)
    playSonicPiInstruments([:drum_heavy_kick],[1],1, self.method(:sample),1)
  end
end

def hihat()
  sync :bass_kick
  live_loop :hihat16 do
    playSonicPiInstruments([:drum_cymbal_closed], [1],1, self.method(:sample),1)
    playSonicPiInstruments([:drum_cymbal_open], [1],1, self.method(:sample),1, 0.2)
    playSonicPiInstruments([:drum_cymbal_closed], [0.25],4, self.method(:sample),1,0.7)
    playSonicPiInstruments([:drum_cymbal_open], [1],1, self.method(:sample),1, 0.2)
  end
end

def bass ()
  live_loop :bass do
    sync :bass_kick
    playSonicPiInstruments([:a1],[0.5],2, self.method(:play))
    playSonicPiInstruments([:r] ,[3]  ,1, self.method(:play))
  end
end

def chordSynth ()
  live_loop :synth do
    sync :bass_kick
    ([:A3,:G3]).each do |root|
      (1..4).each do |index|
        playSonicPiInstruments([chord(root, index % 2 ? :minor : :major)],[0.5],2, self.method(:play))
        playSonicPiInstruments([:r] ,[3]  ,1, self.method(:play))
      end
    end
  end
end


def lead ()
  live_loop :lead do
    sync :bass_kick
    play_pattern_timed scale(:a4, :minor).shuffle, 0.5, amp: 0.2
  end
end

def massive ()
  live_loop :massive do
    sync :synth
    ([:A5,:G5]).each do |root|
      (1..4).each do |index|
        playMidiInstruments([root],[1], 1, self.method(:midi_note_on), 1, "loopmidi")
        playMidiInstruments([:r],[1], 3, self.method(:midi_note_on), 1, "loopmidi")
      end
    end
  end
end

def avenger ()
  live_loop :avenger do
    sync :bass_kick
    ([:A5,:G5]).each do |root|
      (1..4).each do |index|
        playMidiInstruments([root],[1], 1, self.method(:midi_note_on), 1, "loopmidigt")
        playMidiInstruments([:r],[1], 3, self.method(:midi_note_on), 1, "loopmidigt")
      end
    end
  end
end

def kiritan ()
  live_loop :kiritan do
    sync :bass_kick
    Dir.chdir('C:\DtmTools\SonicPiPortable\samples')
    kiritanPhrase = Dir.glob("*.wav");
    playSonicPiInstruments(['C:\DtmTools\SonicPiPortable\samples\\'+choose(kiritanPhrase)+''], [4],4, self.method(:sample), 1,1.5)
    playSonicPiInstruments([:r], [4],1, self.method(:sample),1)
    playSonicPiInstruments(['C:\DtmTools\SonicPiPortable\samples\\'+choose(kiritanPhrase)+''], [4],1, self.method(:sample), 1,1.5)
    playSonicPiInstruments([:r], [4],3, self.method(:sample),1)
  end
end


kick()
hihat()
bass()
chordSynth()
lead()
massive()
avenger()
kiritan()

