//
//  IsNumberValid.swift
//  MyAuctions
//
//  Created by Mohab on 02/07/2025.
//
import SwiftUI


func isNumberValid(text: String) ->  (Bool,String) {
    
    let phoneRegex = #"^5\d{8}$"#
    let isValidPhone = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: text)
    
    if isValidPhone {
        return (true,"")
    }else{
        return (false,"invalid number")
    }
}

func isEmailValid(text: String) ->  (Bool,String) {
    
    let email = text.trimmingCharacters(in: .whitespacesAndNewlines)
          

           // pragmatic regex (works well for most apps)
           let pattern = #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
           var isValidEmail = text.range(of: pattern, options: .regularExpression) != nil
    
    
    if isValidEmail {
        return (true,"")
    }else{
        return (false,"invalid number")
    }
}
