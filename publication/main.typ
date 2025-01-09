#import "ilm.typ": *
#import "@preview/xarrow:0.3.0": xarrow, xarrowSquiggly, xarrowTwoHead
#import "@preview/equate:0.2.1": equate

// for definition and example subheadings
#import "@preview/great-theorems:0.1.1": *
#import "@preview/rich-counters:0.2.2": *

// for listings
#import "@preview/codly:1.1.1": *
#show: codly-init.with()
#codly(languages: (
  HTML: (
    name: "SPARQL", color: green
  )
))

// for ER-Diagrams
#import "@preview/pintorita:0.1.3"

#set text(lang: "en", region: "GB")
#show: great-theorems-init
// #show raw.where(lang: "pintora"): it => pintorita.render(it.text) // todo: Add this back in when I want to print.

#let spct = sym.space.punct
#show "e.g.": [e.#sym.space.thin\g.] // unsure whether I like this.
#show "i.e.": [i.#sym.space.thin\e.]
#show "B.Sc.": [B.#spct\Sc.]
#show "M.Sc.": [M.#spct\Sc.]
#show "Prof. Dr.": [Prof.#spct\Dr.]

#let assessor = [Prof. Dr. Clemens Beckstein\ M. Sc. Johannes Mitschunas]
#let degree = [Bachelor of Science (B. Sc.)]

#show: ilm.with(
  title: [Query by Graph],
  author: "Friedrich Answin Daniel Motz",

  // cover-german: (
  //   faculty: "Fakultät für Mathematik und Informatik",
  //   university: "Friedrich-Schiller-Universität Jena",
  //   type-of-work: "Bachelorarbeit",
  //   academic-degree: degree,
  //   field-of-study: "Informatik",
  //   author-info: "15. Juli 2001 in Chemnitz, Deutschland",
  //   assessor: assessor,
  //   place-and-submission-date: "Jena, 12. Januar 2025",
  // ),

  cover-english: (
    faculty: "Faculty for Mathematics and Computer Science",
    university: "Friedrich Schiller University Jena",
    type-of-work: "Bachelor Thesis",
    academic-degree: degree,
    field-of-study: "Computer Science",
    author-info: "15 July 2001 in Chemnitz, Germany",
    assessor: assessor,
    place-and-submission-date: "Jena, 12 January 2025",
  ),
  
  abstract: [
    This thesis establishes the foundation for a visual query builder for SPARQL queries, called *Query by Graph*. The developed program enables users to construct queries for Wikibase instances without the need for coding. Since RDF triplestore contents can be represented as graphs, queries can too. With Query by Graph, users can visually sketch the desired graph structure and insert variables to retrieve results. Additionally, Query by Graph introduces an intuitive representation for querying special Wikibase constructs directly, enhancing usability and functionality.
  ],
  
  preface: align(left)[
    This bachelor thesis represents the culmination of a journey fueled by my commitment to making complex things more accessible. Along the way, I have been fortunate to receive invaluable support, guidance, and inspiration from several remarkable individuals.  

    First and foremost, I owe the genesis of this work to Olaf Simons. His blog post and the initiative FactGrid sparked my interest in exploring Visual Query Graphs and Wikibase, laying the foundation for this thesis.  

    I am deeply grateful to Lucas Werkmeister, whose expertise in the technical intricacies of Wikibase was indispensable. His guidance helped me navigate complexities I could not have overcome alone.  

    I would also like to express my profound thanks to Clemens Beckstein and Johannes Mitschunas for their exceptional mentorship. Their wisdom, encouragement, and thoughtful feedback were instrumental in shaping this project and pushing it to its full potential.  

    Special thanks go to Patrick Stahl for his contributions to implementing UI features. His creativity and technical skill transformed abstract ideas into clear, functional designs, enriching the practical aspects of this work.  

    Each of these individuals has played a vital role in bringing this thesis to fruition. Their support has made this journey not only intellectually rewarding but also personally meaningful.

    To all of you, I extend my heartfelt gratitude.  
  ],
  
  appendix: [
    #set heading(outlined: false)
    #heading(numbering: none, "Use of Generative AI")
    This bachelor thesis was written in assistance of the OpenAI large language models GPT-4o and GPT-o1 preview. The large language models were used to ease literature research and to point out stylistic, orthographical and grammatical mistakes to the writer.
  ],
  
  abbreviations: (
    ("W3C", "World Wide Web Consortium (registered trademark)"),
    ("RDF", "Resource Description Framework"),
    ("RDFS", "Resource Description Framework Schema (Ontology within RDF)"),
    ("SPARQL", [SPARQL Protocol And RDF Query Language (see @heading:sparql)]),
    ("IRI", [Internationalised Resource Identifier (see @heading:iri)]),
    ("BGP", [Basic Graph Pattern (@def:bgp)]),
    ("OWL", "Web Ontology Language"),
    ("VQG", [Visual Query Graph (see @def:vqg)]),
    ("VQL", "Visual Query Language"),
    ("qVQG", [qualifiable Visual Query Graph (see @def:qvqg)]),
    ("WASM", [Web Assembly]),
    ("API", "Application Programming Interface"),
    ("WWW", "World Wide Web")
  ),

  external-link-circle: true, // TURN THIS OFF IF YOU GENERATE THE PRINT VARIANT
  
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
  bibliography: bibliography(title: "Bibliography", style: "ieee", "bib.yaml")
)

/* BEGIN Custom Environment */

#let mathcounter = rich-counter(
  identifier: "mathblocks",
  inherited_levels: 1
)

#let definition = mathblock(
  blocktitle: "Definition",
  counter: mathcounter
)

#let theorem = mathblock(
  blocktitle: "Theorem",
  counter: mathcounter,
)

#let lemma = mathblock(
  blocktitle: "Lemma",
  counter: mathcounter,
)

#let example = mathblock(
  blocktitle: "Example",
  counter: mathcounter,
)

#let remark = mathblock(
  blocktitle: "Remark",
  prefix: [_Remark._],
  // inset: 5pt,
  // fill: lime,
  // radius: 5pt,
)

#let proof = proofblock()

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

#show heading.where(level: 1): it=> [#v(.5cm) #it #v(.2cm)]
#show heading.where(level: 2): it=> [#v(.5cm) #it #v(.2cm)]

