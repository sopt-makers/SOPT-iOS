//
//  OfficialNotificationDetailView.swift
//  NotificationFeature
//
//  Created by 이나연 on 11/18/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import SwiftUI
import UIKit

import MDS
import DSKit

struct OfficialNotificationDetailView: View {
    @StateObject var viewModel: OfficialNotificationDetailViewModel

    // TODO: mds font 적용
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                textSection
                ImagesListView(
                    imageUrls: viewModel.imageUrls,
                    onZoomTap: { viewModel.onZoomInButtonTap?($0) }
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(SemanticColor.Bg.Neutral.ghost), in: RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(Color(SemanticColor.Bg.Layer.basement))
    }
}

extension OfficialNotificationDetailView {
    private var textSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            content
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.notificationTitle)
                    .foregroundColor(Color(uiColor: SemanticColor.Fg.Neutral.bold))
                    .font(.system(size: 18))

                Text(viewModel.createdDate)
                    .foregroundColor(Color(uiColor: SemanticColor.Fg.Neutral.subtle))
                    .font(.system(size: 12))
            }
            divider
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(uiColor: SemanticColor.Stroke.Neutral.default))
            .frame(height: 1)
    }

    private var content: some View {
        Text(viewModel.notificationText)
            .foregroundColor(Color(uiColor: SemanticColor.Fg.Neutral.bold))
            .font(.system(size: 16))
    }
}

struct ImagesListView: View {
    let imageUrls: [String]
    let onZoomTap: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            ForEach(imageUrls, id: \.self) { url in
                notificationImage(url: url)
            }
        }
    }

    private func notificationImage(url: String) -> some View {
        Rectangle()
            .fill(Color(SemanticColor.Bg.Neutral.subtle))
            .aspectRatio(3 / 2, contentMode: .fill)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottomTrailing) {
                Button { onZoomTap?(url) } label: { zoomIcon }
                    .padding([.trailing, .bottom], 16)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var zoomIcon: some View {
        ZStack {
            Circle()
                .fill(Color(uiColor: SemanticColor.Bg.Layer.basement).opacity(0.3))

            Image(uiImage: MDSIcon.zoomInOutlined.image)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color(uiColor: SemanticColor.Fg.Neutral.bold))
                .frame(width: 20, height: 20)
        }
        .frame(width: 32, height: 32)
    }
}
