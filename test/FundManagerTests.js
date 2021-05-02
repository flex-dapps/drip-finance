const { parseEther } = require("@ethersproject/units");
const { expect } = require("chai");

describe("DCAFundManager functions", function() {

  before(async function() {
    const erc20 = await ethers.getContractFactory("ERC20");
    const DCAManager = await ethers.getContractFactory("DCAManager");
    //TODO get or deploy uniswap
    // this.uniswapV2 = await ethers.getContractFactory("IUniswapV2Router02").attach("0x0000000000000000000000000000000000000000");
    this.baseToken = await erc20.deploy("BASE", 18);
    this.destinationToken = await erc20.deploy("DEST", 18);
    this.DCAManager = await DCAManager.deploy(
        this.baseToken.address,
        this.destinationToken.address,
        604800,
        parseEther("0.1"),
        "EXAMPLE",
        "0x0000000000000000000000000000000000000000"
    );
  });

  it("Should return the interval correctly", async function() {
    expect(await this.DCAManager.timeInterval()).to.equal(604800, "should be one week in seconds")
  });
});
