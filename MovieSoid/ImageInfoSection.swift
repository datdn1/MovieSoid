//
//  ImageInfoSection.swift
//  MovieSoid
//
//  Created by datdn1 on 6/20/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import IGListKit

class ImagesInfoSection: IGListSectionController, IGListSectionType, ASSectionController {
    override init() {
        super.init()
        self.inset = UIEdgeInsetsMake(10, 0, 20, 0)
    }

    var object: ImagesInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        guard let imagesInfo = object else { return {
                return ASCellNode()
            }
        }
        return {
            return ImagesDetailInfoCell(model: imagesInfo, controller: self.viewController)
        }
    }

    func numberOfItems() -> Int {
        return 1
    }

    func didUpdate(to object: Any) {
        self.object = object as? ImagesInfo
    }

    func didSelectItem(at index: Int) { }

    func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}
