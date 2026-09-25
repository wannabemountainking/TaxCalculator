//
//  AvgCost.swift
//  MyTool
//
//  Created by YoonieMac on 9/24/26.
//

import Foundation


struct AvgCost {
	
	static func averageUnitPrice(ticker: String, transactions: [Transaction]) -> Decimal? {
		let buyTransactions = transactions.filter({ $0.ticker == ticker && $0.type == .buy })
		let result = buyTransactions.reduce(into: (sum: Decimal(0), qty: Decimal(0))) { tupleAcc, transaction in
			tupleAcc.sum += (transaction.unitPrice * transaction.quantity) + transaction.tradeFee
			tupleAcc.qty += transaction.quantity
		}
		if result.qty == 0 {
			return nil
		} else {
			var meanPrice = result.sum / result.qty
			
			var rounded = Decimal()
			NSDecimalRound(&rounded, &meanPrice, 2, .plain)
			print(rounded)
			return rounded
		}
	}
}
