//
//  ReduceDeepDive.swift
//  MyTool
//
//  Created by YoonieMac on 9/24/26.
//

import Foundation


func groupWordsByLength() {
	let words = ["cat", "dog", "swift", "ios", "code", "ai"]
	let byLength = words.reduce(into: [Int: [String]]()) { dictAcc, word in
		let key = word.count
		dictAcc[key, default: []].append(word)
	}
	print(byLength)
}

func separateEvenAndOdd() {
	let numbers = [4, 7, 2, 9, 12, 15, 6, 3]
	let evenAndOddTuple = numbers.reduce(into: (evenArr: [Int](), oddArr: [Int]())) { tupleAcc, number in
		if number.isMultiple(of: 2) {
			tupleAcc.evenArr.append(number)
		} else {
			tupleAcc.oddArr.append(number)
		}
	}
	print(evenAndOddTuple)
}
