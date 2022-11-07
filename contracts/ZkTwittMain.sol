// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ZkTwitt.sol";

interface IZkTwittERC20 is IERC20 {
}

contract ZktTwittMain {

    uint costPerLike;
    mapping(uint => uint) likesCountPerTweet;
    mapping(uint => address[]) likersPerTweet;
    IZkTwittERC20 zkTwit;  

    constructor (uint _costPerLike, address _zkTwittERC20) {
        costPerLike = _costPerLike;
        zkTwit = IZkTwittERC20(_zkTwittERC20);
    }

    function like(uint _tokenId) public {
        require(zkTwit.balanceOf(msg.sender) >= costPerLike, "not enough balance to pay for like");
        likesCountPerTweet[_tokenId]++;
        likersPerTweet[_tokenId].push(msg.sender);
    }


    function nbLike(uint _tokenId) public view returns (uint) {
        return likesCountPerTweet[_tokenId];
    }
}