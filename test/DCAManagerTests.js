const { expect } = require("chai");

//TODO complete
describe("DCAManager functions", function() {

  before(async function() {
    const [user, relayer] = await ethers.getSigners();
    this.user = user;
    this.relayer = relayer;
    const erc20 = await ethers.getContractFactory("ERC20");
    const DCAManager = await ethers.getContractFactory("DCAManager");
    //TODO get or deploy uniswap
    this.baseToken = await erc20.deploy("BASE", 18);
    this.destinationToken = await erc20.deploy("DEST", 18);
    this.DCAManager = await DCAManager.deploy("0x0000000000000000000000000000000000000000");
    const defaultSwapOrder = {
      baseToken: this.baseToken.address,
      amountBaseToken: 100000000000,
      destinationToken: this.destinationToken.address,
      fromTime: 0,
      toTime: 100000000000000000000
    };
    this.order = defaultSwapOrder;

    // sign the hash (will double hash) so that prefix can always have n/32
    const msg = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(
        [ "address", "uint", "address", "uint", "uint" ],
        [ defaultSwapOrder.baseToken,
          defaultSwapOrder.amountBaseToken,
          defaultSwapOrder.destinationToken,
          defaultSwapOrder.fromTime,
          defaultSwapOrder.toTime ]
        )
    );

    const flatSignature = await user.signMessage(msg);
    this.sig = ethers.utils.splitSignature(flatSignature);
  });

  it("Should fail to swap due to lack of approval from user", async function() {
    expect(await this.DCAManager.swapOnUsersBehalf(...this.order, ...this.sig)).reverted;
  });

  it("Should be able to swap on behalf of the user", async function() {
    const token = this.baseToken.connect(this.user);
    token.approve(this.DCAManager.address, "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
    const DCAManager = this.DCAManager.connect(this.relayer);
    expect(await DCAManager.swapOnUsersBehalf(...this.order, ...this.sig)).to.equal(true, "swap executed");
  });
});
