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

    function grantAccress() public reqAdmin(roleOfAccount[msg.sender]) {}

    function changeRole(address user)
        public
        reqAdmin(roleOfAccount[msg.sender])
    {}

    function approveRegistrant() public reqAdmin(roleOfAccount[msg.sender]) {}

    function approveReviewer() public reqAdmin(roleOfAccount[msg.sender]) {}
}
