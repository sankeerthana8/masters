// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CarResaleValue is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    event ExpirationDateSet(uint256 indexed tokenId, uint256 expirationDate);    
    event CarSold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 salePrice);

    struct CarDetails {
        string make;
        string model;
        uint256 year;
        string condition;
        uint256 resaleValue;
        uint256 expirationDate;
        bool sold;
    }

    mapping(uint256 => CarDetails) private _carDetails;

    constructor() ERC721("CarResaleValue", "CRV") {}

    modifier priceIfNotZero(uint256 resaleValue) {
        require(resaleValue > 0, "Resale value must be greater than zero");
        _;
    }

    modifier validcondition(string memory condition) {
        require(
            keccak256(bytes(condition)) == keccak256(bytes("excellent")) ||
                keccak256(bytes(condition)) == keccak256(bytes("good")) ||
                keccak256(bytes(condition)) == keccak256(bytes("fair")) ||
                keccak256(bytes(condition)) == keccak256(bytes("poor")),
            "Invalid condition"
        );
        _;
    }

    function createCarResaleValue(
        string memory make,
        string memory model,
        uint256 year,
        string memory condition,
        uint256 resaleValue,
        address owner
    ) public priceIfNotZero(resaleValue) validcondition(condition) returns (uint256) {
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        _mint(owner, tokenId);
        CarDetails memory details = CarDetails({
            make: make,
            model: model,
            year: year,
            condition: condition,
            resaleValue: resaleValue,
            expirationDate: 0,
            sold:false
        });

        _carDetails[tokenId] = details;

        return tokenId;
    }

    function getCarDetails(uint256 tokenId) public view returns (CarDetails memory) {
        require(_exists(tokenId), "Token does not exist");

        return _carDetails[tokenId];
    }

    function purchaseCarResaleValue(uint256 tokenId) public payable {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) != msg.sender, "You already own this token");
        require(msg.value >= _carDetails[tokenId].resaleValue, "Insufficient funds");
        require(!_carDetails[tokenId].sold, "Car already sold");
        address payable owner = payable(ownerOf(tokenId));
        owner.transfer(msg.value);
        _transfer(owner, msg.sender, tokenId);
        _carDetails[tokenId].sold = true;

        emit CarSold(tokenId, owner, msg.sender, msg.value);
    }


    function editCarDetails(uint256 tokenId, string memory make, string memory model, uint256 year, string memory condition, uint256 resaleValue) public validcondition(condition) priceIfNotZero(resaleValue) {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "Only the owner can call this function");
        CarDetails storage details = _carDetails[tokenId];
        details.make = make;
        details.model = model;
        details.year = year;
        details.condition = condition;
        details.resaleValue = resaleValue;
    }
    function setExpirationDate(uint256 tokenId, uint256 expirationDate) public {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "Only the owner can call this function");
        require(expirationDate > block.timestamp/31536000, "Expiration date must be in the future");

        CarDetails storage details = _carDetails[tokenId];
        details.expirationDate = expirationDate;

        emit ExpirationDateSet(tokenId, expirationDate);
    }

    function deleteCar(uint256 tokenId) public {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "Only the owner can call this function");

    
        _burn(tokenId);
    }
    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }


    
    function searchCar(string memory make, string memory model, uint256 year, string memory condition) public view returns (CarDetails[] memory) {
        uint256 totalCars = totalSupply();
        CarDetails[] memory cars = new CarDetails[](totalCars);

        for (uint256 i = 1; i <= totalCars; i++) {
            if (keccak256(bytes(_carDetails[i].make)) == keccak256(bytes(make)) ||
                keccak256(bytes(_carDetails[i].model)) == keccak256(bytes(model)) ||
                _carDetails[i].year == year ||
                keccak256(bytes(_carDetails[i].condition)) == keccak256(bytes(condition))) {
                cars[i-1] = _carDetails[i];
            }
        }

        return cars;
    }

    function isCarSold(uint256 tokenId) public view returns (bool) {
        require(_exists(tokenId), "Token does not exist");

        return getCarDetails(tokenId).sold;
    }

    
}
