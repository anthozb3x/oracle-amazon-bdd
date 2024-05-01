/*
-- Création du USER SQL
alter session
    set
    "_ORACLE_SCRIPT" = true;

CREATE USER "AMAZONDATABASE" IDENTIFIED BY "MDPAMAZONDATABASE";

ALTER USER "AMAZONDATABASE" DEFAULT TABLESPACE "USERS" TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK;

-- SYSTEM PRIVILEGES
GRANT CREATE TRIGGER TO "AMAZONDATABASE";

GRANT CREATE SEQUENCE TO "AMAZONDATABASE";

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

-- Drop toutes les tables et de toutes les vues
BEGIN
    -- Suppression de toutes les tables
    FOR table_rec IN (SELECT table_name FROM user_tables) LOOP
            EXECUTE IMMEDIATE 'DROP TABLE ' || table_rec.table_name || ' CASCADE CONSTRAINTS';
        END LOOP;

    -- Suppression de toutes les vues
    FOR view_rec IN (SELECT view_name FROM user_views) LOOP
            EXECUTE IMMEDIATE 'DROP VIEW ' || view_rec.view_name;
        END LOOP;

    -- Suppression de tous les triggers
    FOR trigger_rec IN (SELECT trigger_name FROM user_triggers) LOOP
            EXECUTE IMMEDIATE 'DROP TRIGGER ' || trigger_rec.trigger_name;
        END LOOP;

    -- Suppression de toutes les séquences
    FOR sequence_rec IN (SELECT sequence_name FROM user_sequences) LOOP
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || sequence_rec.sequence_name;
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
    CONSTRAINT "UTILISATEUR_PK" PRIMARY KEY ("UTILISATEUR_UID") USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255,
    CONSTRAINT "UTILISATEUR_UK_EMAIL" UNIQUE ("EMAIL") USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS ENABLE
);

-- creatiion des tables
CREATE TABLE CONVERSATION (
                              CONVERSATION_UID VARCHAR2(255) NOT NULL,
                              CONVERSATION_ID VARCHAR2(255) NOT NULL,
                              COLUMN1 VARCHAR2(255) NOT NULL,
                              CONSTRAINT CONVERSATION_PK PRIMARY KEY(CONVERSATION_UID) ENABLE
);

CREATE TABLE ADRESSE (
                         ADRESSE_UID VARCHAR2(255) NOT NULL,
                         ADRESSE_ID VARCHAR2(255) NOT NULL,
                         ADRESSE_POSTALE VARCHAR2(255) NOT NULL,
                         ADRESSE_REGION VARCHAR2(255) NOT NULL,
                         UTILISATEUR_UID VARCHAR2(255),
                         EST_FAVORITE NUMBER DEFAULT 0 NOT NULL,
                         DATE_CREATION DATE NOT NULL,
                         DATE_SUPPRESSION DATE,
                         CONSTRAINT ADRESSE_PK PRIMARY KEY (ADRESSE_UID),
                         CONSTRAINT FK_ADRESSE_UTILISATEUR FOREIGN KEY (UTILISATEUR_UID) REFERENCES UTILISATEUR (UTILISATEUR_UID)
);

CREATE TABLE ADRESSE_LOG (
                             LOG_ID NUMBER PRIMARY KEY,
                             ADRESSE_ID VARCHAR2(255),
                             ACTION VARCHAR2(10),
                             TIMESTAMP TIMESTAMP
);

CREATE TABLE HISTORIQUE_ADRESSE (
                                    HISTORIQUE_ADRESSE_UID VARCHAR2(255) NOT NULL,
                                    ID NUMBER NOT NULL,
                                    ADRESSE_INITIAL_UID VARCHAR2(255) NOT NULL,
                                    ADRESSE_UID VARCHAR2(255) NOT NULL,
                                    CONSTRAINT HISTORIQUE_ADRESSE_PK PRIMARY KEY (HISTORIQUE_ADRESSE_UID),
                                    CONSTRAINT HISTORIQUE_ADRESSE_FK1 FOREIGN KEY (ADRESSE_UID) REFERENCES ADRESSE (ADRESSE_UID) ENABLE,
                                    CONSTRAINT HISTORIQUE_ADRESSE_FK2 FOREIGN KEY (ADRESSE_INITIAL_UID) REFERENCES ADRESSE (ADRESSE_UID) ENABLE
);

CREATE TABLE COMMANDE (
                          COMMANDE_UID VARCHAR2(255) NOT NULL,
                          COMMANDE_DATE DATE NOT NULL,
                          UTILISATEUR_ACHETEUR_UID VARCHAR2(255) NOT NULL,
                          UTILISATEUR_VENDEUR_UID VARCHAR2(255) NOT NULL,
                          ADRESSE_EXPEDITION_UID VARCHAR2(255) NOT NULL,
                          ADRESSE_DESTINANTION_UID VARCHAR2(255) NOT NULL,
                          MONTANT_TOTAL NUMBER(12, 2) NOT NULL,
                          CONSTRAINT COMMANDE_PK PRIMARY KEY (COMMANDE_UID),
                          CONSTRAINT COMMANDE_FK_ADRESSE_DESTINATION FOREIGN KEY (ADRESSE_DESTINANTION_UID) REFERENCES ADRESSE (ADRESSE_UID) ENABLE,
                          CONSTRAINT COMMANDE_FK_ADRESSE_EXPEDITION FOREIGN KEY (ADRESSE_EXPEDITION_UID) REFERENCES ADRESSE (ADRESSE_UID) ENABLE,
                          CONSTRAINT COMMANDE_FK_UTILISATEUR_ACHETEUR FOREIGN KEY (UTILISATEUR_ACHETEUR_UID) REFERENCES UTILISATEUR (UTILISATEUR_UID) ENABLE,
                          CONSTRAINT COMMANDE_FK_UTILISATEUR_VENDEUR FOREIGN KEY (UTILISATEUR_VENDEUR_UID) REFERENCES UTILISATEUR (UTILISATEUR_UID) ENABLE
);

CREATE TABLE ARTICLE (
                         ARTICLE_UID VARCHAR2(255) NOT NULL,
                         ARTICLE_ID VARCHAR2(255) NOT NULL,
                         ARTICLE_NOM VARCHAR2(255) NOT NULL,
                         ARTICLE_DESCRIPTION VARCHAR2(255) NOT NULL,
                         ARTICLE_PRIX NUMBER NOT NULL,
                         ARTICLE_PHOTO VARCHAR2(255) NOT NULL,
                         ARTICLE_NOTE NUMBER,
                         ARTICLE_DATE_CREATION DATE NOT NULL,
                         ARTICLE_DATE_SUPPRESSION DATE,
                         CONSTRAINT ARTICLE_PK PRIMARY KEY (ARTICLE_UID) ENABLE
);

CREATE TABLE CATEGORIE (
                           CATEGORIE_ID VARCHAR2(255) NOT NULL,
                           CATEGORIE_UID VARCHAR2(255) NOT NULL,
                           CATEGORIE_NOM VARCHAR2(255) NOT NULL,
                           CATEGORIE_DESCRIPTION CLOB NOT NULL,
                           CONSTRAINT CATEGORIE_PK PRIMARY KEY (CATEGORIE_ID) ENABLE
);

CREATE TABLE SOUHAITS
(
    SOUHAITS_ID VARCHAR2(255) NOT NULL,
    SOUHAITS_UID VARCHAR2(255) NOT NULL,
    SOUHAITS_UTILISATEUR_UID VARCHAR2(255) NOT NULL,
    SOUHAITS_DATE_AJOUT DATE NOT NULL,
    SOUHAITS_DATE_SUPPRESSION DATE,  -- Correction du nom de la colonne
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

CREATE TABLE SOUHAITS_LOG (
                              LOG_ID NUMBER PRIMARY KEY,
                              SOUHAITS_ID VARCHAR2(255),
                              ACTION VARCHAR2(10),
                              TIMESTAMP TIMESTAMP
);

CREATE TABLE COMMANDE_ARTICLE (
                                  COMMANDE_ARTICLE_UID VARCHAR2(255) NOT NULL,
                                  COMMANDE_ARTICLE_ID VARCHAR2(255) NOT NULL,
                                  COMMANDE_UID VARCHAR2(255) NOT NULL,
                                  QUANTITÉ NUMBER NOT NULL,
                                  COMMANDE_ARTICLE_ARTICLE_UID VARCHAR2(255) NOT NULL,
                                  CONSTRAINT COMMANDE_ARTICLE_PK PRIMARY KEY (COMMANDE_ARTICLE_UID),
                                  CONSTRAINT COMMANDE_ARTICLE_ARTICLE_FK FOREIGN KEY (COMMANDE_ARTICLE_ARTICLE_UID) REFERENCES ARTICLE (ARTICLE_UID) ENABLE,
                                  CONSTRAINT COMMANDE_ARTICLE_COMMANDE_FK FOREIGN KEY (COMMANDE_UID) REFERENCES COMMANDE (COMMANDE_UID) ENABLE
);

CREATE TABLE ARTICLE_CATEGORIE (
                                   ARTICLE_CATEGORIE_UID VARCHAR2(255) NOT NULL,
                                   ARTICLE_CATEGORIE_ID VARCHAR2(255) NOT NULL,
                                   ARTICLE_CATEGORIE_ARTICLE_UID VARCHAR2(20),
                                   ARTICLE_CATEGORIE_CATEGORIE_UID VARCHAR2(255) NOT NULL,
                                   CONSTRAINT ARTICLE_CATEGORIE_PK PRIMARY KEY (ARTICLE_CATEGORIE_UID),
                                   CONSTRAINT ARTICLE_CATEGORIE_ARTICLE_FK FOREIGN KEY (ARTICLE_CATEGORIE_ARTICLE_UID) REFERENCES ARTICLE (ARTICLE_UID),
                                   CONSTRAINT ARTICLE_CATEGORIE_CATEGORIE_FK FOREIGN KEY (ARTICLE_CATEGORIE_CATEGORIE_UID) REFERENCES CATEGORIE (CATEGORIE_ID)
);

CREATE TABLE MESSAGE (
                         MESSAGE_UID VARCHAR2(255 BYTE) NOT NULL,
                         MESSAGE_ID VARCHAR2(255 BYTE) NOT NULL,
                         CONVERSATION_UID VARCHAR2(255 BYTE) NOT NULL,
                         UTILISATEUR_DESTINATAIRE_UID VARCHAR2(255 BYTE) NOT NULL,
                         UTILISATEUR_EXPEDITEUR_UID VARCHAR2(255 BYTE) NOT NULL,
                         DATE_MESSAGE DATE NOT NULL,
                         MESSAGE CLOB NOT NULL,
                         CONSTRAINT MESSAGE_PK PRIMARY KEY (MESSAGE_UID),
                         CONSTRAINT MESSAGE_FK_UTILISATEUR_EXPEDITEUR FOREIGN KEY (UTILISATEUR_EXPEDITEUR_UID) REFERENCES UTILISATEUR (UTILISATEUR_UID) ENABLE,
                         CONSTRAINT MESSAGE_FK_UTILISATEUR_DESTINATAIRE FOREIGN KEY (UTILISATEUR_DESTINATAIRE_UID) REFERENCES UTILISATEUR (UTILISATEUR_UID) ENABLE
);
/
-- GETTERS SETTERS
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

CREATE
    OR REPLACE PROCEDURE get_conversation (
    p_conversation_uid IN VARCHAR2,
    p_conversation_cursor OUT SYS_REFCURSOR
) AS BEGIN OPEN p_conversation_cursor FOR
    SELECT
        *
    FROM
        CONVERSATION
    WHERE
        CONVERSATION_UID = p_conversation_uid;

END get_conversation;
/

CREATE
    OR REPLACE PROCEDURE insert_conversation (
    p_conversation_uid IN VARCHAR2,
    p_conversation_id IN VARCHAR2,
    p_column1 IN VARCHAR2
) AS BEGIN
    INSERT INTO
        CONVERSATION (
        CONVERSATION_UID,
        CONVERSATION_ID,
        COLUMN1
    )
    VALUES
        (
            p_conversation_uid,
            p_conversation_id,
            p_column1
        );

    COMMIT;

END insert_conversation;
/

CREATE
    OR REPLACE PROCEDURE update_conversation (
    p_conversation_uid IN VARCHAR2,
    p_conversation_id IN VARCHAR2,
    p_column1 IN VARCHAR2
) AS BEGIN
    UPDATE
        CONVERSATION
    SET
        CONVERSATION_ID = p_conversation_id,
        COLUMN1 = p_column1
    WHERE
        CONVERSATION_UID = p_conversation_uid;

    COMMIT;

END update_conversation;

/

CREATE
    OR REPLACE PROCEDURE get_message (
    p_message_uid IN VARCHAR2,
    p_message_cursor OUT SYS_REFCURSOR
) AS BEGIN OPEN p_message_cursor FOR
    SELECT
        *
    FROM
        MESSAGE
    WHERE
        MESSAGE_UID = p_message_uid;

END get_message;

/

CREATE
    OR REPLACE PROCEDURE insert_message (
    p_message_uid IN VARCHAR2,
    p_message_id IN VARCHAR2,
    p_conversation_uid IN VARCHAR2,
    p_utilisateur_destinataire_uid IN VARCHAR2,
    p_utilisateur_expediteur_uid IN VARCHAR2,
    p_date_message IN DATE,
    p_message_text IN CLOB
) AS BEGIN
    INSERT INTO
        MESSAGE (
        MESSAGE_UID,
        MESSAGE_ID,
        CONVERSATION_UID,
        UTILISATEUR_DESTINATAIRE_UID,
        UTILISATEUR_EXPEDITEUR_UID,
        DATE_MESSAGE,
        MESSAGE
    )
    VALUES
        (
            p_message_uid,
            p_message_id,
            p_conversation_uid,
            p_utilisateur_destinataire_uid,
            p_utilisateur_expediteur_uid,
            p_date_message,
            p_message_text
        );

    COMMIT;

END insert_message;

/

CREATE
    OR REPLACE PROCEDURE update_message (
    p_message_uid IN VARCHAR2,
    p_message_id IN VARCHAR2,
    p_conversation_uid IN VARCHAR2,
    p_utilisateur_destinataire_uid IN VARCHAR2,
    p_utilisateur_expediteur_uid IN VARCHAR2,
    p_date_message IN DATE,
    p_message_text IN CLOB
) AS BEGIN
    UPDATE
        MESSAGE
    SET
        MESSAGE_ID = p_message_id,
        CONVERSATION_UID = p_conversation_uid,
        UTILISATEUR_DESTINATAIRE_UID = p_utilisateur_destinataire_uid,
        UTILISATEUR_EXPEDITEUR_UID = p_utilisateur_expediteur_uid,
        DATE_MESSAGE = p_date_message,
        MESSAGE = p_message_text
    WHERE
        MESSAGE_UID = p_message_uid;

    COMMIT;

END update_message;

/
-- Table Utilisateurs
-- Getter (SELECT) procedure for UTILISATEUR
CREATE OR REPLACE PROCEDURE get_utilisateur (
    p_utilisateur_uid IN VARCHAR2,
    p_utilisateur_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_utilisateur_cursor FOR
        SELECT *
        FROM "AMAZONDATABASE"."UTILISATEUR"
        WHERE "UTILISATEUR_UID" = p_utilisateur_uid;
END get_utilisateur;
/

-- Setter (INSERT) procedure for UTILISATEUR
CREATE
    OR REPLACE PROCEDURE insert_utilisateur (
    p_utilisateur_uid IN VARCHAR2,
    p_utilisateur_id IN NUMBER,
    p_nom IN VARCHAR2,
    p_prenom IN VARCHAR2,
    p_email IN VARCHAR2,
    p_est_vendeur IN NUMBER,
    p_date_creation IN DATE,
    p_date_suppression IN DATE
) AS BEGIN
    INSERT INTO
        "AMAZONDATABASE"."UTILISATEUR" (
        "UTILISATEUR_UID",
        "UTILISATEUR_ID",
        "NOM",
        "PRENOM",
        "EMAIL",
        "EST_VENDEUR",
        "DATE_CREATION",
        "DATE_SUPRESSION"
    ) VALUES (
                 p_utilisateur_uid,
                 p_utilisateur_id,
                 p_nom,
                 p_prenom,
                 p_email,
                 p_est_vendeur,
                 p_date_creation,
                 p_date_suppression
             );
    COMMIT;
END insert_utilisateur;
/

-- Setter (UPDATE) procedure for UTILISATEUR
CREATE OR REPLACE PROCEDURE update_utilisateur (
    p_utilisateur_uid IN VARCHAR2,
    p_utilisateur_id IN NUMBER,
    p_nom IN VARCHAR2,
    p_prenom IN VARCHAR2,
    p_email IN VARCHAR2,
    p_est_vendeur IN NUMBER,
    p_date_creation IN DATE,
    p_date_suppression IN DATE
) AS BEGIN
    UPDATE
        "AMAZONDATABASE"."UTILISATEUR"
    SET
        "UTILISATEUR_ID" = p_utilisateur_id,
        "NOM" = p_nom,
        "PRENOM" = p_prenom,
        "EMAIL" = p_email,
        "EST_VENDEUR" = p_est_vendeur,
        "DATE_CREATION" = p_date_creation,
        "DATE_SUPRESSION" = p_date_suppression
    WHERE
        "UTILISATEUR_UID" = p_utilisateur_uid;

    COMMIT;

END update_utilisateur;
/


-- Getter (SELECT) procedure for ADRESSE
CREATE OR REPLACE PROCEDURE get_adresse (
    p_adresse_uid IN VARCHAR2,
    p_adresse_cursor OUT SYS_REFCURSOR
) AS BEGIN OPEN p_adresse_cursor FOR
    SELECT
        *
    FROM
        ADRESSE
    WHERE
        ADRESSE_UID = p_adresse_uid;

END get_adresse;
/

-- Setter (INSERT) procedure for ADRESSE
CREATE OR REPLACE PROCEDURE insert_adresse (
    p_adresse_uid IN VARCHAR2,
    p_adresse_id IN VARCHAR2,
    p_adresse_postale IN VARCHAR2,
    p_adresse_region IN VARCHAR2,
    p_utilisateur_uid IN VARCHAR2,
    p_est_favorite IN NUMBER,
    p_date_creation IN DATE,
    p_date_suppression IN DATE
) AS BEGIN
    INSERT INTO
        ADRESSE (
        ADRESSE_UID,
        ADRESSE_ID,
        ADRESSE_POSTALE,
        ADRESSE_REGION,
        UTILISATEUR_UID,
        EST_FAVORITE,
        DATE_CREATION,
        DATE_SUPPRESSION
    )
    VALUES
        (
            p_adresse_uid,
            p_adresse_id,
            p_adresse_postale,
            p_adresse_region,
            p_utilisateur_uid,
            p_est_favorite,
            p_date_creation,
            p_date_suppression
        );

    COMMIT;

END insert_adresse;
/

-- Setter (UPDATE) procedure for ADRESSE
CREATE OR REPLACE PROCEDURE update_adresse (
    p_adresse_uid IN VARCHAR2,
    p_adresse_id IN VARCHAR2,
    p_adresse_postale IN VARCHAR2,
    p_adresse_region IN VARCHAR2,
    p_utilisateur_uid IN VARCHAR2,
    p_est_favorite IN NUMBER,
    p_date_creation IN DATE,
    p_date_suppression IN DATE
) AS BEGIN
    UPDATE
        ADRESSE
    SET
        ADRESSE_ID = p_adresse_id,
        ADRESSE_POSTALE = p_adresse_postale,
        ADRESSE_REGION = p_adresse_region,
        UTILISATEUR_UID = p_utilisateur_uid,
        EST_FAVORITE = p_est_favorite,
        DATE_CREATION = p_date_creation,
        DATE_SUPPRESSION = p_date_suppression
    WHERE
        ADRESSE_UID = p_adresse_uid;

    COMMIT;

END update_adresse;
/



-- Table COMMANDE
-- Procedure pour insérer une ligne dans la table COMMANDE
CREATE OR REPLACE PROCEDURE insert_commande (
    p_commande_uid IN VARCHAR2,
    p_commande_date IN DATE,
    p_utilisateur_acheteur_uid IN VARCHAR2,
    p_utilisateur_vendeur_uid IN VARCHAR2,
    p_adresse_expedition_uid IN VARCHAR2,
    p_adresse_destination_uid IN VARCHAR2,
    p_montant_total IN NUMBER
) IS BEGIN
    INSERT INTO
        COMMANDE (
        COMMANDE_UID,
        COMMANDE_DATE,
        UTILISATEUR_ACHETEUR_UID,
        UTILISATEUR_VENDEUR_UID,
        ADRESSE_EXPEDITION_UID,
        ADRESSE_DESTINANTION_UID,
        MONTANT_TOTAL
    )
    VALUES
        (
            p_commande_uid,
            p_commande_date,
            p_utilisateur_acheteur_uid,
            p_utilisateur_vendeur_uid,
            p_adresse_expedition_uid,
            p_adresse_destination_uid,
            p_montant_total
        );

    COMMIT;

END;

/

-- Procedure pour supprimer une ligne dans la table COMMANDE depuis COMMANDE_UID
CREATE
    OR REPLACE PROCEDURE delete_commande (p_commande_uid IN VARCHAR2) IS BEGIN
    DELETE FROM
        COMMANDE
    WHERE
        COMMANDE_UID = p_commande_uid;

    COMMIT;

END delete_commande;
/

-- Procedure pour mettre à jour une ligne dans la table COMMANDE depuis COMMANDE_UID
CREATE OR REPLACE PROCEDURE update_commande (
    p_commande_uid IN VARCHAR2,
    p_commande_date IN DATE,
    p_utilisateur_acheteur_uid IN VARCHAR2,
    p_utilisateur_vendeur_uid IN VARCHAR2,
    p_adresse_expedition_uid IN VARCHAR2,
    p_adresse_destination_uid IN VARCHAR2,
    p_montant_total IN NUMBER
) IS BEGIN
    UPDATE
        COMMANDE
    SET
        COMMANDE_DATE = p_commande_date,
        UTILISATEUR_ACHETEUR_UID = p_utilisateur_acheteur_uid,
        UTILISATEUR_VENDEUR_UID = p_utilisateur_vendeur_uid,
        ADRESSE_EXPEDITION_UID = p_adresse_expedition_uid,
        ADRESSE_DESTINANTION_UID = p_adresse_destination_uid,
        MONTANT_TOTAL = p_montant_total
    WHERE
        COMMANDE_UID = p_commande_uid;

    COMMIT;

END;

/
-- Fonction pour récupérer une ligne dans la table COMMANDE depuis COMMANDE_UID
CREATE
    OR REPLACE FUNCTION get_commande (
    p_commande_uid IN VARCHAR2,
    p_commande_cursor OUT SYS_REFCURSOR
) RETURN SYS_REFCURSOR AS BEGIN OPEN p_commande_cursor FOR
    SELECT
        *
    FROM
        COMMANDE
    WHERE
        COMMANDE_UID = p_commande_uid;

RETURN p_commande_cursor;

END get_commande;
/

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

-- VIEWS

-- Vue Statistique articles souhaités mais non commandés
CREATE VIEW STATS_ARTICLES_SOUHAITES_SANS_COMMANDE AS
SELECT
    SA.SOUHAITS_ARTICLE_UID AS ARTICLE_UID,
    A.ARTICLE_NOM,
    A.ARTICLE_DESCRIPTION,
    COUNT(SA.SOUHAITS_UID) AS NOMBRE_DE_SOUHAITS
FROM
    SOUHAITS SA
        JOIN
    ARTICLE A ON SA.SOUHAITS_ARTICLE_UID = A.ARTICLE_UID
WHERE
    SA.SOUHAITS_COMMANDE_UID IS NULL
GROUP BY
    SA.SOUHAITS_ARTICLE_UID, A.ARTICLE_NOM, A.ARTICLE_DESCRIPTION;

-- Vue Statistique catégories les plus commandées
CREATE VIEW STATS_CATEGORIES_COMMANDEES AS
SELECT
    AC.ARTICLE_CATEGORIE_CATEGORIE_UID AS CATEGORIE_UID,
    C.CATEGORIE_NOM,
    COUNT(*) AS NOMBRE_DE_COMMANDES
FROM
    COMMANDE_ARTICLE CA
        JOIN
    ARTICLE_CATEGORIE AC ON CA.COMMANDE_ARTICLE_ARTICLE_UID = AC.ARTICLE_CATEGORIE_ARTICLE_UID
        JOIN
    CATEGORIE C ON AC.ARTICLE_CATEGORIE_CATEGORIE_UID = C.CATEGORIE_UID
GROUP BY
    AC.ARTICLE_CATEGORIE_CATEGORIE_UID, C.CATEGORIE_NOM;


-- Journaux de Log

-- Log des Adresses
CREATE SEQUENCE  "AMAZONDATABASE"."ADRESSE_LOG_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 2 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

create or replace NONEDITIONABLE TRIGGER adresse_trigger
    AFTER INSERT OR UPDATE OR DELETE ON ADRESSE
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO ADRESSE_LOG (LOG_ID, ADRESSE_ID, ACTION, TIMESTAMP)
        VALUES (adresse_log_seq.NEXTVAL, :NEW.ADRESSE_ID, 'INSERT', SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO ADRESSE_LOG (LOG_ID, ADRESSE_ID, ACTION, TIMESTAMP)
        VALUES (adresse_log_seq.NEXTVAL, :NEW.ADRESSE_ID, 'UPDATE', SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO ADRESSE_LOG (LOG_ID, ADRESSE_ID, ACTION, TIMESTAMP)
        VALUES (adresse_log_seq.NEXTVAL, :NEW.ADRESSE_ID, 'DELETE', SYSTIMESTAMP);
    END IF;
END;
/
-- Log des Souhaits
CREATE SEQUENCE  "AMAZONDATABASE"."SOUHAIT_LOG_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

create or replace NONEDITIONABLE TRIGGER souhait_trigger
    AFTER INSERT OR UPDATE OR DELETE ON SOUHAITS
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO SOUHAITS_LOG (LOG_ID, SOUHAITS_ID, ACTION, TIMESTAMP)
        VALUES (souhait_log_seq.NEXTVAL, :NEW.SOUHAITS_ID, 'INSERT', SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO SOUHAITS_LOG (LOG_ID, SOUHAITS_ID, ACTION, TIMESTAMP)
        VALUES (souhait_log_seq.NEXTVAL, :NEW.SOUHAITS_ID, 'UPDATE', SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO SOUHAITS_LOG (LOG_ID, SOUHAITS_ID, ACTION, TIMESTAMP)
        VALUES (souhait_log_seq.NEXTVAL, :OLD.SOUHAITS_ID, 'DELETE', SYSTIMESTAMP);
    END IF;
END;
/

-- Création d'un jeu de donnée de test
-- Insertion des utilisateurs
BEGIN
    insert_utilisateur('1', 1, 'John', 'Doe', 'john.doe@example.com', 0, SYSDATE, NULL);
    insert_utilisateur('2', 2, 'Jane', 'Smith', 'jane.smith@example.com', 1, SYSDATE, NULL);
    insert_utilisateur('3', 3, 'Alice', 'Johnson', 'alice.johnson@example.com', 0, SYSDATE, NULL);
    insert_utilisateur('4', 4, 'Bob', 'Brown', 'bob.brown@example.com', 1, SYSDATE, NULL);
END;
/

-- Insertion des adresses
BEGIN
    insert_adresse('1', 'Adresse1', '123 Rue de la Paix', 'Île-de-France', '1', 1, SYSDATE, NULL);
    insert_adresse('2', 'Adresse2', '456 Avenue des Champs-Élysées', 'Auvergne-Rhône-Alpes', '2', 0, SYSDATE, NULL);
END;
/

-- Insertion des commandes
BEGIN
    insert_commande('1', SYSDATE, '1', '2', '1', '2', 150);
    insert_commande('2', SYSDATE, '3', '2', '2', '1', 200);
    insert_commande('3', SYSDATE, '2', '3', '2', '1', 250);
END;
/

-- Insertion des articles
BEGIN
    insert_article('1', '1', 'Article 1', 'Description de l''article 1', 100, 'photo1.jpg', 4, SYSDATE, NULL);
    insert_article('2', '2', 'Article 2', 'Description de l''article 2', 200, 'photo2.jpg', 3, SYSDATE, NULL);
    insert_article('3', '3', 'Article 3', 'Description de l''article 3', 300, 'photo3.jpg', 5, SYSDATE, NULL);
END;
/
-- Insertion des commandes_articles
BEGIN
    insert_commande_article('1', '1', '1', 1, '1');
    insert_commande_article('2', '2', '2', 2, '2');
    insert_commande_article('3', '3', '3', 3, '3');
END;

-- Insertion des souhaits
BEGIN
    insert_souhait('1', '1', '1', SYSDATE, NULL, '1', '1', '1');
    insert_souhait('2', '2', '2', SYSDATE, NULL, '2', '2', '2');
    insert_souhait('3', '3', '3', SYSDATE, NULL, '3', '3', '3');
END;
/
-- Insertion des catégories
BEGIN
    insert_categorie('1', '1', 'Catégorie 1', 'Description de la catégorie 1');
    insert_categorie('2', '2', 'Catégorie 2', 'Description de la catégorie 2');
    insert_categorie('3', '3', 'Catégorie 3', 'Description de la catégorie 3');
    insert_categorie('4', '4', 'Catégorie 4', 'Description de la catégorie 4');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Jeu de données pour les catégories inséré avec succès.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur lors de l''insertion des données pour les catégories: ' || SQLERRM);
END;
/