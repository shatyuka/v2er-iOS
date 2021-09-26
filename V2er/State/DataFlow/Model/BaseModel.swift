//
//  BaseModel.swift
//  BaseModel
//
//  Created by ghui on 2021/8/21.
//  Copyright © 2021 lessmore.io. All rights reserved.
//

import Foundation
import SwiftSoup

protocol HtmlParsable {
    init(from html: Element?)
}

protocol HtmlItemModel: HtmlParsable, Identifiable {

}

protocol BaseModel: HtmlParsable {
    var rawData: String? { get set }

    init()

    func isValid() -> Bool
}

extension BaseModel {

    var rawData: String? {
        get {
            return .empty
        }
        set {

        }
    }

    func isValid() -> Bool {
        return true
    }
}




