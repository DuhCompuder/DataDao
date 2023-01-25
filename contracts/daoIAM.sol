// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;
import "./daoIAMTypes.sol";
contract IamDAO is IAMLib { 

    function grantAccress() public IAMLib.reqAdmin(roleOfAccount[msg.sender]) {

    }

    function changeRole(address user) public IAMLib.reqAdmin(roleOfAccount[msg.sender]) {

    }
}