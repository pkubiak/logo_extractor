module LogoExtractor
  # weights for each criterion
  WEIGHTS = {
    is_svg: 1,
    is_png: 2,
    is_jpg: 3,
    is_gif: 4, 
    is_bmp: 5,
    keyword_in_class: 6,
    keyword_in_alt: 7,
    keyword_in_title: 8,
    keyword_in_src: 9,
    keyword_in_id: 10,
    keyword_in_anncestor: 11, 
    parents_anchor: 12  
  }
end