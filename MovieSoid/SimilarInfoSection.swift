//
//  SimilarDetailInfoSection.swift
//  MovieSoid
//
//  Created by datdn1 on 6/20/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import IGListKit

class SimilarInfoSection: ListSectionController, ASSectionController {
    override init() {
        super.init()
        self.inset = UIEdgeInsetsMake(10, 0, 20, 0)
    }

    var object: MoviesInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        guard let simalarInfo = object else { return {
            return ASCellNode()
            }
        }
        return {
            return SimilarDetailInfoCell(model: simalarInfo, controller: self.viewController)
        }
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func didUpdate(to object: Any) {
        self.object = object as? MoviesInfo
    }

    override func didSelectItem(at index: Int) { }

    override func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}








