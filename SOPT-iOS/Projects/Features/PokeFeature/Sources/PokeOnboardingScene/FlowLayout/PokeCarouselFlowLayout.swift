//
//  PokeCarouselFlowLayout.swift
//  PokeFeature
//
//  Created by Ian on 6/3/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

public final class PokeCarouselFlowLayout: UICollectionViewFlowLayout {
  private enum Metric {
    static let contentleadingTrailing = 20.f
    static let collectionViewHeight = 586.f
    
    static let lineSpacing = 20.f
  }
  
  public override func prepare() {
    super.prepare()
    
    guard let collectionView else { return }
    
    let itemWidth = collectionView.bounds.width - Metric.contentleadingTrailing * 2
    let itemHeight = Metric.collectionViewHeight
    self.itemSize = CGSize(width: itemWidth, height: itemHeight)
    
    self.scrollDirection = .horizontal
    self.minimumLineSpacing = Metric.lineSpacing
    self.sectionInset = UIEdgeInsets(
      top: .zero,
      left: Metric.contentleadingTrailing,
      bottom: .zero,
      right: Metric.contentleadingTrailing
    )
  }
}

extension PokeCarouselFlowLayout {
  public override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint,
    withScrollingVelocity velocity: CGPoint
  ) -> CGPoint {
    guard let collectionView else { return proposedContentOffset }
    
    let pageWidth = self.itemSize.width + self.minimumLineSpacing
    let approximatePage = collectionView.contentOffset.x / pageWidth
    let currentPage = velocity.x == 0
    ? round(approximatePage) : (velocity.x < 0 ? floor(approximatePage) : ceil(approximatePage))
    
    let xOffset = currentPage * pageWidth
    return CGPoint(x: xOffset, y: 0)
  }
}
         
