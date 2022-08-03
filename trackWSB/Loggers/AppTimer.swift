//
//  AppTimer.swift
//  Finance_App01
//
//  Created by Adel Al-Aali on 6/23/22.
//

import Foundation
import UIKit
import Combine

// Impliments User-timer
class AppTimer  {
    
    @Published var counter: Int = 0
    
    var subscribers = Set<AnyCancellable>()
    
    
    init() { setupTimer() }
    
    func setupTimer() {
        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] count in
                guard let self = self else { return }
                self.counter+=1
                // print("[!][COUNTER] \(count)")
            }
            .store(in: &subscribers)
    }
}
