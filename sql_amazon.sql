/*
 -- Création du USER SQL
 alter session
 set
 "_ORACLE_SCRIPT" = true;
 
 CREATE USER "AMAZONDATABSE" IDENTIFIED BY "MDPAMAZONDATABSE";
 
 ALTER USER "AMAZONDATABSE" DEFAULT TABLESPACE "USERS" TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK;
 
 -- SYSTEM PRIVILEGES
 GRANT CREATE TRIGGER TO "AMAZONDATABSE";
 
 GRANT CREATE PROCEDURE TO  "AMAZONDATABSE";
 
 GRANT CREATE ANY INDEX TO "AMAZONDATABSE";
 
 GRANT CREATE VIEW TO "AMAZONDATABSE";
 
 GRANT CREATE SESSION TO "AMAZONDATABSE";
 
 GRANT
 SELECT
 ANY TABLE TO "AMAZONDATABSE";
 
 GRANT DELETE ANY TABLE TO "AMAZONDATABSE";
 
 GRANT CREATE TABLE TO "AMAZONDATABSE";
 
 GRANT DROP ANY TABLE TO "AMAZONDATABSE";
 
 GRANT UNDER ANY TYPE TO "AMAZONDATABSE";
 
 GRANT CREATE TYPE TO "AMAZONDATABSE";
 
 GRANT DROP ANY TYPE TO "AMAZONDATABSE";
 
 GRANT EXECUTE ANY PROCEDURE TO "AMAZONDATABSE";
 
 SET SERVEROUTPUT ON;
 GRANT UNLIMITED TABLESPACE TO "AMAZONDATABSE";
 
 GRANT EXECUTE ANY PROGRAM TO "AMAZONDATABSE";
 
 GRANT EXECUTE ANY TYPE TO "AMAZONDATABSE";
 
 GRANT DROP ANY INDEX TO "AMAZONDATABSE";
 
 GRANT
 UPDATE
 ANY TABLE TO "AMAZONDATABSE";
 
 GRANT DROP ANY VIEW TO "AMAZONDATABSE";
 
 GRANT UNDER ANY VIEW TO "AMAZONDATABSE";
 
 GRANT GRANT ANY PRIVILEGE TO "AMAZONDATABSE"; -- Crée la base de données AMAZON_DATABSE et ce connecter avec l'user configurer juste au dessus
 */
-- Drop toutes les tables
-- Drop all tables
BEGIN FOR table_rec IN (
    SELECT
        table_name
    FROM
        user_tables
) LOOP EXECUTE IMMEDIATE 'DROP TABLE ' || table_rec.table_name || ' CASCADE CONSTRAINTS';

END LOOP;

END;

