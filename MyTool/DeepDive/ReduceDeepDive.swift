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

// 양도차익
/*
 양도가액	Transfer price / Sale price	transferPrice
 취득가액	Acquisition value	acquisitionValue (이미 struct 이름으로 씀 — 변수로 쓸 땐 acquisitionValue.result)
 필요경비	Necessary (deductible) expenses	necessaryExpenses
 인정 항목	Recognized/Deductible items	recognizedExpenses (이미 enum 이름공간으로 지으셨죠)
 양도차익	Capital gain (on transfer)	capitalGain (4-B에서 CapitalGainTax를 이미 쓰셨으니, 헷갈리지 않게 이번엔 transferGain처럼 구분할 수도 있습니다)
 항목명	Item name	name
 금액	Amount	amount
 */
func transferGain(
	transferPrice: Decimal,
	acquisitionValue: Decimal?,
	necessaryExpenses: [(name: String, amount: Decimal)],
	recognizedExpenses: [String]
) -> (transferGain: Decimal?, recognizedNecessaryExpenses: Decimal) {
	let recognizedNecessaryExpenses = necessaryExpenses
		.filter { necessary in recognizedExpenses.contains(where: { $0 == necessary.name }) }
		.reduce(Decimal(0)) { $0 + $1.amount }
	guard let acquisitionValue else { return (transferGain: nil, recognizedNecessaryExpenses: recognizedNecessaryExpenses) }
	let result = transferPrice - acquisitionValue - recognizedNecessaryExpenses
	return (transferGain: result, recognizedNecessaryExpenses: recognizedNecessaryExpenses)
}

func transferGainKUS(
	transferPrice: Decimal,
	acquisitionValue: Decimal?,
	necessaryExpenses: [(name: String, amount: Decimal)],
	recognizedExpenses: [String]
) -> String? {
	
	let transferGainResult = transferGain(
		transferPrice: transferPrice,
		acquisitionValue: acquisitionValue,
		necessaryExpenses: necessaryExpenses,
		recognizedExpenses: recognizedExpenses
	)
	// 양도가액 스트링
	let unitLimit = Decimal(1_000_000)
	let transferPriceKUS = KRWAmount(value: transferPrice, unitLimit: unitLimit).koreanUnitString()
	
	// 취득가액 스트링
	guard let transferGain = transferGainResult.transferGain,
		  let acquisitionValue else {return nil}
	let acquisitionnValueKUS = KRWAmount(
		value: acquisitionValue,
		unitLimit: unitLimit
	).koreanUnitString()
	
	// 인정 필요경비 스트링
	let recognizedNecessareExpensesKUS = KRWAmount(
		value: transferGainResult.recognizedNecessaryExpenses,
		unitLimit: unitLimit
	).koreanUnitString()
	
	// 양도차익 스트링
	let transferGainKUS = KRWAmount(
		value: transferGain,
		unitLimit: unitLimit
	).koreanUnitString()

	return
		"""
		양도가액: \(transferPrice.formatted())원 (약 \(transferPriceKUS))
		취득가액: \(acquisitionValue.formatted())원 (약 \(acquisitionnValueKUS))
		인정 필요경비: \(transferGainResult.recognizedNecessaryExpenses.formatted())원 (약 \(recognizedNecessareExpensesKUS))
		양도차익: \(transferGain.formatted())원 (약 \(transferGainKUS))
		"""
}

func comprehensiveTaxationCheck(financialIncome: Decimal, limit: Decimal) -> (isOverThreshold:Bool, excessAmount: Decimal) {
	let difference = financialIncome - limit
	let isOverThreshold = difference > 0
	let excessAmount = max(Decimal(0), difference)
	return (isOverThreshold: isOverThreshold, excessAmount: excessAmount)
}

func dependentQualificationCheck(totalIncome: Decimal, propertyTaxBase: Decimal) -> DependentQualification {
	if propertyTaxBase > HealthInsuranceConstants.propertyUpperBound {
		return .disQualified
	} else if propertyTaxBase > HealthInsuranceConstants.propertyLowerBound {
		if totalIncome > HealthInsuranceConstants.strictIncomeThreshold {
			return .disQualified
		} else {
			return .Qualified
		}
	} else {
		if totalIncome > HealthInsuranceConstants.standardIncomeThreshold {
			return .disQualified
		} else {
			return .Qualified
		}
	}
}

// 월 건강보험료, 장기요양보험료
/*
 1. 초과분 = max(0, 보수외소득합계 - 2,000만원)
 2. 소득월액 = 초과분 ÷ 12
 3. 소득월액보험료(월) = 소득월액 × 7.19%
 4. 장기요양보험료(월) = 소득월액보험료 × (0.9448% ÷ 7.19%)
 5. 연간추가부담 = (소득월액보험료 + 장기요양보험료) × 12
 초과분 excessAmount
 소득월액 monthlyIncomeAmount
 소득월액보험료 monthlyIncomePremium
 장기요양보험료 monthlyLongTermCarePremium
 연간추가부담 annualAdditionalBurden
 */

func employeeIncomePremium(employmentExcessIncome: Decimal) -> (
    monthlyIncomePremium: Decimal,
    monthlyLongTermCarePremium: Decimal,
    annualAdditionalBurden: Decimal
) {
    let excessAmount = max(0, employmentExcessIncome - Decimal(20_000_000))
    let monthlyIncomeAmount = excessAmount / Decimal(12)
    
    let monthlyIncomePremium = (monthlyIncomeAmount * HealthInsurancePremium.monthlyIncomePremiumRate).truncateToTen(to: -1)
    let monthlyLongTermCarePremium = (monthlyIncomePremium * (HealthInsurancePremium.monthlyLongTermCarePremiumRate / HealthInsurancePremium.monthlyIncomePremiumRate)).truncateToTen(to: -1)
    let annualAdditionalBurden = (monthlyIncomePremium + monthlyLongTermCarePremium) * Decimal(12)
    
    return (
        monthlyIncomePremium: monthlyIncomePremium,
        monthlyLongTermCarePremium: monthlyLongTermCarePremium,
        annualAdditionalBurden: annualAdditionalBurden
    )
}


