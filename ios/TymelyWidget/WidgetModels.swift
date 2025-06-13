import Foundation
import SwiftUI

// Widget-specific models to avoid conflicts with main app
struct WidgetRoutineItem: Identifiable {
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

struct WidgetSampleData {
    static let routineItems: [WidgetRoutineItem] = [
        WidgetRoutineItem(time: "6:30 AM", iconName: "sparkles", title: "Wake Up & Hydrate", tag: "DAY START", tagColor: .pink, details: ["Gradual sunrise started at 6:25 AM (peaks at 6:35 AM)", "Hydrate with water + electrolytes immediately", "Wash face with cool water to boost alertness", "Listen to classical basic gutiar/piano, get dressed", "5-10 min morning sunlight exposure outside", "Sets circadian rhythm for muscle recovery"], isCompleted: true),
        WidgetRoutineItem(time: "6:50 AM", iconName: "figure.walk", title: "Morning Walk", tag: nil, tagColor: .clear, details: ["10-15 minute light walk outside", "Fresh air and gentle movement", "Boosts circulation and mental clarity", "Optional: listen to podcast or music"], isCompleted: true),
        WidgetRoutineItem(time: "7:10 AM", iconName: "pills", title: "ADHD Meds + Big Breakfast", tag: "MEAL", tagColor: .blue, details: ["ADHD medication with high-calorie breakfast", "Target: 600-700 calories", "Examples: 4 eggs + sourdough + nut butter + fruit", "Add olive oil drizzle for extra calories", "Perfect timing before 7:45 AM meetings"], isCompleted: true),
        WidgetRoutineItem(time: "7:45 AM", iconName: "briefcase", title: "First Meeting", tag: nil, tagColor: .clear, details: ["Ready for cognitive performance window", "Peak cognitive performance window", "Stay hydrated during calls", "ADHD medication at optimal effect"], isCompleted: true),
        WidgetRoutineItem(time: "9:00 AM", iconName: "cup.and.saucer", title: "Snack #1", tag: "SNACK", tagColor: .green, details: ["High-calorie snack: 400-500 calories", "Examples: Greek yogurt + granola + walnuts", "Helps meet calorie goals without feeling stuffed"], isCompleted: true),
        WidgetRoutineItem(time: "12:00 PM", iconName: "sun.max", title: "Lunch", tag: "MEAL", tagColor: .blue, details: ["Target: 700-900 calories", "Examples: Grilled chicken/steak + rice + avocado", "Add roasted vegetables for nutrients", "Focus on protein + complex carbs"], isCompleted: false, isCurrent: true),
        WidgetRoutineItem(time: "1:45 PM", iconName: "bolt", title: "Pre-Workout (Naked Energy)", tag: "SNACK", tagColor: .green, details: ["Half scoop Naked Energy (100mg caffeine)", "Light carb: banana or rice cake with PB"], isCompleted: false),
        WidgetRoutineItem(time: "2:00 PM", iconName: "figure.strengthtraining.traditional", title: "Workout", tag: nil, tagColor: .clear, details: ["Strength training for muscle growth", "Progressive overload to improve", "Stay hydrated throughout", "45-60 minute sessions"], isCompleted: false),
        WidgetRoutineItem(time: "3:00 PM", iconName: "flame", title: "Post-Workout Muscle Fuel", tag: "MEAL", tagColor: .blue, details: ["Critical for muscle growth: 700-800 calories", "Protein shake + oats + almond butter OR", "Chicken + white rice + sweet potatoes", "Spike insulin for muscle growth"], isCompleted: false),
        WidgetRoutineItem(time: "5:30 PM", iconName: "carrot", title: "Snack #2", tag: "SNACK", tagColor: .green, details: ["300-400 calories if dinner is later", "Examples: Hard-boiled eggs, hummus + pita", "Turkey roll-ups with cheese", "Bridge to dinner without overeating"], isCompleted: false),
        WidgetRoutineItem(time: "6:30 PM", iconName: "moon", title: "Dinner", tag: "MEAL", tagColor: .blue, details: ["Target: 700-800 calories", "Ground beef/chicken thighs + pasta/couscous", "Add cheese or olive oil for calorie density", "Include cooked greens for nutrients"], isCompleted: false),
        WidgetRoutineItem(time: "7:00 PM", iconName: "figure.walk.motion", title: "Post-Dinner Walk", tag: nil, tagColor: .clear, details: ["10-15 minute light walk outside", "Aids digestion and helps with sleep onset", "Optional: listen to calming music or podcast"], isCompleted: false),
        WidgetRoutineItem(time: "8:30 PM", iconName: "bed.double", title: "Evening Mini-Meal", tag: "MEAL", tagColor: .blue, details: ["Light but nutrient-dense: 300-400 calories", "Cottage cheese + almond butter + berries OR", "Casein protein shake", "Supports overnight muscle repair"], isCompleted: false),
        WidgetRoutineItem(time: "9:15 PM", iconName: "wind", title: "Wind-down & Sleep Prep", tag: nil, tagColor: .clear, details: ["Dim lights automatically (warm relaxing light)", "Hot shower (5-10 min) - raises core temp-drop for sleepiness", "Light stretching, reading, or calming activities", "If not sleepy, take magnesium glycinate OR apigenin + L-theanine", "Helps transitioning to sleep mode", "Red lighting activates automatically", "Cool bedroom environment (65-68°F)", "Final prep for muscle recovery sleep"], isCompleted: false),
        WidgetRoutineItem(time: "10:15 PM", iconName: "powersleep", title: "Sleep (Lights Out)", tag: "DAY END", tagColor: .purple, details: ["All lights off automatically, 6 hours until 6:15 AM", "Focus on breathing or progressive relaxation", "Pitch-black, silent room", "Muscle growth happens during deep sleep"], isCompleted: false)
    ]
} 