#show raw: set text(
  font: "Noto Sans Mono",
  weight: 300,
  ligatures: true,
  discretionary-ligatures: true,
  historical-ligatures: true,
)

/* END Custom Environment */

= Introduction <heading:introduction>

Over its thousands of years in existence, humanity has built an _infrastructure for knowledge_. It started out with stone tablets, evolved to hand-written papyrus books, libraries, the printing press and recently culminated in computer and the internet. Instead of using a library and asking a librarian, we usually consult "the internet" using a search engine -- even for small questions. Now, in order to answer a question, the search engine needs to be able to treat the contents of a website in a semantically correct way, just like a human would. This is achieved using i.e. network analysis and techniques of natural language processing. However, what if the contents of websites could be semantically annotated by their creators? This lead to the inception of the Wikidata#footnote[https://www.wikidata.org] initiative, among others. Their idea was to rewrite Wikipedia articles into very simple assertions using a specified vocabulary. These assertions consist of a subject, predicate and an object, in analogy to sentence structures in linguistics, where subjects and objects can refer to objects of our intuition and predicates define how they are related. These assertions are also referred to as *triples*. Another benefit of these triples is their ability to be represented as a graph (see @fig:rdf_graph_fragment), where nodes represent subjects and objects, and edges represent relationships. This allows to easily visualise the database relationships.

#let lalalalalala = 90pt
$
  "Goethe (subject)"& xarrow("educated at (property)", width: lalalalalala)& "Leipzig (object)" \
  "Goethe"& xarrow("place of birth", width: lalalalalala) &"Frankfurt am Main"
$

#figure(
  caption: [A graphical visualisation of the triple $("Goethe", "educated at", "Leipzig")$ as a graph. Subjects and objects are represented as nodes and properties are represented as edges between these nodes.],
  image("example_triple_graph.svg", width: 230pt)
) <fig:rdf_graph_fragment>

Now, Wikidata contains a very big set of such triples, posing the new opportunity, that it could be used like a database and queried for results, just like classical relational databases. Such databases can be implemented using a framework called Resource Description Framework (RDF) and are called *triplestore* or *RDF graph*. A resource can be any object of our intuition and these resources can be described using the syntax RDF offers. The vocabulary used to describe the resources, is specified or chosen by the users. Triplestores can be advantageous when the information collected is incomplete or might be enhanced later on. In contrast, any entry in a relational database needs to be consistent with the specified data model and applications making use of that data in turn expect consistency. By design, an application using triplestores must account for the absence of data.

The maximally flexible data model is what lead triplestores to become popular in the digital humanities. An initiative called FactGrid#footnote[https://factgrid.de] hosts a triplestore, specifically for historians, which make the data gained from their research public in this database. This poses the potential, that a user with knowledge of the specified vocabulary and conventions of the database, could get information about historical facts by writing an adequate query to the database. Furthermore, inferencing information about historical facts could be made a matter of, again, writing an adequate query.

== Problem
Making use of a triplestore in a broader audience poses the challenge, that the technicalities of the database are exposed to its user. To populate the database, the users have to attend to the conventions of the vocabulary and the database engineers. The formalisation is therefore being put into the hands of e.g. historians. Secondly, to adequately query a database, the user is forced to use the query language _SPARQL_, which requires technical knowledge.

#figure(caption: [The process of getting a result from an RDF triplestore.],
  image("methodology_pipeline_without_proposal.svg", width: 100%)
)

For example, a researcher might ask: 'What professions did members of societies dedicated to advancements in the natural sciences in Jena hold?' There are many ways to interpret this question: Are we looking for registered clubs, meaning a legal entity or does a regular's table in a pub count? What does the term profession refer to? Is it the current _occupation_ or the _trained_ profession? Secondly, before starting to write a SPARQL query, the next step is to 'pre-formalise' the question using the concise 'subject, predicate, object' syntax, which adequately captures its essence. This requires familiarity with the database's modeling conventions. For example, a researcher could query for entities classified as clubs and ensure that these entities are also associated with 'natural sciences' through the predicate 'interested in'. Alternatively, we could look for things which are related to 'Natural research association' through the predicate 'instance of'. Both options seem just, but in practice, one returns results and the other does not.

We want to reach a broader user base, than these hurdles would invite to participate.
One cannot expect the user to make these steps without extensive training, an understanding of how such things are usually modelled and extensive knowledge of the SPARQL language features. 

#figure(caption: [A possible SPARQL query to the professions of members of societies for natural sciences in Jena from the database FactGrid.],
```HTML
PREFIX fg: <https://database.factgrid.de/entity/>
PREFIX fgt: <https://database.factgrid.de/prop/direct/>
SELECT DISTINCT ?careerStatement WHERE {
     ?society fgt:P2 fg:Q266832 .
    # Variable -- [Ist ein(e)] -> Naturforschender Verein
     ?society fgt:P83 fg:Q10391 .
    # Variable -- [Ortsansässig in] -> Jena
     ?people fgt:P91 ?society .
    # Variable -- [Mitglied in] -> Variable
     ?people fgt:P165 ?careerStatement .
    # Variable -- [Karriere-Aussage] -> Variable
}
```
)

== Proposal
This work aims to lay the fundamentals for a program, which allows to build queries to an RDF triplestore using visual representation. The idea is, that since the _contents_ of the RDF triplestore can be _visualised as a graph_, _so could the query_ @Vargas2019_RDF_Explorer @Simons_Blog_Entry_Graphic_query. Instead of writing a query in the database's query language SPARQL, the user employs a visual query builder, which in turn generates the equivalent query.

Creating a Visual Query Graph is similar to sketching: the user outlines the desired database structure, adds variables for the required results, and focuses on visualising the database rather than syntax. The graph is then automatically converted into a SPARQL query that adheres to all technical requirements.

#figure(caption: [Methodology pipeline: How to get from a question in natural language to the result  in an RDF database.],
  image("methodology_pipeline.svg", width: 100%)
)

This work aims to closely integrate with the triplestore software suite called Wikibase#footnote[https://wikiba.se], which is widely adopted#footnote[e.g. Wikidata and FactGrid]. Wikibase offers many very useful constructs, which, by their nature, require some technicalities to be represented using the triple syntax, e.g. further specifications of a property (which in Wikibase are called qualifiers). This work demonstrates that, beyond the standard triple syntax, such complex constructs can be represented as intuitive structures and queried using a Visual Query Graph. To achieve this, it introduces the conventions of data modelling in Wikibase and explains their mapping to RDF syntax.

