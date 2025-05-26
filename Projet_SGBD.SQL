--------------------------------------------------------- partie 1. Mise en Place de la Base de Données----------------------------
-- Table AVION
CREATE TABLE AVION (
    id_avion VARCHAR2(10) PRIMARY KEY,
    modele VARCHAR2(50) NOT NULL,
    capacite NUMBER NOT NULL,
    type VARCHAR2(30) NOT NULL
);

-- Table AEROPORT
CREATE TABLE AEROPORT (
    id_aeroport VARCHAR2(5) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    ville VARCHAR2(50) NOT NULL,
    pays VARCHAR2(50) DEFAULT 'Tunisie'
);

-- Table VOL
CREATE TABLE VOL (
    id_vol VARCHAR2(10) PRIMARY KEY,
    date_depart DATE NOT NULL,
    heure_depart VARCHAR2(5) NOT NULL,
    heure_arrivee VARCHAR2(5) NOT NULL,
    id_avion VARCHAR2(10) NOT NULL,
    aeroport_depart VARCHAR2(5) NOT NULL,
    aeroport_arrivee VARCHAR2(5) NOT NULL,
    CONSTRAINT fk_vol_avion FOREIGN KEY (id_avion) REFERENCES AVION(id_avion),
    CONSTRAINT fk_vol_depart FOREIGN KEY (aeroport_depart) REFERENCES AEROPORT(id_aeroport),
    CONSTRAINT fk_vol_arrivee FOREIGN KEY (aeroport_arrivee) REFERENCES AEROPORT(id_aeroport),
    CONSTRAINT chk_heure_depart CHECK (REGEXP_LIKE(heure_depart, '^[0-2][0-9]:[0-5][0-9]$')),
    CONSTRAINT chk_heure_arrivee CHECK (REGEXP_LIKE(heure_arrivee, '^[0-2][0-9]:[0-5][0-9]$'))
);

