// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ZkTwitt.sol";

interface IZkTwittERC20 is IERC20 {
}

contract ZktTwittMain {

    uint public costPerLike;
    uint public costOfTwitt;
    uint public priceOfToken;
    mapping(uint => uint) public likesCountPerTweet;
    mapping(uint => address[]) public likersPerTweet;
    mapping(uint=>address) public twitOwner
    IZkTwittERC20 public zkTwit;  

    constructor (uint _costPerLike, address _zkTwittERC20,_priceOfToken) {
        costPerLike = _costPerLike;
        zkTwit = IZkTwittERC20(_zkTwittERC20);
        priceOfToken=_priceOfToken
    }

//payable with the costPerLike
    function like(uint _twittId) public payable {
        require(zkTwit.balanceOf(msg.sender) >= costPerLike, "not enough balance to pay for like");
        //send few token to owner of twitt
        //get owner
        address owner=twitOwner[_twittId]
        zkTwit.transfer(owner,costPerLike/2);
        likesCountPerTweet[_twittId]++;
        likersPerTweet[_twittId].push(msg.sender);
    }
//priceOfToken
   function buyToken () public payable
   {
    uint256  paymentReceived=msg.value;
    uint256 amountToBeGiven=paymentReceived/priceOfToken;
    zkTwit.mint(msg.sender,amountToBeGiven);
  }


  function searchforTwittOwner(uint twitId){
    return  twitOwner[twitId];
  }

  function getAllTwitt(address user){
     return 
  }

    function nbLike(uint _twittId) public view returns (uint) {
        return likesCountPerTweet[_twittId];
    }
 
 //minting the nft
    function tweet() payable{
        //mint the nft
        //and return Id
    }
}