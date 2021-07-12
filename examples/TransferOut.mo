import Cycles "../src/Cycles";
import Option "mo:base/Option";
import Principal "mo:base/Principal";

// An actor class is required if we want to use shared(msg) at initialization time.
shared(msg) actor class TransferOut() {
  let OWNER = msg.caller; // The creator of this canister becomes the owner.
  let MINIMUM_RESERVE = 400_000_000_000 : Nat64; // Minimum required to finish the call, subject to change.

  // Allow transferring of all remaining cycles (less a minimum reserve required to finish 
  // the call) if the following conditions are satisified:
  //  - the call is made by the owner; 
  //  - the receiver field is not null.
  public shared(msg) func cycles_transfer(request: Cycles.Request) : async Cycles.Response {
     if (msg.caller == OWNER) {
       assert(request.sender == null);
       assert(request.amount == null);
       assert(request.receiver != null);
       let receiver_id = Option.unwrap(request.receiver);
       let receiver : Cycles.Transfer = actor(Principal.toText(receiver_id));
       let balance = Cycles.balance();
       assert(balance >= MINIMUM_RESERVE);
       Cycles.add(balance - MINIMUM_RESERVE);
       await receiver.cycles_transfer({ amount = null; sender = null; receiver = null })
     } else {
       #unauthorized
     }
  };

  // Return the principal of the creator of this canister
  public query func owner() : async Principal {
    return OWNER;
  }
}
