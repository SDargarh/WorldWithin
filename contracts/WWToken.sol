// SPDX-License-Identifier: MIT
pragma solidity >= 0.7;

import "../client/node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WWToken is ERC20{
    constructor(address _owner) ERC20("WorldWithin", "WW") {
        _mint(_owner, 1000000);
    }
}