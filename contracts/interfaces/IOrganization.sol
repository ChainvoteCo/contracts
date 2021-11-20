// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IAccessControl } from "@openzeppelin/contracts/access/IAccessControl.sol";

interface IOrganization is IAccessControl {

    /// @notice Add a member to organization
    /// @dev Mints a token towards address
    /// @param member Address of the member
    /// @param votingPower Address of the member
    function inviteMember(address member, uint votingPower) external;

    /// @notice Remove member from the organization
    /// @dev Burns the balance tokens of address
    /// @param member Address of the member
    function removeMember(address member) external;

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param admin Documents a parameter just like in doxygen (must be followed by parameter name)
    /// @param votingPower Documents a parameter just like in doxygen (must be followed by parameter name)
    function inviteAdmin(address admin, uint votingPower) external;

    function join() external;

    /* ========== VIEW FUNCTIONS ========== */

    function isMember(address member) view external returns (bool result);
    function isAdmin(address admin) view external returns (bool result);

    function votingPowerOf(address member) view external returns(uint);
    function getAdminRole() pure external returns(bytes32);

    function getMemberRole() pure external returns(bytes32);
}