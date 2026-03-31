# SimpleDisenchant - Plan de Test

Plan de test pour les features des PRs #33, #34, #35, #37.

---

## PR #33 - Equipment Set Filter (Issue #32)

### Pre-requis
- Avoir au moins 1 equipment set cree (via le gestionnaire d'equipement WoW)
- Avoir des items de cet equipment set dans les sacs
- Avoir des items desenchantables (vert+) dans les sacs

### Tests

- [ ] **T33-01** : Ouvrir `/sde`, verifier que les items d'equipment set ne sont PAS dans la liste de desenchantement (filtre actif par defaut)
- [ ] **T33-02** : Ouvrir le dropdown "Filtre", verifier la presence de la checkbox "Hide Equipment Set items" (cochee par defaut)
- [ ] **T33-03** : Decocher "Hide Equipment Set items", verifier que les items d'equipment set apparaissent dans la liste principale
- [ ] **T33-04** : Recocher "Hide Equipment Set items", les items disparaissent de la liste principale
- [ ] **T33-05** : Avec le filtre actif, ouvrir `/sde filtered` — verifier la section "Equipment Set" avec les items filtres
- [ ] **T33-06** : Dans le panneau Filtered, cliquer sur un item d'equipment set — il doit etre ajoute en position 1 de la liste de desenchantement
- [ ] **T33-07** : Le tooltip dans le panneau Filtered affiche bien le hint "Click to add to disenchant list"
- [ ] **T33-08** : `/reload` — le reglage du filtre equipment set est persiste (SavedVariables)
- [ ] **T33-09** : Creer un nouvel equipment set avec un item du sac, re-scanner (`/sde`) — l'item est maintenant filtre
- [ ] **T33-10** : Supprimer l'equipment set, re-scanner — l'item reapparait dans la liste

### Locales
- [ ] **T33-L1** : Tester en anglais (enUS) — labels corrects
- [ ] **T33-L2** : Tester en francais (frFR) — labels corrects
- [ ] **T33-L3** : Verifier le tooltip du filtre equipment set

---

## PR #34 - Profession Equipment Filter (Issue #31)

### Pre-requis
- Avoir des items desenchantables de types varies : armure, arme, equipement de profession (ex: outil de mineur, gants d'ingenieur)
- Avoir des items de qualite verte ou superieure

### Tests

- [ ] **T34-01** : Ouvrir `/sde`, verifier que tous les types d'items apparaissent (armure, arme, profession) — tous les filtres sont actifs par defaut
- [ ] **T34-02** : Ouvrir le dropdown "Filtre", verifier la section "Item Type" avec 3 checkboxes : Armor, Weapon, Profession
- [ ] **T34-03** : Decocher "Armor", verifier que les armures disparaissent de la liste
- [ ] **T34-04** : Decocher "Weapon", verifier que les armes disparaissent
- [ ] **T34-05** : Decocher "Profession", verifier que l'equipement de profession disparait
- [ ] **T34-06** : Recocher chaque type — les items reapparaissent
- [ ] **T34-07** : Le bouton "Reset" du filtre remet tous les types a cochee
- [ ] **T34-08** : `/reload` — les reglages de type d'item sont persistes
- [ ] **T34-09** : Verifier que le compteur d'items se met a jour quand on active/desactive les filtres de type
- [ ] **T34-10** : Verifier que `HasActiveFilters()` detecte un filtre de type decocher (indicateur visuel sur le bouton Filtre)

### Locales
- [ ] **T34-L1** : Labels en anglais corrects (Armor, Weapon, Profession)
- [ ] **T34-L2** : Labels en francais corrects
- [ ] **T34-L3** : Tooltip du filtre item type visible et correct

---

## PR #35 - LDB Support (Issue #30)

### Pre-requis
- Installer un addon LDB display (Bazooka, Titan Panel, ChocolateBar, ou similaire)
- LibDataBroker-1.1 et LibStub doivent etre inclus (empaquetes automatiquement)

### Tests

- [ ] **T35-01** : Au chargement, verifier que SimpleDisenchant apparait dans l'addon LDB display
- [ ] **T35-02** : Verifier l'icone (INV_Enchant_Disenchant) dans le display
- [ ] **T35-03** : Clic gauche sur le launcher LDB — ouvre/ferme la fenetre principale + scan des sacs
- [ ] **T35-04** : Clic droit sur le launcher LDB — ouvre/ferme la blacklist
- [ ] **T35-05** : Shift+clic sur le launcher LDB — toggle le bouton minimap
- [ ] **T35-06** : Hover sur le launcher — tooltip affiche titre + instructions (memes textes que le minimap)
- [ ] **T35-07** : En combat, clic sur le launcher — message d'avertissement combat, pas d'action
- [ ] **T35-08** : Sans addon LDB installe — l'addon SimpleDisenchant se charge normalement sans erreur
- [ ] **T35-09** : Verifier que LibStub et LibDataBroker sont bien empaquetes (dossier Libs/)

### Fallback
- [ ] **T35-F1** : Supprimer le dossier Libs/ — l'addon se charge sans erreur Lua (graceful fallback)

---

## PR #37 - Reset Window Positions (Issue #36)

### Pre-requis
- Avoir ouvert et deplace les fenetres (principale, blacklist, filtered items)

### Tests

- [ ] **T37-01** : Deplacer la fenetre principale, taper `/sde reset` — la fenetre revient au centre
- [ ] **T37-02** : Deplacer la fenetre blacklist, taper `/sde reset` — la fenetre revient a sa position par defaut
- [ ] **T37-03** : Deplacer la fenetre filtered items, taper `/sde reset` — position par defaut
- [ ] **T37-04** : Deplacer les 3 fenetres, `/sde reset` — toutes reviennent en position par defaut
- [ ] **T37-05** : Verifier le message de confirmation dans le chat apres `/sde reset`
- [ ] **T37-06** : Taper `/sde reset` sans avoir ouvert de fenetre — pas d'erreur Lua
- [ ] **T37-07** : Apres reset, le docking fonctionne toujours (blacklist se colle a la fenetre principale quand ouverte)

### Locales
- [ ] **T37-L1** : Message de reset en anglais correct
- [ ] **T37-L2** : Message de reset en francais correct

---

## Tests de Non-Regression

### Fonctionnalites existantes

- [ ] **NR-01** : `/sde` ouvre/ferme la fenetre principale
- [ ] **NR-02** : `/sde blacklist` ou `/sde bl` ouvre/ferme la blacklist
- [ ] **NR-03** : `/sde filtered` ou `/sde filter` ouvre/ferme le panneau des items filtres
- [ ] **NR-04** : `/sde minimap` toggle le bouton minimap
- [ ] **NR-05** : `/sde blacklist clear` vide la blacklist
- [ ] **NR-06** : Scan des sacs — tous les items desenchantables apparaissent
- [ ] **NR-07** : Clic droit sur un item — ajout a la blacklist avec message de confirmation
- [ ] **NR-08** : Bouton de desenchantement fonctionne (securise)
- [ ] **NR-09** : Filtre de rarete (qualite) fonctionne
- [ ] **NR-10** : Filtre d'item level fonctionne (min/max)
- [ ] **NR-11** : Filtre de prix vendeur fonctionne (min/max)
- [ ] **NR-12** : Le bouton "Reset" remet tous les filtres par defaut
- [ ] **NR-13** : Fermeture avec Escape sur toutes les fenetres
- [ ] **NR-14** : Docking : blacklist se colle a droite de la fenetre principale
- [ ] **NR-15** : Docking : filtered se colle a droite de la blacklist (ou de la principale si blacklist fermee)
- [ ] **NR-16** : Bouton minimap — clic gauche ouvre la fenetre, clic droit ouvre la blacklist
- [ ] **NR-17** : En combat — overlay affiche, aucune action possible
- [ ] **NR-18** : Sortie de combat — overlay disparait, scan auto
- [ ] **NR-19** : Keybindings fonctionnels (si configures)
- [ ] **NR-20** : Addon Compartment (bouton addon dans la barre) fonctionne

### SavedVariables
- [ ] **NR-SV1** : `/reload` — blacklist persistee
- [ ] **NR-SV2** : `/reload` — filtres de rarete persistes
- [ ] **NR-SV3** : `/reload` — filtres ilvl/gold persistes
- [ ] **NR-SV4** : `/reload` — position du minimap button persistee
- [ ] **NR-SV5** : `/reload` — filtres item type persistes (nouveau)
- [ ] **NR-SV6** : `/reload` — filtre equipment set persiste (nouveau)

### Performance
- [ ] **NR-P1** : Ouvrir les sacs avec 100+ items — pas de freeze notable
- [ ] **NR-P2** : Spam `/sde` rapidement — pas d'erreur Lua
- [ ] **NR-P3** : Ouvrir/fermer toutes les fenetres rapidement — pas de fuite memoire visible
