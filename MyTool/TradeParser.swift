//
//  TradeParser.swift
//  MyTool
//
//  Created by YoonieMac on 9/20/26.
//

import Foundation




struct TradeParser {
	
	static var parserError: String = ""
	
	static func parse(line: String) -> Transaction? {
		let fields = line.split(separator: ",", omittingEmptySubsequences: false )
			.map { String($0) }
		guard fields.count == 6 else {
			self.parserError = "필드 개수가 맞지 않음"
			return nil
		}
		let date = fields[0]
		let ticker = fields[2]
		guard let type = TransactionType(rawValue: fields[1]) else {
			self.parserError = "Not Transaction Type"
			return nil
		}
		guard let _ = Int(fields[3]) else {
			self.parserError = "Not proper quantity type"
			return nil
		}
		guard let _ = Double(fields[4]) else {
			self.parserError = "Not proper unit price type"
			return nil
		}
		guard let _ = Double(fields[5]) else {
			self.parserError = "Not proper trade fee type"
			return nil
		}
		guard let qty = Decimal(string: fields[3]), qty >= 0 else {
			self.parserError = "수량 타입 변환 실패"
			return nil
		}
		guard let price = Decimal(string: fields[4]), price >= 0 else {
			self.parserError = "단가 타입 변환 실패"
			return nil
		}
		guard let fee = Decimal(string: fields[5]), fee >= 0 else {
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
