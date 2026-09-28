//
//  Helpers.swift
//  MyTool
//
//  Created by yoonie on 9/28/26.
//

import Foundation


struct CapitalGainTax {
    
    static var basicDeduction: Decimal = Decimal(2_500_000)
    
    static var taxRate: Decimal? = Decimal(string: "0.22")
    static var usdToKrwExchangeRate : Decimal = Decimal(1_400)
    
    let ticker: String
    var averagePurchaseUnitPrice: Decimal?
    let quantity: Decimal

    var capitalGain: Decimal? {
        guard let averagePurchaseUnitPrice else {return nil}
        return quantity * averagePurchaseUnitPrice
    }
    var taxableIncome: Decimal? {
        guard let capitalGain else {return nil}
        let usdToKrwExchangeRate = CapitalGainTax.usdToKrwExchangeRate
        let capitalGainForWon = capitalGain * usdToKrwExchangeRate
        let basic = CapitalGainTax.basicDeduction
        return Swift.max(0, capitalGainForWon - basic)
    }
    
    var taxValueForDollar: Decimal? {
        guard let taxableIncome = taxableIncome,
              let taxRate = CapitalGainTax.taxRate else { return nil }
        return taxableIncome * taxRate
    }
    
    var taxValueForWon: Decimal? {
        guard let dollarValue = taxValueForDollar else { return nil }
        let rate = CapitalGainTax.usdToKrwExchangeRate
        return dollarValue * rate
    }
}
