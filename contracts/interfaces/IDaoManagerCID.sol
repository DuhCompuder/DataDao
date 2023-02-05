// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

interface IDaoManagerCID {
    event addedNewCID(bytes cidraw, uint256 size);

    function checkProvider(bytes calldata cidraw, uint64 provider)
        external
        view
        returns (bool, int64);

    function addCID(bytes calldata cidraw, uint256 size) external;

    function authorizeData(
        bytes memory cidraw,
        uint64 provider,
        uint256 size,
        int64 lastClaimed
    ) external;
}
