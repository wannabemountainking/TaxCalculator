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

func dividendReport(transactions: [Transaction]) -> (gross: Decimal, withholdingTax: Decimal, net: Decimal) {
	let transactionsDiv = transactions.filter { $0.type == .dividend }
	let preTaxAmount = transactionsDiv.reduce(Decimal(0)) { preTotal, current in
		let currentSum = current.quantity * current.unitPrice
		return currentSum + preTotal
	}
	
	let transactionTax = TransactionTax(grossAmount: preTaxAmount)
	let gross = preTaxAmount
	let withholdingTax = transactionTax.withholdingTax
	let net = transactionTax.netAmount
	return (gross: gross, withholdingTax: withholdingTax, net: net)
}
func monthlyDividendSummary(transactions: [Transaction]) -> [String: Decimal] {
	let divTransactions = transactions.filter{ $0.type == .dividend }
	let result = divTransactions.reduce(into: [String: Decimal]()) { dictAcc, transaction in
		let key = String(transaction.date.prefix(7))
		let value = transaction.quantity * transaction.unitPrice
		dictAcc[key, default: Decimal(0)] += value
	}
	return result
}

func monthlyDividendPrint(result: [String: Decimal]) -> [String: String] {
	result.mapValues { dividend in
		"$\(dividend.formatted(.number.precision(.fractionLength(2))))"
	}
}

func topDividendTickers(transactions: [Transaction], n: Int) -> [(ticker: String, total: Decimal)] {
	let divTransactions = transactions.filter{ $0.type == .dividend }
	let resultDict = divTransactions.reduce(into: [String : Decimal]()) { dictAcc, transaction in
		dictAcc[transaction.ticker, default: Decimal(0)] += transaction.quantity * transaction.unitPrice
	}
	let tupleArr = resultDict.map { (ticker: $0.key, total: $0.value) }
	let aligned = tupleArr.sorted(by: { $0.total > $1.total })
	let result = Array(aligned.prefix(n))
	return result
}

func topDividendPrint(result: [(ticker: String, total: Decimal)]) -> String {
	var presentableResult: String {
		let arr = result.map { "\($0.ticker) $\($0.total.formatted(.number.precision(.fractionLength(2)))) " }
		var transactionString: String = ""
		for str in arr {
			transactionString += str
		}
		return transactionString
	}
	return "상위 \(result.count)종목: \(presentableResult)"
}

// 실현손익 = 매도금액 − (매도수량 × 평균매입단가) − 매도수수료
