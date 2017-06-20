//
//  MovieGridCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/17/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MovieGridCell: MovieBaseCell {

    override init(model: Movies) {
        super.init(model: model)
        self.backgroundColor = Constants.Color.headerColor
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let width = constrainedSize.min.width
        let height = width * 3 / 2.0

        self.posterImageNode.style.preferredSize = CGSize(width: width, height: height)
        self.titleTextNode.style.flexGrow = 1
        self.titleTextNode.style.flexShrink = 1

        var children: [ASLayoutElement] = [self.posterImageNode, self.titleTextNode, self.yearTextNode]
        if let rate = self.rateTextNode.attributedString(), rate.length > 0 {
            children.append(self.rateTextNode)
        }

        let mainStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 2, justifyContent: .center, alignItems: .center, children: children)
        mainStackSpec.style.width = ASDimension(unit: .points, value: width)

        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 8, 0), child: mainStackSpec)

        return insetSpec
    }
}
