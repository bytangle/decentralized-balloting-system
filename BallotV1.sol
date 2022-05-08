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
    Phase public state = Phase.Init;
}