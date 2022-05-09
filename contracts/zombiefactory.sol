pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ZombieFactory is Ownable {
    //start here
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    event NewZombie(uint256 _zombieId, string _name, uint256 _dna);

    uint256 cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 loss
    }

    Zombie[] public zombies;

    mapping(address => uint256) public zombieToOwner;

    mapping(uint256 => address) ownerZombieCount;

    function _createZombies(string memory _name, uint256 _dna) internal {
        // zombies.push(Zombie(_name, _dna));

        uint256 id = zombies.push(
            Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)
        ) - 1;

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);

        uint256 randDna = _generateRandomDna(_name);
        _createZombies(_name, randDna);
    }
}
