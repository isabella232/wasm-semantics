#!/usr/bin/env python3

import wasm2kast
import pyk
import sys

WASM_definition_llvm_no_coverage_dir = '.build/defn/llvm'

def config_to_kast_term(config):
    return { 'format' : 'KAST', 'version': 1, 'term': config }

def run_module(parsed_module):
    input_json = config_to_kast_term(parsed_module)
    krun_args = [ '--term', '--debug']
    (rc, new_wasm_config, err) = pyk.krunJSON(WASM_definition_llvm_no_coverage_dir, input_json, krunArgs = krun_args, teeOutput=True)
    if rc != 0:
        raise Exception("Received error while running: " + err )

sys.setrecursionlimit(1500000000)

if __name__ == "__main__":
    module = wasm2kast.main()
    run_module(module)