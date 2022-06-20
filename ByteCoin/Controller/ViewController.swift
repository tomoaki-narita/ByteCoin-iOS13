//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    //CoinManager構造体をインスタンス化
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    
    //デリゲートメソッド
    func didUpdatePrice(price: String, currency: String) {
        //UIを更新する処理
        DispatchQueue.main.async {
            //priceにはフォーマットされた値が入っているのでその値をbitcoinLabelのテキストに代入
            self.bitcoinLabel.text = price
            //currencyにはピッカーから選択された要素名が入っているのでそれをcurrencyLabelのテキストに代入
            self.currencyLabel.text = currency
        }
    }
    //デリゲートメソッド
    //エラーが入って来たらそのエラーを出力するメソッド
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    //プロトコルUIPickerViewDataSourceの必須メソッド
    //Pickerの列数を決める
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    //プロトコルUIPickerViewDataSourceの必須メソッド
    //Pickerの行数を決める
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //currencyArrayに入っている要素の数
        return coinManager.currencyArray.count
    }
    //pickerViewの行にcurrencyArrayの配列をセットするメソッド
    //表示するだけで選択しても何も起こらない
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManager.currencyArray[row]
    }
    //pickerがスクロール(選択)されるたびに呼ばれるメソッド
    //選択するたびに選択した行の値にアクセスできる
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)//選択した行のインデックス番号が出力される
        print(coinManager.currencyArray[row])//選択した行の要素名が出力される
        //coinManagerのcurrencyArrayをselectedCurrencyとしてインスタンス化
        //選択した行の要素名をselectedCurrencyに代入
        let selectedCurrency = coinManager.currencyArray[row]
        //coinManager構造体のgetCoinPriceメソッドの引数に上で作ったインスタンスselectedCurrencyを入れる
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}




