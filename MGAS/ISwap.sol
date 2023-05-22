// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


interface ISwap {
    /**
     * @dev Creates `amount` tokens and assigns them to `recipient`, increasing
     * the total supply.
     *
     * Requirements
     *
     * - `msg.sender` must be the token owner
     * - `_mintable` must be true
     */
    function mintTo(uint256 amount, address recipient) external returns (bool);

    /**
    * @dev Burn `amount` tokens and decreasing the total supply.
    */
    function burn(uint256 amount) external returns (bool);
}