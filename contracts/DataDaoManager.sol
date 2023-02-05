// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
import "./IAMDataDao.sol";
import "./InstitutionDao.sol";
import "./interface/IDaoManagerCID.sol";
import "./interface/IClaimReward.sol";

contract DaoManager is IDaoManagerCID {
    struct CidInfo {
        bool cidSet;
        uint256 cidSizes;
        address fromInstitution;
    }
    struct ProviderInfo {
        bool isProvider;
        uint64 lastClaimed;
    }
    mapping(bytes => CidInfo) public cidInfo;
    mapping(bytes => mapping(uint64 => ProviderInfo)) public cidProviders;

    mapping(address => bool) public createdInstitutions;
    address[] public allInstitutions;

    modifier isManagedInstitution() {
        require(
            createdInstitutions[msg.sender] == true,
            "This institution is not registered on the DAO"
        );
        _;
    }

    event CreatedNewInstitution(
        address creator,
        uint256 timeCreated,
        string nameOfInstitution,
        address addressOfInstitution
    );

    function createNewInstitutionDAO(
        string memory name,
        address[] memory initialOwners
    ) public returns (address) {
        Institution institution = new Institution(name, initialOwners, this);
        address addressCreated = address(institution);
        allInstitutions.push(addressCreated);
        createdInstitutions[addressCreated] = true;

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
        cidInfo[cidraw].cidSet = true;
        cidInfo[cidraw].cidSizes = size;
        emit addedNewCID(cidraw, size);
    }

    function policyOK(bytes memory cidraw, uint64 provider)
        internal
        view
        returns (bool)
    {
        bool alreadyStoring = cidProviders[cidraw][provider].isProvider;
        return !alreadyStoring;
    }

    // Bounty Hunters
    function authorizeData(
        bytes memory cidraw,
        uint64 provider,
        uint256 size,
        uint64 startTime
    ) public isManagedInstitution {
        require(cidInfo[cidraw].cidSet, "cid must be added before authorizing");
        require(
            cidInfo[cidraw].cidSizes == size,
            "data size must match expected"
        );
        require(
            policyOK(cidraw, provider),
            "deal failed policy check: has provider already claimed this cid?"
        );

        cidProviders[cidraw][provider].isProvider = true;
        cidProviders[cidraw][provider].lastClaimed = startTime;
    }

    function claimBounty(uint64 deal_id) public {
        MarketTypes.GetDealDataCommitmentReturn memory commitmentRet = MarketAPI
            .getDealDataCommitment(deal_id);
        IClaimReward institution = IClaimReward(
            cidInfo[commitmentRet.data].fromInstitution
        );
        institution.claim_bounty(deal_id);
    }

    function claimRewardFromBounty(uint64 deal_id) public {
        MarketTypes.GetDealDataCommitmentReturn memory commitmentRet = MarketAPI
            .getDealDataCommitment(deal_id);
        IClaimReward institution = IClaimReward(
            cidInfo[commitmentRet.data].fromInstitution
        );
        institution.claim_reward(deal_id);
    }
}
