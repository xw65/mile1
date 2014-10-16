CREATE TABLE Cases(
       serial INTEGER NOT NULL PRIMARY KEY,
       name VARCHAR(255) NOT NULL,
       issue VARCHAR(255) NOT NULL,
       technical_area VARCHAR(255) NOT NULL,
       day DATE NOT NULL,
       result VARCHAR(255)
       	      CHECK(result = 'def' OR result = 'plt')
);

CREATE TABLE Court(
       court_id INTEGER NOT NULL PRIMARY KEY,
       name varchar(255) NOT NULL,
       city varchar(255) NOT NULL,
       state varchar(255) NOT NULL,
       level varchar(255) NOT NULL CHECK(level = 'trial' OR level = 'appellate' OR level = 'supreme')
);

CREATE TABLE En_banc_reviewed(
       lower_case_serial INTEGER NOT NULL REFERENCES Cases(serial),
       en_banc_case_serial INTEGER NOT NULL REFERENCES Cases(serial)
       			   CHECK(lower_case_serial <> en_banc_case_serial),
       PRIMARY KEY(lower_case_serial, en_banc_case_serial) 
);

CREATE TABLE Judge(
       court_id INTEGER NOT NULL REFERENCES Court(court_id),
       judge_id INTEGER NOT NULL,
       name varchar(255) NOT NULL,
       gender VARCHAR(255) CHECK(gender = 'male' OR gender = 'female'),       
       location varchar(255) NOT NULL,
       birthday date,
       nomination_date DATE NOT NULL,
       nominated_by varchar(255) NOT NULL,
       title varchar(255) NOT NULL,
       PRIMARY KEY(court_id, judge_id)
);

CREATE TABLE Party(
       party_id INTEGER NOT NULL PRIMARY KEY,
       name VARCHAR(255) NOT NULL,
       size INTEGER NOT NULL,
       location VARCHAR(255) NOT NULL,
       race VARCHAR(255)
       	    CHECK((race IS NULL) OR race = 'asi' OR race = 'afr' OR race = 'eur'
                 OR race = 'nat' OR race = 'his' OR race = 'pac' 
	   	 OR race = 'other'),
       gender VARCHAR(255)
       	    CHECK((gender IS NULL) OR gender = 'male' OR gender = 'female'),
       political_affiliation VARCHAR(255)
            CHECK((political_affiliation IS NULL) OR 
                 political_affiliation = 'dem' OR
	         political_affiliation = 'rep')
);

CREATE TABLE Involved(
       serial INTEGER NOT NULL REFERENCES Cases(serial),
       party_id INTEGER NOT NULL REFERENCES Party(party_id),
       status VARCHAR(255) NOT NULL CHECK(status='plt' OR status = 'def'),
       PRIMARY KEY(serial, party_id) 
);

CREATE TABLE Rules(
       serial INTEGER NOT NULL REFERENCES Cases(serial),
       court_id INTEGER NOT NULL,
       judge_id INTEGER NOT NULL,
       decision VARCHAR(255) 
             CHECK(decision = 'def' OR decision = 'plt'),
       PRIMARY KEY(serial, judge_id, court_id),
       FOREIGN KEY(judge_id, court_id) REFERENCES Judge(judge_id, court_id) 
);

CREATE TABLE Supreme_court_reviewed(
       en_banc_case_serial INTEGER NOT NULL REFERENCES Cases(serial),	
       supreme_case_serial INTEGER NOT NULL REFERENCES Cases(serial)
             CHECK(en_banc_case_serial <> supreme_case_serial),
       PRIMARY KEY(en_banc_case_serial, supreme_case_serial)
);

CREATE TABLE Tech_judge(
       court_id INTEGER NOT NULL,
       judge_id INTEGER NOT NULL,
       background varchar(255) NOT NULL CHECK(background = 'bio' OR background = 'ecs' OR background = 'other'),
       PRIMARY KEY(court_id, judge_id),
       FOREIGN KEY(court_id, judge_id) REFERENCES Judge(court_id, judge_id)
);
