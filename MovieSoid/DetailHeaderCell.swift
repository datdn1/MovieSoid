//
//  DetailHeaderCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/20/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class DetailHeaderCell: ASCellNode {

    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
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

    init(title: String) {
        super.init()
        self.titleTextNode.attributedText = NSAttributedString(string: title)
        self.backgroundColor = Constants.Color.headerColor
        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let headerStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .spaceBetween, alignItems: .center, children:  [self.titleTextNode, self.seeAllTextNode])
        headerStackSpec.style.width = ASDimension(unit: .points, value: UIScreen.main.bounds.size.width)
        let headerInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(12, 8, 12, 8), child: headerStackSpec)
        return headerInsetSpec
    }
}
















