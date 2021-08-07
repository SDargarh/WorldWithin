// SPDX-License-Identifier: MIT
pragma solidity >= 0.7;

import "../client/node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../client/node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract WWNFTToken is ERC721{
    // using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint[] public Items;

    constructor() ERC721("WWNFTToken", "WWTKN") {
    }

    function mintForUser(address _user) public returns(uint) {
        address user = _user;
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(user, newItemId);
        
        Items.push(newItemId);
        //add a tokenURI

        return newItemId;
    }

}