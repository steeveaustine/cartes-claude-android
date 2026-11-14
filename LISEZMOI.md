# Claude en main, appli Android et iPhone

Tout ce que Claude peut faire, rangé par thème : 68 tutos détaillés, un schéma pour chaque étape, les gestes précis et les consignes à copier. Hors ligne, aucune autorisation demandée. Guide indépendant, non officiel.

## Installer sur Android

Ouvre ce lien depuis le téléphone, connecté à GitHub :
https://github.com/steeveaustine/cartes-claude-android/releases/download/apk/claude-en-main.apk

## Installer sur iPhone

Apple n'accepte que des applis signées. Le fichier `claude-en-main.ipa` fabriqué ici ne l'est pas : c'est au moment de l'installation que ton identifiant Apple le signe.

1. Sur le PC Windows, télécharge l'IPA : https://github.com/steeveaustine/cartes-claude-android/releases/download/ipa/claude-en-main.ipa
2. Installe Sideloadly (sideloadly.io) et la version web d'iTunes, pas celle du Microsoft Store.
3. Branche l'iPhone en USB, fais-lui confiance, glisse l'IPA dans Sideloadly, entre ton identifiant Apple, clique sur Start.
4. Sur l'iPhone : Réglages, Confidentialité et sécurité, Mode développeur, active-le et redémarre. Puis Réglages, Général, VPN et gestion de l'appareil, fais confiance à ton identifiant.

Avec un identifiant Apple gratuit, l'appli cesse de s'ouvrir au bout de 7 jours : il suffit de la réinstaller de la même façon, les favoris restent. Avec l'Apple Developer Program (99 $ par an), elle tient un an, et l'App Store devient possible.

## Modifier

Le contenu de l'appli est dans `app/src/main/assets/index.html`, partagé par les deux versions. À chaque envoi sur GitHub, un nouvel APK est fabriqué, et un nouvel IPA dès que la page ou le dossier `ios` change.

Le projet iPhone tient dans `ios/` : `prepare.sh` copie la page et télécharge les polices, `project.yml` décrit le projet Xcode (XcodeGen), `bridge.js` relie la page à l'iPhone (copier, ouvrir les liens, marge sous l'encoche).
