//
//  MovieCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/16/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import UIKit


class MovieCell: UICollectionViewCell {

    let imageBaseURL = "https://image.tmdb.org/t/p/w500"

    @IBOutlet weak var posterImageView: UIImageView!

//    public func bindModel(movie: Movies) {
//        self.posterImageView.sd_setImage(with: URL(string: imageBaseURL + movie.posterPath)!)
//    }
}
