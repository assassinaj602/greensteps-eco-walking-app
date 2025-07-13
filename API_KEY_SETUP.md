# 🗝️ Google Maps API Key Setup Guide

## 📋 Prerequisites
Before running the GreenSteps app, you need to set up Google Maps API keys.

## 🚀 Quick Setup Steps

### 1. Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the following APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS** 
   - **Maps JavaScript API**
   - **Directions API**
   - **Geocoding API**

4. Go to **APIs & Services** → **Credentials**
5. Click **Create Credentials** → **API Key**
6. Copy your API key

### 2. Configure the API Key

#### For Development:
1. Open `lib/config/app_config.dart`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:

```dart
static const String googleMapsApiKey = 'AIzaSyD_your_actual_api_key_here';
```

#### For Android:
1. Open `android/app/src/main/AndroidManifest.xml`
2. Replace the placeholder in this line:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyD_your_actual_api_key_here" />
```

#### For Web:
1. Open `web/index.html`
2. Update the Google Sign-In client ID (already configured)

### 3. Restrict Your API Key (Recommended)

1. In Google Cloud Console, click on your API key
2. Under **Application restrictions**:
   - For Android: Add your package name and SHA-1
   - For Web: Add your domain
3. Under **API restrictions**: Select only the APIs you enabled

### 4. Test Your Setup

Run the app and test:
- ✅ Map loads properly
- ✅ Current location works
- ✅ Route finding works
- ✅ Authentication works

## 🔒 Security Best Practices

1. **Never commit API keys to version control**
2. **Use environment variables for production**
3. **Restrict API keys by platform and API**
4. **Monitor API usage in Google Cloud Console**

## 🐛 Troubleshooting

### Map not loading?
- Check if Maps SDK is enabled
- Verify API key is correct
- Check browser console for errors

### Routes not working?
- Ensure Directions API is enabled
- Check network connectivity
- Verify API key restrictions

### Authentication issues?
- Check Firebase configuration
- Verify Google Sign-In setup
- Check SHA-1 fingerprints

## 📞 Need Help?

If you encounter issues:
1. Check the [Google Maps Platform documentation](https://developers.google.com/maps/documentation)
2. Verify your Firebase project settings
3. Check the browser/Android logs for specific errors

---

**🌱 Ready to go green with GreenSteps!** 🚀
