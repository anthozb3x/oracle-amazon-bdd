/*
-- Création du USER SQL
alter session
    set
    "_ORACLE_SCRIPT" = true;

CREATE USER "AMAZONDATABASE" IDENTIFIED BY "MDPAMAZONDATABASE";

ALTER USER "AMAZONDATABASE" DEFAULT TABLESPACE "USERS" TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK;

-- SYSTEM PRIVILEGES
GRANT CREATE TRIGGER TO "AMAZONDATABASE";

GRANT CREATE PROCEDURE TO  "AMAZONDATABASE";

GRANT CREATE ANY INDEX TO "AMAZONDATABASE";

GRANT CREATE VIEW TO "AMAZONDATABASE";

GRANT CREATE SESSION TO "AMAZONDATABASE";

GRANT
    SELECT
    ANY TABLE TO "AMAZONDATABASE";

GRANT DELETE ANY TABLE TO "AMAZONDATABASE";

GRANT CREATE TABLE TO "AMAZONDATABASE";

GRANT DROP ANY TABLE TO "AMAZONDATABASE";

GRANT UNDER ANY TYPE TO "AMAZONDATABASE";

GRANT CREATE TYPE TO "AMAZONDATABASE";

GRANT DROP ANY TYPE TO "AMAZONDATABASE";

GRANT EXECUTE ANY PROCEDURE TO "AMAZONDATABASE";

SET SERVEROUTPUT ON;
GRANT UNLIMITED TABLESPACE TO "AMAZONDATABASE";

GRANT EXECUTE ANY PROGRAM TO "AMAZONDATABASE";

GRANT EXECUTE ANY TYPE TO "AMAZONDATABASE";

GRANT DROP ANY INDEX TO "AMAZONDATABASE";

GRANT
    UPDATE
    ANY TABLE TO "AMAZONDATABASE";

GRANT DROP ANY VIEW TO "AMAZONDATABASE";

GRANT UNDER ANY VIEW TO "AMAZONDATABASE";

GRANT GRANT ANY PRIVILEGE TO "AMAZONDATABASE"; -- Crée la base de données AMAZON_DATABSE et ce connecter avec l'user configurer juste au dessus
*/

-- Drop toutes les tables
-- Drop all tables
BEGIN
    FOR table_rec IN (SELECT table_name FROM user_tables) LOOP
            EXECUTE IMMEDIATE 'DROP TABLE ' || table_rec.table_name || ' CASCADE CONSTRAINTS';
        END LOOP;
END;
/


-- Créé la table UTILISATEUR

CREATE TABLE "AMAZONDATABASE"."UTILISATEUR"
(
    "UTILISATEUR_UID" VARCHAR2(200 BYTE) NOT NULL ENABLE,
	"UTILISATEUR_ID" NUMBER NOT NULL ENABLE,
	"NOM" VARCHAR2(200 BYTE) NOT NULL ENABLE,
	"PRENOM" VARCHAR2(200 BYTE) NOT NULL ENABLE,
	"EMAIL" VARCHAR2(255 BYTE) NOT NULL ENABLE,
	"EST_VENDEUR" NUMBER DEFAULT 0 NOT NULL ENABLE,
	"DATE_CREATION" DATE NOT NULL ENABLE,
	"DATE_SUPRESSION" DATE,
	 CONSTRAINT "UTILISATEUR_PK" PRIMARY KEY ("UTILISATEUR_UID")
	     USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255,
	 CONSTRAINT "UTILISATEUR_UK_EMAIL" UNIQUE ("EMAIL")
	     USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS ENABLE
);
-- creatiion des tables
CREATE TABLE CONVERSATION
(
    CONVERSATION_UID VARCHAR2(255) NOT NULL,
    CONVERSATION_ID VARCHAR2(255) NOT NULL,
    COLUMN1 VARCHAR2(255) NOT NULL,
    CONSTRAINT CONVERSATION_PK PRIMARY KEY(CONVERSATION_UID) ENABLE
);

CREATE TABLE MESSAGE
(
  MESSAGE_UID VARCHAR2(255 BYTE) NOT NULL,
  MESSAGE_ID VARCHAR2(255 BYTE) NOT NULL,
  CONVERSATION_UID VARCHAR2(255 BYTE) NOT NULL,
  UTILISATEUR_DESTINATAIRE_UID VARCHAR2(255 BYTE) NOT NULL,
  UTILISATEUR_EXPEDITEUR_UID VARCHAR2(255 BYTE) NOT NULL,
  DATE_MESSAGE DATE NOT NULL,
  MESSAGE CLOB NOT NULL,
  CONSTRAINT MESSAGE_PK PRIMARY KEY (MESSAGE_UID),
  CONSTRAINT MESSAGE_FK_UTILISATEUR_EXPEDITEUR FOREIGN KEY (UTILISATEUR_EXPEDITEUR_UID)
    REFERENCES UTILISATEUR (UTILISATEUR_UID)
    ENABLE,
  CONSTRAINT MESSAGE_FK_UTILISATEUR_DESTINATAIRE FOREIGN KEY (UTILISATEUR_DESTINATAIRE_UID)
    REFERENCES UTILISATEUR (UTILISATEUR_UID)
    ENABLE
);

