//
//  HorizalDetailCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/19/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HorizalDetailCell: ASCellNode {

    let controller: UIViewController?
    let heightForNode: CGFloat

    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        let attrs = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: Constants.CellLayout.FontSize)
        ]
        node.attributedText = NSAttributedString(string: "", attributes: attrs)
        return node
    }()

    lazy var seeAllTextNode: ASTextNode = {
        let node = ASTextNode()
        let attrs = [
            NSForegroundColorAttributeName : UIColor.lightGray,
            NSFontAttributeName: UIFont.systemFont(ofSize: 13)
        ]
        node.attributedText = NSAttributedString(string: "See All〉", attributes: attrs)
        return node
    }()

    lazy var castCollectionNode: ASCollectionNode = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let node = ASCollectionNode(collectionViewLayout: flowLayout)
        node.backgroundColor = Constants.Color.primaryColor
        return node
    }()

    override func didLoad() {
        super.didLoad()
        self.castCollectionNode.view.alwaysBounceVertical = false
        self.adapter.setASDKCollectionNode(self.castCollectionNode)
    }

    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self.controller, workingRangeSize: 0)
    }()

    init(title: String, height: CGFloat, controller: UIViewController?) {
        self.controller = controller
        self.heightForNode = height
        super.init()
        self.titleTextNode.attributedText = NSAttributedString(string: title)
        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let headerStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .spaceBetween, alignItems: .center, children:  [self.titleTextNode, self.seeAllTextNode])
        headerStackSpec.style.width = ASDimension(unit: .points, value: UIScreen.main.bounds.size.width)
        let headerInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(12, 8, 12, 8), child: headerStackSpec)

        let headerBackgroundNode = ASDisplayNode()
        headerBackgroundNode.backgroundColor = Constants.Color.headerColor

        let headerBackgroundSpec = ASBackgroundLayoutSpec(child:headerInsetSpec , background: headerBackgroundNode)

        self.castCollectionNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.heightForNode)
        let mainStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 3, justifyContent: .start, alignItems: .start, children: [headerBackgroundSpec, self.castCollectionNode])
        return mainStackSpec
    }
}
