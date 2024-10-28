#import "ilm.typ": *
#import "@preview/xarrow:0.3.0": xarrow, xarrowSquiggly, xarrowTwoHead
#import "@preview/equate:0.2.1": equate

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

#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(A.1)", supplement: "Eq.")

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

#let longArrow = xarrow.with(
  sym: sym.arrow.long,
  width: 5em,
  partial_repeats: false,
)

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
Much of the world's knowledge is contained in a format, which for a computer, is mostly unstructured, namely, natural language. There have been many attempts to process natural language from e.g. books, which did not yet succeeded in the complete successful extraction of obvious knowledge contained in them. This is because human language is too ambiguous and dependent on context and an understanding of the real-world, which a computer usually lacks. If we may not get the computer to understand our language, we ought to write in a language it understands. Now, formalising arbitrary knowledge about the world we know in advance, is a big task. The way around is to simply "formalise as you go": 

Everything mankind learns about the world can be written down as a relationship between an individual, say "Johann Wolfgang von Goethe", which relates to an object, say the "University of Leipzig", in a specific way; he was "educated at" the University of Leipzig. Now, one might derive a general way of expressing such relationships using the following structure:

$ 
  "Subject" xarrow("Predicate") "Object", \
$ <triple_structure>

which offers us great possibilities. It can be shown, that our example can be expressed in this form:
#text(size: 0.8em,
$
  "Subject" := "Johann Wolfgang von Goethe" \
  "Predicate" := "educated at" \
  "Object" := "University of Leipzig" \
  "Johann Wolfgang von Goethe" xarrow("educated at") "University of Leipzig"
$)

Such statements  are called assertions. Just from this assertion we can take away that:
- there is something called "Johann Wolfgang von Goethe",
- there is something different from that called "University of Leipzig",
- there is a directed relation called "educated" at and
- of course the assertion itself, meaning that this relation applies between these two subjects.

The compter does still not understand what it means to be educated at some place or where Leipzig is, but it can interact with this information in a formally correct way. The human operator can interpret meaning in to the result.

Such assertions are often called triples, because they can be written as a tuple with three entries: $("Subject", "Predicate", "Object")$. Some real-world relationship might present to be more complex than this. For example, we may want to express that Goethe was educated at the University of Leipzig from 3 October 1765 to 28 August 1768. There are several ways to model this relationship. One possibility is to let relationships have more than two operands, e.g. increase the arity by one for each additional datum. "Educated at" would then be called "educated at (#sym.dot) from (#sym.dot) to (#sym.dot)". Another way using the limited triple syntax is to create an implicit object, that assists in modelling the relationship. We use it to describe a new concept; a human might be inclined to give it a name, e.g. "educated at for a certain time":
$
  "Goethe" &longArrow("educated at") && "Implicit1" \
  "Implicit1" &longArrow("educated at") && "Uni Leipzig" \
  "Implicit1" &longArrow("started at") && 3.10.1765 \
  "Implicit1" &longArrow("ended at") && 28.08.1768
$

The computer does not require a name, it merely handles the explicit assertions for an anonymous concept. Such statements are called qualifiers in the context of Wikidata @wikibooks_sparql_qualifiers. But, this anonymity poses a challenge to a human interpreter. We can handle information better if we can give it a topic, a name.

#todo[
  therefore challenges are:
  - Making information in an RDF databases understandable and not so abstract for a human interpreter (for example visualising the result in a graph)
]

#todo[connect this to somewhere]
RDF databases store large amounts of validated data and are freely available, however, they:
- can only be potently queried using SPARQL, which is not intuitive for non-programmers,
- can be queried using query builders, which however lack many essential features,
- usually contain no formal ontology to inference on their data,
- can hardly automatically be made consistent with a formal ontology and
- allow for no systemic consistency checks (i.e. those have to be ran as post-hoc batch jobs).




== Related Work

=== Visualising Graph Databases and Queries over them
==== RDF Explorer
The approach by Vargas et al. is to show all possible assertions about an object #todo[is "object" the right word?] already while building the query. For example, `wd:Q5879`, also known as Johann Wolfgang von Goethe offers, several possible assertions, such as that he is "instance of" human and that he was "educated at" the University of Leipzig. This approach shows all assertions of Wikidata in a sidebar, implying, that those might be sensible next steps to specify a question.

@Vargas2019_RDF_Explorer


- Offers the user to interactively explorer #link("https://www.wikimedia.de/projekte/wikibase/")[Wikibase instances] (i.e. #link("https://www.wikidata.org/")[Wikidata])
- The search starts from an individual

The implementation is available at https://rdfexplorer.org.


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
- How do RDF databases work?
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
- caution: each result/graph must be discussed! what’s the reason for this peak or why have you observed this effect
