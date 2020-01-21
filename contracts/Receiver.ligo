type action is
| Receive of nat
| Request of (address * address * address)

type account is record
    balance : nat;
    allowances: map(address, nat);
end

type tokenAction is
| GetBalance of (address * contract(nat))
| GetTotalSupply of (unit * contract(nat))

function requestBalance (const user : address ; const proxy : address ; const token : address) : list(operation) is
 begin
  const contr: contract(tokenAction) = get_contract(token);
  const receiver: contract(nat) = get_contract(proxy);
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