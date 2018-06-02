//
//  ReviewInfo.swift
//  MovieSoid
//
//  Created by datdn1 on 6/18/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

class Reviews: Mappable {
    var id: Int!
    var author: String!
    var content: String!
    var isSeeMore: Bool!

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        author <- map["author"]
        content <- map["content"]
        isSeeMore = false
    }
}

extension Reviews {
    func attrStringForAuthor(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : Constants.Color.actionColor,
            NSFontAttributeName: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: "@\(self.author!)", attributes: attr)
    }

    func attrStringForContent(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.lightGray,
            NSFontAttributeName: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: self.content, attributes: attr)
    }
}

class ReviewsInfo: Mappable, DetailInfoSortProtocol {
    var totalPages: Int!
    var reviews:[Reviews]!
    var totalResults: Int!
    var page: Int!

    required init?(map: Map) { }

    func mapping(map: Map) {
        totalPages <- map["total_pages"]
        reviews <- map["results"]
        totalResults <- map["total_results"]
        page <- map["page"]
    }

    var detailIndex: Int = 0

    var identifier: Int {
        set {
            detailIndex = newValue
        }

        get {
            return detailIndex
        }
    }
}

extension ReviewsInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "\(detailIndex)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? ReviewsInfo else { return false }
        return self.detailIndex == object.detailIndex
    }
}












