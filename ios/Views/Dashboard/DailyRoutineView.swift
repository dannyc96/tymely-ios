import SwiftUI

struct DailyRoutineView: View {
    @State private var allItems = SampleData.routineItems
    @Binding var scrollToCurrentAction: (() -> Void)?
    
    private var currentTime: Date {
        Date()
    }
    
    private var currentItemIndex: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let calendar = Calendar.current
        let now = currentTime
        
        print("Current time: \(formatter.string(from: now))")
        
        // Find the current or next upcoming item
        for (index, item) in allItems.enumerated() {
            if let itemTime = formatter.date(from: item.time) {
                // Create today's version of this time
                let todayItemTime = calendar.date(bySettingHour: calendar.component(.hour, from: itemTime),
                                                minute: calendar.component(.minute, from: itemTime),
                                                second: 0,
                                                of: now) ?? itemTime
                
                print("Item \(index): \(item.time) -> \(formatter.string(from: todayItemTime))")
                
                // If this item's time is in the future or current, this is our target
                if todayItemTime >= now {
                    print("Found current/next item at index \(index): \(item.time)")
                    return index
                }
            }
        }
        
        // If all items are in the past, return the last item
        print("All items are in the past, returning last item")
        return max(0, allItems.count - 1)
    }
    
    private var processedItems: [RoutineItem] {
        let currentIndex = currentItemIndex
        
        return allItems.enumerated().map { index, item in
            var updatedItem = item
            updatedItem.isCurrent = (index == currentIndex)
            return updatedItem
        }
    }
    
    var body: some View {
        // Scrollable Routine Items
        ScrollViewReader { proxy in
            LazyVStack(spacing: 15) {
                ForEach(processedItems) { item in
                    ContextualRoutineItemRowView(item: item)
                        .id(item.id)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 100) // Extra bottom padding for tab bar
            .onAppear {
                // Create the scroll action closure for parent to use
                scrollToCurrentAction = {
                    let targetIndex = currentItemIndex
                    print("Scrolling to item at index: \(targetIndex)")
                    
                    if targetIndex < processedItems.count {
                        let currentItem = processedItems[targetIndex]
                        print("Scrolling to item: \(currentItem.time) - \(currentItem.title)")
                        
                        withAnimation(.easeInOut(duration: 0.8)) {
                            proxy.scrollTo(currentItem.id, anchor: .center)
                        }
                    } else {
                        print("Target index \(targetIndex) is out of bounds")
                    }
                }
                
                // Debug: Print current item info
                print("=== DailyRoutineView onAppear ===")
                print("Current item index: \(currentItemIndex)")
                if currentItemIndex < processedItems.count {
                    print("Current item: \(processedItems[currentItemIndex].time) - \(processedItems[currentItemIndex].title)")
                }
                print("Total items: \(processedItems.count)")
                
                // Auto-scroll to current item when view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Auto-scrolling to current item...")
                    scrollToCurrentAction?()
                }
            }
        }
    }
}

// Extension to support binding with default value
extension DailyRoutineView {
    init() {
        self.init(scrollToCurrentAction: .constant(nil))
    }
}

struct DailyRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        DailyRoutineView()
            .background(Color.appBackground)
            .preferredColorScheme(.dark)
    }
} 