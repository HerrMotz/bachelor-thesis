mod utils;

use std::collections::HashSet;
use wasm_bindgen::prelude::*;
use serde_json::from_str;
use serde::Deserialize;
use crate::utils::set_panic_hook;

const INDENTATION_COUNT:usize = 4;

#[wasm_bindgen]
extern "C" {
    fn alert(s: &str);
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("Hello dear, {}!", name)
}

#[derive(Deserialize)]
struct Entity {
    pub id: String,
    pub label: String,
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

    let projection_list = connections.iter()
        .flat_map(|connection| {
            vec![&connection.source, &connection.target, &connection.property]
        })
        .filter(|entity| entity.id.starts_with('?'))
        .map(|entity| entity.id.clone())
        .collect::<HashSet<_>>()
        .into_iter()
        .collect::<Vec<_>>()
        .join(", ");

    let where_clause: String = connections.iter()
        .map(|connection| {
            format!(
                "{}wd:{} wdt:{} wd:{} . # {} -- {} -> {}\n",
                " ".repeat(INDENTATION_COUNT),
                connection.source.id, connection.property.id, connection.target.id,
                connection.source.label, connection.property.label, connection.target.label
            )
        })
        .collect();

    format!(
        "PREFIX : <http://example.org/>\nSELECT {} WHERE {{\n{}\n}}",
        projection_list, where_clause
    )
}
