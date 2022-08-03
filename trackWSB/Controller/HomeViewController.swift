//
//  HomeTableViewController.swift
//  Finance_App01
//
//  Created by a-robota on 5/31/22.
//

// TODO : 1. FETCH FINANCE DOCS 2. SET UP NEWSPAPER API. 3. LIVE NEWS FEED UNDER SEARCHRESULTS 4. PDF SCANNER 5. ROTATE VIEWS FOR CALC

import UIKit
import Combine


struct SymbolModel {
    var symbol: String?
}

class validateSymbol {
    static weak var validate = validateSymbol()
    private var symbolModel: SymbolModel?
    private static var symbol : String? // allow outside classes to reassign. May need to make private(set)
    static let state = validateSymbol()

    private init() {}
    deinit {
        print("[!] The Symbol has been removed from memory.. \(symbolModel?.symbol) ")
    }
    
    func checkValidation(symbol: String, completion: @escaping(Bool) -> Void){
        DispatchQueue.background(delay: 0.0, completion: {
            print("[!] Moving thread to ground ")
            sleep(1)
            DispatchQueue.main.async {
                if symbol.count == 3 || symbol.count == 4 {
                    self.symbolModel = SymbolModel(symbol: symbol)
                    print("[+] The symbol is valid")
                    completion(true)
                }
                else {
                    print(symbolError.symbolErr)
                    self.symbolModel = nil
                    completion(false)
                }
            }
        })
    }
}



@IBDesignable
class HomeViewController: ViewControllerLogger, UITextFieldDelegate {
    
    var timer = AppTimer()
    let dispatchGroup = DispatchGroup()
    static var homeVC = HomeViewController()
    
    
    private let banner = """
          __,
         (           o  /) _/_
          `.  , , , ,  //  /
        (___)(_(_/_(_ //_ (__
                     /)
                    (/
        
        version 0.0.1 Beta
        copyleft, [all wrongs reserved] @elit_haxxor
        
        
        """
    @IBOutlet weak var textFieldInput: UITextField!
    
