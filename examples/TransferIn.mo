import Cycles "../src/Cycles";
import Option "mo:base/Option";
import Principal "mo:base/Principal";

actor TransferIn {
  // Accept incoming cycles transfer when the receiver field is null.
  public func cycles_transfer(request: Cycles.Request) : async Cycles.Response {
     if (request.receiver == null) {
       // Deposit all available cycles to this canister.
       let available = Cycles.available();
       let requested_amount = Option.get(request.amount, available);
       let amount = if (requested_amount > available) { available } else { requested_amount };
       let accepted = Cycles.accept(amount);
       return #transferred(accepted);
     } else {
       #unauthorized
     }
  }
}
