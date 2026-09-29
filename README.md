# ثرواتنا من أرضنا (Our Resources) - Flutter App

مشروع متكامل ومُعاد بناؤه بنسبة 100% باستخدام **Flutter & Dart** كنسخة مطابقة تماماً (1:1 Migration) لتطبيق الأندرويد الأصلي `map`، مع دعمه لجميع المنصات:
- **Android**
- **iOS**
- **Web**
- **Windows Desktop**

---

## 🌟 مميزات التطبيق والأقسام المطابقة

1. **شاشة البداية (Start Screen)**:
   - خلفية رخامية برديّة مطابقة (`wallpaper2.jpg`).
   - شعار رؤية المملكة 2030 وشعار جامعة الملك سعود.
   - زر التفاعل واللمس المركزي مع تأثير النبض (`click.png`).
   - التوجيه الأفقي التلقائي (Landscape Mode) والاتجاه الكامل من اليمين لليسار (RTL).

2. **القائمة الرئيسية (Fullscreen Menu)**:
   - خلفية مطابقة (`wallpaper5.jpg`) وشريط ترويسة يحمل عنوان "ثرواتنا من أرضنا".
   - زر "نبذة تعريفية": يفتح نافذة منبثقة تفاعلية توضح أهداف المشروع، والفريق العلمي والتقني، مع توقيع المشرف على المشروع أ. د. عبد الله بن محمد العمري (`sign.png`).
   - شبكة (2×3) متناسقة لأقسام التطبيق الستة:
     1. **جيولوجية المملكة**
     2. **الصخور والمعادن الإقتصادية**
     3. **مصادر المياه**
     4. **البترول والغاز**
     5. **السياحة والآثار**
     6. **قاعدة البيانات الزلزالية**
   - زر "المصادر والمراجع": يفتح نافذة المراجع العلمية العربية والدولية.

3. **جيولوجية المملكة (General Geology)**:
   - خريطة تفاعلية فضائية عالية الدقة (Satellite Imagery).
   - قائمة جانبية برديّة مطابقة للأصل (`wallpaper.png`).
   - استعراض النطق الجيولوجية الأربعة:
     - **الدرع العربي**: مع نافذة الشرح والصورة الجيولوجية (`arabian_shield.png`).
     - **الرصيف العربي**: مع نافذة الشرح والصورة الجيولوجية (`arabian_platform.png`).
     - **الحرات البركانية**: مع نافذة الشرح وصورة الحرات (`harat.jpg`) وخريطة تفاعلية لفوهات وبراكين الحرات (حرة رهط، خيبر، كشب، عويرض، الحرة، الشاقة، إلخ).
     - **السهول الساحلية**: مع نافذة الشرح وصورة السهول (`swahel.png`).

4. **الصخور والمعادن الإقتصادية (Economic Minerals)**:
   - قراءة وتحليل بيانات ملف الإكسل الحقيقي `materials.xlsx` بدقة وسرعة فائقة باستخدام حزمة Dart الأصلية.
   - قائمة تشمل 41 معدناً وصخراً اقتصادياً (الذهب، الفضة، النحاس، الحديد، البوكسيت، الفوسفات، الزنك، الرصاص، النيكل، الكروم، المغنيزايت، الفلدسبار، الجبس، الحجر الجيري، الرخام، الجرانيت، البازلت، رمال السيليكا، الكوارتزايت، الكاولين، الطين، التلك، البارايت، اليورانيوم، الزيولايت، الجرافيت، الدولومايت، الكيانايت، إلخ).
   - عند اختيار أي معدن:
     - عرض نافذة مواصفات المعدن واستخداماته مع صورته الحقيقية (`*.jpg`).
     - تحديد كافة مواقع تواجد هذا الخام على خريطة المملكة بأيقونته الخاصة (`ic_<metal>.png`).
     - إمكانية النقر على أي موقع لمعرفة اسم الموقع والمنطقة الإدارية وإحداثيات خط الطول والعرض.

