import { expect, use } from 'chai'
import { Contract } from 'ethers'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryFactoryStorageTest from '../../build/PropertyDirectoryFactoryStorageTest.json'

use(solidity)

describe('PropertyDirectoryFactoryStorage', () => {
	const provider = new MockProvider()
	const [deployer] = provider.getWallets()
	let propertyDirectoryFactoryStorageTest: Contract

	before(async () => {
		propertyDirectoryFactoryStorageTest = await deployContract(
			deployer,
			PropertyDirectoryFactoryStorageTest
		)
		await propertyDirectoryFactoryStorageTest.createStorage()
	})

	describe('addPropertyDirectory, deletePropertyDirectory, isPropertyDirectory', () => {
		it('default value is false.', async () => {
			const empty = provider.createEmptyWallet()
			const result = await propertyDirectoryFactoryStorageTest.isPropertyDirectory(
				empty.address
			)
			expect(result).to.equal(false)
		})
		it('if you execute add or delete method, result is change.', async () => {
			const empty = provider.createEmptyWallet()
			await propertyDirectoryFactoryStorageTest.addPropertyDirectoryTest(
				empty.address
			)
			let result = await propertyDirectoryFactoryStorageTest.isPropertyDirectory(
				empty.address
			)
			expect(result).to.equal(true)
			await propertyDirectoryFactoryStorageTest.deletePropertyDirectoryTest(
				empty.address
			)
			result = await propertyDirectoryFactoryStorageTest.isPropertyDirectory(
				empty.address
			)
			expect(result).to.equal(false)
		})
	})
})