#figure(
  caption: [The visual query graph which generates the above posted query],
  image("screenshot_queybg_example.png", width: 100%)
)

Query by Graph cannot fully eliminate the need for users to learn the conventions of an RDF triplestore. For instance, determining which subjects are available and what to expect is entirely dependent on the database's users and engineers, as is the naming of properties. However, with the editor's search fields, users can quickly adjust the meanings of nodes and edges, creating a workflow that feels more intuitive and similar to sketching.


= Preliminaries
To define the tasks of Query by Graph, it is essential to discuss Wikibase's data modelling conventions, the formal definitions of Wikibase's special constructs, their mapping to the Resource Description Framework (RDF) and the syntax of SPARQL queries to the triplestore. The most commonly used SPARQL queries for retrieving information are SPARQL-SELECT queries, which are the primary focus of this work, with attention limited to a specific subset. SPARQL-SELECT function like stencils that describe a triple pattern, which is applied across an RDF graph until a matching pattern is found. For each match in the RDF graph, the corresponding variable assignments are returned as a result set. The idea is that the Visual Query Graph will represent the same pattern as the SPARQL-SELECT query, while complex constructs of RDF implementations, such as those used in Wikibase, will receive an intuitive representation within the Visual Query Graph.

== Data Model in Wikibase
*Wikibase* is one of the most widely used softwares for community knowledge bases, with the most prominent instance, *Wikidata*#footnote[http://wikidata.org --- an initiative for a free community knowledge base], storing \~115 million data items. Wikibase has its own internal structure and conventions for naming and modeling entities and concepts. These internals are in turn mapped to an expression in RDF syntax @wikibase_rdf_mapping_article. This invertible mapping permits the use of _RDF terminology to refer to structures within Wikibase_ and most notably _the use of the SPARQL query language for information retrieval_. This specific data model of Wikibase is particularly noteworthy due to its widespread use and substantial influence on other initiatives, driven by its sheer scale. For example, DBpedia will make use of Wikidata resources @Lehmann2015DBpediaA.

In Wikibase, a *thing* is referred to as an *item* and assigned a unique *Q-Number* within a Wikibase instance. Any *predicate* is called *property* and assigned a unique *P-Number*. A statement in Wikibase puts an item in relation to another item using a property.


#let lala2 = lalalalalala/2

#example[
  Suppose a user wants to enhance an entry in Wikidata for a person called "Johann Wolfgang von Goethe". Goethe is modeled as an item with the Q-number `Q5879` and wants to add the statement, that Goethe was "educated at" (P-number `P69`) the "University of Leipzig" (Q-number `Q154804`). Using the user interface, the user edits the entry for Goethe and fills the fields "property" and "object" with `P69` and `Q154804`.
  The triple representation in an RDF graph would be very similar:
  $
    "Johann Wolfgang von Goethe" &xarrow("educated at",width:lala2) "University of Leipzig", quad "or" \
    "Q5879" &xarrow("P69", width:lala2) "Q154804."
  $ <ex_spo_goethe>
]

Most real-world relationships might present to be more complex than something one would want to model in a single triple. For example, one may want to express that "Goethe" was educated at the "University of Leipzig" from 3 October 1765 to 28 August 1768. Wikibase represents it as a hierarchical structure, with "educated at" as the primary property and the others arranged beneath it. In the Wikibase context, a statement specifying another relationship is called a *qualifier*.

#figure(
  caption: [Presentation of an qualified relationship in the software Wikibase.],
  image("screenshot_wikidata.png", width: 320pt)
)<fig:qualifier_screenshot>

One possibility is to let relationships have more than two operands, i.e. increase the arity by one for each additional parameter. "Educated at" would then be called "educated at (#sym.dot) from (#sym.dot) to (#sym.dot)". Another way using the already existing RDF triple syntax is to create an implicit object, that assists in modelling the relationship using an *implicit* or *blank node* to describe a new concept; a human might be inclined to give it a name, e.g. "educated at for a certain time". 
The following triples exemplify such an implicit relationship, called a *qualified statement*:
$
  "Goethe" &longArrow("educated at") && "Uni Leipzig", \
  "Goethe" &longArrow("educated at") && "Implicit1", \
  "Implicit1" &longArrow("location") && "Uni Leipzig", \
  "Implicit1" &longArrow("started at") && 3.10.1765, #<ex_qualifier_1> \
  "Implicit1" &longArrow("ended at") && 28.08.1768.  #<ex_qualifier_2>
$ <ex:assertions_goethe_education>

#figure(image("Qualifier_ohne.svg", width: 320pt), caption: [Graphical visualisation of a qualified statement using natural language descriptors.]) <fig:vqg_no_qualifier>

Since qualifiers are widely used in most Wikibase instances, this work aims to develop a representation in the Visual Query Graph that enables their effective querying.

== Resource Description Framework
=== Internationalised Resource Identifier <heading:iri>

Internationalised Resource Identifiers (IRIs) [#link("https://www.ietf.org/rfc/rfc3987.txt")[RFC3987]] are a superset of Uniform Resource Identifiers (URIs) [#link("https://www.ietf.org/rfc/rfc3986.txt")[RFC3986]], for example `http://database.factgrid.de/entity/Q409`. Their purpose is to *refer to a resource*. The resource an IRI points at is called *referent*. 

The main advantage of IRIs over URIs are their enhanced character set. However, the details are not directly relevant to this work, therefore I will simply refer to the quoted RFCs for further reading.

<def:prefixes_and_bases>
RDF allows to define a *prefix*, which acts as an *abbreviation of an IRI*. For example, let `wd` be a prefix with the value `http://www.wikidata.org/entity/`. Then, the IRI `http://www.wikidata.org/entity/Q5879` can be rewritten using this prefix as `wd:Q5879`. The part after the colon is called *local name* and is essentially a string restricted to alphanumerical characters.

=== Literals <heading:literals>

The definitions in this section follow the *RDF v1.2* specifications @W3C_RDF_1.2_Proposal, which, at the time of writing, is a working draft. Again, the technical specifications are not directly relevant to the matters of this work, therefore I will abstract from the implementation details. 

#definition[
  A *literal* in an RDF graph can be used to express values such as strings, dates and numbers. It essentially consists of two elements:
  + a *lexical form*, which is a Unicode string,
  + a *data type IRI*, which defines the mapping from the lexical form to the literal value in the user representation. (also note the remark below this list)
] <def:literals>

