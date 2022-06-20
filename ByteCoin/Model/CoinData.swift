//
//  File.swift
//  ByteCoin
//
//  Created by output. on 2022/05/14.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

//CoinData構造体
//スーパークラスにプロトコルDecodableを持つ
struct CoinData: Decodable {
    
    //There's only 1 property we're interested in the JSON data, that's the last price of bitcoin
    //Because it's a decimal number, we'll give it a Double data type.
    //APIkeyでJSONデータを取得して、必要なプロパティは最終価格の1つだけなので定数rateとしてDouble型で宣言しておく
    let rate: Double
}