CREATE TABLE ADRESSE
(
  ADRESSE_UID VARCHAR2(255) NOT NULL
, ADRESSE_ID VARCHAR2(255) NOT NULL
, ADRESSE_POSTALE VARCHAR2(255) NOT NULL
, EST_FAVORITE NUMBER DEFAULT 0 NOT NULL
, DATE_CREATION DATE NOT NULL
, DATE_SUPPRESSION DATE
, CONSTRAINT ADRESSE_PK PRIMARY KEY
  (
    ADRESSE_UID
  )
  ENABLE
);

CREATE TABLE HISTORIQUE_ADRESSE
(
  HISTORIQUE_ADRESSE_UID VARCHAR2(255) NOT NULL,
  ID NUMBER NOT NULL,
  ADRESSE_INITIAL_UID VARCHAR2(255) NOT NULL,
  ADRESSE_UID VARCHAR2(255) NOT NULL,
  CONSTRAINT HISTORIQUE_ADRESSE_PK PRIMARY KEY (HISTORIQUE_ADRESSE_UID),
  CONSTRAINT HISTORIQUE_ADRESSE_FK1 FOREIGN KEY (ADRESSE_UID)
    REFERENCES ADRESSE (ADRESSE_UID)
    ENABLE,
  CONSTRAINT HISTORIQUE_ADRESSE_FK2 FOREIGN KEY (ADRESSE_INITIAL_UID)
    REFERENCES ADRESSE (ADRESSE_UID)
    ENABLE
);

CREATE TABLE COMMANDE
(
  COMMANDE_UID VARCHAR2(255) NOT NULL,
  COMMANDE_DATE DATE NOT NULL,
  UTILISATEUR_ACHETEUR_UID VARCHAR2(255) NOT NULL,
  UTILISATEUR_VENDEUR_UID VARCHAR2(255) NOT NULL,
  ADRESSE_EXPEDITION_UID VARCHAR2(255) NOT NULL,
  ADRESSE_DESTINANTION_UID VARCHAR2(255) NOT NULL,
  CONSTRAINT COMMANDE_PK PRIMARY KEY (COMMANDE_UID),
  CONSTRAINT COMMANDE_FK_ADRESSE_DESTINATION FOREIGN KEY (ADRESSE_DESTINANTION_UID)
    REFERENCES ADRESSE (ADRESSE_UID)
    ENABLE,
  CONSTRAINT COMMANDE_FK_ADRESSE_EXPEDITION FOREIGN KEY (ADRESSE_EXPEDITION_UID)
    REFERENCES ADRESSE (ADRESSE_UID)
    ENABLE,
  CONSTRAINT COMMANDE_FK_UTILISATEUR_ACHETEUR FOREIGN KEY (UTILISATEUR_ACHETEUR_UID)
    REFERENCES UTILISATEUR (UTILISATEUR_UID)
    ENABLE,
  CONSTRAINT COMMANDE_FK_UTILISATEUR_VENDEUR FOREIGN KEY (UTILISATEUR_VENDEUR_UID)
    REFERENCES UTILISATEUR (UTILISATEUR_UID)
    ENABLE
);

CREATE TABLE ARTICLE
(
  ARTICLE_UID VARCHAR2(255) NOT NULL
, ARTICLE_ID VARCHAR2(255) NOT NULL
, ARTICLE_NOM VARCHAR2(255) NOT NULL
, ARTICLE_DESCRIPTION VARCHAR2(255) NOT NULL
, ARTICLE_PRIX NUMBER NOT NULL
, ARTICLE_PHOTO VARCHAR2(255) NOT NULL
, ARTICLE_NOTE NUMBER
, ARTICLE_DATE_CREATION DATE NOT NULL
, ARTICLE_DATE_SUPPRESSION DATE
, CONSTRAINT ARTICLE_PK PRIMARY KEY
  (
    ARTICLE_UID
  )
  ENABLE
);

CREATE TABLE CATEGORIES
(
  CATEGORIES_ID VARCHAR2(255) NOT NULL
, CATEGORIE_UID VARCHAR2(255) NOT NULL
, CATEGORIE_NOM VARCHAR2(255) NOT NULL
, CATEGORIE_DESCRIPTION CLOB NOT NULL
, CONSTRAINT CATEGORIE_PK PRIMARY KEY
  (
    CATEGORIE_ID
  )
  ENABLE
);

