//
//  MovieDetailBaseCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/20/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MovieDetailBaseCell: ASCellNode {

    let height: CGFloat

    lazy var imageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.defaultImage = #imageLiteral(resourceName: "user_anynomus")
        node.contentMode = .scaleAspectFill
        return node
    }()

    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1

        return node
    }()

    lazy var subtitleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 2
        return node
    }()

    init(height: CGFloat) {
        self.height = height
        super.init()
        self.automaticallyManagesSubnodes = true
    }

    override func didLoad() {
        super.didLoad()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width: Double = 120
        let height: Double = width * 3 / 2.0
        self.imageNode.style.preferredSize = CGSize(width: width, height: height)

        self.titleTextNode.style.flexGrow = 1
        self.titleTextNode.style.flexShrink = 1
        self.subtitleTextNode.style.flexShrink = 1
        self.subtitleTextNode.style.flexGrow = 1

        let nameStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [self.titleTextNode, self.subtitleTextNode])
        nameStackSpec.style.width = ASDimension(unit: .points, value: CGFloat(width))

        let mainStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [self.imageNode, nameStackSpec])
        mainStackSpec.style.height = ASDimension(unit: .points, value: self.height)
        
        return mainStackSpec
    }

}
