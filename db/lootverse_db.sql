CREATE DATABASE  IF NOT EXISTS `lootverse_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `lootverse_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: lootverse_db
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `idAdmin` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`idAdmin`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Admin','admin@lootverse.it','2958bfdff5d15d53ea0bb6c54319aa4d7f8b8a526b69921fb19a39ba6ca423536635eb9f8565ce3e29ef66afa081df814afcb1b7564db0e9aac85754395b55e6');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrello`
--

DROP TABLE IF EXISTS `carrello`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrello` (
  `idCarrello` int NOT NULL AUTO_INCREMENT,
  `data` date DEFAULT NULL,
  `id_utente` int NOT NULL,
  PRIMARY KEY (`idCarrello`),
  UNIQUE KEY `id_utente_UNIQUE` (`id_utente`),
  KEY `utente_carrello_idx` (`id_utente`),
  CONSTRAINT `fk_carrello_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`idUtente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrello`
--

LOCK TABLES `carrello` WRITE;
/*!40000 ALTER TABLE `carrello` DISABLE KEYS */;
INSERT INTO `carrello` VALUES (1,'2026-07-06',2),(2,NULL,3),(3,NULL,4);
/*!40000 ALTER TABLE `carrello` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contiene`
--

DROP TABLE IF EXISTS `contiene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contiene` (
  `id_prodotto` int NOT NULL,
  `id_carrello` int NOT NULL,
  `quantita` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_carrello`,`id_prodotto`),
  KEY `carrello_contiene_idx` (`id_carrello`),
  KEY `prodotto_contiene_idx` (`id_prodotto`),
  CONSTRAINT `fk_contiene_carrello` FOREIGN KEY (`id_carrello`) REFERENCES `carrello` (`idCarrello`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contiene_prodotto` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotto` (`idProdotto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contiene`
--

LOCK TABLES `contiene` WRITE;
/*!40000 ALTER TABLE `contiene` DISABLE KEYS */;
INSERT INTO `contiene` VALUES (2,3,1),(15,3,1);
/*!40000 ALTER TABLE `contiene` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dettaglio_ordine`
--

DROP TABLE IF EXISTS `dettaglio_ordine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dettaglio_ordine` (
  `id_ordine` int NOT NULL,
  `id_prodotto` int NOT NULL,
  `prezzo` decimal(10,2) NOT NULL,
  `iva` decimal(5,2) NOT NULL DEFAULT '22.00',
  `quantita` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_ordine`,`id_prodotto`),
  KEY `ordine_dettaglio_idx` (`id_ordine`),
  KEY `prodotto_dettaglio_idx` (`id_prodotto`),
  CONSTRAINT `fk_dettaglio_ordine` FOREIGN KEY (`id_ordine`) REFERENCES `ordine` (`idOrdine`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dettaglio_prodotto` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotto` (`idProdotto`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_ordine`
--

LOCK TABLES `dettaglio_ordine` WRITE;
/*!40000 ALTER TABLE `dettaglio_ordine` DISABLE KEYS */;
INSERT INTO `dettaglio_ordine` VALUES (1,1,366.00,22.00,1),(1,2,244.00,22.00,1),(3,15,145.18,22.00,1),(4,6,30.50,22.00,1),(4,15,145.18,22.00,1),(5,1,366.00,22.00,1),(5,15,145.18,22.00,1),(6,2,244.00,22.00,1),(7,15,145.18,22.00,1),(8,12,256.20,22.00,1),(9,12,256.20,22.00,1);
/*!40000 ALTER TABLE `dettaglio_ordine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `include`
--

DROP TABLE IF EXISTS `include`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `include` (
  `id_prodotto` int NOT NULL,
  `id_lista` int NOT NULL,
  PRIMARY KEY (`id_lista`,`id_prodotto`),
  KEY `prodotto_include_idx` (`id_prodotto`),
  KEY `lista_include_idx` (`id_lista`),
  CONSTRAINT `fk_include_lista` FOREIGN KEY (`id_lista`) REFERENCES `lista_desideri` (`id_lista_desideri`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_include_prodotto` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotto` (`idProdotto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `include`
--

LOCK TABLES `include` WRITE;
/*!40000 ALTER TABLE `include` DISABLE KEYS */;
INSERT INTO `include` VALUES (1,2),(4,3),(9,2),(15,2),(15,3);
/*!40000 ALTER TABLE `include` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_desideri`
--

DROP TABLE IF EXISTS `lista_desideri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lista_desideri` (
  `id_lista_desideri` int NOT NULL AUTO_INCREMENT,
  `prodotti` int NOT NULL DEFAULT '0',
  `id_utente` int NOT NULL,
  PRIMARY KEY (`id_lista_desideri`),
  UNIQUE KEY `id_utente_UNIQUE` (`id_utente`),
  KEY `utenteLista_idx` (`id_utente`),
  CONSTRAINT `utenteLista` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`idUtente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_desideri`
--

LOCK TABLES `lista_desideri` WRITE;
/*!40000 ALTER TABLE `lista_desideri` DISABLE KEYS */;
INSERT INTO `lista_desideri` VALUES (1,0,2),(2,3,3),(3,2,4);
/*!40000 ALTER TABLE `lista_desideri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordine`
--

DROP TABLE IF EXISTS `ordine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine` (
  `idOrdine` int NOT NULL AUTO_INCREMENT,
  `id_utente` int NOT NULL,
  `stato` varchar(300) NOT NULL DEFAULT 'In lavorazione',
  `data` date DEFAULT NULL,
  `totale` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`idOrdine`),
  KEY `fk_ordine_utente` (`id_utente`),
  CONSTRAINT `fk_ordine_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`idUtente`) ON UPDATE CASCADE,
  CONSTRAINT `chk_stato_ordine` CHECK ((`stato` in (_utf8mb3'In lavorazione',_utf8mb3'Spedito',_utf8mb3'Consegnato',_utf8mb3'Annullato',_utf8mb3'Rimborsato')))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordine`
--

LOCK TABLES `ordine` WRITE;
/*!40000 ALTER TABLE `ordine` DISABLE KEYS */;
INSERT INTO `ordine` VALUES (1,3,'Consegnato','2026-08-10',610.00),(3,3,'Spedito','2026-08-11',145.18),(4,3,'In lavorazione','2026-08-12',175.68),(5,3,'In lavorazione','2026-08-12',511.18),(6,3,'In lavorazione','2026-08-12',244.00),(7,4,'In lavorazione','2026-08-12',145.18),(8,3,'In lavorazione','2026-09-20',256.20),(9,4,'In lavorazione','2026-09-20',256.20);
/*!40000 ALTER TABLE `ordine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prodotto`
--

DROP TABLE IF EXISTS `prodotto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodotto` (
  `idProdotto` int NOT NULL AUTO_INCREMENT,
  `prezzo` decimal(10,2) NOT NULL,
  `descrizione` text,
  `disponibilita` tinyint NOT NULL,
  `sconto` decimal(10,2) DEFAULT '0.00',
  `iva` decimal(5,2) NOT NULL DEFAULT '22.00',
  `id_admin` int NOT NULL,
  `nome` varchar(45) NOT NULL,
  `materiale` varchar(500) DEFAULT NULL,
  `colore` varchar(500) DEFAULT NULL,
  `dimensione` varchar(500) DEFAULT NULL,
  `immagine` varchar(255) DEFAULT 'default.jpg',
  `immagine_carosello` varchar(255) DEFAULT NULL,
  `tipo_arma` varchar(50) DEFAULT NULL,
  `tipo_media` varchar(50) DEFAULT NULL,
  `mondo_provenienza` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idProdotto`),
  KEY `admin_prodotto_idx` (`id_admin`),
  CONSTRAINT `fk_prodotto_admin` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`idAdmin`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodotto`
--

LOCK TABLES `prodotto` WRITE;
/*!40000 ALTER TABLE `prodotto` DISABLE KEYS */;
INSERT INTO `prodotto` VALUES (1,300.00,'Cannone al plasma ad altissima tecnologia sviluppato dalla UAC (Union Aerospace Corporation). Spara una massiccia sfera di energia al plasma argenteo-verde che rilascia archi elettrici secondari; polverizza istantaneamente la maggior parte dei nemici nell\'area d\'impatto',1,0.00,22.00,1,'BFG 9000','Plastica ad alta densità','grigio metallizzato','71 cm di lunghezza, 37 cm di larghezza e 33 cm di altezza','bfg9000/card.png','bfg9000/banner.png','Pistola','Videogiochi','Doom'),(2,200.00,'Una coppia di larghe e letali spade legate agli avambracci dell\'utilizzatore tramite catene roventi, forgiate nelle profondità dell\'Oltretomba per ordine di Ares. Rappresentano la servitù e il patto di sangue di Kratos con il Dio della Guerra, marchiando a fuoco la sua pelle. In combattimento vengono scagliate e fatte roteare a grande distanza grazie alle catene, permettendo attacchi acrobatici, ad area e intrisi del Fuoco dell\'Oltretomba (Primordial Fire).',1,0.00,22.00,1,'Lame del Caos','Metallo infernale forgiato nell\'Oltretomba greco e ferro fuso; le catene sono composte da una lega mitologica incandescente incisa sulla carne di chi le impugna.','La lama è di un grigio scuro metallico con venature e incisioni che risplendono di un rosso/arancione incandescente quando attivate dal fuoco. Le else e le impugnature sono rifinite in bronzo dorato e cuoio scuro.','Ogni singola lama misura indicativamente tra i 70 e i 90 cm di lunghezza (la sola parte della spada), mentre le catene collegate si estendono e si allungano per diversi metri durante i fendenti e le rotazioni in combattimento.','lame_del_caos/card.png','lame_del_caos/banner.png','Coltello','Videogiochi','God of war'),(3,150.00,'Katana leggendaria forgiata da Hattori Hanzo, caratterizzata da una lama in acciaio al carbonio e dal distintivo simbolo del leone d\'oro inciso vicino alla guardia.',1,0.00,22.00,1,'Katana di Hattori Hanzo','Lama in acciaio al carbonio; manico (Tsuka) in legno rivestito in pelle di razza (Samegawa) con intreccio in corda nera (Ito); fodero (Saya) in legno laccato lucido.','Lama argento lucido; fodero nero laccato lucido con dettagli e strisce dorate; manico nero su fondo bianco/chiaro.','Lunghezza totale: circa 100 – 103 cm; Lunghezza lama: circa 68 – 72 cm; Lunghezza impugnatura: circa 27 cm; Peso: circa 1,0 – 1,2 kg','kill_bill/card.png','kill_bill/banner.png','Spada','Film','Kill Bill'),(4,50.00,'Incarna lo spirito del Re degli Cecchini con la replica fedele della leggendaria fionda Kabuto di Usopp! Perfetta per cosplayer, collezionisti e veri appassionati della ciurma di Cappello di Paglia, questa riproduzione cattura ogni dettaglio dell\'arma iconica sfoggiata a Enies Lobby.',1,10.00,22.00,1,'Fionda Kabuto di Usopp','Resina e PVC','Verde','Lunghezza totale: 130 cm, Larghezza della testa: 32 cm, Spessore: 8 cm','fionda_usopp/card.png','','Speciali','Anime','One piece'),(5,100.00,'Replica fedele della celebre mannaia smussata utilizzata dallo Stregone di Grado 1 Kento Nanami',1,0.00,22.00,1,'Mannaia Kento Nanami','Lama in acciaio al carbonio con finitura smussata non affilata, completamente avvolta da una fasciatura in tessuto di cotone rinforzato a trama spessa con motivo maculato. Impugnatura anatomica in polimero ABS ad alta densità fissa con rivetti di rinforzo in metallo. Fodero protettivo incluso in ecopelle nera con finiture interne antigraffio, passante da cintura e bottoni a pressione in lega metallica dorata.','Lama ricoperta di fasce a macchie nere e impugnatura nera','Lunghezza totale: 50 cm | Lunghezza lama: 35 cm | Lunghezza impugnatura: 15 cm | Larghezza lama: 8,5 cm | Spessore lama: 4 mm','mannaia_Kaito/card.png',NULL,'Coltello','Anime','Jujutsu Kaisen'),(6,25.00,'Arma tattica da lancio di ordinanza, usata dai ninja del Villaggio della Foglia. Presenta una versatile lama a foglia a doppio filo, bilanciata per il combattimento a corto raggio o per il lancio, e dotata di anello posteriore sagomato per manovre veloci e applicazione di carte bomba.',1,0.00,22.00,1,'Kunai Ninja','Lama in acciaio inossidabile temperato con finitura brunita antiriflesso. Impugnatura rivestita con fasciatura ad alta resistenza in fibra di cotone per massimizzare la presa durante l utilizzo.','Nero opaco con fasciatura dell impugnatura bianca','Lunghezza totale: 25 cm | Lunghezza lama: 13 cm | Diametro anello: 2,5 cm | Spessore lama: 3 mm | Peso: 150 g','kunai_naruto/card.png',NULL,'Coltello','Anime','Naruto'),(7,220.00,'Una delle dodici lame di grado Supremo (Saijo O Wazamono), nota come la spada nera piu potente del mondo. Caratterizzata dalla maestosa elsa a croce e dalla gigantesca lama ricurva a filo singolo, e capace di generare fendenti d energia distruttivi in grado di fendere intere navi da guerra.',1,0.00,22.00,1,'Spada Yoru - Dracule Mihawk','Lama in acciaio ad alto tenore di carbonio con finitura nera brunita a specchio. Elsa crociata in lega metallica finemente lavorata con gemme cabochon incastonate. Impugnatura rivestita in pelle sintetica intrecciata per una presa salda e bilanciata.','Lama nera lucida con elsa dorata e gemme verdi','Lunghezza totale: 145 cm | Lunghezza lama: 110 cm | Larghezza elsa: 45 cm | Spessore lama: 6 mm | Peso: 2,8 kg','spada_mihawk/card.png',NULL,'Spada','Anime','One Piece'),(8,250.00,'Tesoro Sacro intitolato alla fanciulla amata dal sole. Un imponente ascia ad una mano caratterizzata da una gigantesca lama a mezzaluna e da un contrappeso a rosetta, in grado di immagazzinare l immenso calore emesso da chi la impugna per poi sprigionarlo in devastanti attacchi ad area.',1,0.00,22.00,1,'Ascia Divina Rhitta','Struttura massiccia in lega metallica e acciaio inossidabile con rifinitura dorata a specchio. Impugnatura anatomica monoblocco rinforzata per bilanciare la pesante testa dell ascia.','Oro brillante con dettagli metallici finemente lavorati','Lunghezza totale: 150 cm | Larghezza lama: 65 cm | Spessore lama: 8 mm | Peso: 4,2 kg','ascia_escanor/card.png',NULL,'Speciali','Anime','The Seven Deadly Sins'),(9,350.00,'Iconica mitragliatrice pesante a nastro per supporto tattico ad alto volume di fuoco, nota per l impiego nelle missioni d infiltrazione e combattimento nella giungla. Dotata di maniglia di trasporto superiore, bipiede anteriore pieghevole e caricatore laterale per nastro a maglie metalliche.',1,20.00,22.00,1,'Mitragliatrice M60 - Rambo','Castello e canna in lega metallica anodizzata con componenti in acciaio brunito. Calcio, impugnatura a pistola e paramano anteriore realizzati in polimero ad alta densita antishock.','Nero opaco e canna di fucile con nastro proiettili decorativo in finitura ottone','Lunghezza totale: 110 cm | Lunghezza canna: 56 cm | Altezza con bipiede: 35 cm | Peso: 4,2 kg','mitragliatrice_rambo/card.png',NULL,'Pistola','Film','Rambo'),(10,180.00,'Arma mitica incantata forgiata nel cuore di una stella morente. Il leggendario martello da guerra asgardiano presenta un massiccio blocco rettangolare con incisioni runiche sui bordi e un impugnatura rigida con laccio da polso per incanalare e scagliare la potenza del tuono.',1,0.00,22.00,1,'Martello Mjolnir - Thor','Testa metallica in fusione di lega d alluminio zincato con finitura spazzolata a rilievo. Impugnatura rinforzata avvolta in pelle sintetica e cinturino da polso posteriore in cuoio intrecciato.','Argento satinato con impugnatura e cinturino marrone scuro','Lunghezza totale: 44 cm | Testa martello: 22 x 13 x 13 cm | Diametro impugnatura: 4 cm | Peso: 3,5 kg','martello_thor/card.png',NULL,'Speciali','Film','Marvel'),(11,150.00,'Elegante arma a energia dei Cavalieri Jedi e dei Signori dei Sith, dotata di una potente lama di plasma puro emessa da un elsa cilindrica metallica. Capace di fendere quasi ogni materiale, e alimentata da un cristallo Kyber interno ed equipaggiata con pulsanti di attivazione e gancio da cintura.',1,0.00,22.00,1,'Spada Laser Skywalker - Star Wars','Elsa lavorata in lega di alluminio di grado aeronautico lavorato a CNC con finiture cromate e dettagli in gomma antiscivolo. Lama rimovibile in policarbonato ad alta resistenza agli impatti.','Elsa argento e nera con lama luminescente blu','Lunghezza totale: 110 cm | Lunghezza elsa: 28 cm | Lunghezza lama: 82 cm | Diametro elsa: 3,8 cm | Peso: 850 g','spada_laser_starwars/card.png',NULL,'Spada','Film','Star Wars'),(12,210.00,'Tragicamente nota e inconfondibile arma-utensile utilizzata da Leatherface. Presenta un corpo motore a scoppio stile vintage con maniglia di avviamento a strappo, doppia impugnatura di manovra e una lunga barra guida avvolta da una catena dentata con dettagliati effetti di invecchiamento e usura.',1,0.00,22.00,1,'Motosega di Leatherface','Scocca in lega metallica e resina polimerica ad alta densita con finitura invecchiata a mano. Barra di guida e catena decorativa in acciaio spazzolato con patine antiruggine ed effetti di pittura realistici.','Giallo canarino vintage usurato con dettagli grigio metallo e ruggine','Lunghezza totale: 85 cm | Lunghezza barra: 45 cm | Larghezza corpo: 25 cm | Peso: 3,8 kg','motosega_leatherface/card.png',NULL,'Speciale','Film','Non Aprite Quella Porta'),(13,190.00,'La Spada Suprema del Ricetto, incantata e forgiata per respingere l oscurita. Presenta la leggendaria elsa a forma di ali spiegate con gemma centrale, finitura della guardia in rilievo e la lama a doppio filo incisa con il simbolo sacro della Triforza alla base.',1,0.00,22.00,1,'Master Sword - Legend of Zelda','Lama in acciaio inossidabile 440 con incisioni laser a rilievo. Elsa e guardia in lega metallica di zama con dettagli smaltati e impugnatura rivestita in pelle sintetica intrecciata.','Lama argento satinato con elsa blu cobalto e dettagli dorati','Lunghezza totale: 105 cm | Lunghezza lama: 78 cm | Larghezza elsa: 22 cm | Spessore lama: 4 mm | Peso: 1,8 kg','spada_master_zelda/card.png',NULL,'Spada','Videogiochi','The Legend of Zelda'),(15,170.00,'Devastante pistola magnum ad alto calibro progettata per l arresto immediato di minacce biologiche ad alto rischio. Presenta una canna rinforzata con contrappeso anteriore, tamburo ad alta capacita e slitta superiore per il montaggio di sistemi di puntamento tattici.',1,15.00,22.00,1,'Magnum Requiem - Resident Evil','Castello e canna in lega metallica ad alta densita con finitura satinata e componenti in acciaio. Impugnatura anatomica rivestita in polimero antiscivolo con texture ad alto grip.','Nero canna di fucile con dettagli argento e impugnatura nera','Lunghezza totale: 29 cm | Lunghezza canna: 15 cm | Altezza: 16 cm | Spessore: 4 cm | Peso: 1,2 kg','magnum_requiem_re/card.png','','Pistola','Videogiochi','Resident Evil'),(16,150.00,'Fucile da assalto automatico ad alte prestazioni, leggendario per la sua straordinaria precisione e potenza di fuoco sulla media e lunga distanza. Dotato di mirino di puntamento metallico, selettore di fuoco, caricatore curvo ad estrazione rapida e calcio posteriore rinforzato per la massima stabilita.',1,0.00,22.00,1,'Fucile SCAR Leggendario - Fortnite','Scocca esterna in resina ABS e polimeri ad alta resistenza agli urti con componenti e canna interna in lega metallica rinforzata.','Giallo ocra tattico con dettagli nero opaco e canna grigio scuro','Lunghezza totale: 82 cm | Altezza: 28 cm | Spessore: 7 cm | Peso: 1,9 kg','scar_fortnite/card.png',NULL,'Pistola','Videogiochi','Fortnite');
/*!40000 ALTER TABLE `prodotto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente` (
  `idUtente` int NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `nome` varchar(45) DEFAULT NULL,
  `cognome` varchar(45) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`idUtente`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'test1782832486029@lootverse.it','password_test_hash','Mario','Rossi',NULL),(2,'utente1783354475550@lootverse.it','utente_hash_test','Mario','Rossi',NULL),(3,'giovanniunir@gmail.com','55bc86b162bea2f62fbf9be40f9e29046777f58188a7d67ec538adcd42d54cdf4162d562d1aa4b9ca592d19e873968b7e0635b94fd9efcacce1cd2467d764445','Giovanni','Unir','+393333333333'),(4,'danielprocio@gmail.com','ca96ab07652d743c8412b362c9497732f09a5eab4f45c1eaa2360b28fdd7d856bda1c5e1b40a3589f674b5f4d71103d7fdb737231bacb79686c22456c2f4e52a','Daniel','Procio','+393368750789');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-22 23:13:45
