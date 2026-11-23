# Mobile UI Skills — Claude Code & Codex

ثلاث مهارات بتخلّي واجهات الموبايل مقصودة ومتسقة ومتاحة للجميع (accessible) — بدل الشكل الجنريك اللي بيطلع من الـ AI. بتشتغل مباشرة مع Claude Code وCodex، والمصدر واحد عشان القواعد تفضل متسقة.

بتدعم **iOS, Android, Flutter, React Native, SwiftUI, UIKit, Jetpack Compose**، وفيها قواعد كاملة للعربي والـ RTL.

---

## التوافق مع الـ agents

| البيئة | طريقة الاستخدام الفعلية |
|---|---|
| Claude Code | Plugin تلقائي بأوامر `/mobile-ui:create` و`/mobile-ui:audit` و`/mobile-ui:fix`، أو التثبيت اليدوي الموضح أدناه. |
| Codex | Native skills بأسماء `$mobile-ui-create` و`$mobile-ui-audit` و`$mobile-ui-fix` بعد التثبيت. الـ implicit invocation شغال افتراضياً كمان. |
| أي agent آخر | اقرأ ملف `SKILL.md` المطلوب صراحةً والمراجع التي يوجّه إليها قبل التنفيذ. |

## التثبيت والاستخدام في Codex

Codex بيدوّر على user skills في `~/.agents/skills`. ثبّت النسخة الـ native كده:

```bash
git clone https://github.com/karemreda040-dotcom/mobile-ui-skills.git
cd mobile-ui-skills
bash install.sh --agent codex
```

المطلوب: Git وBash، وPython 3 لتصدير نسخة Codex. ولتثبيت البيئتين مرة واحدة: `bash install.sh --agent both`.

بعدها استخدمها صراحةً في Codex:

```text
$mobile-ui-audit راجع واجهة الموبايل في src/screens وsrc/components من غير تعديل.
$mobile-ui-fix صلّح مشاكل الـ Blocker والـ High في شاشة Profile فقط، مع الحفاظ على logic وroutes وAPIs.
$mobile-ui-create ابنِ شاشة login عربية RTL ومتوافقة مع iOS وAndroid.
```

الـ audit تعليمات read-only، لكن صلاحيات الـ host هي اللي بتنفّذ العزل فعلياً. استخدم صلاحيات قراءة فقط لو محتاج enforcement. للإزالة: `bash uninstall.sh --agent codex`. لو المهارات مش ظاهرة، أعد تشغيل Codex أو افتح `/skills` للتحقق منها.

لو عايز تثبّت skill جوه مشروع أو تختبرها من غير ما تلمس الـ user directory، مرّر destination مخصص:

```bash
bash install.sh --agent codex --dest /path/to/your-app/.agents/skills
```

ده هو مسار الـ repository skills في Codex. شغّل Codex بعد كده من working directory بتاع التطبيق، مش من checkout المهارات. وللإزالة من نفس المسار: `bash uninstall.sh --agent codex --dest /path/to/your-app/.agents/skills`. التفاصيل الرسمية: [Build skills for Codex](https://learn.chatgpt.com/docs/build-skills).

---

## الأوامر الثلاثة في Claude Code

| الأمر | إمتى تستخدمه |
|---|---|
| `/mobile-ui:create` | التصميم لسه مبدأش — عايز شاشة أو flow جديد |
| `/mobile-ui:audit` | التصميم موجود وعايز **تقرير** بالمشاكل من غير ما يتلمس الكود |
| `/mobile-ui:fix` | التصميم موجود وعايز Claude **يعدّل الكود فعلاً** ويختبره |

`/mobile-ui:audit` في تكامل Claude Code يطلب read-only، ولو الـ host بيفسّر `disallowed-tools` في frontmatter ملف الاسكيل ممكن يزيل `Edit` و`Write` و`NotebookEdit`. ده مش sandbox عام؛ خارج host يطبّق القيود لازم تستخدم صلاحيات قراءة فقط.

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
