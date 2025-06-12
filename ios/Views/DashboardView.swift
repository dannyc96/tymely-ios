import SwiftUI

struct DashboardView: View {
    @Binding var isMenuOpen: Bool
    @State private var scrollToCurrentAction: (() -> Void)?
    @State private var showFloatingButton = true // For testing
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Pinned Navigation Bar
                NavigationBarView(isMenuOpen: $isMenuOpen)
                
                // Pinned Daily Progress Section
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Daily Progress")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        // Large, prominent percentage
                        Text("\(calculateProgress())%")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.clear)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.yellow,
                                        Color.orange,
                                        Color.pink,
                                        Color.blue,
                                        Color.purple
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Text("\(calculateProgress())%")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                            )
                    }
                    .padding(.horizontal)
                    
                    // Stunning Progress Section
                    VStack(spacing: 10) {
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 24)
                            
                            // Gradient progress fill
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.yellow,
                                            Color.orange,
                                            Color.pink,
                                            Color.blue,
                                            Color.purple
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: UIScreen.main.bounds.width * 0.85 * (Double(calculateProgress()) / 100.0), height: 24)
                                .animation(.easeInOut(duration: 1.0), value: calculateProgress())
                        }
                        
                        // Progress details
                        HStack {
                            Text("\(SampleData.routineItems.filter { $0.isCompleted }.count) of \(SampleData.routineItems.count) completed")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                            
                            Spacer()
                            
                            Text("Today")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                        }
                    }
                    .padding()
                    .background(Color.componentBackground)
                    .cornerRadius(20)
                    .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                }
                .background(Color.appBackground)
                .shadow(color: Color.accent.opacity(0.2), radius: 5, x: 0, y: 2)
                
                // Scrollable Content
                ScrollView {
                    VStack(alignment: .center, spacing: 25) {
                        DailyRoutineView(scrollToCurrentAction: $scrollToCurrentAction)
                    }
                    .padding(.vertical)
                }
            }
            .background(Color.appBackground.edgesIgnoringSafeArea(.all))
            
            // Floating "Now" Button - Truly floating above everything
            if showFloatingButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Floating Now button tapped!")
                            scrollToCurrentAction?()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Now")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, Color.red]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .shadow(color: Color.orange.opacity(0.6), radius: 15, x: 0, y: 8)
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 120) // Above tab bar
                .transition(.scale.combined(with: .opacity))
                .zIndex(1000) // Ensure it's on top of everything
            }
        }
    }
    
    private func calculateProgress() -> Int {
        let completedCount = SampleData.routineItems.filter { $0.isCompleted }.count
        guard !SampleData.routineItems.isEmpty else { return 0 }
        return Int((Double(completedCount) / Double(SampleData.routineItems.count)) * 100)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(isMenuOpen: .constant(false))
            .preferredColorScheme(.dark)
    }
} 