CREATE TABLE SOUHAITS
(
  SOUHAITS_ID VARCHAR2(255) NOT NULL,
  SOUHAITS_UID VARCHAR2(255) NOT NULL,
  SOUHAITS_UTILISATEUR_UID VARCHAR2(255) NOT NULL,
  SOUHAITS_DATE_AJOUT DATE NOT NULL,
  SOUHAITS_DATE_SUPPRESSION DATE,  
  SOUHAITS_COMMANDE_UID VARCHAR2(255),
  SOUHAITS_ARTICLE_UID VARCHAR2(255) NOT NULL,
  SOUHAITS_QUANTITÉ VARCHAR2(255),

  CONSTRAINT SOUHAITS_PK PRIMARY KEY (SOUHAITS_UID),

  CONSTRAINT SOUHAITS_ARTICLE_FK FOREIGN KEY (SOUHAITS_ARTICLE_UID)
    REFERENCES ARTICLE (ARTICLE_UID) ENABLE,
  CONSTRAINT SOUHAITS_COMMANDE_FK FOREIGN KEY (SOUHAITS_COMMANDE_UID)
    REFERENCES COMMANDE (COMMANDE_UID) ENABLE,
  CONSTRAINT SOUHAITS_UTILISATEUR_FK FOREIGN KEY (SOUHAITS_UTILISATEUR_UID)
    REFERENCES UTILISATEUR (UTILISATEUR_UID) ENABLE
);

CREATE TABLE COMMANDE_ARTICLE
(
  COMMANDE_ARTICLE_UID VARCHAR2(255) NOT NULL,
  COMMANDE_ARTICLE_ID VARCHAR2(255) NOT NULL,
  COMMANDE_UID VARCHAR2(255) NOT NULL,
  QUANTITÉ NUMBER NOT NULL,
  COMMANDE_ARTICLE_ARTICLE_UID VARCHAR2(255) NOT NULL,

  CONSTRAINT COMMANDE_ARTICLE_PK PRIMARY KEY (COMMANDE_ARTICLE_UID),

  CONSTRAINT COMMANDE_ARTICLE_ARTICLE_FK FOREIGN KEY (COMMANDE_ARTICLE_ARTICLE_UID)
    REFERENCES ARTICLE (ARTICLE_UID) ENABLE,
  CONSTRAINT COMMANDE_ARTICLE_COMMANDE_FK FOREIGN KEY (COMMANDE_UID)
    REFERENCES COMMANDE (COMMANDE_UID) ENABLE
);


CREATE TABLE ARTICLE_CATEGORIE
(
  ARTICLE_CATEGORIE_UID VARCHAR2(255) NOT NULL,
  ARTICLE_CATEGORIE_ID VARCHAR2(255) NOT NULL,
  ARTICLE_CATEGORIE_ARTICLE_UID VARCHAR2(20),
  ARTICLE_CATEGORIE_CATEGORIE_UID VARCHAR2(255) NOT NULL,

  CONSTRAINT ARTICLE_CATEGORIE_PK PRIMARY KEY (ARTICLE_CATEGORIE_UID),

  CONSTRAINT ARTICLE_CATEGORIE_ARTICLE_FK FOREIGN KEY (ARTICLE_CATEGORIE_ARTICLE_UID)
    REFERENCES ARTICLE (ARTICLE_UID),
  CONSTRAINT ARTICLE_CATEGORIE_CATEGORIE_FK FOREIGN KEY (ARTICLE_CATEGORIE_CATEGORIE_UID)
    REFERENCES CATEGORIE (CATEGORIE_ID)
);


-- -- Getter Categorie
-- CREATE OR REPLACE PROCEDURE get_categorie (
--     p_categorie_id IN VARCHAR2,
--     p_categorie_uid OUT VARCHAR2,
--     p_categorie_nom OUT VARCHAR2,
--     p_categorie_description OUT CLOB
-- ) AS
-- BEGIN
--     SELECT CATEGORIE_UID, CATEGORIE_NOM, CATEGORIE_DESCRIPTION
--     INTO p_categorie_uid, p_categorie_nom, p_categorie_description
--     FROM CATEGORIE
--     WHERE CATEGORIE_ID = p_categorie_id;
-- END get_categorie;
-- /

-- -- Setter Categorie
-- CREATE OR REPLACE PROCEDURE set_categorie (
--     p_categorie_id IN VARCHAR2,
--     p_categorie_uid IN VARCHAR2,
--     p_categorie_nom IN VARCHAR2,
--     p_categorie_description IN CLOB
-- ) AS
-- BEGIN
--     UPDATE CATEGORIE
--     SET CATEGORIE_UID = p_categorie_uid,
--         CATEGORIE_NOM = p_categorie_nom,
--         CATEGORIE_DESCRIPTION = p_categorie_description
--     WHERE CATEGORIE_ID = p_categorie_id;
-- END set_categorie;
-- /

-- -- Getter Article_Categorie
-- CREATE OR REPLACE PROCEDURE get_article_categorie (
--     p_article_categorie_uid IN VARCHAR2,
--     p_article_categorie_id OUT VARCHAR2,
--     p_article_categorie_article_uid OUT VARCHAR2,
--     p_article_categorie_categorie_uid OUT VARCHAR2
-- ) AS
-- BEGIN
--     SELECT ARTICLE_CATEGORIE_ID, ARTICLE_CATEGORIE_ARTICLE_UID, ARTICLE_CATEGORIE_CATEGORIE_UID
--     INTO p_article_categorie_id, p_article_categorie_article_uid, p_article_categorie_categorie_uid
--     FROM ARTICLE_CATEGORIE
--     WHERE ARTICLE_CATEGORIE_UID = p_article_categorie_uid;
-- END get_article_categorie;
-- /

