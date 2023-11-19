//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

contract Ballot {
    // The address which deployed the contract, who is also the chairperson in this context
    address chairperson;

    /**
     * Each user that register gets mapped to a Voter struct that specifies:
     * - weight: The weight of this users' vote
     * - voted: Indicates if the user has already voted or not
     * - vote: To whom they have voted for
     */
    struct Voter {
        uint256 weight;
        bool voted;
        uint256 vote;
    }

    /**
     * The following Proposal struct that keeps track of:
     * - voteCount: The number of votes that were receieved for this specific proposal
     */
    struct Proposal {
        uint256 voteCount;
    }

    // Mapping user address to a Voter struct
    mapping(address => Voter) voters;

    // An array of Proposal struct
    Proposal[] proposals;

    /**
     * Makes sure that the user calling a function was the chairperson
     */
    modifier onlyChair() {
        require(
            msg.sender == chairperson,
            "Access Denied: user is not the chairperson!"
        );
        _;
    }

    /**
     * Makes sure that the user calling a function was a registered voter
     */
    modifier validVoter() {
        require(
            voters[msg.sender].weight > 0,
            "Access Denied: Not a Registered Voter!"
        );
        _;
    }

    /**
     * Makes sure that the user calling a function has not registered before
     */
    modifier validRegistrant() {
        require(
            voters[msg.sender].weight == 0,
            "Access Denied: User has been registered already!"
        );
        _;
    }

    constructor(uint256 numProposals) {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // weight 2 for testing purposes
        for (uint256 prop = 0; prop < numProposals; prop++) {
            proposals.push(Proposal(0));
        }
    }

    function register() public validRegistrant {
        voters[msg.sender].weight = 1;
        voters[msg.sender].voted = false;
    }

    function vote(uint256 toProposal) public validVoter {
        Voter storage sender = voters[msg.sender];

        require(!sender.voted, "Vote Denied: This user has already casted a vote!");
        require(toProposal < proposals.length, "Invalid Vote: The vote proposal entered is invalid!");

        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    function reqWinner() public view returns (uint256 winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint256 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                winningProposal = prop;
            }
        assert(winningVoteCount >= 3);
    }
}