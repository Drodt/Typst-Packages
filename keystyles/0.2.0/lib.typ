#import "@preview/curryst:0.6.0"

#let dlfunc(f) = math.italic(f)
#let dlsort(s) = math.sans(s)
#let dlvar(v) = math.italic(v)

#let keyinstanceof(val, ty) = ty + [::instance] + math.lr([(#val)])
#let keyif(cond, t, e) = [if #cond then #t else #e]

#let mono(c) = text(font: "DejaVu Sans Mono", size: .8em, c)

#let rust(c) = if type(c) == str { raw(lang: "rs", c) } else { mono(c) }
#let java(c) = if type(c) == str { raw(lang: "java", c) } else { mono(c) }

#let pv(x) = rust(x)

#let dia(p) = math.lr(sym.chevron.l + rust(p) + sym.chevron.r)
#let diac(p) = math.lr(
  sym.chevron.l
    + sym.pi
    + h(.2em)
    + rust(p)
    + h(.2em)
    + sym.omega
    + sym.chevron.r,
)
#let dlf(p, f) = dia(p) + f
#let dlfc(p, f) = diac(p) + f
#let dlbox(p) = sym.bracket.l + rust(p) + sym.bracket.r
#let dlboxf(p, f) = dlbox(p) + f
#let dlboth(p) = (
  sym.chevron.l
    + h(-.1em)
    + sym.bracket.l
    + rust(p)
    + sym.bracket.r
    + h(-.1em)
    + sym.chevron.r
)
#let dlbothf(p, f) = dlboth(p) + f

#let upd = sym.colon.eq
#let upl = sym.brace.l
#let upr = sym.brace.r
#let update(lhs, rhs) = upl + lhs + upd + rhs + upr
#let dupd = $ast #h(-.4em) ->$
#let parupd = $||$
#let applyUp(u) = upl + u + upr

#let expUpd(v, f) = $#v triangle.r #f$

#let substOp(l, r) = (
  sym.brace.l
    + sym.backslash
    + [subst]
    + h(.1em)
    + l
    + sym.semi
    + h(.1em)
    + r
    + sym.brace.r
)

// Sequents
#let turnstyle = sym.arrow.r.double.long

#let ruleName(n) = math.sans(n)

#let seq(l, r) = {
  if type(l) == array {
    l = l.join($,$)
  }
  if type(r) == array {
    r = r.join($,$)
  }
  l + math.thin + turnstyle + math.thin + r
}

#let sequent(
  ante: none,
  succ: none,
) = seq[$Gamma#if ante == none { none } else { sym.comma + ante }$][$#if succ == none { none } else { succ + sym.comma }Delta$]

#let prooftree = curryst.prooftree.with(
  title-inset: 4pt,
  min-premise-spacing: 10pt,
)
#let rule(name, cond: none, def: false, ..premises, conclusion) = curryst.rule(
  label: if def [#smallcaps(name)#label("dlrule:" + name)] else {
    smallcaps(name)
  },
  name: cond,
  ..premises,
  conclusion,
)
#let ruleW(name, cond: none, ..premises, conclusion) = context {
  let lbl = [#smallcaps(name)#label("dlrule:" + name)]

  let pt = prooftree(
    curryst.rule(
      label: none,
      name: cond,
      ..premises,
      conclusion,
    ),
  )
  box(lbl + h(measure(pt).width - measure(lbl).width) + linebreak() + pt)
}

#let dl-ref(name) = link(label("dlrule:" + name))[Rule~#smallcaps(name)]

#let closeBranch = sym.star

#let seqRule(name, ..pre, concl, cond: none) = {
  let pres = pre.pos()
  prooftree(rule(name, cond: cond, def: true, ..pres, concl))
}

#let seqRuleW(name, ..pres, concl, cond: none) = context {
  let r = rule(name, cond: cond, def: true, ..pres, concl)
  let lbl = r.at("label")
  let lens = (concl, ..pres.pos()).map(p => measure(p).width)
  let len = calc.max(..lens)
  let pt = align(
    center,
    {
      for pre in pres.pos() {
        pre
        linebreak()
      }
      v(-.8em)
      line(start: (0pt, 0pt), length: len + 4pt, stroke: .4pt)
      v(-.8em)
      concl
      if cond != none {
        linebreak()
        v(0pt)
        cond
      }
    },
  )
  box(lbl + h(measure(pt).width - measure(lbl).width) + linebreak() + pt)
}

