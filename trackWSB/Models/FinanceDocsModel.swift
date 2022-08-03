// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let financeDocsModel = try? newJSONDecoder().decode(FinanceDocsModel.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.financeDocsModelTask(with: url) { financeDocsModel, response, error in
//     if let financeDocsModel = financeDocsModel {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - FinanceDocsModel
struct FinanceDocsModel: Codable {
    var results: [Result01]
    var status, requestID: String
    var count: Int
    var nextURL: String

    enum CodingKeys: String, CodingKey {
        case results, status
        case requestID = "request_id"
        case count
        case nextURL = "next_url"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.resultTask(with: url) { result, response, error in
//     if let result = result {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Result
struct Result01: Codable {
    var financials: Financials
    var startDate, endDate, filingDate, cik: String
    var companyName, fiscalPeriod, fiscalYear: String
    var sourceFilingURL: String
    var sourceFilingFileURL: String

    enum CodingKeys: String, CodingKey {
        case financials
        case startDate = "start_date"
        case endDate = "end_date"
        case filingDate = "filing_date"
        case cik
        case companyName = "company_name"
        case fiscalPeriod = "fiscal_period"
        case fiscalYear = "fiscal_year"
        case sourceFilingURL = "source_filing_url"
        case sourceFilingFileURL = "source_filing_file_url"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.financialsTask(with: url) { financials, response, error in
//     if let financials = financials {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Financials
struct Financials: Codable {
    var comprehensiveIncome: ComprehensiveIncome
    var incomeStatement, balanceSheet: [String: BalanceSheet]
    var cashFlowStatement: CashFlowStatement

    enum CodingKeys: String, CodingKey {
        case comprehensiveIncome = "comprehensive_income"
        case incomeStatement = "income_statement"
        case balanceSheet = "balance_sheet"
        case cashFlowStatement = "cash_flow_statement"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.balanceSheetTask(with: url) { balanceSheet, response, error in
//     if let balanceSheet = balanceSheet {
//       ...
//     }
//   }
//   task.resume()

// MARK: - BalanceSheet
struct BalanceSheet: Codable {
    var label: String
    var value: Double
    var unit: Unit
    var order: Int
}

enum Unit: String, Codable {
    case usd = "USD"
    case usdShares = "USD / shares"
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.cashFlowStatementTask(with: url) { cashFlowStatement, response, error in
//     if let cashFlowStatement = cashFlowStatement {
//       ...
//     }
//   }
//   task.resume()

// MARK: - CashFlowStatement
struct CashFlowStatement: Codable {
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.comprehensiveIncomeTask(with: url) { comprehensiveIncome, response, error in
//     if let comprehensiveIncome = comprehensiveIncome {
//       ...
//     }
//   }
//   task.resume()

// MARK: - ComprehensiveIncome
struct ComprehensiveIncome: Codable {
    var otherComprehensiveIncomeLoss, comprehensiveIncomeLossAttributableToParent, otherComprehensiveIncomeLossAttributableToParent, comprehensiveIncomeLoss: BalanceSheet
    var comprehensiveIncomeLossAttributableToNoncontrollingInterest: BalanceSheet

    enum CodingKeys: String, CodingKey {
        case otherComprehensiveIncomeLoss = "other_comprehensive_income_loss"
        case comprehensiveIncomeLossAttributableToParent = "comprehensive_income_loss_attributable_to_parent"
        case otherComprehensiveIncomeLossAttributableToParent = "other_comprehensive_income_loss_attributable_to_parent"
        case comprehensiveIncomeLoss = "comprehensive_income_loss"
        case comprehensiveIncomeLossAttributableToNoncontrollingInterest = "comprehensive_income_loss_attributable_to_noncontrolling_interest"
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder0() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder0() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func financeDocsModelTask(with url: URL, completionHandler: @escaping (FinanceDocsModel?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
