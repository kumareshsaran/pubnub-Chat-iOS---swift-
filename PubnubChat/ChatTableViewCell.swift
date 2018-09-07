//
//  ChatTableViewCell.swift
//  PubnubChat
//
//  Created by CSS on 05/09/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    var labelMessage = UILabel()
    var backGroundView = UIView()
    var labelTime = UILabel()
    
    var isIncomming : String = "" {
        didSet {
            backGroundView.backgroundColor = isIncomming == "user" ? UIColor(red: 229/255, green: 230/255, blue: 234/255, alpha: 1) : UIColor(red: 165/255, green: 239/255, blue: 91/255, alpha: 1)
            labelMessage.textColor = isIncomming == "user" ? UIColor(red: 54/255, green: 54/255, blue: 55/255, alpha: 1) : UIColor(red: 54/255, green: 54/255, blue: 55/255, alpha: 1)
            
            if isIncomming == "user" {
                messageLeadingConstraint.isActive = true
                messageTrailingConstraint.isActive = false
                
                timeLeadingConstraint.isActive = true
                timeTrailingConstraint.isActive = false
            }else{
                messageLeadingConstraint.isActive = false
                messageTrailingConstraint.isActive = true
                
                timeTrailingConstraint.isActive = true
                timeLeadingConstraint.isActive = false
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backGroundView)
        addSubview(labelMessage)
        addSubview(labelTime)
        backgroundColor = UIColor.clear
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        labelTime.backgroundColor = UIColor.clear
        labelTime.textColor = UIColor.lightGray
        
        labelTime.font = UIFont.systemFont(ofSize: 10)
        labelTime.text = "20 min ago"
        
        backGroundView.backgroundColor = UIColor.lightGray
        backGroundView.layer.cornerRadius = 15
        labelMessage.numberOfLines = 0
        
        let constraints = [labelMessage.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                        
                           labelMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                           labelMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                           
                           backGroundView.topAnchor.constraint(equalTo: labelMessage.topAnchor, constant: -16),
                           backGroundView.leadingAnchor.constraint(equalTo: labelMessage.leadingAnchor, constant: -16),
                           backGroundView.bottomAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 16),
                           backGroundView.trailingAnchor.constraint(equalTo: labelMessage.trailingAnchor, constant: 16),
                           
                            labelTime.heightAnchor.constraint(equalToConstant: 10),
                            labelTime.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
                            labelTime.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor, constant: 10)
            
            
                           ]
        
        
        NSLayoutConstraint.activate(constraints)
        
        messageLeadingConstraint = labelMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
       // messageLeadingConstraint.isActive = false
        messageTrailingConstraint = labelMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
       // messageTrailingConstraint.isActive = true
        
        timeLeadingConstraint = labelTime.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
       // timeLeadingConstraint.isActive = false
        timeTrailingConstraint = labelTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        //timeTrailingConstraint.isActive = true
        
        
    }
    
    var messageLeadingConstraint : NSLayoutConstraint!
    var messageTrailingConstraint : NSLayoutConstraint!
    var timeLeadingConstraint : NSLayoutConstraint!
    var timeTrailingConstraint : NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
