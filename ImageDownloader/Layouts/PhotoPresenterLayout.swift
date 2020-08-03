//
//  PhotoPresenterLayout.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 27.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

class PhotoPresenterLayout: UICollectionViewFlowLayout {
  
  override func prepare() {
    self.scrollDirection = .horizontal
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    if let collectionViewBounds = self.collectionView?.bounds {
      let halfWidthOfVC = collectionViewBounds.size.width * 0.5
      let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidthOfVC
      if let attributesForVisibleCells = self.layoutAttributesForElements(in: collectionViewBounds) {
        var candidateAttribute: UICollectionViewLayoutAttributes?
        for attributes in attributesForVisibleCells {
          let candAttr: UICollectionViewLayoutAttributes? = candidateAttribute
          if candAttr != nil {
            let attributedCenterX = attributes.center.x - proposedContentOffsetCenterX
            let candAttrCenterX = candAttr!.center.x - proposedContentOffsetCenterX
            if abs(attributedCenterX) < abs(candAttrCenterX) {
              candidateAttribute = attributes
            }
          } else {
            candidateAttribute = attributes
            continue
          }
        }
        if candidateAttribute != nil {
          return CGPoint(x: candidateAttribute!.center.x - halfWidthOfVC, y: proposedContentOffset.y)
        }
      }
    }
    return CGPoint(x: proposedContentOffset.x, y: 0)
  }
}
