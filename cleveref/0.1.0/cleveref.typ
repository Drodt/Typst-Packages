#import "util.typ"

#let cref(db: util.__db, ..args) = context {
  let lbls = args.pos()
  if lbls.len() == 0 {
    panic("No labels provided")
  }
  if lbls.len() == 1 {
    return ref(lbls.first())
  }
  let elems = util.get-elements(lbls)
  let groups = util.group-by-supp(elems)
  util.print-groups(groups, db: db)
}

#let cref-range(start, end, db: util.__db) = context {
  let elems = util.get-elements((start, end))
  if elems.first().supplement != elems.last().supplement {
    panic("Two different supplements: " + elems.first().supplement.text + " != " + elems.last().supplement.text)
  }
  let supp = elems.first().supplement.text
  util.get-term(supp + "-pl", db: db) + [~]
  util.print-range(elems)
}

#let cpageref(db: util.__db, ..args) = context {
  let labels = args.pos()
  let elems = util.get-page-elems(labels).dedup()
  util.print-group(elems, db: db)
}

#let cpageref-range(start, end) = context {
  let labels = args.pos()
  let elems = util.get-page-elems(labels)
  let supp = elems.first().supplement.text + [~]
  util.print-range(elems)
}

#let supplement(label) = context {
  query(label).first().supplement
}

#let labelcref(db: util.__db, ..args) = context {
  let labels = args.pos()
  let lbls = args.pos()
  if lbls.len() == 0 {
    panic("No labels provided")
  }
  let elems = util.get-elements(lbls)
  let groups = util.group-by-supp(elems)
  if groups.len() != 1 {
    panic("All supplements must be equal")
  }
  util.print-group(elems, suppress-supp: true, db: db)
}

#let labelcpageref(db: util.__db, ..args) = context {
  let labels = args.pos()
  let elems = util.get-page-elems(labels).dedup()
  util.print-group(elems, suppress-supp: true, db: db)
}