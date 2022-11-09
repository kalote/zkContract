// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "hardhat/console.sol";

interface IZkTwittERC20 is IERC20 {

    function mint(address to, uint256 amount) external;

    function burnFrom(address from, uint256 amount) external;
}


interface IZkTwittERC721 is IERC721 {
    function safeMint(address to, uint256 tokenId) external;
}


contract ZktTwittMain {

    uint priceOfToken = 2;
    uint costPerLike;
    uint costPerTweet;
    mapping(uint => uint) likesCountPerTweet;
    mapping(uint => address[]) likersPerTweet;
    IZkTwittERC20 zkTwitERC20;  
    IZkTwittERC721 zkTwittERC721;


    constructor (uint _costPerTweet, 
                 uint _costPerLike,
                 address _zkTwittERC20, 
                 address _zkTwittERC721) {
        costPerTweet = _costPerTweet;
        costPerLike = _costPerLike;
        zkTwitERC20 = IZkTwittERC20(_zkTwittERC20);
        zkTwittERC721 = IZkTwittERC721(_zkTwittERC721);
    }

    function tweet(uint _tokenId) public {
        require(zkTwitERC20.balanceOf(msg.sender) >= costPerTweet, "not enough balance to pay for tweet");
        zkTwittERC721.safeMint(msg.sender, _tokenId);
        zkTwitERC20.burnFrom(msg.sender, costPerTweet);
    }

    function like(uint _tokenId) public {
        require(zkTwitERC20.balanceOf(msg.sender) >= costPerLike, "not enough balance to pay for like");
        address tweetOwner = zkTwittERC721.ownerOf(_tokenId);
        likesCountPerTweet[_tokenId]++;
        likersPerTweet[_tokenId].push(msg.sender);
        zkTwitERC20.transferFrom(msg.sender, tweetOwner, costPerLike);
    }


    function buyToken() public payable {
        uint256  paymentReceived = msg.value;
        uint256 amountToBeGiven = paymentReceived/priceOfToken;
        zkTwitERC20.mint(msg.sender,amountToBeGiven);
    }


    function nbLike(uint _twittId) public view returns (uint) {
        return likesCountPerTweet[_twittId];
    }
 

    function whoLike(uint _tokenId) public view returns (address[] memory){
        return likersPerTweet[_tokenId];
    }
}