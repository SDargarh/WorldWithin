// SPDX-License-Identifier: MIT
pragma solidity >= 0.7;

import "./WWToken.sol";
import "./WWNFTToken.sol";
import "../client/node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Marketplace{
    using SafeMath for uint;

    struct ItemsDetails{
        // uint ItemId;
        address seller;
        uint priceInWW;
    }

    //stores the items put up for sale by users againt assetID/TokenID
    mapping(uint => ItemsDetails) public ItemsForSale;
    // mapping(address => uint) public mintedTokenByUser;
    
    WWToken wwToken;
    WWNFTToken wwNftToken;

    constructor(address _tokenAddress, address _nftAddress) {
        wwToken = WWToken(_tokenAddress);
        wwNftToken = WWNFTToken(_nftAddress);
    }
    
    function mintToken() public returns(uint){
        uint newItemId = wwNftToken.mintForUser(msg.sender);
        return newItemId;
        // mintedTokenByUser[msg.sender] = newItemId;
    }

    function transferCutToOwner(uint _price) internal {
        
        //payment to Market place owner to put up the sale request
        //2% of the Item price
        uint marketOwnerRate = 0;
        marketOwnerRate = _price.mul(2).div(100);

        //must be approved 
        require(
        wwToken.transferFrom(msg.sender, address(this), marketOwnerRate),
        "Transfering the cut to the Marketplace owner failed"
        );

    }

    function UserSaleRequest(uint _assetId, uint _priceInWW) public {
        ItemsForSale[_assetId].seller = msg.sender;
        ItemsForSale[_assetId].priceInWW = _priceInWW;  

        transferCutToOwner(_priceInWW);
    }

    function UserPurchaseRequest(uint _assetId, uint _payment) public {
        // Transfer sale amount to seller
        require(ItemsForSale[_assetId].seller != address(0), "Item not available");
        address _seller  = ItemsForSale[_assetId].seller;
        uint _priceInWW = ItemsForSale[_assetId].priceInWW;
        
        //marketOwner's Rate must be included in the payment from user and the left must be equal to the NFT Item's price
        //2% of the deal
        uint marketOwnerRate = 0;
        marketOwnerRate = _priceInWW.mul(2).div(100);

        require(
        _payment == _priceInWW.add(marketOwnerRate), 
        "payment sent is not correct"
        );

        //must be approved
        require(
        wwToken.transferFrom(msg.sender, address(this), marketOwnerRate),
        "Transfering the cut to the Marketplace owner failed"
        );

        require(
        wwToken.transferFrom(msg.sender, _seller, _payment.sub(marketOwnerRate)),
        "Transfering the sale amount to the seller failed"
        );
        
        // Transfer asset owner
        wwNftToken.safeTransferFrom(_seller, msg.sender, _assetId);

        //remove the asset from the ItemsForSale
        ItemsForSale[_assetId].seller = address(0);
        ItemsForSale[_assetId].priceInWW = 0;
    
    }

}