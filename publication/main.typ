#import "ilm.typ": *

#set text(lang: "en", region: "GB")

#show: ilm.with(
  title: [Bachelor Thesis\ Query by Graph],
  author: "Friedrich Answin Daniel Motz",
  date: datetime(year: 2025, month: 01, day: 12),
  date-format: "[day padding:none] [month repr:long] [year]",
  abstract: [
    I propose a collection of tools for building and running SPARQL queries for complex RDF databases, which are neatly composed into one and given the name Visual Query Builder. #todo[Reformulate]
  ],
  preface: align(center)[#todo[Insert a preface here.]],
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
  bibliography: bibliography(style: "institute-of-electrical-and-electronics-engineers", "bib.yaml")
)

#set heading(numbering: "1.1")
#set quote(block: true)

#show heading.where(level: 1): it=> [#v(.5cm) #align(center, it) #v(.2cm)]
#show heading.where(level: 2): it=> [#v(.5cm) #align(center, it) #v(.2cm)]

/* BEGIN Custom Environment */

#let exampleCounter = counter("exC")
#exampleCounter.update(0)

#show heading.where(
  level: 6
): it => text(
  weight: "regular",
  style: "italic",
  it.body,
)

#let beispiel(it) = {
  exampleCounter.step()
  context {
    let _n = numbering( "1", exampleCounter.get().at(0))
    text(style: "italic", [#heading(level: 6, bookmarked: true, numbering: none, "Beispiel " + _n + ": ") #label("example"+_n)]) + it
  }
}

#let übungCounter = counter("üC")
#übungCounter.update(0)

#let übung(it) = {
  übungCounter.step()
  context {
    let _n = numbering( "1", exampleCounter.get().at(0))
    text(style: "italic", [#heading(level: 6, bookmarked: true, numbering: none, "Übung " + _n + ": ") #label("excercise"+_n)]) + it
  }
}

#let s = sym.space.punct

#let note(it) = text(fill: luma(150), size: 0.7em, it)
#let todo(it) = note([\/\/ to do: ]+it)
#let spruch(it) = move(dx: -30pt, text(style: "italic", fill: luma(100), quote(it)))

/* END Custom Environment */

= Aim and Relevance
- Context: make sure to link where your work fits in
- Problem: gap in knowledge, too expensive, too slow, a deficiency, superseded technology
- Strategy: the way you will address the problem  

I should also state some general information:
- comment on employed hardware and software
- describe methods and techniques that build the basis of your work
- review related work(!)

== Problem
RDF databases store large amounts of data and are freely available, however, they:
- usually contain no formal ontology to inference on their data,
- can hardly automatically be made consistent with a formal ontology,
- allow for no consistency checks (those have to be ran as e.g. post-hoc batch jobs),
- can only be queried using SPARQL, which is not intuitive for non-programmers (article by Olaf Simons).



== Related Work
=== Visualising Graph Database Queries
@Vargas2019_RDF_Explorer


=== Connecting Ontologies and RDF Databases
@Arakawa2023_SugarBindRDFOntology

= Fundamentals

Questions, which I would like to be answered in this chapter:
- How can information about the real world be represented in a computer?
- What is the advantage of using a strict formal ontology in comparison to an RDF database.
- How can ontologies

== Semantic Technologies
@Dengel2012_Semantic_Technologies

(There are Springer conferences on semantic web technologies: https://suche.thulb.uni-jena.de/Record/1041330375?sid=49057082)

== RDF Databases
- What are alternatives to RDF databases?
- How do RDF Databases work?
- Which query languages work / are used on RDF databases?

== OWL
@Sack2009_OWL_und_OWL_Semantik
@Lacy2005_OWL

== Knowledge Representation
@Stock2008_Wissensrepräsentation

== SPARQL
Which features does SPARQL offer and which can I graphically visualise?

How can I visualise filters?



= Developed architecture / system design / implementation

- start with a theoretical approach
- describe the developed system/algorithm/method from a high-level point of view
- go ahead in presenting your developments in more detail


= Measurement results / analysis / discussion

- whatever you have done, you must comment it, compare it to other systems, evaluate it
- usually, adequate graphs help to show the benefits of your approach
- caution: each result/graph must be discussed! what's the reason for this peak or why have you observed this effect