-- -- Setter Article_Categorie
-- CREATE OR REPLACE PROCEDURE set_article_categorie (
--     p_article_categorie_uid IN VARCHAR2,
--     p_article_categorie_id IN VARCHAR2,
--     p_article_categorie_article_uid IN VARCHAR2,
--     p_article_categorie_categorie_uid IN VARCHAR2
-- ) AS
-- BEGIN
--     UPDATE ARTICLE_CATEGORIE
--     SET ARTICLE_CATEGORIE_ID = p_article_categorie_id,
--         ARTICLE_CATEGORIE_ARTICLE_UID = p_article_categorie_article_uid,
--         ARTICLE_CATEGORIE_CATEGORIE_UID = p_article_categorie_categorie_uid
--     WHERE ARTICLE_CATEGORIE_UID = p_article_categorie_uid;
-- END set_article_categorie;
-- /

-- -- Getter Article
-- CREATE OR REPLACE PROCEDURE get_article (
--     p_article_uid IN VARCHAR2,
--     p_article_id OUT VARCHAR2,
--     p_article_nom OUT VARCHAR2,
--     p_article_description OUT VARCHAR2,
--     p_article_prix OUT NUMBER,
--     p_article_photo OUT VARCHAR2,
--     p_article_note OUT NUMBER,
--     p_article_date_creation OUT DATE,
--     p_article_date_suppression OUT DATE
-- ) AS
-- BEGIN
--     SELECT ARTICLE_ID, ARTICLE_NOM, ARTICLE_DESCRIPTION, ARTICLE_PRIX,
--            ARTICLE_PHOTO, ARTICLE_NOTE, ARTICLE_DATE_CREATION, ARTICLE_DATE_SUPPRESSION
--     INTO p_article_id, p_article_nom, p_article_description, p_article_prix,
--          p_article_photo, p_article_note, p_article_date_creation, p_article_date_suppression
--     FROM ARTICLE
--     WHERE ARTICLE_UID = p_article_uid;
-- END get_article;
-- /

-- --  Setter Article
-- CREATE OR REPLACE PROCEDURE set_article (
--     p_article_uid IN VARCHAR2,
--     p_article_id IN VARCHAR2,
--     p_article_nom IN VARCHAR2,
--     p_article_description IN VARCHAR2,
--     p_article_prix IN NUMBER,
--     p_article_photo IN VARCHAR2,
--     p_article_note IN NUMBER,
--     p_article_date_creation IN DATE,
--     p_article_date_suppression IN DATE
-- ) AS
-- BEGIN
--     UPDATE ARTICLE
--     SET ARTICLE_ID = p_article_id,
--         ARTICLE_NOM = p_article_nom,
--         ARTICLE_DESCRIPTION = p_article_description,
--         ARTICLE_PRIX = p_article_prix,
--         ARTICLE_PHOTO = p_article_photo,
--         ARTICLE_NOTE = p_article_note,
--         ARTICLE_DATE_CREATION = p_article_date_creation,
--         ARTICLE_DATE_SUPPRESSION = p_article_date_suppression
--     WHERE ARTICLE_UID = p_article_uid;
-- END set_article;
-- /

-- --  Getter Souhait
-- CREATE OR REPLACE PROCEDURE get_souhait (
--     p_souhait_uid IN VARCHAR2,
--     p_souhait_id OUT VARCHAR2,
--     p_utilisateur_uid OUT VARCHAR2,
--     p_date_ajout OUT DATE,
--     p_date_suppression OUT DATE,
--     p_commande_uid OUT VARCHAR2,
--     p_article_uid OUT VARCHAR2,
--     p_quantite OUT VARCHAR2
-- ) AS
-- BEGIN
--     SELECT SOUHAITS_ID, SOUHAITS_UTILISATEUR_UID, SOUHAITS_DATE_AJOUT,
--            SOUHAITS_DATE_SUPPRESSION, SOUHAITS_COMMANDE_UID, SOUHAITS_ARTICLE_UID,
--            SOUHAITS_QUANTITE
--     INTO p_souhait_id, p_utilisateur_uid, p_date_ajout, p_date_suppression,
--          p_commande_uid, p_article_uid, p_quantite
--     FROM SOUHAITS
--     WHERE SOUHAITS_UID = p_souhait_uid;
-- END get_souhait;
-- /

