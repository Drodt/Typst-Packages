#import "@local/abbrv:0.1.0": make-abbrvs
#import "@preview/ctheorems:1.1.2": thmrules
#import "@preview/drafting:0.2.0": set-page-properties, set-margin-note-defaults

#let format-date(date) = context {
  if text.lang == "de" {
    let month(m) = if m == 1 {
      "Januar"
    } else if m == 2 {
      "Februar"
    } else if m == 3 {
      "März"
    } else if m == 4 {
      "April"
    } else if m == 5 {
      "Mai"
    } else if m == 6 {
      "Juni"
    } else if m == 7 {
      "Juli"
    } else if m == 8 {
      "August"
    } else if m == 9 {
      "September"
    } else if m == 10 {
      "Oktober"
    } else if m == 11 {
      "November"
    } else {
      "Dezember"
    }
    [#date.day(). #month(date.month()) #date.year()]
  } else {
    date.display("[month repr:long] [day padding:none] [year]")
  }
}

#let project(
  title: [],
  abstract: none,
  preface: none,
  authors: (),
  date: none,
  logo: none,
  show-outline: false,
  draft: false,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  let left-margin = 2.5cm
  let right-margin = if draft { 5cm } else { 2.5cm }
  set page(
  	numbering: "1",
  	number-align: center,
  	margin: (left: left-margin, right: right-margin),
  	header: h(1fr) + title
  )
  set-page-properties(margin-left: left-margin, margin-right: right-margin)
  set-margin-note-defaults(hidden: not draft)
  set text(font: "Linux Libertine")
  set heading(numbering: "1.1")

  show: make-abbrvs
  show: thmrules

  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  v(0.6fr)
  if logo != none {
    align(right, image(logo, width: 26%))
  }
  v(9.6fr)

  text(1.1em, format-date(date))
  v(1.2em, weak: true)
  text(2em, weight: 700, title)

  // Author information.
  pad(
    top: 0.7em,
    right: 20%,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(start)[
        *#author.name* \
        #author.email \
        #author.affiliation
      ]),
    ),
  )

  v(2.4fr)
  pagebreak()

  if abstract != none {
    pagebreak()

    // Abstract page.
    v(1fr)
    align(center)[
      #heading(
        outlined: false,
        numbering: none,
        text(0.85em, smallcaps[Abstract]),
      )
      #abstract
    ]
    v(1.618fr)
    
  }

  if preface != none {
    pagebreak(weak: true)

    heading(outlined: false, numbering: none)[Preface]

    preface
    pagebreak(weak: true)
  }

  if show-outline {
    // Table of contents.
    outline(depth: 3, indent: true)
    pagebreak(weak: true)
  }

  // Main body.
  set par(justify: true, first-line-indent: 1em)
  show par: set block(spacing: 0.65em)

  body
}
