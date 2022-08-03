//
//  NewsTableViewController.swift
//  Financial_Calc_II
//
//  Created by a-robota on 4/27/22.
//

import UIKit
import Combine



// pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD
struct Cells {
    static let docsCell = "Financial Documents Cell"
}
@IBDesignable
class FinanceDocumentsViewController: ViewControllerLogger, ObservableObject, UISearchBarDelegate {

    
    
    // NOTE: Takes the published value from homeviewcontroller and posts to UI + Initiates query/
    fileprivate func updateSearchResults() {
        NotificationCenter.default.post(name: Notification.Name("symbol"), object: searchTextField.text)
        NotificationCenter.default.post(name: Notification.Name.symbol, object: nil)
        
        print("[!] Message from updateSearchResults: [now searching for] \(searchTextField.text)")
        print("[!] Message from updateSearchResults: [updated title] \(titleLbl.text)")
        loadDataSource(symbol: titleLbl.text)
    }

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // TODO: Link to storyboard
    @IBAction func didTapbackBtn() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // TODO: Link to storyboard so frontend user sees homeview value
    @IBOutlet weak var titleLbl : UITextView! {
        didSet {
            print("[!] Title Label Set")
        }
    }
    
    
    var showDocuments = PassthroughSubject<[FinanceDocsModel], Never>()
    private(set) var docResults00:  [FinanceDocsModel] = []
    public var docResults: [Result01] = []
    
    public var homeTextResults: String = "" {
        didSet {
            try? getData(symbol: homeTextResults)
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet {
            print("[!] Search Text Field pressed ")
            
            homeTextResults = searchTextField.text!
            titleLbl.text = searchTextField.text
        }
    }
    
    
    
    @IBOutlet weak var TitleLabl: UILabel!
    @IBOutlet weak var BodyLabel: UILabel!
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        loadDataSource(symbol: searchTextField.text)
    }
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        createLogFile()
        NSLog("[LOGGING--> <START> [NEWS-TABLE VC]")
        title = "Financial Document's ViewController"
        
        // UPDATES VIEW FROM NOTIFICATION CENTER
        
        
        let nib = UINib(nibName: "DocsTableViewCell", bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: "DocsTableViewCell")
        tableView.register(nib, forCellReuseIdentifier: "IncomeStatementTableViewCell")
        tableView.register(nib, forCellReuseIdentifier: "IncomeStatementTableViewCell")
        tableView.register(nib, forCellReuseIdentifier: "ComprehensiveTableViewCell")
        tableView.register(nib, forCellReuseIdentifier: "LinksForDocsCell")

        NSLog("[LOGGING--> <END> [NEWS-TABLE VC]")
    }
    
    
    private func loadDataSource(symbol: String? ) {
        print("[!] Now laoding data source \(symbol)")
        getData(symbol: symbol!)
    }
    
    private func getData(symbol: String)  {
        print("[!] Getting Data! \(symbol) ")
        fetchResults(symbol: symbol)
        if (searchTextField?.text == nil) {
            let symbol = homeTextResults
            fetchResults(symbol: symbol)
        } else {
            let symbol = searchTextField?.text ?? "AAPL"
            fetchResults(symbol: symbol)
        }
    }
    private func fetchResults(symbol: String) {
        let apiKey = "pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"
        
        let symbol = symbol.uppercased()
        
        let defaultURL = "https://api.polygon.io/vX/reference/financials?ticker=AAPL&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"
        let fetchURL = "https://api.polygon.io/vX/reference/financials?ticker=\(symbol)&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"
        print("[!] Fetching Results! \(fetchURL)")
        
        let task = URLSession.shared.dataTask(with: URL(string: fetchURL) ?? URL(string: defaultURL)!, completionHandler: { [self] data, response, error in
            guard let data = data, error == nil else {
                print("[-] Error in URLSession datatask \(String(describing: error)) ")
                return
            }
            var results: FinanceDocsModel?
            do {
                results = try? JSONDecoder().decode(FinanceDocsModel?.self, from: data)
                print(results?.requestID)
                print(results?.status)
                
            }
            catch { print(error.localizedDescription) }
            guard let json = results else { return }
            print("[?] Status: \(json.status)")
            print("[+] Request ID \(json.requestID)")
            print("[+] Request ID \(json.results)")
            docResults = json.results.self
            populateResults(status: json.status,
                            requestID: json.requestID,
                            results: json.results,
                            docResults: docResults)

        })
        task.resume()
        self.tableView?.reloadData() // maintains state ui persistance
        self.tableView?.isScrollEnabled = true
    }
    
    func populateResults(status: String,
                         requestID: String,
                         results: [Result01],
                         docResults: [Result01] ) {
        print("[!] Populating Results! ")
        print("[+] Results \(results)")
        print("[+] Doc Results \(docResults)")
        
        DispatchQueue.main.async {
            self.tableView.reloadData() // maintains state ui persistance
            self.tableView.isScrollEnabled = true
        }
        
    }
    
    
    // MARK: - Navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //    }
    
}

