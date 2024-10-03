// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >0.8.0 <=0.9.0;

library TokenIdIdentifiers {
    uint8 constant ADDRESS_BIT = 160;
    uint8 constant INDEX_BITS = 96;

    uint256 constant INDEX_MASK =
        0x0000000000000000000000000000000000000000ffffffffffffffffffffffff;

    // 뒤의 12바이트인 토큰 인덱스를 반환
    function tokenIndex(uint256 _id) public pure returns (uint256) {
        return _id & INDEX_MASK;
    }

    // 앞의 20바이트를 파싱. 토큰 Creator 주소 반환
    function tokenCreator(uint256 _id) public pure returns (address) {
        return address(uint160(_id >> INDEX_BITS));
    }
}