=== Blank nodes
RDF specifies *blank nodes*, which do not have an IRI nor a literal assigned to them. The specification @W3C_RDF_1.1_Reference and the current version of its successor @W3C_RDF_1.2_Proposal do not comment on the structure of a blank node: "Otherwise, the set of possible blank nodes is arbitrary." @W3C_RDF_1.1_Reference.
It only specifies, that *the set of blank nodes is disjunct from all literals and IRIs*. In most common RDF formats, a blank node can be locally referenced using a *local name* and a special "empty" IRI-prefix often denoted by an underscore character.

/*=== Modelling Information using Triples

Suppose, that the assertion from @ex_spo_goethe is part of the A-box of an RDF database. It can be deducted that:
#todo[such statements are called entailments]:
- there is something called "Johann Wolfgang von Goethe",
- using the assumption that a different symbol implies a different object, there is something different from Goethe, called "University of Leipzig",
- there is a directed relation called "educated" at and
- of course the assertion itself, meaning that the relation applies between these two objects.

A computer still does not understand what it means to be educated at some place or where Leipzig is, but it can interact with this information in a formally correct way. The human operator can construe meaning, an interpretation grounded in the real world, in to the assertion. 

However, for any structured querying to be possible, the databases ought to be filled according to certain conventions. Preferably such conventions that are interoperable with other data sources (see @heading:lod).*/

=== RDF Graph and RDF Triple <heading:triples>

#definition[
  Let *$I$* denote the set of IRIs, *$B$* denote the set containing all blank nodes, *$L$* denote the set of literals, *$T := I union L union B$* the set of all RDF-Terms and for further use *$V$* the set of all variables. Let
  subject $bold("s") in bold("I") union bold("B")$,
  predicate $bold("p") in bold("I")$ and
  object $bold("o") in bold("T")$.

  Then, following @W3C_RDF_1.1_Reference, an *RDF triple* or simply a *triple*, takes the form:
  $
    (bold("s"), bold("p"), bold("o")).
  $
] <def:spo>

#definition[An *RDF graph* is a set of RDF triples. An RDF triple is said to be asserted in an RDF graph if it is an element of the RDF graph @W3C_RDF_1.2_Proposal.] <def:rdf_graph>

= Querying
== SPARQL Protocol and RDF Query Language <heading:sparql>

The acronym _SPARQL_ is recursive and stands for *S*\PARQL *P*\rotocol *A*\nd *R*\DF *Q*\uery *L*\anguage. It is considered to be a _graph based_ query language. This definitions in this section follow its currently recommended specification v1.1 @W3C_SPARQL_Specification.

This work focuses on a specific subset of SPARQL-SELECT queries, specifically those containing only triple patterns. SELECT queries can include additional components, such as value constraints, which restrict permissible variable assignments in the results. For instance, a constraint ensuring that an event occurred before 1900 would be expressed as `FILTER(?year < 1900)`.

#todo[richtig einfügen:]
Alternative query types include `ASK` (essentially a SELECT query that returns whether the result set is non-empty) and `DESCRIBE`, which returns an RDF graph describing a given resource (the actual result is implementation defined @W3C_SPARQL_Specification).

#remark[
The definitions of the following section are an excerpt from the _Formal Definition of the SPARQL query language_ @W3C_SPARQL_Formal_Definition. All relevant aspects of the formal definition are clarified in this work. Readers interested in further details are encouraged to consult the documentation directly.]

#definition[
  A *Basic Graph Pattern (BGP)* is a *subset* of SPARQL triple patterns
  $(T union V) times (I union V) times (T union V)$ @W3C_SPARQL_Formal_Definition.
]<def:bgp>

#definition[
  A *Graph Pattern* defines the pattern to be matched within an RDF graph. Most relevant to this work are *Basic Graph Patterns*. Additionally, `FILTER` statements are considered part of this category. Other types of graph patterns are detailed in the formal definition provided by @W3C_SPARQL_Formal_Definition.
]<def:graph_pattern>

#definition[
  A *SPARQL-SELECT query* is a special SPARQL query, which allows for 
]

#definition[
  A *SPARQL query* is defined as a tuple $(G P, D S, S M, R)$ where:
  $G P$ is a graph pattern,
  $D S$ is an RDF Dataset (essentially a set of RDF graphs),
  $S M$ is a set of solution modifiers and
  $R$ is a result form. A *SPARQL-SELECT query* is a SPARQL query, where $R$ is a _projection statement_. Furthermore, a SELECT query has requires a _projection variables_, which will be returned as results and a _selection-clause_ (indicated by the keyword `WHERE`), which contains Basic Graph Patterns @W3C_SPARQL_Formal_Definition.
]<def:sparql_query>

#remark[
  This implies, that a SPARQL query can query for a triple, which has a literal as its subject.
]

Writing SPARQL queries is pretty straight-forward: The wanted structure
is expressed in terms of the query language, and the unknown parts are replaced by variables. Say the user wants to know which universities Goethe went to. The matching query would look like @example:goethe_query. IRIs are enclosed within angle brackets.
#figure(caption: "A SPARQL query to determine which educational institutions Goethe visited.",
  ```HTML
  PREFIX wd: <http://www.wikidata.org/entity/>
  PREFIX wdt: <http://www.wikidata.org/prop/direct/>
  SELECT ?1 WHERE {
      wd:Q5879 wdt:P69 ?1 .
      # Johann Wolfgang von Goethe -- [educated at] -> Variable
  }
  ```
) <example:goethe_query>

The result set of a SPARQL query can either be a set of possible value combinations
#todo[Finish section]

== Mapping the Wikibase Data Model to RDF
As can be seen in @example:prefixes_in_wikidata, there are many prefixes apparently for the same things, namely *items* and *properties*. However, their use 
in Wikibase depends on the context. @fig:rdf_mapping shows how they come into play in the Wikibase data model. It is important to mention, that once an item 
or property is added to Wikibase, it is referencable using all of the prefixes of the data model. Using the concrete example of Wikidata, an item can be directly addressed using the prefix `wd` and a property directly accessed using `wdt`.

