//
//  String+Extensions.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 11/05/24.
//

import Foundation

extension String{
    var isEmptyOrWhiteSpace:Bool{
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