-- -- Setter Souhait
-- CREATE OR REPLACE PROCEDURE set_souhait (
--     p_souhait_uid IN VARCHAR2,
--     p_souhait_id IN VARCHAR2,
--     p_utilisateur_uid IN VARCHAR2,
--     p_date_ajout IN DATE,
--     p_date_suppression IN DATE,
--     p_commande_uid IN VARCHAR2,
--     p_article_uid IN VARCHAR2,
--     p_quantite IN VARCHAR2
-- ) AS
-- BEGIN
--     UPDATE SOUHAITS
--     SET SOUHAITS_ID = p_souhait_id,
--         SOUHAITS_UTILISATEUR_UID = p_utilisateur_uid,
--         SOUHAITS_DATE_AJOUT = p_date_ajout,
--         SOUHAITS_DATE_SUPPRESSION = p_date_suppression,
--         SOUHAITS_COMMANDE_UID = p_commande_uid,
--         SOUHAITS_ARTICLE_UID = p_article_uid,
--         SOUHAITS_QUANTITE = p_quantite
--     WHERE SOUHAITS_UID = p_souhait_uid;
-- END set_souhait;
-- /

-- -- Getter Commande_Article

-- CREATE OR REPLACE FUNCTION get_commande_article (
--     p_commande_article_uid IN VARCHAR2
-- ) RETURN NUMBER AS
--     v_quantite NUMBER;
-- BEGIN
--     SELECT QUANTITE INTO v_quantite
--     FROM V_COMMANDE_ARTICLE
--     WHERE COMMANDE_ARTICLE_UID = p_commande_article_uid;
--     RETURN v_quantite;
-- END get_commande_article;
-- /


-- -- Setter Commande_Article

-- CREATE OR REPLACE PROCEDURE set_commande_article (
--     p_commande_article_uid IN VARCHAR2,
--     p_quantite IN NUMBER
-- ) AS
-- BEGIN
--     UPDATE V_COMMANDE_ARTICLE
--     SET QUANTITE = p_quantite
--     WHERE COMMANDE_ARTICLE_UID = p_commande_article_uid;
-- END set_commande_article;
-- /

-- Accesseurs CATEGORIE

-- INSERT
CREATE OR REPLACE PROCEDURE insert_categorie (
    p_categorie_id IN VARCHAR2,
    p_categorie_uid IN VARCHAR2,
    p_categorie_nom IN VARCHAR2,
    p_categorie_description IN CLOB
) AS
BEGIN
    INSERT INTO CATEGORIE (CATEGORIE_ID, CATEGORIE_UID, CATEGORIE_NOM, CATEGORIE_DESCRIPTION)
    VALUES (p_categorie_id, p_categorie_uid, p_categorie_nom, p_categorie_description);
END insert_categorie;
/

-- DELETE
CREATE OR REPLACE PROCEDURE delete_categorie (
    p_categorie_id IN VARCHAR2
) AS
BEGIN
    DELETE FROM CATEGORIE
    WHERE CATEGORIE_ID = p_categorie_id;
END delete_categorie;
/

-- UPDATE
CREATE OR REPLACE PROCEDURE update_categorie (
    p_categorie_id IN VARCHAR2,
    p_categorie_uid IN VARCHAR2,
    p_categorie_nom IN VARCHAR2,
    p_categorie_description IN CLOB
) AS
BEGIN
    UPDATE CATEGORIE
    SET CATEGORIE_UID = p_categorie_uid,
        CATEGORIE_NOM = p_categorie_nom,
        CATEGORIE_DESCRIPTION = p_categorie_description
    WHERE CATEGORIE_ID = p_categorie_id;
END update_categorie;
/

-- GET
CREATE OR REPLACE PROCEDURE get_categorie_info (
    p_categorie_id IN VARCHAR2,
    p_categorie_uid OUT VARCHAR2,
    p_categorie_nom OUT VARCHAR2,
    p_categorie_description OUT CLOB
) AS
BEGIN
    SELECT CATEGORIE_UID, CATEGORIE_NOM, CATEGORIE_DESCRIPTION
    INTO p_categorie_uid, p_categorie_nom, p_categorie_description
    FROM CATEGORIE
    WHERE CATEGORIE_ID = p_categorie_id;
END get_categorie_info;
/

-- JDD
BEGIN
    insert_categorie('1', 'cat_uid_1', 'Catégorie 1', 'Description de la catégorie 1');
    insert_categorie('2', 'cat_uid_2', 'Catégorie 2', 'Description de la catégorie 2');
    insert_categorie('3', 'cat_uid_3', 'Catégorie 3', 'Description de la catégorie 3');
    insert_categorie('4', 'cat_uid_4', 'Catégorie 4', 'Description de la catégorie 4');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Jeu de données pour les catégories inséré avec succès.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur lors de l''insertion des données pour les catégories: ' || SQLERRM);
END;
/

-- Accesseurs Article_Categorie

-- INSERT
CREATE OR REPLACE PROCEDURE insert_article_categorie (
    p_article_categorie_uid IN VARCHAR2,
    p_article_categorie_id IN VARCHAR2,
    p_article_categorie_article_uid IN VARCHAR2,
    p_article_categorie_categorie_uid IN VARCHAR2
) AS
BEGIN
    INSERT INTO ARTICLE_CATEGORIE (ARTICLE_CATEGORIE_UID, ARTICLE_CATEGORIE_ID, ARTICLE_CATEGORIE_ARTICLE_UID, ARTICLE_CATEGORIE_CATEGORIE_UID)
    VALUES (p_article_categorie_uid, p_article_categorie_id, p_article_categorie_article_uid, p_article_categorie_categorie_uid);
