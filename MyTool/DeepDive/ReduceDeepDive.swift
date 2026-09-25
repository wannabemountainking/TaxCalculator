//
//  ReduceDeepDive.swift
//  MyTool
//
//  Created by YoonieMac on 9/24/26.
//

import Foundation


func groupWordsByLength() {
	let words = ["cat", "dog", "swift", "ios", "code", "ai"]
	let byLength = words.reduce(into: [Int: [String]]()) { dictAcc, word in
		let key = word.count
		dictAcc[key, default: []].append(word)
	}
	print(byLength)
}

func separateEvenAndOdd() {
	let numbers = [4, 7, 2, 9, 12, 15, 6, 3]
	let evenAndOddTuple = numbers.reduce(into: (evenArr: [Int](), oddArr: [Int]())) { tupleAcc, number in
		if number.isMultiple(of: 2) {
			tupleAcc.evenArr.append(number)
		} else {
			tupleAcc.oddArr.append(number)
		}
	}
	print(evenAndOddTuple)
}

func transactionListForTicker(transactions: [Transaction]) -> [String: [Transaction]]{
	let listForTicker = transactions.reduce(into: [String : [Transaction]]()) { dictAcc, transaction in
		let key = transaction.ticker
		dictAcc[key, default: []].append(transaction)
	}
	return listForTicker
}

func frequency() {
	let text = "mississippi"
	
	let result = text.reduce(into: [Character: Int]()) { dictAcc, char in
		let key = char
		dictAcc[key, default: 0] += 1
	}
	
	print(result)
}

func gatherTickers(transactions: [Transaction]) {
	let result = transactions.reduce(into: Set<String>()) { setAcc, transaction in
		let ticker = transaction.ticker
		setAcc.insert(ticker)
	}
	print(result)
}

func searchTransaction(transactions: [Transaction]) -> [UUID: Transaction] {
	
	return transactions.reduce(into: [UUID: Transaction]()) { dictAcc, transaction in
		let key = transaction.id
		dictAcc[key] = transaction
	}
}

func sumMaxMin() {
	let prices = [180.0, 200.0, 175.5, 210.0, 190.25]
	
	let result = prices.reduce(into: (sum: 0.0, max: -Double.greatestFiniteMagnitude, min: Double.greatestFiniteMagnitude)) { result, number in
		result.sum += number
		if result.max < number {
			result.max = number
		}
		if result.min > number {
			result.min = number
		}
	}
	print(result)
}
