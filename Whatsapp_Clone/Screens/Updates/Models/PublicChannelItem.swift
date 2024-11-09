//
//  PublicChannelItem.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 06/11/24.
//

import SwiftUI


struct PublicChannelItem: Identifiable {
    let imageUrl: String
    let title: String
    
    var id: String {
        title
    }
    
    
    static let placehoders:[PublicChannelItem] = [
        .init(imageUrl:"https://i.redd.it/oog08qvto2k91.jpg", title: "UFC"),
        .init(imageUrl:"https://1000logos.net/wp-content/uploads/2018/05/PSG-Logo.png",title: "Paris Saint-Germain"),
        .init(imageUrl:"https://static-00.iconduck.com/assets.00/whatsapp-icon-512x511-cfemecku.png", title: "WhatsApp"),
        .init(imageUrl:"https://asset.brandfetch.io/idP48RNgRN/idAMHRHf39.jpeg", title: "Forbes"),
        .init(imageUrl:"https://www.freevector.com/uploads/vector/preview/14053/FreeVector-Real-Madrid-FC.jpg", title: "Real Madrid"),
        .init (imageUrl:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSonGvxvmQ4_0tCWEYVUj2KRoTA8Xhgzyz0broc7RsTbg&s", title:"Times"),
        .init(imageUrl:"https://images.ctfassets.net/y2ske730sjqp/5QQ9SVIdc1tmkqrtFnG9U1/de758bba0f65dcc1c6bc1f31f161003d/BrandAssets_Logos_02-NSymbol.jpg?w=940", title: "Netflix"),
        .init(imageUrl:"https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Call_of_Duty_2023_logo_2.svg/2048px-Call_of_Duty_2023_logo_2.svg.png", title:"Call of Duty"),
        .init (imageUrl:"https://www.bleepstatic.com/content/hl-images/2022/10/27/New_York_Post.jpg", title: "New York Post"),
        .init (imageUrl:"https://1000logos.net/wp-content/uploads/2019/11/The-Wall-Street-Journal-emblem.png", title: "The Wall Street Journal"),
        .init (imageUrl:"https://logos-world.net/wp-content/uploads/2021/11/World-Wrestling-Entertainment-WWE-Logo.png", title: "WWE"),
        
    ]
}
