//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.4.22 <0.9.0;

contract Counter {
    // The value of the counter
    int256 value;

    // The address which deployed the contract
    address private contractDeployer;

    // Contains all phases of counter
    enum CounterPhases {
        Uninitialized,
        Initialized
    }

    // Initial counterPhase is Uninitialized
    CounterPhases private counterPhase = CounterPhases.Uninitialized;

    /**
     * Makes sure that the user calling a function was the contractDeployer
     */
    modifier onlyDeployer(address userAddress) {
        require(
            contractDeployer == userAddress,
            "Access Denied: user is not the contract deployer!"
        );
        _;
    }

    /**
     * This validates that counterPhase is at Initialized
     */
    modifier InitializedPhase() {
        require(
            counterPhase == CounterPhases.Initialized,
            "Access Denied: counterPhase is not at Initialized!"
        );
        _;
    }

    constructor() {
        contractDeployer = msg.sender;
    }

    function initialize(int256 x) public onlyDeployer(msg.sender) {
        value = x;
        counterPhase = CounterPhases.Initialized;
    }

    function get() public view InitializedPhase returns (int256) {
        return value;
    }

    function increment(int256 n) public InitializedPhase {
        value = value + n;
    }

    function decrement(int256 n) public InitializedPhase {
        value = value - n;
    }
}

