%%%% The stylesheet for SCORLATTI music notation font
%%%%
%%%% In order for this to work, this file's directory needs to 
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "scorlatti.ily"
%%%%
%%%% Copyright (C) 2014 Abraham Lee (tisimst.lilypond@gmail.com)

\version "2.18.2"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "scorlatti"
    #:factor (/ staff-height pt 20)
  ))
}

\layout {
  \override Tie.thickness = #2.5
  \override Slur.thickness = #2.5
  \override PhrasingSlur.thickness = #2.5
}
