# compile params; needed for the next command
ligo compile-parameter ./contracts/Receiver.ligo main -s pascaligo "Request((\"tz1bwsEWCwSEXdRvnJxvegQZKeX5dj6oKEys\" : address), (\"KT1WzFjL8kYqDYthT1GsQtqcYami3pzLQbvV\" : address), (\"KT1Qqq5GLSCYuenwaajYLF1cjouEdf5VtSyJ\" : address) )"

# send action
tezos-client -A rpcalpha.tzbeta.net -P 443 -S  transfer 0.1 from alice to "KT1NF8qAXNSNJ4XznA3dnfJ1joQz1yYdemwb" --arg "(Right   (Pair (Pair \"tz1UbbpwwefHU7N7EiHr6hiyFA2sDJi5vXkq\" \"KT1CEPFZg9u9mmZ1e9xHNqTy46Lj5MJUKKa4\")\"KT1UW7M5SiNjGqBZxnzCSy5LsKitZ8nj2bju\"))" --burn-cap 0.5

# get storage
curl https://rpcalpha.tzbeta.net:443/chains/main/blocks/head/context/contracts/KT1NF8qAXNSNJ4XznA3dnfJ1joQz1yYdemwb/storage