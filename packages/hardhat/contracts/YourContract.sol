pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract {
    event SetPurpose(address sender, string purpose);

    AggregatorV3Interface internal priceFeed;
    string public purpose = "Building Unstoppable Apps!!!";
    uint256 public count = 0;

    /**
     * Network: Rinkeby
     * Aggregator: ETH/USD
     * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
     */
    constructor() {
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    /**
     * Returns the latest price
     */
    function getLatestEthPrice()
        public
        view
        returns (
            string memory,
            uint8,
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        string memory description = priceFeed.description();
        uint8 decimals = priceFeed.decimals();
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        return (
            description,
            decimals,
            roundID,
            price,
            startedAt,
            timeStamp,
            answeredInRound
        );
    }

    function setPurpose(string memory newPurpose) public {
        purpose = newPurpose;
        console.log(msg.sender, "set purpose to", purpose);
        emit SetPurpose(msg.sender, purpose);
    }

    function setCount(uint256 newCount) public {
        count = newCount;
        console.log(msg.sender, "set count to", newCount);
    }
}
