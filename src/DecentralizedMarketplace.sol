// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedMarketplace {
    // Struct to represent a product listing
    struct Product {
        uint256 id;
        string name;
        string description;
        uint256 price;
        address payable seller;
        bool isListed;
        uint256 rating;
        uint256 ratingCount;
        uint256 createdAt;
    }

    // Struct to represent an escrow transaction
    struct Escrow {
        uint256 id;
        uint256 productId;
        address payable buyer;
        address payable seller;
        uint256 amount;
        bool isReleased;
        uint256 createdAt;
    }

    // Mapping to store product listings
    mapping(uint256 => Product) public products;
    // Mapping to store escrow transactions
    mapping(uint256 => Escrow) public escrows;

    // Event to emit when a new product is listed
    event ProductListed(
        uint256 id,
        string name,
        string description,
        uint256 price,
        address seller,
        uint256 createdAt
    );

    // Event to emit when an escrow transaction is created
    event EscrowCreated(
        uint256 id,
        uint256 productId,
        address buyer,
        address seller,
        uint256 amount,
        uint256 createdAt
    );

    // Event to emit when an escrow transaction is released
    event EscrowReleased(uint256 id, uint256 rating);

    // Counter to keep track of product IDs
    uint256 public productCount;
    // Counter to keep track of escrow IDs
    uint256 public escrowCount;

    // Modifiers
    modifier onlySeller(uint256 _productId) {
        Product memory product = products[_productId];
        require(
            msg.sender == product.seller,
            "Only the seller can perform this action"
        );
        _;
    }

    modifier onlyBuyer(uint256 _escrowId) {
        Escrow memory escrow = escrows[_escrowId];
        require(
            msg.sender == escrow.buyer,
            "Only the buyer can perform this action"
        );
        _;
    }

    // Function to list a new product
    function listProduct(
        string memory _name,
        string memory _description,
        uint256 _price
    ) public {
        productCount++;
        products[productCount] = Product(
            productCount,
            _name,
            _description,
            _price,
            payable(msg.sender),
            true,
            0,
            0,
            block.timestamp
        );
        emit ProductListed(
            productCount,
            _name,
            _description,
            _price,
            msg.sender,
            block.timestamp
        );
    }

    // Function to purchase a product and create an escrow
    function purchaseProduct(uint256 _id) public payable {
        Product memory product = products[_id];
        require(product.isListed, "Product is not listed for sale");
        require(msg.value >= product.price, "Insufficient funds sent");

        escrowCount++;
        escrows[escrowCount] = Escrow(
            escrowCount,
            _id,
            payable(msg.sender),
            product.seller,
            msg.value,
            false,
            block.timestamp
        );
        emit EscrowCreated(
            escrowCount,
            _id,
            msg.sender,
            product.seller,
            msg.value,
            block.timestamp
        );
    }

    // Function to release funds from escrow and rate the seller
    function releaseEscrow(
        uint256 _escrowId,
        uint256 _rating
    ) public onlyBuyer(_escrowId) {
        Escrow storage escrow = escrows[_escrowId];
        require(!escrow.isReleased, "Escrow has already been released");
        require(_rating <= 5, "Rating must be between 1 and 5");

        escrow.seller.transfer(escrow.amount);
        escrow.isReleased = true;

        Product storage product = products[escrow.productId];
        product.rating =
            (product.rating * product.ratingCount + _rating) /
            (product.ratingCount + 1);
        product.ratingCount++;

        emit EscrowReleased(_escrowId, _rating);
    }

    // Function to update a product listing
    function updateProduct(
        uint256 _id,
        string memory _name,
        string memory _description,
        uint256 _price
    ) public onlySeller(_id) {
        Product storage product = products[_id];
        product.name = _name;
        product.description = _description;
        product.price = _price;
    }

    // Function to remove a product listing
    function removeProduct(uint256 _id) public onlySeller(_id) {
        Product storage product = products[_id];
        require(product.isListed, "Product is not listed");
        product.isListed = false;
    }

    // Function to retrieve a product listing by ID
    function getProduct(
        uint256 _id
    )
        public
        view
        returns (
            uint256 id,
            string memory name,
            string memory description,
            uint256 price,
            address seller,
            bool isListed,
            uint256 rating,
            uint256 ratingCount,
            uint256 createdAt
        )
    {
        Product memory product = products[_id];
        return (
            product.id,
            product.name,
            product.description,
            product.price,
            product.seller,
            product.isListed,
            product.rating,
            product.ratingCount,
            product.createdAt
        );
    }

    // Function to retrieve an escrow transaction by ID
    function getEscrow(
        uint256 _id
    )
        public
        view
        returns (
            uint256 id,
            uint256 productId,
            address buyer,
            address seller,
            uint256 amount,
            bool isReleased,
            uint256 createdAt
        )
    {
        Escrow memory escrow = escrows[_id];
        return (
            escrow.id,
            escrow.productId,
            escrow.buyer,
            escrow.seller,
            escrow.amount,
            escrow.isReleased,
            escrow.createdAt
        );
    }
}