-- Table PASSAGER
CREATE TABLE PASSAGER (
    id_passager VARCHAR2(10) PRIMARY KEY,
    nom VARCHAR2(50) NOT NULL,
    prenom VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    telephone VARCHAR2(20) NOT NULL,
    CONSTRAINT chk_email CHECK 
    (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);

-- Table RESERVATION
CREATE TABLE RESERVATION (
    id_reservation VARCHAR2(10) PRIMARY KEY,
    id_passager VARCHAR2(10) NOT NULL,
    id_vol VARCHAR2(10) NOT NULL,
    date_reservation DATE DEFAULT SYSDATE,
    statut VARCHAR2(20) DEFAULT 'confirmé',
    CONSTRAINT fk_reservation_passager 
    FOREIGN KEY (id_passager) REFERENCES PASSAGER(id_passager),
    CONSTRAINT fk_reservation_vol 
    FOREIGN KEY (id_vol) REFERENCES VOL(id_vol),
    CONSTRAINT chk_statut 
    CHECK (statut IN ('confirmé', 'annulé', 'en attente'))
);

-- Table EMPLOYE
CREATE TABLE EMPLOYE (
    id_employee VARCHAR2(10) PRIMARY KEY,
    nom VARCHAR2(50) NOT NULL,
    prenom VARCHAR2(50) NOT NULL,
    poste VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    CONSTRAINT chk_employee_email CHECK 
    (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);

-- Table ASSIGNATION_EQUIPAGE
CREATE TABLE ASSIGNATION_EQUIPAGE (
    id_vol VARCHAR2(10) NOT NULL,
    id_employee VARCHAR2(10) NOT NULL,
    role VARCHAR2(50) NOT NULL,
    PRIMARY KEY (id_vol, id_employee),
    CONSTRAINT fk_assignation_vol 
    FOREIGN KEY (id_vol) REFERENCES VOL(id_vol),
    CONSTRAINT fk_assignation_employee 
    FOREIGN KEY (id_employee) REFERENCES EMPLOYE(id_employee)
);

-- Table BAGAGE
CREATE TABLE BAGAGE (
    id_bagage VARCHAR2(10) PRIMARY KEY,
    poids NUMBER(5,2) NOT NULL,
    id_reservation VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_bagage_reservation
    FOREIGN KEY (id_reservation) REFERENCES RESERVATION(id_reservation),
    CONSTRAINT chk_poids CHECK (poids BETWEEN 1 AND 32)
);

-- Table PRESENCE_VOL
CREATE TABLE PRESENCE_VOL (
    id_passager VARCHAR2(10) NOT NULL,
    id_vol VARCHAR2(10) NOT NULL,
    etat_presence VARCHAR2(20) DEFAULT 'présent',
    PRIMARY KEY (id_passager, id_vol),
    CONSTRAINT fk_presence_passager 
    FOREIGN KEY (id_passager) REFERENCES PASSAGER(id_passager),
    CONSTRAINT fk_presence_vol 
    FOREIGN KEY (id_vol) REFERENCES VOL(id_vol),
    CONSTRAINT chk_etat_presence 
    CHECK (etat_presence IN ('présent', 'absent', 'embarqué', 'annulé'))
);

-- Table UTILISATEUR
CREATE TABLE UTILISATEUR (
    id_user VARCHAR2(10) PRIMARY KEY,
    login VARCHAR2(50) UNIQUE NOT NULL,
    mot_de_passe VARCHAR2(100) NOT NULL,
    profil VARCHAR2(30) NOT NULL,
    CONSTRAINT chk_profil 
    CHECK (profil IN ('administrateur', 'agent_reservation', 'personnel_navigant'))
);

---insertion dans les tables ---
-- Insertion des avions
INSERT INTO AVION VALUES ('TN001', 'Airbus A320', 180, 'Moyen-courrier');
INSERT INTO AVION VALUES ('TN002', 'Boeing 737', 160, 'Moyen-courrier');
INSERT INTO AVION VALUES ('TN003', 'Airbus A330', 300, 'Long-courrier');
INSERT INTO AVION VALUES ('TN004', 'ATR 72', 70, 'Régional');
INSERT INTO AVION VALUES ('TN005', 'Embraer 190', 100, 'Régional');

-- Insertion des aéroports tunisiens
INSERT INTO AEROPORT VALUES ('TUN', 'Aéroport International de Tunis-Carthage', 'Tunis', 'Tunisie');
INSERT INTO AEROPORT VALUES ('SFA', 'Aéroport International de Sfax-Thyna', 'Sfax', 'Tunisie');
INSERT INTO AEROPORT VALUES ('DJE', 'Aéroport International de Djerba-Zarzis', 'Djerba', 'Tunisie');
INSERT INTO AEROPORT VALUES ('TOE', 'Aéroport International de Tozeur-Nefta', 'Tozeur', 'Tunisie');
INSERT INTO AEROPORT VALUES ('MIR', 'Aéroport International de Monastir-Habib Bourguiba', 'Monastir', 'Tunisie');

-- Insertion des vols
INSERT INTO VOL VALUES ('TU1001', TO_DATE('15/05/2025', 'DD/MM/YYYY'), '08:00', '09:00', 'TN001', 'TUN', 'SFA');
INSERT INTO VOL VALUES ('TU1002', TO_DATE('15/05/2025', 'DD/MM/YYYY'), '10:30', '11:45', 'TN002', 'SFA', 'TUN');
INSERT INTO VOL VALUES ('TU1003', TO_DATE('16/05/2025', 'DD/MM/YYYY'), '14:00', '15:30', 'TN003', 'TUN', 'DJE');
INSERT INTO VOL VALUES ('TU1004', TO_DATE('16/05/2025', 'DD/MM/YYYY'), '16:00', '17:15', 'TN004', 'DJE', 'TUN');
INSERT INTO VOL VALUES ('TU1005', TO_DATE('17/05/2025', 'DD/MM/YYYY'), '09:30', '10:45', 'TN005', 'TUN', 'MIR');

-- Insertion des passagers tunisiens
INSERT INTO PASSAGER VALUES ('P001', 'Ben Ali', 'Mohamed', 'mohamed.benali@email.com', '20123456');
INSERT INTO PASSAGER VALUES ('P002', 'Trabelsi', 'Amira', 'amira.trabelsi@email.com', '98123456');
INSERT INTO PASSAGER VALUES ('P003', 'Masmoudi', 'Karim', 'karim.masmoudi@email.com', '50123456');
INSERT INTO PASSAGER VALUES ('P004', 'Gharbi', 'Leila', 'leila.gharbi@email.com', '22123456');
INSERT INTO PASSAGER VALUES ('P005', 'Saadi', 'Youssef', 'youssef.saadi@email.com', '95123456');

-- Insertion des réservations
INSERT INTO RESERVATION VALUES ('R001', 'P001', 'TU1001', TO_DATE('01/05/2025', 'DD/MM/YYYY'), 'confirmé');
INSERT INTO RESERVATION VALUES ('R002', 'P002', 'TU1001', TO_DATE('02/05/2025', 'DD/MM/YYYY'), 'confirmé');
INSERT INTO RESERVATION VALUES ('R003', 'P003', 'TU1002', TO_DATE('03/05/2025', 'DD/MM/YYYY'), 'annulé');
INSERT INTO RESERVATION VALUES ('R004', 'P004', 'TU1003', TO_DATE('04/05/2025', 'DD/MM/YYYY'), 'confirmé');
INSERT INTO RESERVATION VALUES ('R005', 'P005', 'TU1004', TO_DATE('05/05/2025', 'DD/MM/YYYY'), 'en attente');

-- Insertion des employés
INSERT INTO EMPLOYE VALUES ('E001', 'Bouzid', 'Ali', 'Pilote', 'ali.bouzid@tunisair.com');
INSERT INTO EMPLOYE VALUES ('E002', 'Mansour', 'Samira', 'Hôtesse de l''air', 'samira.mansour@tunisair.com');
INSERT INTO EMPLOYE VALUES ('E003', 'Haddad', 'Nabil', 'Copilote', 'nabil.haddad@tunisair.com');
INSERT INTO EMPLOYE VALUES ('E004', 'Cherif', 'Salma', 'Agent de bord', 'salma.cherif@tunisair.com');
INSERT INTO EMPLOYE VALUES ('E005', 'Khalifa', 'Hichem', 'Pilote', 'hichem.khalifa@tunisair.com');

-- Insertion des assignations d'équipage
INSERT INTO ASSIGNATION_EQUIPAGE VALUES ('TU1001', 'E001', 'Commandant de bord');
INSERT INTO ASSIGNATION_EQUIPAGE VALUES ('TU1001', 'E002', 'Hôtesse principale');
INSERT INTO ASSIGNATION_EQUIPAGE VALUES ('TU1002', 'E003', 'Copilote');
INSERT INTO ASSIGNATION_EQUIPAGE VALUES ('TU1003', 'E001', 'Commandant de bord');
INSERT INTO ASSIGNATION_EQUIPAGE VALUES ('TU1004', 'E005', 'Commandant de bord');

-- Insertion des bagages
INSERT INTO BAGAGE VALUES ('B001', 23.5, 'R001');
INSERT INTO BAGAGE VALUES ('B002', 15.0, 'R001');
INSERT INTO BAGAGE VALUES ('B003', 18.0, 'R002');
INSERT INTO BAGAGE VALUES ('B004', 12.5, 'R003');
INSERT INTO BAGAGE VALUES ('B005', 20.0, 'R004');

-- Insertion des présences en vol
INSERT INTO PRESENCE_VOL VALUES ('P001', 'TU1001', 'présent');
INSERT INTO PRESENCE_VOL VALUES ('P002', 'TU1001', 'présent');
INSERT INTO PRESENCE_VOL VALUES ('P003', 'TU1002', 'absent');
INSERT INTO PRESENCE_VOL VALUES ('P004', 'TU1003', 'embarqué');
INSERT INTO PRESENCE_VOL VALUES ('P005', 'TU1004', 'annulé');

-- Insertion des utilisateurs
INSERT INTO UTILISATEUR VALUES ('U001', 'admin', 'admin123', 'administrateur');
INSERT INTO UTILISATEUR VALUES ('U002', 'agent1', 'agent456', 'agent_reservation');
INSERT INTO UTILISATEUR VALUES ('U003', 'pilot1', 'pilot789', 'personnel_navigant');
INSERT INTO UTILISATEUR VALUES ('U004', 'agent2', 'agent101', 'agent_reservation');
INSERT INTO UTILISATEUR VALUES ('U005', 'crew1', 'crew112', 'personnel_navigant');




----les séquences ----
CREATE SEQUENCE seq_reservation START WITH 6 INCREMENT BY 1;
--'R' || LPAD(seq_reservation.NEXTVAL, 3, '0')--
CREATE SEQUENCE seq_bagage START WITH 6 INCREMENT BY 1;
--'B' || LPAD(seq_bagage.NEXTVAL, 3, '0')--
CREATE SEQUENCE seq_passager START WITH 6 INCREMENT BY 1;
--'P' || LPAD(seq_passager.NEXTVAL, 3, '0')--
CREATE SEQUENCE seq_employe START WITH 6 INCREMENT BY 1;
--'E' || LPAD(seq_employe.NEXTVAL, 3, '0')--
CREATE SEQUENCE seq_utilisateur START WITH 6 INCREMENT BY 1;
--'U' || LPAD(seq_utilisateur.NEXTVAL, 3, '0')--


---------------------------------------------- partie 2. Gestion des Utilisateurs et des Profils d’Accès --------------------------------
-- 1. Création des profils ----

CREATE PROFILE admin_profil LIMIT
  PASSWORD_LIFE_TIME UNLIMITED
  FAILED_LOGIN_ATTEMPTS 3;

CREATE PROFILE agent_profile LIMIT
  PASSWORD_LIFE_TIME 90
  FAILED_LOGIN_ATTEMPTS 5;

CREATE PROFILE navigant_profile LIMIT
  PASSWORD_LIFE_TIME 60
  FAILED_LOGIN_ATTEMPTS 3;
SELECT * FROM DBA_PROFILES;

-- 2. Création des utilisateurs ---

CREATE USER admin_aviation IDENTIFIED BY "Admin123*"
PROFILE admin_profil
DEFAULT TABLESPACE USERS
ACCOUNT UNLOCK;

CREATE USER agent_reservation IDENTIFIED BY "Agent123*"
PROFILE agent_profile
DEFAULT TABLESPACE USERS
ACCOUNT UNLOCK;

--- ALTER USER agent_reservation IDENTIFIED BY "Agent123*";


CREATE USER personnel_nav IDENTIFIED BY "Pers123*"
PROFILE navigant_profile
DEFAULT TABLESPACE USERS
ACCOUNT UNLOCK;

-- 3. Attribution des droits
----- admin--------------------------------------------------------------------------------------------------------------
GRANT CONNECT ,RESOURCE,DBA TO admin_aviation

---- Agent de réservation-------------------------------------------------------------------------------------------------

GRANT CONNECT TO agent_reservation;


GRANT SELECT,INSERT,UPDATE,DELETE ON PASSAGER TO agent_reservation;
GRANT SELECT,INSERT,UPDATE ,DELETE ON RESERVATION TO agent_reservation;
GRANT SELECT ,INSERT ,UPDATE,DELETE ON VOL TO agent_reservation;

----------- Personnel navigant-------------------------------------------------------------------------------------------------

GRANT CONNECT TO personnel_nav;

CREATE OR REPLACE VIEW vols_assignes_view AS 
SELECT v.*
FROM VOL v
JOIN ASSIGNATION_EQUIPAGE ae ON v.id_vol=ae.id_vol
JOIN EMPLOYE e ON  e.id_employee=ae.id_employee
WHERE e.email=USER;

GRANT SELECT ON vols_assignes_view TO personnel_nav

CREATE OR REPLACE VIEW informations_passagers_view AS 
SELECT p.*
FROM PASSAGER p
JOIN PRESENCE_VOL pv ON p.id_passager=pv.id_passager
JOIN ASSIGNATION_EQUIPAGE a on a.id_vol=pv.id_vol
JOIN EMPLOYE e ON e.id_employee=a.id_employee
WHERE LOWER(e.email) = LOWER(USER); 

GRANT SELECT ON informations_passagers_view TO personnel_nav;
-------------------------------------------------------------- partie 3 : Requêtes Métier à Implémenter -----------------------------------------------------------------


--------------------------------------------------------------------------------
-- 1) Rechercher tous les vols disponibles entre deux aéroports à une date donnée
--   L’utilisateur saisit les codes des aéroports et la date ;
--   la requête retourne les vols dont le départ, l’arrivée et la date correspondent.
--------------------------------------------------------------------------------
ACCEPT depart      PROMPT 'Entrer le code de l''aéroport de départ (ex : TUN) : '
ACCEPT arrivee     PROMPT 'Entrer le code de l''aéroport d''arrivée (ex : SFA) : '
ACCEPT date_saisie PROMPT 'Entrer la date du vol (JJ/MM/AA, ex : 15/05/25) : '

SELECT *
FROM VOL
WHERE aeroport_depart = '&depart'
  AND aeroport_arrivee = '&arrivee'
  AND date_depart = TO_DATE('&date_saisie', 'DD/MM/YY');



--------------------------------------------------------------------------------
-- 2) Afficher les membres d’équipage d’un vol donné avec leurs rôles
--   L’utilisateur saisit l’ID du vol ; la requête liste les employés assignés
--   à ce vol et leur rôle (pilote, copilote, hôtesse, etc.).
--------------------------------------------------------------------------------
ACCEPT vol_id PROMPT 'Entrer l''ID du vol : '

