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
		return "\(self.method.title)(\(result.formatted())): \(result.formatted())원"
	}
}
