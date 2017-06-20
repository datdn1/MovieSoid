//
//  MovieHeader.swift
//  MovieSoid
//
//  Created by datdn1 on 6/17/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MovieHeader: ASCellNode {
    lazy var numberResultTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()

    lazy var showTypeButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(UIImage(named: "ic_list"), for: .normal)
        node.addTarget(self, action: #selector(changeShowType), forControlEvents: .touchUpInside)
        return node
    }()


    init(model: MoviesInfo) {
        super.init()
        self.numberResultTextNode.attributedText = model.attrStringForResult(withSize: Constants.CellLayout.FontSize)
        self.backgroundColor = Constants.Color.headerColor
        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let headerStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 20, justifyContent: .spaceBetween, alignItems: .center, children: [numberResultTextNode, showTypeButtonNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), child: headerStackSpec)
    }

    @objc private func changeShowType() {
        print("Change show type")
    }
}
