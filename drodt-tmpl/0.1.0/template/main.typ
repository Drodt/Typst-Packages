#import "@local/drodt-tmpl:0.1.0": project

#show: project.with(
  authors: (
    (
      name: "Daniel Drodt",
      email: "daniel.drodt@tu-darmstadt.de",
      affiliation: "TU Darmstadt"
    ),
  ),
  title: [],
  date: datetime.today(),
  draft: true,
)