/ -- Créé la table UTILISATEUR
CREATE TABLE "AMAZONDATABSE"."UTILISATEUR" (
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

/ CREATE
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

/ CREATE TABLE MESSAGE (
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

/ CREATE
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

/ CREATE
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

/ CREATE TABLE ADRESSE (
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

CREATE TABLE SOUHAITS (
    SOUHAITS_ID VARCHAR2(255) NOT NULL,
    SOUHAITS_UID VARCHAR2(255) NOT NULL,
    SOUHAITS_UTILISATEUR_UID VARCHAR2(255) NOT NULL,
    SOUHAITS_DATE_AJOUT DATE NOT NULL,
    SOUHAITS_DATE_SUPPRESSION DATEch SOUHAITS_COMMANDE_UID VARCHAR2(255),
    SOUHAITS_ARTICLE_UID VARCHAR2(255) NOT NULL,
    SOUHAITS_QUANTITÉ VARCHAR2(255),
    CONSTRAINT SOUHAITS_PK PRIMARY KEY (SOUHAITS_UID),
    CONSTRAINT SOUHAITS_ARTICLE_FK FOREIGN KEY (SOUHAITS_ARTICLE_UID) REFERENCES ARTICLE (ARTICLE_UID) ENABLE,
    CONSTRAINT SOUHAITS_COMMANDE_FK FOREIGN KEY (SOUHAITS_COMMANDE_UID) REFERENCES COMMANDE (COMMANDE_UID) ENABLE,
    CONSTRAINT SOUHAITS_UTILISATEUR_FK FOREIGN KEY (SOUHAITS_UTILISATEUR_UID) REFERENCES UTILISATEUR (UTILISATEUR_UID) ENABLE
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

-- GETTERS SETTERS
-- Table Utilisateurs
-- Getter (SELECT) procedure for UTILISATEUR
CREATE
OR REPLACE PROCEDURE get_utilisateur (
    p_utilisateur_uid IN VARCHAR2,
    p_utilisateur_cursor OUT SYS_REFCURSOR
) AS BEGIN OPEN p_utilisateur_cursor FOR
SELECT
    *
FROM
    "AMAZONDATABSE"."UTILISATEUR"
WHERE
    "UTILISATEUR_UID" = p_utilisateur_uid;

END get_utilisateur;

/ -- Setter (INSERT) procedure for UTILISATEUR
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
    "AMAZONDATABSE"."UTILISATEUR" (
        "UTILISATEUR_UID",
        "UTILISATEUR_ID",
        "NOM",
        "PRENOM",
        "EMAIL",
        "EST_VENDEUR",
        "DATE_CREATION",
        "DATE_SUPRESSION"
    )
VALUES
    (
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

/ -- Setter (UPDATE) procedure for UTILISATEUR
CREATE
OR REPLACE PROCEDURE update_utilisateur (
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
    "AMAZONDATABSE"."UTILISATEUR"
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

/ -- Getter (SELECT) procedure for ADRESSE
CREATE
OR REPLACE PROCEDURE get_adresse (
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

/ -- Setter (INSERT) procedure for ADRESSE
-- Setter (INSERT) procedure for ADRESSE
CREATE
OR REPLACE PROCEDURE insert_adresse (
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

/ / -- Setter (UPDATE) procedure for ADRESSE
CREATE
OR REPLACE PROCEDURE update_adresse (
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

/ -- Table COMMANDE
-- Procedure pour insérer une ligne dans la table COMMANDE
CREATE
OR REPLACE PROCEDURE insert_commande (
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

/ -- Procedure pour supprimer une ligne dans la table COMMANDE depuis COMMANDE_UID
CREATE
OR REPLACE PROCEDURE delete_commande (p_commande_uid IN VARCHAR2) IS BEGIN
DELETE FROM
    COMMANDE
WHERE
    COMMANDE_UID = p_commande_uid;

COMMIT;

END delete_commande;

/ -- Procedure pour mettre à jour une ligne dans la table COMMANDE depuis COMMANDE_UID
CREATE
OR REPLACE PROCEDURE update_commande (
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

/ -- Fonction pour récupérer une ligne dans la table COMMANDE depuis COMMANDE_UID
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

/ -- Création d'un jeu de donnée de test
-- Insertion des utilisateurs
BEGIN insert_utilisateur(
    '1',
    1,
    'John',
    'Doe',
    'john.doe@example.com',
    0,
    SYSDATE,
    NULL
);

insert_utilisateur(
    '2',
    2,
    'Jane',
    'Smith',
    'jane.smith@example.com',
    1,
    SYSDATE,
    NULL
);

insert_utilisateur(
    '3',
    3,
    'Alice',
    'Johnson',
    'alice.johnson@example.com',
    0,
    SYSDATE,
    NULL
);

insert_utilisateur(
    '4',
    4,
    'Bob',
    'Brown',
    'bob.brown@example.com',
    1,
    SYSDATE,
    NULL
);

END;

/ -- Insertion des adresses
BEGIN
    insert_adresse('1', 'Adresse1', '123 Rue de la Paix', 'Île-de-France', 'U1', 1, SYSDATE, NULL);
    insert_adresse('2', 'Adresse2', '456 Avenue des Champs-Élysées', 'Auvergne-Rhône-Alpes', 'U2', 0, SYSDATE, NULL);
    insert_adresse('3', 'Adresse3', '789 Boulevard Saint-Germain', 'Provence-Alpes-Côte d Azur', 'U3', 1, SYSDATE, NULL);
END;

/ -- Insertion des commandes
BEGIN insert_commande('1', SYSDATE, '1', '2', '1', '2', 150.00);

-- Ajout du montant total pour la commande 1
insert_commande('2', SYSDATE, '3', '4', '2', '1', 200.00);

-- Ajout du montant total pour la commande 2
insert_commande('3', SYSDATE, '2', '3', '3', '3', 250.00);

-- Ajout du montant total pour la commande 3
END;

/ / -- Test des getters
-- Test du getter pour UTILISATEUR avec l'ID 1
DECLARE utilisateur_cursor SYS_REFCURSOR;

v_utilisateur_uid VARCHAR2(255);

v_utilisateur_id NUMBER;

v_nom VARCHAR2(200);

v_prenom VARCHAR2(200);

v_email VARCHAR2(255);

v_est_vendeur NUMBER;

v_date_creation DATE;

v_date_suppression DATE;

BEGIN get_utilisateur('1', utilisateur_cursor);

FETCH utilisateur_cursor INTO v_utilisateur_uid,
v_utilisateur_id,
v_nom,
v_prenom,
v_email,
v_est_vendeur,
v_date_creation,
v_date_suppression;

DBMS_OUTPUT.PUT_LINE('Résultats pour l''utilisateur avec l''ID 1:');

DBMS_OUTPUT.PUT_LINE('-----------------------------------------');

DBMS_OUTPUT.PUT_LINE('Utilisateur UID: ' || v_utilisateur_uid);

DBMS_OUTPUT.PUT_LINE('Utilisateur ID: ' || v_utilisateur_id);

DBMS_OUTPUT.PUT_LINE('Nom: ' || v_nom);

DBMS_OUTPUT.PUT_LINE('Prénom: ' || v_prenom);

DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);

DBMS_OUTPUT.PUT_LINE('Est Vendeur: ' || v_est_vendeur);

DBMS_OUTPUT.PUT_LINE(
    'Date de création: ' || TO_CHAR(v_date_creation, 'YYYY-MM-DD')
);

DBMS_OUTPUT.PUT_LINE(
    'Date de suppression: ' || NVL(TO_CHAR(v_date_suppression, 'YYYY-MM-DD'), 'N/A')
);

DBMS_OUTPUT.PUT_LINE('-----------------------------------------');

CLOSE utilisateur_cursor;

END;

/**VIEW*/
-- permet d'avoir le nombre d'utilisateur part region
CREATE
OR REPLACE VIEW VUE_UTILISATEURS_REGION AS
SELECT
    a.ADRESSE_REGION,
    COUNT(DISTINCT a.UTILISATEUR_UID) AS NOMBRE_UTILISATEURS,
    ROUND(
        (
            COUNT(DISTINCT a.UTILISATEUR_UID) / total.total_users
        ) * 100,
        2
    ) AS POURCENTAGE
FROM
    ADRESSE a,
    (
        SELECT
            COUNT(DISTINCT UTILISATEUR_UID) AS total_users
        FROM
            ADRESSE
        WHERE
            UTILISATEUR_UID IS NOT NULL
    ) total
WHERE
    a.UTILISATEUR_UID IS NOT NULL
GROUP BY
    a.ADRESSE_REGION,
    total.total_users;

-- Cette vue peut montrer pour chaque utilisateur :
--     Le nombre total de commandes.
--     La date de la première commande.
--     La date de la dernière commande.
--     Le montant total dépensé
CREATE
OR REPLACE VIEW VUE_STATISTIQUES_COMMANDES_UTILISATEUR AS
SELECT
    u.UTILISATEUR_UID,
    u.NOM,
    u.PRENOM,
    u.EMAIL,
    COUNT(c.COMMANDE_UID) AS TOTAL_COMMANDES,
    MIN(c.COMMANDE_DATE) AS PREMIERE_COMMANDE,
    MAX(c.COMMANDE_DATE) AS DERNIERE_COMMANDE,
    NVL(SUM(c.MONTANT_TOTAL), 0) AS MONTANT_TOTAL_DEPENSE,
    ROUND(
        (NVL(SUM(c.MONTANT_TOTAL), 0) / t.TOTAL_GLOBAL) * 100,
        2
    ) AS POURCENTAGE_DU_TOTAL_GLOBAL
FROM
    UTILISATEUR u
    LEFT JOIN COMMANDE c ON u.UTILISATEUR_UID = c.UTILISATEUR_ACHETEUR_UID,
    (
        SELECT
            NVL(SUM(MONTANT_TOTAL), 0) AS TOTAL_GLOBAL
        FROM
            COMMANDE
    ) t
GROUP BY
    u.UTILISATEUR_UID,
    u.NOM,
    u.PRENOM,
    u.EMAIL,
    t.TOTAL_GLOBAL;