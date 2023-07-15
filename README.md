ZkPlayground HW0 solved by using [murky](https://github.com/dmfxyz/murky).

There is no padding empty node for odd nodes in the merkle tree of hw0, which is a bit different from murky, so we need to manually tweak the logic. These are the two functions that are modified:

```solidity
function getProof(bytes32[] memory data, uint256 node) public pure returns (bytes32[] memory) {
    require(data.length > 1, "won't generate proof for single leaf");
    // The size of the proof is equal to the ceiling of log2(numLeaves)
    bytes32[] memory result = new bytes32[](log2ceilBitMagic(data.length));
    uint256 pos = 0;

    // Two overflow risks: node, pos
    // node: max array size is 2**256-1. Largest index in the array will be 1 less than that. Also,
        // for dynamic arrays, size is limited to 2**64-1
    // pos: pos is bounded by log2(data.length), which should be less than type(uint256).max
    while(data.length > 1) {
        unchecked {
            if (node & 0x1 == 1) {
                // even node
                result[pos++] = data[node - 1];
            } else if (node + 1 == data.length) {
                // odd and also the last node
            } else {
                result[pos++] = data[node + 1];
            }
            node /= 2;
        }
        data = hashLevel(data);
    }
    return result;
}

function hashLevel(bytes32[] memory data) private pure returns (bytes32[] memory) {
    bytes32[] memory result;

    // Function is private, and all internal callers check that data.length >=2.
    // Underflow is not possible as lowest possible value for data/result index is 1
    // overflow should be safe as length is / 2 always.
    unchecked {
        uint256 length = data.length;
        if (length & 0x1 == 1){
            result = new bytes32[](length / 2 + 1);
            result[result.length - 1] = data[length - 1];
        } else {
            result = new bytes32[](length / 2);
    }
    // pos is upper bounded by data.length / 2, so safe even if array is at max size
        uint256 pos = 0;
        for (uint256 i = 0; i < length-1; i+=2){
            result[pos] = hashLeafPairs(data[i], data[i+1]);
            ++pos;
        }
    }
    return result;
}
```
