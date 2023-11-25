---
"@cartesi/rollups": major
---

Refactored the `IConsensus` interface for better interaction with the Cartesi Rollups node.
Updated the `AbstractConsensus` contract to partially implement the `IConsensus` interface (only the `getEpochHash` function).
Removed the `bytes context` field from the `Proof` structure and added an `InputRange inputRange` field.
Contracts that implemented the old `IConsensus` and wish to implement the new one must be adapted (see the new interface).
Contracts that inherited from `AbstractConsensus` must now implement the new `IConsensus` interface except for the `getEpochHash` function (which is implemented by `AbstractConsensus`).
Components that would call the `getClaim` function must now call the `getEpochHash` function, while passing the desired input range as parameter instead of returning it.
Components that would call the `join` function should not call it anymore, as it is no longer declared in the new interface.
Components that would listen to the `ApplicationJoined` event should not listen to it anymore, as it is no longer declared in the new interface.
