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
    
    var relativeDateString:String{
        let calendar = Calendar.current
        if calendar.isDateInToday(self){
            return "Today"
        }else if calendar.isDateInYesterday(self){
            return "Yesterday"
        }else if isCurrentWeek{
            return toString(format: "EEEE")
        }else if isCurrentYear{
            return toString(format: "E, MMM d") // "Sat, Jul 06 "
        }else{
            return toString(format: "MMM dd, yyyy") // "Sat, Jul 06, 2024"
        }
    }
    
    private var isCurrentWeek:Bool{
        return Calendar.current.isDate(self, equalTo: Date(),toGranularity: .weekday)
    }
    
    private var isCurrentYear:Bool{
        return Calendar.current.isDate(self, equalTo: Date(),toGranularity: .year)
    }
    
    
    func isSameDay(as otherDate:Date)-> Bool{
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}
