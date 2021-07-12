import Cycles "../src/Cycles";
import Option "mo:base/Option";
import Principal "mo:base/Principal";

shared(msg) actor class HelloCycles() {
  let OWNER = msg.caller;
  let MINIMUM_RESERVE = 400_000_000_000 : Nat64;

  public shared(msg) func cycles_transfer(request: Cycles.Request) : async Cycles.Response {
     if (msg.caller == OWNER) {
       // Owner asks to transfer out
       assert(request.sender == null);
       assert(request.receiver != null);
       let receiver_id = Option.unwrap(request.receiver);
       let receiver : Cycles.Transfer = actor(Principal.toText(receiver_id));
       let balance = Cycles.balance();
       let amount = Option.get(request.amount, 0 : Nat64);
       assert(amount > 0);
       if (amount + MINIMUM_RESERVE > balance) {
         return #rejected("Insufficient cycles balance");
       };
       Cycles.add(amount);
       await receiver.cycles_transfer({
         sender = request.sender;
         receiver = null;
         amount = ?amount;
       })
     } else if (request.receiver == null) {
       // Deposit available cycles to this canister.
       let available = Cycles.available();
       let requested_amount = Option.get(request.amount, available);
       let amount = if (requested_amount > available) { available } else { requested_amount };
       let accepted = Cycles.accept(amount);
       return #transferred(accepted);
     } else {
       #unauthorized
     }
  };

  // Return the current cycle balance.
  public shared query (msg) func cycles_balance() : async Nat64 {
    Cycles.balance()
  };

  // Return the principal of the creator of this canister
  public query func owner() : async Principal {
    return OWNER;
  }
}
