//
//  TwitterPredictViewController.swift
//  Finance_App00
//
//  Created by a-robota on 5/28/22.
//

// api key 6HE1wYuuAOF9UQvxtI9aMlcfX
// secret key r0XWPP9uUT0FW9q1yQ9KrnkT8Kxgmr2oiL9MeC7c70HyUlgc39
// bearer token AAAAAAAAAAAAAAAAAAAAAHZudAEAAAAAQVQhVshdEIqL5ViZAPg8rVDYVgg%3DNvwO9U3BCfGgPs8kqYWBFcTR91qcbsbkzZX7qlfSpy2vzvKLzE




import UIKit
// import SwiftyJSON
import CoreML
// import SwifteriOS // Embedded Twitter Framework
import Combine


public enum predictionsError: Error {
    case badPrediction
    case badInput
}
public enum twitterAPIerr : Error {
    case encoding
    case badRequest
    case success
    case failure
} // error handling


@IBDesignable
class TwitterPredictViewController: ViewControllerLogger {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField? {
        didSet {
            fetchTweets(textField?.text ?? "DEBUG ME")
            symbolLabel.text = textField?.text
        }
        
    }
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    
    
//    @IBAction func didUnwindFromSearchVC(_ sender: UIStoryboardSegue) {
//        guard let searchVC = sender.source as? SearchTableViewController? else { return }
//        searchVC?.homeTextValue.self = searchVC?.searchInput?.text ?? "debug unwind from searchVC"
//    }
    
    
    @IBAction func fetchBtn(_sender: Any) {
        fetchTweets(textField?.text ?? "DEBUG ME")
    }
    
    private let consumerKey: String = "6HE1wYuuAOF9UQvxtI9aMlcfX"
    private  let privKey: String = "r0XWPP9uUT0FW9q1yQ9KrnkT8Kxgmr2oiL9MeC7c70HyUlgc39"
    private  let twitterPath: String = "/Users/adelal-aali/Desktop/Finance_App01/twitter-sanders-apple3.csv"
    private let classificationPath: String = "/Users/adelal-aali/Desktop/Finance_App01/TwitterClassifer.mlmodel"
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    // @Published var subscribers = Set<AnyCancellable>() // for fetch
    
    
    
    // MARK: Varibles from SearchView Controller
    var homeTextValue: String? {
        didSet {
            print("[!] searchview text field passed \(String(describing: homeTextValue))")
            fetchBtn(_sender: self.homeTextValue ?? "DEBUG ME")
        }
    }
    
    
    // TODO: Mark For Debugging !!
//    let twitterClassifer = TwitterClassifer()
//    let twitterClassifer: TwitterClassifer = {
//        do {
//            let config = MLModelConfiguration()
//            return try TwitterClassifer(configuration: config)
//        } catch {
//            print(" [!] Error in creating twitterClassfier obj \(error)")
//            fatalError("Couldn't create Twitter Classifier")
//        }
//    }()
    
    //  let swifter = Swifter(consumerKey: consumerKey , consumerSecret: privKey )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLogFile()
     //   let swifter = Swifter(consumerKey: consumerKey , consumerSecret: privKey )
        createObservers()
        NSLog("[LOGGING--> <START> [Twitter-Classifcation VC]")
        textField?.text = homeTextValue ?? ""
        if textField?.text != nil {
            symbolLabel.text = homeTextValue ?? textField?.text
            symbolLabel.text = textField?.text

           // fetchTweets(swifter.self)
        }
        