5. **مصادر المياه (Water Resources)**:
   - عرض فوري تلقائي عند الدخول لنافذة "مشاكل ومصادر المياه" التي تحوي الشرح المائي الشامل وجميع اللوحات والمخططات الإيضاحية العشرة (`waterproblems1.png` إلى `waterproblems10.png`).
   - 4 تبويبات رئيسية:
     - **التكاوين المائية الرئيسية**: (ساق، تبوك، وجيد، منجور، بياض، وسيع).
     - **التكاوين المائية الثانوية**: (أم الرضمة، الدمام، النيوجين، الجوف، الخف، الجلح، ضرما، سكاكا، العرمة).
     - **الأودية (53 وادياً)**: قراءة وعرض مسارات الـ 53 وادياً من ملفات `GeoJSON` مع ألوانها الأصلية المميزة والتحليق لموقع الوادي.
     - **السدود**: قراءة سدود المملكة من ملف الإكسل `dams.xlsx` وعرضها برموز قطرات الماء (`droplet.png`) وتفاصيل ارتفاع وسعة كل سد.

6. **البترول والغاز (Petroleum & Gas)**:
   - مقدمة جيولوجية مصورة (`oil_brief.png`) حول نشأة ومكامن النفط والغاز.
   - قائمتان منسدلتان متطابقتان:
     - **حقول النفط (12 حقلاً)**: الغوار، خريص، اللغفة، الجوب، الشطفة، الشيبة، الرملة، الحوطة، بقيق، السفانية، منيفة، البري.
     - **حقول الغاز (12 حقلاً)**: مدين، برقان، الحلوة، شمعة، الكدن الشمالي، الكدن الجنوبي، المحاكيك، شدون، الوضيحي، أوتاد، مزاليج، إلخ.
   - علامات الخريطة المخصصة (`oil_marker.png` و `gas_marker.png`).
   - عند النقر على أي حقل: التكبير الفوري إلى الحقل وعرض بطاقة معلوماته التفصيلية واحتياطياته وصخور مكمنه ومصدره.

7. **السياحة والآثار (Geological Tourism)**:
   - مقدمة عن السياحة الجيولوجية ومواقع التراث العالمي في المملكة.
   - تصفح المعالم حسب المناطق الإدارية (المدينة المنورة، الرياض، مكة المكرمة، تبوك، حائل، عسير، الشرقية، جازان، نجران، الجوف، الباحة، إلخ).
   - بطاقات تعريفية مصورة للمعالم الجيولوجية البارزة (جبل الفيل، قوس مقرط الدبوس، غراميل العلا، فوهة الوعبة، بركان جبل الملساء، بركان جبل البيضاء، حافة العالم، عين هيت، وادي الديسة، صخرة النصلة، جبل القارة، وادي لجب، جبال فيفا، قرية ذي عين، جزر فرسان، مدائن صالح، إلخ).

8. **قاعدة البيانات الزلزالية (Seismic Database)**:
   - مقدمة زلزالية وتكتونية حول حركة الصفيحة العربية.
   - تصنيف زلزالي تفاعلي عبر 5 ملفات إكسل حقيقية:
     - الزلازل التاريخية (`Histroical.xlsx` - أيقونة مربعة)
     - من 4 إلى 4.9 درجات (`4 to 5.xlsx` - أيقونة دائرية صغيرة)
     - من 5 إلى 5.9 درجات (`5 to 6.xlsx` - أيقونة متوسطة)
     - من 6 إلى 6.9 درجات (`6 to 7.xlsx` - أيقونة كبيرة)
     - 7 درجات فما فوق (`7 and above.xlsx` - أيقونة كبيرة جداً)
   - قراءة الإحداثيات وتاريخ ووقت الهزة وقوتها بمقياس ريختر وإظهارها عند النقر على الهزة.

---

## 🚀 تشغيل التطبيق (How to Run)

### 1. المتطلبات:
- تثبيت Flutter SDK (الإصدار 3.10 فما فوق).

### 2. تثبيت الحزم:
```bash
flutter pub get
```

