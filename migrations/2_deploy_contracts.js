var ConcertTix = artifacts.require("./ConcertTix.sol");

module.exports = function(deployer) {
  deployer.deploy(ConcertTix);
};
