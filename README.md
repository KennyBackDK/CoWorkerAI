# CoWorkAI — Foundation v7.1 (Template & Projekt-Guide)

Denne mappe er din **base**. Gør den til et **Template repository** på GitHub, og brug den derefter til ALLE nye projekter. Alt vigtigt (prompter, SPEC, OpenAPI, CI, CodeQL, Dependabot, release-please, Foundation Guard) er med.

---

## Del A — Første opsætning (én gang)

> Brug denne DEL A én gang for at få din base op på GitHub som en **Template**.

1) **Opret et tomt repo på GitHub (UI-metode, langsom men sikker)**
- Gå til GitHub → øverst til højre: **+** → **New repository**
- Navn fx: `coworkai-foundation`
- **Vigtigt:** lad alt andet stå tomt (ingen README/license/gitignore)  
- Klik **Create repository** og kopier **HTTPS URL’en** (fx `https://github.com/<OWNER>/coworkai-foundation.git`)

2) **Push din mappe op i det repo**
Åbn Terminal i roden af mappen `CoWorkAI_Elite_v7.1_FoundationGuard` og kør:

```bash
git init
git lfs install
git add .
git commit -m "feat: CoWorkAI Foundation v7.1"
git branch -M main
git remote add origin https://github.com/<OWNER>/coworkai-foundation.git
git push -u origin main
