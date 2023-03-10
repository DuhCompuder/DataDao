// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "./IAMDataDao.sol";
import "./interfaces/IDaoManagerCID.sol";
import "./interfaces/IClaimReward.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {MarketAPI} from "../filecoin-solidity/contracts/v0.8/MarketAPI.sol";
import {MarketTypes} from "../filecoin-solidity/contracts/v0.8/types/MarketTypes.sol";
import {Actor} from "../filecoin-solidity/contracts/v0.8/utils/Actor.sol";
import {Misc} from "../filecoin-solidity/contracts/v0.8/utils/Misc.sol";

contract Institution is IAMDataDAO, IClaimReward {
    address constant CALL_ACTOR_ID = 0xfe00000000000000000000000000000000000005;
    uint64 constant METHOD_SEND = 0;
    using Counters for Counters.Counter;
    string public name;
    IDaoManagerCID managingDAO;

    struct DealIdentifer {
        uint64 dealID;
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
            memberOfDAO.push(owners[i]);
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
    function voteDealIdentifer(uint256 index, uint64 dealId)
        public
        reqAdmin(roleOfAccount[msg.sender])
    {
        require(docsForApproval[index].dealID == dealId, "voting for the wrong deal document");
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
    function registerNewDealIdentifer(string calldata title, uint64 deal_id)
        public
        reqRegistrants(roleOfAccount[msg.sender])
    {
        MarketTypes.GetDealDataCommitmentReturn memory commitmentRet = MarketAPI
            .getDealDataCommitment(deal_id);

        DealIdentifer memory newDoc;
        newDoc.dealID = deal_id;
        newDoc.title = title;
        newDoc.cid = commitmentRet.data;
        newDoc.cidSize = commitmentRet.size;
        newDoc.timeCreated = block.timestamp;

        docsForApproval[docsForApprovalCount.current()] = newDoc;
        docsForApprovalCount.increment();
    }

    // must check filecoin network to see if deal is added by miner
    function claim_bounty(uint64 deal_id) public {
        MarketTypes.GetDealDataCommitmentReturn memory commitmentRet = MarketAPI
            .getDealDataCommitment(deal_id);
        MarketTypes.GetDealProviderReturn memory providerRet = MarketAPI
            .getDealProvider(deal_id);

        (int64 start, ) = getDealTerms(deal_id);

        managingDAO.authorizeData(
            commitmentRet.data,
            providerRet.provider,
            commitmentRet.size,
            start
        );
    }

    function award_bounty(uint64 deal_id) public {
        MarketTypes.GetDealDataCommitmentReturn memory commitmentRet = MarketAPI
            .getDealDataCommitment(deal_id);
        MarketTypes.GetDealProviderReturn memory providerRet = MarketAPI
            .getDealProvider(deal_id);

        (bool isProvider, int64 lastClaimed) = managingDAO.checkProvider(
            commitmentRet.data,
            providerRet.provider
        );
        require(
            isProvider == true,
            "You do not have a claim on this deal bounty"
        );
        (int64 start, int64 end) = getDealTerms(deal_id);

        //update this eventually
        uint256 awardAmount = calculate_reward(start, end);
        // if (block.timestamp > end) {
        //     awardAmount = calculate_reward(lastClaimed, end);
        // } else {
        //     // awardAmount = calculate_reward(lastClaimed, int64(block.timestamp));
        // }

        // managingDAO
        // .cidProviders[commitmentRet.data][providerRet.provider]
        //     .lastClaimed = block.timestamp;

        // get dealer (bounty hunter client)
        MarketTypes.GetDealClientReturn memory clientRet = MarketAPI
            .getDealClient(deal_id);

        // send reward to client
        send(clientRet.client, awardAmount);
    }

    function calculate_reward(int64 start, int64 current)
        private
        pure
        returns (uint256)
    {
        //Do something to calculate duration and a multiple
        int64 duration = current - start;
        //0.2 FIL to the
        uint256 oneFIL = 200000000000000000;
        return oneFIL;
    }

    function call_actor_id(
        uint64 method,
        uint256 value,
        uint64 flags,
        uint64 codec,
        bytes memory params,
        uint64 id
    )
        public
        returns (
            bool,
            int256,
            uint64,
            bytes memory
        )
    {
        (bool success, bytes memory data) = address(CALL_ACTOR_ID).delegatecall(
            abi.encode(method, value, flags, codec, params, id)
        );
        (int256 exit, uint64 return_codec, bytes memory return_value) = abi
            .decode(data, (int256, uint64, bytes));
        return (success, exit, return_codec, return_value);
    }

    // send filecoin actor at actor_id

    function send(uint64 actorID, uint256 amount) private {
        bytes memory emptyParams = "";
        delete emptyParams;

        uint256 oneFIL = 200000000000000000;
        Actor.callByID(
            actorID,
            METHOD_SEND,
            Misc.NONE_CODEC,
            emptyParams,
            oneFIL,
            true
        );
    }

    function getDealTerms(uint64 deal_id) public returns (int64, int64) {
        MarketTypes.GetDealTermReturn memory providerRet = MarketAPI
            .getDealTerm(deal_id);
        return (providerRet.start, providerRet.end);
    }

    // function getDealTotalPrice(uint64 deal_id)
    //     public
    //     returns (MarketTypes.GetDealEpochPriceReturn memory)
    // {
    //     MarketTypes.GetDealEpochPriceReturn memory providerRet = MarketAPI
    //         .getDealTotalPrice(deal_id);
    //     return providerRet;
    // }
}