#todo[
  Ich sollte das Beispiel mit den Prefixes erläutern und auch warum ich es zeige. Das wird noch nicht klar.
  Ich erkläre kurz wie für die Implementation wd wdt pq relevant sind.
]


/*```turtle
 wd:P22 a wikibase:Property ;
     rdfs:label "Item property"@en ;
     wikibase:propertyType wikibase:WikibaseItem ;
     wikibase:directClaim wdt:P22 ;
     wikibase:claim p:P22 ;
     wikibase:statementProperty ps:P22 ;
     wikibase:statementValue psv:P22 ;
     wikibase:qualifier pq:P22 ;
     wikibase:qualifierValue pqv:P22 ;
     wikibase:reference pr:P22 ;
     wikibase:referenceValue prv:P22 ;
     wikibase:novalue wdno:P22 .
```*/

#figure(caption: [An excerpt of customary IRI prefixes defined by Wikidata.],
```HTML
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX pq: <http://www.wikidata.org/prop/qualifier/>
PREFIX pqv: <http://www.wikidata.org/prop/qualifier/value/>
PREFIX ps: <http://www.wikidata.org/prop/statement/>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wds: <http://www.wikidata.org/entity/statement/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wdv: <http://www.wikidata.org/value/>
```
) <example:prefixes_in_wikidata>


Often in Wikibase, the same local name is used in combination with different IRI prefixes to address different aspects of the same assertion. For further use in this work, I will define sets of prefixes and mappings to prepend a prefix to a local name.

#definition[
  Let $Sigma$ be a valid alphabet for local names and $Sigma^*$ its Kleene closure.
  Let
  $f_bold(p), f_bold(q), f_bold(s) in I$, then they are forthon used to describe _distinct_ IRI prefixes for so called *p*\roperties, *q*\ualifying properties and property *s*\tatements, in analogy to the Wikibase data model. 
] <def:prefix_formally>

#remark[
  May $f_x in I$, then any IRI $i in I$ with a prefix can be written as $i = f_x u$ and $u in Sigma^*$#footnote[Technically, a valid prefix could be written e.g. without a trailing slash. For the purposes of this work, I consider the basic concatenation to work like the concatenation algorithmm for URIs specified in #link("https://www.ietf.org/rfc/rfc3986.txt")[RFC3986], if necessary.].
]

#figure(caption: [Informal overview of Wikibase conventions for\ mapping information about an Item to the RDF standard @wikibase_rdf_mapping_graphic.],
  image("rdf_mapping.svg", width: 87%)
) <fig:rdf_mapping>

== Qualifiers <heading:qualifiers>
To query qualifiers using a Visual Query Graph, they must first be clearly defined. The term and concept "qualifier" are *not* used or specified in the RDF reference @W3C_RDF_1.1_Reference @W3C_RDF_1.2_Proposal. The definitions below follow the Wikibase conventions @wikibooks_sparql_qualifiers @wikidata_sparql_qualifiers, where the property and value of the *qualified edge\/assertion* are displayed hierarchically above the qualifiers, as seen in @fig:qualifier_screenshot. 
In this work, the term *qualifier* can be used in *three ways*: The *concept* of a qualifier, is that a relationship between items can be further specified using them. The now following definition refers to qualifiers, which can be *asserted in an RDF graph*. The third meaning is a qualifier in a *qualifiable Visual Query Graph*, which will be defined later on. 

In order to model and query a qualifier in an RDF database, distinct prefixes for statements and qualifiers are necessary. In SPARQL queries a variable is used to match a blank node, such as "Implicit1". Now, the Wikibase data model allows for many more constructs involving a blank node connected to an item. Furthermore, to correctly display the qualified edge and the qualifying edges, the property IRI prefixes ought to be discernable. In Wikibase, there is always a direct edge from the subject to the object using the `wdt:` prefix. First, this is necessary, should the database's user not want to query for a qualifier, but just for the "regular" assertion. Then, there are the constructing parts of the qualifier: the statement edge from the subject to the blank node using `p:`, the property statement edge from the blank node to the "main" assertion using `ps:` -- e.g. "educated at" in @ex:assertions_goethe_education -- and lastly the qualifier edges, using the `pq:` prefix. Using these prefixes, the data model allows to point at one and the same item, but from very different contexts. In order to handle qualifiers, they need to be formally defined.

/*#todo[move this somewhere where it makes sense]
The semantically similar assertions $(s,p,o)$ and $(b, p_s, o)$ are not erroneous, but an implementation detail of Wikibase to be able to differentiate the qualifiers from the qualified edge.
*/

#definition[
  Let $G$ be an RDF graph, $s in I$ be a specific subject,#sym.space.med
  $Q:= { f_bold(q) u | u in Sigma^*}, Q subset I$ a set of qualifier IRIs with $q_i in Q$,#sym.space.med
  $p := f_p u, u in Sigma^*$. Additionally, let $p_s$ and $p$ refer the same local name $u$ (or Wikibase property) using different prefixes $p_s := f_s u$. Lastly, let $o in L union I, o_j in O subset.eq L union I$ and $b in B$ a blank node. Then, a *qualified statement* in $G$ is defined as a set containing the triples
  $
      {(s, bold(p), b), (b,p_s,o)} union {(b, q_i, o_i) | i in NN}.
  $
  Statements such as $(b, q_i, o_i)$ are called *qualifiers* in $G$ and the triple $(s, f_t u, o)$ with $u in Sigma^*$ would be called *qualified edge* in the RDF graph $G$.
] <def:qualifiers>

#figure(
  caption: [A visualisation of a qualified statement with two qualifiers using the terms introduced in @def:qualifiers. The `wdt:` description is used in analogy to the Wikibase RDF data model figure. It is to be interpreted as an IRI with the instance-specific prefix `wdt` and a valid arbitrary local name.],
  image("Qualifier_abstract.svg")
)
#todo[Make sure, that this figure is on the same page as the definition above.]

