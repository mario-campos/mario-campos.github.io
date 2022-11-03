# Changelog

All notable changes to this project (the [Brutalist-Minimalist Hugo
Theme][bm]) will be documented in this file.

The format is based on [Keep a Changelog][keepachangelog], and this
project adheres to [Semantic Versioning][semver].

## [UNRELEASED]

### Added

- Simple banner short code and styling. This creates a box in 400% font, a
  lighter text color and --toc-shade as background. Current purpose:
  Banners for "Website under construction".  
- Copyright header in some static css.
- Now source line contains page date. Obviously only makes sense if the date
  field is properly maintained.
- Database for (primarily) freebooks. Create pages under content/book,
  every page is a record with the required metadata.
- Better rendering for tags (but still not perfect) 
- Added link to tags/ to landing page of example site
- Books are now rendered in bibliography style in book/ (for the moment
  only there)
- Tags now also give the item type (book, blogpost, documentation).  

### Fixed

- For page backed tags, the source line did not work. Repaired.
- Removed commas in tags in sample org file. These became part of the tags.
- Improved text of link to books database on landing page.
- draft=false for (canned) disclaimer pages.

### Changed

- When presenting books, white space between book "card" and disclaimers.

## [0.2.0] - 2022-03-20

### Added

- Some missing copyright headers.
- KaTeX and Highlighting are now included earlier.
- Source URL below the footer
- Styling code for printing as black and white.
- scripts/deploy to upload pages to a server dependent on configuration in
  config.toml. For details see 'scripts/deploy --help'.
- German "Datenschutzerkärung" and imprint to demo site (German law
  requires this if I serve the demo site somehwere in the web).
- New partial "obligatory-links" for obligatory links that have to turn up
  in header and footer.
- In exampleSite: Documentation pages will be sorted by page attribute
  "order" now (instead of meaningless date), list will be titled
  "Documentation" instead of "Documentations".
- In exampleSite: The about/site page.
- Completed theme.toml.

### Fixed

- BM-2: Printing style partially ignored by Safari on IPadOS.
- BM-3: Frame around the header has now vanished in printing style.
- BM-5: Warning: .File.Path on zero object.
- draft:true -> draft:false for exampleSite pages
- Fixed typos in README

### Known Bugs

- BM-4: Code styling and overriding is too hacky.

## [0.1.0] - 2022-03-12

This is the first draft release from the original PoC.

### Added

- Templates to support site pages and blog.
- "Recent Posts" section on the home page.
- Styling (darksblue bars for header and footer).
- Math support.
- Table of content support.

### Known Bugs

- BM-1: TOC vanishes as mobile response for small window sizes.
- BM-2: Printing style partially ignored by Safari on IPadOS
- BM-3: Frame around the header has now vanished in printing style

Generally the printing style support is now broken and needs to be
reconstructed.

# -- References ------------------------------------------------- ---

  [bm]:              https://brutalist-minimalist.glitzersachen.de
  [keepachangelog]:  https://keepachangelog.com/en/1.0.0/
  [semver]:          https://semver.org/spec/v2.0.0.html
  
<!-- ------------------------------------------------------------- -->
<!-- Local Variables: -->
<!-- fill-column: 75 -->
<!-- eval: (column-enforce-mode 1) -->
<!-- End: -->
