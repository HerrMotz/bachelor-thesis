#import "ilm.typ": *
#import "@preview/xarrow:0.3.0": xarrow, xarrowSquiggly, xarrowTwoHead
#import "@preview/equate:0.2.1": equate

#set text(lang: "en", region: "GB")

#let spct = sym.space.punct
#let examiner = [Prof.#spct\Dr. Clemens Beckstein\ M.#spct\Sc. Johannes Mitschunas]
#let degree = [Bachelor of Science (B.#spct\Sc.)]

#show: ilm.with(
  title: [Query by Graph],
  author: "Friedrich Answin Daniel Motz",

  cover-german: (
    faculty: "Fakultät für Mathematik und Informatik",
    university: "Friedrich-Schiller-Universität Jena",
    type-of-work: "Bachelorarbeit",
    academic-degree: degree,
    field-of-study: "Informatik",
    author-info: "15. Juli 2001 in Chemnitz, Deutschland",
    examiner: examiner,
    place-and-submission-date: "Jena, 12. Januar 2025",
  ),

  cover-english: (
    faculty: "Faculty for Mathematics and Computer Science",
    university: "Friedrich Schiller University Jena",
    type-of-work: "Bachelor Thesis",
    academic-degree: degree,
    field-of-study: "Computer Science",
    author-info: "15 July 2001 in Chemnitz, Germany",
    examiner: examiner,
    place-and-submission-date: "Jena, 12 January 2025",
  ),
  
  abstract: [
    I propose a collection of tools for building and running SPARQL queries for complex RDF databases with the support of formal ontologies, which are neatly composed into one and given the name Query by Graph. #todo[Rephrase and add]
  ],
  
  preface: align(left)[
    #todo[Write a heartwarming preface.]
  ],
  
  appendix: [
    #set heading(outlined: false)
    #todo[This chapter should contain all code listings, figures, tables and so on.]
    == Use of Generative AI
    This bachelor thesis was written in assistance of the OpenAI large language models GPT-4o and GPT-o1 preview. The large language models were used to get an overview over a domain, to ease literature research and to point out stylistic, orthographical and grammatical mistakes to the writer. The models were _not_ used to generate passages of this work. 
  ],
  
  abbreviations: (
    ("W3C", "World Wide Web Consortium (registered trademark)"),
    ("RDF", "Resource Description Framework"),
    ("RDFS", "Resource Description Framework Schema (Ontology within RDF)"),
    ("SPARQL", "SPARQL Protocol And RDF Query Language (recursive acronym)"),
    ("IRI", "Internationalised Resource Identifier (similar to URI)"),
    ("OWL", "Web Ontology Language"),
    ("VQG", "Visual Query Graph (user-built query graph)")
  ),

  external-link-circle: true,
  
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
  bibliography: bibliography(title: "Bibliography", style: "institute-of-electrical-and-electronics-engineers", "bib.yaml")
)

/* BEGIN Custom Environment */

#let exampleCounter = counter("exC")
#exampleCounter.update(0)

#show heading.where(level: 6): set heading(outlined: false)

#show heading.where(
  level: 4,
): it => text(
  weight: "bold",
  style: "italic",
  it.body,
)

#show heading.where(
  level: 6,
): it => text(
  weight: "regular",
  style: "italic",
  it.body,
)

