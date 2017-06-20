//
//  MovieTableCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/16/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MovieTableCell: MovieBaseCell {

    lazy var seperatorNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .white
        return node
    }()

    override init(model: Movies) {
        super.init(model: model)
        self.backgroundColor = Constants.Color.primaryColor
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let height = constrainedSize.min.height
        let width = height / 3.0 * 2
        self.posterImageNode.style.preferredSize = CGSize(width: width, height: height)

        var infoChildren: [ASLayoutElement] = [self.titleTextNode, self.yearTextNode, self.overviewTextNode]

        if let rate = self.rateTextNode.attributedString(), rate.length > 0 {
            infoChildren.insert(self.rateTextNode, at: 2)
        }

        let infoStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 2, justifyContent: .start, alignItems: .start, children: infoChildren)
        infoStackSpec.style.flexGrow = 1.0
        infoStackSpec.style.flexShrink = 1.0
        let mainStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .start, children: [self.posterImageNode, infoStackSpec])
        let mainStackInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 8, 8, 8), child: mainStackSpec)

        self.seperatorNode.style.preferredSize = CGSize(width: constrainedSize.min.width, height: 0.5)

        let stackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [mainStackInsetSpec, self.seperatorNode])
        return stackSpec
    }

}
