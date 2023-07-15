// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/murky/Merkle.sol";

interface HW0 {
    function solved2(address) external returns (bool);
    function merkleProof(bytes32[] memory proof) external;
}

contract HW0Test is Test {
    HW0 constant hw0 = HW0(0x5c561Afb29903D14B17B8C5EA934D6760C882b7d);
    uint256 privateKey = vm.envUint("PRIVATE_KEY");
    address player = vm.envAddress("ADDRESS");

    function setUp() public {}

    function testMerkleProof() public {
        vm.startPrank(player);
        hw0.merkleProof(getProof(0));
        vm.stopPrank();
    }

    function getProof(uint256 node) internal returns (bytes32[] memory) {
        Merkle m = new Merkle();
        bytes32[] memory data = new bytes32[](10);
        data[0] = keccak256(abi.encodePacked("zkplayground"));
        data[1] = keccak256(abi.encodePacked("zkpapaya"));
        data[2] = keccak256(abi.encodePacked("zkpeach"));
        data[3] = keccak256(abi.encodePacked("zkpear"));
        data[4] = keccak256(abi.encodePacked("zkpersimmon"));
        data[5] = keccak256(abi.encodePacked("zkpineapple"));
        data[6] = keccak256(abi.encodePacked("zkpitaya"));
        data[7] = keccak256(abi.encodePacked("zkplum"));
        data[8] = keccak256(abi.encodePacked("zkpomegranate"));
        data[9] = keccak256(abi.encodePacked("zkpomelo"));
        assertEq(m.getRoot(data), 0x8d798c5764a164492f1c8850246fdd11750bd2bffd8f42356150ae85a2b5469e);

        bytes32[] memory proof = m.getProof(data, node);
        return proof;
    }
}
