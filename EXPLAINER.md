# الاسكيل دي بتعمل إيه؟ — شرح لأي حد

## الفكرة في سطر واحد

Claude لوحده بيصمم من "ذاكرته العامة"، فبيطلّع نفس الواجهة الجنريكة كل مرة. الاسكيل دي **نظام قواعد صارم** بيمشي عليه بدل ما يرتجل.

هي **مش** زرار "جمّل التصميم". هي مجموعة قواعد + workflow. إنت اللي بتحدد نوع الشغل والنطاق.

---

## الأوامر التلاتة

| الأمر | استخدمه لما |
|---|---|
| `/mobile-ui:create` | **لسه مبدأتش.** عايز شاشة أو flow جديد يتبني من الصفر |
| `/mobile-ui:audit` | **التصميم موجود.** عايز تعرف إيه الغلط — **من غير ما يتلمس أي ملف** |
| `/mobile-ui:fix` | **التصميم موجود.** عايز Claude يصلّح الكود فعلاً ويختبره |

> لو ثبّتها يدوي (`install.sh`) الأسماء بتبقى `/mobile-ui-create` من غير النقطتين.

**الـ audit read-only بالإجبار** — مش مجرد تعليمات مكتوبة. أدوات التعديل (`Edit`, `Write`, `NotebookEdit`) **مشيلة فعلياً** من إيد Claude طول ما الأمر شغال. يعني تقدر تشغّله على كود production من غير خوف.

---

## "شكل الـ AI" — إيه هو بالظبط؟

دي مش حاجة مبهمة. هي **قايمة أنماط محددة** بيقع فيها كل مولّد AI. خد شاشة نموذجية اتعملت بالـ AI وشوف الأمراض:

### ١. الجراديانت البنفسجي-الأزرق

```jsx
<LinearGradient colors={['#667EEA', '#764BA2']}>
```

اللونين دول بالذات هما توقيع الـ AI. مش ليهم علاقة ببراند المنتج — طالعين من الفراغ. الاسكيل بتشيلهم وتدوّر على لون البراند الحقيقي في المشروع.

### ٢. الإيموجي كنظام أيقونات

```jsx
<Text>💰</Text>   <Text>📈</Text>   <Text>🎯</Text>
<Text>Welcome Back! ✨</Text>
<Text>Upgrade to Premium 🚀</Text>
```

الإيموجي بيتغيّر شكله بين المنصات، مش قابل للتلوين، ومش بيتقري بالـ screen reader صح. المنتج الحقيقي عنده icon set واحد.

### ٣. بيانات وهمية

```jsx
<Text>$12,450</Text>    <Text>+24%</Text>    <Text>8 Goals</Text>
```

أرقام متحطوطة بالإيد عشان الشاشة "تبان مليانة". دي كذبة بتتشحن للـ production.

### ٤. كل حاجة كارت — وكروت جوه كروت

```jsx
<View style={styles.sectionCard}>     // كارت
  <View style={styles.txCard}>        // كارت جوه الكارت
```

على خلفية رمادية `#F7F7F7`. النتيجة: كروت بيضا طايرة في كل مكان، ومفيش hierarchy — كل حاجة نفس الأهمية.

### ٥. نفس الظل تحت كل حاجة

```jsx
shadowOpacity: 0.18, shadowRadius: 16, shadowOffset: { height: 8 }
```

مكرر تحت الـ stat cards والـ section cards والـ transaction cards. الظل المفروض **يعني** ارتفاع — لو تحت كل حاجة، فهو مش بيعني حاجة.

### ٦. أيقونة جوه مربع ملون لغرض الزينة

```jsx
iconBox: { width: 36, height: 36, borderRadius: 12, backgroundColor: '#EEF2FF' }
```

المربع الملون ده مالوش أي معنى. مجرد ديكور.

### ٧. مسافات عشوائية

```jsx
paddingHorizontal: 19,  marginBottom: 17,  padding: 13,  marginLeft: 13
```

١٩ و١٧ و١٣؟ دي مش من أي نظام. النظام السليم مبني على ٤: `4, 8, 12, 16, 24, 32`.

### ٨. نص رمادي مش مقروء

```jsx
statLabel: { color: '#808080' }
```

تباينه على الأبيض **3.95:1** — والحد الأدنى في WCAG هو **4.5:1**. يعني حرفياً صعب القراءة.

### ٩. مساحات لمس أصغر من الحد الأدنى

```jsx
pill: { height: 36, borderRadius: 999 }
```

٣٦ نقطة. الحد الأدنى **٤٤ على iOS** و**٤٨ على Android**. يعني الزرار صعب تدوس عليه. وكمان `borderRadius: 999` — كل حاجة pill.

### ١٠. Hierarchy مكسورة

```jsx
heroTitle:    fontSize: 34, fontWeight: '700'   // ضخم زي إعلان
sectionTitle: fontSize: 24, fontWeight: '500'   // عنوان بوزن Medium؟
txName:       fontSize: 16, fontWeight: '500'   // كل النصوص Medium
```

عنوان ٣٤ في شاشة **مالية** (شاشة شغل، مش صفحة هبوط). وكل النصوص وزنها Medium — فالشاشة تقيلة ومفيش فيها تركيز.

### ١١. بيكسر العربي

```jsx
marginLeft: 13
marginLeft: 'auto'
```

`marginLeft` بيفضل شمال حتى في RTL. الصح `marginStart` — بيتقلب لوحده مع العربي.

