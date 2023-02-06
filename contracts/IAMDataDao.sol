// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "./interfaces/IManageInstitutionOnDao.sol";

// Library Definition
abstract contract IAMDataDAO is IManageInstitutionOnDao {
    mapping(address => ROLES) public roleOfAccount;
    address[] memberOfDAO;
    address[] public memberApplicants;

    modifier checkUser(address user) {
        if (getRoleNum(roleOfAccount[user]) == 0) {
            memberOfDAO.push(user);
        }
        _;
    }

    modifier reqOwners(ROLES access) {
        require(access == ROLES.OWNERS, "Access Denied: Owners only");
        _;
    }

    modifier reqAdmin(ROLES access) {
        require(
            access == ROLES.ADMINS || access == ROLES.OWNERS,
            "Access Denied: Admins and above"
        );
        _;
    }

    modifier reqRegistrants(ROLES access) {
        require(
            access == ROLES.ADMINS ||
                access == ROLES.OWNERS ||
                access == ROLES.REGISTRANTS,
            "Access Denied: Registrants and above"
        );
        _;
    }

    modifier reqReviewers(ROLES access) {
        require(
            access == ROLES.ADMINS ||
                access == ROLES.OWNERS ||
                access == ROLES.REGISTRANTS ||
                access == ROLES.REVIEWERS,
            "Access Denied: Reviewers and above"
        );
        _;
    }

    function grantAccess(address user, ROLES role)
        public
        checkUser(user)
        reqOwners(roleOfAccount[msg.sender])
    {
        require(role != ROLES.OWNERS, "Cannot directly grant owner role");
        roleOfAccount[user] = role;
    }

    function revokeRole(address user)
        public
        reqAdmin(roleOfAccount[msg.sender])
    {
        require(
            roleOfAccount[user] != ROLES.NOT_A_MEMBER,
            "Cannot rovoke role from non-member"
        );
        require(
            getRoleNum(roleOfAccount[msg.sender]) >
                getRoleNum(roleOfAccount[user]),
            "Cannot remove role of equal or greater level"
        );
        delete roleOfAccount[user];
    }

    function allowRegistrant(address user)
        public
        checkUser(user)
        reqAdmin(roleOfAccount[msg.sender])
    {
        roleOfAccount[user] = ROLES.REGISTRANTS;
    }

    function allowReviewer(address user)
        public
        checkUser(user)
        reqRegistrants(roleOfAccount[msg.sender])
    {
        roleOfAccount[user] = ROLES.REVIEWERS;
    }

    function applyToInstitution() public {
        memberApplicants.push(msg.sender);
    }

    function approveJoinInstitution()
        public
        checkUser(memberApplicants[memberApplicants.length])
        reqRegistrants(roleOfAccount[msg.sender])
    {
        roleOfAccount[memberApplicants[memberApplicants.length]] = ROLES
            .REVIEWERS;
    }

    function denyJoinInstitution()
        public
        reqRegistrants(roleOfAccount[msg.sender])
    {
        delete memberApplicants[memberApplicants.length];
    }

    function getAllMembersOfDAO() public view returns (address[] memory) {
        address[] memory allMembers;
        for (uint256 i = 0; i < memberOfDAO.length; i++) {
            allMembers[i] = (memberOfDAO[i]);
        }
        return allMembers;
    }

    function getRoleNum(ROLES role) public pure returns (uint256) {
        if (role == ROLES.OWNERS) {
            return 4;
        } else if (role == ROLES.ADMINS) {
            return 3;
        } else if (role == ROLES.REGISTRANTS) {
            return 2;
        } else if (role == ROLES.REVIEWERS) {
            return 1;
        } else {
            return 0;
        }
    }
}
