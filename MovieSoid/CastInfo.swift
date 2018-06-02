//
//  CastInfo.swift
//  MovieSoid
//
//  Created by datdn1 on 6/18/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

struct Crew: Mappable {
    var id: Int!
    var job: String!
    var name: String!
    var profilePath: String!

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        job <- map["job"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
}

class Cast: Mappable {
    var id: Int!
    var character: String!
    var name: String!
    var profilePath: String!

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        character <- map["character"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
}

extension Cast {
    func attrStringForName(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: self.name, attributes: attr)
    }

    func attrStringForCharater(withSize size: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attr = [
            NSForegroundColorAttributeName : UIColor.lightGray,
            NSFontAttributeName: UIFont.systemFont(ofSize: size),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        return NSAttributedString(string: self.character, attributes: attr)
    }
}

class CastInfo: Mappable, DetailInfoSortProtocol {
    var casts: [Cast]!
    var crews: [Crew]!

    required init?(map: Map) { }

    func mapping(map: Map) {
        casts <- map["cast"]
        crews <- map["crew"]
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

extension CastInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "\(detailIndex)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? CastInfo else { return false }
        return self.detailIndex == object.detailIndex
    }
}

extension Cast: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "\(self.id)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Cast else { return false }
        return self.id == object.id
    }
}


