-- Schema for mortgage loan application database
-- This file is fed to the LLM so it knows the table structure

-- Main application table
CREATE TABLE application (
    id INTEGER PRIMARY KEY,
    as_of_year SMALLINT NOT NULL,
    respondent_id TEXT NOT NULL,
    agency_code SMALLINT NOT NULL,
    loan_type SMALLINT NOT NULL,
    property_type SMALLINT NOT NULL,
    loan_purpose SMALLINT NOT NULL,
    owner_occupancy SMALLINT NOT NULL,
    loan_amount_000s INTEGER,
    preapproval SMALLINT NOT NULL,
    action_taken SMALLINT NOT NULL,
    msamd INTEGER,
    state_code SMALLINT NOT NULL,
    county_code INTEGER,
    census_tract_number DECIMAL(7,2),
    applicant_ethnicity SMALLINT NOT NULL,
    co_applicant_ethnicity SMALLINT NOT NULL,
    applicant_race_1 SMALLINT NOT NULL,
    applicant_sex SMALLINT NOT NULL,
    co_applicant_sex SMALLINT NOT NULL,
    applicant_income_000s INTEGER,
    purchaser_type SMALLINT NOT NULL,
    denial_reason_1 SMALLINT,
    denial_reason_2 SMALLINT,
    denial_reason_3 SMALLINT,
    rate_spread DECIMAL(5,2),
    hoepa_status SMALLINT NOT NULL,
    lien_status SMALLINT NOT NULL
);

-- Lookup tables with human-readable names
CREATE TABLE agency (
    agency_code SMALLINT PRIMARY KEY,
    agency_name TEXT NOT NULL,
    agency_abbr TEXT NOT NULL
);

CREATE TABLE loan_type (
    loan_type SMALLINT PRIMARY KEY,
    loan_type_name TEXT NOT NULL
);

CREATE TABLE property_type (
    property_type SMALLINT PRIMARY KEY,
    property_type_name TEXT NOT NULL
);

CREATE TABLE owner_occupancy (
    owner_occupancy SMALLINT PRIMARY KEY,
    owner_occupancy_name TEXT NOT NULL
);

CREATE TABLE action_taken (
    action_taken SMALLINT PRIMARY KEY,
    action_taken_name TEXT NOT NULL
);

CREATE TABLE denial_reason (
    denial_reason_code SMALLINT PRIMARY KEY,
    denial_reason_name TEXT NOT NULL
);

CREATE TABLE state (
    state_code SMALLINT PRIMARY KEY,
    state_name TEXT NOT NULL,
    state_abbr TEXT NOT NULL
);

CREATE TABLE county (
    county_code INTEGER PRIMARY KEY,
    county_name TEXT NOT NULL
);

-- Note: loan_amount_000s and applicant_income_000s are in thousands of dollars
-- Example: loan_amount_000s = 200 means $200,000
