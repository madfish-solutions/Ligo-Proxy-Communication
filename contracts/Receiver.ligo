type action is
| Receive of nat
| Request of (address * address * address)

type amount is nat;

type account is record
    balance : amount;
    allowances: map(address, amount);
end

type tokenAction is
| Transfer of (address * address * amount)
| Mint of (amount)
| Burn of (amount)
| Approve of (address * amount)
| GetAllowance of (address * address * contract(amount))
| GetBalance of (address * contract(amount))
| GetTotalSupply of (unit * contract(amount))

function requestBalance (const user : address ; const proxy : address ; const token : address) : list(operation) is
 begin
  const contr: contract(tokenAction) = get_contract(token);
  const receiver: contract(amount) = get_contract(proxy);
  const param: tokenAction = GetBalance(user, receiver);
  const operations : list(operation) = list transaction(param, 0tz, contr); end;
 end with operations

function receive (const value : nat) : nat is
 begin
  skip
 end with value

function main (const p : action ; const s : nat) :
  (list(operation) * nat) is
 block { 
    skip;
  } with case p of
  | Request(n) -> (requestBalance(n.0, n.1, n.2), s)
  | Receive(n) -> ((nil : list(operation)), receive(n))
 end