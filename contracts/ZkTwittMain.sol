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

contract ZkTwittMain {
    uint256 priceOfToken = 2;
    uint256 costPerLike;
    uint256 costPerRetweet;
    uint256 costPerTweet;
    // mapping(uint256 => uint256) likesCountPerTweet;
    // mapping(uint256 => uint256) retweetCountPerTweet;
    // mapping(uint256 => address[]) likersPerTweet;
    IZkTwittERC20 zkTwitERC20;
    IZkTwittERC721 zkTwittERC721;

    constructor(
        uint256 _costPerTweet,
        uint256 _costPerLike,
        address _zkTwittERC20,
        address _zkTwittERC721
    ) {
        costPerTweet = _costPerTweet * 10**18;
        costPerLike = _costPerLike * 10**18;
        costPerRetweet = _costPerLike * 10**18;
        zkTwitERC20 = IZkTwittERC20(_zkTwittERC20);
        zkTwittERC721 = IZkTwittERC721(_zkTwittERC721);
    }

    function tweet(uint256 _tokenId) public {
        require(
            zkTwitERC20.balanceOf(msg.sender) >= costPerTweet,
            "not enough balance to pay for tweet"
        );
        zkTwittERC721.safeMint(msg.sender, _tokenId);
        zkTwitERC20.burnFrom(msg.sender, costPerTweet);
    }

    function like(uint256 _tokenId) public {
        require(
            zkTwitERC20.balanceOf(msg.sender) >= costPerLike,
            "not enough balance to pay for like"
        );
        address tweetOwner = zkTwittERC721.ownerOf(_tokenId);
        // likesCountPerTweet[_tokenId]++;
        // likersPerTweet[_tokenId].push(msg.sender);
        zkTwitERC20.transferFrom(msg.sender, tweetOwner, costPerLike);
    }

    function retweet(uint256 _tokenId) public {
        require(
            zkTwitERC20.balanceOf(msg.sender) >= costPerRetweet,
            "not enough balance to pay for retweet"
        );
        address tweetOwner = zkTwittERC721.ownerOf(_tokenId);
        // retweetCountPerTweet[_tokenId]++;
        zkTwitERC20.transferFrom(msg.sender, tweetOwner, costPerRetweet);
    }

    function buyToken() public payable {
        uint256 paymentReceived = msg.value;
        uint256 amountToBeGiven = paymentReceived / priceOfToken;
        zkTwitERC20.mint(msg.sender, amountToBeGiven);
    }

    // function nbLike(uint256 _twittId) public view returns (uint256) {
    //     return likesCountPerTweet[_twittId];
    // }

    // function nbRetweet(uint256 _twittId) public view returns (uint256) {
    //     return retweetCountPerTweet[_twittId];
    // }

    // function whoLike(uint256 _tokenId) public view returns (address[] memory) {
    //     return likersPerTweet[_tokenId];
    // }
}
