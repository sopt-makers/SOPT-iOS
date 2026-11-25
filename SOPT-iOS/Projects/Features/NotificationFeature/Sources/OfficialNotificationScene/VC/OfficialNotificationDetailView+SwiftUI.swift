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
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    textSection
                    ImagesListView(
                        imageUrls: viewModel.imageUrls,
                        onZoomTap: { viewModel.onZoomInButtonTap?($0) }
                    )
                    openLinkButton
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(SemanticColor.Bg.Neutral.ghost), in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            FooterView()
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
    
    private var openLinkButton: some View {
        Button(action: { }) {
            HStack(spacing: 4) {
                Image(uiImage: MDSIcon.arrowUpRightOutlined.image)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("https://www.sopt.org")
                    .tint(Color(uiColor: SemanticColor.Fg.Neutral.bold))
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color(uiColor: SemanticColor.Bg.Neutral.subtle), in: RoundedRectangle(cornerRadius: 8))
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

struct FooterView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                checkedMemberCountText
                Spacer()
                checkMemberButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            MDSActionButtonView(
                title: "공지 확인하기",
                variant: .primary,
                size: .large
            ) { }
                .padding(.horizontal, 20)
            
            Text("버튼을 누르면 확인한 멤버로 표시됩니다.")
                .font(.system(size: 14))
                .foregroundStyle(Color(uiColor: SemanticColor.Fg.Neutral.subtle))
                .frame(height: 22)
                .padding(.top, 8)
               
        }
        .frame(maxWidth: .infinity)
        .frame(height: 136)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(uiColor: SemanticColor.Stroke.Neutral.subtle))
                .frame(height: 1)
        }
    }
    
    private var checkedMemberCountText: some View {
        let count = Text("4명")
            .foregroundColor(Color(uiColor: DSKitAsset.Colors.blue300.color))

        return Text("\(count)이 확인했어요")
            .foregroundColor(Color(uiColor: SemanticColor.Fg.Neutral.bold))
            .font(.system(size: 14))
    }
    
    private var checkMemberButton: some View {
        Button(action: {}) {
            HStack(spacing: 2) {
                Text("확인한 멤버 보기")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(uiColor: DSKitAsset.Colors.gray200.color))
                
                Image(uiImage: MDSIcon.chevronRightOutlined.image)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color(uiColor: DSKitAsset.Colors.gray200.color))
            }
        }
    }
}
