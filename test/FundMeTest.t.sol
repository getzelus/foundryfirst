// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from '../src/FundMe.sol';
import {DeployFundMe} from '../script/DeployFundMe.s.sol';

contract FundMeTest is Test {

    uint256 number = 4;
    FundMe fundMe;
    address USER = makeAddr('user');
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    // for each test function this setUp first and one function at a time
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testDemo() public {
        console.log("hello", number);
        assertEq(number, 4);
    }

     modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

 

    function testMinimumDollarIsFive() public{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public{
       // assertEq(fundMe.i_owner(), address(this));
        //FundMeTest contract is the owner and not us msg.sender
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testVersion() public{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); // should revert after 

        fundMe.fund();
    }

    function testFundUpdates() public funded {
        uint256 amoundFunded = fundMe.getAddressToAmoundFunded(USER);
        assertEq(amoundFunded, SEND_VALUE);
    }

    function testAddsFunder() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {

        vm.prank(USER); // the next tx will be made by USER
        vm.expectRevert();
        fundMe.withdraw();
    }
}