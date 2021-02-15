import { expect, use } from 'chai'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import * as PropertyDirectoryTokenFactory from '../../build/PropertyDirectoryTokenFactory.json'

use(solidity)

describe('PropertyDirectoryTokenFactory', () => {
	describe('create', () => {
		const provider = new MockProvider()
		const [deployer, author, propertyDirectory] = provider.getWallets()

		it('Transaction is successfully issued.', async () => {
			const propertyDirectoryTokenFactory = await deployContract(
				deployer,
				PropertyDirectoryTokenFactory
			)
			const transactionInfo = await propertyDirectoryTokenFactory.create(
				author.address,
				propertyDirectory.address,
				'test',
				'TEST'
			)
			expect(transactionInfo.to).to.equal(propertyDirectoryTokenFactory.address)
		})
	})
})
