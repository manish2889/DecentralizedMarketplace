# Decentralized Marketplace

This repository contains the Solidity smart contract for a decentralized marketplace built on the Polygon network. The decentralized marketplace allows users to list products for sale, purchase listed products, and leave ratings for sellers, all facilitated through secure and transparent smart contracts.

## Features

- **Product Listing**: Sellers can list their products with details such as name, description, and price.
- **Secure Transactions**: Buyers can purchase listed products by sending the required amount to an escrow smart contract.
- **Escrow System**: Funds from purchases are held in escrow until the buyer confirms the delivery and releases the payment to the seller.
- **Rating System**: After a successful transaction, buyers can rate the seller, creating a decentralized reputation system.
- **Scalability**: Leveraging the Polygon network's layer-2 solution, the marketplace offers fast transaction times and low gas fees.

## Getting Started

To run and interact with the Decentralized Marketplace smart contract, you'll need the following:

- An Ethereum-compatible development environment (e.g., Remix, Truffle, or Hardhat)
- A connection to the Polygon network (e.g., using the Polygon RPC endpoint or a local Polygon node)

1. Clone this repository to your local machine.
2. Compile the `DecentralizedMarketplace.sol` file.
3. Deploy the smart contract to the Polygon network.
4. Interact with the deployed contract using the provided functions and events.

## Contract Functions

### `listProduct(string _name, string _description, uint256 _price)`
Lists a new product for sale with the provided details.

### `purchaseProduct(uint256 _id)`
Allows a buyer to purchase a listed product by sending the required amount. Creates an escrow transaction.

### `releaseEscrow(uint256 _escrowId, uint256 _rating)`
Releases the funds from the escrow to the seller and allows the buyer to rate the seller.

### `updateProduct(uint256 _id, string _name, string _description, uint256 _price)`
Allows the seller to update the details of a listed product.

### `removeProduct(uint256 _id)`
Allows the seller to remove a listed product from the marketplace.

### `getProduct(uint256 _id)`
Retrieves the details of a listed product.

### `getEscrow(uint256 _id)`
Retrieves the details of an escrow transaction.

## Events

- `ProductListed`: Emitted when a new product is listed.
- `EscrowCreated`: Emitted when a new escrow transaction is created.
- `EscrowReleased`: Emitted when an escrow transaction is released, and the seller is rated.

## Contributing

Contributions to this project are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
