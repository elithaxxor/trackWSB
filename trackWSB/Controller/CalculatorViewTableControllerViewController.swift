//
//  CalculatorViewTableControllerViewController.swift
//  Financial_Calc_II
//
//  Created by a-robota on 5/23/22.
//

import UIKit
import Combine

//MARK: Calculator Views [finance calc]
@IBDesignable
class CalculatorViewTableControllerViewController: TableViewControllerLogger {

    // let DateVC = DateSelectionTableViewController()

    @IBOutlet weak var symbolLabel : UILabel!
    @IBOutlet weak var assetNameLabel : UILabel!
    @IBOutlet var currencyLabels : [UILabel]!
    
    @IBOutlet weak var amountInvestedLabel : UILabel!
    @IBOutlet weak var initialInvestmentDate : UITextField!
    @IBOutlet weak var monthlyDCF : UITextField!
    @IBOutlet weak var initialInvestmentText : UITextField!

    @IBOutlet weak var currentValLabel : UILabel!
    @IBOutlet weak var totalInvestedLabel : UILabel!
    @IBOutlet weak var gainLabel : UILabel!
    @IBOutlet weak var yieldLabel : UILabel!
    @IBOutlet weak var annualReturnLabel : UILabel!


    // TODO: Perform Segue :  identifer: doneBtn
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        print("[?] Starting Segue To Dates")
    }

    // TODO: Perform Segue : ID: newsBtn
    @IBAction func newsBtn(_ sender: Any) {
        print("[?] Starting Segue To News")

    }

    // TODO: Perform Segue : ID: basicCalcBtn

    @IBAction func basicCalc(_ sender: UIBarButtonItem) {
        print("[?] Starting Segue To Basic Calc")

    }


    @IBInspectable
    @IBOutlet weak var dateSlider : UISlider?

    // Publishers
    @Published private var initialDateOfInvestment: Int?
    @Published private var initialInvestmentAmt : Int?
    @Published private var monthDCF : Int?

    // MARK: Variables from SearchTableVC Segue
    var searchTableSearchResults : SearchResults? {
        didSet {
            print("[!] SearchResults set from SeachTableVC \(String(describing: searchTableSearchResults))")
        }

    }
    var searchTableSearchQuery : String? {
        didSet {
            print("[!] SearchResults set from searchTableVC \(String(describing: searchTableSearchQuery))")
        }
    }

    var searchTableSubscribers : Set<AnyCancellable>? {
        didSet {
            print("[!] SearchResults set from searchTableVC \(String(describing: searchTableSubscribers))")
        }
    }
    

    // MARK: Class Variables 
    private var subscribers = Set<AnyCancellable>()
    public var asset : Asset? // stores data from APICall
    private let dcaLogic = DCALogic()

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


    override func viewDidLoad()
    {
        super.viewDidLoad()
        createLogFile()
        NSLog("[LOGGING--> <START> [CALCULATOR VC]")
        setupViews()
        print(banner)
        setupTextFields()
        observeForm()
        setupSlider()
        resetViews()
        NSLog("[LOGGING--> <END> [CALCULATOR VC]")
    }
    
    //MARK: Intended to provide views with correct symbols / vals
    private func setupViews() {
        symbolLabel.text = asset?.searchResults.symbol ?? "DEFAULT VALUE"
        assetNameLabel.text = asset?.searchResults.name
        amountInvestedLabel.text = asset?.searchResults.currency
        currencyLabels.forEach { ( label) in
            label.text = asset?.searchResults.currency.addBrackets() //String Extension to fix UI mistake
        }
    }

    // overrite textview should begin editing -->
    // Access to "done button" is in extensions folder file: Extensions
    private func setupTextFields() {
        initialInvestmentText.addDoneBtn() // in extensions folder
        monthlyDCF.addDoneBtn()
        initialInvestmentText.delegate = self   // segue: showDate
    }
    
    
    private func setupSlider() {
        print("[+] Setting up slider")
        if let count = asset?.TimeByMonthModel.getMonthInfo().count {
            let dateSliderCount = count - 1
            dateSlider?.maximumValue = Float(dateSliderCount)
            print("[+] Slider count is \(count)")
        } else {
            print("[-] Slider Error! ")
        }
    }


    private func resetViews() {
        print("[!] Resetting Calculator View Controller")
        createLogFile()
        NSLog("[LOGGING--> <START> [CALCULATOR RESET VC]")
        currentValLabel.text = "0.00"
        initialInvestmentText.text = "0.00"
        yieldLabel.text = "0"
        gainLabel.text = "-"
        annualReturnLabel.text = "-"
        NSLog("[LOGGING--> <END> [CALCULATOR RESET VC]")

    }


    // MARK: To observe textField events, populates values upon input
    private func observeForm() {
        $initialDateOfInvestment.sink{ [weak self] (index) in
            print("From Observed Form: ", index as Any)
            guard let index = index else { return }
            self?.dateSlider?.value = Float(index)

            if let dateString = self?.asset?.TimeByMonthModel.getMonthInfo()[index].date.dateFormatter {
                self?.initialInvestmentDate.text = dateString
            }
        }.store(in: &subscribers)
        print("Subscribers:", subscribers.self)
        // MARK: Observed TextField [IB initialInvestmentText]
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentText).compactMap({
            ($0.object as? UITextField)?.text
        }).sink{ [weak self] (text) in
            self?.initialInvestmentAmt = Int(text) ?? 0
            print("[+] [Initial Invesstment TextField] \(text)")
        }.store(in: &subscribers)

        // MARK: Average DCF AMT
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDCF).compactMap({
            ($0.object as? UITextField)?.text
        }).sink{ [weak self] (text) in
            self?.monthDCF = Int(text) ?? 0
            print("[?] [Month DCF TextField] \(self?.monthDCF ?? 0) ")
        }.store(in: &subscribers)

        Publishers.CombineLatest3($initialDateOfInvestment, $initialInvestmentAmt, $monthDCF ).sink { [weak self](
            initialDateOfInvestment, initialInvestmentAmt, monthDCF) in

            print("[PUBLISHER]-->[initial date of investment] \(String(describing: initialDateOfInvestment))")
            print("[PUBLISHER]-->[initial amount invested] \(String(describing: initialInvestmentAmt))")
            print("[PUBLISHER]-->[monthly dcf] \(String(describing: monthDCF))")


            guard let initialDateOfInvestment = initialDateOfInvestment,
                  let initialInvestmentAmt = initialInvestmentAmt,
                  let monthDCF = monthDCF,
                  let asset = self?.asset

            else { return }



            let results = self?.dcaLogic.calculate(startingAmount: Double(initialInvestmentAmt), monthlyDCF: Double(monthDCF), investedDateIdx: initialDateOfInvestment, asset: asset)

            print("[+] [DATE] [\(initialDateOfInvestment)] +[AMOUNT] [\(initialInvestmentAmt)] + DCF [\(monthDCF)] [+][+] Publisher Results results")

            let isProfitable = (results?.isProfitable == true)
            let gainSymbol = isProfitable ? "+" : "-"

            self?.currentValLabel.backgroundColor = isProfitable ? .winningGreen : .losingRed
            self?.currentValLabel.text = results?.currentVal.string2doublePlaceholder2
            self?.totalInvestedLabel.text = results?.investedAmt.formatDouble2Currency
            self?.gainLabel.text = results?.gain.removeSymbolandDecimal(hasSymbol: false, hasDecimalHolder: false).commonPrefix(with: gainSymbol)

            self?.yieldLabel.textColor = isProfitable ? .winningGreen : .losingRed
            self?.yieldLabel.text = results?.yield.convertDouble2StrPercent
            
            self?.annualReturnLabel.text = results?.annualReturn.convertDouble2StrPercent
            self?.annualReturnLabel.textColor = isProfitable ? .winningGreen : .losingRed


        }
    }





    // MARK: May be a bug lurking... [Prepare for Segue to dateTime view]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDate", let DateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeAdjusted = sender as? TimeByMonthModel {
            DateSelectionTableViewController.TimeByMonthModel = timeAdjusted
            DateSelectionTableViewController.selectedIndex = initialDateOfInvestment

            DateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(index: index)
            }
        }
    }
    private func handleDateSelection(index: Int) {
        // do not render if not dateselectionVC
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        navigationController?.popViewController(animated: true)
        if let monthInfo = asset?.TimeByMonthModel.getMonthInfo() {
            initialDateOfInvestment = index
            let monthInfo = monthInfo[index]
            let dateString = monthInfo.date.dateFormatter
            initialInvestmentText.text = "[\(dateString)]"
        }
    }
    @IBAction func didSliderChange( _ sender: UISlider ) {
        initialDateOfInvestment = Int(sender.value)
        print("slider value changed \(sender.value)")
    }
}


// [textfields for DCF Calculator] -> overright textFieldShouldBeginEditing
extension CalculatorViewTableControllerViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField : UITextField) -> Bool {
        if textField == initialInvestmentText {
            performSegue(withIdentifier : "showDate", sender : asset?.TimeByMonthModel)
            return false
        }
        return true
    }
}

