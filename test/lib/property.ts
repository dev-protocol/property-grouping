/* eslint-disable @typescript-eslint/prefer-readonly-parameter-types */
import { expect, use } from 'chai'
import { Contract, BigNumber } from 'ethers'
import { deployContract, MockProvider, solidity } from 'ethereum-waffle'
import { toBigNumber } from '@devprotocol/util-ts'
import * as PropertyTest from '../../build/PropertyTest.json'
import * as PropertyTokenTest from '../../build/PropertyTokenTest.json'

use(solidity)

describe('Property', () => {
	const [deployer] = new MockProvider().getWallets()
	let propertyTest: Contract

	before(async () => {
		propertyTest = await deployContract(deployer, PropertyTest)
	})
	const getTestInstance = async (supply: BigNumber): Promise<Contract> => {
		const propertyTokenTest = await deployContract(
			deployer,
			PropertyTokenTest,
			[supply]
		)
		await propertyTest.set(propertyTokenTest.address)
		return propertyTest
	}

	describe('mulAmount', () => {
		it('in case totalSupply is 10000000000000000000000000.', async () => {
			const propertyTest = await getTestInstance(
				toBigNumber('10000000000000000000000000')
			)
			const result = await propertyTest.mulAmount(100)
			expect(toBigNumber(result)).to.equal(toBigNumber(100))
		})
		it('in case totalSupply is 10000000.', async () => {
			const propertyTest = await getTestInstance(toBigNumber(10000000))
			const result = await propertyTest.mulAmount(100)
			expect(toBigNumber(result).toString()).to.equal(
				toBigNumber(100).mul(toBigNumber('1000000000000000000').toString())
			)
		})
		it('if it is an invalid address.', async () => {
			const propertyTest = await getTestInstance(toBigNumber(10))
			await expect(propertyTest.mulAmount(100)).to.be.revertedWith(
				'liiegal address'
			)
		})
	})
	describe('divAmount', () => {
		it('in case totalSupply is 10000000000000000000000000.', async () => {
			const propertyTest = await getTestInstance(
				toBigNumber('10000000000000000000000000')
			)
			const result = await propertyTest.divAmount(100)
			expect(toBigNumber(result)).to.equal(toBigNumber(100))
		})
		it('in case totalSupply is 10000000.', async () => {
			const propertyTest = await getTestInstance(toBigNumber(10000000))
			const result = await propertyTest.divAmount(
				toBigNumber('100000000000000000000')
			)
			expect(toBigNumber(result).toString()).to.equal(
				toBigNumber(100).toString()
			)
		})
		it('if it is an invalid address.', async () => {
			const propertyTest = await getTestInstance(toBigNumber(10))
			await expect(propertyTest.divAmount(100)).to.be.revertedWith(
				'liiegal address'
			)
		})
	})
})
