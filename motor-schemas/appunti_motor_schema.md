# Appunti Motor Schema

Ogni behaviour rappresenta un diverso Motor Schema.
Ciascun Motor Schema ritorna un vettore composto da magnitudine e orientazione(v_length, v_angle) e contribuisce quindi a variare l'angolo della direzione del robot.
Alla fine si sommeranno quindi i vettori di tutti i motor schema presenti e si calcolerà la forza finale.

Un motor schema è composta da un perceptual schema, il quale fornisce le informazioni ambientali specifiche per quel behaviour.

Tipologie di campi potenziali:
- uniforme
- perpendicolare
- attrattivo
- repulsivo
- tangenziale

Come programmare un campo potenziale:
I campi sono calcolati ad ogni step a seconda di dove si trova il robot.
Esempio per la forza repulsiva
V_angle = -pi
V_length = D - d / D

Sui perceptual schemas:
Il robot percepisce l'ambiente (sensori) attraverso i perceptual schemas.
Si puo avere un perceptual schema per ogni sensore.
L'obiettivo è quello di incapsulare dentro al perceptual schema le informazioni rilevanti per un determinato motorschema.


Idee:
In pratica ogni motor schema si calcola il suo campo potenziale che gli interessa (attrattivo, repulsivo, etc) e torna il vettore con magnitudine e angolo.