import Foundation
import SwiftUI

struct RoutineItem: Identifiable {
    let id = UUID()
    let time: String
    let iconName: String
    let title: String
    let tag: String?
    let tagColor: Color
    let details: [String]
    var isCompleted: Bool
    var isCurrent: Bool = false
} 