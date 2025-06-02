public enum RankingViewType {
    case all
    case currentGeneration(info: UsersActiveGenerationStatusViewResponse)
    case partRanking
    case individualRankingInPart(part: Part)
}