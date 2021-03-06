-- ----------------------------------------------------------
--  driver: db2, generated: 2008-07-21 18:17:51
-- ----------------------------------------------------------
ALTER TABLE sla DROP CONSTRAINT FK_sla_service_id_id;

-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
RENAME TABLE system_user TO users;

-- ----------------------------------------------------------
--  create table queue_preferences
-- ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
);

CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);

-- ----------------------------------------------------------
--  create table service_sla
-- ----------------------------------------------------------
CREATE TABLE service_sla (
    service_id INTEGER NOT NULL,
    sla_id INTEGER NOT NULL,
    CONSTRAINT service_sla_service_sla UNIQUE (service_id, sla_id)
);

-- ----------------------------------------------------------
--  create table link_type
-- ----------------------------------------------------------
CREATE TABLE link_type (
    id SMALLINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_type_name UNIQUE (name)
);

-- ----------------------------------------------------------
--  create table link_state
-- ----------------------------------------------------------
CREATE TABLE link_state (
    id SMALLINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_state_name UNIQUE (name)
);

-- ----------------------------------------------------------
--  create table link_object
-- ----------------------------------------------------------
CREATE TABLE link_object (
    id SMALLINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR (100) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_object_name UNIQUE (name)
);

-- ----------------------------------------------------------
--  create table link_relation
-- ----------------------------------------------------------
CREATE TABLE link_relation (
    source_object_id SMALLINT NOT NULL,
    source_key VARCHAR (50) NOT NULL,
    target_object_id SMALLINT NOT NULL,
    target_key VARCHAR (50) NOT NULL,
    type_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    CONSTRAINT link_relation_view UNIQUE (source_object_id, source_key, target_object_id, target_key, type_id)
);

CREATE INDEX user_preferences_user_id ON user_preferences (user_id);

CREATE INDEX group_user_user_id ON group_user (user_id);

CREATE INDEX group_user_group_id ON group_user (group_id);

CREATE INDEX group_role_role_id ON group_role (role_id);

CREATE INDEX group_role_group_id ON group_role (group_id);

CREATE INDEX group_customer_user_user_id ON group_customer_user (user_id);

CREATE INDEX group_customer_user_group_id ON group_customer_user (group_id);

CREATE INDEX role_user_user_id ON role_user (user_id);

CREATE INDEX role_user_role_id ON role_user (role_id);

CREATE INDEX personal_queues_user_id ON personal_queues (user_id);

CREATE INDEX personal_queues_queue_id ON personal_queues (queue_id);

-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD first_response_notify SMALLINT;

-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD update_notify SMALLINT;

-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD solution_notify SMALLINT;

CREATE INDEX queue_group_id ON queue (group_id);

SET INTEGRITY FOR ticket OFF;

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket ADD COLUMN escalation_update_time INTEGER GENERATED ALWAYS AS (escalation_start_time);

SET INTEGRITY FOR ticket IMMEDIATE CHECKED FORCE GENERATED;

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket ALTER escalation_update_time DROP EXPRESSION;

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN escalation_start_time;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

ALTER TABLE ticket ALTER COLUMN escalation_update_time SET DEFAULT 0;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

ALTER TABLE ticket ALTER COLUMN escalation_update_time DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

UPDATE ticket SET escalation_update_time = 0 WHERE escalation_update_time IS NULL;

ALTER TABLE ticket ALTER COLUMN escalation_update_time SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket ADD escalation_time INTEGER;

UPDATE ticket SET escalation_time = 0 WHERE escalation_time IS NULL;

ALTER TABLE ticket ALTER COLUMN escalation_time SET DEFAULT 0;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

ALTER TABLE ticket ALTER COLUMN escalation_time SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

CREATE INDEX ticket_escalation_time ON ticket (escalation_time);

CREATE INDEX ticket_escalation_update_time ON ticket (escalation_update_time);

CREATE INDEX ticket_escalation_response_time ON ticket (escalation_response_time);

CREATE INDEX ticket_escalation_solution_time ON ticket (escalation_solution_time);

CREATE INDEX ticket_title ON ticket (title);

CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);

CREATE INDEX ticket_customer_id ON ticket (customer_id);

CREATE INDEX ticket_queue_id ON ticket (queue_id);

CREATE INDEX ticket_ticket_lock_id ON ticket (ticket_lock_id);

CREATE INDEX ticket_responsible_user_id ON ticket (responsible_user_id);

CREATE INDEX ticket_ticket_state_id ON ticket (ticket_state_id);

CREATE INDEX ticket_ticket_priority_id ON ticket (ticket_priority_id);

CREATE INDEX index_object_link_a_id ON object_link (object_link_a_id);

CREATE INDEX index_object_link_b_id ON object_link (object_link_b_id);

CREATE INDEX index_object_link_a_object ON object_link (object_link_a_object);

CREATE INDEX index_object_link_b_object ON object_link (object_link_b_object);

CREATE INDEX index_object_link_type ON object_link (object_link_type);

CREATE INDEX ticket_history_history_type_id ON ticket_history (history_type_id);

CREATE INDEX ticket_history_queue_id ON ticket_history (queue_id);

CREATE INDEX ticket_history_type_id ON ticket_history (type_id);

CREATE INDEX ticket_history_owner_id ON ticket_history (owner_id);

