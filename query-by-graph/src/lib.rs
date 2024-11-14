mod utils;

use std::collections::HashSet;
use wasm_bindgen::prelude::*;
use serde_json::from_str;
use serde::{Deserialize, Serialize};
use crate::utils::set_panic_hook;
use spargebra::{Query, SparqlSyntaxError};
use spargebra::algebra::GraphPattern;
use spargebra::term::{TriplePattern};

const INDENTATION_COUNT: usize = 4;

#[derive(Serialize, Deserialize)]
pub struct Entity {
    pub id: String,
    pub label: String,
    pub description: String,
    pub prefix: Prefix,
}

#[derive(Serialize, Deserialize)]
pub struct Prefix {
    uri: String,
    abbreviation: String,
}

#[derive(Serialize, Deserialize)]
pub struct Connection {
    pub property: Entity,
    pub source: Entity,
    pub target: Entity,
}

// wasm method, to get a string containing a JSON, which converts it to Connection
// structs and then calls graph_to_query
#[wasm_bindgen]
pub fn graph_to_query_wasm(json: &str) -> String {
    // for better errors logging in the web browser
    set_panic_hook();

    let connections: Vec<Connection> = from_str(json).unwrap();
    graph_to_query(connections)
}

fn graph_to_query(connections: Vec<Connection>) -> String {
    let projection_set = connections.iter()
        .flat_map(|connection| {
            vec![&connection.source, &connection.target, &connection.property]
        })
        .filter(|entity| entity.id.starts_with('?'))
        .map(|entity| entity.id.clone())
        .collect::<HashSet<_>>();

    let projection_list = if projection_set.len() == 0 { String::from("*") } else {
        projection_set.into_iter()
            .collect::<Vec<_>>()
            .join(" ")
    };


    let where_clause: String = connections.iter()
        .map(|connection| {
            let source_uri = if connection.source.prefix.uri.is_empty() {
                connection.source.id.clone() // Clone the String to avoid moving it
            } else {
                format!("<{}>", connection.source.prefix.uri)
            };

            let property_uri = if connection.property.prefix.uri.is_empty() {
                connection.property.id.clone() // Clone the String to avoid moving it
            } else {
                format!("<{}>", connection.property.prefix.uri)
            };

            let target_uri = if connection.target.prefix.uri.is_empty() {
                connection.target.id.clone() // Clone the String to avoid moving it
            } else {
                format!("<{}>", connection.target.prefix.uri)
            };

            format!(
                "{}# {} -- [{}] -> {}\n{}{} {} {} .\n ",
                " ".repeat(INDENTATION_COUNT),
                connection.source.label,
                connection.property.label,
                connection.target.label,
                " ".repeat(INDENTATION_COUNT),
                source_uri,
                property_uri,
                target_uri,
            )
        })
        .collect();

    format!(
        "SELECT {} WHERE {{\n{}\n}}",
        projection_list, where_clause
    )
}

fn parse_query(query: &str) -> Result<Query, SparqlSyntaxError> {
    Query::parse(query, None)
}

pub fn bgp_to_graph(bgp: Vec<TriplePattern>) -> Vec<Connection> {
    bgp.iter().map(
        |pattern| {
            Connection {
                property: Entity {
                    id: pattern.predicate.to_string(),
                    label: "Variable".to_string(),
                    description: "".to_string(),
                    prefix: Prefix {
                        uri: "".to_string(),
                        abbreviation: "".to_string(),
                    },
                },
                source: Entity {
                    id: pattern.subject.to_string(),
                    label: pattern.subject.to_string(),
                    description: "".to_string(),
                    prefix: Prefix {
                        uri: "".to_string(),
                        abbreviation: "".to_string(),
                    },
                },
                target: Entity {
                    id: pattern.object.to_string(),
                    label: pattern.object.to_string(),
                    description: "".to_string(),
                    prefix: Prefix {
                        uri: "".to_string(),
                        abbreviation: "".to_string(),
                    },
                },
            }
        }
    ).collect()
}

#[wasm_bindgen]
pub fn query_to_graph_wasm(query: &str) -> Vec<Connection> {
    // for better errors logging in the web browser
    set_panic_hook();

    query_to_graph_wasm(query)
}

/// We get a query, can be a SELECT query or something else.
/// A SELECT statement consist of a:
/// - dataset
/// - graph pattern
/// - base IRI (optional)
///
/// The "graph pattern" is equivalent to a SPARQL Basic Graph Pattern (BGP)
fn query_to_graph(query: &str) -> Vec<Connection> {
    let parsed_query = parse_query(query);

    // Match on the query type.
    match parsed_query {
        Ok(Query::Select { pattern: p, .. }) => match p {
            GraphPattern::Bgp { patterns: bgp } => bgp_to_graph(bgp),
            GraphPattern::Path { .. } => vec![default_connection()],
            _ => vec![default_connection()]
        },
        _ => vec![default_connection()],
    }
}

// Helper function to generate a default `Connection` object.
fn default_connection() -> Connection {
    Connection {
        property: Entity {
            id: "".to_string(),
            label: "".to_string(),
            description: "".to_string(),
            prefix: Prefix {
                uri: "".to_string(),
                abbreviation: "".to_string(),
            },
        },
        source: Entity {
            id: "".to_string(),
            label: "".to_string(),
            description: "".to_string(),
            prefix: Prefix {
                uri: "".to_string(),
                abbreviation: "".to_string(),
            },
        },
        target: Entity {
            id: "".to_string(),
            label: "".to_string(),
            description: "".to_string(),
            prefix: Prefix {
                uri: "".to_string(),
                abbreviation: "".to_string(),
            },
        },
    }
}


#[cfg(test)]
mod tests {
    use serde_json::to_string;
    use super::*;
    #[test]
    fn graph_to_query_works() {
        query_to_graph("SELECT ?3 WHERE { <http://www.wikidata.org/entity/Q5879> ?3 <http://www.wikidata.org/entity/Q152838> .}");
    }

    #[test]
    fn serialize_graph() {
        let graph = query_to_graph("SELECT ?3 WHERE { <http://www.wikidata.org/entity/Q5879> ?3 <http://www.wikidata.org/entity/Q152838> .}");
        print!("{:?}", to_string(&graph).unwrap())
    }
}
