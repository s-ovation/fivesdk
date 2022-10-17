//
//  MyLog.swift
//  fivesdk
//
//  Created by Kei Oikawa on 2022/10/11.
//

import Foundation

// カスタムロガー(デバッグモードのときだけログが出る)
func mylog(_ items: Any...) {
    #if DEBUG
    let arr: [String] = ["FiveSdkPlugin:"] + items.map { String(describing: $0) }
    Swift.print(arr.joined(separator: " "))
    #endif
}
