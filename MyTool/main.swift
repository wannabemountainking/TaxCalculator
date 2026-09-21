import Foundation


let tradeURL = URL(filePath: "/Users/yooniemac/Desktop/TaxCalculator/trades.csv", directoryHint: .notDirectory)

let tradeText = try String(contentsOf: tradeURL, encoding: .utf8)
let tradeTexts = tradeText.components(separatedBy: "\n").filter { !$0.isEmpty }

var transactions: [Transaction] = []

for tradeData in tradeTexts {
	if let transaction = TradeParser.readLine(line: tradeData) {
		transactions.append(transaction)
	} else {
		print(TradeParser.parserError)
	}
}
print(transactions)

