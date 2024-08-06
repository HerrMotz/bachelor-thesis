mod utils;

use wasm_bindgen::prelude::*;
use serde_json::from_str;
use serde::Deserialize;
use crate::utils::set_panic_hook;

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
struct Property {
    pub id: String,
    pub label: String,
}

#[derive(Deserialize)]
struct Connection {
    pub property: Property,
    pub source: String,
    pub target: String,
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
    let mut sparql = String::from("PREFIX : <http://example.org/>\n");
    sparql.push_str("SELECT * WHERE {\n");

    for connection in connections {
        sparql.push_str(&format!(
            "wd:{} wdt:{} wd:{} . // {} {}\n",
            connection.source, connection.property.id, connection.target,
            connection.property.id, connection.property.label
        ));
    }

    sparql.push_str("}");

    sparql
}