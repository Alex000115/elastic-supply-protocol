// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RebaseToken is IERC20, Ownable {
    uint256 private constant MAX_UINT256 = type(uint256).max;
    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10**9 * 10**18;
    
    // "TOTAL_GONS" is a large multiple of "INITIAL_FRAGMENTS_SUPPLY"
    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);

    uint256 private _totalSupply;
    uint256 private _gonsPerFragment;
    mapping(address => uint256) private _gonBalances;
    mapping(address => mapping(address => uint256)) private _allowedFragments;

    constructor() Ownable(msg.sender) {
        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        _gonBalances[msg.sender] = TOTAL_GONS;
        _gonsPerFragment = TOTAL_GONS / _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function rebase(uint256 epoch, int256 supplyDelta) external onlyOwner returns (uint256) {
        if (supplyDelta == 0) return _totalSupply;

        if (supplyDelta < 0) {
            _totalSupply -= uint256(-supplyDelta);
        } else {
            _totalSupply += uint256(supplyDelta);
        }

        _gonsPerFragment = TOTAL_GONS / _totalSupply;
        return _totalSupply;
    }

    function balanceOf(address who) public view override returns (uint256) {
        return _gonBalances[who] / _gonsPerFragment;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        uint256 gonValue = value * _gonsPerFragment;
        _gonBalances[msg.sender] -= gonValue;
        _gonBalances[to] += gonValue;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Standard ERC20 allowance logic omitted for brevity
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowedFragments[owner][spender];
    }
}
