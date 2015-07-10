\version "2.18.2"

#(define-public (add-notation-font fontnode name music-str brace-str factor)
  (begin 
    (add-music-fonts fontnode 
      name music-str brace-str 
      feta-design-size-mapping factor)
    fontnode))

\paper {
  #(define notation-fonts
    (list 
      (list 'beethoven "beethoven" "beethoven")
      (list 'cadence "cadence" "emmentaler")
      (list 'emmentaler "emmentaler" "emmentaler")
      (list 'gonville "gonville" "gonville")
      (list 'gutenberg "gutenberg1939" "gutenberg1939")
      (list 'haydn "haydn" "haydn")
      (list 'improviso "improviso" "improviso")
      (list 'lilyboulez "lilyboulez" "emmentaler")
      (list 'lilyjazz "lilyjazz" "lilyjazz")
      (list 'lv-goldenage "lv-goldenage" "emmentaler")
      (list 'paganini "paganini" "emmentaler")
      (list 'profondo "profondo" "profondo")
      (list 'ross "ross" "ross")
      (list 'scorlatti "scorlatti" "scorlatti")
      (list 'sebastiano "sebastiano" "sebastiano")
    ))
    
  #(begin 
    (for-each
      (lambda (tup)
        (add-notation-font fonts 
          (car tup) ; font identifier
          (cadr tup) ; notation font
          (caddr tup) ; brace font
          (/ staff-height pt 20)))
      notation-fonts))
}
