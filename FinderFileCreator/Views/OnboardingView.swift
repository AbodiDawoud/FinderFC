//
//  OnboardingView.swift
//  FinderFileCreator
    

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(TemplateLibrary.self) private var library
    @State private var selectedRole: UserRole?

    var body: some View {
        ZStack {
            // Subtle ambient color accents
            Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(x: -200, y: -150)
            
            Circle()
                .fill(Color.purple.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 200, y: 150)

            VStack(spacing: 28) {
                Image(.finderIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 12) {
                    Text("Welcome to Finder File Creator")
                        .font(.title2.bold())
                        .foregroundStyle(Color.primary.gradient)
                    
                    Text("Selecting your role helps us tailor the experience to your needs. Skip if you prefer to create the templates manually.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 400)
                }
                
                VStack(spacing: 11) {
                    HStack(spacing: 13) {
                        RoleCard(role: .apple, isSelected: UserRole.apple == selectedRole)
                            .onTapGesture { selectRole(.apple) }
                        
                        RoleCard(role: .web, isSelected: UserRole.web == selectedRole)
                            .onTapGesture { selectRole(.web) }
                    }
                    
                    HStack(spacing: 13) {
                        RoleCard(role: .android, isSelected: UserRole.android == selectedRole)
                            .onTapGesture { selectRole(.android) }
                        
                        RoleCard(role: .general, isSelected: UserRole.general == selectedRole)
                            .onTapGesture { selectRole(.general) }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 30)
                
                HStack {
                    Button(action: continueAction) {
                        Text("Skip")
                            .font(.callout)
                            .frame(width: 120)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .stroke(Color.white.opacity(0.06), lineWidth: 0.95)
                                    .fill(.gray.quinary.opacity(0.6))
                            )
                    }
                    
                    Button(action: continueAction) {
                        Text("Continue")
                            .font(.callout.weight(.medium))
                            .frame(width: 200)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .stroke(Color.white.opacity(0.06), lineWidth: 0.95)
                                    .fill(.gray.quinary.opacity(0.6))
                            )
                    }
                    .disabled(selectedRole == nil)
                }
                .buttonStyle(.plain)
                .pointerStyle(.link)
            }
            .padding(50)
        }
    }
    
    private func selectRole(_ role: UserRole) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedRole = role
        }
    }
    
    func continueAction() {
        if let role = selectedRole {
            library.applyRoleTemplates(for: role)
            withAnimation(.easeInOut(duration: 0.4)) {
                hasCompletedOnboarding = true
            }
        }
    }
    
    func skipAction() {
        withAnimation(.easeInOut(duration: 0.4)) {
            hasCompletedOnboarding = true
        }
    }
}


private struct RoleCard: View {
    let role: UserRole
    let isSelected: Bool
    @State private var isHovering = false
    
    var body: some View {
        Text(role.rawValue)
            .font(
                .system(size: 13.5, weight: isSelected ? .semibold : .regular)
            )
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: 38)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.secondary.opacity(isSelected ? 0.3 : (isHovering ? 0.15 : 0.05)), lineWidth: 0.8)
                    .fill(isSelected ? Color.gray.opacity(0.1) : (isHovering ? Color.gray.opacity(0.08) : Color.black.opacity(0.2)))
            )
            .onHover { hovering in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isHovering = hovering
                }
            }
    }
}


enum UserRole: String {
    case apple = "Apple Developer"
    case web = "Web Developer"
    case android = "Android Developer"
    case general = "General / Designer"
    
    var id: String { rawValue }
}