END insert_article_categorie;
/

-- DELETE
CREATE OR REPLACE PROCEDURE delete_article_categorie (
    p_article_categorie_uid IN VARCHAR2
) AS
BEGIN
    DELETE FROM ARTICLE_CATEGORIE
    WHERE ARTICLE_CATEGORIE_UID = p_article_categorie_uid;
END delete_article_categorie;
/

-- UPDATE
CREATE OR REPLACE PROCEDURE update_article_categorie (
    p_article_categorie_uid IN VARCHAR2,
    p_article_categorie_id IN VARCHAR2,
    p_article_categorie_article_uid IN VARCHAR2,
    p_article_categorie_categorie_uid IN VARCHAR2
) AS
BEGIN
    UPDATE ARTICLE_CATEGORIE
    SET ARTICLE_CATEGORIE_ID = p_article_categorie_id,
        ARTICLE_CATEGORIE_ARTICLE_UID = p_article_categorie_article_uid,
        ARTICLE_CATEGORIE_CATEGORIE_UID = p_article_categorie_categorie_uid
    WHERE ARTICLE_CATEGORIE_UID = p_article_categorie_uid;
END update_article_categorie;
/

-- GET
CREATE OR REPLACE PROCEDURE get_article_categorie_info (
    p_article_categorie_uid IN VARCHAR2,
    p_article_categorie_id OUT VARCHAR2,
    p_article_categorie_article_uid OUT VARCHAR2,
    p_article_categorie_categorie_uid OUT VARCHAR2
) AS
BEGIN
    SELECT ARTICLE_CATEGORIE_ID, ARTICLE_CATEGORIE_ARTICLE_UID, ARTICLE_CATEGORIE_CATEGORIE_UID
    INTO p_article_categorie_id, p_article_categorie_article_uid, p_article_categorie_categorie_uid
    FROM ARTICLE_CATEGORIE
    WHERE ARTICLE_CATEGORIE_UID = p_article_categorie_uid;
END get_article_categorie_info;
/

-- Accesseurs Article

-- INSERT
CREATE OR REPLACE PROCEDURE insert_article (
    p_article_uid IN VARCHAR2,
    p_article_id IN VARCHAR2,
    p_article_nom IN VARCHAR2,
    p_article_description IN VARCHAR2,
    p_article_prix IN NUMBER,
    p_article_photo IN VARCHAR2,
    p_article_note IN NUMBER,
    p_article_date_creation IN DATE,
    p_article_date_suppression IN DATE
) AS
BEGIN
    INSERT INTO ARTICLE (ARTICLE_UID, ARTICLE_ID, ARTICLE_NOM, ARTICLE_DESCRIPTION, ARTICLE_PRIX, ARTICLE_PHOTO, ARTICLE_NOTE, ARTICLE_DATE_CREATION, ARTICLE_DATE_SUPPRESSION)
    VALUES (p_article_uid, p_article_id, p_article_nom, p_article_description, p_article_prix, p_article_photo, p_article_note, p_article_date_creation, p_article_date_suppression);
END insert_article;
/

-- DELETE
CREATE OR REPLACE PROCEDURE delete_article (
    p_article_uid IN VARCHAR2
) AS
BEGIN
    DELETE FROM ARTICLE
    WHERE ARTICLE_UID = p_article_uid;
END delete_article;
/

-- UPDATE
CREATE OR REPLACE PROCEDURE update_article (
    p_article_uid IN VARCHAR2,
    p_article_id IN VARCHAR2,
    p_article_nom IN VARCHAR2,
    p_article_description IN VARCHAR2,
    p_article_prix IN NUMBER,
    p_article_photo IN VARCHAR2,
    p_article_note IN NUMBER,
    p_article_date_creation IN DATE,
    p_article_date_suppression IN DATE
) AS
BEGIN
    UPDATE ARTICLE
    SET ARTICLE_ID = p_article_id,
        ARTICLE_NOM = p_article_nom,
        ARTICLE_DESCRIPTION = p_article_description,
        ARTICLE_PRIX = p_article_prix,
        ARTICLE_PHOTO = p_article_photo,
        ARTICLE_NOTE = p_article_note,
        ARTICLE_DATE_CREATION = p_article_date_creation,
        ARTICLE_DATE_SUPPRESSION = p_article_date_suppression
    WHERE ARTICLE_UID = p_article_uid;
END update_article;
/

