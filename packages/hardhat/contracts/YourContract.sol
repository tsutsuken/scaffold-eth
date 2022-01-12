pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is ChainlinkClient {
    event SetPurpose(address sender, string purpose);

    using Chainlink for Chainlink.Request;

    uint256 public volume;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    AggregatorV3Interface internal priceFeed;
    string public purpose = "Building Unstoppable Apps!!!";
    uint256 public count = 0;

    constructor() {
        /**
         * Network: Kovan
         * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel
         * Node)
         * Job ID: d5270d1c311941d0b08bead21fea7747
         * Fee: 0.1 LINK
         */
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10**18; // (Varies by network and job)

        /**
         * Aggregator: ETH/USD
         * Address_Rinkeby: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
         * Address_Kovan: 0x9326BFA02ADD2366b30bacB125260Af641031331
         */
        priceFeed = AggregatorV3Interface(
            0x9326BFA02ADD2366b30bacB125260Af641031331
        );
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Set the URL to perform the GET request on
        request.add(
            "get",
            "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD"
        );

        // Set the path to find the desired data in the API response, where the response format is:
        // {"RAW":
        //   {"ETH":
        //    {"USD":
        //     {
        //      "VOLUME24HOUR": xxx.xxx,
        //     }
        //    }
        //   }
        //  }
        request.add("path", "RAW.ETH.USD.VOLUME24HOUR");

        // Multiply the result by 1000000000000000000 to remove decimals
        int256 timesAmount = 10**18;
        request.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract

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
