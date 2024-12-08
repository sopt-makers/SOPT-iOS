//
//  LeftAlignedCollectionViewFlowLayout.swift
//  
//
//  Created by Jae Hyun Lee on 11/28/24.
//

import UIKit

/// CVC를 왼쪽 정렬시켜주는 커스텀 UICollectionViewFlowLayout입니다.
final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        /// attributes를 순회하면서 위치를 조정합니다.
        for layoutAttribute in attributes {
            /// 현재 셀의 y가 maxY보다 크거나 같으면, 줄바꿈이 된 것이므로 그 셀의 leftMargin을 초기화합니다.
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            /// leftMargin에 itemSpacing을 더합니다.
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
