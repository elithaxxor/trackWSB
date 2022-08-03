// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsModel = try? newJSONDecoder().decode(NewsModel.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.newsModelTask(with: url) { newsModel, response, error in
//     if let newsModel = newsModel {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - NewsModel
struct NewsModel: Codable {
    var results: [Result02]
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
struct Result02: Codable {
    var id: String
    var publisher: Publisher
    var title, author: String
    var publishedUTC: Date
    var articleURL: String
    var tickers: [String]
    var imageURL: String
    var resultDescription: String
    var keywords: [String]?
    var ampURL: String?

    enum CodingKeys: String, CodingKey {
        case id, publisher, title, author
        case publishedUTC = "published_utc"
        case articleURL = "article_url"
        case tickers
        case imageURL = "image_url"
        case resultDescription = "description"
        case keywords
        case ampURL = "amp_url"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.publisherTask(with: url) { publisher, response, error in
//     if let publisher = publisher {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Publisher
struct Publisher: Codable {
    var name: Name
    var homepageURL: String
    var logoURL: String
    var faviconURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case homepageURL = "homepage_url"
        case logoURL = "logo_url"
        case faviconURL = "favicon_url"
    }
}

enum Name: String, Codable {
    case marketWatch = "MarketWatch"
    case theMotleyFool = "The Motley Fool"
    case zacksInvestmentResearch = "Zacks Investment Research"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
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

    func newsModelTask(with url: URL, completionHandler: @escaping (NewsModel?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