// This method of describing information allows us to implicitly define new concepts. Any program dealing with qualifiers merely handles the explicit assertions for an anonymous concept. But, this anonymity poses a challenge to a human interpreter; implicit concepts usually remain unnamed (#todo[below (how does it work)]).


= Visual Query Graph
#definition[
  Following @Vargas2019_RDF_Explorer, a *visual query graph* (VQG) is defined as a directed, edge- and vertex-labelled graph $G=(N,E)$, with vertices/nodes $N$ and edges $E$. The nodes of $G$ are a finite set of IRIs, literals or variables: $N subset bold("I") union bold("L") union bold("V")$.
  The edges of the VQG are a finite set of triples, where each triple indicates a directed edge between two nodes with a label taken from the set of IRIs or variables: $E subset N times (bold("I") union bold("V")) times N$.
] <def:vqg>

A qualifier, as defined in @heading:qualifiers, would now be constructed as shown in @fig:vqg_no_qualifier.


#definition[
  Following @def:vqg, a *qualifiable visual query graph* (qVQG) is a directed, edge- and node-labelled graph $G_q=(N,E,E_q)$ with $N, E$ as defined above, $Q subset I$ the set of designated qualifier IRIs (see @def:qualifiers) and $E_q subset E times Q times N$.
] <def:qvqg>

#definition[
  A *qualifier* in the *qualifiable visual query graph* $G_q=(N,E,E_q)$ with $N, E, Q$ is a special directed, labelled edge $bold(e_q) in E_q$ as defined above and $bold(e_q) in E_q subset E times Q times N$. Let $e_q = (e, q, n)$ be a qualifier in $G_q$, then $e in E$ is called *qualified edge*, $q in Q$ is called *qualifying edge* and $n in N$ is called *qualifying value*.
] <def:qvqg-qualifier>

#todo[
  This is probably still unclear.
]

#let vql_ops = (
   [User Interaction],
    [Adding a variable node],
    [Adding a literal node],
    [Adding a directed edge],
    [*Adding a qualifier*]
)

Following @Vargas2019_RDF_Explorer, the qVQG is _constructed_ using the _qualifiable visual query language (qVQL)_, consisting of #{vql_ops.len()/2-1} algebraic operators, which will correspond to atomic user interactions of the VQG: adding a variable node, adding a literal node and adding a directed edge. In addition, I propose the actions of adding and removing an edge qualifier.

#figure(
  caption: "Operations in the VQL",
  table(columns: 1,
  ..vql_ops
  )
)

Using this new *qVQG* and qVQL, we can now create an intuitive visualisation (see @fig:vqg_with_qualifier) as motivated by @Simons_Blog_Entry_Graphic_query. Now, it needs to be shown, that the qVQG can be losslessly translated to a VQG and in turn to a SPARQL-SELECT query.

#figure(image("Qualifier_mit.svg"), caption: [Qualifiers in the qVQG]) <fig:vqg_with_qualifier>

== Mapping Visual Query Graphs to SPARQL queries <heading:mapping_theory>

#todo[Is the mapping invertible? Beweis ggf. durch Gegenbeispiel.]

The goal of this section is to define a mapping from VQGs to SPARQL-SELECT queries. Much of the SPARQL query language's expressability is covered by BGPs. Further components, such as value constraints with the keyword `FILTER` could possibly also be visualised in the VQG, but are currently not defined. First, the goal is to show, that a VQG and qVQG can be converted to BGPs and the second step is to show how a SPARQL-SELECT query can be constructed from this.

#definition[
  Let $E':= (I union L union V) times (I union V) times (I union L union V)$ be the set of all possible edges in a VQG. Let Y be the set of all possible triples $Y:=(T union V) times (I union V) times (T union V)$ (a finite subset of which is a BGP). A BGP is now constructed using the mapping
  $
    f: E' &-> Y, \
    (s, p, o) &arrow.bar (s, p, o).
  $
  For the mapping to be accurate, $E$ needs to be a subset or equal to $X$. Since both VQGs and BGPs allow variables at any position in the triple, it now only needs to be shown, that for $T: = I union L union B$ it holds true that $I union L subset.eq T$, which is trivially true from the definition of $T$.
]


In order to convert a SPARQL SELECT-query to a VQG, this translation needs to be invertible. Since a valid query can have blank node specifiers for subjects and objects, but the VQG is defined without blank nodes, some replacement needs to be found. The SPARQL specification#footnote[in section 4.1.4 Syntax for Blank Nodes] however concludes, that a blank node can be written as a variable in a query @W3C_SPARQL_Specification. Therefore, in order to create a VQG from a BGP, the mapping is inverted and for any blank node a variable is inserted. If a blank node occurs multiple times in a query, the same variable will be used for all occurences.

#todo[Sollte ich das noch einmal lemmatisieren und beweisen?]

Using the above lemma, a VQG can already construct a qualifier. The blank node can be replaced by a variable and the only other obligation is to use the correct prefixes.

#lemma[
  Let again $E':= (I union L union V) times (I union V) times (I union L union V)$ be the set of all possible edges in a VQG. Let $E'_q := E times Q times N$ be the set of all possible qualifier edges with elements of the form $(e_q, q, n)$. Let $E$ be the set of valid edges in a VQG with elements of the form $(s_e, p_e, o_e)$. Let $v in V$ be a unique variable for each triple in $E_q$ and $w in Sigma^*$. Qualifiers can now be converted to valid VQG triples using the mapping
  $
    g: E_q &-> E', \
    ((s_e, (f_t p_e), o_e), q, n) & arrow.bar {(s_e, f_p p_e, v), (v, f_s p_e, o_e), (b, q, n)}
  $
]
#todo[Ist es in Ordnung das so aufzuschreiben? Vielleicht "hash"funktion für Variablenbezeichner abhängig von qualified edge.]

#proof[
  Poof! #emoji.explosion
  #todo[
    Mehrere unterschiedliche Variablen zu verwenden ist in Ordnung, weil das bei einer Abfrage keine Rolle spielt. Die unterschiedlichen Variablen würden auf die gleichen Strukturen im RDF graph matchen. Es wäre allerdings schön, dass man die Variablen wiederverwenden kann, wenn es sich auf die gleiche qualified edge bezieht. Ich könnte eine "Hash"funktion definieren, die die qualified edge auf eine Variablenbezeichnung abbildet.
  ]
]

