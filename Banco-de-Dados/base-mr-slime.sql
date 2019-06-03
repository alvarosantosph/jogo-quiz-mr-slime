
#
# Structure for table "categorias"
#

DROP TABLE IF EXISTS `categorias`;
CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL AUTO_INCREMENT,
  `categoria` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;

#
# Structure for table "player"
#

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id_player` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `pontuacao` decimal(10,0) DEFAULT '0',
  PRIMARY KEY (`id_player`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8;

#
# Structure for table "partida"
#

DROP TABLE IF EXISTS `partida`;
CREATE TABLE `partida` (
  `id_partida` int(11) NOT NULL AUTO_INCREMENT,
  `id_player` int(11) DEFAULT NULL,
  `pontuacao_partida` decimal(10,0) DEFAULT NULL,
  `data_ini_partida` datetime DEFAULT NULL,
  `duracao_partida` int(11) DEFAULT NULL,
  `duracao_perguntas` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_partida`),
  KEY `id_player` (`id_player`),
  CONSTRAINT `partida_ibfk_1` FOREIGN KEY (`id_player`) REFERENCES `player` (`id_player`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for table "respostas_correta"
#

DROP TABLE IF EXISTS `respostas_correta`;
CREATE TABLE `respostas_correta` (
  `id_resposta` int(11) NOT NULL AUTO_INCREMENT,
  `resposta_correta` varchar(300) DEFAULT NULL,
  `letra_resposta_correta` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_resposta`)
) ENGINE=InnoDB AUTO_INCREMENT=542 DEFAULT CHARSET=utf8;

#
# Structure for table "perguntas"
#

DROP TABLE IF EXISTS `perguntas`;
CREATE TABLE `perguntas` (
  `id_pergunta` int(11) NOT NULL AUTO_INCREMENT,
  `id_resposta` int(11) DEFAULT NULL,
  `questao` varchar(500) DEFAULT NULL,
  `letra_a` varchar(300) DEFAULT NULL,
  `letra_b` varchar(300) DEFAULT NULL,
  `letra_c` varchar(300) DEFAULT NULL,
  `letra_d` varchar(300) DEFAULT NULL,
  `pontuacao_pergunta` int(11) DEFAULT '5',
  `nivel_dificuldade` int(11) DEFAULT '1',
  PRIMARY KEY (`id_pergunta`),
  KEY `id_resposta` (`id_resposta`),
  CONSTRAINT `perguntas_ibfk_1` FOREIGN KEY (`id_resposta`) REFERENCES `respostas_correta` (`id_resposta`)
) ENGINE=InnoDB AUTO_INCREMENT=512 DEFAULT CHARSET=utf8;

#
# Structure for table "pergunta_categoria"
#

DROP TABLE IF EXISTS `pergunta_categoria`;
CREATE TABLE `pergunta_categoria` (
  `id_categoria` int(11) DEFAULT NULL,
  `id_pergunta` int(11) DEFAULT NULL,
  KEY `id_categoria` (`id_categoria`),
  KEY `id_pergunta` (`id_pergunta`),
  CONSTRAINT `pergunta_categoria_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  CONSTRAINT `pergunta_categoria_ibfk_2` FOREIGN KEY (`id_pergunta`) REFERENCES `perguntas` (`id_pergunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Structure for table "users"
#

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# View "selecionar_categorias"
#

DROP VIEW IF EXISTS `selecionar_categorias`;
CREATE
  ALGORITHM = UNDEFINED
  VIEW `selecionar_categorias`
  AS
  SELECT
    `categorias`.`id_categoria` AS 'identificador', `categorias`.`categoria`, `pergunta_categoria`.`id_categoria` AS 'identificador_cat_pergunta', `pergunta_categoria`.`id_pergunta` AS 'identificador_pergunta'
  FROM
    (`categorias`
      JOIN `pergunta_categoria` ON ((`categorias`.`id_categoria` = `pergunta_categoria`.`id_categoria`)));

#
# View "selecionar_perguntas"
#

DROP VIEW IF EXISTS `selecionar_perguntas`;
CREATE
  ALGORITHM = UNDEFINED
  VIEW `selecionar_perguntas`
  AS
  SELECT
    `pe`.`id_pergunta`,
    `pe`.`questao` AS 'QUESTAO',
    `pe`.`letra_a` AS 'LETRA_A',
    `pe`.`letra_b` AS 'LETRA_B',
    `pe`.`letra_c` AS 'LETRA_C',
    `pe`.`letra_d` AS 'LETRA_D',
    `pe`.`nivel_dificuldade` AS 'DIFICULDADE',
    `re`.`resposta_correta` AS 'RESPOSTA_CORRETA',
    `re`.`letra_resposta_correta` AS 'LETRA_RESPOSTA_CORRETA',
    `ct`.`categoria` AS 'CATEGORIA',
    `ct`.`id_categoria`
  FROM
    (((`respostas_correta` re
      JOIN `perguntas` pe ON ((`re`.`id_resposta` = `pe`.`id_resposta`)))
      JOIN `pergunta_categoria` pc ON ((`pe`.`id_pergunta` = `pc`.`id_pergunta`)))
      JOIN `categorias` ct ON ((`pc`.`id_categoria` = `ct`.`id_categoria`)));
