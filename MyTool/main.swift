import Foundation

// 
//
//if let tradeURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first?.appending(components: "TaxCalculator", "trades.csv", directoryHint: .notDirectory) {
//    
//    
//    let tradeText = try String(contentsOf: tradeURL, encoding: .utf8)
//    let tradeTexts = tradeText.components(separatedBy: "\n").filter { !$0.isEmpty }
//	
//	let transactions = tradeTexts.enumerated().compactMap { (index: Int, tradeContents: String) in
//		let result = TradeParser.parse(line: tradeContents)
//		switch result {
//		case .success(let transaction):
//			return transaction
//		case .failure(let error):
//			switch error {
//			case .lackOfFieldsError:
//				print("\(index + 1)번째 줄, 에러 내용: 필드 개수가 맞지 않습니다")
//			case .transactionTypeError:
//				print("\(index + 1)번째 줄, 에러 내용: 적절한 Transaction 타입이 아닙니다")
//			case .quantityError:
//				print("\(index + 1)번째 줄, 에러 내용: 적절한 Quantity 타입이 아닙니다")
//			case .unitPriceTypeError:
//				print("\(index + 1)번째 줄, 에러 내용: 적절한 UnitPrice 타입이 아닙니다")
//			case .tradeFeeTypeError:
//				print("\(index + 1)번째 줄, 에러 내용: 적절한 중개수수료 타입이 아닙니다")
//			case .unitPriceTypeConversionError:
//				print("\(index + 1)번째 줄, 에러 내용: 단가의 Decimal 타입 변환에 실패했습니다")
//			case .tradeFeeTypeConversionError:
//				print("\(index + 1)번째 줄, 에러 내용: 중개수수료의 Decimal 타입 변환에 실패했습니다")
//			}
//		return nil
//		}
//	}
//}

//groupWordsByLength()
//separateEvenAndOdd()
