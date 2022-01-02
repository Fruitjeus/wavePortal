// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves; // State Variable, defaults 0

    // Random number gen
    uint256 private seed;

    // To store into the blockchain
    event NewWave(address indexed from, uint256 timestamp, string message);
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }
    // Holds all waves
    Wave[] waves;
    
    // Stores address with the last time the user waved.
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        // Set seed
        seed = (block.timestamp + block.difficulty) % 100;
    }
    function wave(string memory _message) public {
        // requires atleast 15min
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Waved within 15m"
        );
        lastWavedAt[msg.sender] = block.timestamp; // update last time

        totalWaves += 1;
        console.log("%s has waved!", msg.sender); // wallet address of triggerer
        //Store the wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // 50% chance to giff ETH
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        // Emit NewWave, which stores sender address, timestamp and message
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
    
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}