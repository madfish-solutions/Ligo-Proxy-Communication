type action is
| Receive of nat
| Request of (address * address * address)

function requestBalance (const user : address ; const proxy : address ; const token : address) : list(operation) is
 begin
  const contr: contract((address * contract(nat))) = get_contract(token);
  const receiver: contract(nat) = get_contract(proxy);
  const param: (address * contract(nat)) = (user, receiver);
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