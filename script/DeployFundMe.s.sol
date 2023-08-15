// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
/* 
    struct NetworkConfig {
        address priceFeed;
    } 
*/

    function run() external returns (FundMe) {

         // NetworkConfig memory networkConfig = NetworkConfig(helperConfig.activeNetworkConfig());
       // console.log("eth usd", networkConfig.priceFeed);

        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        // returns a variable from a struct with only one variable instead of ( x, )

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
