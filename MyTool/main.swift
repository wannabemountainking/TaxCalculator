import Foundation


let tradeURL = URL(filePath: "/Users/yooniemac/Desktop/TaxCalculator/trades.csv", directoryHint: .notDirectory)

let tradeText = try String(contentsOf: tradeURL, encoding: .utf8)
let tradeTexts = tradeText.components(separatedBy: "\n").filter { !$0.isEmpty }

var transactions: [Transaction] = []

for (index, tradeData) in tradeTexts.enumerated() {
	if let transaction = TradeParser.parse(line: tradeTexts[index]) {
		transactions.append(transaction)
	} else {
		print("\(index) 번 \(tradeData.components(separatedBy: ",")[2]) \(TradeParser.parserError)")
	}
}
print(transactions)

