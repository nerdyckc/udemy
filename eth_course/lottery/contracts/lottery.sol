pragma solidity ^0.4.24;

contract Lottery {
    address public manager;     // only the manager can invoke pickWinner function
    address[] public players;

    constructor() public {
        manager = msg.sender;
    }

    function enter() public payable {
        // msg is a global variable
        require(msg.value > .01 ether);

        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        // hashing algorithm which returns a hash, the hash is turned into unsigned integer
        return uint(keccak256(block.difficulty, now, players));
    }
    
    function pickWinner() public restricted {
        uint index = random() % players.length;
        // transfer entire balance in contract to selected player
        players[index].transfer(this.balance);
        players = new address[](0); // dynamic array with initial size of zero
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;      // run rest of the code in target function
    }
}
