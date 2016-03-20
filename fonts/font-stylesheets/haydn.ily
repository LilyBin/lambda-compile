%%%% The stylesheet for HAYDN music notation font
%%%%
%%%% In order for this to work, this file's directory needs to 
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "haydn.ily"
%%%%
%%%% Copyright (C) 2014 Abraham Lee (tisimst.lilypond@gmail.com)

\version "2.18.2"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "haydn"
    #:brace "haydn"
    ;#:roman "OldStandardTT"
    #:factor (/ staff-height pt 20)
  ))
}

\layout {
  \context {
    \Staff
    \override Beam #'beam-thickness = #0.7
    \override Beam #'length-fraction = #1.2
    \override Tie #'thickness = #3
    \override Slur #'thickness = #3
    \override PhrasingSlur #'thickness = #3
  }
}  
