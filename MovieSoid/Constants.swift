//
//  Constants.swift
//  MovieSoid
//
//  Created by datdn1 on 6/16/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct CellLayout {
        static let TitleFontSize: CGFloat = 16
        static let FontSize: CGFloat = 14
        static let WatchListButtonFontSize: CGFloat = 13
    }

    struct URL {
        static let ImageBaseURL: String = "https://image.tmdb.org/t/p/w500"
        static let EndpointBaseURL: String = "https://api.themoviedb.org/3"
        static let VideoBaseURL: String = "https://www.youtube.com/watch?v="
        static let ThumbnailBaseURL: String = "https://img.youtube.com/vi/"
    }

    struct DetailSectionIndex {
        static let DetailSection: Int = 1
        static let CreditsSection: Int = 2
        static let VideosSection: Int = 3
        static let ImagesSection: Int = 4
        static let SimilarSection: Int = 5
        static let ReviewsSection: Int = 6
    }

    struct Color {
        static let primaryColor: UIColor = UIColor(red: 42.0/255, green: 42.0/255, blue: 42.0/255, alpha: 1.0)
        static let headerColor: UIColor = UIColor(red: 54.0/255, green: 54.0/255, blue: 54.0/255, alpha: 1.0)
        static let actionColor: UIColor = UIColor(red: 0/255, green: 211.0/255, blue: 115.0/255, alpha: 1.0)
    }
}
