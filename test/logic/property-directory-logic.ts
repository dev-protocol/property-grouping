import { expect, use } from 'chai'
import { Contract, BigNumber } from 'ethers'
import { toBigNumber } from '@devprotocol/util-ts'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryLogic from '../../build/PropertyDirectoryLogic.json'
import * as PropertyDirectoryConfig from '../../build/PropertyDirectoryConfig.json'
import * as AddressConfigTest from '../../build/AddressConfigTest.json'
import * as PropertyGroupTest from '../../build/PropertyGroupTest.json'
import * as PropertyDirectoryToken from '../../build/PropertyDirectoryToken.json'
import * as WithdrawTest from '../../build/WithdrawTest.json'

use(solidity)

describe.only('PropertyDirectoryLogic', () => {
	const provider = new MockProvider()
	const [deployer, author, propertyDirectory] = provider.getWallets()
	let propertyDirectoryConfig: Contract
	let propertyDirectoryLogic: Contract
	let addressConfig: Contract
	let propertyGroupTest: Contract
	let propertyDirectoryToken: Contract
	let withdrawTest: Contract

	before(async () => {
		propertyDirectoryConfig = await deployContract(
			deployer,
			PropertyDirectoryConfig
		)
		await propertyDirectoryConfig.createStorage()
		propertyDirectoryLogic = await deployContract(
			deployer,
			PropertyDirectoryLogic,
			[propertyDirectoryConfig.address]
		)
		addressConfig = await deployContract(deployer, AddressConfigTest)
		propertyDirectoryToken = await deployContract(
			deployer,
			PropertyDirectoryToken,
			[author.address, propertyDirectory.address, 'test', 'TEST']
		)
		withdrawTest = await deployContract(deployer, WithdrawTest)
		await addressConfig.setWithdraw(withdrawTest.address)
		const token = provider.createEmptyWallet()
		await addressConfig.setToken(token.address)
		propertyGroupTest = await deployContract(deployer, PropertyGroupTest)
		await addressConfig.setPropertyGroup(propertyGroupTest.address)
		await propertyDirectoryConfig.setProtocolConfig(addressConfig.address, {
			gasLimit: 1200000,
		})
	})
	describe('getWithdrawAddress', () => {
		it('get withdraw address', async () => {
			const withdrawAddress = await propertyDirectoryLogic.getWithdrawAddress()
			expect(withdrawAddress).to.equal(await addressConfig.withdraw())
		})
	})
	describe('getDevTokenAddress', () => {
		it('get dev token address', async () => {
			const tokenAddress = await propertyDirectoryLogic.getDevTokenAddress()
			expect(tokenAddress).to.equal(await addressConfig.token())
		})
	})
	describe('validatePropertyAddress', () => {
		it('No error is generated for property addresses.', async () => {
			const property = provider.createEmptyWallet()
			await propertyGroupTest.addGroup(property.address)
			await propertyDirectoryLogic.validatePropertyAddress(property.address)
		})
		it('error is generated for property addresses.', async () => {
			const property = provider.createEmptyWallet()
			await expect(
				propertyDirectoryLogic.validatePropertyAddress(property.address)
			).to.be.revertedWith('not property address')
		})
	})
	describe('calculateAmount', () => {
		it('calculate amount.', async () => {
			const result: BigNumber = await propertyDirectoryLogic
				.calculateAmount(
					'100000000000000000000000000',
					'30000000000000000000000000',
					propertyDirectoryToken.address,
					author.address
				)
				.then(toBigNumber)
			expect(result.toString()).to.equal('70000000000000000000000000')
		})
	})
	describe('curretnRewardAmount', () => {
		it('calculate amount.', async () => {
			const result: BigNumber = await propertyDirectoryLogic
				.curretnRewardAmount([
					'0x1dCb85efEa6A3FB528d19B9174E88ee35BfF540a',
					'0x2c2807a0eb5fd0dfac8a93a2c9d788154a17b369',
				])
				.then(toBigNumber)
			expect(result.toString()).to.equal('300000000000000000000')
		})
	})
})
