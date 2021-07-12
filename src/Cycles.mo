import Nat64 "mo:base/Nat64";
import Cycles "mo:base/ExperimentalCycles";
import Prim "mo:⛔";

module {

  public type Cycles = Nat64;

  /// Cycles transfer request contains optional data that is passed to the 
  /// `cycles_transfer` method. Note that it entirely depends on the callee's 
  /// implementation on how these values are used, which may or may not follow
  /// the convention listed here.
  public type Request = {
    /// Receiver principal of a cycles transfer. If omitted, the callee canister
    /// is assumed to be the receiver.
    receiver: ?Principal;
    /// Sender principal of a cycles transfer. If omitted, the caller (either a
    /// user or a canister) is assumed to be the sender.
    sender: ?Principal;
    /// Amount of cycles to transfer. If omitted, the amount reported by
    /// `available()` will be assumed.
    amount: ?Nat64;
  };

  /// Cycles transfer reponse. Note that it entirely depends on the callee's 
  /// implementation on what values are reported, which may or may not follow
  /// the convention listed here.
  public type Response = {
    /// Actual amount of cycles successfully transferred.
    #transferred: Nat64;
    /// The caller is not authorized to make this cycles transfer.
    #unauthorized;
    /// The transfer is rejected.
    #rejected: Text;
  };

  /// Canisters that implements the cycles_transfer interface.
  public type Transfer = actor {
     cycles_transfer(Request): async Response;
  };

  /// Indicates additional `amount` of cycles to be transferred in
  /// the next call, that is, evaluation of a shared function call or
  /// async expression.
  /// Upon the call, but not before, the total amount of cycles ``add``ed since
  /// the last call is deducted from `balance()`.
  /// If this total exceeds `balance()`, the caller traps, aborting the call.
  ///
  /// **Note**: the implicit register of added amounts is reset to zero on entry to
  /// a shared function and after each shared function call or resume from an await.
  public func add(amount: Nat64) {
      Prim.cyclesAdd(amount)
  };

  /// Transfers up to `amount` from `available()` to `balance()`.
  /// Returns the amount actually transferred, which may be less than
  /// requested, for example, if less is available, or if canister balance limits are reached.
  public func accept(amount : Nat64) : Nat64 {
    Prim.cyclesAccept(amount);
  };

  /// Returns the currently available `amount` of cycles.
  /// The amount available is the amount received in the current call,
  /// minus the cumulative amount `accept`ed by this call.
  /// On exit from the current shared function or async expression via `return` or `throw`
  /// any remaining available amount is automatically
  /// refunded to the caller/context.
  public func available() : Nat64 {
    Prim.cyclesAvailable()
  };

  /// Returns the actor's current balance of cycles as `amount`.
  public func balance() : Nat64 {
    Prim.cyclesBalance()
  };

  /// Reports `amount` of cycles refunded in the last `await` of the current
  /// context, or zero if no await has occurred yet.
  /// Calling `refunded()` is solely informational and does not affect `balance()`.
  /// Instead, refunds are automatically added to the current balance,
  /// whether or not `refunded` is used to observe them.
  public func refunded() : Nat64 {
      Prim.cyclesRefunded()
  };
}
