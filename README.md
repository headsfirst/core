# SingularityNetwork
Includes contracts, migrations, tests

## Design Specifications

[Smart Contracts Design ](./docs/SNContractsDesignSpecs.md)


## Requirements

* [Node.js](https://github.com/nodejs/node) (7.6 +)
* [Npm](https://www.npmjs.com/package/npm)

## Install

### Dependencies
```bash
npm install
```

### Test 

```bash
npm run test
```

or 

```bash
truffle test
```

## Flattening

`solidity_flattener contracts/Contract.sol --solc-paths=zeppelin-solidity=$(pwd)/node_modules/zeppelin-solidity/ --output contract.sol`

