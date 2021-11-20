// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

import { IOrganization } from "./../interfaces/IOrganization.sol";

contract Election is Pausable, AccessControl {

    bytes32 public constant VOTER_ROLE = keccak256("VOTER_ROLE");
    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

    uint startTime;
    uint endTime;

    bytes private ID;

    constructor(
        bytes memory _ID,
        address[] memory moderators, 
        address[] memory voters, 
        uint start, 
        uint end
    ){
        require(moderators.length > 0, "Election: No moderators added");
        ID = _ID;

        // org member/admin can become voter
        for(uint i = 0; i<voters.length; i++){
            require(
                IOrganization(msg.sender).isAdmin(voters[i]) || IOrganization(msg.sender).isMember(voters[i]), 
                "Election: Voter is not organization admin/member");
            grantRole(VOTER_ROLE, voters[i]);
        }

        // only org admins can become moderator
        for(uint i = 0; i<moderators.length; i++){
            require(
                IOrganization(msg.sender).isAdmin(voters[i]), 
                "Election: Moderator is not organization admin");
            grantRole(MODERATOR_ROLE, moderators[i]);
        }

        startTime = start;
        endTime = end;
    }

    function pause() external onlyRole(MODERATOR_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(MODERATOR_ROLE) {
        _unpause();
    }

    function updateTime(uint start, uint end) external onlyRole(MODERATOR_ROLE) {
        startTime = start;
        endTime = end;
    }
}