#import "@preview/touying:0.6.1": *
#import "@local/drodt-pres:0.1.0": *

#let title = [Title]
#let author = "Daniel Drodt"
#let date = datetime.today()

#set document(author: author, title: title, date: date)

#show: theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: title,
    author: author,
    date: date.display("[day]. [month repr:long] [year repr:full]"),
    logo: [TU Darmstadt],
  ),
  config-store(quotes: (
    left: "‘",
    right: "’",
  )),
)

#title-slide()

