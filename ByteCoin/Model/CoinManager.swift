//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Stacy on 25.05.22.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate { // протокол инициализ. в том же файле, где класс, использующ. протокол
    func didUpdateCurrency(_ coinManager: CoinManager, coinData: CoinData, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0EBDA1FF-96A0-4232-AED5-373E671F2B2A"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?


    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
                    
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            self.delegate?.didFailWithError(error: error!)
                            return
                        }

                if let safeData = data {
                    let bitcoinPrice = self.parseJSON(safeData)
                    self.delegate?.didUpdateCurrency(self, coinData: bitcoinPrice!, currency: currency)
                }
                
            }
            task.resume() //4. start the task
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastRate = decodedData.rate
            
            let price = CoinData(rate: lastRate)
            return price

        } catch {
            delegate?.didFailWithError(error: error)
           return nil
        }
    }
    
}