SELECT E.nom,
       E.prenom,
       AE.role
FROM ASSIGNATION_EQUIPAGE AE
JOIN EMPLOYE E ON AE.id_employee = E.id_employee
WHERE AE.id_vol = '&vol_id';



--------------------------------------------------------------------------------
-- 3) Identifier les passagers ayant réservé un vol mais n’ayant pas embarqué
--   On joint PASSAGER→RESERVATION, puis LEFT JOIN PRESENCE_VOL ;
--   on retient les cas où aucun enregistrement de présence n’existe
--   ou où l’état est explicitement 'absent'.
--------------------------------------------------------------------------------
SELECT P.id_passager,
       P.nom,
       P.prenom,
       R.id_vol
FROM PASSAGER P
JOIN RESERVATION R ON P.id_passager = R.id_passager
LEFT JOIN PRESENCE_VOL PV
       ON PV.id_passager = P.id_passager
      AND PV.id_vol       = R.id_vol
WHERE PV.etat_presence IS NULL
   OR LOWER(PV.etat_presence) = 'absent';

   

--------------------------------------------------------------------------------
-- 4) Calculer le poids total des bagages par réservation
--   On groupe les enregistrements de BAGAGE par id_reservation
--   et on somme la colonne poids.
--------------------------------------------------------------------------------
SELECT id_reservation,
       SUM(poids) AS poids_total
