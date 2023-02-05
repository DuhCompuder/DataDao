// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

interface IClaimReward {
    function claim_bounty(uint64 deal_id) external;

    function award_bounty(uint64 deal_id) external;
}
