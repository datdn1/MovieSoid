//
//  VideosInfo.swift
//  MovieSoid
//
//  Created by datdn1 on 6/18/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit


struct Videos: Mappable {
    var id: String!
    var key: String!
    var name: String!
    var type: String!

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        key <- map["key"]
        name <- map["name"]
        type <- map["type"]
    }
}

class VideosInfo: Mappable, DetailInfoSortProtocol {
    var videos: [Videos]!

    required init?(map: Map) { }

    func mapping(map: Map) {
        videos <- map["results"]
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

extension VideosInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "\(detailIndex)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? VideosInfo else { return false }
        return self.detailIndex == object.detailIndex
    }
}
