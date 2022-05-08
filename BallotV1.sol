pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    address chairperson;
    
    struct Voter {
        uint vote;
        bool voted;
        uint weight;
    }

    struct Proposal {
        uint voteCount;
    }

    mapping(address => Voter) voters;
    Proposal[] proposals;

    enum Phase {Init, Regs, Vote, Done};
    Phase private state = Phase.Init;

    /** Gate Keepers */
    modifier onlyChairperson {
        require(chairperson == msg.sender);
        _;
    }

    modifier validPhase(Phase phase) {
        require(state == phase);
        _;
    }

    modifier validProposal(uint proposalIndex) {
        require(proposalIndex < proposals);
        _;
    }

    modifier hasNotVoted(address voter) {
        require(!voters[voter].voted);
        _;
    }

    modifier onlyVoter(address voter) {
        _;
    }

    constructor(uint _proposals) public {
        chairperson = msg.sender; // Contract deployer is the admin
        voters[chairperson].weight = 2; // Chairperson has the highest vote weight

        /** Initial Proposals */
        for(uint proposal = 0; proposal < _proposals; proposal++) {
            proposals.push(Proposal(0)); // Create proposal and save it in the proposals array
        }
    }

    function changePhase(Phase phase) public onlyChairperson {
        if(msg.sender != chairperson) { revert(); } /** Revert if entity calling this function isn't the chairperson */
        if(x < state) { revert(); } /** State transition allowed : 0 -> 1 -> 2 -> 3 */

        state = phase;
    }

    function register(address voter) public onlyChairperson validPhase(Phase.Regs) hasNotVoted(voter) {
        voters[voter].weight = 1;
        voters[voter].voted = false;
    }

    function vote(uint proposal) public onlyVoter validPhase(Phase.Vote) validProposal(proposal) hasNotVoted(msg.sender) returns (bool) {
        Voter memory voter = voters[msg.sender];
        voter.voted = true;
        voter.vote = proposal;
        proposals[proposal].voteCount += voter.weight;

        return true;
    }

    function requestWinner() public validPhase(Phase.Done) view returns (uint winningProposal, uint voteCount) {
        voteCount = 0;
        
        for(unit proposal = 0; proposal < proposals.length; proposal++) {
            if(proposals[proposal].voteCount > voteCount) {
                voteCount = proposals[proposal].voteCount;
                winningProposal = proposal;
            }
        }
    }
}