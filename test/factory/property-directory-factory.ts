import { expect, use } from 'chai'
import { Contract } from 'ethers'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryFactory from '../../build/PropertyDirectoryFactory.json'
import * as PropertyDirectoryConfig from '../../build/PropertyDirectoryConfig.json'
import * as PropertyDirectoryTokenFactory from '../../build/PropertyDirectoryTokenFactory.json'
import { toBigNumber } from '@devprotocol/util-ts'

use(solidity)

describe.only('PropertyDirectoryFactory', () => {
	const options = {
		allowUnlimetedContractSize: true,
		gasLimit: 0xfffffffffff,
	}
	const provider = new MockProvider({ ganacheOptions: options })
	const [deployer] = provider.getWallets()
	let propertyDirectoryFactory: Contract
	let propertyDirectoryConfig: Contract
	let propertyDirectoryTokenFactory: Contract

	before(async () => {
		console.log(1)
		propertyDirectoryConfig = await deployContract(
			deployer,
			PropertyDirectoryConfig
		)
		await propertyDirectoryConfig.createStorage()
		propertyDirectoryTokenFactory = await deployContract(
			deployer,
			PropertyDirectoryTokenFactory
		)
		await propertyDirectoryConfig.setTokenFactory(
			propertyDirectoryTokenFactory.address
		)
		console.log(2)
		propertyDirectoryFactory = await deployContract(
			deployer,
			PropertyDirectoryFactory,
			[propertyDirectoryConfig.address],
			{
				gasLimit: 8000000,
			}
		)
		console.log(3)
		await propertyDirectoryFactory.createStorage()
		console.log(4)
		await propertyDirectoryConfig.setFactory(propertyDirectoryFactory.address)
		console.log(5)
	})

	describe('create', () => {
		it('PropertyDirectory is created.', async () => {
			const result = await propertyDirectoryFactory.create('test', 'TEST', {
				gasLimit: 15000000,
			})
			console.log(result)
		})
	})
})
