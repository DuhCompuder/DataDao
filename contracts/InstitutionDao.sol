// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;
import "./DataDaoIAM.sol";
import "./DaoManager.sol";
import {MarketAPI} from "@zondax/filecoin-solidity/contracts/v0.8/MarketAPI.sol";
import {CommonTypes} from "@zondax/filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";
import {MarketTypes} from "@zondax/filecoin-solidity/contracts/v0.8/types/MarketAPI.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract InstitutionDAO is DataDAOIAM {
    using Counters for Counters.Counter;
    string public name;
    DaoManager managingDAO;

    struct DealIdentifer {
        string title;
        bytes cid;
        uint256 cidSize;
        uint256 timeCreated;
        bool approved;
        uint256 voteCount;
    }

    mapping(uint256 => DealIdentifer) public docsForApproval;
    mapping(uint256 => DealIdentifer) public approvedDealIdentifers;

    Counters.Counter public dealidentiferCount;
    Counters.Counter public docsForApprovalCount;

    mapping(bytes => mapping(address => bool)) public voters;

    constructor(
        string memory _name,
        address[] owners,
        DaoManager _managingDao
    ) {
        name = _name;
        managingDAO = _managingDAO;
        for (int256 i = 0; i < owners.length; i++) {
            roleOfAccount[i] = ROLES.OWNERS;
        }
    }

    function fund(uint64 unused) public payable {}

    // Owner Functions

    function updateName(string memory newName)
        public
        reqOwners(roleOfAccount[msg.sender])
    {
        name = newName;
    }

    // Admin Functions
    function voteDealIdentifer(uint256 index)
        public
        reqAdmin(roleOfAccount[msg.sender])
    {
        require(
            voters[docsForApproval[index].cid][msg.sender] == false,
            "You cannot vote for the same document more than once"
        );
        voters[docsForApproval[index].cid][msg.sender] = true;
        docsForApproval[index].voteCount += 1;
    }

    function approveDealIdentifer(uint256 index)
        public
        reqAdmin(roleOfAccount[msg.sender])
    {
        require(
            docsForApproval[index].votes > 0,
            "Does not meet minimum vote count for approval"
        );
        docsForApproval[index].approved = true;
        managingDAO.addCID(
            docsForApproval[index].cid,
            docsForApproval[index].size
        );
    }

    // Registrant Functions
    function registerNewDealIdentifer(string calldata title, bytes calldata cid)
        public
        reqRegistrants(roleOfAccount[msg.sender])
    {
        DealIdentifer memory newDoc;
        newDoc.title = title;
        newDoc.cid = cid;
        newDoc.timeCreated = block.timestamp;

        docsForApproval[docsForApprovalCount.current()] = newDoc;
        docsForApprovalCount.increment();
    }
}
