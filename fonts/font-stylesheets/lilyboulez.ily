%%%% The stylesheet for LILYBOULEZ music notation font
%%%%
%%%% In order for this to work, this file's directory needs to 
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "lilyboulez.ily"
%%%%
%%%% Copyright (C) 2015 Abraham Lee (tisimst.lilypond@gmail.com)

\version "2.18.2"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "lilyboulez"
    #:factor (/ staff-height pt 20)
  ))
}
