// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Voter {
        bool hasVoted;
        string voteToken;
    }

    address public admin;
    mapping(address => Voter) public voters;
    mapping(string => uint256) public votes;
    mapping(string => bool) public candidateExists;  // Using a mapping for faster lookups
    string[] public candidates;

    // Maintain an array of registered voter addresses
    address[] public registeredVoters;

    event VoterRegistered(address voter, string token);
    event VoteCasted(address voter, string candidate);

    constructor(string[] memory _candidates) {
        admin = msg.sender;
        candidates = _candidates;
        
        // Populating the candidateExists mapping for faster lookups
        for (uint i = 0; i < _candidates.length; i++) {
            candidateExists[_candidates[i]] = true;
        }
    }

    // Only the admin can register voters
    // modifier onlyAdmin() {
    //     require(msg.sender == admin, "Only admin can call this function");
    //     _;
    // }

    // Register a voter and assign a unique token (could be a random string)
    function registerVoter(address _voter, string memory _token) public {
        require(!voters[_voter].hasVoted, "Voter has already voted");

        // Prevent registering the same voter more than once
        for (uint i = 0; i < registeredVoters.length; i++) {
            require(registeredVoters[i] != _voter, "Voter is already registered");
        }

        // Add voter to the registeredVoters array
        voters[_voter] = Voter(false, _token);
        registeredVoters.push(_voter);

        emit VoterRegistered(_voter, _token);
    }

    // Voter casts their vote
    function castVote(address _voter, string memory _token, string memory _candidate) public {
    Voter storage voter = voters[_voter];  // Use the provided address instead of msg.sender
    require(!voter.hasVoted, "You have already voted");
    require(keccak256(bytes(voter.voteToken)) == keccak256(bytes(_token)), "Invalid token");
    require(candidateExists[_candidate], "Invalid candidate");

    // Cast the vote
    votes[_candidate]++;
    voter.hasVoted = true;

    emit VoteCasted(_voter, _candidate);
    }

    // function castVote(string memory _candidate, string memory _voteToken) public {
    //     Voter storage voter = voters[msg.sender];

    //     // Ensure voter is registered and has not voted yet
    //     require(bytes(voter.voteToken).length > 0, "You are not registered to vote");
    //     require(keccak256(bytes(voter.voteToken)) == keccak256(bytes(_voteToken)), "Invalid token");
    //     require(!voter.hasVoted, "You have already voted");

    //     // Ensure the candidate is valid
    //     require(candidateExists[_candidate], "Invalid candidate");

    //     // Cast vote
    //     votes[_candidate]++;
    //     voter.hasVoted = true;

    //     emit VoteCasted(msg.sender, _candidate);
    // }

    // Get the total votes for a candidate
    function getVotes(string memory _candidate) public view returns (uint256) {
        return votes[_candidate];
    }

    // Get the list of candidates
    function getCandidates() public view returns (string[] memory) {
        return candidates;
    }

    // Get the list of registered voters
    function getRegisteredVoters() public view returns (address[] memory) {
        return registeredVoters;
    }
}
