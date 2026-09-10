/-
Copyright 2026 The Capacity Atlas Authors
Licensed under the Apache License, Version 2.0 (the "License").
See the License for the specific language governing permissions and limitations.
-/

import CapacityAtlasCost
import Lean.Meta
import Lean.Util.CollectAxioms

open Lean Meta

private def checkProofs : CoreM (Array String × Nat) := do
  let env ← getEnv
  let mut errors := #[]
  let mut count := 0
  for (name, _) in env.constants.toList do
    let some index := env.getModuleIdxFor? name | continue
    let moduleName := env.header.moduleNames[index]!
    unless moduleName == `CapacityAtlasCost || (`CapacityAtlasCost).isPrefixOf moduleName do
      continue
    count := count + 1
    let axioms ← Lean.collectAxioms name
    let unexpected := axioms.filter fun axiomName ↦
      !(#[``propext, ``Quot.sound, ``Classical.choice]).contains axiomName
    unless unexpected.isEmpty do
      errors := errors.push s!"{name}: unexpected axioms {unexpected.toList}"
  if count == 0 then errors := errors.push "No proof declarations were loaded"
  let certificateName := `CapacityAtlasCost.finiteDMCInputCostCapacity
  let statementName := `CapacityAtlas.FiniteChannel.finiteDMCInputCostCapacityStatement
  if !env.contains certificateName then
    errors := errors.push "The registered certificate is missing"
  else if !env.contains statementName then
    errors := errors.push "The canonical Atlas statement is missing"
  else
    let typesMatch ← MetaM.run' do
      let certificateType ← inferType (← mkConstWithFreshMVarLevels certificateName)
      let statementType ← inferType (← mkConstWithFreshMVarLevels statementName)
      isDefEq certificateType statementType
    unless typesMatch do
      errors := errors.push "The certificate type does not match the canonical Atlas statement"
  return (errors, count)

def main : IO UInt32 := do
  unsafe Lean.enableInitializersExecution
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := `CapacityAtlasCost }] {} (loadExts := true)
  let context : Core.Context := { fileName := "", fileMap := default }
  let state : Core.State := { env }
  let ((errors, count), _) ← (checkProofs).toIO context state
  for error in errors do IO.eprintln error
  IO.println s!"Audited {count} declarations; {errors.size} errors"
  return if errors.isEmpty then 0 else 1
