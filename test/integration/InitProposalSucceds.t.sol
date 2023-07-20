// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@forge-std/Test.sol";

import {Proposal} from "@test/proposals/proposalTypes/Proposal.sol";
import {Addresses} from "@test/proposals/Addresses.sol";
import {TestProposals} from "@test/proposals/TestProposals.sol";
import {Configs} from "@test/proposals/Configs.sol";
import {TemporalGovernor} from "@protocol/core/Governance/TemporalGovernor.sol";

/// validate the deployment on sepolia testnet
contract InitProposalSucceedsTest is Test {
    TestProposals proposals;
    Addresses addresses;
    // bytes constant data = hex"01000000000100223bac66ef9d27d85c26fd7c48fc4a5c2e6f818527ce675eadc840224580e22f73d4fea79092fc494271c200e6497a5e87e53e13fcb3846c369ea141def14c4a0164aedbbc00000002000200000000000000000000000029353c2e5dcdf7de3c92e81325b0c54cb451750e0000000000000005c80000000000000000000000000e173860e6f80c735f5dfe6354c9ee4ae5dc60e1000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000500000000000000000000000031678ab506a672453d1235040a6ad1776db75e1d000000000000000000000000d3bc55237fea3f11643c95e766358484582f466a000000000000000000000000da150f475da060c59554dfbed16c6c53991a28ca000000000000000000000000682e7b16c21fe5b8f4e578da90870347f181fb3c000000000000000000000000bf08a960b7443e971ea9a0173b95fe31e946f611000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000001e000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000004e9c714f2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044095ea7b3000000000000000000000000682e7b16c21fe5b8f4e578da90870347f181fb3c00000000000000000000000000000000000000000000000000000000000f4240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044095ea7b3000000000000000000000000bf08a960b7443e971ea9a0173b95fe31e946f6110000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024a0712d6800000000000000000000000000000000000000000000000000000000000f4240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024a0712d680000000000000000000000000000000000000000000000000de0b6b3a764000000000000000000000000000000000000000000000000000000000000";

    function setUp() public {
        proposals = new TestProposals();
        proposals.setUp();
        proposals.setDebug(true);
        addresses = proposals.addresses();

        console.log("chainid: ", block.chainid);
    }

    function testInitProposalSucceeds() public {
        Configs(address(proposals.proposals(0))).init(addresses); /// init configs
        proposals.testProposals(true, false, false, true, true, false, false);
        proposals.printCalldata(0, addresses.getAddress("TEMPORAL_GOVERNOR"), addresses.getAddress("WORMHOLE_CORE")); /// print calldata out
    }

    function testDeployAfterDeployBuildRunValidateProposalSucceeds() public {
        proposals.testProposals(true, true, true, true, true, false, true);
    }

    function testValidateSucceeds() public {
        testInitProposalSucceeds();

        /// validate mip 00 after gov proposal succeeds
        /// moonbeam timelock corresponds to EOA owner on sepolia testnet
        proposals.proposals(0).validate(addresses, addresses.getAddress("MOONBEAM_TIMELOCK"));
    }

    function testBuildProcessRequestSucceeds() public view {
        console.log("queueProposal: ");
        console.logBytes(abi.encodePacked(TemporalGovernor.queueProposal.selector));

        console.log("executeProposal: ");
        console.logBytes(abi.encodePacked(TemporalGovernor.executeProposal.selector));

        // console.log("sepolia data: ");
        // console.logBytes(abi.encodePacked(TemporalGovernor.executeProposal.selector, data));
        // console.logBytes(data);
    }

    // function testRawVaaCallSucceeds() public {
    //     TemporalGovernor gov = TemporalGovernor(addresses.getAddress("TEMPORAL_GOVERNOR"));
    //     vm.startPrank(0x29353c2e5dCDF7dE3c92E81325B0C54Cb451750E);
    //     gov.queueProposal(data);
    //     vm.warp(gov.proposalDelay() + block.timestamp);
    //     gov.executeProposal(data);
    // }
}