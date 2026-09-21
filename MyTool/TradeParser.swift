//
//  TradeParser.swift
//  MyTool
//
//  Created by YoonieMac on 9/20/26.
//

import Foundation




struct TradeParser {
	
	static var parserError: String = ""
	
	static func readLine(line: String) -> Transaction? {
		let dataArray = line.split(separator: ",", omittingEmptySubsequences: false )
			.map { String($0) }
		guard dataArray.count == 6 else {
			guard dataArray.count > 0 else {
				self.parserError = "empty line error"
				return nil
			}
			self.parserError = "fields are not filled"
			return nil
		}
		let date = dataArray[0]
		let ticker = dataArray[2]
		guard let type = TransactionType(rawValue: dataArray[1]) else {
			self.parserError = "Not Transaction Type"
			return nil
		}
		guard let quantity = Int(dataArray[3]), quantity >= 0 else {
			self.parserError = "Not proper quantity type"
			return nil
		}
		guard let unitPrice = Double(dataArray[4]), unitPrice >= 0 else {
			self.parserError = "Not proper unit price type"
			return nil
		}
		guard let tradeFee = Double(dataArray[5]), tradeFee >= 0 else {
			self.parserError = "Not proper trade fee type"
			return nil
		}
		guard let qty = Decimal(string: dataArray[3]) else {
			self.parserError = "수량 타입 변환 실패"
			return nil
		}
		guard let price = Decimal(string: dataArray[4]) else {
			self.parserError = "단가 타입 변환 실패"
			return nil
		}
		guard let fee = Decimal(string: dataArray[5]) else {
			self.parserError = "중개수수료 타입 변환 실패"
			return nil
		}
		
		return Transaction(
			date: date,
			type: type,
			ticker: ticker,
			quantity: qty,
			unitPrice: price,
			tradeFee: fee
		)
	}
}
