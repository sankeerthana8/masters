pragma solidity >=0.4.22 <=0.6.0;

import "./helper_contracts/ERC721.sol";

contract RES4 is ERC721{
    struct Asset{
        uint256 assetId;
        uint256 price;
    }

    uint256 public assetsCount;
    mapping(uint256 => Asset) public assetMap;
    address public supervisor;
    mapping (uint256 => address) private assetOwner;
    mapping (address => uint256) private ownedAssetsCount;
    mapping (uint256 => address) public assetApprovals;
    constructor()public {
        supervisor = msg.sender;
    }

    //Events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    function addAsset(uint256 price,address to) public{
        require(supervisor == msg.sender,'NotAManager');
        assetMap[assetsCount] = Asset(assetsCount,price);
        mint(to,assetsCount);
        assetsCount = assetsCount+1;
    }
    function clearApproval(uint256 assetId,address approved) public {
        if (assetApprovals[assetId]==approved){
            assetApprovals[assetId] = address(0);
        }
    }

    function addApproval(address to,uint256 assetId) public {
        address owner = ownerOf(assetId);
        require(to != owner, "CurrentOwnerApproval");
        require(msg.sender == owner,"NotTheAssetOwner");
        assetApprovals[assetId] = to;
        emit Approval(owner, to, assetId);
    }

    function build(uint256 assetId,uint256 value) public payable{
        require(isApprovedOrOwner(msg.sender, assetId), "NotAnApprovedowner");
         Asset memory oldAsset = assetMap[assetId];
         assetMap[assetId] = Asset(oldAsset.assetId, oldAsset.price+value);
    }
        function appreciate(uint256 assetId,uint256 value) public{
        require(msg.sender==supervisor,"NotaManager");
         Asset memory oldAsset = assetMap[assetId];
         assetMap[assetId] = Asset(oldAsset.assetId, oldAsset.price+value);
    }
        function depreciate(uint256 assetId,uint256 value) public{
        require(msg.sender==supervisor,"NotaManager");
         Asset memory oldAsset = assetMap[assetId];
         assetMap[assetId] = Asset(oldAsset.assetId, oldAsset.price-value);
    }
    function getAssetsSize() public view returns(uint){
        return assetsCount;
    }
   
}