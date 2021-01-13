import { expect, use } from 'chai'
import { Contract, constants } from 'ethers'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryConfig from '../../build/PropertyDirectoryConfig.json'

use(solidity)

describe('PropertyDirectoryConfig', () => {
	const [
		deployer,
		user,
		factory,
		protocolConfig,
		eventContract,
	] = new MockProvider().getWallets()
	let propertyDirectoryConfig: Contract
	let propertyDirectoryConfigOther: Contract

	before(async () => {
		propertyDirectoryConfig = await deployContract(
			deployer,
			PropertyDirectoryConfig
		)
		await propertyDirectoryConfig.createStorage()
		propertyDirectoryConfigOther = propertyDirectoryConfig.connect(user)
	})

	describe('setFactory, getFactory', () => {
		it('0 by default', async () => {
			const value: string = await propertyDirectoryConfig.getFactory()
			expect(value).to.equal(constants.AddressZero)
		})
		it('get the set address', async () => {
			await propertyDirectoryConfig.setFactory(factory.address)
			const value: string = await propertyDirectoryConfig.getFactory()
			expect(value).to.equal(factory.address)
		})
		it('get the set address', async () => {
			await expect(
				propertyDirectoryConfigOther.setFactory(factory.address)
			).to.be.revertedWith('admin only.')
		})
	})
	describe('setProtocolConfig, getProtocolConfig', () => {
		it('0 by default', async () => {
			const value: string = await propertyDirectoryConfig.getProtocolConfig()
			expect(value).to.equal(constants.AddressZero)
		})
		it('get the set address', async () => {
			await propertyDirectoryConfig.setProtocolConfig(protocolConfig.address)
			const value: string = await propertyDirectoryConfig.getProtocolConfig()
			expect(value).to.equal(protocolConfig.address)
		})
		it('get the set address', async () => {
			await expect(
				propertyDirectoryConfigOther.setProtocolConfig(protocolConfig.address)
			).to.be.revertedWith('admin only.')
		})
	})

	describe('setEvent, getEvent', () => {
		it('0 by default', async () => {
			const value: string = await propertyDirectoryConfig.getEvent()
			expect(value).to.equal(constants.AddressZero)
		})
		it('get the set address', async () => {
			await propertyDirectoryConfig.setEvent(eventContract.address)
			const value: string = await propertyDirectoryConfig.getEvent()
			expect(value).to.equal(eventContract.address)
		})
		it('get the set address', async () => {
			await expect(
				propertyDirectoryConfigOther.setEvent(eventContract.address)
			).to.be.revertedWith('admin only.')
		})
	})
})
