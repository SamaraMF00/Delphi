CREATE DATABASE  IF NOT EXISTS `bdvendas` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `bdvendas`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: bdvendas
-- ------------------------------------------------------
-- Server version	5.7.10-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cabecalho_pedido`
--

DROP TABLE IF EXISTS `cabecalho_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cabecalho_pedido` (
  `NUMPEDIDO` int(11) NOT NULL AUTO_INCREMENT,
  `DATAEMISSAO` datetime DEFAULT NULL,
  `CODCLIENTE` int(11) DEFAULT NULL,
  `VALORTOTAL` float DEFAULT NULL,
  PRIMARY KEY (`NUMPEDIDO`),
  KEY `idx_NumPedido` (`NUMPEDIDO`),
  KEY `fk_Cliente` (`CODCLIENTE`),
  CONSTRAINT `fk_Cliente` FOREIGN KEY (`CODCLIENTE`) REFERENCES `cliente` (`CODCLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cabecalho_pedido`
--

LOCK TABLES `cabecalho_pedido` WRITE;
/*!40000 ALTER TABLE `cabecalho_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `cabecalho_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliente` (
  `CODCLIENTE` int(11) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(30) DEFAULT NULL,
  `CIDADE` varchar(30) DEFAULT NULL,
  `UF` char(2) DEFAULT NULL,
  PRIMARY KEY (`CODCLIENTE`),
  KEY `idx_cliente` (`CODCLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Ana Luiza','Sarzedo','MG'),(2,'Arnaldo','Betim','MG'),(3,'Aroldo','Ibirité','MG'),(4,'Atos','Brumadinho','MG'),(5,'Beatriz','Sarzedo','MG'),(6,'Bianca','Mario Campos','MG'),(7,'Bruna','Ibirité','MG'),(8,'Bruno','Sarzedo','MG'),(9,'Breno','Barreiro','MG'),(10,'Caio','Sarzedo','MG'),(11,'Carlos','Guarulhos','SP'),(12,'Carla','Montes Claros','MG'),(13,'Clarisse','Sarzedo','MG'),(14,'Camila','Osasco','SP'),(15,'Luiza','Ibirité','MG'),(16,'Marina','Sarzedo','MG'),(17,'Mariana','Belo Horizonte','MG'),(18,'Maria','Mauá','SP'),(19,'Marcos','Sarzedo','MG'),(20,'Samara','Ibirité','MG'),(21,'William','Sarzedo','MG');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itens_pedido`
--

DROP TABLE IF EXISTS `itens_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itens_pedido` (
  `IDITEM` int(11) NOT NULL AUTO_INCREMENT,
  `NUMPEDIDO` int(11) DEFAULT NULL,
  `CODPROD` int(11) DEFAULT NULL,
  `QUANTIDADE` int(11) DEFAULT NULL,
  `VLRUNITARIO` float DEFAULT NULL,
  `VLRTOTAL` float DEFAULT NULL,
  PRIMARY KEY (`IDITEM`),
  KEY `fk_Produto` (`CODPROD`),
  KEY `idx_NumPedido` (`NUMPEDIDO`),
  CONSTRAINT `fk_Pedido` FOREIGN KEY (`NUMPEDIDO`) REFERENCES `cabecalho_pedido` (`NUMPEDIDO`),
  CONSTRAINT `fk_Produto` FOREIGN KEY (`CODPROD`) REFERENCES `produtos` (`CODPROD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itens_pedido`
--

LOCK TABLES `itens_pedido` WRITE;
/*!40000 ALTER TABLE `itens_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `itens_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produtos` (
  `CODPROD` int(11) NOT NULL AUTO_INCREMENT,
  `DESCRICAO` varchar(30) DEFAULT NULL,
  `PRECOVENDA` float DEFAULT NULL,
  PRIMARY KEY (`CODPROD`),
  KEY `idx_CodProd` (`CODPROD`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Monitor 15.6\' preto',710),(2,'Monitor 18.5\' grafit',650.91),(3,'Teclado mecânico Dell',1000),(4,'Teclado comum preto',100),(5,'Teclado gamer branco',940),(6,'Mouse sem fio preto',530.5),(7,'Mouse sem fio gamer',719),(8,'Mouse comum Dell',150),(9,'Cadeira de escritório',600),(10,'Cadeira reclinável',810),(11,'Cadeira gamer comum',790.99),(12,'Cadeira gamer ajustável',960),(13,'Apoio para os pés',150),(14,'Apoio para os pés ajustável',360),(15,'Caneca comum gamer',56),(16,'Caneca personalizada',90),(17,'Copo térmico',150),(18,'Fone de ouvido comum',59),(19,'Fone de ouvido sem fio',80.5),(20,'Fone de ouvido gamer',260);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bdvendas'
--

--
-- Dumping routines for database 'bdvendas'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-29  8:13:43