FROM BAGAGE
GROUP BY id_reservation;



--------------------------------------------------------------------------------
-- 5) Identifier l’avion le plus utilisé
--   On compte le nombre de vols par id_avion dans VOL,
--   on ordonne par décompte décroissant et on prend le premier.
--------------------------------------------------------------------------------
SELECT id_avion,
       COUNT(*) AS nombre_utilisations
FROM VOL
GROUP BY id_avion
ORDER BY nombre_utilisations DESC
FETCH FIRST 1 ROWS ONLY;



--------------------------------------------------------------------------------
-- 6) Lister les réservations annulées
--   On filtre la table RESERVATION sur statut = 'annulé'.
--------------------------------------------------------------------------------
SELECT *
FROM RESERVATION
WHERE statut = 'annulé';



--------------------------------------------------------------------------------
-- 7) Calculer le taux d’occupation des vols
--   Pour chaque vol : on joint AVION pour récupérer la capacité,
--   on LEFT JOIN PRESENCE_VOL pour compter les passagers présents,
--   puis on calcule le pourcentage.
--------------------------------------------------------------------------------
SELECT V.id_vol,
       A.capacite,
       COUNT(PV.id_passager) AS nb_passagers,
       ROUND(COUNT(PV.id_passager) * 100.0 / A.capacite, 2) AS taux_occupation
