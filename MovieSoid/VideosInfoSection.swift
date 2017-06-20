//
//  VideosInfoSection.swift
//  MovieSoid
//
//  Created by datdn1 on 6/19/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import IGListKit

class VideosInfoSection: IGListSectionController, IGListSectionType, ASSectionController {

    override init() {
        super.init()
        self.inset = UIEdgeInsetsMake(10, 0, 20, 0)
    }

    var object: VideosInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        guard let videosInfo = object else { return {
            return ASCellNode()
            }
        }
        return {
            return VideosDetailInfoCell(model: videosInfo, controller: self.viewController)
        }
    }

    func numberOfItems() -> Int {
        return 1
    }

    func didUpdate(to object: Any) {
        self.object = object as? VideosInfo
    }

    func didSelectItem(at index: Int) { }

    func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }

}
