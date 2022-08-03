////
////  createMLmodel.swift
////  Finance_App00
////
////  Created by a-robota on 5/28/22.
////
//
//
//import UIKit
//import SwiftyJSON
//import CoreML
//import SwifteriOS
//// import CreateML
//
//struct createTwitterMLmodel {
//
//    func runTrainingModule() {
//        // train then test -> 80/20 SPLIT - Column Name [class] && row [text]
//
//        let consumerKey: String = "r0XWPP9uUT0FW9q1yQ9KrnkT8Kxgmr2oiL9MeC7c70HyUlgc39"
//        let privKey: String = "r0XWPP9uUT0FW9q1yQ9KrnkT8Kxgmr2oiL9MeC7c70HyUlgc39"
//        let twitterPath: String = "/Users/adelal-aali/Desktop/Finance_App01/twitter-sanders-apple3.csv"
//        let classificationPath = "/Users/adelal-aali/Desktop/Finance_App01/TwitterClassifer.mlmodel"
//
//        let swifter = Swifter(consumerKey:consumerKey , consumerSecret: privKey )
//        let data = try MLDataTable(contentsOf: URL(fileURLWithPath: twitterPath))
//        let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5 )
//        let sentimentClassifier = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "class")
//
//        //MARK: EVALUATE Errors in Classification
//        let testingMetrics = sentimentClassifier.evaluation(on: testingData)
//        let classificiationErr = (1.0 - testingMetrics.classificationError) * 100
//
//        try sentimentClassifier.write(to: URL(fileURLWithPath: classificationPath))
//        try sentimentClassifier.prediction(from: "@do not buy twitter stock")
//        try sentimentClassifier.prediction(from: "@I wrote a scam app, do not buy")
//        try sentimentClassifier.prediction(from: "@Google does not make a safe phone")
//    }
//}
//
//func sentimentClassifier () {
//
//}
//
