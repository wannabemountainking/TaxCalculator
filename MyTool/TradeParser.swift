//
//  TradeParser.swift
//  MyTool
//
//  Created by YoonieMac on 9/20/26.
//

import Foundation


enum ParsingError: Error {
    case lackOfFieldsError(desc: String)
    case transactionTypeError(desc: String)
    case quantityTypeError(desc: String)
    case unitPriceTypeError(desc: String)
    case tradeFeeTypeError(desc: String)
    case quantityTypeConversionError(desc: String)
    case unitPriceTypeConversionError(desc: String)
    case tradeFeeTypeConversionError(desc: String)
}

struct TradeParser {
	
	static func parse(line: String) -> Result<Transaction, ParsingError> {
		let fields = line.split(separator: ",", omittingEmptySubsequences: false )
			.map { String($0) }
		guard fields.count == 6 else {
            return Result.failure(.lackOfFieldsError(desc: "필드 개수가 맞지 않습니다"))
		}
		let date = fields[0]
		let ticker = fields[2]
		guard let type = TransactionType(rawValue: fields[1]) else {
            return .failure(.transactionTypeError(desc: "Transaction 타입이 아닙니다"))
		}
		guard let _ = Int(fields[3]) else {
            return .failure(.quantityTypeError(desc: "수량으로 적절하지 않은 타입입니다"))
		}
		guard let _ = Double(fields[4]) else {
            return .failure(.unitPriceTypeError(desc: "단가로 적절하지 않은 타입입니다"))
		}
		guard let _ = Double(fields[5]) else {
            return .failure(.tradeFeeTypeError(desc: "중개수수료로 적절하지 않은 타입입니다"))
		}
		guard let qty = Decimal(string: fields[3]), qty >= 0 else {
            return .failure(.quantityTypeConversionError(desc: "수량의 타입변환(Int -> Decimal)에 실패했습니다"))
		}
		guard let price = Decimal(string: fields[4]), price >= 0 else {
            return .failure(.unitPriceTypeConversionError(desc: "단가의 타입변환(Double -> Decimal)에 실패했습니다"))
		}
		guard let fee = Decimal(string: fields[5]), fee >= 0 else {
            return .failure(.tradeFeeTypeConversionError(desc: "중개수수료의 타입변환(Double -> Decimal)에 실패했습니다"))
		}
		
        return .success(
            Transaction(
                date: date,
                type: type,
                ticker: ticker,
                quantity: qty,
                unitPrice: price,
                tradeFee: fee
            )
        )
	}
}
