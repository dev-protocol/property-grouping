import { expect, use } from 'chai'
import { Contract, constants } from 'ethers'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryTokenTest from '../../build/PropertyDirectoryTokenTest.json'
import * as PropertyDirectoryToken from '../../build/PropertyDirectoryToken.json'
import { toBigNumber } from '@devprotocol/util-ts'

use(solidity)

describe('PropertyDirectoryToken', () => {
	describe('transfer', () => {
		const provider = new MockProvider()
		const [deployer, author, user] = provider.getWallets()
		let propertyDirectoryTokenTest: Contract
		let propertyDirectoryToken: Contract

		beforeEach(async () => {
			propertyDirectoryTokenTest = await deployContract(
				deployer,
				PropertyDirectoryTokenTest
			)
			await propertyDirectoryTokenTest.createToken(author.address)
			const tokenAddress: string = await propertyDirectoryTokenTest.token()
			propertyDirectoryToken = new Contract(
				tokenAddress,
				PropertyDirectoryToken.abi,
				provider
			)
		})

		it('an BeforeBalanceChange event is created.(transfer)', async () => {
			const tokenByAuthor = propertyDirectoryToken.connect(author)
			const empty = provider.createEmptyWallet()
			const beforeBalance = await propertyDirectoryToken.balanceOf(
				empty.address
			)
			expect(toBigNumber(beforeBalance)).to.equal(toBigNumber(0))
			await expect(tokenByAuthor.transfer(empty.address, 100))
				.to.emit(propertyDirectoryTokenTest, 'BeforeBalanceChange')
				.withArgs(author.address, empty.address, 100)
			const afterBalance = await propertyDirectoryToken.balanceOf(empty.address)
			expect(toBigNumber(afterBalance)).to.equal(toBigNumber(100))
		})
		it('an BeforeBalanceChange event is created.(transferFrom)', async () => {
			const tokenByAuthor = propertyDirectoryToken.connect(author)
			await tokenByAuthor.approve(user.address, 100)
			const tokenByUser = propertyDirectoryToken.connect(user)
			const beforeBalance = await propertyDirectoryToken.balanceOf(user.address)
			expect(toBigNumber(beforeBalance)).to.equal(toBigNumber(0))
			await expect(
				tokenByUser.transferFrom(author.address, user.address, 100, {
					gasLimit: 1200000,
				})
			)
				.to.emit(propertyDirectoryTokenTest, 'BeforeBalanceChange')
				.withArgs(author.address, user.address, 100)
			const afterBalance = await propertyDirectoryToken.balanceOf(user.address)
			expect(toBigNumber(afterBalance)).to.equal(toBigNumber(100))
		})
	})
	describe('setPropertyDirectoryAddress', () => {
		const provider = new MockProvider()
		const [deployer, author, propertyDirectory, user] = provider.getWallets()

		it('deployer can change the address of PropertyDirectory.', async () => {
			const propertyDirectoryToken = await deployContract(
				author,
				PropertyDirectoryToken,
				[author.address, propertyDirectory.address, 'test', 'TEST']
			)
			const propertyDirectoryTokenTest = await deployContract(
				deployer,
				PropertyDirectoryTokenTest
			)
			await propertyDirectoryToken
				.connect(propertyDirectory)
				.setPropertyDirectoryAddress(propertyDirectoryTokenTest.address, {
					gasLimit: 1200000,
				})
			await expect(
				propertyDirectoryToken.transfer(user.address, 100, {
					gasLimit: 1200000,
				})
			)
				.to.emit(propertyDirectoryTokenTest, 'BeforeBalanceChange')
				.withArgs(author.address, user.address, 100)
		})
		it('non-deployer can not change the address of PropertyDirectory.', async () => {
			const propertyDirectoryToken = await deployContract(
				deployer,
				PropertyDirectoryToken,
				[author.address, constants.AddressZero, 'test', 'TEST']
			)
			const empty = provider.createEmptyWallet()
			const propertyDirectoryTokenUser = propertyDirectoryToken.connect(user)
			await expect(
				propertyDirectoryTokenUser.setPropertyDirectoryAddress(empty.address)
			).to.be.revertedWith('illegal access')
		})
	})
	describe('tokenDecimals', () => {
		const provider = new MockProvider()
		const [deployer, propertyDirectory] = provider.getWallets()

		it('can get token decimals.', async () => {
			const propertyDirectoryToken = await deployContract(
				deployer,
				PropertyDirectoryToken,
				[deployer.address, propertyDirectory.address, 'test', 'TEST']
			)
			const decimals: number = await propertyDirectoryToken.tokenDecimals()
			expect(decimals).to.equal(18)
		})
	})
})
