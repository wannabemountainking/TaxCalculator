//
//  Transaction.swift
//  MyTool
//
//  Created by YoonieMac on 9/20/26.
//

import Foundation

enum TransactionType: String {
	case sell = "SELL"
	case buy = "BUY"
	case dividend = "DIV"
}

struct Transaction: Identifiable {
	let id = UUID()
	let date: String
	let type: TransactionType
	let ticker: String
	let quantity: Decimal
	let unitPrice: Decimal
	let tradeFee: Decimal
}

struct TransactionTax {
	let grossAmount: Decimal
	var withholdingTax: Decimal {
		var withholding = grossAmount * Decimal(string: "0.15")!
		var rounded = Decimal()
		NSDecimalRound(
			&rounded,
			&withholding,
			2,
			.plain
		)
		return rounded
	}
	var netAmount: Decimal {
		guard grossAmount != 0 else { return 0 }
		var pureNet = grossAmount - withholdingTax
		var rounded = Decimal()
		NSDecimalRound(
			&rounded,
			&pureNet,
			2,
			.plain
		)
		return rounded
	}
}
