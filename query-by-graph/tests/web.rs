//! Test suite for the Web and headless browsers.

#![cfg(target_arch = "wasm32")]

extern crate wasm_bindgen_test;
use wasm_bindgen_test::*;
use query_by_graph::graph_to_query_wasm;

wasm_bindgen_test_configure!(run_in_browser);

#[wasm_bindgen_test]
fn test_empty_query() {
    assert_eq!(graph_to_query_wasm("[]"), "");
}
