# Mobile UI Skills — Codex, Claude Code & AI Agents

ثلاث مهارات بتخلّي واجهات الموبايل مقصودة ومتسقة ومتاحة للجميع (accessible) — بدل الشكل الجنريك اللي بيطلع من الـ AI. القواعد والمراجع قابلة لإعادة الاستخدام مع Codex وClaude Code وأي agent يقدر يقرأ ملفات `SKILL.md` والمراجع المرتبطة بها. التثبيت التلقائي وأوامر الـ slash الموجودة هنا مخصصة لـ Claude Code.

بتدعم **iOS, Android, Flutter, React Native, SwiftUI, UIKit, Jetpack Compose**، وفيها قواعد كاملة للعربي والـ RTL.

---

## التوافق مع الـ agents

| البيئة | طريقة الاستخدام الفعلية |
|---|---|
| Claude Code | Plugin تلقائي بأوامر `/mobile-ui:create` و`/mobile-ui:audit` و`/mobile-ui:fix`، أو التثبيت اليدوي الموضح أدناه. |
| Codex وأي agent آخر | مفيش auto-discovery أو slash commands مضمونة. اقرأ ملف `SKILL.md` المطلوب صراحةً، واقرأ المراجع التي يوجّه إليها واللازمة لنطاق المهمة قبل التنفيذ. |

للاستخدام اليدوي مع Codex أو agent آخر:

```bash
git clone https://github.com/karemreda040-dotcom/mobile-ui-skills.git
cd mobile-ui-skills
```

```text
اقرأ plugins/mobile-ui/skills/audit/SKILL.md والمراجع المشتركة التي يوجّه إليها واللازمة لنطاق المهمة، ثم راجع الـ UI في src/screens وsrc/components.
لا تعدّل أي ملف. رتّب النتائج حسب Blocker ثم High ثم Medium ثم Polish، مع location وevidence وproblem وrecommended correction لكل finding.
```

داخل هذه الملفات، `$ARGUMENTS` معناها نص المهمة الذي تضعه في prompt. أسماء frontmatter مثل `disable-model-invocation` و`disallowed-tools` مخصصة لتكامل Claude Code؛ ولو الـ host بيفسّر `disallowed-tools` ممكن يزيل أدوات التعديل أثناء الـ audit. تعليمات الـ audit وحدها لا تعزل كل أدوات الـ agent ولا تضمن read-only؛ استخدم صلاحيات host للقراءة فقط عندما تحتاج enforcement فعلي.

---

## الأوامر الثلاثة في Claude Code

| الأمر | إمتى تستخدمه |
|---|---|
| `/mobile-ui:create` | التصميم لسه مبدأش — عايز شاشة أو flow جديد |
| `/mobile-ui:audit` | التصميم موجود وعايز **تقرير** بالمشاكل من غير ما يتلمس الكود |
| `/mobile-ui:fix` | التصميم موجود وعايز Claude **يعدّل الكود فعلاً** ويختبره |

`/mobile-ui:audit` في تكامل Claude Code يطلب read-only، وmanifest التكامل يمنع `Edit` و`Write` و`NotebookEdit` عندما يطبّقها الـ host. ده مش sandbox عام؛ خارج host يطبّق القيود لازم تستخدم صلاحيات قراءة فقط.

---

## التثبيت في Claude Code

### الطريقة المفضّلة — Plugin (للتيم)

جوه Claude Code:

```
/plugin marketplace add karemreda040-dotcom/mobile-ui-skills
/plugin install mobile-ui@bdc-mobile-ui
```

وخلاص. لو نزلت نسخة جديدة، التيم بيعمل:

```
/plugin marketplace update bdc-mobile-ui
```

### الطريقة اليدوية لـ Claude Code — نسخ في `~/.claude/skills/`

لو حد مش عايز يستخدم نظام الـ plugins:

```bash
git clone https://github.com/karemreda040-dotcom/mobile-ui-skills.git
cd mobile-ui-skills
bash install.sh
```

في الحالة دي الأسماء بتبقى `/mobile-ui-create` و`/mobile-ui-audit` و`/mobile-ui-fix` (من غير الـ `:` لأن مفيش plugin بيعمل namespace).

للإزالة: `bash uninstall.sh`

> **ملاحظة:** لو فولدر `~/.claude/skills` مكانش موجود قبل كده، اقفل Claude Code وافتحه تاني. تعديل اسكيل موجودة بيتقرا live من غير restart.

---

## إزاي تستخدمها في Claude Code

### ١. عندك تطبيق معمول بالـ AI وشكله وحش

ده أكتر سيناريو. اعمل branch الأول:

```bash
git switch -c ui-cleanup
```

**الطريقة الآمنة — audit ثم fix:**

```
/mobile-ui:audit راجع الـ UI كله في src/screens و src/components.

التطبيق ده اتعمل بالـ AI. دوّر على:
- كروت زيادة عن اللزوم وpill shapes في كل حتة
- مسافات وradius عشوائية
- hierarchy ضعيفة في الخطوط
- جراديانت وglass وshadows بلا داعي
- أزرار وinputs مش متسقة
- حالات ناقصة: loading / error / empty / offline / disabled
- مشاكل accessibility و RTL

متعدلش أي ملف. رتّب النتايج بالخطورة وحدد ترتيب التنفيذ.
```

اقرا التقرير. لو موافق:

