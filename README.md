# Welcome

 * This is a NFT project using ERC721A to implement.

## Features
 * Two-Stage mint : presale, publicsale
 * White List
 * Airdrop 
 * Blind Box system
 * Reveal function
 * Reserve function


## Usage

### How to mint (Rookies.sol)
 * add to whitelist ```function addToAllowList(address[] calldata addresses)```
 * check mint status ```_isPreSaleActive, _isPublicSaleActive```
 * mint ```function mint_presale(uint8 NUM_TOKENS_MINT), function mint_public(uint8 NUM_TOKENS_MINT)```
 * Etherscan合約地址 [Rookies.sol](https://rinkeby.etherscan.io/address/0x01d5b5044c5c6a97e071c5753fb7b6d40949cc06#code)

### Why ERC721A
 * 節省mint gas fee，特別是針對批次mint
 * 優化 1 - Removing duplicate storage from OpenZeppelin’s (OZ) ERC721Enumerable
 * 優化 2 - updating the owner’s balance once per batch mint request, instead of per minted NFT 
 * 優化 3 - updating the owner data once per batch mint request, instead of per minted NFT
 * 實作參考資料 [Azuki ERC721A](https://www.azuki.com/erc721a?fbclid=IwAR0bYh7Ehls9hilQxVLl6h4AbqQNWng0N2o6UdOCpi4BRjm9609bGTKafqY)


## Installation

If you are cloning the project then run this first, otherwise you can download the source code on the release page and skip this step.

```sh
git clone https://github.com/DazaiC/dazai_nft_erc721a.git
```

Make sure you have node.js installed so you can use npm, then run:

```sh
npm install
```

## Hardhat

To install Hardhat, go to an empty folder, initialize an npm project (i.e. npm init), and run

```sh
npm install --save-dev hardhat
```

Once it's installed, just run this command and follow its instructions:

```sh
npx hardhat
```

Create a .env file and put your ETHERSCAN_API_KEY, PRIVATE_KEY, TESTNET_URL

```sh
ETHERSCAN_API_KEY = 123........
PRIVATE_KEY = 456......

ROPSTEN_URL = https://ropsten.infura.io/v3/abcdefg123456...
RINKEBY_URL = https://rinkeby.infura.io/v3/abcdefg123456...
```

* Find more info about [Hardhat](https://hardhat.org/tutorial/)

## License

This project is licensed under the [MIT license](LICENSE).
