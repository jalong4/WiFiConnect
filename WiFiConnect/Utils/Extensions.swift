//
//  Extensions.swift
//  WiFiConnect
//
//  Created by Jim Long on 3/12/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class Utils {
    static func isEmailValid(_ email: String?) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
    }
    
    static func isUsernameValid(_ username: String?) -> Bool {
        // "0-9 a-z A-Z _ between 6 and 18 characters in length
        return NSPredicate(format:"SELF MATCHES %@", "^[0-9a-zA-Z\\_]{6,18}$").evaluate(with: username)
    }
    
    static func isPasswordValid(_ password: String?) -> Bool {
        /*
         1 - Password length is 6 or greater.
         2 - At least one letter in Password.
         3 - at least one Special Character in Password.
         
         */
        
        return NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}").evaluate(with: password)
    }
    
    static func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }

}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIImage {
    func resizeImage(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(newSize)
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
}

extension UIView {
    func anchor (top: NSLayoutYAxisAnchor?,
                 left: NSLayoutXAxisAnchor?,
                 bottom: NSLayoutYAxisAnchor?,
                 right: NSLayoutXAxisAnchor?,
                 paddingTop: CGFloat,
                 paddingLeft: CGFloat,
                 paddingBottom: CGFloat,
                 paddingRight: CGFloat,
                 width: CGFloat,
                 height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UITextField {
    func setDefaults() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.03)
        self.borderStyle = .roundedRect
        self.font = UIFont.systemFont(ofSize: 14)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        self.clearButtonMode = .whileEditing
    }
}
