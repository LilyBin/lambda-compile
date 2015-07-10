%%%% The stylesheet for PROFONDO music notation font (Bravura)
%%%%
%%%% In order for this to work, this file's directory needs to 
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "profondo.ily"
%%%%
%%%% Copyright (C) 2014 Abraham Lee (tisimst.lilypond@gmail.com)

\version "2.18.2"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "profondo"
    #:brace "profondo"
    #:factor (/ staff-height pt 20)
  ))
}

% Since Profondo is a very bold font, let's up the thickness of some lines
% (taken from the openlilylib snippets repository)
\layout {
  \override Staff.StaffSymbol.thickness = #1.2
  \override Staff.Stem.thickness = #1.6
  \override Staff.Beam.beam-thickness = #0.55
  \override Staff.Tie.thickness = #1.5
  \override Staff.Slur.thickness = #1.5
  \override Staff.PhrasingSlur.thickness = #1.5
  \override Staff.TupletNumber.font-name = #"ProfondoTupletNumbers"
}
