---
"@cartesi/rollups": major
---

Move the definition of the `OutputValidityProof` structure to its own file.
This change was made to avoid coupling this structure with the `LibOutputValidation` library.
Contracts that imported this structure from `contracts/library/LibOutputValidation.sol` must now import it from `contracts/common/OutputValidityProof.sol`.
