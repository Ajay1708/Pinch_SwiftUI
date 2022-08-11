//
//  PageModel.swift
//  Pinch_SwiftUI
//
//  Created by Venkata Ajay Sai (Paras) on 11/08/22.
//

import Foundation
struct Page:Identifiable{
    let id: Int
    let name: String
}

extension Page{
    var thumbImg: String{
        return "thumb-" + name
    }
}