        viewWillAppear(true)
        
    }
    
     func viewWillAppear(_ animated: Bool, sentimentScore: Int) {
         print("view will appear")
        super.viewWillAppear(animated)
         if sentimentScore > 20 {
             self.view.backgroundColor = .purple
             backgroundView.backgroundColor = .purple

        }
         else if sentimentScore > 10 &&  sentimentScore < 20 {
             self.view.backgroundColor = .winningGreen
             backgroundView.backgroundColor = .winningGreen
         }
         else if sentimentScore < 10 &&  sentimentScore > 0 {
             self.view.backgroundColor = .yellow
         }
         else if sentimentScore == 0 {
             self.view.backgroundColor = .systemGray2
         }
         else if sentimentScore > -10 && sentimentScore < 0 {
             self.view.backgroundColor = .darkGray
         }
         else if sentimentScore < -10  {
             self.view.backgroundColor = .red
         }
    }
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPredictViewController.updateUI(sentimentScore:)), name: loveBackgroundKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPredictViewController.updateUI(sentimentScore:)), name: happyBackgroundKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPredictViewController.updateUI(sentimentScore:)), name: posNeutralBkGroundKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPredictViewController.updateUI(sentimentScore:)), name: neutralBkGroundKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPredictViewController.updateUI(sentimentScore:)), name: negNeutralBkGroundKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPredictViewController.updateUI(sentimentScore:)), name: angryBkGroundKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPredictViewController.updateUI(sentimentScore:)), name: disguistedBkGroundKey, object: nil)
                                               
    }
    
    func updateBackground(notification: NSNotification) {
      
        let isLove = notification.name == loveBackgroundKey
        let isLovecolor = isLove ? UIColor.cyan : UIColor.red
        self.view.backgroundColor = isLovecolor
        view.layoutSubviews()
        let isHappy = notification.name == happyBackgroundKey
        let isHappyColor = isHappy ? UIColor.yellow : UIColor.gray
        self.view.backgroundColor = isHappyColor

        let isPosNeutral = notification.name == posNeutralBkGroundKey
        let isPosNeutralColor = isPosNeutral ? UIColor.yellow : UIColor.gray
        self.view.backgroundColor = isPosNeutralColor

        let isNeutral = notification.name == neutralBkGroundKey
        let isNeutralColor = isNeutral ? UIColor.yellow : UIColor.gray
        self.view.backgroundColor = isNeutralColor
        

        let isNegNeutral = notification.name == angryBkGroundKey
        let isNegNeutralColor = isNegNeutral ? UIColor.yellow : UIColor.gray
        self.view.backgroundColor = isNegNeutralColor

        let isDisguisted = notification.name == disguistedBkGroundKey
        let isDisguistedlColor = isDisguisted ? UIColor.yellow : UIColor.gray
        self.view.backgroundColor = isDisguistedlColor

    }
    
    @IBAction func fetchTweets(_ sender: Any) {
        // let TwitterClassifer = TwitterClassifer()
        
        let maxTweetCount = 100
    // let swifter = Swifter(consumerKey: consumerKey , consumerSecret: privKey )
        
        // TODO: Debug this
        let textInput = textField?.text
        let textInput00 = sender.self
        //  let prediction = try! TwitterClassifer.prediction(text: textInput ?? "DEBUG ME")
        
        print("[!] \(String(describing: textInput))")
        print("[!] \(textInput00)")
        
        
//        swifter.searchTweet(using: textField?.text ?? "DEBUG ME", lang: "en", count: maxTweetCount, tweetMode: .extended, success:
//                                { (results, metaData) in
//            
//            var tweets = [TwitterClassiferInput]()
//            print("[+] Tweets Metadata \(metaData)]")
//            print("[+] API Fetch Results [\(results)]")
//            print("[+] Tweets \(tweets)]")
//            
//            for i in 0..<maxTweetCount {
//                if let tweet = results[i]["full_text"].string {
//                    print("[+] [TWEETS] [\(i)] \(tweet)")
//                    let tweetForClassification = TwitterClassiferInput(text: tweet)
//                    tweets.append(tweetForClassification)
//                }
//            }
//            do {
//                let predictions = try self.twitterClassifer.predictions(inputs: tweets)
//                
//                var sentimentScore = 0
//                for pred in predictions {
//                    let sentiment = pred.label
//                    print("[+] Sentiment \(sentiment) + \(pred)")
//                    if sentiment == "Pos" { sentimentScore += 1
//                    } else if sentiment == "Neg"{ sentimentScore -= 1}
//                    self.updateUI(sentimentScore: sentimentScore)
//                    self.viewWillAppear(true, sentimentScore: sentimentScore)
//                }
//                
//                print("[+] Predictions \(predictions)")
////                print("[+] Predictions Label [SCORE] \(sentimentScore) \(predictions[0].label ?? "no input paramaters")")
//                print("[+] What Twitter Thinks: [Classification-Score] \(sentimentScore)")
//                
//            } catch { print("[-] Error in Twitter Prediction \(error)") }
//            
//        }, failure: { error in
//            print("[-] Error in [func]fetchingTweets api \(error)")
//            
//        })
    }
    
    
    @objc func updateUI(sentimentScore: Int) {
        
        if sentimentScore > 20 {
            let loveBackground = Notification.Name(rawValue: loveBackgroundKey.rawValue)
            self.sentimentLabel.text = "😍"
            view.backgroundColor = .purple
            self.backgroundView.backgroundColor = .purple
            self.symbolLabel.textColor = .lightGray
            self.symbolLabel.text = textField?.text

            self.viewWillAppear(true, sentimentScore: sentimentScore)
            //NotificationCenter.default.post(name: loveBackground, object: nil)
            
        } else if sentimentScore > 10 {
            let happyBackground = Notification.Name(rawValue: happyBackgroundKey.rawValue)
           // NotificationCenter.default.post(name: happyBackground, object: nil)
            self.view.backgroundColor = .winningGreen
            self.backgroundView.backgroundColor = .winningGreen
            self.symbolLabel.textColor = .lightGray
            self.symbolLabel.text = textField?.text

            self.viewWillAppear(true, sentimentScore: sentimentScore)
            self.sentimentLabel.text = "😀"
            
        } else if sentimentScore > 0 {
            let posNeutralBkGround = Notification.Name(rawValue: posNeutralBkGroundKey.rawValue)
           // NotificationCenter.default.post(name: posNeutralBkGround, object: nil)
            view.backgroundColor = .yellow
            self.backgroundView.backgroundColor = .yellow
            self.symbolLabel.textColor = .gray
            self.symbolLabel.text = textField?.text

            self.viewWillAppear(true, sentimentScore: sentimentScore)
            self.sentimentLabel.text = "🙂"
            
        } else if sentimentScore == 0 {
            let neutralBkGround = Notification.Name(rawValue: neutralBkGroundKey.rawValue)
           // NotificationCenter.default.post(name: neutralBkGround, object: nil)
            view.backgroundColor = .gray
            self.backgroundView.backgroundColor = .gray
            self.symbolLabel.textColor = .darkGray
            self.symbolLabel.text = textField?.text

            self.viewWillAppear(true, sentimentScore: sentimentScore)
            self.sentimentLabel.text = "😐"
            
        } else if sentimentScore > -10 {
            let netNegativeBkGround = Notification.Name(rawValue: negNeutralBkGroundKey.rawValue)
          //  NotificationCenter.default.post(name: netNegativeBkGround, object: nil)
            view.backgroundColor = .darkGray
            self.backgroundView.backgroundColor = .darkGray
            self.symbolLabel.textColor = .black
            self.symbolLabel.text = textField?.text
            self.viewWillAppear(true, sentimentScore: sentimentScore)

            self.sentimentLabel.text = "😕"
            
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
            let angryBkGround = Notification.Name(rawValue: angryBkGroundKey.rawValue)
            view.backgroundColor = .systemOrange
            self.backgroundView.backgroundColor = .systemOrange
            self.symbolLabel.textColor = .black
            self.symbolLabel.text = textField?.text


            self.viewWillAppear(true, sentimentScore: sentimentScore)
           // NotificationCenter.default.post(name: angryBkGround, object: nil)
        } else {
            self.sentimentLabel.text = "🤮"
            let disguistedBkGround = Notification.Name(rawValue: disguistedBkGroundKey.rawValue)
            //NotificationCenter.default.post(name: disguistedBkGround, object: nil)
            view.backgroundColor = .systemOrange
            self.viewWillAppear(true, sentimentScore: sentimentScore)
            self.backgroundView.backgroundColor = .losingRed
            self.symbolLabel.textColor = .black
            self.symbolLabel.text = textField?.text
       }
    }
}

let loveBackgroundKey = Notification.Name(rawValue: love)
let happyBackgroundKey = Notification.Name(rawValue: happy)
let posNeutralBkGroundKey = Notification.Name(rawValue: posNeutral)
let neutralBkGroundKey = Notification.Name(rawValue: neutral)
let negNeutralBkGroundKey = Notification.Name(rawValue: negNeutral)
let unhappyBkGroundKey = Notification.Name(rawValue: unhappy)
let angryBkGroundKey = Notification.Name(rawValue: angry)
let disguistedBkGroundKey = Notification.Name(rawValue: disguisted)

let love = "20"
let happy = "10"
let posNeutral = "1"
let neutral = "0"
let negNeutral = "-1"
let unhappy = "-10"
let angry = "-20"
let disguisted = "-30"
