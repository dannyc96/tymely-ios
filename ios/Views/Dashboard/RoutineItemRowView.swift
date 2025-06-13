import SwiftUI

struct RoutineItemRowView: View {
    let item: RoutineItem
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                // Header with Time
                HStack {
                    Spacer()
                    Text(item.time)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 12)
                .background(Color.accent)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                
                // Main Content
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: item.iconName)
                            .font(.callout)
                            .foregroundColor(.accent)

                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if let tag = item.tag {
                            Text(tag)
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(item.tagColor.opacity(0.3))
                                .foregroundColor(item.tagColor)
                                .cornerRadius(5)
                        }
                        
                        Spacer()
                    }
                    
                    // Details Section
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(item.details, id: \.self) { detail in
                            Text("• \(detail)")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                                .lineLimit(2)
                        }
                    }
                }
                .padding()
                .background(Color.componentBackground)
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            }
            .shadow(color: Color.accent.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

// Extension to support corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct RoutineItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            RoutineItemRowView(item: SampleData.routineItems[0])
            RoutineItemRowView(item: SampleData.routineItems[5])
            RoutineItemRowView(item: SampleData.routineItems[15])
        }
        .padding()
        .background(Color.appBackground)
        .preferredColorScheme(.dark)
    }
} 