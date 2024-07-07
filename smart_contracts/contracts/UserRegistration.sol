// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract UserRegistration {
    struct UserProfile {
        string name;
        address walletAddress;
        bool isVerified;
    }

    mapping(address => UserProfile) public users;

    event UserRegistered(address indexed user, string name, bool isVerified);

    modifier onlyNewUser() {
        require(users[msg.sender].walletAddress == address(0), "User already registered");
        _;
    }

    function registerUser(string memory _name) public onlyNewUser {
        users[msg.sender] = UserProfile({
            name: _name,
            walletAddress: msg.sender,
            isVerified: false
        });

        emit UserRegistered(msg.sender, _name, false);
    }

    function verifyUser(address _userAddress) public {
        require(msg.sender == _userAddress, "Verification can only be performed by the user.");
        users[_userAddress].isVerified = true;
        emit UserRegistered(_userAddress, users[_userAddress].name, true);
    }
}