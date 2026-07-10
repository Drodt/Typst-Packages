#import "cleveref.typ": cref, cref-range, cpageref, supplement, labelcref

#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")
#set page(numbering: "1")

#set text(lang: "de")

= Introduction <sec:intro>

#figure(
  table(
    columns: 2,
    [Some data], [yes]
  )
) <tab:one>

$
a = 1
$ <eq:1>

#figure(
  [Hi],
  caption: [Cap]
) <fig:1>

#lorem(500)

== A <sec:a>

#figure(
  table(
    columns: 2,
    [Some data], [yes]
  )
) <tab:two>

$
a = 1
$ <eq:2>

#figure(
  [Hi],
  caption: [Cap]
) <fig:2>

#lorem(500)

= B <sec:b>

#figure(
  table(
    columns: 2,
    [Some data], [yes]
  )
) <tab:three>

$
a = 1
$ <eq:3>

#figure(
  [Hi],
  caption: [Cap]
) <fig:3>

#lorem(500)

= C <sec:c>

#figure(
  table(
    columns: 2,
    [Some data], [yes]
  )
) <tab:four>

$
a = 1
$ <eq:4>

#figure(
  [Hi],
  caption: [Cap]
) <fig:4>

#lorem(500)

#cref(<sec:intro>, <sec:a>, <sec:b>, <sec:c>,
  <tab:one>, <tab:two>, <tab:three>, <tab:four>,
  <eq:1>,<eq:2>,<eq:3>,<eq:4>,
  <fig:1>,<fig:2>,<fig:3>,<fig:4>
)

#cref-range(<sec:intro>, <sec:c>)

#cpageref(<sec:intro>, <sec:a>, <sec:b>, <sec:c>,
  <tab:one>, <tab:two>, <tab:three>, <tab:four>,
  <eq:1>,<eq:2>,<eq:3>,<eq:4>,
  <fig:1>,<fig:2>,<fig:3>,<fig:4>)

#supplement(<sec:a>)

#labelcref(<sec:intro>, <sec:a>, <sec:b>, <sec:c>)