//
//  MovieInfoSection.swift
//  MovieSoid
//
//  Created by datdn1 on 6/19/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import IGListKit

class MovieInfoSection: IGListSectionController, IGListSectionType, ASSectionController {
    var object: Movies?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        guard let movie = object else { return {
                return ASCellNode()
            }
        }
        return {
            return MovieDetailInfoCell(model: movie)
        }
    }
    
    func numberOfItems() -> Int {
        return 1
    }

    func didUpdate(to object: Any) {
        self.object = object as? Movies
    }

    func didSelectItem(at index: Int) { }

    func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}
