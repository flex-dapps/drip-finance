pragma solidity ^0.8.0;

import "./interfaces/IDCAManager.sol";
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

contract DCAManager is IDCAManager {

    IUniswapV2Router02 public uniswapRouter;

    constructor(address _uniswapV2Router) public {
        uniswapRouter = IUniswapV2Router02(_uniswapV2Router);
    }

    /*
    * See IDCAManager.sol
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
    ) public override returns (bool) {
        require(block.timestamp >= fromTime && block.timestamp <= toTime, "failed to meet the time requirement");
        bytes memory message = abi.encodePacked(
            baseToken,
            amountBaseToken,
            destinationToken,
            fromTime,
            toTime
        );
        bytes32 messageHash = keccak256(message);
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes msgHashWithPrefix = keccak256(prefix, messageHash);
        address user = ecrecover(msgHashWithPrefix, v, r, s);
        address[] memory path = new address[](2);
        path[0] = baseToken;
        path[1] = destinationToken;

        uniswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountBaseToken,
            0, // TODO set min amount of WETH using some kind of oracle
            path,
            user,
            toTime
        );
        return true;
    }

}