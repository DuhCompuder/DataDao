// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;
import "./daoIAM.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract Institution is IamDAO {
    using Counters for Counters.Counter;
    string public name;
    struct Document{
        string title;
        bytes cid;
        uint256 timeCreated;
        uint256 timeLastUpdated;
        uint256 currentVersion;
        // mapping(uint256 => bytes) versions;
    }

    mapping (uint256 => Document) private documents;
    mapping (uint256 => Document) private docsForApproval;
    Document[] private allDocs;
    Counters.Counter public documentCount;
    Counters.Counter public docsForApprovalCount;

    constructor(string memory _name) {
        name = _name;
    }

    mapping (address => string) institutionName; 

    function updateName(string memory newName) public IAMLib.reqOwners(roleOfAccount[msg.sender]) {
        name = newName;
    }

    function registerNewDocument(string calldata title, bytes calldata cid) public IAMLib.reqRegistrants(roleOfAccount[msg.sender]) {
        Document memory newDoc;
        newDoc.title = title;
        newDoc.cid = cid;
        newDoc.timeCreated = block.timestamp;

        docsForApproval[docsForApprovalCount.current()] = newDoc;
        docsForApprovalCount.increment();
    }

    function updateDocument() public {

    }

    function approveRegistrant() public IAMLib.reqAdmin(roleOfAccount[msg.sender]) {

    }

    function approveReviewer() public IAMLib.reqAdmin(roleOfAccount[msg.sender]) {
        
    }
}