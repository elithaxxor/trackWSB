//
//  ViewController.swift
//  Financial_Calc_II
//
//  Created by a-robota on 4/20/22.
//
//
//  ViewController.swift
//  FinanceApp
//
//  Created by a-robota on 4/20/22.
//
//
// https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=demo
// https://www.alphavantage.co/documentation/
// https://developer.apple.com/documentation/combine



// TODO : 1. FETCH FINANCE DOCS 2. SET UP NEWSPAPER API. 3. LIVE NEWS FEED UNDER SEARCHRESULTS 4. PDF SCANNER 5. ROTATE VIEWS FOR CALC
import UIKit
import Combine
import MBProgressHUD
import SwiftUI

@IBDesignable
class SearchTableViewController: TableViewControllerLogger, MBProgAnimate {
    
    
    private enum Mode {
        case onboarding // homescreen (no search)
        case search // renders users result
    }
    
    // Class Instances //
    private let runAPI = APIWorker()
    private let viewCell = SearchTableViewCell()
    
    
    private(set) var searchResults: SearchResults? // return Models fetched from API
    var subscribers = Set<AnyCancellable>() // for fetch
    
    
    @Published private var mode: Mode = .onboarding // UI state (onboarding or searcahing)
    @Published private var searchQuery = String() // search query (nav bar)
    
    static var homeTextValue: String = ""
    
    
    public lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter Company Name or $Ticker"
        sc.searchBar.autocapitalizationType = .allCharacters
        //   sc.searchBar.text = symbol
        
        return sc
    }()
    
    var symbol: SymbolModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLogFile()
        NSLog("[LOGGING--> <START> [SEARCH VC]")
        
        populateSymbol()
        setupNavBar()
        setupTableView() // FOR UI, when no search results.
        
        // NOTE: Posts the data from home view controller to ui label and ui textfield
        NotificationCenter.default.post(name: Notification.Name("symbol"), object: symbolLabel.text)
        NotificationCenter.default.post(name: Notification.Name("symbol"), object: textInputField.text)
        NotificationCenter.default.post(name: Notification.Name("symbol"), object: $searchQuery)
        
        observeForm()
        NSLog("[LOGGING--> <END> [CALCULATOR VC]")
        
    }
    
    
    
    private func populateSymbol() {
        textInputField.text = "\(symbol.symbol)"
        symbolLabel.text = "\(symbol.symbol)"
    }
    
    // TODO: Link to storyboard
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    
    // TODO: Find the tex tinput field in storyboard and ib add function.
    @IBAction func textInput() {
        print("[!] The input is being edited.")
    }
    @IBAction func symbolFieldInput() {
        print("[!] The symbool field is being editied .")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // viewCell.configure(with: searchResults.self)
    }
    
    private func setupNavBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    
    @IBAction func calcBtn(_ sender: UIBarButtonItem) {
        print("[+] Segue to Basic Calcualtor")
        self.performSegue(withIdentifier: "toBasicCalc", sender: self)
        
    }
    
    @IBAction func twitterBtn(_ sender: Any) {
        print("[!] Twitter Btn Pressed! ")
        self.performSegue(withIdentifier: "search2twitter", sender: self)
    }
    @IBAction func backBtn(_ sender: Any) {
        print("[!] Back Btn Pressed! ")
        self.performSegue(withIdentifier: "backBtnPressed", sender: self)
    }
    
    @IBAction func calcBtnSegue(_ sender: UIButton) {
        print("[!] Calc Segue initiated! ")
        self.performSegue(withIdentifier: "calcBtnSegue", sender: self)
    }
    
    private func setupTableView(){
        tableView.tableFooterView = UIView()
    }
    
    private func observeForm(){
        $searchQuery
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink { [ unowned self ] (searchQuery) in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                guard !searchQuery.isEmpty else  { return }
                
                self.showLoadingAnimation()
                print("[+] Search Query Returned \(searchQuery)")
                self.runAPI.fetchSymbols(keywords: searchQuery).sink { (completion) in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished: break
                    }
                } receiveValue: { ( searchResults) in
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                    print(self.searchResults ?? "DEBUG ME--> SearchTable observeForm() ")
                }.store(in: &self.subscribers)
            }
        
        
        guard !searchQuery.isEmpty else {
            print("search navbar is empty")
            return
        }
        
        showLoadingAnimation()
        self.runAPI.fetchSymbols(keywords: searchQuery).sink { (completion) in
            switch completion {
            case .failure(let error):
                print("Error, observedForm \(error)")
                print(error.localizedDescription)
                
            case.finished: break
            }
        }
        
    receiveValue: { (searchResults ) in
        self.searchResults = searchResults
        self.tableView.reloadData() // maintains state ui persistance
        self.tableView.isScrollEnabled = true
    }.store(in: &subscribers)
        
        
        $mode.sink { [unowned self] (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = nil
            case .search:
                self.tableView.backgroundView = nil
                
                
            }
        }.store(in: &subscribers)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults
        {
            let searchResult  = searchResults.allResults[indexPath.row]
            cell.configure(with: searchResult)
            return cell
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.allResults.count ?? 0
    }
    
    // MARK: Segues into Stock Calculator screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = self.searchResults {
            let searchResult = searchResults.allResults[indexPath.item]
            let symbol = searchResult.symbol
            
            handleSelection(for: symbol, searchResult: searchResult)
        }
    }
    
    // MARK: To handle indivdual cell seletion
    func handleSelection(for symbol: String, searchResult: SearchResult) {
        showLoadingAnimation()
        runAPI.fetchMonthlyAdjustedObj(keywords: symbol).sink { [weak self] (completionResult) in
            self?.hideLoadingAnimation()
            switch completionResult {
            case.failure(let error):
                print("[!] Error in hanlding CellView Selection \(error) ")
            case.finished:
                print("[+] Completed Processing CellView Selection")
                break
            }
        } receiveValue: { [weak self] (TimeByMonthModel) in
            print("perfomring segue transfer to DCA Calc")
            let asset = Asset(searchResults: searchResult, TimeByMonthModel: TimeByMonthModel)
            self?.performSegue(withIdentifier: "showCalculator", sender: asset)
            print("success \( TimeByMonthModel.getMonthInfo())")
        }.store(in: &subscribers)
    }
}



// [ Search Nav Bar  ]
extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "DEBUG ME")
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        print("User Input \(searchQuery)")
        self.searchQuery = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("switiching modes")
        mode = .search
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == "toBasicCalc" {
            let toBasicCalc = segue.destination as? CalculatorViewTableControllerViewController
            toBasicCalc?.modalPresentationStyle = .popover
            present(toBasicCalc!, animated: true)
        }
        
        if segue.identifier == "search2twitter" {
            let destinationVC = segue.destination as? TwitterPredictViewController
            print("[!] Moving on to twitter \n")
            let input = symbolLabel.text
            destinationVC?.homeTextValue = input
            destinationVC?.symbolLabel.text = input
        }
        
        if segue.identifier == "backBtnPressed" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
        if segue.identifier == "calcBtnSegue" {
            let destinationVC = segue.destination as? CalculatorViewTableControllerViewController
            let input = textInputField.text
            destinationVC?.symbolLabel.text = input
            destinationVC?.assetNameLabel.text = input
        }
        
    }
}



/*
 // Class Instances //
 private let runAPI = APIWorker()
 private var searchResults: SearchResults? // return Models fetched from API
 var subscribers = Set<AnyCancellable>() // for fetch
 
 
 @Published private var mode: Mode = .onboarding // UI state (onboarding or searcahing)
 @Published private var searchQuery = String() // search query (nav bar)
 
 */