FROM VOL V
JOIN AVION A ON V.id_avion = A.id_avion
LEFT JOIN PRESENCE_VOL PV
       ON V.id_vol = PV.id_vol
      AND PV.etat_presence = 'présent'
GROUP BY V.id_vol, A.capacite;



--------------------------------------------------------------------------------
-- 8) Déterminer le nombre moyen de bagages par passager
--   On calcule d’abord, pour chaque passager,
--   le nombre de bagages (JOIN puis GROUP BY),
--   puis on fait la moyenne de ces totaux.
--------------------------------------------------------------------------------
SELECT ROUND(AVG(nb_bagages), 2) AS moyenne_bagages_par_passager
FROM (
  SELECT R.id_passager,
         COUNT(B.id_bagage) AS nb_bagages
  FROM RESERVATION R
  LEFT JOIN BAGAGE B ON R.id_reservation = B.id_reservation
  GROUP BY R.id_passager
);


-------------------------------------------------------------- 4. Implémentation des Règles de Gestion -----------------------------------------------------------
--------------  1 Enregistrer une nouvelle réservation (création automatique des données liées).  --------------

CREATE OR REPLACE PROCEDURE AJOUTER_RESERVATION (
    v_id_reservation IN VARCHAR2,
    v_id_passager IN VARCHAR2,
    v_id_vol IN VARCHAR2,
    v_date_reservation IN DATE,
    v_statut IN VARCHAR2
) AS
    -- Déclaration des variables pour vérifier si les données existent
    v_exist_passager INTEGER;
    v_exist_vol INTEGER;
