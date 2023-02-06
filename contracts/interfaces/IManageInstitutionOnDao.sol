// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

interface IManageInstitutionOnDao {
    enum ROLES {
        NOT_A_MEMBER,
        REVIEWERS,
        REGISTRANTS,
        ADMINS,
        OWNERS
    }

    function roleOfAccount(address role) external view returns (ROLES);

    function getRoleNum(ROLES role) external pure returns (uint256);
}