```
/mobile-ui:fix طبّق نتايج الـ Blocker والـ High من الـ audit فوق.

ابدأ بالـ tokens والـ shared components قبل الشاشات.
حافظ على: business logic, routes, APIs, analytics, localization keys, accessibility labels, test IDs.
شغّل formatter و lint و type check و tests و build بعد التعديل.
```

مش محتاج تنسخ التقرير تاني — Claude شايفه في نفس المحادثة.

**الطريقة السريعة — fix مباشر:**

```
/mobile-ui:fix افحص وصلّح الـ UI كله في التطبيق ده.

اتعمل بالـ AI وشكله جنريك. ابدأ بالـ design system والـ theme والـ shared components، وبعدين الشاشات.
شيل الديكور اللي مالوش لازمة وخلي الواجهة مقصودة ومتسقة ومناسبة للمنصة.
متغيرش أي business logic.
```

### ٢. عايز شاشة جديدة

```
/mobile-ui:create اعمل ونفّذ شاشة تسجيل دخول للمشروع ده.

راجع الأول الـ theme والـ components الموجودة ومتعملش design system جديد لو فيه واحد.

الشاشة عربي RTL وإنجليزي، وفيها:
- رقم تليفون، باسورد، نسيت الباسورد، زرار الدخول
- حالات: loading، أخطاء validation، disabled، خطأ شبكة، نجاح

خلّي سلوك iOS و Android مناسب لكل منصة، وبعد التنفيذ شغّل formatter و lint و tests و build.
```

### ٣. عندك screenshot بس من غير كود

حط الصورة في المشروع، أو اسحبها/الصقها في Claude Code مباشرة:

```
/mobile-ui:audit راجع الصورة اللي في design-references/home.png وقارنها بـ src/screens/Home.tsx.
```

---

## حدّد الـ scope — أمثلة Claude Code

لو قلت "ظبط الـ UI" بس، Claude ممكن يغيّر أكتر من اللازم. الصيغة اللي بتشتغل:

```
/mobile-ui:fix
Task: شيل الشكل الجنريك بتاع الـ AI.
Scope: شاشتَي Home و Profile بس.
Platform: React Native — iOS و Android.
Preserve: logic, navigation, APIs, localization, analytics, test IDs.
Validate: lint, tests, build.
```

**شاشة واحدة:**
```
/mobile-ui:fix صلّح شاشة Profile بس والـ shared components اللي بتستخدمها مباشرة.
متلمسش أي شاشة تانية إلا لو فيه إصلاح لازم يتعمل في token أو component مشترك.
```

**Flow كامل:**
```
/mobile-ui:fix صلّح flow المصادقة بس: Login، Forgot password، OTP، Reset password.
```

---

## ترتيب الأولوية — مين بيغلب مين

الاسكيلز بتطبّق القواعد بالترتيب ده:

1. **طلبات المستخدم** والاحتياجات الصريحة للـ accessibility.
2. **الـ design system الموجود في المشروع** — البراند، الـ tokens، الـ components.
3. **قواعد المنصة** (iOS / Material 3).
4. **الـ fallback tokens** في `TOKENS.json`.

يعني الاسكيل **مش هتفرض** ألوانها أو خطوطها على مشروع عنده براند واضح. الـ `TOKENS.json` مجرد شبكة أمان لما المشروع مفيهوش نظام.

عايز تغيّر الـ fallback؟ عدّل `plugins/mobile-ui/skills/_mobile-ui-shared/TOKENS.json` بس — مش ملفات القواعد.

---

## المحتوى

```
plugins/mobile-ui/skills/
├── _mobile-ui-shared/          ← القواعد المشتركة (مصدر واحد للحقيقة)
│   ├── FOUNDATIONS.md          خطوط، مسافات، ألوان، radius، ظلال، motion، accessibility
│   ├── COMPONENTS.md           أزرار، حقول، كروت، navigation، sheets، forms، states
│   ├── PLATFORM-IOS.md         قواعد iOS و Liquid Glass
│   ├── PLATFORM-ANDROID.md     قواعد Android و Material 3
│   ├── ARABIC-RTL.md           العربي، bidi، الأرقام، المحتوى المختلط
│   ├── ANTI-AI.md              الأنماط اللي بتخلي التصميم شكله AI
│   ├── REVIEW-CHECKLIST.md     مراجعة نهائية بدرجات Blocker/High/Medium/Polish
│   ├── TOKENS.json             tokens افتراضية (المشروع بيغلبها)
│   ├── EVALS.md                سيناريوهات اختبار الاسكيل نفسها
│   └── SOURCES.md              المصادر
├── create/SKILL.md
├── audit/SKILL.md
└── fix/SKILL.md
```

الفولدر `_mobile-ui-shared` **مفهوش SKILL.md** — عشان كده Claude Code بيتجاهله كأمر، وبيفضل مجرد مرجع بتقراه الأوامر التلاتة. أي تعديل في قاعدة بيتعمل في مكان واحد بس.

---

## فحص الباكدج

بعد أي تعديل:

```bash
python3 scripts/validate.py
```

بيتأكد إن الـ manifests سليمة، والـ frontmatter ومتطلبات الـ audit المعلنة موجودة، والـ `$ARGUMENTS` موجود، وكل الروابط للملفات المشتركة شغالة. ده فحص هيكلي؛ مش إثبات إن كل host هيمنع التعديل أثناء التشغيل.

---

## الترخيص

MIT
