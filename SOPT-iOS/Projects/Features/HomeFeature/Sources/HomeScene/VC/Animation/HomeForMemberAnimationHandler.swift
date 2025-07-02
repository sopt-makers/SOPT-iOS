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
        stopPlaygroundNewsAnimationLoop()
        
        // 타이머로 3초마다 한 번씩 반복 요청
        outlineAnimationTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.runOutlineAnimationStep()
        }
        
        RunLoop.main.add(outlineAnimationTimer!, forMode: .common)
    }

    func stopPlaygroundNewsAnimationLoop() {
        outlineAnimationTimer?.invalidate()
        outlineAnimationTimer = nil
        
        playgroundNewsAnimationTask?.cancel()
        playgroundNewsAnimationTask = nil
    }

    private func runOutlineAnimationStep() {
        // Task가 진행 중일 경우 return
        guard playgroundNewsAnimationTask == nil || playgroundNewsAnimationTask?.isCancelled == true else { return }
        
        let playgroundNewsSectionIndex = HomeForMemberSectionLayoutKind.playgroundNews.rawValue
        let indexPath = IndexPath(item: currentIndex, section: playgroundNewsSectionIndex)

        if let cell = self.collectionView.cellForItem(at: indexPath) as? DefaultPostCVC {
            playgroundNewsAnimationTask = Task { [weak self] in
                await cell.setOutlinedAnimated()
                self?.playgroundNewsAnimationTask = nil
            }
        }

        currentIndex = (currentIndex + 1) % 3
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
