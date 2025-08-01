/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/

// abbrv figure kind
#let __abbrv_figure = "abbrv_entry"
// prefix of label for references query
#let __abbrv_label_prefix = "abbrv:"
// global state containing the abbrv entry and their location
#let __abbrv_entries = state("__abbrv_entries", (:))

#let __query_labels_with_key(loc, key, before: false) = {
  if before {
    query(
      selector(label(__abbrv_label_prefix + key)).before(loc, inclusive: false),
      loc,
    )
  } else {
    query(
      selector(label(__abbrv_label_prefix + key)),
      loc,
    )
  }
}

// Reference a term
#let abbrv(key, suffix: none, long: none, display: none) = {
  locate(
    loc => {
      let __abbrv_entries = __abbrv_entries.final(loc);
      if key in __abbrv_entries {
        let entry = __abbrv_entries.at(key)

        let gloss = __query_labels_with_key(loc, key, before: true)

        let is_first = gloss == ();
        let entlong = entry.at("long", default: "")
        let textLink = if display != none {
            [#display]
        } else if (is_first or long == true) and entlong != [] and entlong != "" and long != false {
          [#entlong (#entry.short#suffix)]
        } else {
          [#entry.short#suffix]
        }

        [#textLink#label(__abbrv_label_prefix + entry.key)]
      } else {
        text(fill: red, "Abbreviation not found: " + key)
      }
    },
  )
}

// reference to term with pluralisation
#let abbrvpl(key) = abbrv(key, suffix: "s")

// show rule to make the references for abbrv
#let make-abbrvs(body) = {
  show ref: r => {
    if r.element != none and r.element.func() == figure and r.element.kind == __abbrv_figure {
      // call to the general citing function
      abbrv(str(r.target), suffix: r.citation.supplement)
    } else {
      r
    }
  }
  body
}

#let print-abbrvs(entries, show-all: false) = {
  __abbrv_entries.update(
    (x) => {
      for entry in entries {
        x.insert(
          entry.key,
          (
            key: entry.key,
            short: entry.short,
            long: entry.at("long", default: ""),
            desc: entry.at("desc", default: ""),
          ),
        )
      }

      x
    },
  )

  for entry in entries.sorted(key: (x) => x.key) {
    hide[
    #show figure.where(kind: __abbrv_figure): it => it.caption
    #par(
      hanging-indent: 1em,
      first-line-indent: 0em,
    )[
      #figure(
        supplement: "",
        kind: __abbrv_figure,
        numbering: none,
        caption: {
          locate(
            loc => {
              let term_references = __query_labels_with_key(loc, entry.key)
              if term_references.len() != 0 or show-all {
                let desc = entry.at("desc", default: "")
                let long = entry.at("long", default: "")
                let hasLong = long != "" and long != []
                let hasDesc = desc != "" and desc != []

                {
                  set text(weight: 600)
                  if hasLong {
                    emph(entry.short) + [ -- ] + entry.long
                  }
                  else {
                    emph(entry.short)
                  }
                }
                if hasDesc [: #desc ] else [. ]

                term_references.map((x) => x.location())
                .sorted(key: (x) => x.page())
                .fold(
                  (values: (), pages: ()),
                  ((values, pages), x) => if pages.contains(x.page()) {
                    (values: values, pages: pages)
                  } else {
                    values.push(x)
                    pages.push(x.page())
                    (values: values, pages: pages)
                  },
                )
                .values
                .map(
                  (x) => link(
                    x,
                  )[#numbering(x.page-numbering(), ..counter(page).at(x))],
                )
                .join(", ")
              }
            },
          )
        },
      )[] #label(entry.key)
      ]
    #parbreak()
    ]
  }
};