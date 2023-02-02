// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.13;
import {MarketAPI} from "@zondax/filecoin-solidity/contracts/v0.8/MarketAPI.sol";
import {CommonTypes} from "@zondax/filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";
import {MarketTypes} from "@zondax/filecoin-solidity/contracts/v0.8/types/MarketAPI.sol";
import "./IAMDataDao.sol";
import "./InstitutionDao.sol";

contract DaoManager {
    struct InstitutionInfo {
        string name;
        uint256 timeCreated;
        address[] members; //may not need
    }
    mapping(bytes => bool) public cidSet;
    mapping(bytes => uint256) public cidSizes;
    mapping(bytes => mapping(uint64 => bool)) public cidProviders;
    mapping(address => InstitutionInfo) public createdInstitutions;
    address[] public allInstitutions;

    event CreatedNewInstitution(
        address creator,
        uint256 timeCreated,
        string nameOfInstitution,
        address addressOfInstitution
    );

    function createNewInstitutionDAO(string name, address[] initialOwners)
        public
        returns (address institution)
    {
        InstitutionDAO institution = new InstitutionDAO(name, initialOwners);
        address memory addressCreated = address(institution);
        allInstitutions.push(addressCreatedAt);
        createdInstitutions(addressCreatedAt);
        emit CreatedNewInstitution(
            msg.sender,
            block.timestamp,
            name,
            addressCreatedAt
        );
        return addressCreatedAt;
    }

    function fund(uint64 unused) public payable {}

    function addCID(bytes calldata cidraw, uint256 size) public {
        require(msg.sender == owner);
        cidSet[cidraw] = true;
        cidSizes[cidraw] = size;
    }

    function policyOK(bytes memory cidraw, uint64 provider)
        internal
        view
        returns (bool)
    {
        bool alreadyStoring = cidProviders[cidraw][provider];
        return !alreadyStoring;
    }

    function authorizeData(
        bytes memory cidraw,
        uint64 provider,
        uint256 size
    ) public {
        require(cidSet[cidraw], "cid must be added before authorizing");
        require(cidSizes[cidraw] == size, "data size must match expected");
        require(
            policyOK(cidraw, provider),
            "deal failed policy check: has provider already claimed this cid?"
        );

        cidProviders[cidraw][provider] = true;
    }

    function claim_bounty(uint64 deal_id) public {
        MarketTypes.GetDealDataCommitmentReturn memory commitmentRet = MarketAPI
            .getDealDataCommitment(
                MarketTypes.GetDealDataCommitmentParams({id: deal_id})
            );
        MarketTypes.GetDealProviderReturn memory providerRet = MarketAPI
            .getDealProvider(MarketTypes.GetDealProviderParams({id: deal_id}));

        authorizeData(
            commitmentRet.data,
            providerRet.provider,
            commitmentRet.size
        );

        // get dealer (bounty hunter client)
        MarketTypes.GetDealClientReturn memory clientRet = MarketAPI
            .getDealClient(MarketTypes.GetDealClientParams({id: deal_id}));

        // send reward to client
        send(clientRet.client);
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

    // send 1 FIL to the filecoin actor at actor_id
    function send(uint64 actorID) internal {
        bytes memory emptyParams = "";
        delete emptyParams;

        uint256 oneFIL = 1000000000000000000;
        HyperActor.call_actor_id(
            METHOD_SEND,
            oneFIL,
            DEFAULT_FLAG,
            Misc.NONE_CODEC,
            emptyParams,
            actorID
        );
    }
}