### 3. الفحص البرمجي:
```bash
flutter analyze
```

### 4. التشغيل على المنصات:
- **تشغيل على متصفح الويب (Chrome)**:
  ```bash
  flutter run -d chrome
  ```
- **تشغيل على نظام ويندوز (Windows Desktop)**:
  ```bash
  flutter run -d windows
  ```
- **تشغيل على أجهزة أندرويد (Android)**:
  ```bash
  flutter run -d android
  ```
- **تشغيل على أجهزة آبل (iOS)**:
  ```bash
  flutter run -d ios
  ```

---

## 📁 هيكلية المشروع المستحدثة (Restructured Repository Architecture)

```text
our resoures flutter/
├── .github/
│   └── workflows/
│       └── deploy.yml            # CI/CD: Automated Flutter Web build & Vercel deployment
├── vercel.json                   # Vercel SPA routing and header configuration
├── .gitignore                    # Flutter, Android, iOS, Windows, Vercel ignore rules
├── assets/
│   ├── data/                     # materials.xlsx, dams.xlsx, tourism_data.json
│   ├── earthquake/               # 5 earthquake Excel datasets
│   ├── fonts/                    # Noto Kufi Arabic Fonts & Reem Kufi
│   ├── images/                   # Wallpapers, icons, specimen photos, infographics
│   └── maps/                     # 53 Valley GeoJSONs, water formations, saudi_geo
├── lib/
│   ├── main.dart                 # App entrypoint, RTL config, Landscape lock
│   ├── core/
│   │   ├── constants/            # AppAssets paths
│   │   ├── theme/                # AppColors, typography & button themes
│   │   ├── widgets/              # MapShell, CustomButton
│   │   └── dialogs/              # Info, Brief, Water Infographics, About dialogs
│   └── features/
│       ├── start/                # StartScreen (matching StartActivity)
│       ├── menu/                 # FullscreenMenuScreen (matching FullscreenListActivity)
│       ├── geology/              # GeologyScreen (matching MainActivity)
│       ├── materials/            # MaterialsScreen (matching MaterialsActivity)
│       ├── water/                # WaterFormationsScreen (matching WaterFormations)
│       ├── oil_gas/              # OilGasScreen (matching OilGas)
│       ├── earthquake/           # EarthquakeScreen (matching EarthquakeActivity)
│       └── tourism/              # TourismScreen (matching TourismActivity)
├── android/                      # Flutter Android native runner
├── ios/                          # Flutter iOS native runner
├── web/                          # Flutter Web entrypoint & manifest
├── windows/                      # Flutter Windows desktop runner
├── pubspec.yaml                  # Flutter assets & dependencies
│
└── kotlin_android_legacy/        # 📦 التطبيق الأصلي بكود Kotlin محفوظ بالكامل
    └── map/                      # Original Android Kotlin Android Studio Project
```

---

## 🚀 الاستضافة والنشر على Vercel عبر GitHub (Vercel + GitHub Deployment)

### الطريقة الأولى: النشر الآلي عبر GitHub Actions (موصى بها)
1. قم بإنشاء مستودع جديد على **GitHub** (New Repository).
2. ادفع الكود إلى المستودع:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Our Resources Flutter Multiplatform App"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```
3. في حسابك على **Vercel**:
   - احصل على `VERCEL_TOKEN` من إعدادات حسابك (Account Settings -> Tokens).
   - قم بربط المشروع في Vercel، وضع أسرار المشروع في GitHub Secrets:
     - `VERCEL_TOKEN`
     - `VERCEL_ORG_ID`
     - `VERCEL_PROJECT_ID`
4. عند كل `git push` إلى `main`، سيقوم GitHub Actions ببناء تطبيق Flutter Web ونشره فوراً على Vercel!

### الطريقة الثانية: الرفع المباشر عبر Vercel CLI
1. بناء ملفات الويب محلياً:
   ```bash
   flutter build web --release
   ```
2. النشر المباشر عبر أمر Vercel:
   ```bash
   vercel --prod
   ```