    var homeTextInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(banner)
        timer.setupTimer()
        createLogFile()
        NSLog("[LOGGING--> <START> [HOME VC]")
        
        
        textFieldInput?.delegate = self
        textFieldInput?.returnKeyType = .done // specifies the return-key is done
        textFieldInput?.addTarget(self, action: #selector(self.validateField), for: .editingChanged)
        homeBtn?.isEnabled = false
        
        // To Broadcast symbol to all views.
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotification(_: )), name: .symbol, object: nil)
    }
    
    
    static var subscriptions = Set<AnyCancellable>() // for fetch
    var cancellables = Set<AnyCancellable>() // for fetch
    
    let publishedTextVal: Publishers.Sequence<[String?], Never> = [].publisher
    
    @Published var homeTextValuePublished: String = ""
    @Published var textIsValid: Bool = false
    
    @objc func didGetNotification(_ notification: Notification) {
        let symbol = notification.object as! String?
        print("[+] Symbol Queried \(symbol)")
        
        userInputtedSymbol.text = symbol
        textFieldInput.text = symbol
        validateField(symbol: symbol!)
    }
    
    // TODO: Link this function to the storyboard [the search btm]
    @IBOutlet weak var home2searchProp: UIButton!
    
    // TODO: Link this function to the storyboard [the search btm]
    @IBAction func home2seachIsActive(active: Bool) {
        print("[!] ")
        if active == true {
            home2searchProp.isHidden = active
        }
        home2searchProp.isHidden = active
    }
    
    @IBAction func home2prediction (_ sender: UIButton) {
        print("[!] User wants to go to predictive viewmodel")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PredictStockVC") as! PredictStockVC
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // TODO: Add $stock symbol validator
    @objc private func validateField(symbol: String) {
        DispatchQueue.background(delay: 0.0, completion: {
            validateSymbol.state.checkValidation(symbol: symbol) { (completion) in
                if completion == true && symbol.count < 4 || symbol != nil {
                    self.home2seachIsActive(active: true)
                    NotificationCenter.default.post(name: .symbol, object: symbol)
                    print(" [+] Current notification symbol \(Notification.Name.symbol)")
                    
                }
                else {
                    print("[-] Homevalid is invalid, because symbol request does not fit paramaters. ")
                    self.showAlertTextField()
                    
                }
            }
        }
        )}
    
    func delayRun(after seconds: Double, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: deadline) { completion() }
    }
    
    
    
    
    private func reloadData() {
        DispatchQueue.global(qos: .userInitiated).async {
            print("[!] User Requested to reload view")
            HomeViewController.homeVC.viewDidLoad()
        }
    }
    
    
    // TODO: Add to storyboard
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var userInputtedSymbol: UITextView!
    
    @IBAction func homeBtnPressed() {
        print("[!] User requested views refresh")
        self.viewDidLoad()
    }
    // TODO: Present popview if invalid symbol presented
    @IBAction func homeBtn2search(_ sender: UIButton, symbol: String?) {
        print("[!] homeBtn2search Pressed")
        validateField(symbol: symbol!)
        homeTextInput = textFieldInput?.text
        print("[!]- homeBtnb2search - symbol \(symbol) \n homeTextField input \(homeTextInput)")
        
        if home2searchProp.isHidden == true {
            // TODO: Remove this, it is a duplicate validator
            let isValid = validateSymbol.validate?.checkValidation(symbol: symbol!){ success in
                if success {
                    self.goToSearchViewController(symbol: symbol!)
                }
                
                // TODO: Add Alert letting user know the symbol is not valid. return the symbol entered.
                else {
                    print(symbolError.symbolStructErr)
                }
            }
        }
    }
    
    
    // TODO: May have to remove @IBAction. If not, then lnk to the storyboard
    @IBAction private func showSymbolAlert(controller: UIViewController){
        print("[!] User Entered the wrong input, asking for new Symbol ")
        let alert = UIAlertController(title: "🛑🛑🛑", message: "🛑enter a proper symbol🛑", preferredStyle: .alert)
        
        // NOTE: Left Btn action --
        // TODO: ADD LOGIIV TO REFRESH THE HOMEVIEW.
        alert.addAction(UIAlertAction(title: "edit", style: .default, handler: { [weak self] (editor) in
            print("[!] User is editing symnol \(editor)")
            self?.showAlertTextField()
        }))
        
        //TODO: Add to refresh table view and reload data for verifiation.
        alert.addAction(UIAlertAction(title: "reload", style: .cancel, handler: { [weak self] (reloadData) in
            print("[!] User initiated reload data \(reloadData)")
            self?.reloadData()
            
        }))
        
        // TASK: The red btn
        alert.addAction(UIAlertAction(title: "dismiss", style: .destructive, handler: { [weak self] (goBack) in
            print("[!] User initiated alert canncel \(goBack)")
            
        }))
        
        self.present(alert, animated: true, completion: {
            print("[!] Alert View Initiated")
        })
    }
    
    
    // TODO: Take user input for alert view and pass on to verificatno class.
    private func showAlertTextField() {
        print("[!] User is Editing the symbol via the alert view.")
        let notifiedSymbol = Notification.Name.symbol
        let alertController = UIAlertController(title: "enter new symbol", message: "\(notifiedSymbol) not valid", preferredStyle: .alert)
        
        dispatchGroup.enter()
        let confirmEditBtn = UIAlertAction(title: "add", style: .default) { [weak self] (edit) in
            print("[!] Editing UITextField ")
            if let alertField = alertController.textFields?.first, let text = alertField.text {
                NotificationCenter.default.post(name: .symbol, object: text)
                print("[!] User entered \(text)")
                self?.reloadData()
                self?.validateField(symbol: text)
                self?.dispatchGroup.leave()
            }
        }
        let cancelAlertBtn = UIAlertAction(title: "dismiss", style: .cancel) { [weak self] (cancel) in
            DispatchQueue.global(qos: .userInitiated).async {
                self?.reloadData()
                self?.dispatchGroup.leave()
            }
            
        }
        alertController.addTextField { textField in (textField)
            textField.placeholder = "$symbol"
            print("[!] [ALERT-TEXT-FIELD] \(textField.text)")
        }
        
        alertController.addAction(confirmEditBtn)
        alertController.addAction(cancelAlertBtn)
        self.present(alertController, animated: true, completion: nil)
        
    }
    // TODO: Programmatitcally add the alert view and have storyboard szfeconize it.
    
    
    
    // TODO: Pass the value though publisher OR completion handler
    private func goToSearchViewController(symbol: String) {
        let input = self.textFieldInput.text ?? "GOOG"
        let controller = storyboard?
            .instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        // SearchTableViewController?.homeTextValue = input
        
        present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func homeScroll2Search(_ sender: UIButton) {
        print("[!] homescroll btn pressed ")
        performSegue(withIdentifier: "homeScroll2Search", sender: self)
    }
    @IBAction func homeScroll2Twitter(_ sender: UIButton) {
        print("[!] Scroll btn 2 twitter pressed")
        performSegue(withIdentifier: "homeScroll2twitter", sender: self)
    }
    
    
    @IBAction func homeScroll2WebViews(_ sender: UIButton)  {
        print("[!] Scroll btn 2 webviews pressed! ")
        performSegue(withIdentifier: "homeScroll2WebViews", sender: self)
    }
    
    @IBAction func homeScroll2FinDocs(_ sender: UIButton) {
        print("[!] Home scroll to Financial docs pressed")
        performSegue(withIdentifier: "homeScroll2FinDocs", sender: self)
    }
    
    
    @IBAction func homeScroll2BasicCalc(_sender: UIButton) {
        print("[!] home scroll 2 basic calc btn pressed ")
        performSegue(withIdentifier: "home2calc", sender: self)
    }
    
    @IBAction func textField(_ sender: UITextField) {
        print("[!] uiTextField inititiated.. \(String(describing: sender.text))")
        homeTextInput = sender.text
        print(homeTextInput ?? "default value")
        //textFieldInput.addTarget?(self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //   homeTextValue = sender.text
        //   print("[!] UI TextField activated \(homeTextValue ?? sender.placeholder!)")
        
        //if sender.text
    }
    
    @IBAction func scrollButton(_ sender: UIButton) {
        
        
    }
    
    // resignes the keyboard when the screen outside keyboard is touched.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - HomeVC Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: See which variable passes.
        if segue.identifier == "homeBtn2search" {
            let homeBtn2search = segue.destination as? SearchTableViewController
            
            let input = self.textFieldInput.text ?? "GOOG"
            homeBtn2search?.searchController.searchBar.text = input
            
            
            print("input \(input)")
            print("homeBtn2search?.homeTextValueVC  \(input.self)")
        }
        
        if segue.identifier == "homeScroll2Search" {
            let homeScroll2SearchVC = segue.destination as? SearchTableViewController
            let input = self.textFieldInput.text ?? "GOOG"
            SearchTableViewController.homeTextValue = input
            homeScroll2SearchVC?.searchController.searchBar.text  = input
            
            
        }
        if segue.identifier == "homeScroll2twitter" {
            let home2twitterVC = segue.destination as? TwitterPredictViewController
            let input = self.textFieldInput.text ?? "GOOG"
            home2twitterVC?.homeTextValue = input
            home2twitterVC?.textField?.text = input
            home2twitterVC?.symbolLabel?.text = input
            
        }
        if segue.identifier == "homeScroll2WebViews" {
            let homeScroll2WebViewsVC = segue.destination as? WebViewController
            let input = self.textFieldInput.text ?? "GOOG"
            homeScroll2WebViewsVC?.homeTextValue = textFieldInput.text
            
        }
        
        if segue.identifier == "home2calc" {
            let home2calcVC = segue.destination as? BasicCalculatorViewController
        }
        
        if segue.identifier == "homeScroll2FinDocs" {
            let homeScroll2FinDocsVC = segue.destination as? FinanceDocumentsViewController
            homeScroll2FinDocsVC?.homeTextResults = textFieldInput.text ?? "GOOG"
            homeScroll2FinDocsVC?.TitleLabl?.text =  textFieldInput.text
            
        }
    }
}


