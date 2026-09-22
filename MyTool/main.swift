import Foundation


if let tradeURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first?.appending(component: "trades.csv", directoryHint: .notDirectory) {
    
    
    let tradeText = try String(contentsOf: tradeURL, encoding: .utf8)
    let tradeTexts = tradeText.components(separatedBy: "\n").filter { !$0.isEmpty }
    
    var transactions: [Transaction] = []
    
    for (index, tradeData) in tradeTexts.enumerated() {
        let result = TradeParser.parse(line: tradeData)
        do {
            let transaction = try result.get()
            transactions.append(transaction)
        } catch {
            // TODO: 할 일을 할것
        }
//            transactions.append(transaction)
//        } else {
//            print("\(index) 번 \(tradeData.components(separatedBy: ",")[2]) \(TradeParser.parserError)")
//        }
    }
    print(transactions)
}
