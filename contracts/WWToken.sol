// SPDX-License-Identifier: MIT
pragma solidity >= 0.7;

import "../client/node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WWToken is ERC20{
    constructor() ERC20("WorldWithin", "WW") {
        _mint(msg.sender, 100000000000000000000000000);
    }
}