#let example(it) = {
  exampleCounter.step()
  context {
    let _n = numbering( "1", exampleCounter.get().at(0))
    text(style: "italic", [#heading(level: 6, bookmarked: true, numbering: none, "Example " + _n + ": ") #label("example"+_n)]) + it
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


#let note(it) = text(fill: luma(150), size: 0.7em, it)
#let spruch(it) = move(dx: -30pt, text(style: "italic", fill: luma(100), quote(it)))

#let longArrow = xarrow.with(
  sym: sym.arrow.long,
  width: 5em,
  partial_repeats: false,
)

#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(A.1)", supplement: "Eq.")

#set heading(numbering: "1.1")
#set quote(block: true)

#show heading.where(level: 1): it=> [#v(.5cm) #align(center, it) #v(.2cm)]
#show heading.where(level: 2): it=> [#v(.5cm) #align(center, it) #v(.2cm)]

#show raw: set text(
  font: "Cascadia Code",
  weight: 300,
  ligatures: true,
  discretionary-ligatures: true,
  historical-ligatures: true,
)

/* END Custom Environment */

= Aim and Relevance
#todo[

Contents of Aim and Relevance
- Context: make sure to link where your work fits in
- Problem: gap in knowledge, too expensive, too slow, a deficiency, superseded technology
- Strategy: the way you will address the problem  

I should also state some general information:
- comment on employed hardware and software
- describe methods and techniques that build the basis of your work
]

== Problem <problem_heading>
Much of the world's knowledge is contained in a format, which for a computer, is mostly incomprehensible, namely, natural language. There have been many attempts to process the semantics of natural language, which did not yet succeed. First and foremost, the computer does not know of any causalities in the real world, which makes certain interpretations unattainable. This is because human language is ambiguous and dependent on context. If we may not get the computer to understand our language, we ought to give it knowledge of our world and express ourselves in a language it can understand.  Now, formalising arbitrary knowledge about the world we know in advance is an impossible task --- at least today. One solution is, to simply not formalise.

Most factual knowledge#todo[what factual knowledge can not be represented using triples?] mankind learns about the world can be written down as a relationship between an individual. A general way of expressing such relationships could be

$ 
  bold("Subject") xarrow(italic("Predicate")) bold("Object"). \
$

#todo[maybe reference @triples_heading]

Say "Johann Wolfgang von Goethe" is a subject, which relates to an object, the "University of Leipzig", in a specific way: He was "educated at" the "University of Leipzig". Using the formalism above, we get
$
  bold("Subject") := "Johann Wolfgang von Goethe", \
  italic("Predicate") := "educated at", \
  bold("Object") := "University of Leipzig", \
  "Johann Wolfgang von Goethe" xarrow("educated at") "University of Leipzig"
$ <spo_goethe_example>

Such assertions are usually referred to as _triples_, because they can be written as a tuple with three entries in the form of $(bold("Subject"), italic("Predicate"), bold("Object"))$ (see @triples_heading). If we interpret this triple as an element of some knowledge base, we can deduct that #todo[such statements are called entailments]:
- there is something called "Johann Wolfgang von Goethe",
- under the assumption that a different symbol implies a different object, there is something different, called "University of Leipzig",
- there is a directed relation called "educated" at and
- of course the assertion itself, meaning that the relation applies between these two objects.

The compter does still not understand what it means to be educated at some place or where Leipzig is, but it can interact with this information in a formally correct way. The human operator can construe meaning in to the result.

#todo[
  Therefore challenges are:
  - Making information in an RDF databases understandable and not so abstract for a human interpreter (for example visualising the result in a graph)
]

#todo[Connect the following to somewhere:]

RDF databases store large amounts of validated data and are freely available, however, they:
- can only be potently queried using SPARQL, which is not intuitive for non-programmers,
- can be queried using query builders, which however lack many essential features,
- usually contain no formal ontology to inference on their data,
- can hardly automatically be made consistent with a formal ontology and
- allow for no systemic consistency checks (i.e. those have to be ran as post-hoc batch jobs).

== Proposed Solution
Query by Graph aims to

- guide the user during the process of formalising the question,

- allow a layman to write arbitrary SPARQL-select-queries, #todo[find a pretty abbreviation for SPARQL-select-queries and change every occurence in the document and write a macro which detects these occurences and marks it as an error]

- integrate

== Related Works

=== RDF Explorer

The approach by Vargas et al. @Vargas2019_RDF_Explorer is to show all possible assertions about an object #todo[Is "object" the right word?] already while building the query. The goal is to guide the formulation of the user's question from a known starting point. This approach uses a fuzzy search prompt for an RDF resource as a starting point. After adding an object from the prompt results to the drawing board, the user can select from a list of all relations to other objects to augment the prompt. The user may also leave the relation unspecified, add a new object and select from a list of all assertions between these two objects. A user may just as well choose to let any object or property be a variable.

