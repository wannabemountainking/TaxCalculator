//
//  Helpers.swift
//  MyTool
//
//  Created by yoonie on 9/28/26.
//

import Foundation


struct CapicalGainTax {
    
    static let basicDeduction: Decimal = Decimal(string: "2_500_000") ?? Decimal()
    
    let ticker: String
    var avaragePurchaseUnitPrice: Decimal?
    let quantity: Decimal
    let salePrice: Decimal

    var capitalGain: Decimal?
    var taxableIncome: Decimal {
        Swift.max(0, capitalGain - basicDeduction)
    }
}
