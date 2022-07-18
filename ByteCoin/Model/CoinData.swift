//
//  CoinData.swift
//  ByteCoin
//
//  Created by Stacy on 25.05.22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let rate: Double
    
    var lastPrice: String {
        return String(format: "%.2f", rate)
    }

}
