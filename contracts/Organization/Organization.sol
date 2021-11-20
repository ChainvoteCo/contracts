// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Election } from "./../Election/Election.sol";
import { Users } from "./Users.sol";

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Organization Contract
/// @author Prasad Kumkar - <prasad@chainvote.co>
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details
contract Organization is Users, ERC20 {

    mapping (bytes => Election) public elections;

    constructor(string memory name, string memory symbol)
    ERC20(name, symbol){
        grantRole(ADMIN_ROLE, msg.sender);
    }
    
    function burn(address account, uint256 amount) public virtual override {
        _burn(account, amount);
    }

    function mint(address account, uint256 amount) public virtual override {
        _mint(account, amount);
    }

    function balanceOf(address account) public view virtual override(Users, ERC20) returns(uint) {
        return super.balanceOf(account);
    }

    /* ========== */

    function newElection(
        bytes memory electionId, 
        address[] memory mods, 
        address[] memory voters, 
        uint start, 
        uint end
    ) external onlyRole(ADMIN_ROLE) {
        Election election = new Election(electionId, mods, voters, start, end);
        elections[electionId] = election;
    }
}