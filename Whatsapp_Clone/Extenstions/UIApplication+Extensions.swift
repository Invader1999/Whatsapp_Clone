//
//  UIApplication+Extensions.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 12/06/24.
//

import Foundation
import UIKit

extension UIApplication{
    static func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
