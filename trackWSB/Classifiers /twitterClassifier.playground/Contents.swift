import Cocoa
// import CreateML #### UNCOMMENT WHEN IN PLAYGROUNDS

var greeting = "Hello, playground"
let twitterPath: String = "/Users/adelal-aali/Desktop/Finance_App00/twitter-sanders-apple3.csv"
let classiferPath: String = "/Users/adelal-aali/Desktop/Finance_App00/TwitterClassifer.mlmodel"

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: twitterPath))

let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5 )

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")
let testingMetrics = sentimentClassifier.evaluation(on: testingData, textColumn:"text", labelColumn:"class")
let classificiationErr = (1.0 - testingMetrics.classificationError) * 100
let metaData = MLModelMetadata(author: "a-robot", shortDescription: "training/classification/accuracy test for twitter model", license: "GPL", version: "0.0.007")

try sentimentClassifier.write(to: URL(fileURLWithPath: classiferPath))
try sentimentClassifier.prediction(from: "@do not buy twitter stock")
try sentimentClassifier.prediction(from: "@I wrote a scam app, do not buy")
try sentimentClassifier.prediction(from: "@Google does not make a safe phone")
