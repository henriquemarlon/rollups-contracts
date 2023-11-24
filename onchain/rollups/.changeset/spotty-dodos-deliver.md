---
"@cartesi/rollups": minor
---

Added `EpochHashStorage` contract.
This contract was designed to be inherited by implementations of the `IConsensus` interface for simple storage and retrieval of epoch hashes.
It defines two internal functions, `_getEpochHash` and `_setEpochHash`, to be called by contracts that inherit from it.
