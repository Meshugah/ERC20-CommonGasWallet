var Receiver = artifacts.require('Receiver');
var Factory = artifacts.require('Factory');

module.exports = function(deployer) {
    deployer.deploy(Receiver);
    deployer.deploy(Factory);
};