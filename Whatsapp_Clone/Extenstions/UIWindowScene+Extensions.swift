//
//  UIWindowScene+Extensions.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 12/06/24.
//

import Foundation
import UIKit

extension UIWindowScene{
    static var current:UIWindowScene?{
        return UIApplication.shared.connectedScenes
            .first{$0 is UIWindowScene} as? UIWindowScene
    }
    
    var screenWidth:CGFloat{
        return UIWindowScene.current?.screen.bounds.width ?? 0
    }
    
    var screenHeight:CGFloat{
        return UIWindowScene.current?.screen.bounds.height ?? 0 
    }
}