BEGIN
    -- Vérifier si le passager existe
    SELECT COUNT(*) INTO v_exist_passager 
    FROM PASSAGER 
    WHERE ID_PASSAGER = v_id_passager;

    -- Si le passager n'existe pas, l'ajouter
    IF v_exist_passager = 0 THEN
        INSERT INTO PASSAGER (ID_PASSAGER) 
        VALUES (v_id_passager); -- Ajouter d'autres informations selon les besoins
    END IF;

    -- Vérifier si le vol existe
    SELECT COUNT(*) INTO v_exist_vol 
    FROM VOL 
    WHERE ID_VOL = v_id_vol;

    -- Si le vol n'existe pas, l'ajouter
    IF v_exist_vol = 0 THEN
        INSERT INTO VOL (ID_VOL) 
        VALUES (v_id_vol); -- Ajouter d'autres informations selon les besoins
    END IF;

    -- Insertion de la réservation
    INSERT INTO RESERVATION (
        ID_RESERVATION, 
        ID_PASSAGER, 
        ID_VOL, 
        DATE_RESERVATION, 
        STATUT
    )
    VALUES (
        v_id_reservation, 
        v_id_passager, 
        v_id_vol, 
        v_date_reservation, 
        v_statut
    );
END AJOUTER_RESERVATION;
/
-- bech testi --
BEGIN
    AJOUTER_RESERVATION('R008', 'P001', 'TU1001', TO_DATE('06/05/2025', 'DD/MM/YYYY'), 'Confirmé');
END;
/



----------------2 Annuler une réservation et mettre à jour les enregistrements concernés. -- 
CREATE OR REPLACE PROCEDURE annuler_reservation (
    p_id_reservation IN VARCHAR2
) 
IS
BEGIN
    SAVEPOINT before_annulation;
    
    -- Correction : Vérifier l'orthographe exacte de 'annulé' selon la contrainte
    UPDATE RESERVATION
    SET statut = 'Annulé' -- Assurez-vous que l'accent est correct
    WHERE id_reservation = p_id_reservation;
    
    UPDATE PRESENCE_VOL pv
    SET pv.etat_presence = 'annulé' -- Même vérification ici
    WHERE EXISTS (
        SELECT 1
        FROM RESERVATION r
        WHERE r.id_reservation = p_id_reservation
        AND r.id_passager = pv.id_passager
        AND r.id_vol = pv.id_vol
    );
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO before_annulation;
        RAISE_APPLICATION_ERROR(-20001, 'Erreur d''annulation : ' || SQLERRM);
END annuler_reservation;
/
--pour tester --
BEGIN
    annuler_reservation('R005');
END;
/ 

----------- 3 Enregistrer la présence d’un passager à bord -------------------

CREATE OR REPLACE PROCEDURE enregistrer_presence (
    p_id_passager IN VARCHAR2,
    p_id_vol IN VARCHAR2,
    p_etat_presence IN VARCHAR2 DEFAULT 'présent'
) 
IS
    v_reservation_exist NUMBER;
BEGIN
    -- Vérification des valeurs autorisées
    IF p_etat_presence NOT IN ('présent', 'embarqué') THEN
        RAISE_APPLICATION_ERROR(-20002, 'État invalide. Valeurs autorisées : "présent" ou "embarqué"');
    END IF;

    -- Vérification de la réservation confirmée
    SELECT COUNT(*)
    INTO v_reservation_exist
    FROM RESERVATION
    WHERE id_passager = p_id_passager
    AND id_vol = p_id_vol
    AND statut = 'confirmé';

    IF v_reservation_exist = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Aucune réservation confirmée trouvée');
    END IF;

    -- Mise à jour de la présence avec vérification des clés
    UPDATE PRESENCE_VOL
    SET etat_presence = p_etat_presence
    WHERE id_passager = p_id_passager
    AND id_vol = p_id_vol;

    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence)
        VALUES (p_id_passager, p_id_vol, p_etat_presence);
    END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Présence enregistrée : ' || p_etat_presence);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Erreur lors de l''enregistrement : ' || SQLERRM);
END enregistrer_presence;
/
-- Pour marquer un passager comme présent
BEGIN
    enregistrer_presence('P001', 'TU1001', 'présent');
END;
/

-- Pour marquer un passager comme embarqué (valeur par défaut : 'présent')
BEGIN
    enregistrer_presence('P002', 'TU1001', 'embarqué');
END;
/

--verification --
SELECT * FROM PRESENCE_VOL 
WHERE id_passager = 'P001' AND id_vol = 'TU1001';


--------------------------4 . Obtenir la liste des vols affectés à un employé ------------------------

