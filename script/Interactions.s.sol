//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeploed) public {
        vm.startBroadcast();

        FundMe(payable(mostRecentlyDeploed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();

        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external returns (address) {
        // Here it looks in the broadcast folder
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();

        fundFundMe(mostRecentDeployment);
        vm.stopBroadcast();

        return mostRecentDeployment;
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeploed) public {
        vm.startBroadcast();

        FundMe(payable(mostRecentlyDeploed)).withdraw();
        vm.stopBroadcast();

        console.log("Withdraw");
    }

    function run() external {
        // Here it looks in the broadcast folder
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();

        withdrawFundMe(mostRecentDeployment);
        vm.stopBroadcast();
    }
}
