// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// Library Definition
contract IAMDataDAO {
    enum ROLES {
        OWNERS,
        ADMINS,
        REGISTRANTS,
        REVIEWERS
    }

    mapping(address => ROLES) public roleOfAccount;

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
        reqOwners(roleOfAccount[msg.sender])
    {
        require(role != ROLES.OWNERS, "Cannot directly grant owner role");
        roleOfAccount[user] = role;
    }

    function RevokeRole(address user)
        public
        reqAdmin(roleOfAccount[msg.sender])
    {
        require(
            mapRoleToNum(roleOfAccount[msg.sender]) >
                mapRoleToNum(roleOfAccount[user]),
            "Cannot remove role of equal or greater level"
        );
        delete roleOfAccount[user];
    }

    function allowRegistrant(address user)
        public
        reqAdmin(roleOfAccount[msg.sender])
    {
        roleOfAccount[user] = ROLES.REGISTRANTS;
    }

    function allowReviewer(address user)
        public
        reqRegistrants(roleOfAccount[msg.sender])
    {
        roleOfAccount[user] = ROLES.REVIEWERS;
    }

    function mapRoleToNum(ROLES role) private pure returns (uint256) {
        if (role == ROLES.OWNERS) {
            return 3;
        } else if (role == ROLES.ADMINS) {
            return 2;
        } else if (role == ROLES.REGISTRANTS) {
            return 1;
        } else {
            return 0;
        }
    }
}
