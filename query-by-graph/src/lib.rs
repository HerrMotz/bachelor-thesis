mod utils;

use std::collections::HashSet;
use wasm_bindgen::prelude::*;
use serde_json::from_str;
use serde::Deserialize;
use crate::utils::set_panic_hook;

const INDENTATION_COUNT:usize = 4;

#[derive(Deserialize)]
struct Entity {
    pub id: String,
    pub label: String,
    pub description: String,
    pub prefix: Prefix
}

#[derive(Deserialize)]
struct Prefix {
    uri: String,
    abbreviation: String
}

#[derive(Deserialize)]
struct Connection {
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
        .join(" ")};


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
                "{} {} {} {} . # {} -- [{}] -> {}\n",
                " ".repeat(INDENTATION_COUNT),
                source_uri,
                property_uri,
                target_uri,
                connection.source.label,
                connection.property.label,
                connection.target.label
            )
        })
        .collect();

    format!(
        "SELECT {} WHERE {{\n{}\n}}",
        projection_list, where_clause
    )
}
