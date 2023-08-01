// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(title: "", subtitle: "", authors: (), logo: none, body) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(number-align: center)
  //set text(font: "Linux Libertine", lang: "en")
  set text(font: "HK Grotesk", lang: "en")



  set heading(numbering: "1.1")
  

  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  if logo != none {
    v(0.1fr)
    link("https://github.com/orbit-systems")[#align(right, image(logo, width: 50%))]
  }
  v(9fr)

  text(2em, weight: 700, title)
  text(1.7em, weight: 300, " " + subtitle)

  // Author information.
  pad(
    top: 4em,
    right: 20%,
    grid(
      columns: (2fr,) * calc.min(2, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(start)[
        #text(author.name, weight:"bold") \
         #link("mailto:"+author.email)[#author.email]
      ]),
    ),
  )

  v(0fr)


  // Main body.
  set par(justify: true)

  body
}

// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(title: "", subtitle: "", authors: (), logo: none, body) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(number-align: center)
  //set text(font: "Linux Libertine", lang: "en")
  set text(font: "Hanken Grotesk", lang: "en")



  set heading(numbering: "1.1")
  

  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  if logo != none {
    v(0.1fr)
    link("https://github.com/orbit-systems")[#align(right, image(logo, width: 50%))]
  }
  v(9fr)

  text(2em, weight: 700, title)
  text(1.7em, weight: 300, " " + subtitle)

  // Author information.
  pad(
    top: 4em,
    right: 20%,
    grid(
      columns: (2fr,) * calc.min(2, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(start)[
        #text(author.name, weight:"bold") \
         #link("mailto:"+author.email)[#author.email]
      ]),
    ),
  )

  v(0fr)


  // Main body.
  set par(justify: true)

  body
}

