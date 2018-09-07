//
//  messageModel.swift
//  PubnubChat
//
//  Created by CSS on 05/09/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation


struct MessageModel: JSONSerializable {
    var message : String?
    var type : String?
    var created_at : Double?
    var name: String?

}
