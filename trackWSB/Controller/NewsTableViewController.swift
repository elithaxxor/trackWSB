//
//  NewsTableViewController.swift
//  
//
//  Created by a-robota on 6/2/22.
//
// https://api.polygon.io/v2/reference/news?ticker=aapl&order=asc&limit=50&sort=published_utc&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD


import UIKit

protocol DataModelDelegate: NewsTableViewController {
    func didRecieveDataUpdate(data: String)
}

// backup url https://api.polygon.io/v2/reference/news?ticker=aapl&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD

// use this  https://api.polygon.io/v2/reference/news?ticker=aapl&sort=published_utc&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD


@IBDesignable
class NewsTableViewController: TableViewControllerLogger {
    let runAPI = NewsAPIWorker()
    let newsModel = [NewsModel].self

    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func searchBtnPressed(_ sender: UIButton!) {
        print("[!] Search Btn Pressed! ")
        try? runAPI.handleRequestData(symbol: searchTextField.text)
    }
    
    // TODO: Add back button to storyboard, and link the IBAaction
    @IBAction func didTapBackBtn () {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        vc!.present(vc!, animated: true)
    }
    

    @Published var newsAPIModel : [NewsModel] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }


    private func useData(strData: String) throws {
        print("[!] Using received data \(strData)")
        guard let retrievedData = try? runAPI.handleRequestData(symbol: searchTextField.text) else { throw newsTableErrors.fetchDataErr }
                print("[+] Retrieved Data \(retrievedData) ")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        return newsAPIModel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let newsResults = newsAPIModel[indexPath.item]
        let index = indexPath.item
        return cell
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

enum newsTableErrors : Error {
case fetchDataErr
}

extension newsTableErrors {
    public var newsTableErrsDescrptions : String {
        switch self {
            case .fetchDataErr : return "[!] Error in fetching && parsing data"
        }
    }
}
