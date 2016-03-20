%%%% The stylesheet for ROSS music notation font
%%%%
%%%% In order for this to work, this file's directory needs to 
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "ross.ily"
%%%%
%%%% Copyright (C) 2014 Abraham Lee (tisimst.lilypond@gmail.com)

\version "2.18.2"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "ross"
    #:brace "ross"
    #:factor (/ staff-height pt 20)
  ))
}

\layout {
  \override Hairpin.thickness = #1.5
  \override Slur.thickness = #1.2
  \override Tie.thickness = #1.2
  \override PhrasingSlur.thickness = #1.2
  \override Score.StaffSymbol.thickness = #1.5
  \override PianoPedalBracket.thickness = #1.5
}
