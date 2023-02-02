// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
import { MarketAPI } from "../filecoin-solidity/contracts/v0.8/MarketAPI.sol";
import { CommonTypes } from "../filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";
import { MarketTypes } from "../filecoin-solidity/contracts/v0.8/types/MarketTypes.sol";
// import { Actor, HyperActor } from "../filecoin-solidity/contracts/v0.8/utils/Actor.sol";
import { Misc } from "../../filecoin-solidity/contracts/v0.8/utils/Misc.sol";
import "./IAMDataDao.sol";
import "./InstitutionDao.sol";

contract DaoManager {
    struct InstitutionInfo {
        string name;
        uint256 timeCreated;
        bool usesManager;
        address[] members; //may not need
    }

    mapping(bytes => bool) public cidSet;
    mapping(bytes => uint256) public cidSizes;
    mapping(bytes => mapping(uint64 => bool)) public cidProviders;

    mapping(address => InstitutionInfo) public createdInstitutions;
    address[] public allInstitutions;

    modifier isManagedInstitution() {
        require(
            createdInstitutions[msg.sender].usesManager == true,
            "This institution or organization is not created or registered on the DAO"
        );
        _;
    }

    event CreatedNewInstitution(
        address creator,
        uint256 timeCreated,
        string nameOfInstitution,
        address addressOfInstitution
    );

    function createNewInstitutionDAO(string memory name, address[] memory initialOwners)
        public
        returns (address)
    {

        Institution institution = new Institution(
            name,
            initialOwners,
            this
        );
        address addressCreated = address(institution);
        allInstitutions.push(addressCreated);
        createdInstitutions[addressCreated].name = name;
        createdInstitutions[addressCreated].timeCreated = block.timestamp;
        createdInstitutions[addressCreated].usesManager = true;
        createdInstitutions[addressCreated].members = initialOwners;

        emit CreatedNewInstitution(
            msg.sender,
            block.timestamp,
            name,
            addressCreated
        );
        return addressCreated;
    }

    function addCID(bytes calldata cidraw, uint256 size)
        public
        isManagedInstitution
    {
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

    // Bounty Hunters
    function authorizeData(
        bytes memory cidraw,
        uint64 provider,
        uint256 size
    ) internal {
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
        // send(clientRet.client);
    }

    // function call_actor_id(
    //     uint64 method,
    //     uint256 value,
    //     uint64 flags,
    //     uint64 codec,
    //     bytes memory params,
    //     uint64 id
    // )
    //     public
    //     returns (
    //         bool,
    //         int256,
    //         uint64,
    //         bytes memory
    //     )
    // {
    //     (bool success, bytes memory data) = address(CALL_ACTOR_ID).delegatecall(
    //         abi.encode(method, value, flags, codec, params, id)
    //     );
    //     (int256 exit, uint64 return_codec, bytes memory return_value) = abi
    //         .decode(data, (int256, uint64, bytes));
    //     return (success, exit, return_codec, return_value);
    // }

    // send 1 FIL to the filecoin actor at actor_id
    // function send(uint64 actorID) internal {
    //     bytes memory emptyParams = "";
    //     delete emptyParams;

    //     uint256 oneFIL = 1000000000000000000;
    //     HyperActor.call_actor_id(
    //         METHOD_SEND,
    //         oneFIL,
    //         DEFAULT_FLAG,
    //         Misc.NONE_CODEC,
    //         emptyParams,
    //         actorID
    //     );
    // }
}
