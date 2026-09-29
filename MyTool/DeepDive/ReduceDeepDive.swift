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
func realizedPnL(ticker: String, transactions: [Transaction]) -> Decimal? {
	let sellTransactions = transactions.filter({ $0.ticker == ticker && $0.type == .sell })
	guard let averageUnitValue = AvgCost.averageUnitPrice(ticker: ticker, transactions: transactions) else { return nil }
	let result = sellTransactions.reduce(Decimal(0)) { prev, current in
		let sell = current.quantity * current.unitPrice
		let yourBuyingCost = current.quantity * averageUnitValue
		return prev + sell - yourBuyingCost - current.tradeFee
	}
	return result
}

func realizedPnLPrint(tickers: [String], transactions: [Transaction]) -> String {
	var result: String = ""
	for index in 0..<tickers.count {
		let lastOneNoSpace: String = (index == tickers.count - 1) ? "" : "\n"
		if let pnL = realizedPnL(ticker: tickers[index], transactions: transactions) {
			let pnLString = pnL.formatted(.number.precision(.fractionLength(2)))
			result += "\(tickers[index]) 실현손익: $\(pnLString)\(lastOneNoSpace)"
		} else {
			result += "\(tickers[index]) 매수 기록 누락\(lastOneNoSpace)"
		}
	}
	return result
}

func wonPnLs(transactions: [Transaction]) -> [Decimal] {
	let usdToWonExchangeRate: Decimal = Decimal(1_400)
	// 1. ticker를 중복없이 모은다
	// 2. ticker를 기준으로 순회하면서 각각의 realizedPnL을 구한다(배열)
	// 3. nil이 나오면 제거하고 값이있으면 1400원을 곱한다
	let tickers = transactions.reduce(into: Set<String>()) { setAcc, transaction in
		setAcc.insert(transaction.ticker)
	}
	
	let wonSum: [Decimal] = tickers.compactMap {
		guard let pnl = realizedPnL(ticker: $0, transactions: transactions) else {return nil}
		return pnl * usdToWonExchangeRate
	}
	return wonSum
}

func capitalGainTax(_ wonPnLs: [Decimal]) -> (taxableIncome: Decimal, tax: Decimal) {
	
	let basicDeduction: Decimal = Decimal(2_500_000)
	let capitalGainTaxRate: Decimal = Decimal(string: "0.22")!
	
	// 1. 전체의 PnL 합하기 (reduce)
	// 2. 과세표준(taxableIncome) 구하기 ( 금액의 -2_500_000을 하고 이게 0보다 큰것만 가져오는 코드)
	// 3. 세금 구하기: taxableIncome * Decimal(string:"0.22")
	let totalPnLs = wonPnLs.reduce(Decimal(0), +)
	let taxableIncome = Swift.max(0, (totalPnLs - basicDeduction))
	let tax = taxableIncome * capitalGainTaxRate
	return (taxableIncome: taxableIncome, tax: tax)
}


// 연간 월세 수입 ÷ (매매가격 − 월세보증금) × 100: 임대수익률
/*
 매입가: purchasePrice
 보증금: deposit
 실투자금: actualInvestment
 연 월세 수입: annualRentalIncome
 연 임대수익률: annualRentalYield
 공실: vacancy
 월 평균: monthlyAverage
 */
func rentalYield(monthlyRents: [String], purchasePrice: Decimal, deposit: Decimal) -> (annualRentalIncome: Decimal, annualRentalYield: Decimal, recentThreeMonthsAverage: Decimal) {
	let actualInvestment = purchasePrice - deposit
	let annualRentalIncomesArr = Array(monthlyRents.prefix(12))
	let threeMonthsIncomesArr = Array(annualRentalIncomesArr.suffix(3)).map { Decimal(string: $0) ?? Decimal(0) }
	let annualRentalIncomes = annualRentalIncomesArr.map { Decimal(string: $0) ?? Decimal(0) }.reduce(Decimal(0), +)
	let annualRentalYield = (annualRentalIncomes / actualInvestment) * Decimal(100)
	let recentThreeMonthsAverage = threeMonthsIncomesArr.reduce(0, +) / Decimal(3)
	return (annualRentalIncome: annualRentalIncomes, annualRentalYield: annualRentalYield, recentThreeMonthsAverage: recentThreeMonthsAverage)
}

func printRentalYield(rentalYield: (annualRentalIncome: Decimal, annualRentalYield: Decimal, recentThreeMonthsAverage: Decimal)) {
	let annualRentalYieldString: String = "\(rentalYield.annualRentalYield.formatted(.number.precision(.fractionLength(1))))%"
	let recentThreeMonthsString: String = "약 \(rentalYield.recentThreeMonthsAverage.formatted(.number.precision(.fractionLength(0))))원"
	print(
"""
연 임대수입: \(rentalYield.annualRentalIncome.formatted(.number))원
연 임대수익률: \(annualRentalYieldString)
최근 3개월 평균: \(recentThreeMonthsString)
"""
	)
}
