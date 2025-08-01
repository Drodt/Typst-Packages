#let mkpos(line, col) = (line: line, column: col)

#let token(kind, text, pos) = (kind: kind, text: text, pos: pos)

#let _print_pos(pos) = str(pos.at("line")) + ":" + str(pos.at("column"))

#let tokenize(input) = {
  let toks = ()
  let pos = 0
  let line = 1
  let col = 1
  let len = input.len()

  while pos < len {
    let c = input.at(pos)

    if c == "<" {
      toks.push(token("LT", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == ">" {
      toks.push(token("GT", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == "'" {
      let start-col = col
      pos += 1
      col += 1
      let start = pos
      while input.at(pos) != "'" {
        if input.at(pos) == "\\" and input.at(pos + 1) == "'" {
          pos += 1
          col += 1
        }
        pos += 1
        col += 1
      }
      toks.push(token("TERMINAL", input.slice(start, pos).replace("\\'", "'"), mkpos(line, start-col)))
      pos += 1
      col += 1
    } else if c == " " {
      pos += 1
      col += 1
    } else if c == "\\" {
      let start = pos
      let start-col = col
      pos += 1
      col += 1
      let d = input.at(pos)

      if d == "\\" {
        toks.push(token("LINEBREAK", "\\\\", mkpos(line, start-col)))
        pos += 1
        col += 1
      } else if d == "|" {
        toks.push(token("ALT", "\\|", mkpos(line, start-col)))
        pos += 1
        col += 1
      } else {
        panic("Expected escaped input, got " + d + " @" + _print_pos(mkpos(line, col)))
      }
    } else if (c >= "A" and c <= "Z") or (c >= "a" and c <= "z") {
      let start = pos
      let start-col = col
      pos += 1
      col += 1
      while (input.at(pos) >= "A" and input.at(pos) <= "Z") or (input.at(pos) >= "a" and input.at(pos) <= "z") or (input.at(pos) >= "0" and input.at(pos) <= "9") or input.at(pos) == "_" or input.at(pos) == "-" {
        pos += 1
        col += 1
      }
      toks.push(token("IDENT", input.slice(start, pos), mkpos(line, start-col)))
    } else if c == ":" and input.at(pos + 1) == ":" and input.at(pos + 2) == "=" {
      toks.push(token("DEFINE", "::=", mkpos(line, col)))
      pos += 3
      col += 3
    } else if c == "*" {
      toks.push(token("STAR", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == "+" {
      toks.push(token("PLUS", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == "?" {
      toks.push(token("QMARK", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == "(" {
      toks.push(token("LPAREN", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == ")" {
      toks.push(token("RPAREN", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == "|" {
      toks.push(token("VBAR", c, mkpos(line, col)))
      pos += 1
      col += 1
    } else if c == "\n" {
      toks.push(token("NEWLINE", c, mkpos(line, col)))
      pos += 1
      col = 1
      line += 1
    } else {
      panic("Unknown token " + c + " @" + _print_pos(mkpos(line, col)))
    }
  }

  toks
}

#let _is(toks, pos, expected) = pos < toks.len() and toks.at(pos).at("kind") == expected

#let _eat(toks, pos, expected) = if _is(toks, pos, expected) {
  let res = toks.at(pos)
  pos += 1
  (pos, res)
} else if pos >= toks.len() {
  panic("Error @" + _print_pos(toks.at(pos).at("pos")) + ": Expected " + expected + "; got EOF")
} else {
  panic("Error @" + _print_pos(toks.at(pos).at("pos")) + ": Expected " + expected + "; got " + toks.at(pos).at("kind") + "(" + toks.at(pos).at("text") + ")")
}

#let _parse_nt(toks, pos) = {
  let ident
  (pos, _) = _eat(toks, pos, "LT")
  (pos, ident) = _eat(toks, pos, "IDENT")
  (pos, _) = _eat(toks, pos, "GT")
  (pos, (kind: "NT", name: ident.at("text")))
}

#let _parse_alts(toks, pos) = {
  let _parse_term(toks, pos) = {
    let term
    (pos, term) = if _is(toks, pos, "LT") {
      let (npos, nt) = _parse_nt(toks, pos)
      (npos, nt)
    } else if _is(toks, pos, "TERMINAL") {
      (pos + 1, (kind: "T", text: toks.at(pos).at("text")))
    } else if _is(toks, pos, "LPAREN") {
      pos += 1
      let terms = ()
      while not _is(toks, pos, "RPAREN") {
        let (npos, term) = _parse_alts(toks, pos)
        terms.push(term)
        pos = npos
      }
      pos += 1
      (pos, (kind: "GROUP", terms: terms))
    } else if _is(toks, pos, "LINEBREAK") {
      (pos + 2, (kind: "LB", text: "\\\n"))
    } else {
      panic("Unexpected token @" + _print_pos(toks.at(pos).at("pos")) + ": " + toks.at(pos).at("kind"))
    }

    if _is(toks, pos, "QMARK") {
      pos += 1
      term = (kind: "OPTIONAL", term: term)
    } else if _is(toks, pos, "STAR") {
      pos += 1
      term = (kind: "REPEAT", term: term)
    } else if _is(toks, pos, "PLUS") {
      pos += 1
      term = (kind: "AT_LEAST", term: term)
    }

    (pos, term)
  }

  let _parse_terms(toks, pos) = {
    let terms = ()
    while not _is(toks, pos, "VBAR") and not _is(toks, pos, "NEWLINE") and not _is(toks, pos, "RPAREN") and pos < toks.len() {
      let (npos, term) = _parse_term(toks, pos)
      terms.push(term)
      pos = npos
    }
    (pos, (kind: "TERMS", terms: terms))
  }

  let term
  (pos, term) = _parse_terms(toks, pos)
  if _is(toks, pos, "VBAR") {
    let alts = (term,)
    while _is(toks, pos, "VBAR") {
      pos += 1
      let (npos, term) = _parse_terms(toks, pos)
      alts.push(term)
      pos = npos
    }
    (pos, (kind: "ALTERNATIVES", alts: alts))
  } else {
    (pos, term)
  }
}

#let _parse_rhs(toks, pos) = {
  let term
  (pos, term) = _parse_alts(toks, pos)
  let lines = (term,)
  while _is(toks, pos, "NEWLINE") and _is(toks, pos + 1, "ALT") {
    pos += 2
    let (npos, term) = _parse_alts(toks, pos)
    lines.push(term)
    pos = npos
  }
  if lines.len() == 1 {
    (pos, lines.at(0))
  } else {
    (pos, (kind: "LINES", lines: lines))
  }
}

#let _parse_production(toks, pos) = {
  while toks.at(pos).at("kind") == "NEWLINE" {
    pos += 1
  }
  let lhs
  let rhs
  (pos, lhs) = _parse_nt(toks, pos)
  (pos, _) = _eat(toks, pos, "DEFINE")
  (pos, rhs) = _parse_rhs(toks, pos)

  (pos, (lhs: lhs, rhs: rhs))
}

#let parse_gramar(toks) = {
  let pos = 0
  let productions = ()

  while pos < toks.len() {
    let (newpos, prod) = _parse_production(toks, pos)
    productions.push(prod)
    pos = newpos
  }

  productions
}

#let _print_term(term) = {
  let kind = term.at("kind")
  if kind == "NT" {
    sym.angle.l + h(.1em) + emph(term.at("name")) + h(.1em) + sym.angle.r
  } else if kind == "T" {
    box(raw("‘" + term.at("text") + "’"))
  } else if kind == "GROUP" {
    [(#term.at("terms").map(_print_term).join())]
  } else if kind == "TERMS" {
    [#term.at("terms").map(_print_term).join([~])]
  } else if kind == "OPTIONAL" {
    [#_print_term(term.at("term"))?]
  } else if kind == "REPEAT" {
    [#_print_term(term.at("term"))\*]
  } else if kind == "ALTERNATIVES" {
    term.at("alts").map(_print_term).join([~|~])
  } else if kind == "LB" {
    linebreak() + h(1.2em)
  } else if kind == "LINES" {
    term.at("lines").map(_print_term).join(linebreak() + h(1em) + [|~])
  } else if kind == "AT_LEAST" {
    [#_print_term(term.at("term"))+]
  } else {
    panic("Unknown kind " + kind)
  }
}

#let _print_grammar(g) = {
  set par(justify: false, linebreaks: "optimized", hanging-indent: 2em)
  let out = []
  for prod in g {
    let lhs = _print_term(prod.at("lhs"))
    let rhs = _print_term(prod.at("rhs"))
    out += align(start, block([#lhs #sym.colon.double.eq #rhs]))
  }
  out
}

#let _debug_grammar(input) = {
  let toks = tokenize(input)
  parse_gramar(input)
}

#let grammar(input) = {
  let toks = tokenize(input)
  let g = parse_gramar(toks)
  _print_grammar(g)
}
