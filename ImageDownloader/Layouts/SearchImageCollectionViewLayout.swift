//
//  SearchImageCollectionViewLayout.swift
//  ImageDownloader
//
//  Created by Astemir Shibzuhov on 18.07.2020.
//  Copyright © 2020 Astemir Shibzuhov. All rights reserved.
//

import UIKit

class SearchImageCollectionViewLayout: UICollectionViewLayout {
  
  fileprivate let sizeSmallCell: CGSize = CGSize(width: 204, height: 139)
  fileprivate let sizeLongCell: CGSize = CGSize(width: 123, height: 278)
  fileprivate var cache: [UICollectionViewLayoutAttributes] = []
  
  let numberOfColumns = 2
  
  // Content Size
  fileprivate var contentHeight: CGFloat = 0
  fileprivate var contetWidth: CGFloat {
    guard let collectionView = collectionView else {return 0}
    return collectionView.bounds.width
  }
  
  override var collectionViewContentSize: CGSize {
    
    return CGSize(width: contetWidth, height: contentHeight)
  }
  
  override func prepare() {
    super.prepare()
    contentHeight = 0
    cache.removeAll()
    guard cache.isEmpty else {return}
    let xOffset = calculateXOffsets()
    let yOffset = calculateYOffsets()
    calculatingCells(xOffset: xOffset, yOffset: yOffset)
    contentHeight += 20
  }
  
  func calculatingCells(xOffset: [CGFloat], yOffset: [CGFloat]) {
    guard  let collectionView = collectionView else {return}
    let widths = calculateWidth()
    var flag = false
    var index = 0
    var frame: CGRect
    
    for _ in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexFlag = index == 0 ? 0 : index
      if indexFlag % 3 == 0 {
        if !flag {
          for cell in 0..<3 {
            if cache.count == collectionView.numberOfItems(inSection: 0) {return}
            if cell == 0 {
              frame = CGRect(x: xOffset[0] + 8,
                             y: yOffset[index] + 8,
                             width: widths[0] - 4,
                             height: sizeLongCell.height - 4)
              cache.append(generateAttribute(frame: frame, for: IndexPath(item: index, section: 0)))
              index += 1
            } else {
              frame = CGRect(x: xOffset[1] + 8, y: yOffset[index] + 8, width: widths[1] - 12, height: sizeSmallCell.height - 4)
             cache.append(generateAttribute(frame: frame, for: IndexPath(item: index, section: 0)))
              index += 1
            }
          }
          flag = !flag
        } else {
          if cache.count == collectionView.numberOfItems(inSection: 0) {return}
          for cell in 0..<3 {
            if cache.count == collectionView.numberOfItems(inSection: 0) {return}
            if cell == 2 {
              frame = CGRect(x: xOffset[2] + 8, y: yOffset[index] + 8, width: widths[0] - 12, height: sizeLongCell.height - 4)
             cache.append(generateAttribute(frame: frame, for: IndexPath(item: index, section: 0)))
              index += 1
            } else {
              frame = CGRect(x: 0 + 8, y: yOffset[index] + 8, width: widths[2] - 4, height: sizeSmallCell.height - 4)
              cache.append(generateAttribute(frame: frame, for: IndexPath(item: index, section: 0)))
              index += 1
            }
          }
          flag = !flag
        }
      }
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visableLayoutAttributes = [UICollectionViewLayoutAttributes]()
    for attribute in cache {
      if attribute.frame.intersects(rect) {
        visableLayoutAttributes.append(attribute)
      }
    }
    return visableLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
  fileprivate func calculateXOffsets() -> [CGFloat] {
    var xOffset = [CGFloat]()
    let coef = 0.376
    
    let longCellXOffset = CGFloat(contetWidth * CGFloat(coef))
    
    xOffset.append(0)
    xOffset.append(longCellXOffset)
    xOffset.append(contetWidth - longCellXOffset)
    return xOffset
  }
  
  fileprivate func calculateYOffsets() -> [CGFloat] {
    guard let collectionView = collectionView else {return []}
    var yOffset = [CGFloat]()
    let yConstant: [CGFloat] = [0.0, 0.0, sizeSmallCell.height, sizeLongCell.height, sizeLongCell.height + sizeSmallCell.height, sizeLongCell.height]
    
    for index in 0..<collectionView.numberOfItems(inSection: 0) where index % 3 == 0 {
      contentHeight += sizeLongCell.height
    }
    
    for _ in 0..<collectionView.numberOfItems(inSection: 0) {
      if yOffset.count >= collectionView.numberOfItems(inSection: 0) {return yOffset}
      for index in 0..<yConstant.count {
        if yOffset.count >= collectionView.numberOfItems(inSection: 0) {return yOffset}
        if yOffset.count < yConstant.count {
          yOffset.append(yConstant[index])
          continue
        }
        let index = yOffset.count - 6
        
        if yOffset[index] == 0 {
          yOffset.append(sizeLongCell.height * 2)
          continue
        }
        let multipl = sizeLongCell.height + sizeLongCell.height
        
        yOffset.append(yOffset[index] + multipl)
      }
    }
    print(yOffset.count)
    return yOffset
  }
  
  fileprivate func calculateWidth() -> [CGFloat] {
    var widths = [CGFloat]()
    let coef: CGFloat = 0.376
    
    let longCellWidth = contetWidth * coef
    let smallCellWidth = contetWidth - longCellWidth
    print(smallCellWidth)
    widths.append(longCellWidth)
    widths.append(contetWidth - longCellWidth)
    widths.append(smallCellWidth)
    
    return widths
  }
  
  fileprivate func generateAttribute(frame: CGRect, for indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
    let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    attribute.frame = frame
    return attribute
  }
}
