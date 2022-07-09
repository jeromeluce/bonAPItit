# bon-API-tit

## Résumé

bonAPItit permet d'organiser des repas en ville satisfaisant le plus grand nombre de personnes ! Particulièrement adapté aux repas entre collègues, bonAPItit vous trouve les meilleurs choix près de votre lieu de travail (ou autre !). 

Organisez un groupe, donnez le code aux participants, et laissez bonAPItit vous conseiller !

## Fonctionnalités prévues

Un utilisateur créé un groupe sur l'API. Il passe les informations suivantes :
+ Le nom de son groupe (name)
+ Une addresse de départ (address)
+ Une distance maximale en mètres (entier radius, de 1000 à 50000)

L'API lui retourne alors, en cas de succès, les informations suivantes :
+ Un lien permettant de vérifier la géolocalisation 
+ Un code utilisateurs à six caractères
+ Son code administrateur à douze caractères

L'API récupère via Google Places les 20 restaurants les plus pertinents (popularité, note) présents dans le radius donné.

Le code utilisateurs permet à d'autres utilisateurs de s'inscrire à l'événement.

Pour ce faire, ils donnent à l'API leur nom (name) et le code d'inscription (registration_code).

L'API leur retourne alors, en cas de succès, les informations suivantes :
+ Leur nom (name)
+ Leurs allergies (allergies) ou null si vide
+ Leur code (member_code) permettant de modifier leurs infos

Ces utilisateurs peuvent renseigner une liste factultative d'allergies pour en informer l'organisateur, soit à leur inscription à l'évenement, soit plus tard.

Tout utilisateur peut à n'importe quel moment récupérer la liste des 20 restaurants actuellement proposés. Ils sont uniquement classés par pertinence (selon l'API Google Places).

Tout utilisateur peut, pour chaque restaurant de la liste, émettre un vote positif ou négatif. Il ne connait pas les votes des autres, uniquement le créateur du groupe peut obtenir cette information. 

Le code administrateur, lui, permet de modifier les informations de l'événement (adresse, nom, radius).

En cas de changement d'adresse ou de radius, un background job vient mettre à jour la liste.

Les restaurants qui ne se trouvent plus dans la liste après ces changements sont gardés en DB pour garantir la permanence des votes émis.

Sans action de leur part, on suppose qu'ils sont ouverts à tout. Mais un endpoint permet de choisir des types, soit par choix, soit par élimination. 

Un endpoint pour lister les types qu'on veut choisir, un endpoint pour lister les types qu'on veut exclure. 


Un endpoint permet au créateur de récupérer une liste classée de restaurants correspondant aux attentes des autres participants (en prenant en compte leurs votes, mais aussi la note donnée par les reviews Google)

+ Nom
+ Distance depuis le lieu de travail (à vol d'oiseau)
+ Nombre de likes
+ Nombre de dislikes
+ Note Google Reviews

De plus, le créateur reçoit aussi :
+ Nombre total de membres pour son événement
+ Liste des allergies 
