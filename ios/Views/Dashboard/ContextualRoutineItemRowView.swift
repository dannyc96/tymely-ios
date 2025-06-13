import SwiftUI

struct ContextualRoutineItemRowView: View {
    let item: RoutineItem
    
    private var hasTimePassed: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        guard let itemTime = formatter.date(from: item.time) else { return false }
        
        let calendar = Calendar.current
        let now = Date()
        let todayItemTime = calendar.date(bySettingHour: calendar.component(.hour, from: itemTime),
                                        minute: calendar.component(.minute, from: itemTime),
                                        second: 0,
                                        of: now)
        
        if let todayItemTime = todayItemTime {
            return todayItemTime <= now
        }
        return false
    }
    
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
                .background(hasTimePassed ? Color.gray.opacity(0.6) : Color.accent)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                
                // Main Content
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: item.iconName)
                            .font(.callout)
                            .foregroundColor(hasTimePassed ? .gray : .accent)

                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(hasTimePassed ? .gray : .primaryText)
                        
                        if let tag = item.tag {
                            Text(tag)
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(hasTimePassed ? Color.gray.opacity(0.3) : item.tagColor.opacity(0.3))
                                .foregroundColor(hasTimePassed ? .gray : item.tagColor)
                                .cornerRadius(5)
                        }
                        
                        Spacer()
                    }
                    
                    // Details Section
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(item.details, id: \.self) { detail in
                            Text("• \(detail)")
                                .font(.subheadline)
                                .foregroundColor(hasTimePassed ? .gray.opacity(0.7) : .secondaryText)
                                .lineLimit(2)
                        }
                    }
                }
                .padding()
                .background(Color.componentBackground)
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            }
            .opacity(hasTimePassed ? 0.6 : 1.0)
            .shadow(color: hasTimePassed ? Color.gray.opacity(0.2) : Color.accent.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

struct ContextualRoutineItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            ContextualRoutineItemRowView(item: SampleData.routineItems[0])
            ContextualRoutineItemRowView(item: SampleData.routineItems[5])
            ContextualRoutineItemRowView(item: SampleData.routineItems[15])
        }
        .padding()
        .background(Color.appBackground)
        .preferredColorScheme(.dark)
    }
} 