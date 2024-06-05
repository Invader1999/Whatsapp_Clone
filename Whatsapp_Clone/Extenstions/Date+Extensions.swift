//
//  Date+Extensions.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 19/05/24.
//

import Foundation

extension Date{
    
    var dayOrTimeRepresentation:String{
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calender.isDateInToday(self){
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
            
        }else if calender.isDateInYesterday(self){
            return "Yeseterday"
        }else{
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter.string(from: self)
        }
    }
    
    var formatToTime:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: self)
        return formattedTime
    }
    func toString(format:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
