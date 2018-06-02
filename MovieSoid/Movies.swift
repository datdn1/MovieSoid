//
//  Movies.swift
//  MovieSoid
//
//  Created by datdn1 on 6/16/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

class MoviesInfo: Mappable, DetailInfoSortProtocol {
    var totalPages: Int!
    var movies:[Movies]!
    var totalResults: Int!
    var page: Int!

    required init?(map: Map) { }

    func mapping(map: Map) {
        totalPages <- map["total_pages"]
        movies <- map["results"]
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

extension MoviesInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "\(self.detailIndex)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? MoviesInfo else { return false }
        return self.detailIndex == object.detailIndex
    }
}

extension MoviesInfo {
    func attrStringForResult(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: String(format: "%d results", self.totalResults) , attributes: attr)
    }
}

struct Genres: Mappable {
    var id: Int!
    var name: String!

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

class Movies: NSObject, Mappable, DetailInfoSortProtocol {
    var voteCount: Int!
    var id: Int!
    var video: Bool!
    var voteAverage: Float!
    var title: String!
    var popularity: Float!
    var posterPath: String!
    var genreIds: [Int]!
    var backdropPath: String!
    var overview: String!
    var releaseDate: String!
    var runtime: Int!
    var genres: [Genres]!

    required init?(map: Map) { }

    func mapping(map: Map) {
        voteCount <- map["vote_count"]
        id <- map["id"]
        video <- map["video"]
        voteAverage <- map["vote_average"]
        title <- map["title"]
        popularity <- map["popularity"]
        posterPath <- map["poster_path"]
        genreIds <- map["genre_ids"]
        backdropPath <- map["backdrop_path"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        runtime <- map["runtime"]
        genres <- map["genres"]
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

extension Movies {

    // MARK: - Attributed Strings
    func attrStringForTitle(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: self.title, attributes: attr)
    }

    func attrStringForDetailTitle(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: self.title, attributes: attr)
    }

    func attrStringForDetailGenres(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.lightGray,
            NSFontAttributeName: UIFont.systemFont(ofSize: size)
        ]
        let strs = [self.timeInfo(), self.genresInfo()].filter { $0.characters.count > 0 }
        let genresString = strs.joined(separator: " • ")
        return NSAttributedString(string: genresString, attributes: attr)
    }

    func attrStringForYear(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.lightGray,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
        ]
        let year = self.releaseDate.components(separatedBy: "-").first!
        return NSAttributedString(string: year, attributes: attr)
    }

    func attrStringForRate(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: String(format: "%.1f", self.voteAverage), attributes: attr)
    }

    func attrStringForVoteCount(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.lightGray,
            NSFontAttributeName: UIFont.systemFont(ofSize: size)
        ]
        if let voteCount = self.voteCount, voteCount > 0 {
            return NSAttributedString(string: "\(voteCount) votes", attributes: attr)
        }
        else {
            return NSAttributedString(string: "", attributes: attr)
        }
    }

    func attrStringForOverview(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
        ]
        return NSAttributedString(string: self.overview, attributes: attr)
    }

    func attrStringForDetailOverview(withSize size: CGFloat) -> NSAttributedString {
        let attr = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: size)
        ]
        return NSAttributedString(string: self.overview, attributes: attr)
    }
}

extension Movies {
    func genresInfo() -> String {
        guard let genres = self.genres, genres.count > 0 else { return "" }
        let genreNames = genres.filter { ($0.name != nil) && ($0.name.characters.count > 0) }.map { $0.name! }
        return genreNames.joined(separator: ", ")
    }

    func timeInfo() -> String {
        guard let time = self.runtime, time > 0 else { return "" }
        return "\(time)min"
    }
}

extension Movies: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "\(self.id)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Movies else { return false }
        return self.id == object.id
    }
}
















