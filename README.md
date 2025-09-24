# Ridya - 3D Ride Sharing App

A stunning 3D ride-sharing application built with Flutter, featuring immersive animations and modern UI design with an orange, black, and white theme.

## 🚀 Features Implemented

### ✅ Project Structure & Dependencies
- **Google Maps Flutter** - For interactive maps with 3D markers
- **Geolocator** - For precise location services
- **Flutter Animate** - For 3D animations and transitions
- **Card Swiper** - For 3D card stack effects
- **Flutter Staggered Animations** - For complex 3D animation sequences
- **Rive & Lottie** - For advanced 3D animations
- **Custom UberMove Font** - Using the provided font asset

### 🎨 Design System
- **Orange/Black/White Theme** - Consistent color palette throughout
- **3D UI Components** - Reusable components with depth and animations
- **Custom Gradients** - Smooth color transitions
- **Box Shadows** - Multiple shadow layers for 3D depth
- **Border Radius** - Consistent rounded corners

### 📱 Screens Implemented

#### 1. **Splash Screen** ✅
- 3D rotating logo animation using `assets/images/3dlogo.png`
- Gradient background with depth
- Floating particles animation
- Glowing effects and smooth transitions
- Auto-navigation to onboarding

#### 2. **Onboarding Screens** ✅
- 4 interactive onboarding cards
- 3D card stack swiper with perspective
- Parallax background effects
- Floating emoji elements with physics
- Smooth page transitions
- Skip functionality

#### 3. **Authentication Screen** ✅
- 3D flip card animation between Login/Signup
- Floating input fields with depth effects
- 3D button press animations
- Form validation
- Animated background particles

#### 4. **Home Screen** ✅
- Map placeholder (ready for Google Maps integration)
- 3D floating action buttons with hover effects
- Bottom sheet with 3D slide-up animation
- Quick action buttons
- Search functionality UI

### 🛠️ 3D UI Components Created

#### **Ridya3DButton**
- 3D press animations
- Glow effects
- Loading states
- Custom colors and icons

#### **Ridya3DCard** 
- Hover animations with perspective
- Glowing effects
- 3D transforms
- Custom shadow system

#### **Ridya3DFloatingActionButton**
- Continuous floating animation
- Rotation effects
- Pulse animations
- Multiple shadow layers

#### **Ridya3DTextField**
- Focus animations with elevation
- Glow effects on focus
- 3D perspective transforms
- Custom styling

### 🎭 3D Animation Techniques Used

1. **Matrix4 Transformations** - For perspective and 3D rotations
2. **Perspective Entry** - `setEntry(3, 2, 0.001)` for 3D depth
3. **Multiple Animation Controllers** - For complex coordinated animations
4. **Sin/Cos Functions** - For natural floating and oscillating movements
5. **Gradient Animations** - For color transitions and effects
6. **Shadow Layering** - Multiple BoxShadow for realistic depth

### 📁 Project Structure
```
lib/
├── constants/
│   └── app_theme.dart          # Complete theme system
├── screens/
│   ├── splash_screen.dart      # 3D splash with logo animation
│   ├── onboarding/
│   │   └── onboarding_screen.dart  # 4 onboarding cards with 3D effects
│   ├── auth/
│   │   └── auth_screen.dart    # 3D flip card authentication
│   └── home/
│       └── home_screen.dart    # Home with floating elements
├── widgets/
│   └── ridya_3d_components.dart    # Reusable 3D components
├── utils/                      # Utility functions (ready for expansion)
└── main.dart                   # App entry point
```

### 🎯 Next Development Phase (Week 2-4)

#### **Google Maps Integration**
- Replace map placeholder with Google Maps
- Add 3D markers with custom animations
- Implement real-time location tracking
- Add route visualization with 3D effects

#### **Advanced 3D Features**
- 3D car selection carousel
- Driver profile cards with flip animations
- Real-time ride tracking with 3D elements
- Payment screens with card flip effects

#### **State Management**
- Provider integration for app state
- User authentication logic
- Location permissions handling
- API integration for ride services

### 🔧 Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test
```

### 🎨 Color Palette

```dart
Primary Orange: #FF6B35
Dark Orange: #E55A2B
Light Orange: #FF8A65
Accent Orange: #FFA726

Primary Black: #1A1A1A
Dark Black: #000000
Light Black: #2E2E2E
Grey Black: #424242

Primary White: #FFFFFF
Off White: #F5F5F5
Light Grey: #E0E0E0
Dark Grey: #9E9E9E
```

### 📱 Assets Required
- ✅ `assets/images/3dlogo.png` - App logo
- ✅ `assets/fonts/UberMoveBold.otf` - Custom font

### 🚧 Known Issues
- Some deprecated method warnings (withOpacity) - cosmetic only
- Google Maps not yet integrated (placeholder shown)
- Location permissions not yet implemented

### 🎉 What Makes This App Special

1. **True 3D Effects** - Not just shadows, but actual Matrix4 transformations
2. **Coordinated Animations** - Multiple animation controllers working together
3. **Physics-Based Motion** - Using sin/cos for natural movements
4. **Depth Layering** - Multiple shadow systems for realistic depth
5. **Performance Optimized** - Efficient animation disposal and state management
6. **Modular Components** - Reusable 3D components for consistency

This implementation provides a solid foundation for a modern, visually stunning ride-sharing app with true 3D effects and smooth animations throughout the user experience.
