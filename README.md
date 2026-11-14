# Servicedesk | BOA Portaal

Self-service en behandelaarsportaal voor [servicedesk.boaportaal.nl](https://servicedesk.boaportaal.nl).

Medewerkers worden aangemaakt in systeem.boaportaal.nl. Alleen die accounts komen in de backoffice. Indienen kan ook zonder account.

## Publiceren

1. Draai `schema.sql` eenmalig in de Supabase SQL Editor van het bestaande BOA-project.
2. Koppel deze repository aan een nieuwe Netlify-site.
3. Zet het domein `servicedesk.boaportaal.nl` op die site.
4. Publish directory is de root. Er is geen buildstap.

In de interface staan alleen Client-ID en PV-naam. Geen e-mailadressen.
