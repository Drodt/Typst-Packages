#let consSym = math.class("binary", $arrow.cw.half$)
#let consTr(a, b) = $#b consSym #a$
#let concatTr(a, b) = $#a dot.c #b$
#let cont(e) = $upright("K")(#e)$
#let contP(p, e) = $upright("K")^#p (#e)$
#let mkTr(s) = $angle.l #s angle.r$
#let valB(s, e) = $"val"_#s (#e)$
#let valD(e) = valB(sym.sigma, e)
#let valBP(b, p, e) = $"val"_#b^#p (#e)$
#let valP(p, e) = valBP(sym.sigma, p, e)
#let pc = $italic("pc")$
#let pop = $triangle.r$
#let mono(c) = text(font: "DejaVu Sans Mono", size: .8em, c)
#let pv(x) = mono(x)
#let update(s, v, e) = $#s [pv(#v) mapsto #e]$
#let dom(s) = $"dom"(#s)$
#let wf = $italic("wf")$
#let sh = $italic("sh")$
#let shi = $underline(sh)$
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
#let tr(..args) = {
  let pos = args.pos()
  if pos.len() == 0 {
    panic("Expected at least one element of a trace")
  }
  let tr = mkTr(pos.at(0))

  for i in range(1, pos.len()) {
    let t = pos.at(i)
    tr = consTr(t, tr)
  }

  tr
}
#let traces(e, s) = $bold("Tr")(#e,#s)$

#let many(e) = $overline(#e)$

#let trueSem = $upright("t")#h(-1mm)upright("t")$
#let falseSem = $upright("f")#h(-1mm)upright("f")$

#let last = $upright("last")$

#let semChop = math.class("binary", $ast#h(-1mm)ast$)