public enum symbolError: Error {
    case symbolErr
    case symbolStructErr
    
}
extension symbolError {
    public var symbolErrorDescription : String {
        switch self {
        case .symbolErr : return "[-] There is an error processing the symbol. "
        case .symbolStructErr : return String("[-] There is an error passing the symbol to struct")
            
        }
    }
}
public enum homePublishError : Error {
    case dataError
    case smallInput
}
extension homePublishError {
    public var errorDescription: String {
        switch self {
        case .dataError : return "Error in home data publisher"
        case .smallInput : return "input is too small to validate (input < 2) "
        }
    }
}


extension Notification.Name {
    public static let symbol = Notification.Name("symbol")
}


extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

/*
 
 DispatchQueue.background(delay: 3.0, background: {
 // do something in background
 }, completion: {
 // when background job finishes, wait 3 seconds and do something in main thread
 })
 
 DispatchQueue.background(background: {
 // do something in background
 }, completion:{
 // when background job finished, do something in main thread
 })
 
 DispatchQueue.background(delay: 3.0, completion:{
 // do something in main thread after 3 seconds
 })
 
 */


/*

// TO PASS DATA TO NOTIFICATION CENTER
NotificationCenter.default
            .post(name: NSNotification.Name("com.user.login.success"),
             object: nil)
 
 let loginResponse = ["userInfo": ["userID": 6, "userName": "John"]]
 NotificationCenter.default
             .post(name: NSNotification.Name("com.user.login.success"),
              object: nil,
              userInfo: loginResponse)
 
 
 
*/


