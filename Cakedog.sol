
// File: openzeppelin-solidity/contracts/proxy/Proxy.sol

// SPDX-License-Identifier: MIT
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;



contract BEP20UpgradeableProxy is TransparentUpgradeableProxy {

    constructor(address logic, address admin, bytes memory data) TransparentUpgradeableProxy(logic, admin, data) public {

    }

}