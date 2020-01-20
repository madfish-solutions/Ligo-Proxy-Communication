# compile params; needed for the next command; 
ligo compile-parameter ./contracts/Receiver.ligo main -s pascaligo "Request((\"USER_ADDRESS\" : address), (\"PROXY_ADDRESS\" : address), (\"TOKEN_ADDRESS\" : address) )"

# send action
tezos-client -A rpcalpha.tzbeta.net -P 443 -S  transfer 0.1 from alice to "RECEIVER_ADDRESS" --arg "(Right   (Pair (Pair \"USER_ADDRESS\" \"PROXY_ADDRESS\")\"TOKEN_ADDRESS\"))" --burn-cap 0.5

# get storage
curl https://rpcalpha.tzbeta.net:443/chains/main/blocks/head/context/contracts/RECEIVER_ADDRESS/storage