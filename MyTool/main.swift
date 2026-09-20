import Foundation


let tradeURL = URL(filePath: "/Users/yooniemac/Desktop/TaxCalculator/trades.csv", directoryHint: .notDirectory)

let tradeText = try String(contentsOf: tradeURL, encoding: .utf8)

var parser = TradeParser()
var array = parser.readLine(line: String(tradeText.split(separator: "\n")[0]))
print(array)
