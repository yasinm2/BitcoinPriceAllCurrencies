//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Yasin Agbulut on 15/07/2023.

//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice (price: String , currency: String)
    func didFail (error: Error)
}

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A0D942F9-D9FB-407A-AD40-308FB5301093"
    
    let currencyArray = ["USD","TRY","EUR","AUD", "BRL","CAD","CNY","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    
    //MARK: - COINPRİCE

    func getCoinPrice (for currency : String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data , response , error) in
                if error != nil {
                    self.delegate?.didFail(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: -JSONdecode
    
        
        func parseJSON(_ data: Data) -> Double? {
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(CoinData.self, from: data)
                let lastPrice = decodedData.rate
                print(lastPrice)
              
                return lastPrice
               
                
            }
            catch {
                delegate?.didFail(error: error)
                print("hata")
                return nil
            }
        }
    }