#let iField(f) = math.mono([<#f>])
#let iMeth(m) = math.mono([<#m>()])
#let iNextToCreate = iField("nextToCreate")
#let iCreated = iField("created")
#let iInitialised = iField("initialised")
#let iErroneous = iField("erroneous")
#let imPrepare = iMeth("prepare")
#let imPrepareEnter = iMeth("prepareEnter")
#let imInit = iField("init") // paremeters are added in the text
#let imCreateObject = iMeth("createObject")
#let imAllocate = iMeth("allocate")
#let imClInit = iMeth("clinit")
#let imClPrepare = iMeth("clprepare")

// KeY logical operators, in concrete KeY syntax
#let keyeq = math.accent(sym.eq, sym.dot)
#let keyneq = math.accent(sym.eq.not, sym.dot)
#let keyquantification(quant: none, ..args) = (
  quant
    + h1(.1em)
    + args.at(0)
    + if args.len() == 1 { none } else { h(.1em) + args.at(1) }
    + sym.semi
    + h(.1em)
)
#let keyallq = keyquantification.with(quant: sym.backslash + [forall])
#let keyquantification = keyquantification.with(quant: sym.backslash + [exists])
#let keyallqmath = keyquantification.with(quant: sym.forall)
#let keyexqmath = keyquantification.with(quant: sym.exists)
#let keytrue = math.op("true")
#let keyfalse = math.op("false")
#let keybooltrue = math.italic("TRUE")
#let keyboolfalse = math.italic("FALSE")
#let rewrite = sym.arrow.r.squiggly

// KeY book

#let KeY = [Ke#h(-1pt)Y]
#let Java = [Java]
#let Rust = [Rust]
#let JML = [JML]
#let RustyKeY = [Rusty#KeY]

#let models = sym.tack.r.double
#let not-models = sym.tack.r.double.not

#let types = math.cal("T")
#let t-sym = math.text("TSym")

#let subtype = sym.subset.eq.sq
#let subtype-direct = [$#subtype^0$]
#let supertype = sym.supset.eq.sq
#let t-intersect = sym.inter.sq
#let t-union = sym.union.sq

#let v-sym = math.text("VSym")
#let pv-sym = math.text("ProgVSym")
#let f-sym = math.text("FSym")
#let trm(ty) = $"Trm"_#ty$
#let dl-trm(ty) = $"DLTrm"_#ty$
#let fml = "Fml"
#let fl-fml = "DLFml"
#let p-var = "PVar"

#let fvar = math.italic("fv")
#let var = math.italic("var")
#let func(f) = math.italic(f)

#let states = math.cal("S")

#let domain = math.cal("D")
#let d-type = sym.delta
#let s-type = sym.sigma

#let s-domain(t) = $#domain^#t$

#let interp = math.text("I")

#let domain-order = $prec.eq_#domain$

#let choice = math.cal("C")

#let structure = math.cal("M")
#let k-struct = math.cal("K")

#let valname = math.text("val")
#let vals = math.attach(valname, br: $#k-struct, s, beta$)
#let vals-prime = math.attach(valname, br: $#k-struct, s', beta$)
#let vals-prime-prime = math.attach(valname, br: $#k-struct, s'', beta$)
#let vals-one = math.attach(valname, br: $#k-struct, s_1, beta$)
#let vals-two = math.attach(valname, br: $#k-struct, s_2, beta$)
#let vals-three = math.attach(valname, br: $#k-struct, s_3, beta$)
#let vals-four = math.attach(valname, br: $#k-struct, s_4, beta$)

#let valids = vals + models
#let valids-prime = vals-prime + models
#let valids-prime-prime = vals-prime-prime + models
#let valids-one = vals-one + models
#let valids-two = vals-two + models
#let valids-three = vals-three + models
#let valids-four = vals-four + models

#let para-fn(name, ..args) = $dlfunc(#name)"<"#args.pos().join($,$)">"$
#let para-sort(name, ..args) = $dlsort(#name)"<"#args.pos().join($,$)">"$

#let instanceof(S) = para-fn("instanceof", S)

// Integer

#let Int = dlsort("int")

#let in-int(ty) = text(style: "oblique", "in_" + ty)

#let inI32 = in-int("i32")

#let add = dlfunc("add")

// References

#let RefS(S) = para-sort("RefS", S)
#let RefM(S) = para-sort("RefM", S)
#let Place(S) = para-sort("Place", S)

#let refS(S) = para-fn("refS", S)
#let refSI = dlfunc("refS")
#let refM(S) = para-fn("refM", S)
#let refMI = dlfunc("refM")
#let place(x) = $floor.l #h(-.3em) floor.l #x ceil.r #h(-.3em) ceil.r$

// Arrays

#let Array(E, N) = para-sort("Array", E, $"const" #N$)

#let arrGet(S) = para-fn("get", S)
#let arrGetI = dlfunc("get")
#let arrSet(S) = para-fn("set", S)
#let arrSetI = dlfunc("set")
