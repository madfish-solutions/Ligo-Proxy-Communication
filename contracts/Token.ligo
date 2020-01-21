type account is record
    balance : nat;
    allowances: map(address, nat);
end

type action is
| GetBalance of (address * contract(nat))
| GetTotalSupply of (unit * contract(nat))

type contract_storage is record
  totalSupply: nat;
  ledger: big_map(address, account);
end

function getBalance (const accountFrom : address ; const contr : contract(nat) ; var s : contract_storage) : list(operation) is
 begin
  const src: account = get_force(accountFrom, s.ledger);
 end with list [transaction(src.balance, 0tz, contr)]

function getTotalSupply (const contr : contract(nat) ; var s : contract_storage) : list(operation) is
  list [transaction(s.totalSupply, 0tz, contr)]

function main (const p : action ; const s : contract_storage) :
  (list(operation) * contract_storage) is
 block { 
   // Reject any transaction that try to transfer token to this contract
   if amount =/= 0tz then failwith ("This contract do not accept token");
   else skip;
  } with case p of
  | GetBalance(n) -> (getBalance(n.0, n.1, s), s)
  | GetTotalSupply(n) -> (getTotalSupply(n.1, s), s)
 end