CREATE OR REPLACE PROCEDURE get_vols_par_employe (
    p_id_employee IN VARCHAR2,
    p_result OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
        SELECT 
            e.nom || ' ' || e.prenom AS employe_complet,
            ae.role,
            v.id_vol,
            v.date_depart,
            v.heure_depart,
            v.heure_arrivee,
            a_dep.nom AS aeroport_depart,
            a_arr.nom AS aeroport_arrivee,
            av.modele AS avion
        FROM EMPLOYE e
        JOIN ASSIGNATION_EQUIPAGE ae 
            ON e.id_employee = ae.id_employee
        JOIN VOL v 
            ON ae.id_vol = v.id_vol
        JOIN AEROPORT a_dep 
            ON v.aeroport_depart = a_dep.id_aeroport
        JOIN AEROPORT a_arr 
            ON v.aeroport_arrivee = a_arr.id_aeroport
        JOIN AVION av 
            ON v.id_avion = av.id_avion
        WHERE e.id_employee = p_id_employee
        ORDER BY v.date_depart DESC, v.heure_depart;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005, 
            'Erreur de récupération : ' || SQLERRM);
END get_vols_par_employe;
/

--utilisation --

DECLARE
    result SYS_REFCURSOR;
    v_employe VARCHAR2(101);
    v_role VARCHAR2(50);
    v_vol VARCHAR2(10);
    v_date DATE;
    v_heure_dep VARCHAR2(5);
    v_heure_arr VARCHAR2(5);
    v_aero_dep VARCHAR2(100);
    v_aero_arr VARCHAR2(100);
    v_avion VARCHAR2(50);
BEGIN
    get_vols_par_employe('E001', result);
    
    LOOP
        FETCH result INTO 
            v_employe,
            v_role,
            v_vol,
            v_date,
            v_heure_dep,
            v_heure_arr,
            v_aero_dep,
            v_aero_arr,
            v_avion;
        EXIT WHEN result%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            'Employé: ' || v_employe ||
            ' | Vol: ' || v_vol ||
            ' | Date: ' || TO_CHAR(v_date, 'DD/MM/YYYY') ||
            ' | Départ: ' || v_heure_dep || ' de ' || v_aero_dep ||
            ' | Arrivée: ' || v_heure_arr || ' à ' || v_aero_arr ||
            ' | Avion: ' || v_avion ||
            ' | Rôle: ' || v_role
        );
    END LOOP;
    CLOSE result;
END;
/
------------------------------------------------------------partie 5 Règles Métier Automatisées -----------------------------------------------------------------------
-----1 Création automatique d’un enregistrement de bagage lors d’une réservation.

 create or replace TRIGGER after_reservation_ajouterBagage1
 AFTER INSERT on RESERVATION
 FOR EACH ROW 
 BEGIN 
    INSERT INTO BAGAGE(id_bagage,poids,id_reservation)
     VALUES ('B' || LPAD(seq_bagage.NEXTVAL, 3, '0'), 0, :NEW.id_reservation);
 END;



-- -- -------exemple pour la tester 
INSERT INTO RESERVATION  
VALUES ('R006','P005','TU1001',TO_DATE('01/05/2025', 'DD/MM/YYYY'),'confirmé');


select * from RESERVATION;
 select * from BAGAGE;


-----------------------------------------------------------------------------------------------------------------------------
-- 2-Empêcher l’affectation d’un employé à deux vols simultanés.--

 CREATE OR REPLACE TRIGGER prevent_double_affectation
 BEFORE INSERT ON ASSIGNATION_EQUIPAGE
 FOR EACH ROW
 DECLARE
     nb_assignations NUMBER;
 BEGIN
     SELECT COUNT(*) INTO nb_assignations
     FROM ASSIGNATION_EQUIPAGE ae
     JOIN VOL v1 ON ae.id_vol = v1.id_vol
     JOIN VOL v2 ON v2.id_vol = :NEW.id_vol
     WHERE ae.id_employee = :NEW.id_employee
     AND v1.date_depart = v2.date_depart;

     IF nb_assignations > 0 THEN
       RAISE_APPLICATION_ERROR(-20002, 'Cet employé est déjà affecté à un vol ce jour-là.');
    END IF;
 END; 
 /

-- -------exemple pour la tester 
SELECT * FROM ASSIGNATION_EQUIPAGE;
 INSERT INTO ASSIGNATION_EQUIPAGE VALUES ('TU1004', 'E005', 'Commandant de bord');


-------------------------------------------------------------------------------------------------------------------------------------------
--3 Éviter qu’un passager soit réservé plusieurs fois sur le même vol.---
CREATE OR REPLACE TRIGGER passager_reserve_memevol
BEFORE INSERT ON  RESERVATION
 FOR EACH ROW 
 DECLARE passager_reserve_count NUMBER;
 BEGIN 
SELECT COUNT(*) INTO passager_reserve_count
FROM RESERVATION
WHERE  id_passager=:NEW.id_passager AND id_vol=:NEW.id_vol;

