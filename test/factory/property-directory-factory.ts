import { expect, use } from 'chai'
import { Contract } from 'ethers'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryFactory from '../../build/PropertyDirectoryFactory.json'
import * as PropertyDirectoryConfig from '../../build/PropertyDirectoryConfig.json'
import * as PropertyDirectoryTokenFactory from '../../build/PropertyDirectoryTokenFactory.json'
import { toBigNumber } from '@devprotocol/util-ts'

use(solidity)

describe('PropertyDirectoryFactory', () => {
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
		propertyDirectoryFactory = await deployContract(
			deployer,
			PropertyDirectoryFactory,
			[propertyDirectoryConfig.address],
			{
				gasLimit: 8000000,
			}
		)
		await propertyDirectoryFactory.createStorage()
		await propertyDirectoryConfig.setFactory(propertyDirectoryFactory.address)
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
