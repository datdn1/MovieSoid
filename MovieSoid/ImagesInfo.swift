//
//  ImagesInfo.swift
//  MovieSoid
//
//  Created by datdn1 on 6/18/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit


struct Image: Mappable {
    var ratio: Float!
    var filePath: String!
    var height: Int!
    var width: Int!

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        ratio <- map["aspect_ratio"]
        height <- map["height"]
        width <- map["width"]
        filePath <- map["file_path"]
    }
}

class ImagesInfo: Mappable, DetailInfoSortProtocol {
    var posters: [Image]!
    var backdrops: [Image]!

    required init?(map: Map) { }

    func mapping(map: Map) {
        posters <- map["posters"]
        backdrops <- map["backdrops"]
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

extension ImagesInfo: IGListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "\(detailIndex)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? ImagesInfo else { return false }
        return self.detailIndex == object.detailIndex
    }

}