IF passager_reserve_count>0 THEN 
 RAISE_APPLICATION_ERROR(-20002, 'passager est deja reserve sur ce vol.');
END IF;  
/

------- test du trigger
 INSERT INTO RESERVATION VALUES ('R002', 'P002', 'TU1001', TO_DATE('02/05/2025', 'DD/MM/YYYY'), 'confirmé');




---- 4. creer une fonction de hachage (avec SHA-256): -----

CREATE OR REPLACE FUNCTION hash_mot_de_passe(mdp IN VARCHAR2)
RETURN VARCHAR2
IS
    hash_raw RAW(256);
BEGIN
    -- Hash the password using SHA-256
    hash_raw := DBMS_CRYPTO.HASH(
        UTL_I18N.STRING_TO_RAW(mdp, 'AL32UTF8'),
        DBMS_CRYPTO.HASH_SH256
    );

    -- Return the hash in hexadecimal format
    RETURN RAWTOHEX(hash_raw);
END;
/


-- ALTER FUNCTION hash_mot_de_passe COMPILE;
SELECT object_name, status FROM user_objects WHERE object_type = 'FUNCTION';


------ this to test if the function  hash_mot_de_passe works
SELECT hash_mot_de_passe('test123') FROM dual;


--------- le trigger de mot de passe
CREATE OR REPLACE TRIGGER trigger_hash_mdp
BEFORE INSERT OR UPDATE ON UTILISATEUR
FOR EACH ROW
BEGIN
    :NEW.mot_de_passe := hash_mot_de_passe(:NEW.mot_de_passe);
END;
/

----1. Testing  the triger with INSERT
INSERT INTO UTILISATEUR (id_user, login, mot_de_passe, profil)
VALUES ('U00', 'crew3', 'ranim123', 'agent_reservation');


-------seeing the result of the test
DESC UTILISATEUR;
SELECT * FROM UTILISATEUR;

------------------------ changement de session ----------------
Alter session set container=CDB$ROOT;
Alter session set container=XEPDB1;

----------- POUR VOIR LES  UTILISATEURS
SELECT USERNAME FROM DBA_USERS;
--------------------------------------------------------------partie 6. Partage de Données entre Schémas  ------------------

CREATE OR REPLACE VIEW vols_disponibles AS
SELECT id_vol, date_depart, heure_depart, heure_arrivee,
       aeroport_depart, aeroport_arrivee
FROM VOL;

-- Donner accès à cette vue
GRANT SELECT ON vols_disponibles TO agent_reservation;
SELECT table_name FROM all_tables WHERE owner = 'agent_reservation';




-- SELECT table_name FROM all_tables WHERE owner = 'ADMIN_AVIATION';
-----Check granted privileges
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'AGENT_RESERVATION';
SELECT * FROM USER_VIEWS WHERE VIEW_NAME IN ('VOLS_ASSIGNES_VIEW', 'INFORMATIONS_PASSAGERS_VIEW');



-------
-- -- Connect as agent_reservation in a NEW session/window
-- CONNECT agent_reservation/Agent123*@XEPDB1



SELECT * FROM PASSAGER; 
SELECT * FROM EMPLOYE; 
SELECT * FROM DBA_TAB_PRIVS 
WHERE TABLE_NAME = 'EMPLOYE' AND GRANTEE = 'PUBLIC';




SELECT owner, table_name 
FROM all_tables 
WHERE table_name IN ('PASSAGER','RESERVATION','VOL','EMPLOYE');


GRANT SELECT,INSERT,UPDATE,DELETE ON SYSTEM.PASSAGER TO agent_reservation;
GRANT SELECT,INSERT,UPDATE,DELETE ON SYSTEM.RESERVATION TO agent_reservation;
GRANT SELECT,INSERT,UPDATE,DELETE ON SYSTEM.VOL TO agent_reservation;

CREATE OR REPLACE PUBLIC SYNONYM PASSAGER FOR SYSTEM.PASSAGER;
CREATE OR REPLACE PUBLIC SYNONYM RESERVATION FOR SYSTEM.RESERVATION;
CREATE OR REPLACE PUBLIC SYNONYM VOL FOR SYSTEM.VOL;

SELECT table_name, privilege, owner 
FROM dba_tab_privs 
WHERE grantee = 'AGENT_RESERVATION';



SELECT owner, table_name FROM all_tables 
WHERE table_name IN ('PASSAGER','RESERVATION','VOL');



ALTER SESSION SET CONTAINER = CDB$ROOT;