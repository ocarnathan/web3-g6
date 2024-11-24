// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    struct Voter {
        bool hasVoted;
        string voteToken;
    }

    address public admin;
    mapping(address => Voter) public voters;
    mapping(string => uint256) public votes;
    string[] public candidates;

    event VoterRegistered(address voter, string token);
    event VoteCasted(address voter, string candidate);

    constructor(string[] memory _candidates) {
        admin = msg.sender;
        candidates = _candidates;
    }
 

    //Only the admin can register voters
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Register a voter and assign a unique token (could be a random string)
    function registerVoter(address _voter, string memory _token) public onlyAdmin {
        require(!voters[_voter].hasVoted, "Voter has already voted");
        voters[_voter] = Voter(false, _token);
        emit VoterRegistered(_voter, _token);
    }

    // Voter casts their vote
    function castVote(string memory _candidate) public {
        Voter storage voter = voters[msg.sender];
        require(!voter.hasVoted, "You have already voted");
        require(bytes(voter.voteToken).length > 0, "You are not registered to vote");

        // Check if candidate exists
        bool validCandidate = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(_candidate))) {
                validCandidate = true;
                break;
            }
        }
        require(validCandidate, "Invalid candidate");

        // Cast vote
        votes[_candidate]++;
        voter.hasVoted = true;

        emit VoteCasted(msg.sender, _candidate);
    }

        // Get the total votes for a candidate
    function getVotes(string memory _candidate) public view returns (uint256) {
        return votes[_candidate];
    }
}