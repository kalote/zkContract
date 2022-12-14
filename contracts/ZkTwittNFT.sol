// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ZkTwittNFT is ERC721 {

    constructor() ERC721("ZkTwittNFT", "ZT") {}

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

}