// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract DecentralizedVotingPlatform{
    address public admin_;
    bool public votingOpen_;
    uint public candidatesCount;
    uint public votersCount=0;
     
     constructor(){
          admin_=msg.sender;
          candidatesCount=0;
     }

     struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedCandidateId;
     }

     struct Candidate {
        string name;
        uint voteCount;
        bool isRegistered;
        uint id;
      }

     mapping (address=> Voter) public  voters;
     mapping (uint => Candidate) public  candidates;
     
     uint[] private  candidateIDs;
     
    //  Events
    event VoterRegistered(address indexed voter);
    event CandidateRegisterd(address indexed candidate, string indexed _name);
    event Voted(uint indexed  candidate, address indexed  voter );

    //  modifers

    modifier  OnlyAdmin(){
        require(admin_== msg.sender, "Not the Admin");
        _;
    }

    // // function register voters
    
    function registerVoters(address _voter) public OnlyAdmin{
        require(_voter != address(0), "Invalid voter");
        require(!voters[_voter].isRegistered, "Voter Register already");
         votersCount++;
         voters[_voter]= Voter({
            isRegistered: true,
            hasVoted:false,
            votedCandidateId:0
         });

        emit VoterRegistered(_voter);
    }

        // register a candidate

    function registerCandidate(address _candidateAddress,uint _candidateID, string memory _name) public OnlyAdmin{

         require(_candidateAddress != address(0), "Invalid address");
         require(!candidates[_candidateID].isRegistered, "Already registerd");

        candidatesCount++;
        candidateIDs.push(_candidateID);
        candidates[_candidateID]=Candidate({
            name:_name,
            voteCount:0,
            isRegistered:true,
            id:_candidateID
        });

      
      emit CandidateRegisterd(_candidateAddress,_name);
    }


    //  vote
    function vote(uint _candidateId) public {
       require(votingOpen_, "Voting is not yet open");
       require(voters[msg.sender].isRegistered == true, "You are not eligible to vote");
       require(voters[msg.sender].hasVoted == false, "You can't vote twice");
       require(candidates[_candidateId].isRegistered, "Your Candidate is not on the ballot");
      
        candidates[_candidateId].voteCount += 1;
        voters[msg.sender].hasVoted=true;
        voters[msg.sender].votedCandidateId=_candidateId; 
    }

    function setVoting() public OnlyAdmin{
       votingOpen_= !votingOpen_; 
    }

    // function view result

    function viewResult() public view  returns (Candidate[] memory canditates_) {
        canditates_=new Candidate[](candidatesCount);

        for(uint8 i =1 ; i <= candidatesCount; i++){
            canditates_[i - 1] = candidates[i];
        }

        return  canditates_;
    }

    
}
