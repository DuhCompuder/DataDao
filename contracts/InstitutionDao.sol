// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "./IAMDataDao.sol";
import "./interface/IDaoManagerCID.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Institution is IAMDataDAO {
    using Counters for Counters.Counter;
    string public name;
    IDaoManagerCID managingDAO;

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
        address[] memory owners,
        IDaoManagerCID _managingDao
    ) {
        name = _name;
        managingDAO = _managingDao;
        for (uint256 i = 0; i < owners.length; i++) {
            roleOfAccount[owners[i]] = ROLES.OWNERS;
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
            docsForApproval[index].voteCount > 0,
            "Does not meet minimum vote count for approval"
        );
        docsForApproval[index].approved = true;
        managingDAO.addCID(
            docsForApproval[index].cid,
            docsForApproval[index].cidSize
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

    // function getDealTerm(uint64 dealID) internal returns (MarketTypes.GetDealTermReturn memory) {
    //     bytes memory raw_request = dealID.serializeDealID();

    //     bytes memory raw_response = Actor.call(
    //         MarketTypes.GetDealTermMethodNum,
    //         MarketTypes.ActorID,
    //         raw_request,
    //         Misc.CBOR_CODEC,
    //         msg.value,
    //         true
    //     );

    //     bytes memory result = Actor.readRespData(raw_response);

    //     return result.deserializeGetDealTermReturn();
    // }

    // /// @return the per-epoch price of a deal proposal.
    // function getDealTotalPrice(uint64 dealID) internal returns (MarketTypes.GetDealEpochPriceReturn memory) {
    //     bytes memory raw_request = dealID.serializeDealID();

    //     bytes memory raw_response = Actor.call(
    //         MarketTypes.GetDealEpochPriceMethodNum,
    //         MarketTypes.ActorID,
    //         raw_request,
    //         Misc.CBOR_CODEC,
    //         msg.value,
    //         true
    //     );

    //     bytes memory result = Actor.readRespData(raw_response);

    //     return result.deserializeGetDealEpochPriceReturn();
    // }
}
