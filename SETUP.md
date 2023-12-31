# System Setup

set your env vars:

`ETH_PRIVATE_KEY, DO_DEPLOY, and DO_AFTERDEPLOY to true`

first deploy the entire system:

```forge script test/proposals/DeployProposal.s.sol:DeployProposal -vvv --rpc-url baseGoerli --broadcast```

optionally, you can deploy with verification on BaseScan Goerli:

```forge script test/proposals/DeployProposal.s.sol:DeployProposal -vvv --etherscan-api-key baseGoerli --verify --rpc-url baseGoerli --broadcast```

once that is done, put generated _addAddress function calls into the Addresses.sol constructor. Then remove all whitespaces from the names "TEMPORAL_GOVERNOR " becomes "TEMPORAL_GOVERNOR" etc.

then, create the calldata to submit on the proposing chain:

```forge test -vvv --match-contract InitProposalSucceedsTest --rpc-url $ETH_RPC_URL```

now take the  wormhole publish governance calldata and send it to the wormhole core contract on the sending chain

then run the script to get the wormhole VAA and send them to the destination chain
