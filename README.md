# Minorman.
###### A tale of loss, redemption, and gold. 

Minorman è un roguelite action e story driven. Racconta la storia di Norman, che nello stesso giorno ha perso un padre e un eroe, e che nel farlo ha trovato il suo posto nel mondo. 

NB: questo documento sarà aggiornato mano a mano che troverò la voglia di copià quello cartaceo. 

###### Devlog:
# minorman-game

Giusto un reminder per te, Franco del futuro. Stai in mezzo all'epidemia (pandemia?) de Coronavirus, è il 16 marzo 2020. Cominci sto progetto "nuovo". In bocca al lupo. Crepi.

Allegria. L'hai modificato due volte giusto pe mette la nota di committing.

### 20/03/2020

Cominciata la preproduzione, messe animazioni e sprite placeholder. Ora in cerca di un tileset.

### 21/03/2020

Tileset trovato, area di test in progress.

Eppur si muove! Aggiunto movimento provvisorio, da sostituire con state machine.

### 22/03/2020

Cioè in realtà la state machine non me serve. Per niente. Aggiornato l'header del readme, visto che non sò più da solo qui sopra. Ciao Stè. 

### 24/03/2020

Contrordine, la state machine potrebbe esse un'idea per discerne segui mouse (fermo/attacca) o segui direzione (movimento). Umm. 
Comunque. Habemus piccozza. Piccone. Eh. Ci muoviamo come a South Park, e questa è cosa buona. Collisioni! Adesso manca una bella animazione de attacco e sto a cavallo.

### 04/04/2020

Woohoo. State Machine implementata, pacche sulle spalle. Imparato il fast-forward merge. Adesso Norman attacca ed è in generale piuttosto cazzuto. Foward we go!

### 10/04/2020

Da oggi la porta se apre. Mamma mia. Generazione casuale quasi allo stato dell'arte. Adesso la mappa va popolata, ma l'implementazione è banale vista la struttura che ho dato al generatore. 
Posso migliorare il modo in cui si interfaccia alla tilemap comunque, per decouplare un po'. Al momento è poco flessibile in quel senso, ce stanno troppi hack che stanno su con lo sputo.

Puoi fare di meglio.

###### Memo: aggiungi un altro strato di bordo per sicurezza. 