//
//  Helpers.swift
//  MyTool
//0
//  Created by YoonieMac on 9/30/26.
//

import Foundation


enum AcquisitionMethod {
	case purchased(price: Decimal?)
	case inherited(fairValue: Decimal)
	case selfBuilt(actualCost: Decimal?)
	
	var title: String {
		switch self {
		case .purchased: return "매매"
		case .inherited: return "상속"
		case .selfBuilt: return "신축"
		}
	}
}

struct AcquisitionValue {
	let method: AcquisitionMethod
	
	var result: Decimal? {
		switch method {
		case .purchased(let price):
			return price
		case .inherited(let fairValue):
			return fairValue
		case .selfBuilt(let actualValue):
			return actualValue
		}
	}
	
	var showResult: String {
        guard let result = self.result else {
            return "\(self.method.title)(nil): 환산가액을 계산해 주세요"
        }
        let krwAmount = KRWAmount(value: result, unitLimit: Decimal(1_000_000))
        return "\(self.method.title)(\(krwAmount.koreanUnitString())): \(result.formatted())원"
	}
}

struct KRWAmount {
    let value: Decimal
    let unitLimit: Decimal
    
    func koreanUnitString() -> String {
        var quotient = value / unitLimit
        var roundPlain = Decimal()
        NSDecimalRound(&roundPlain, &quotient, 0, .plain)
        let stringValue = "\(roundPlain)"
        let front = stringValue.count > 2 ? [String(stringValue.dropLast(2))] : []
        let lastTwo = stringValue.suffix(2).map { String($0) }
        let stringValues: [String] = front + lastTwo
        switch stringValues.count {
        case 1:
            if stringValues[0] == "0" {
                return "\(value.formatted())원"
            } else {
                return "\(stringValues[0])백만원"
            }
        case 2:
            if stringValues[1] == "0" {
                return "\(stringValues[0])천만원"
            } else {
                return "\(stringValues[0])천\(stringValues[1])백만원"
            }
        case 3:
            if stringValues[2] == "0" {
                if stringValues[1] == "0" {
                    return "\(stringValues[0])억원"
                } else {
                    return "\(stringValues[0])억\(stringValues[1])천만원"
                }
            } else {
                if stringValues[1] == "0" {
                    return "\(stringValues[0])억\(stringValues[2])백만원"
                } else {
                    return "\(stringValues[0])억\(stringValues[1])천\(stringValues[2])만원"
                }
            }
        default: return "잘못된 숫자를 넣었습니다."
        }
    }
}

// 필요경비
enum RecognizedExpense {
	static let acquisitionTax = "취득세"
	static let brokerageFee = "중개수수료"
	static let legalFee = "법무사비"
}
let expenseItems: [(name: String, amount: Decimal)] = [
	(name: "취득세", amount: Decimal(3_000_000)),
	(name: "중개수수료", amount: Decimal(1_200_000)),
	(name: "법무사비", amount: Decimal(500_000)),
	(name: "도배장판", amount: Decimal(800_000)),
	(name: "재산세", amount: Decimal(600_000))
]

// 건강보험료 기준
enum HealthInsuranceConstants {
	// 재산 9억 초과일때 (무조건 과세대상), 9억~5.4억 일때 소득구간 확인
	static let propertyUpperBound: Decimal = Decimal(900_000_000)
	static let propertyLowerBound: Decimal = Decimal(540_000_000)
	// 재산 5.4억 이하일때 소득 기준 (소득이 이게 넘으면 과세)
	static let standardIncomeThreshold: Decimal = Decimal(20_000_000)
	// 재산 5.4억 - 9억 구간일때 소득 기준 (소득이 이게 넘으면 과세)
	static let strictIncomeThreshold: Decimal = Decimal(10_000_000)
}

// 건강보험 피부양자 자격
enum DependentQualification: String {
	case Qualified = "건강보험 피부양자 자격 유지"
	case disQualified = "건강보험 피부양자 자격 박탈"
}

let totalIncomeAndProperties: [(totalIncome: Decimal, propertyTaxBase: Decimal)] = [
	(totalIncome: Decimal(15_000_000), propertyTaxBase: Decimal(300_000_000)),
	(totalIncome: Decimal(25_000_000), propertyTaxBase: Decimal(300_000_000)),
	(totalIncome: Decimal(8_000_000), propertyTaxBase: Decimal(600_000_000)),
	(totalIncome: Decimal(15_000_000), propertyTaxBase: Decimal(600_000_000)),
	(totalIncome: Decimal(5_000_000), propertyTaxBase: Decimal(1_000_000_000)),
	(totalIncome: Decimal(5_000_000), propertyTaxBase: Decimal(900_000_000)),
	(totalIncome: Decimal(15_000_000), propertyTaxBase: Decimal(900_000_000))
]

