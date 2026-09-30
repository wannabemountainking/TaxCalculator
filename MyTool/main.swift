import Foundation




if let tradeURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first?.appending(components: "TaxCalculator", "trades.csv", directoryHint: .notDirectory) {
    
    
    let tradeText = try String(contentsOf: tradeURL, encoding: .utf8)
    let tradeTexts = tradeText.components(separatedBy: "\n").filter { !$0.isEmpty }
	
	let transactions = tradeTexts.enumerated().compactMap { (index: Int, tradeContents: String) in
		let result = TradeParser.parse(line: tradeContents)
		switch result {
		case .success(let transaction):
			return transaction
		case .failure(let error):
			switch error {
			case .lackOfFieldsError:
				print("\(index + 1)번째 줄, 에러 내용: 필드 개수가 맞지 않습니다")
			case .transactionTypeError:
				print("\(index + 1)번째 줄, 에러 내용: 적절한 Transaction 타입이 아닙니다")
			case .quantityError:
				print("\(index + 1)번째 줄, 에러 내용: 적절한 Quantity 타입이 아닙니다")
			case .unitPriceTypeError:
				print("\(index + 1)번째 줄, 에러 내용: 적절한 UnitPrice 타입이 아닙니다")
			case .tradeFeeTypeError:
				print("\(index + 1)번째 줄, 에러 내용: 적절한 중개수수료 타입이 아닙니다")
			case .unitPriceTypeConversionError:
				print("\(index + 1)번째 줄, 에러 내용: 단가의 Decimal 타입 변환에 실패했습니다")
			case .tradeFeeTypeConversionError:
				print("\(index + 1)번째 줄, 에러 내용: 중개수수료의 Decimal 타입 변환에 실패했습니다")
			}
		return nil
		}
	}
//	print(dividendReport(transactions: transactions))
	
//	let monthly = monthlyDividendSummary(transactions: transactions)
//	print(monthlyDividendPrint(result: monthly))
//	let tupleArr = topDividendTickers(transactions: transactions, n: 2)
//	print(topDividendPrint(result: tupleArr))
//	print(AvgCost.averageUnitPrice(ticker: "AAPL", transactions: transactions))
//	print(AvgCost.averageUnitPrice(ticker: "MSFT", transactions: transactions))
//	print(realizedPnLPrint(tickers: ["AAPL", "MSFT"], transactions: transactions))
//	print(capitalGainTax(wonPnLs(transactions: transactions)))
}

//var test = Decimal(100) / Decimal(3)
//var testRounded = Decimal()
//NSDecimalRound(&testRounded, &test, 2, .plain)
//print(testRounded)
//let result = rentalYield(
//	monthlyRents: [
//		"1000000", "1000000", "1000000", "1000000", "공실", "1000000", "1000000", "1000000", "1000000", "1000000", "공실", "1000000"
//	],
//	purchasePrice: Decimal(300_000_000),
//	deposit: Decimal(50_000_000)
//)
//printRentalYield(rentalYield: result)

let purchased = AcquisitionValue(method: .purchased(price: Decimal(300_000_000)))
let inherited = AcquisitionValue(method: .inherited(fairValue: Decimal(500_000_000)))
let selfBuilt = AcquisitionValue(method: .selfBuilt(actualCost: nil))

print(purchased.showResult)
print(inherited.showResult)
print(selfBuilt.showResult)
