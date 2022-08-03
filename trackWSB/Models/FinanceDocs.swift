//
//  PostData.swift
//  HackerNews
//
//  Created by a-robota on 4/19/22.
//

import Foundation


// https://api.polygon.io/v2/aggs/ticker/AAPL/range/1/day/2021-07-22/2021-07-22?adjusted=true&sort=asc&limit=120&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD


//// daily open cloase
//https://api.polygon.io/v1/open-close/AAPL/2020-10-14?adjusted=true&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD
//
//{
//    "afterHours": 322.1,
//    "close": 325.12,
//    "from": "2020-10-14T00:00:00.000Z",
//    "high": 326.2,
//    "low": 322.3,
//    "open": 324.66,
//    "preMarket": 324.5,
//    "status": "OK",
//    "symbol": "AAPL",
//    "volume": 26122646
//}


//To get financials based on filings that have happened after January 1, 2009 use the query param filing_date.gte=2009-01-01
//
//
//https://api.polygon.io/vX/reference/financials?ticker=aapl&filing_date=2020-06-01&timeframe=quarterly&include_sources=true&order=asc&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD
//RESPONSE OBJECT
//{
//    "results": [],
//    "status": "OK",
//    "request_id": "832c9da9f341c163286f6f07f99a2eef"
//}

// https://app.quicktype.io



struct FinanceDocs: Decodable, Encodable, Identifiable {
    
    var id: String { // .. to use objectID (from .json fetch) as uniqueID
        return request_id
    }
    let request_id: String
    let status : String
    let allDocsResults : [docsResults]

    enum codingKeys : String, CodingKey {
        case request_id
        case status
        case allDocsResults
    }

    init (request_id: String, status: String, allDocsResults: [docsResults]) {
        self.request_id = request_id
        self.status = status
        self.allDocsResults = allDocsResults
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.request_id = try container.decode(String.self, forKey: .request_id)
        self.status = try container.decode(String.self, forKey: .status)
        self.allDocsResults = try container.decode([docsResults].self, forKey: .allDocsResults)
    }

    func encode(to encoder: Encoder) throws {
        guard var container = try? encoder.container(keyedBy: codingKeys.self) else { throw FinanceDocsError.encodingError}
        try container.encode(request_id, forKey: .request_id)
        try container.encode(status, forKey: .status)
        print("[+] Encoding Container \(container)")

    }
}

struct docsResults: Decodable, Encodable {
    let docResults : [String]

    enum codingKeys : String, CodingKey {
        case docResults
    }
    init(docResults: [String]) {
        self.docResults = docResults
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.docResults = try container.decode([String].self, forKey: .docResults)
    }
    func encode(to encoder: Encoder) throws {
        guard var container = try? encoder.container(keyedBy: codingKeys.self) else { throw FinanceDocsError.encodingError }
        try container.encode(docResults, forKey: .docResults)
        print("[+] Encoding Container \(container)")
    }
}



public enum FinanceDocsError : Error {
    case codingError
    case encodingError
}
extension FinanceDocsError {
    public var docErrorDescrption : String {
        switch self {
            case .codingError : return "error doc in decoder"
            case .encodingError : return "error in doc encoder"
        }
    }
}