CREATE INDEX ticket_history_priority_id ON ticket_history (priority_id);

CREATE INDEX ticket_history_state_id ON ticket_history (state_id);

-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD first_response_notify SMALLINT;

-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD update_notify SMALLINT;

-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD solution_notify SMALLINT;

CREATE INDEX article_article_type_id ON article (article_type_id);

CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id);

-- ----------------------------------------------------------
--  create table article_search
-- ----------------------------------------------------------
CREATE TABLE article_search (
    id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from VARCHAR (3800),
    a_to VARCHAR (3800),
    a_cc VARCHAR (3800),
    a_subject VARCHAR (3800),
    a_message_id VARCHAR (3800),
    a_body CLOB (14062K) NOT NULL,
    incoming_time INTEGER NOT NULL,
    a_freekey1 VARCHAR (250),
    a_freetext1 VARCHAR (250),
    a_freekey2 VARCHAR (250),
    a_freetext2 VARCHAR (250),
    a_freekey3 VARCHAR (250),
    a_freetext3 VARCHAR (250),
    PRIMARY KEY(id)
);

CREATE INDEX article_search_article_sender_c7 ON article_search (article_sender_type_id);

CREATE INDEX article_search_article_type_id ON article_search (article_type_id);

CREATE INDEX article_search_message_id ON article_search (a_message_id);

CREATE INDEX article_search_ticket_id ON article_search (ticket_id);

CREATE INDEX ticket_watcher_user_id ON ticket_watcher (user_id);

ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);

ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);

ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);

CREATE INDEX ticket_index_queue_id ON ticket_index (queue_id);

CREATE INDEX ticket_index_group_id ON ticket_index (group_id);

ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);

ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);

ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);

CREATE INDEX postmaster_filter_f_name ON postmaster_filter (f_name);

CREATE INDEX generic_agent_jobs_job_name ON generic_agent_jobs (job_name);

-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
RENAME TABLE pop3_account TO mail_account;

-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
ALTER TABLE mail_account ADD account_type VARCHAR (20);

ALTER TABLE article ALTER COLUMN a_body SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

ALTER TABLE article ALTER COLUMN a_body DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

UPDATE article SET a_body = '' WHERE a_body IS NULL;

ALTER TABLE article ALTER COLUMN a_body SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

ALTER TABLE xml_storage ALTER COLUMN xml_content_value SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE xml_storage');

ALTER TABLE xml_storage ALTER COLUMN xml_content_value DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE xml_storage');

-- ----------------------------------------------------------
--  insert into table notifications
-- ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'iso-8859-1', 'en', 'Ticket Escalation Warning! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,the ticket "<OTRS_TICKET_TicketNumber>" will escalate!Escalation at: <OTRS_TICKET_EscalationDestinationDate>Escalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 1, current_timestamp, 1, current_timestamp);

-- ----------------------------------------------------------
--  insert into table notifications
-- ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'iso-8859-1', 'de', 'Ticket Eskalations-Warnung! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,das Ticket "<OTRS_TICKET_TicketNumber>" wird bald eskalieren!Eskalation um: <OTRS_TICKET_EscalationDestinationDate>Eskalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Bitte um Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 1, current_timestamp, 1, current_timestamp);

-- ----------------------------------------------------------
--  insert into table link_type
-- ----------------------------------------------------------
INSERT INTO link_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Normal', 1, 1, current_timestamp, 1, current_timestamp);

-- ----------------------------------------------------------
--  insert into table link_type
-- ----------------------------------------------------------
INSERT INTO link_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ParentChild', 1, 1, current_timestamp, 1, current_timestamp);

-- ----------------------------------------------------------
--  insert into table link_state
-- ----------------------------------------------------------
INSERT INTO link_state (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Valid', 1, 1, current_timestamp, 1, current_timestamp);

-- ----------------------------------------------------------
--  insert into table link_state
-- ----------------------------------------------------------
INSERT INTO link_state (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Temporary', 1, 1, current_timestamp, 1, current_timestamp);

ALTER TABLE queue_preferences ADD CONSTRAINT FK_queue_preferences_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);

ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);

ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);

ALTER TABLE link_type ADD CONSTRAINT FK_link_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);

ALTER TABLE link_type ADD CONSTRAINT FK_link_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);

ALTER TABLE link_type ADD CONSTRAINT FK_link_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);

ALTER TABLE link_state ADD CONSTRAINT FK_link_state_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);

ALTER TABLE link_state ADD CONSTRAINT FK_link_state_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);

ALTER TABLE link_state ADD CONSTRAINT FK_link_state_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);

ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_source_object_id_id FOREIGN KEY (source_object_id) REFERENCES link_object (id);

ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_target_object_id_id FOREIGN KEY (target_object_id) REFERENCES link_object (id);

ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_state_id_id FOREIGN KEY (state_id) REFERENCES link_state (id);

ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_type_id_id FOREIGN KEY (type_id) REFERENCES link_type (id);

ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);

ALTER TABLE article_search ADD CONSTRAINT FK_article_search_article_sender_type_id_id FOREIGN KEY (article_sender_type_id) REFERENCES article_sender_type (id);

ALTER TABLE article_search ADD CONSTRAINT FK_article_search_article_type_id_id FOREIGN KEY (article_type_id) REFERENCES article_type (id);

ALTER TABLE article_search ADD CONSTRAINT FK_article_search_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);

