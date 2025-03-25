//
//  WKImageDownloadHandler.swift
//  BaseFeatureDependency
//
//  Created by 장석우 on 1/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import WebKit
import Photos
import BaseFeatureDependency

struct WKImageDownloadHandler: WKDownloadExecutable {
    
    static let key = UTType.image
    
    func execute(
        _ download: WKDownload,
        _ response: URLResponse,
        _ suggestedFilename: String,
        _ webVC: SOPTWebViewControllable?
    ) async -> URL? {
        
        guard let webVC else { return nil }
        
        guard await requestAuthorization() else {
            await presentGoToSettingAlert(from: webVC)
            return nil
        }
        
        guard let urlString = response.url?.absoluteString,
              let range = urlString.range(of: "base64,"),
              let encodedData = Data(base64Encoded: String(urlString[range.upperBound...])),
              let image = UIImage(data: encodedData),
              let pngData = image.pngData()
        else {
            return nil
        }
        
        guard let fileURL = try? saveToTemporaryDirectory(pngData, suggestedFilename)
        else { return nil }
        
        await presentActivityVC(fileURL, from: webVC)
        
        return nil
    }
    
    private func requestAuthorization() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        return status == .authorized || status == .limited
    }
    
    private func saveToTemporaryDirectory(_ data: Data, _ suggestedFilename: String) throws -> URL {
        let temporaryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(suggestedFilename)
            .appendingPathExtension("png")
        
        try data.write(to: temporaryURL, options: [])
        return temporaryURL
    }
    
    @MainActor
    private func presentActivityVC(_ fileURL: URL, from webVC: SOPTWebViewControllable) {
        
        let activityVC = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )
        
        activityVC.completionWithItemsHandler = {
            activityType, completed, returnedItems, activityError in
            if activityType == .saveToCameraRoll {
                guard activityError == nil else {
                    ToastUtils.showMDSToast(type: .error, text: "이미지 저장에 실패했습니다.")
                    return
                }
                
                if completed {
                    ToastUtils.showMDSToast(type: .success, text: "이미지가 저장되었습니다.")
                }
            }
        }
        // 공유 화면 표시
        webVC.vc.present(activityVC, animated: true, completion: nil)
        
    }
    
    @MainActor
    private func presentGoToSettingAlert(from webVC: SOPTWebViewControllable) {
        webVC.vc.makeAlert(
            title: "갤러리 접근 권한 설정",
            message: "이미지를 저장하시려면 갤러리 접근 권한이 필요합니다.",
            actions: .init(title: "나중에", style: .destructive),
            .init(title: "설정", style: .default, handler: { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(url) else { return }
                
                UIApplication.shared.open(url, completionHandler: nil)
            })
        )
    }
}



