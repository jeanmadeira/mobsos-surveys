drop schema if exists mobsos;
create schema if not exists mobsos default character set utf8 collate utf8_general_ci;
use mobsos;

grant usage on *.* to acdsense@localhost identified by 'dito'; 
grant all privileges on mobsos.* to acdsense@localhost;

drop table if exists questionnaire;
drop table if exists survey;
drop table if exists survey_context;

-- -----------------------------------------------------
-- Definition table 'questionnaire'
-- -----------------------------------------------------
create table questionnaire (
	id mediumint not null auto_increment,
	owner varchar(128) not null,
	organization varchar(128) not null,
	logo varchar(200) not null,
	name varchar(128) not null,
	description varchar(512) not null,
	form mediumtext,
	constraint questionnaire_pk primary key (id),
	constraint questionnaire_uk unique key (name)
);

create index idx_q_own on questionnaire (owner);
create index idx_q_org on questionnaire (organization);
create index idx_q_log on questionnaire (logo);
create fulltext index idx_q_dsc on questionnaire (description);

-- -----------------------------------------------------
-- Definition table 'survey'
-- -----------------------------------------------------
create table survey (
	id mediumint not null auto_increment,
	owner varchar(128) not null,
	organization varchar(128) not null,
	logo varchar(200) not null,
	name varchar(128) not null,
	description varchar(512) not null,
	resource varchar(128) not null,
	start datetime(6) not null,
	end datetime(6) not null,
	qid mediumint,
	constraint surveypk primary key (id),
	constraint survey_uk unique key (name),
	constraint survey_q_fk foreign key (qid) references questionnaire (id),
	constraint survey_time check (end_time > start_time)
);

create index idx_s_owner on survey(owner);
create index idx_s_org on survey (organization);
create index idx_s_log on survey (logo);
create fulltext index idx_s_topic on survey(resource);
create fulltext index idx_s_desc on survey(description);

-- -----------------------------------------------------
-- Definition table 'survey_context'
-- -----------------------------------------------------
create table survey_context ( 
	sid mediumint not null,
	qid mediumint not null,
	aid mediumint not null,
	constraint struct_pk primary key (sid,qid,aid),
	constraint struct_fk_sid foreign key (sid) references survey(id)
		on delete cascade
		on update no action,
	constraint struct_fk_qid foreign key (qid) references questionnaire(id)
		on delete cascade
		on update no action 
);

