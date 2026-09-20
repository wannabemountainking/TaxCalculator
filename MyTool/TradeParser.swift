//
//  TradeParser.swift
//  MyTool
//
//  Created by YoonieMac on 9/20/26.
//

import Foundation

struct TradeParser {
	
	var parserError: String = ""
	
	mutating func readLine(line: String) -> Transaction? {
		let dataArray = line.split(separator: ",", omittingEmptySubsequences: true )
			.map { String($0) }
		guard dataArray.count == 6 else {
			guard dataArray.count > 0 else {
				self.parserError = "빈줄입니다"
				return nil
			}
			self.parserError = "필드 개수가 부족합니다"
			return nil
		}
		let date = dataArray[0]
		let ticker = dataArray[2]
		guard let type = TransactionType(rawValue: dataArray[1]) else {
			self.parserError = "모르는 거래 종류입니다"
			return nil
		}
		guard let quantity = Int(dataArray[3]) else {
			self.parserError = "수량이 적절한 숫자타입이 아닙니다"
			return nil
		}
		guard let unitPrice = Decimal(string: dataArray[4]) else {
			self.parserError = "단가가 적절한 숫자 타입이 아닙니다"
			return nil
		}
		guard let tradeFee = Decimal(string: dataArray[5]) else {
			self.parserError = "거래수수료가 적절한 숫자 타입이 아닙니다"
			return nil
		}
		return Transaction(
			date: date,
			type: type,
			ticker: ticker,
			quantity: quantity,
			unitPrice: unitPrice,
			tradeFee: tradeFee
		)
	}
}
