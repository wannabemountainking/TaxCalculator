//
//  TradeParser.swift
//  MyTool
//
//  Created by YoonieMac on 9/20/26.
//

import Foundation


enum ParsingError: String, Error {
    case lackOfFieldsError
    case transactionTypeError
    case quantityError
	case unitPriceTypeError
    case tradeFeeTypeError
    case unitPriceTypeConversionError
    case tradeFeeTypeConversionError
}

struct TradeParser {
	
	static func parse(line: String) -> Result<Transaction, ParsingError> {
		let fields = line.split(separator: ",", omittingEmptySubsequences: false )
			.map { String($0) }
		guard fields.count == 6 else {
            return Result.failure(.lackOfFieldsError)
		}
		let date = fields[0]
		let ticker = fields[2]
		guard let type = TransactionType(rawValue: fields[1]) else {
            return .failure(.transactionTypeError)
		}
		guard let qtyInt = Int(fields[3]), qtyInt >= 0, let qty = Decimal(string: fields[3]) else {
            return .failure(.quantityError)
		}
		guard let unitPriceDouble = Double(fields[4]), unitPriceDouble >= 0 else {
            return .failure(.unitPriceTypeError)
		}
		guard let tradeFeeDouble = Double(fields[5]), tradeFeeDouble >= 0 else {
            return .failure(.tradeFeeTypeError)
		}
		guard let price = Decimal(string: fields[4]) else {
            return .failure(.unitPriceTypeConversionError)
		}
		guard let fee = Decimal(string: fields[5]) else {
            return .failure(.tradeFeeTypeConversionError)
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
