// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

// Library Definition
contract IAMLib {
    enum ROLES {
        OWNERS,
        ADMINS,
        REGISTRANTS,
        REVIEWERS
    }

    mapping(address => ROLES) roleOfAccount;

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
}
