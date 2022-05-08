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

    /** Gate Keeper */
    modifier onlyChairperson {
        require(chairperson == msg.sender);
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
}