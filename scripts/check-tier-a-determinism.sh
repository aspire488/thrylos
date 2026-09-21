#!/usr/bin/env bash
set -euo pipefail

# Tier-A crates must remain free of floating-point types. Consensus-critical
# code must produce identical results across supported platforms; float
# arithmetic can vary with compiler/target semantics.
tier_a=(
  crates/types
  crates/state
  crates/exec
  crates/modules
  crates/consensus
  crates/engine-api
  crates/signer
)

matches="$(
  rg -n --glob '*.rs' '\b(f32|f64)\b' "${tier_a[@]}" || true
)"

if [[ -n "$matches" ]]; then
  echo "Floating-point types are forbidden in Tier-A Rust sources:"
  echo "$matches"
  exit 1
fi

echo "Tier-A determinism check passed: no f32/f64 types found."