#todo[Ist die Abbildung invertierbar?]

= Implementation <heading:implementation>

#todo[
Should contain the following aspects:
- describe the developed system/algorithm/method from a high-level point of view
]

#todo[
  My work also has the advantage, that all conventions are regulated in a configuration file specifically for data sources. A user (in the future) can add
  new conventions at a central place and will know, which effects changes have. 
]

The goal of this work is to create two mostly separate programs:
+ the _visual query building interface_ (forthon called *frontend*) and
+ the _translator between VGQ and SPARQL_ (forthon called *backend*).

The most important aspects for the choice of software and UX design were usability and maintability. The aim is to lay the basis for a software, which can be applied in day-to-day use as an "almost-no-code" query builder. The development of Query by Graph will be continued in the project _HisQu_ by the #link("https://www.mephisto.uni-jena.de/")[MEPHisto group] funded by #link("https://4memory.de")[NFDI4Memory]. Therefore, this work's focus lay on building an extensible, future-proof platform, rather than implementing every thought-of feature.



#todo[probably remove the following paragraph]
The step of formalising a natural-language question into a SPARQL query seems simple, however the first challenge arises in finding the correct entities for the query --- let alone the formalisation of the question itself. For example, the question `Find all Nobel prize winners with a student who won the same Nobel prize` (taken from @Vargas2019_RDF_Explorer) is not as simple to model as it would seem at first glance. In Wikidata, three properties are suggested for the search term "student": `wdt:P802 "student"`, `wdt:P1066 "student of"` and `wdt:P69 "educated at"`. In some cases the specific property does not matter. Wikibase instances have the disadvantage, that because they commonly lack an extensive ontology, data consistency varies. The user should be offered an abstraction layer, e.g. to assign a set of properties to an edge in the VQG or to generate the query using a _partial_ ontology. It is cumbersome to the user to remember every conventions, especially, when they could be automatically enforced using a partially defined ontology.

#figure(
  caption: [SPARQL query: Find all Nobel prize winners with a student who won the same Nobel prize. @Vargas2019_RDF_Explorer],
```HTML
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT ?prize ?student ?winner WHERE {
     ?winner wdt:P166 ?prize .
    # Variable -- [award received] -> Variable     ?student wdt:P802 ?winner .
    # Variable -- [student] -> Variable
     ?student wdt:P166 ?prize .
    # Variable -- [award received] -> Variable
     ?prize wdt:P31 wd:Q7191 .
    # Variable -- [instance of] -> Nobel Prize
}
```
)

#remark[Though the query copied from @Vargas2019_RDF_Explorer seems to be correct, it yields an empty result. There are two items which are `instance of` `Nobel prize`, however, neither are a Nobel prize.]

#todo[Wie formuliere ich hier freundlich, dass obwohl ein Werkzeug verwendet wurde das die möglichen Ergebnisse einer Abfrage im Voraus anzeigt, die produzierte Abfrage trotzdem keine Ergebnisse liefert, der Sinn und die Nutzbarkeit des Tools also fragwürdig scheint.]


== Architecture
Since SPARQL is mostly used in the context of a web browser, the choice for a web app seemed obvious. The backend was designed to be explainable and traceable. For this, there are several good choices, especially functional programming language, but since Rust#footnote[http://www.rust-lang.org] can be compiled to Web Assembly#footnote[http://webassembly.org] and therefore executed natively in a browser, the choice fell well in its favour over a server-client architecture. This combination of architectures proves to be extendable, quick and still formally precise.

#todo[Mention, that I am limited to two prefixes, wdt and wd. Also mention, that there is a configuration file, which contains all Wikibase data sources. ]

The *frontend* was written using the libraries Vite, Vue3, ReteJS and TailwindCSS (all licensed under MIT license). Its purpose is to allow the user to
+ build a VQG, and edit it from the SPARQL code editor,
+ searching for items and properties in arbitrary Wikibase instances,
+ display meta-information on items and properties,
+ configure Wikibase data sources and
+ handle all data source specific tasks (such as enriching entities with information from a Wikibase instance).

The *Wikibase data sources* are configured by the user and stored in the browser's local storage. Following the conventions of Wikibase, the choice was made to only allow one prefix for items and one for properties. The program assumes, that the item prefixes point directly to the item, e.g. `wd` for Wikidata, and the property prefixes to the property value, e.g. `wdt` (for reference on the data model see @fig:rdf_mapping). This assumption is based on the premise that users writing queries involving more than this level of abstraction, typically have a deeper understanding of the underlying mechanics and are likely capable of composing an adequate SPARQL query.

The *backend's* purpose is to handle the algebraic parts of the mapping between SPARQL queries and VQGs. 

To ensure compatibility between the backend and frontend, both use the same type definitions. They are exchanged using JSON serialisation and deserialisation.
An entity is considered to have the properties shown in the listing below. #todo[change the reference, if the bug is fixed or I rendered it externally.] 

#figure(caption: [Key Data Types for the translation between VQG and SPARQL.],
```pintora
classDiagram
  class PREFIX {
    string iri
    string abbreviation
  }
  class WIKIBASEDATASOURCE {
    string name
    PREFIX propertyPrefix
    PREFIX itemPrefix
    string[] preferredLanguages
  }
  class ITEM {}
  class PROPERTY {}
  class ENTITY {
    string id
    string label
    PREFIX prefix
    WIKIBASEDATASOURCE dataSource
  }
  ENTITY <|-- ITEM
  ENTITY <|-- PROPERTY
  
  class CONNECTION {
    PROPERTY property
    ITEM source
    ITEM target
  }
  PREFIX "1" o-- "*" ENTITY
  PREFIX "2" o-- "*" WIKIBASEDATASOURCE

  ENTITY "*" --o "1" WIKIBASEDATASOURCE
  
  CONNECTION "2" o-- "*" ITEM
  CONNECTION "1" o-- "*" PROPERTY
```
)

