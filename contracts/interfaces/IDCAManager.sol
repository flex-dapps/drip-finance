pragma solidity ^0.8.0;

interface IDCAManager {

    /*
    * @dev allow a relayer to trigger a trade on behalf of a user with their signed permission,
    * requires that the user approve this contract to move the base token
    * @param baseToken - the token to trade from
    * @param amountBaseToken - the amount of the base token to trade into the destination token
    * @param destinationToken - the address of the token that the user wants to swap their base token into
    * @param fromTime - the desired time for this swap to occur
    * @param toTime - this swap should happen no later than this
    * @param v - signature param
    * @param r - signature param
    * @param s - signature param
    * @returns true if successful
    */
    function swapOnUsersBehalf(
        address baseToken,
        uint amountBaseToken,
        address destinationToken,
        uint fromTime,
        uint toTime,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool);

}