//SPDX-License-Identifier : MIT

pragma solidity ^0.8.26;

contract Lottery{
    address public manager;
    address[]  public players;

    constructor()public {
        manager= msg.sender;
    }

    function enterLottery()public payable{
        require(msg.value > 0.1 ether);
        players.push(msg.sender);
    }

    // function random() private view returns(uint){
    //     return uint(keccak256(block.difficulty, now, players));
    // }

    function random() private view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));
    }
    function pickWinner() public {
      
        uint index = random() % players.length;
        address payable winner = payable(players[index]);

        (bool success,) = winner.call{value:address(this).balance}("");
        players = new address[](0);
    }
    modifier restricted {
        require(msg.sender == manager);
        _;
    }
    function getPlayers ()public view returns (address[] memory){
        return players;

    }
  

}