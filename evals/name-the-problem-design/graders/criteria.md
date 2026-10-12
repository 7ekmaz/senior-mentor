---
type: llm
weight: 1
---

PASS if, before any implementation and before or alongside the constraint questions, the agent frames the problem the way the industry does: names it internationalization (i18n), distinguishes it from localization (l10n), and lists at least three sibling problems that come with it (e.g. right-to-left layout for Arabic, plural rules, date/number/currency formats, locale fallback, Unicode/sorting, the translation workflow), plus at least one named standard or tool (e.g. CLDR, ICU MessageFormat, next-intl, i18next). Bonus if it names how production teams usually handle it and a common mistake (e.g. concatenating translated strings). FAIL if it starts writing implementation code, or only asks constraint questions with no naming of the problem and its siblings.
