import { expect, use } from 'chai'
import { Contract } from 'ethers'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryEvent from '../../build/PropertyDirectoryEvent.json'
import * as PropertyDirectoryConfig from '../../build/PropertyDirectoryConfig.json'
import * as PropertyDirectoryFactoryTest from '../../build/PropertyDirectoryFactoryTest.json'

use(solidity)

describe('PropertyDirectoryEvent', () => {
	const [deployer, from, to] = new MockProvider().getWallets()
	let propertyDirectoryEvent: Contract
	let propertyDirectoryFactory: Contract

	before(async () => {
		propertyDirectoryFactory = await deployContract(
			deployer,
			PropertyDirectoryFactoryTest
		)
		const propertyDirectoryConfig = await deployContract(
			deployer,
			PropertyDirectoryConfig
		)
		await propertyDirectoryConfig.createStorage()
		await propertyDirectoryConfig.setFactory(propertyDirectoryFactory.address)
		propertyDirectoryEvent = await deployContract(
			deployer,
			PropertyDirectoryEvent,
			[propertyDirectoryConfig.address]
		)
	})

	describe('beforeBalanceChange', () => {
		it('create event information.', async () => {
			await propertyDirectoryFactory.setValue(true)
			await expect(
				propertyDirectoryEvent.beforeBalanceChange(
					from.address,
					to.address,
					12345
				)
			)
				.to.emit(propertyDirectoryEvent, 'BeforeBalanceChange')
				.withArgs(from.address, to.address, 12345)
		})
		it('an error will occur if  access from other than the PropertyDirectory.', async () => {
			await propertyDirectoryFactory.setValue(false)
			await expect(
				propertyDirectoryEvent.beforeBalanceChange(
					from.address,
					to.address,
					12345
				)
			).to.be.revertedWith('illegal address.')
		})
	})
})