#example[
  The _Wikidata_ object `wd:Q5879`, also known as _Johann Wolfgang von Goethe_, offers several possible assertions, such as that he is "instance of" human and that he was "educated at" the University of Leipzig. This approach shows these in a sidebar, implying that those might be sensible next steps to specify a question.
]

Compared to writing a complex query manually, this approach offers feedback on which queries may yield a result. The user does not even need to run the generated SPARQL query, because the result is already clear from the explorer interaction. #todo[Olaf Simons was puzzled, which sense it makes to run the SPARQL query afterwards, because the result is already clear from the interaction.]

A demonstration is available at https://rdfexplorer.org.

=== Exploring KGs (also Vargas)
@Vargas2020_UI_for_Exploring_KGs
#todo[
  Summarise
]

=== RDF2Graph
This approach by van Dam et al. @vanDam2015_RDF2Graph conceptualises special RDF resources, which contain _class_ and _subclass_ assertions for its objects. From this information a network of classes can be extracted, which can be used to visualise the possible relations between instances of classes in the resource. This approach was proven to be useful for resources on biology, e.g. #link("https://www.ebi.ac.uk/chebi/")[ChEBI] and #link("https://sapp.gitlab.io/docs/index.html")[SAPP]. Unfortunately, the approach does not discuss the modelling challenges for resources with incomplete, inconsistent or missing class relations.

=== NLQxform
https://www.semanticscholar.org/paper/NLQxform%3A-A-Language-Model-based-Question-to-SPARQL-Wang-Zhang/159ee26c0c2666b3e18814857b4a4d4182ed8246

=== Smeagol: A "Specific-to-General" Query Interface Paradigm

=== Obi-Wan: Ontology-Based RDF Integration of Heterogeneous Data


=== Knowledge Graph Exploration for Laypeople
@KnowledgeGraphExplorationForLaypeople
#todo[Summarise]


=== Conceptual Navigation in Large Knowledge Graphs 
@ConceptualNavigationInLargeKnowledgeGraphs
#todo[Summarise]

=== Connecting Ontologies and RDF Databases 
@Arakawa2023_SugarBindRDFOntology
#todo[Summarise]

=== Relevant Takeaways
Visual Interfaces seem to be promising advantages in the research community and are relevant.

= Fundamentals

== Semantic Technologies
#todo[

Questions, which I would like to be answered in this chapter:
- How can information about the real world be represented in a computer?
- What are RDF databases in comparison to other semantic technologies?
- What is the advantage of using a strict formal ontology in comparison to an RDF database?
]
@Dengel2012_Semantic_Technologies

// (There are Springer conferences on semantic web technologies: https://suche.thulb.uni-jena.de/Record/1041330375?sid=49057082)

Computers generally lack information about the environment humans live in. Unless formalised, a computer is unaware of the fact, that an arbitrary arrangement of numerals separated by lines, such as `8/7/2000`, is supposed to represent a date an historically formed calendar based on the birth of a religious figure. How would a human know of this culture, if it were not taught to him by his parents? Furthermore, a computer can not parse information from a data source, about which it has no meta-information. Even can be reasonably wrong. Here, I picture a European fellow confronted with the date of a booking confirmation issued by an American company.


The original idea by Tim Berners-Lee, was to annotate web pages using a well-defined, common vocabulary, so that any computer can, without human assistance, extract the important contents of a website. For example, a doctors office might post opening times on a website. Using a vocabulary, the website describes a table as "opening times" and the strings of weekdays and times as entries of the opening times. #todo[insert example code from the book on Semantic Technologies] @Dengel2012_Semantic_Technologies. This concept is not necessarily limited to websites, but can just as well be applied in databases. These deliberations waged the establishment of standards for describing meta information, such as:
- Resource Description Framework (see @heading_rdf_standard)
- Web Ontology Language (@heading_owl)
- #todo[List more from the book @Dengel2012_Semantic_Technologies]


