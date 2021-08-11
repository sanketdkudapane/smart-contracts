pragma solidity ^0.4.21;

contract Election {
    
    struct Candidate{
        string name;
        uint voteCount;  
    }
    
    struct Voter {
        bool isAuthorized;
        bool voted;
        uint vote;  //whom to vote
    }
    
    address public owner;
    string public electionName;
    uint public winnerCandidate;
    mapping(address => Voter) public voters; 
    Candidate[] public candidates;
    uint public totalVotes;
    
    modifier ownerOnly(){
        require(msg.sender == owner);
        _;      //remaining body of addCandidate
    }
    
    function Election(string _electionName) public {
        owner = msg.sender;
        electionName = _electionName;
        totalVotes = 0;
    }
    
    //to add candidate only by owner
    function addCandidate(string _name) ownerOnly public {
        candidates.push((Candidate(_name, 0)));
    }
    
    //get count of candidates
    function getNumCandidate() public view returns(uint) { 
        return candidates.length;
    }
    
    //to authorize voter only by owner
    function authorize(address _voter) ownerOnly public {
        voters[_voter].isAuthorized = true;
    }
    
    //to cast vote only if authorized by owner(election commission)
    function vote(uint _candidateIndex) public {
        require(voters[msg.sender].voted == false);
        require(voters[msg.sender].isAuthorized == true);
        
        voters[msg.sender].vote = _candidateIndex;
        voters[msg.sender].voted = true;
        
        candidates[_candidateIndex].voteCount += 1;
        totalVotes += 1;
    }
    
    //update winnerCandidate 
    function getWinner() public returns(uint){
        uint max = 0;
        for(uint i = 0; i < candidates.length; i++)
            if(candidates[i].voteCount > max) 
            {
                max = candidates[i].voteCount;
                winnerCandidate = i;
            }
         return winnerCandidate;
    }
    
    //end the election
    function end() ownerOnly public {
        selfdestruct(owner);
    }
    
}
