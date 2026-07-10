#import "@preview/linguify:0.4.2": linguify, set-database

#let __db = toml("lang.toml")

#let get-term(t, db: __db) = linguify(t, from: __db, default: "?" + t + "?")

#let get-elements(labels) = labels.map(l => {
  let e = query(l).first()
  let counter = if e.func() == figure {
    counter(figure.where(kind: e.kind))
  } else {
    counter(e.func())
  }
  (
    supplement: e.supplement,
    numbering: e.numbering,
    location: e.location(),
    numbers: counter.at(e.location()),
  )
})

#let get-page-elems(labels) = labels.map(l => {
  let e = query(l).first()
  let loc = e.location()

  (
    location: (page: loc.page(), x: 0pt, y: 0pt),
    numbering: loc.page-numbering(),
    numbers: counter(page).at(loc),
    supplement: [Page],
  )
})

#let group-by-supp(es) = {
  let (first, ..es) = es
  let gs = ((first,),)
  for e in es {
    let last-supp = gs.last().first().supplement
    if last-supp == e.supplement {
      gs.last().push(e)
    } else {
      gs.push((e,))
    }
  }
  gs
}

#let are-succ(n1, n2) = {
  if n1.len() != n2.len() {
    false
  } else {
    for (i, (a, b)) in n1.zip(n2).enumerate(start: 1) {
      if i < n1.len() and a != b {
        return false
      }
      if i == n1.len() {
        return a + 1 == b
      }
    }
  }
}

#let get-ranges(g) = {
  let (first, ..rest) = g
  let rs = ((first,),)
  for e in rest {
    if are-succ(rs.last().last().numbers, e.numbers) {
      rs.last().push(e)
    } else {
      if rs.last().len() == 2 {
        let (r1, r2) = rs.pop()
        rs.push((r1,))
        rs.push((r2,))
      }
      rs.push((e,))
    }
  }
  if rs.last().len() == 2 {
    let (r1, r2) = rs.pop()
    rs.push((r1,))
    rs.push((r2,))
  }
  rs
}

#let print-elem(e) = {
  link(e.location, numbering(e.numbering, ..e.numbers))
}

#let print-range(r, db: __db) = {
  if r.len() == 1 {
    print-elem(r.first())
  } else {
    let rang-conj = get-term("range-conj", db: db)
    print-elem(r.first()) + rang-conj + print-elem(r.last())
  }
}

#let print-group(g, suppress-supp: false, db: __db) = {
  if g.len() == 1 {
    return ref(g.first().label)
  }
  if not suppress-supp {
    let supp = g.first().supplement.text
    get-term(supp + "-pl", db: db) + [~]
  }
  let ranges = get-ranges(g)
  let pr = print-range.with(db: db)
  if ranges.len() == 2 {
    let pair-conj = get-term("pair-conj")
    pr(ranges.first(), db: db) + pair-conj + pr(ranges.last(), db: db)
  } else {
    let middle-conj = get-term("middle-conj")
    let last-conj = get-term("last-conj")
    ranges.map(pr).join(middle-conj, last: last-conj)
  }
}

#let print-groups(gs, db: __db) = {
  gs
    .map(print-group.with(db: db))
    .join(
      get-term("middle-group-conj", db: db),
      last: get-term("last-group-conj", db: db),
    )
}
