//
//  Constants.swift
//  watchApp
//
//  Created by Matthew Mitchell on 2/25/19.
//  Copyright © 2019 InTouchTechnologies. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
