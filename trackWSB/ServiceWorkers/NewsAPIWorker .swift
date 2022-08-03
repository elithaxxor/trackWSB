//
//  NewsAPIWorker .swift
//  Finance_App01
//
//  Created by a-robota on 6/2/22.
//

//   let task = URLSession.shared.newsAPIModelTask(with: url) { newsAPIModel, response, error in
//     if let newsAPIModel = newsAPIModel {
//       ...
//     }
//   }
//   task.resume()

//
// To read values from URLs:
//
//   let task = URLSession.shared.publisherTask(with: url) { publisher, response, error in
//     if let publisher = publisher {
//       ...
//     }
//   }
//   task.resume()


import Foundation
import Combine
import SwiftUI


class NewsAPIWorker : ObservableObject {

    @IBInspectable
    var newsAPIKey : String = "pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"
    @IBInspectable
    var newsURL : String = "https://api.polygon.io/v2/reference/news?ticker=AAPL&order=asc&limit=50&sort=published_utc&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"


    @Published var newsAPIModel : [NewsModel] = []
    var cancellables = Set<AnyCancellable>()

    weak var delegate: DataModelDelegate?
    
    init() {
        try? fetchAPI()
        //  self.newsAPIKey = newsAPIKey
    //    self.newsURL = newsURL
        self.newsAPIModel = newsAPIModel
    }
    func fetchAPI() throws {
        print("[!] Fetching API info or newsVC ! ")
        guard let apiURL = URL(string: newsURL.self) else { throw newsAPIerrors.apiURLerr }
        URLSession.shared.dataTaskPublisher(for: apiURL)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> JSONDecoder.Input in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else { throw URLError(.badServerResponse)}
                return data
            }

            .decode(type: [NewsModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                print("[!] Main thread has parsed:  \(apiURL)")
                print("[+] Completion:  \(completion)")

            } receiveValue: { [weak self] (fetchedResults) in
                self?.newsAPIModel = fetchedResults
                print("[+] News Recieved Value: \(String(describing: self?.newsAPIModel) )")
            }
            .store(in: &cancellables)
    }

    func handleRequestData(symbol: String?) throws -> [NewsModel] {
        let data = self.newsAPIModel
        let stringifyData = try String(from: data as! Decoder)
        print("[!] Handle Request Data for News has been called \(data)")
        print("[!] Handle Request Data for News has been called \(stringifyData)")
        
        return data
    }
}


private enum newsAPIerrors : Error {
    case apiURLerr
    case handleRequestErr
}

extension newsAPIerrors {
    public var errorDescription: String {
        switch self {
            case .apiURLerr : return "Error in home data publisher"
            case .handleRequestErr : return "Error in handling app request"
        }
    }
}


/*
 https://api.polygon.io/v2/reference/news?ticker=aapl&order=asc&limit=50&sort=published_utc&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD
 {
 "count": 1,
 "next_url": "https://api.polygon.io:443/v2/reference/news?cursor=eyJsaW1pdCI6MSwic29ydCI6InB1Ymxpc2hlZF91dGMiLCJvcmRlciI6ImFzY2VuZGluZyIsInRpY2tlciI6e30sInB1Ymxpc2hlZF91dGMiOnsiZ3RlIjoiMjAyMS0wNC0yNiJ9LCJzZWFyY2hfYWZ0ZXIiOlsxNjE5NDA0Mzk3MDAwLG51bGxdfQ",
 "request_id": "831afdb0b8078549fed053476984947a",
 "results": [
 {
 "amp_url": "https://amp.benzinga.com/amp/content/20784086",
 "article_url": "https://www.benzinga.com/markets/cryptocurrency/21/04/20784086/cathie-wood-adds-more-coinbase-skillz-trims-square",
 "author": "Rachit Vats",
 "description": "<p>Cathie Wood-led Ark Investment Management on Friday snapped up another 221,167 shares of the cryptocurrency exchange <strong>Coinbase Global Inc </strong>(NASDAQ: <a class=\"ticker\" href=\"https://www.benzinga.com/stock/coin#NASDAQ\">COIN</a>) worth about $64.49 million on the stock&rsquo;s Friday&rsquo;s dip and also its fourth-straight loss.</p>\n<p>The investment firm&rsquo;s <strong>Ark Innovation ETF</strong> (NYSE: <a class=\"ticker\" href=\"https://www.benzinga.com/stock/arkk#NYSE\">ARKK</a>) bought the shares of the company that closed 0.63% lower at $291.60 on Friday, giving the cryptocurrency exchange a market cap of $58.09 billion. Coinbase&rsquo;s market cap has dropped from $85.8 billion on its blockbuster listing earlier this month.</p>\n<p>The New York-based company also added another 3,873 shares of the mobile gaming company <strong>Skillz Inc</strong> (NYSE: <a class=\"ticker\" href=\"https://www.benzinga.com/stock/sklz#NYSE\">SKLZ</a>), <a href=\"http://www.benzinga.com/markets/cryptocurrency/21/04/20762794/cathie-woods-ark-loads-up-another-1-2-million-shares-in-skillz-also-adds-coinbase-draftkin\">just a day after</a> snapping 1.2 million shares of the stock.</p>\n<p>ARKK bought the shares of the company which closed ...</p><p><a href=https://www.benzinga.com/markets/cryptocurrency/21/04/20784086/cathie-wood-adds-more-coinbase-skillz-trims-square alt=Cathie Wood Adds More Coinbase, Skillz, Trims Square>Full story available on Benzinga.com</a></p>",
 "id": "nJsSJJdwViHZcw5367rZi7_qkXLfMzacXBfpv-vD9UA",
 "image_url": "https://cdn2.benzinga.com/files/imagecache/og_image_social_share_1200x630/images/story/2012/andre-francois-mckenzie-auhr4gcqcce-unsplash.jpg?width=720",
 "keywords": [
 "Sector ETFs",
 "Penny Stocks",
 "Cryptocurrency",
 "Small Cap",
 "Markets",
 "Trading Ideas",
 "ETFs"
 ],
 "published_utc": "2021-04-26T02:33:17Z",
 "publisher": {
 "favicon_url": "https://s3.polygon.io/public/public/assets/news/favicons/benzinga.ico",
 "homepage_url": "https://www.benzinga.com/",
 "logo_url": "https://s3.polygon.io/public/public/assets/news/logos/benzinga.svg",
 "name": "Benzinga"
 },
 "tickers": [
 "DOCU",
 "DDD",
 "NIU",
 "ARKF",
 "NVDA",
 "SKLZ",
 "PCAR",
 "MASS",
 "PSTI",
 "SPFR",
 "TREE",
 "PHR",
 "IRDM",
 "BEAM",
 "ARKW",
 "ARKK",
 "ARKG",
 "PSTG",
 "SQ",
 "IONS",
 "SYRS"
 ],
 "title": "Cathie Wood Adds More Coinbase, Skillz, Trims Square"
 }
 ],
 "status": "OK"
 }

 */
