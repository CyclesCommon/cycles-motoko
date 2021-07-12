# Common Cycles Interface for Motoko Canisters

Source code [src/Cycles.mo] is a modified version of the [ExperimentalCycles.mo] module from the Motoko base library:

1. Add the *Request*, *Response*, and *Transfer* types as in the [Cycles Common Specification].
2. Change the common cycles operation to use *Nat64* instead of *Nat* for cycles.

Please read the [Cycles Common Specification] proposal for more details.

Examples are provided in the [examples/](../tree/main/examples/) sub-directory.

[Cycles Common Specification]: https://github.com/CyclesCommon/initiative/pull/1
[src/Cycles.mo]: https://github.com/CyclesCommon/cycles-motoko/blob/main/src/Cycles.mo
[ExperimentalCycles.mo]: https://github.com/dfinity/motoko-base/blob/main/src/ExperimentalCycles.mo
