#let consSym = $arrow.cw.half$
#let consTr(a, b) = $#b arrow.cw.half #a$
#let concatTr(a, b) = $#a dot.c #b$
#let cont(e) = $upright("K")(#e)$
#let mkTr(s) = $angle.l #s angle.r$
#let valD(e) = $"val"_sigma (#e)$
#let pc = $italic("pc")$
#let pop = $triangle.r$
#let update(s, v, e) = $#s [pv(#v) mapsto #e]$
#let wf = $italic("wf")$
#let sh = $italic("sh")$
#let ev = $italic("ev")$
#let ctr(..args, e) = {
  let pos = args.pos()
  if pos.len() == 0 {
    panic("Expected at least one element of a trace")
  }
  let pc = args.at("pc", default: none)
  let tr = mkTr(pos.at(0))

  for i in range(1, pos.len()) {
    let t = pos.at(i)
    tr = consTr(t, tr)
  }

  tr = concatTr(tr, cont(e))

  if pc != none {
    $#pc pop tr$
  } else {
    tr
  }
}
#let traces(e, s) = $bold("Tr")(#e,#s)$
