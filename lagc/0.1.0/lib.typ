#import "@preview/cetz:0.5.2"

#let consSym = math.class("binary", $arrow.cw.half$)
#let consTr(a, b) = $#b consSym #a$
#let concatTr(a, b) = $#a dot.c #b$
#let cont(e) = $upright("K")(#e)$
#let contP(p, e) = $upright("K")^#p (#e)$
#let mkTr(s) = $chevron.l #s chevron.r$
#let valDSym = $"val"_sigma$
#let valB(s, e) = $"val"_#s (#e)$
#let valD(e) = valB(sym.sigma, e)
#let valBP(b, p, e) = $"val"_#b^#p (#e)$
#let valPSym(p) = $"val"_sigma^#p$
#let valP(p, e) = valBP(sym.sigma, p, e)
#let pc = $italic("pc")$
#let pop = $triangle.r$
#let mono(c) = text(font: "DejaVu Sans Mono", size: .8em, c)
#let pv(x) = mono(x)
#let update(s, v, e) = $#s [#v mapsto #e]$
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

  let p = args.at("p", default: none)
  let c = if p == none {
    cont(e)
  } else {
    contP(p, e)
  }

  tr = concatTr(tr, c)

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
#let ctraces = $bold("CTr")$

#let many(e) = $overline(#e)$

#let trueSem = $upright("t")#h(-.8mm)upright("t")$
#let falseSem = $upright("f")#h(-.5mm)upright("f")$

#let last = $upright("last")$
#let lastEv = $upright("lastEv")$

#let semChop = math.class("binary", $ast#h(-1mm)ast$)

#let bottle = cetz.canvas(length: 1.2 * 4.3pt, {
  import cetz.draw: *

  line(
    (0, 1.5),
    (0, 1.2),
    (-.15, .8),
    (-.15, 0),
    (rel: (.6, 0)),
    (rel: (0, .8)),
    (rel: (-.15, .4)),
    (rel: (0, .3)),
    close: true,
    stroke: 0.08 * 4.3pt,
  )
})