== RDF Standard <heading_rdf_standard>
The W3C#sym.trademark.registered recommends a standard for exchange of semantically annotated information calledestablished the Resource Description Framework (RDF) standard model. The most notable recommendations are

- the Internationalised Resource Identifier (see @iri_heading),

- the RDF graph format and triples (see @triples_heading) and

- the query language SPARQL (see @sparql_heading).

#todo[
- What are alternatives to RDF databases?
- How do RDF databases work?
- Which query languages work / are used on RDF databases?
]

#todo[
  What is a reifier good for/used for (irl)?
]

=== Internationalised Resource Identifier <iri_heading>

=== RDF Graph Format and Triples <triples_heading>

==== Modeling Information using Triples
#todo[Restyle level 3 and 4 headings]

As motivated in @problem_heading, a triple consists of the following structure
$ 
  bold("Subject") xarrow(italic("Predicate")) bold("Object"). \
$ <triple_structure>

Every triple has an equivalent RDF Graph, where the subject and object equate nodes, and the predicate equates a directed connection from subject to object.

#align(center, todo[Insert drawing])

Most real-world relationships might present to be more complex than something one would want to model in a single triple. For example, one may want to express that "Goethe" was educated at the "University of Leipzig" from 3 October 1765 to 28 August 1768. One possibility is to let relationships have more than two operands, i.e. increase the arity by one for each additional parameter. "Educated at" would then be called "educated at (#sym.dot) from (#sym.dot) to (#sym.dot)". Another way using the limited triple syntax is to create an implicit object, that assists in modelling the relationship. We use it to describe a new concept; a human might be inclined to give it a name, e.g. "educated at for a certain time":
$
  "Goethe" &longArrow("educated at") && "Implicit1", \
  "Implicit1" &longArrow("educated at") && "Uni Leipzig", \
  "Implicit1" &longArrow("started at") && 3.10.1765, \
  "Implicit1" &longArrow("ended at") && 28.08.1768 
$ <assertions_goethe_education>

Having specified such an implicit concept for our concept "educated at for a certain time", one is free to add a few extra statements about what he studied and whether he graduated:

$
  "Goethe" &longArrow("educated at") && "Implicit1", \
  "Implicit1" &longArrow("educated at") && "Uni Leipzig", \
  "Implicit1" &longArrow("started at") && 3.10.1765, \
  "Implicit1" &longArrow("ended at") && 28.08.1768, \
  #text(fill: green)[Implicit1] &longArrow("field of study") && #text(fill: green)[Law], \
  #text(fill: green)[Implicit1] &longArrow("graduated") && #text(fill: green)[True]
$ <assertions_goethe_education_revised>

Such statements are usually called qualifiers @wikibooks_sparql_qualifiers. This method of describing information allows us to implicitly define new concepts. Any program dealing with qualifiers merely handles the explicit assertions for an anonymous concept. But, this anonymity poses a challenge to a human interpreter; implicit concepts usually remain unnamed (#todo[todo below (how does it work)]).

#todo[How do qualifiers actually work in the context of the spec @W3C_RDF_1.2_Proposal? Do they use blank nodes?]

#todo[How do qualifiers get their name in Wikidata?]

#todo[Are qualifiers specific to an RDF implementation?]

=== SPARQL Protocol and RDF Query Language <sparql_heading>

#blockquote[
  SPARQL can be used to express queries across diverse data sources, whether the data is stored natively as RDF or viewed as RDF via middleware. SPARQL contains capabilities for querying required and optional graph patterns along with their conjunctions and disjunctions. SPARQL also supports extensible value testing and constraining queries by source RDF graph. The results of SPARQL queries can be results sets or RDF graphs. @W3C_SPARQL_Specification
]

#todo[
  Which features does SPARQL offer?
]

== Web Ontology Language <heading_owl>
@Sack2009_OWL_und_OWL_Semantik
@Lacy2005_OWL

