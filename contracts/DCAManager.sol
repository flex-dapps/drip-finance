pragma solidity ^0.8.0;

import "./interfaces/IDCAManager.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
*  @dev this contract is responsible for dollar cost averaging a users position from DAI to ETH at a specific time (weekly) and percentage(10%) on the OVM
*/
contract DCAManager is IDCAManager {

    uint public percentage; //= 0.1 ether; // since both DAI and WETH are decimals 18
    uint public timeInterval; //= 604800; // 1 week in seconds
    uint public lastTimeStamp;
    string public fundPosition; // e.g. DAI to WETH 10% Weekly
    address public baseToken;
    address public destinationToken;

    constructor(
        address _baseToken,
        address _destinationToken,
        uint _timeInterval,
        uint _percentage,
        string memory _fundPosition
    ) public {
        lastTimeStamp = block.timestamp;
        baseToken = _baseToken;
        destinationToken = _destinationToken;
        timeInterval = _timeInterval;
        percentage = _percentage;
        fundPosition = _fundPosition;
    }

    mapping(address => mapping(address => uint)) balances; // user => token => balance

    modifier isATokenPair(address token) {
        require(token == baseToken || token == destinationToken);
        _;
    }

    // you should only deposit the base token i.e. DAI
    function deposit(uint amount) public override returns(bool) {
        require(ERC20(baseToken).transferFrom(msg.sender, address(this), amount));
        balances[msg.sender][baseToken] += amount;

        return true;
    }

    function getContractBalances() public view override returns(address, uint, address, uint) {
        uint baseTokenBalance = ERC20(baseToken).balanceOf(address(this));
        uint destinationTokenBalance = ERC20(destinationToken).balanceOf(address(this));
        // base & destination token
        return (baseToken, baseTokenBalance, destinationToken, destinationTokenBalance);
    }

    // you should be able to withdraw either the base token or the destination token
    function withdraw(uint amount, address token) public override isATokenPair(token) returns(bool) {
        require(balances[msg.sender][token] >= amount);
        require(ERC20(token).transferFrom(address(this), msg.sender, amount));
        balances[msg.sender][token] -= amount;

        return true;
    }

    function performSwap() public override returns(bool) {
        require(lastTimeStamp + timeInterval <= block.timestamp);
        (address dai, uint daiBalance, address weth, uint wethBalance) = getContractBalances();
        uint amountOfDaiToSwap = daiBalance * percentage;
        //TODO do uniswap swap here with default values
        lastTimeStamp = block.timestamp;

        return true;
    }

}