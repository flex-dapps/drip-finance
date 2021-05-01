pragma solidity ^0.8.0;

interface IDCAManager {
    /*
    * @dev allow the user to deposit the base pair into the contract for DCA
    * @param amount - the amount of the token they wish to deposit
    */
    function deposit(uint amount) external returns(bool);
    /*
    * @dev allow the user to withdraw the either token from the pool
    * @param amount - the amount of the token they wish to deposit
    * @param token - the address of the token contract
    * @returns boolean - true if successful else revert
    */
    function withdraw(uint amount, address token) external returns(bool);
    /*
    * @dev perform the swap of the base token into the destination token
    * @returns boolean - true if successful else revert
    */
    function performSwap() external returns(bool);
    /*
    * @dev get the balances of both the base and destination token that the contract holds
    * @returns address base token, uint balance, address destination token, uint balance
    */
    function getContractBalances() external returns(address, uint, address, uint);
}