#figure(caption: [Restructured data types for qVQGs.],
```pintora
classDiagram
  class WIKIBASEDATASOURCE {
    string name
    PREFIX propertyPrefix
    PREFIX itemPrefix
    PREFIX qualifierPrefix
  }
  class ITEM {}
  class PROPERTY {}
  class QUALIFIER {
    PROPERTY property
    ITEM target
  }
  class ENTITY {
    string id
    string label
    PREFIX prefix
    WIKIBASEDATASOURCE dataSource
    QUALIFIER[] qualifiers?
  }
  ENTITY "*" --o "1" WIKIBASEDATASOURCE
  ENTITY <|-- ITEM
  ENTITY <|-- PROPERTY
  PROPERTY "1" *-- "*" QUALIFIER
  ITEM "1" *-- "*" QUALIFIER
```
)

#todo[
- mention which tools I used (spargebra)
- and how the algorithm comes to its results

The pipeline from VQG to SPARQL query and vice versa needs to be made clear:
- especially comment on optimisations, like when something is semantically equal i do not redraw the VQG
- when is something semantically equal?
]


#figure(
  caption: [An overview of all features currently implemented.\ #text(size:.8em)["#sym.checkmark" means implemented and tested, "(#sym.checkmark)" means implemented but not bug-free and "#sym.crossmark" means not implemented. A full feature list can be found in the technical documentation of the repository.]],
  table(columns: 2,
    [Feature], [Status],
    [Drawing a VQG with variables and literals], [#sym.checkmark],
    [Searching for entities on multiple Wikibase instances], [#sym.checkmark],
    [Creating SPARQL-SELECT queries from a VQG], [#sym.checkmark],
    [Code editor for SPARQL queries], [#sym.checkmark],
    [Applying changes in the code editor to the VQG], [(#sym.checkmark)],
    [Enriching unseen entities with metadata from the Wikibase API], [(#sym.checkmark)],
    [Literals with standard RDF data types (string, int, date, ...)], [(#sym.checkmark)],
    [Use multiple Wikibase instances as data sources], [#sym.checkmark],
    [Meta-Info Panel], [#sym.checkmark],
    [Rendering qualifiers with the proposed visualisation], [#sym.crossmark]
  )
)

== Visual Query Graph-SPARQL Mapping Algorithm

For technical reasons

The mapping is done according to the proofs in @heading:mapping_theory. The VQG is exported in the form of an edge list from the frontend to the backend. The elements of the edge list are triples, corresponding to BGPs, and each entry of the triple is a literal, variable or IRI --- or to use Wikibase terminology, an entity. The BGPs in turn are mapped to a SPARQL-SELECT query with all variables from the VQG added to the projection. #todo[Check if this is still the case when I am finished with the qualifier feature, or whether I leave out the blank-node-placeholder variables.]



#todo[define what a SPARQL select query is]

Novel to current work @Vargas2019_RDF_Explorer @Vargas2020_UI_for_Exploring_KGs, _the generated query is displayed instantaneously_ below the visual query builder, thanks to the speed of the backend. 

=== SPARQL to VQG
The backend makes use of a SPARQL parser package called `spargebra`. Currently, only the mapping from SPARQL-Select-queries with BGPs is defined without loss in the implementation. Any language feature which is not implemented will be ignored, e.g. the SPARQL keywords like `FILTER` are ignored. The used parser package, however, has definitions for most#footnote[Here, I must say I did not notice an important language feature which is not implemented, however, there is no statement by the makers which asserts this statement.] of the SPARQL language features. These features can be very easily added in future versions, thanks to the program's modular design. 

Novel to current work:
+ Qualifiers are visualised more intuitively (see Simons Blog @Simons_Blog_Entry_Graphic_query)
+ Multiple data sources and clear prefixes #todo[Check, whether this is actually new]
+ ... more?

#todo[
  Explain which shortcomings in addition to the theoretical ones this makes. (If there are any)
]

#todo[
  Mention the reason for use of wdt prefix (https://www.mediawiki.org/wiki/Wikibase/Indexing/RDF_Dump_Format#Truthy_statements)
]


#todo[
  Explore the expression capabilities of my tool. Can it write an arbitrary SPARQL query?
]

#todo[
  Does Wikibase really only use one property and item prefix when it returns from this query?
  This has the very big limitation, that if a user uses a different prefix, that it does not work.
  Maybe I should comment on this from a user perspective, as in: "a standard user will not write a query so complex, that it cannot do this".
  ```javascript
  export interface WikibaseDataSource {
    name: string;
    url: string,
    preferredLanguages: string[],
    propertyPrefix: {
        iri: string,
        abbreviation: string
    },
    itemPrefix: {
        iri: string,
        abbreviation: string
    },
    queryService: string,
}
  ```
]

#todo[
  Write the missing capabilities:
  - I cannot write SPARQL local names
  - no Filters
  - ...
]

#todo[
  How could I implement something like the same-time highlighting of code and node in the graph?
  - instead of deleting the node, I simply look for equivalents and change the class properties
  - i calculate the steps of algebraic operations necessary to build the graph
]


#todo[
  For the convertConnectionsToPrefixedRepresentation to work,
  the item and property prefixes must be prefix-free (one may not be prefix of the other).
]

#todo[
- whatever you have done, you must comment it, compare it to other systems, evaluate it
- usually, adequate graphs help to show the benefits of your approach
- caution: each result/graph must be discussed! what’s the reason for this peak or why have you observed this effect
]

== Practical Application
- Patrick Stahl developed for Clemens Beck
- Changes / contributions by patrick are clearly marked in Version Control

= Discussion
- Enthält alles was nicht erfüllt wurde
- und vergleicht zu anderen Arbeiten


= Further Work <heading:further_work>

+ Creating/Manipulating RDF assertions (INSERT and UPDATE statements)

+ Many language features of SPARQL:
  - FILTER
  - JOIN
  - Aggregate
  - SUBSTR
  - ...
  - "\[AUTO\_LANGUAGE\],de"

+ Implementing the OWL integration within Query by Graph

+ If an entity in the SPARQL query is selected, also highlight in the retejs editor

+ If the query is changed, try to not move the nodes, but reuse their position.
  - this would involve rewriting the importConnections

+ Formulating queries from natural language using Large Language Models

```XML
xsd:integer
xsd:decimal
xsd:float
xsd:double
xsd:string
xsd:boolean
xsd:dateTime
```

- "what are possible relations between a variable and an item" und man gibt noch mit was man modellieren will

- use describe queries to illustrate rdf graph structures (https://www.w3.org/TR/sparql11-query/#describe)

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