== Visual Query Graph
#todo[As proposed by Vargas or the french dude, I don't recall.]



= Developed architecture / system design / implementation

#todo[
Should contain the following aspects:
- start with a theoretical approach
- describe the developed system/algorithm/method from a high-level point of view
- go ahead in presenting your developments in more detail
]

== Architecture
- Web App (Vite+Vue+Rust+ReteJS+TailwindCSS)
- All mapping algorithms are written in Rust to ensure completeness and speed
- Integrates fuzzy search using Wikibase APIs (exemplary implementation for Wikidata and Factgrid)

== Use in Lecture
- Patrick Stahl developed for Clemens Beck
- Changes / contributions by patrick are clearly marked in Version Control

#todo[How do I license the code? Maybe Rechtsamt fragen.]

== Visual Query Graph-SPARQL Mapping
Novel to current work:
+ Qualifiers are visualised more intuitively (see Simons Blog) #todo[Create reference for Olaf Simons Blogpost]
+ Multiple datasources and clear prefixes #todo[Check, whether this is actually new]
+ ... more?

== SPARQL-OWL Mapping

=== Select Queries
#todo[
  Which features can I graphically visualise?
  - Triples
  - Qualifiers
  - Literals
  - blank nodes?
  - Filters?
  - ...
]

A SPARQL-SELECT-Query

= Measurement results / analysis / discussion

#todo[
- whatever you have done, you must comment it, compare it to other systems, evaluate it
- usually, adequate graphs help to show the benefits of your approach
- caution: each result/graph must be discussed! what’s the reason for this peak or why have you observed this effect
]

= Further Work

+ Creating SPARQL assertions (INSERT statement)

+ SPARQL FILTER query

+ Allow user to specify own data sources

= Declaration of Academic Integrity

#todo[Last edited: January 2024, check for a newer version when I submit]

1. I hereby confirm that this work — or in case of group work, the contribution for which I am responsible and which I have clearly identified as such — is my own work and that I have not used any sources or resources other than those referenced.

   I take responsibility for the quality of this text and its content and have ensured that all information and arguments provided are substantiated with or supported by appropriate academic sources. I have clearly identified and fully referenced any material such as text passages, thoughts, concepts or graphics that I have directly or indirectly copied from the work of others or my own previous work. Except where stated otherwise by reference or acknowledgement, the work presented is my own in terms of copyright. 
   
2. I understand that this declaration also applies to generative AI tools which cannot be cited (hereinafter referred to as "generative AI").

  I understand that the use of generative AI is not permitted unless the examiner has explicitly authorised its use (Declaration of Permitted Resources). Where the use of generative AI was permitted, I confirm that I have only used it as a resource and that this work is largely my own original work. I take full responsibility for any AI-generated content I included in my work. 
   
  Where the use of generative AI was permitted to compose this work, I have acknowledged its use in a separate appendix. This appendix includes information about which AI tool was used or a detailed description of how it was used in accordance with the requirements specified in the examiner#sym.quote.single\s Declaration of Permitted Resources. I have read and understood the requirements contained therein and any use of generative AI in this work has been acknowledged accordingly (e.g. type, purpose and scope as well as specific instructions on how to acknowledge its use). 

#todo[Check whether #sym.quote.single is the right thing to use here.]

3. I also confirm that this work has not been previously submitted in an identical or similar form to any other examination authority in Germany or abroad, and that it has not been previously published in German or any other language. 

4. I am aware that any failure to observe the aforementioned points may lead to the imposition of penalties in accordance with the relevant examination regulations. In particular, this may include that my work will be classified as deception and marked as failed. Repeated or severe attempts to deceive may also lead to a temporary or permanent exclusion from further assessments in my degree programme. 

#v(40pt)
#grid(columns: (1fr, 1fr), row-gutter: 1em,
  line(length: 150pt, stroke: (dash: "dashed")),
  line(length: 200pt, stroke: (dash: "dashed")),
  "Place and date",
  "Signature"
)
