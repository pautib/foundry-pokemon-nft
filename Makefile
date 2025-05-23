-include .env

.PHONY: all test clean deploy help install snapshot format anvil mint

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install OpenZeppelin/openzeppelin-contracts --no-commit && forge install cyfrin/foundry-devops --no-commit && forge install transmissions11/solmate --no-commit
#install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install transmissions11/solmate@v6 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script script/DeployPokemonInterface.s.sol:DeployPokemonInterface $(NETWORK_ARGS)

# Example: make deploy ARGS="--network sepolia"
mint: 
	@forge script script/Interactions.s.sol:MintGholdengoNFT $(NETWORK_ARGS)

ownerOf:
	@cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "ownerOf(uint256)(address)" 0 --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

tokenUri:
	@cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "tokenURI(uint256)(string)" 0 --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# forge test --match-contract PokemonHelperTest --match-test testChangePokemonNickName
# forge test --match-contract PokemonHelperTest --match-test testNotAllowChangeNicknametoNotPokemonTrainer
# forge test --match-contract PokemonHelperTest --match-test testLevelUp