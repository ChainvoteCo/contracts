// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract Users is AccessControl {

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MEMBER_ROLE = keccak256("MEMBER_ROLE");

    enum InviteStatus {
        NotInvited,
        MemberInvite,
        AdminInvite,
        Accepted,
        Declined
    }

    struct Invite {
        InviteStatus status;
        uint votingPower;
    }

    mapping (address => Invite) public invites;

    /* ========== RESTRICTED FUNCTIONS ========== */

    /// @notice Add a member to organization
    /// @dev Mints a token towards address
    /// @param member Address of the member
    /// @param votingPower Address of the member
    function inviteMember(address member, uint votingPower) 
        external 
        onlyRole(ADMIN_ROLE) 
    {
        Invite storage invite = invites[member];

        require(invite.status == InviteStatus.NotInvited, "User Already Invited");

        invite.status = InviteStatus.MemberInvite;
        invite.votingPower = votingPower;
    }

    /// @notice Remove member from the organization
    /// @dev Burns the balance tokens of address
    /// @param member Address of the member
    function removeMember(address member) 
        external 
        onlyRole(ADMIN_ROLE) 
    {
        revokeRole(MEMBER_ROLE, member);
        burn(member, balanceOf(member));
    }

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param admin Documents a parameter just like in doxygen (must be followed by parameter name)
    /// @param votingPower Documents a parameter just like in doxygen (must be followed by parameter name)
    function inviteAdmin(address admin, uint votingPower) 
        external 
        onlyRole(ADMIN_ROLE) 
    {
        Invite storage invite = invites[admin];

        require(invite.status == InviteStatus.NotInvited, "User Already Invited");

        invite.status = InviteStatus.AdminInvite;
        invite.votingPower = votingPower;
    }

    function join() external {
        _join(msg.sender);
    }

    function _join(address user) internal virtual {
        Invite storage invite = invites[user];
        if(invite.status == InviteStatus.AdminInvite) _joinAsAdmin(user);
        else if (invite.status == InviteStatus.MemberInvite) _joinAsMember(user);
        else revert("Invite not found");
    }

    function _joinAsMember(address user) internal virtual {
        grantRole(MEMBER_ROLE, user);
        mint(user, invites[user].votingPower);

        invites[user].status = InviteStatus.Accepted;
    }

    function _joinAsAdmin(address user) internal virtual {
        _joinAsMember(user);
        grantRole(ADMIN_ROLE, user);
    }

    function burn(address account, uint256 amount) public virtual;
    function mint(address account, uint256 amount) public virtual;

    /* ========== VIEW FUNCTIONS ========== */

    function isMember(address member) view public returns (bool result) {
        return hasRole(MEMBER_ROLE, member);
    }

    function isAdmin(address admin) view public returns (bool result) {
        return hasRole(ADMIN_ROLE, admin);
    }

    function votingPowerOf(address member) view external returns(uint) {
        return balanceOf(member);
    }

    function getAdminRole() pure external returns(bytes32) {
        return ADMIN_ROLE;
    }

    function getMemberRole() pure external returns(bytes32) {
        return MEMBER_ROLE;
    }

    function balanceOf(address account) public view virtual returns (uint256);
}