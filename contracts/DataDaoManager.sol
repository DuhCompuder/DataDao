// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
import "./IAMDataDao.sol";
import "./InstitutionDao.sol";
import "./interfaces/IDaoManagerCID.sol";
import "./interfaces/IClaimReward.sol";
import "./interfaces/IManageInstitutionOnDao.sol";

contract DaoManager is IDaoManagerCID {
    struct CidInfo {
        bool cidSet;
        uint256 cidSizes;
        address fromInstitution;
    }
    struct ProviderInfo {
        bool isProvider;
        int64 lastClaimed;
    }
    mapping(address => address[]) public registeredInstitutions;
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

    function getAllInstitutionCount() public view returns (uint256) {
        return allInstitutions.length;
    }

    function getInstitutionRegisteredToCount(address user)
        public
        view
        returns (uint256)
    {
        return registeredInstitutions[user].length;
    }

    function setInstitutionRegisteredTo(address user, address institution)
        public
        isManagedInstitution
    {
        require(
            IManageInstitutionOnDao(institution).getRoleNum(
                IManageInstitutionOnDao(institution).roleOfAccount(user)
            ) > 0,
            "Member already registered"
        );
        registeredInstitutions[user].push(user);
    }

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

    function checkProvider(bytes calldata cidraw, uint64 provider)
        public
        view
        override
        returns (bool, int64)
    {
        return (
            cidProviders[cidraw][provider].isProvider,
            cidProviders[cidraw][provider].lastClaimed
        );
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
        int64 startTime
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
        institution.award_bounty(deal_id);
    }
}
