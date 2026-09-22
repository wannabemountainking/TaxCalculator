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