-- GET
CREATE OR REPLACE PROCEDURE get_article_info (
    p_article_uid IN VARCHAR2,
    p_article_id OUT VARCHAR2,
    p_article_nom OUT VARCHAR2,
    p_article_description OUT VARCHAR2,
    p_article_prix OUT NUMBER,
    p_article_photo OUT VARCHAR2,
    p_article_note OUT NUMBER,
    p_article_date_creation OUT DATE,
    p_article_date_suppression OUT DATE
) AS
BEGIN
    SELECT ARTICLE_ID, ARTICLE_NOM, ARTICLE_DESCRIPTION, ARTICLE_PRIX, ARTICLE_PHOTO, ARTICLE_NOTE, ARTICLE_DATE_CREATION, ARTICLE_DATE_SUPPRESSION
    INTO p_article_id, p_article_nom, p_article_description, p_article_prix, p_article_photo, p_article_note, p_article_date_creation, p_article_date_suppression
    FROM ARTICLE
    WHERE ARTICLE_UID = p_article_uid;
END get_article_info;
/

-- JDD
BEGIN
    insert_article('1', 'article_uid_1', 'article 1', 'Description de l article 1', '10', 'photo.png', '1', '2024-12-11', NULL);
    insert_article('2', 'article_uid_2', 'article 2', 'Description de l article 2', '20', 'photo.png', '8', '2024-12-11', NULL);
    insert_article('3', 'article_uid_3', 'article 3', 'Description de l article 3', '30', 'photo.png', '4', '2024-12-11', NULL);
    insert_article('4', 'article_uid_4', 'article 4', 'Description de l article 4', '40', 'photo.png', '10', '2024-12-11', NULL);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Jeu de données pour les catégories inséré avec succès.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur lors de l''insertion des données pour les catégories: ' || SQLERRM);
END;
/

-- Accesseurs Souhaits

-- INSERT
CREATE OR REPLACE PROCEDURE insert_souhait (
    p_souhait_id IN VARCHAR2,
    p_souhait_uid IN VARCHAR2,
    p_utilisateur_uid IN VARCHAR2,
    p_date_ajout IN DATE,
    p_date_suppression IN DATE,
    p_commande_uid IN VARCHAR2,
    p_article_uid IN VARCHAR2,
    p_quantite IN VARCHAR2
) AS
BEGIN
    INSERT INTO SOUHAITS (SOUHAITS_ID, SOUHAITS_UID, SOUHAITS_UTILISATEUR_UID, SOUHAITS_DATE_AJOUT, SOUHAITS_DATE_SUPPRESSION, SOUHAITS_COMMANDE_UID, SOUHAITS_ARTICLE_UID, SOUHAITS_QUANTITÉ)
    VALUES (p_souhait_id, p_souhait_uid, p_utilisateur_uid, p_date_ajout, p_date_suppression, p_commande_uid, p_article_uid, p_quantite);
END insert_souhait;
/

-- DELETE
CREATE OR REPLACE PROCEDURE delete_souhait (
    p_souhait_uid IN VARCHAR2
) AS
BEGIN
    DELETE FROM SOUHAITS
    WHERE SOUHAITS_UID = p_souhait_uid;
END delete_souhait;
/

--UPDATE
CREATE OR REPLACE PROCEDURE update_souhait (
    p_souhait_uid IN VARCHAR2,
    p_souhait_id IN VARCHAR2,
    p_utilisateur_uid IN VARCHAR2,
    p_date_ajout IN DATE,
    p_date_suppression IN DATE,
    p_commande_uid IN VARCHAR2,
    p_article_uid IN VARCHAR2,
    p_quantite IN VARCHAR2
) AS
BEGIN
    UPDATE SOUHAITS
    SET SOUHAITS_ID = p_souhait_id,
        SOUHAITS_UTILISATEUR_UID = p_utilisateur_uid,
        SOUHAITS_DATE_AJOUT = p_date_ajout,
        SOUHAITS_DATE_SUPPRESSION = p_date_suppression,
        SOUHAITS_COMMANDE_UID = p_commande_uid,
        SOUHAITS_ARTICLE_UID = p_article_uid,
        SOUHAITS_QUANTITÉ = p_quantite
    WHERE SOUHAITS_UID = p_souhait_uid;
END update_souhait;
/

-- GET
CREATE OR REPLACE PROCEDURE get_souhait_info (
    p_souhait_uid IN VARCHAR2,
    p_souhait_id OUT VARCHAR2,
    p_utilisateur_uid OUT VARCHAR2,
    p_date_ajout OUT DATE,
    p_date_suppression OUT DATE,
    p_commande_uid OUT VARCHAR2,
    p_article_uid OUT VARCHAR2,
    p_quantite OUT VARCHAR2
) AS
BEGIN
    SELECT SOUHAITS_ID, SOUHAITS_UTILISATEUR_UID, SOUHAITS_DATE_AJOUT, SOUHAITS_DATE_SUPPRESSION, SOUHAITS_COMMANDE_UID, SOUHAITS_ARTICLE_UID, SOUHAITS_QUANTITÉ
    INTO p_souhait_id, p_utilisateur_uid, p_date_ajout, p_date_suppression, p_commande_uid, p_article_uid, p_quantite
    FROM SOUHAITS
    WHERE SOUHAITS_UID = p_souhait_uid;
