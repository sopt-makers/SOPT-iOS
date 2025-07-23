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
        isOutlineAnimationStopped = false
        currentIndex = 0
        runOutlineAnimationStep()
    }
    
    func stopPlaygroundNewsAnimationLoop() {
        // 현재 보여지는 cell들에 대해 애니메이션을 취소합니다.
        isOutlineAnimationStopped = true
        for cell in collectionView.visibleCells {
            (cell as? DefaultPostCVC)?.cancelOutlineAnimation()
        }
    }

    private func runOutlineAnimationStep() {
        // 실행이 종료되었다면, 재귀에서 빠져 나옵니다.
        guard !isOutlineAnimationStopped else { return }
        let playgroundNewsSectionIndex = HomeForMemberSectionLayoutKind.playgroundNews.rawValue
        let indexPath = IndexPath(item: currentIndex, section: playgroundNewsSectionIndex)
        
        // 셀이 화면에 보이는 경우만 애니메이션을 실행합니다.
        if collectionView.isVisible(at: indexPath),
           let cell = self.collectionView.cellForItem(at: indexPath) as? DefaultPostCVC {
            cell.onAnimationCompleted = { [weak self] in
                guard let self else { return }
                self.currentIndex = (self.currentIndex + 1) % 3
                self.runOutlineAnimationStep()
            }
            cell.setOutlinedAnimated()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                self.runOutlineAnimationStep()
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
