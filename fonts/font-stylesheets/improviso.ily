%%%% The stylesheet for IMPROVISO music notation font
%%%%
%%%% In order for this to work, this file's directory needs to 
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "improviso.ily"
%%%%
%%%% Copyright (C) 2014 Abraham Lee (tisimst.lilypond@gmail.com)

\version "2.18.2"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "improviso"
    #:brace "improviso"
    #:roman "Thickmarker"
    #:factor (/ staff-height pt 20)
  ))
}

\layout {
  \override StaffGroup.SystemStartBracket.thickness = #0.25
  \override Staff.Beam.beam-thickness = #0.5
  \override Staff.Beam.length-fraction = #1.0
  \override Score.Stem.thickness = #1.75
  \override Hairpin.thickness = #2
  \override PianoPedalBracket.thickness = #2
  \override Tie.line-thickness = #2
  \override Tie.thickness = #0
  \override Slur.line-thickness = #2
  \override Slur.thickness = #0
  \override PhrasingSlur.line-thickness = #2
  \override PhrasingSlur.thickness = #0
  \override MultiMeasureRestNumber.font-size = #2
  \override LyricHyphen.thickness = #3
  \override LyricExtender.thickness = #3
  \override Score.VoltaBracket.thickness = #2
  \override TupletBracket.thickness = #2
  \override Stem.thickness = #2
}
