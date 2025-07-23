//
//  HomeForMemberAnimationHandler.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 6/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

// MARK: - PlaygroundNews Section Animation

extension HomeForMemberVC {
    /// Playground News 섹션의 디졸브 전환 애니메이션
    func startPlaygroundNewsAnimationLoop() {
        currentIndex = 0
        runOutlineAnimationStep()
    }

    private func runOutlineAnimationStep() {
        let playgroundNewsSectionIndex = HomeForMemberSectionLayoutKind.playgroundNews.rawValue
        let indexPath = IndexPath(item: currentIndex, section: playgroundNewsSectionIndex)

        if let cell = self.collectionView.cellForItem(at: indexPath) as? DefaultPostCVC {
            cell.onAnimationCompleted = { [weak self] in
                guard let self = self else { return }
                self.currentIndex = (self.currentIndex + 1) % 3
                self.runOutlineAnimationStep()
            }
            cell.setOutlinedAnimated()
        } else {
            self.currentIndex = (self.currentIndex + 1) % 3
            self.runOutlineAnimationStep()
        }
    }
}

// MARK: - Recent Post Section Animaiton

extension HomeForMemberVC {
    /// Recent Post 섹션의 페이지 변환 섹션
    func startRecentPostAnimationLoop() {
        guard recentPostAnimationTask == nil else { return } // Task 중복 생성 방지
        
        let maxItemCount = 5 // 아이템 5개 고정
        let interval = 3.0
        
        recentPostAnimationTask = Task { [weak self] in
            guard let self else { return }
            var currentIndex = 0

            while !Task.isCancelled {
                self.scrollRecentPostItem(at: currentIndex)
                currentIndex = (currentIndex + 1) % maxItemCount
                try? await Task.sleep(for: .seconds(interval))
            }
        }
    }
    
    func stopRecentPostAnimationLoop() {
        recentPostAnimationTask?.cancel()
        recentPostAnimationTask = nil
    }
    
    private func scrollRecentPostItem(at currentIndex: Int) {
        let sectionIndex = HomeForMemberSectionLayoutKind.recentPost.rawValue
        let indexPath = IndexPath(item: currentIndex, section: sectionIndex)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
