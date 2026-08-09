# Heure & Météo — Casablanca 🇲🇦

Une page web unique qui affiche :

- **L'heure en direct** de Casablanca (fuseau `Africa/Casablanca`)
- **La météo actuelle** (température, ressenti, humidité, vent) fournie gratuitement par l'API [Open-Meteo](https://open-meteo.com/) — **aucune clé API nécessaire**

## 🗂️ Contenu du projet

| Fichier      | Rôle                                              |
| ------------ | ------------------------------------------------- |
| `index.html` | La page complète (HTML + CSS + JavaScript)        |
| `README.md`  | Ce guide                                          |

## 🚀 Mise en ligne sur GitHub

1. Créez un compte sur [github.com](https://github.com) (gratuit) et connectez-vous.
2. Cliquez sur le bouton vert **« New »** (ou **« New repository »**) en haut à droite.
3. Remplissez :
   - **Repository name** : `meteo-casablanca` (ou le nom que vous voulez)
   - Choisissez **Public** (gratuit) — ou **Private** si vous préférez
   - Laissez les autres options par défaut, puis cliquez sur **« Create repository »**.
4. Sur la page du nouveau dépôt, cliquez sur **« uploading an existing file »**.
5. Glissez-déposez le fichier `index.html` (et `README.md` si vous voulez) dans la zone prévue.
6. Cliquez sur **« Commit changes »** (le message peut rester par défaut).

Votre page est maintenant sur GitHub : `https://github.com/VOTRE_NOM/meteo-casablanca`

## ▲ Mise en ligne sur Vercel (hébergement gratuit)

1. Allez sur [vercel.com](https://vercel.com) et cliquez sur **« Sign Up »**.
2. Choisissez **« Continue with GitHub »** et autorisez l'accès (cela permet à Vercel de lire vos dépôts).
3. Cliquez sur **« Add New… »** puis **« Project »**.
4. Dans la liste, sélectionnez le dépôt `meteo-casablanca` que vous venez de créer.
5. Vercel détecte automatiquement un site statique — **ne changez rien** aux réglages, cliquez sur **« Deploy »**.
6. Patientez quelques secondes : à la fin, Vercel affiche **« Congratulations »** avec l'adresse de votre site, par exemple :
   `https://meteo-casablanca.vercel.app`

🎉 C'est en ligne ! Le site est accessible depuis n'importe quel appareil, et l'URL ressemble à `https://meteo-casablanca-XXXX.vercel.app`.

## 🔁 Mettre à jour la page plus tard

- Modifiez le fichier `index.html` sur GitHub (icône crayon ✏️) puis cliquez sur **« Commit changes »**.
- Vercel redéploie automatiquement le site en quelques secondes — rien d'autre à faire.

## 🧰 Commandes Git (optionnel, si vous préférez le terminal)

```bash
git clone https://github.com/VOTRE_NOM/meteo-casablanca.git
cd meteo-casablanca
# copiez votre index.html ici, puis :
git add index.html
git commit -m "Ajout de la page heure et météo"
git push
```