// MARK: - Table view data source

extension FinanceDocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! DocsTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocsTableViewCell",
for: indexPath) as? DocsTableViewCell
        let incomeCell = tableView.dequeueReusableCell (withIdentifier: "IncomeStatementTableViewCell", for: indexPath) as? IncomeStatementTableViewCell
        
        let cashFlowCell = tableView.dequeueReusableCell(withIdentifier: "CashFlowTableViewCell", for: indexPath) as? CashFlowTableViewCell
        
        
        let comprehensiveCell = tableView.dequeueReusableCell(withIdentifier: "ComprehensiveTableViewCell", for: indexPath) as? ComprehensiveTableViewCell
        
        let urlCell = tableView.dequeueReusableCell(withIdentifier: "LinksForDocsCell", for: indexPath) as? LinksForDocsCell
        
        
        let idx2 = docResults[indexPath.row]
        cell?.textLabel?.text = idx2.companyName
        cell?.bodyLabel?.text = idx2.financials.balanceSheet.description
        incomeCell?.bodyLabel?.text = idx2.financials.incomeStatement.description
        // cashFlowCell?.bodyLabel?.text = idx2.financials.cashFlowStatement.encode(to: Encoder)
       
        comprehensiveCell?.bodyLabel?.text = idx2.companyName
        comprehensiveCell?.comprehensive?.text = idx2.financials.comprehensiveIncome.comprehensiveIncomeLoss.value.convertDouble2String
        comprehensiveCell?.other?.text = idx2.financials.comprehensiveIncome.otherComprehensiveIncomeLoss.value.convertDouble2String
        comprehensiveCell?.attributed2parent?.text = idx2.financials.comprehensiveIncome.comprehensiveIncomeLossAttributableToParent.value.convertDouble2String
        comprehensiveCell?.other2parent?.text = idx2.financials.comprehensiveIncome.otherComprehensiveIncomeLossAttributableToParent.value.convertDouble2String
        comprehensiveCell?.loss2noncontrol?.text = idx2.financials.comprehensiveIncome.comprehensiveIncomeLossAttributableToNoncontrollingInterest.value.convertDouble2String
        
    
        urlCell?.titleFilingDate?.text = idx2.filingDate.description
        urlCell?.titleCompanyName?.text = idx2.companyName.description
        urlCell?.cik?.text = idx2.cik.description
        urlCell?.sourceFilingURL?.text = idx2.sourceFilingURL.description
        urlCell?.sourceFIlingFileURL?.text = idx2.sourceFilingFileURL.description
        
        
        
        print(idx2.cik.description)
        print(idx2.sourceFilingURL.description)
        print(idx2.sourceFilingFileURL.description)
        
        
        print("[!] [IDX 2] \(idx2)")
        return cell!
    }
    
    // TODO: For when user selects cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User has selected cell.. Moving to aprpopiate view")
    }
    
}


// MARK: Doc Fetching Catch Errors
public enum docFetchError : Error {
    case jsonFetchError
    case getDataError
    case stringifyDataError
    case fetchDataErr
    case buildCellErr
}
extension docFetchError {
    public var docFetchErrorDescription : String {
        switch self {
        case .jsonFetchError : return "[-] Error in Fetching Finance Docs .JSON data"
        case .getDataError : return "[-] Error in Getting Data From Models"
        case .stringifyDataError : return "[-] Error in stringifing model JSON"
        case .fetchDataErr : return "[-] Error in fetching TABLE-VC Data "
        case .buildCellErr : return "[-] Error in building Cell "
        }
    }
}
