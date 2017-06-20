//
//  Helper.swift
//  MovieSoid
//
//  Created by datdn1 on 6/19/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation

struct Helper {
    static func attrString(attrs: [String: Any], text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: attrs)
    }
}