END get_souhait_info;
/


-- Accesseurs Historique_Adresse

-- INSERT
CREATE OR REPLACE PROCEDURE insert_historique_adresse (
    p_historique_adresse_uid IN VARCHAR2,
    p_id IN NUMBER,
    p_adresse_initial_uid IN VARCHAR2,
    p_adresse_uid IN VARCHAR2
) AS
BEGIN
    INSERT INTO HISTORIQUE_ADRESSE (HISTORIQUE_ADRESSE_UID, ID, ADRESSE_INITIAL_UID, ADRESSE_UID)
    VALUES (p_historique_adresse_uid, p_id, p_adresse_initial_uid, p_adresse_uid);
END insert_historique_adresse;
/

-- DELETE
CREATE OR REPLACE PROCEDURE delete_historique_adresse (
    p_historique_adresse_uid IN VARCHAR2
) AS
BEGIN
    DELETE FROM HISTORIQUE_ADRESSE
    WHERE HISTORIQUE_ADRESSE_UID = p_historique_adresse_uid;
END delete_historique_adresse;
/

-- UPDATE
CREATE OR REPLACE PROCEDURE update_historique_adresse (
    p_historique_adresse_uid IN VARCHAR2,
    p_id IN NUMBER,
    p_adresse_initial_uid IN VARCHAR2,
    p_adresse_uid IN VARCHAR2
) AS
BEGIN
    UPDATE HISTORIQUE_ADRESSE
    SET ID = p_id,
        ADRESSE_INITIAL_UID = p_adresse_initial_uid,
        ADRESSE_UID = p_adresse_uid
    WHERE HISTORIQUE_ADRESSE_UID = p_historique_adresse_uid;
END update_historique_adresse;
/

-- GET
CREATE OR REPLACE PROCEDURE get_historique_adresse_info (
    p_historique_adresse_uid IN VARCHAR2,
    p_id OUT NUMBER,
    p_adresse_initial_uid OUT VARCHAR2,
    p_adresse_uid OUT VARCHAR2
) AS
BEGIN
    SELECT ID, ADRESSE_INITIAL_UID, ADRESSE_UID
    INTO p_id, p_adresse_initial_uid, p_adresse_uid
    FROM HISTORIQUE_ADRESSE
    WHERE HISTORIQUE_ADRESSE_UID = p_historique_adresse_uid;
END get_historique_adresse_info;
/

-- Accesseurs Commande_Article

-- INSERT
CREATE OR REPLACE PROCEDURE insert_commande_article (
    p_commande_article_uid IN VARCHAR2,
    p_commande_article_id IN VARCHAR2,
    p_commande_uid IN VARCHAR2,
    p_quantite IN NUMBER,
    p_article_uid IN VARCHAR2
) AS
BEGIN
    INSERT INTO COMMANDE_ARTICLE (COMMANDE_ARTICLE_UID, COMMANDE_ARTICLE_ID, COMMANDE_UID, QUANTITÉ, COMMANDE_ARTICLE_ARTICLE_UID)
    VALUES (p_commande_article_uid, p_commande_article_id, p_commande_uid, p_quantite, p_article_uid);
END insert_commande_article;
/

-- DELETE
CREATE OR REPLACE PROCEDURE delete_commande_article (
    p_commande_article_uid IN VARCHAR2
) AS
BEGIN
    DELETE FROM COMMANDE_ARTICLE
    WHERE COMMANDE_ARTICLE_UID = p_commande_article_uid;
END delete_commande_article;
/

-- UPDATE
CREATE OR REPLACE PROCEDURE update_commande_article (
    p_commande_article_uid IN VARCHAR2,
    p_commande_article_id IN VARCHAR2,
    p_commande_uid IN VARCHAR2,
    p_quantite IN NUMBER,
    p_article_uid IN VARCHAR2
) AS
BEGIN
    UPDATE COMMANDE_ARTICLE
    SET COMMANDE_ARTICLE_ID = p_commande_article_id,
        COMMANDE_UID = p_commande_uid,
        QUANTITÉ = p_quantite,
        COMMANDE_ARTICLE_ARTICLE_UID = p_article_uid
    WHERE COMMANDE_ARTICLE_UID = p_commande_article_uid;
END update_commande_article;
/

-- GET
CREATE OR REPLACE PROCEDURE update_commande_article (
    p_commande_article_uid IN VARCHAR2,
    p_commande_article_id IN VARCHAR2,
    p_commande_uid IN VARCHAR2,
    p_quantite IN NUMBER,
    p_article_uid IN VARCHAR2
) AS
BEGIN
    UPDATE COMMANDE_ARTICLE
    SET COMMANDE_ARTICLE_ID = p_commande_article_id,
        COMMANDE_UID = p_commande_uid,
        QUANTITÉ = p_quantite,
        COMMANDE_ARTICLE_ARTICLE_UID = p_article_uid
    WHERE COMMANDE_ARTICLE_UID = p_commande_article_uid;
END update_commande_article;
/

