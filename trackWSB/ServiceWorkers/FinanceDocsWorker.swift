//
//  FinanceDocsWorker.swift
//  Finance_App01
//
//  Created by a-robota on 6/1/22.
//


// https://app.quicktype.io
import Foundation

class FinanceDocsWorker: ObservableObject {
    let asset : Asset?
    let equities : [SearchResult]
    @IBInspectable var stockSymbol : String
    @Published var docs: [FinanceDocs]
    @Published var docsResults : [docsResults]

    init(asset: Asset?, equities: [SearchResult], stockSymbol: String, docs: [FinanceDocs], docsResults: [docsResults] ) throws {
        self.asset = asset
        self.equities = equities
        self.stockSymbol = stockSymbol
        self.docs = docs
        self.docsResults = docsResults
        try? fetchAPI()
    }


    private func fetchAPI() throws {

        let docsAPI: String = "pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"
        var docsURL: String = "https://api.polygon.io/v2/aggs/ticker/AAPL/range/1/day/2020-06-01/2020-06-17?apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"

        guard docsURL == docsURL else { throw FinanceAPIError.apiStringError }
        guard let url = URL(string: docsURL) else { throw FinanceAPIError.apiStringError }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { print(["[-] No Data in Doc Fetch "]); return }
            guard error == nil else { print("[-] Error: \(String(describing: error))"); return }
            guard let response = response as? HTTPURLResponse else {print("[-] Invalid Response"); return}
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("[-] Fetch Fin Docs Status Code is not 200 \(response.statusCode) \(response.allHeaderFields)")
                return
            }
            let stringifyJSON = String(data: data, encoding: .utf8)
            let newModel = try? JSONDecoder().decode(FinanceDocs.self, from: data)
            DispatchQueue.main.async {
                self.docs.append(newModel!)
            }
            print("[+] Success! Downloaded docsAPI Info \(response.statusCode)")
            print(data)
            print(stringifyJSON ?? "This should display the stringified json")
        }.resume()
    }
}

enum FinanceAPIError : Error {
    case fetchApiError
    case apiStringError
    case apiDataError
    case modelError
}
extension FinanceAPIError {
    public var FinanceAPIdescription : String {
        switch self {
            case .fetchApiError : return "Error in Fetching Finance Docs API"
            case .apiStringError : return "Error in passing Finance Docs String"
            case .apiDataError : return "Error in parsing URLs Data"
            case .modelError : return "Error in Finance Docs building model"
        }
    }
}
