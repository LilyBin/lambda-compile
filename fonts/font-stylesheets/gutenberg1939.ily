%%%% The stylesheet for GUTENBERG1939 music notation font
%%%%
%%%% In order for this to work, this file's directory needs to 
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "gutenberg1939.ily"
%%%%
%%%% Copyright (C) 2014 Abraham Lee (tisimst.lilypond@gmail.com)

\version "2.18.2"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "gutenberg1939"
    #:brace "gutenberg1939"
    #:factor (/ staff-height pt 20)
  ))
}

\layout {
  \override TupletNumber.font-series = #'bold
  \context {
    \Score
    \override BarLine.hair-thickness = #3
    \override SystemStartBar.collapse-height = #4
    \override SystemStartBar.thickness = #3
  }
  \context {
    \StaffGroup
    \override SystemStartBar.collapse-height = #4
  }
}


