# Finite DMC capacity under an input-cost constraint

Lean certificate for Capacity Atlas problem `finite-dmc-input-cost`, claim `exact-capacity`, version 1. The operational model requires a cost bound on every deterministic codeword, uniform messages, vanishing average error, and codes at every sufficiently large blocklength.

The proof combines finite-mixture concavity and Fano's inequality with random coding whose inadmissible codewords are replaced by a fixed feasible word. The added error tends to zero by a cost second-moment bound. At a minimum feasible budget, admissible input laws are supported on minimum-cost symbols; the proof handles this endpoint separately. Mixing with a strictly cheaper symbol handles boundary input distributions when such a symbol exists.

Run `lake --wfail build` and `lake exe capacity_cost_audit`. The audit checks every declaration in the proof modules and permits only Lean's standard axioms `propext`, `Quot.sound`, and `Classical.choice`. It rejects any transitive dependence on the admitted Atlas claim.

The Atlas dependency is pinned in `lakefile.toml` and `capacity-atlas-proof.yaml`. The final certificate proves the canonical proposition directly; it does not use the registered statement as a premise.

Mathematical references:

- Sutter, Sutter, Mohajerin Esfahani and Lygeros, [Efficient Approximation of Channel Capacities](https://arxiv.org/abs/1407.7629), IEEE Transactions on Information Theory 61(4), 1649–1666, 2015, equation (2).
- Kostina and Verdú, [Channels with cost constraints: strong converse and dispersion](https://arxiv.org/abs/1401.5124), IEEE Transactions on Information Theory 61(5), 2415–2429, 2015, Definition 2 and equation (25). This source explicitly distinguishes the maximum codeword constraint from a constraint averaged over messages.

Code is Apache-2.0. This development was assisted by Codex (GPT-6); mathematical statement faithfulness and source attribution require human review.
