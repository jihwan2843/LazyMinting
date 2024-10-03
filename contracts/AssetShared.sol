// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >0.8.0 <=0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./TokenIdIdentifiers.sol";

contract AssetShared is ERC721 {
    using TokenIdIdentifiers for uint256;

    // tokenId에 대한 tokenURI
    mapping(uint256 => string) _tokenURI;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    // minter가 tokenId를 민팅할 수 있는지 체크
    function _requireMintable(address minter, uint256 tokenId) internal pure {
        // tokenId에서 파싱한 앞의 20바이트가 minter랑 같은지 체크
        require(
            tokenId.tokenCreator() == minter,
            "Only creator can mint toekn"
        );
    }

    function _mint(address to, uint256 tokenId) internal override {
        _requireMintable(msg.sender, tokenId);
        super._mint(to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        address owner = _ownerOf(tokenId);

        if (owner == address(0)) {
            _mint(to, tokenId);
        } else {
            super.safeTransferFrom(from, to, tokenId, data);
            _setTokenURI(tokenId, string(data));
        }
    }

    // tokenURI를 설정
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        _tokenURI[tokenId] = uri;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);

        return _tokenURI[tokenId];
    }
}
