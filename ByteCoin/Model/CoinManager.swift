//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//ViewControllerにAPIで取得したビットコインの最後の価格を渡したいのでプロトコルを作る
//処理は受け取る側で実装するので宣言のみする
protocol CoinManagerDelegate {
    
    //取得時の最終価格と通貨名をString型でViewControllerで受け取るメソッド
    func didUpdatePrice(price: String, currency: String)
    
    //エラーが検出された場合にそのエラーをViewControllerで受け取るメソッド
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    //ViewControllerにdelegateで渡す準備
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9E59560A-91A5-46FA-B6B6-0C7E2E613FED"
    
    //通貨をまとめた配列
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //ViewControllerからcurrencyに値が渡されて、それを元にサーバーからデータを取得するメソッド
    func getCoinPrice(for currency: String){
        
        //urlにユーザーが選択した通貨を文字列連結して、apikeyも連結した文字列を定数urlStringに代入
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //オプショナルバインディングを使ってurlstringから作成されたURLをアンラップ
        //アンラップ成功(urlStringに値が入っていたら)したらURL型にキャスト。定数urlに代入して、この中の処理が実行される
        if let url = URL(string: urlString){
            
            //デフォルト設定で新しいURLSessionオブジェクトを作成
            let session = URLSession(configuration: .default)
            
            //URLSessionの新しいデータタスクを作成
            //data,response,errorのどれかに値が入って来たら、この中が実行されるクロージャー
            //実行された結果が定数taskに代入される
            let task = session.dataTask(with: url) { data, response, error in
                //もしerrorがnilじゃなかったら(errorに値が入ってきたら)、デリゲートメソッドdidFailWithErrorの引数errorに入って来たエラーを渡す
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                //もしdataに値が入って来たら(JSONデータが入ってくる)定数safeDataに代入して
                if let safeData = data {
                    //safeDataをJSON解析した値をbitcoinPriceに代入
                    if let bitcoinPrice = self.parseJSON(safeData){
                        //bitcoinPriceの値を小数点以下2桁にフォーマットした値を定数priceStringに代入
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        //デリゲートメソッドのdidUpdatePriceにpriceStringとcurrencyを渡す
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            //サーバーからデータをフェッチで取得する
            //taskにはJSON解析されたデータが入っている
            task.resume()
        }
    }
    
    //JSONデータを解析するメソッド
    //引数に解析したいdataを記述するようにする
    func parseJSON(_ data: Data) -> Double? {
        
        //JSONDecoderクラスをインスタンス化
        let decoder = JSONDecoder()
        
        //do-catch文でエラー処理をする
        //エラーが出るかもしれない関数などを呼び出すときに使う
        do {
            
            //引数dataに入ってきたデータをCoinData構造体をしようしてデコードしてみる
            //デコードしたデータを定数decodedDataに代入
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //decodedDataのrateを定数lastPriceに代入
            let lastPrice = decodedData.rate
            //lastPriceを出力してみる
            print(lastPrice)
            //lastPriceを返す
            return lastPrice
            
        } catch {
            
            //エラーが入って来たらデリゲートメソッドdidFailWithErrorにerrorを渡す
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