### ١٢. الحالة السعيدة بس

```jsx
const { data, loading } = useWallet();   // loading اتجاب... ومااتستخدمش أبداً
```

مفيش loading، مفيش empty، مفيش error، مفيش offline. الشاشة حلوة في السيناريو المثالي بس — وبتنهار في الواقع.

---

## الاسكيل بتعالج ده إزاي؟

**مش بإنها تشيل كل حاجة وتخلي التطبيق ممل.** هي بتستبدل **العشوائية** بـ**قصد**:

| بدل | تحط |
|---|---|
| جراديانت بنفسجي عشوائي | لون البراند الحقيقي من المشروع |
| إيموجي | الـ icon set الموجود |
| بيانات وهمية | بيانات المنتج الحقيقية، ولو مفيش → empty state |
| كل حاجة كارت | كارت لما يكون فيه معنى؛ باقي الأقسام مسافات وعناوين |
| ظل تحت كل حاجة | border خفيف، والظل للـ overlays بس |
| مسافات ١٣/١٧/١٩ | سلّم مبني على ٤ — والمسافة جوه المجموعة أصغر من اللي بينها |
| `#808080` | `#5F6368` (تباين ٧:١) |
| زرار ٣٦ | ٤٨ فعلي، أو أيقونة صغيرة جوه مساحة لمس ٤٤/٤٨ |
| كل النصوص Medium | Regular للنص، Semibold للعناوين — hierarchy واضحة |
| `marginLeft` | `marginStart` |
| الحالة السعيدة بس | loading + empty + error + offline + disabled |

---

## ترتيب الأولوية — الاسكيل مش هتفرض ذوقها عليك

بتطبّق القواعد بالترتيب ده:

1. **طلباتك أنت** واحتياجات الـ accessibility.
2. **الـ design system الموجود في مشروعك** — البراند، الـ tokens، الـ components.
3. **قواعد المنصة** (iOS / Material 3).
4. **الـ fallback tokens** بتاعة الاسكيل.

يعني لو مشروعك عنده براند واضح، **مش هتلمسه.** الـ `TOKENS.json` شبكة أمان لما المشروع مفيهوش نظام، مش قانون.

وكمان بتحافظ على: business logic، الـ routes، الـ APIs، الـ analytics، مفاتيح الترجمة، الـ accessibility labels، والـ test IDs.

---

## إزاي تستخدمها صح

### تطبيق معمول بالـ AI وعايز تنضّفه

```bash
git switch -c ui-cleanup
```

**الطريقة الآمنة — audit ثم fix:**

```
/mobile-ui:audit راجع الـ UI كله في src/screens و src/components.
التطبيق ده اتعمل بالـ AI. متعدلش أي ملف. رتّب النتايج بالخطورة.
```

هيرجعلك تقرير بأدلة — مش كلام عام:

```
High — Inconsistent screen margins

Location:  src/screens/Home.tsx:42
           src/screens/Profile.tsx:31

Evidence:  Home بيستخدم 20. Profile بيستخدم 16. Settings بيستخدم 24.

Problem:   المحاذاة بتتغيّر بين الشاشات وبتكسر الـ grid.

Fix:       token اسمه screenHorizontalPadding قيمته 16.

Where:     في الـ theme المشترك — مش تلات patches منفصلة.
```

تقرا، توافق، وبعدين:

```
/mobile-ui:fix طبّق الـ Blocker والـ High من الـ audit فوق.
ابدأ بالـ tokens والـ shared components قبل الشاشات.
```

مش محتاج تنسخ التقرير — هو شايفه في نفس المحادثة.

### شاشة جديدة

```
/mobile-ui:create اعمل شاشة تسجيل دخول للمشروع ده.
راجع الأول الـ theme والـ components الموجودة.
عربي RTL وإنجليزي. فيها loading و validation errors و disabled و خطأ شبكة.
```

---

## أهم نصيحة: حدّد الـ scope

لو قلت "ظبط الـ UI" وبس، Claude ممكن يغيّر أكتر من اللازم. الصيغة اللي بتشتغل:

```
/mobile-ui:fix
Task:      شيل الشكل الجنريك بتاع الـ AI.
Scope:     شاشتَي Home و Profile بس.
Platform:  React Native — iOS و Android.
Preserve:  logic, navigation, APIs, localization, analytics, test IDs.
Validate:  lint, tests, build.
```

---

## المرجع بيتقسم إزاي

الأوامر التلاتة بتقرا من **مصدر واحد** في `_mobile-ui-shared/`:

- `FOUNDATIONS.md` — خطوط، مسافات، ألوان، radius، ظلال، motion، accessibility
- `COMPONENTS.md` — أزرار، حقول، كروت، navigation، sheets، forms، states
- `PLATFORM-IOS.md` — قواعد iOS و Liquid Glass
- `PLATFORM-ANDROID.md` — Material 3، dp/sp، insets
- `ARABIC-RTL.md` — العربي، bidi، الأرقام، المحتوى المختلط
- `ANTI-AI.md` — القايمة الكاملة للأنماط اللي فوق
- `REVIEW-CHECKLIST.md` — المراجعة النهائية بدرجات Blocker/High/Medium/Polish
- `TOKENS.json` — الـ tokens الافتراضية

عايز تغيّر قاعدة؟ تعدّلها في مكان واحد بس، والتلات أوامر بيشوفوا التعديل.
