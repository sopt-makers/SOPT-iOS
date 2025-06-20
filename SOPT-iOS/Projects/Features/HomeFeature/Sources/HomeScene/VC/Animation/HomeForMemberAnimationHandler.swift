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
        guard playgroundNewsAnimationTask == nil else { return } // Task 중복 생성 방지
        
        playgroundNewsAnimationTask = Task {
            while !Task.isCancelled {
                await togglePlaygroundNewsItemUI()
            }
        }
    }
    
    func stopPlaygroundNewsAnimationLoop() {
        playgroundNewsAnimationTask?.cancel()
        playgroundNewsAnimationTask = nil
    }

    private func togglePlaygroundNewsItemUI() async {
        let playgroundNewsSectionIndex = HomeForMemberSectionLayoutKind.playgroundNews.rawValue
        let repeatCount = 3
        
        // 각 셀마다 반복
        for i in 0..<repeatCount {
            let indexPath = IndexPath(item: i, section: playgroundNewsSectionIndex)
            
            if let cell = self.collectionView.cellForItem(at: indexPath) as? DefaultPostCVC {
                await cell.setOutlinedAnimated()
            }
        }
    }
}

// MARK: - Recent Post Section Animaiton

extension HomeForMemberVC {
    /// Recent Post 섹션의 페이지 변환 섹션
    func startRecentPostAnimationLoop() {
        guard recentPostAnimationTask == nil else { return } // Task 중복 생성 방지
        
        let maxItemCount = 5 // 아이템 5개 고정
        let interval: UInt64 = 3_000_000_000
        
        recentPostAnimationTask = Task {
            var currentIndex = 0

            while !Task.isCancelled {
                await scrollRecentPostItem(at: currentIndex)
                currentIndex = (currentIndex + 1) % maxItemCount
                try? await Task.sleep(nanoseconds: interval)
            }
        }
    }
    
    func stopRecentPostAnimationLoop() {
        recentPostAnimationTask?.cancel()
        recentPostAnimationTask = nil
    }
    
    private func scrollRecentPostItem(at currentIndex: Int) async {
        let sectionIndex = HomeForMemberSectionLayoutKind.recentPost.rawValue
        let indexPath = IndexPath(item: currentIndex, section: sectionIndex)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
