-- 길따라장따라 1인 개발 MVP PostgreSQL 스키마
-- 운영에서는 pgcrypto와 pgvector 사용 여부를 별도 마이그레이션으로 관리한다.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE place_type AS ENUM (
  'MARKET_STALL', 'ATTRACTION', 'RESTAURANT', 'CAFE',
  'PARKING', 'TOILET', 'CULTURE', 'ETC'
);
CREATE TYPE plan_status AS ENUM ('DRAFT', 'SAVED', 'COMPLETED', 'DELETED');
CREATE TYPE source_status AS ENUM ('ACTIVE', 'SUSPECTED_CLOSED', 'CLOSED', 'HIDDEN');

CREATE TABLE app_user (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE,
  nickname VARCHAR(50) NOT NULL,
  auth_provider VARCHAR(20),
  auth_provider_id VARCHAR(255),
  preferences JSONB NOT NULL DEFAULT '{}'::jsonb,
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE market (
  market_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(200) NOT NULL,
  market_type VARCHAR(50),
  open_cycle VARCHAR(50),
  road_address VARCHAR(255),
  jibun_address VARCHAR(255),
  latitude NUMERIC(10,7) NOT NULL,
  longitude NUMERIC(10,7) NOT NULL,
  phone VARCHAR(30),
  item_categories TEXT,
  parking_summary TEXT,
  toilet_summary TEXT,
  source_name VARCHAR(100) NOT NULL,
  source_record_id VARCHAR(150),
  source_url TEXT,
  data_reference_date DATE,
  fetched_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  verified_at TIMESTAMPTZ,
  status source_status NOT NULL DEFAULT 'ACTIVE',
  UNIQUE (source_name, source_record_id)
);

CREATE TABLE market_calendar (
  calendar_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id UUID NOT NULL REFERENCES market(market_id) ON DELETE CASCADE,
  calendar_date DATE NOT NULL,
  is_open BOOLEAN NOT NULL,
  source VARCHAR(100) NOT NULL,
  note VARCHAR(255),
  UNIQUE (market_id, calendar_date)
);

CREATE TABLE place (
  place_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id UUID REFERENCES market(market_id) ON DELETE SET NULL,
  place_type place_type NOT NULL,
  name VARCHAR(200) NOT NULL,
  category_large VARCHAR(100),
  category_mid VARCHAR(100),
  category_small VARCHAR(100),
  road_address VARCHAR(255),
  latitude NUMERIC(10,7) NOT NULL,
  longitude NUMERIC(10,7) NOT NULL,
  phone VARCHAR(30),
  opening_hours JSONB NOT NULL DEFAULT '{}'::jsonb,
  closed_days VARCHAR(255),
  description TEXT,
  image_url TEXT,
  tags JSONB NOT NULL DEFAULT '[]'::jsonb,
  source_name VARCHAR(100) NOT NULL,
  source_record_id VARCHAR(150),
  source_url TEXT,
  data_reference_date DATE,
  fetched_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  verified_at TIMESTAMPTZ,
  status source_status NOT NULL DEFAULT 'ACTIVE',
  UNIQUE (source_name, source_record_id)
);

CREATE INDEX idx_market_location ON market (latitude, longitude);
CREATE INDEX idx_place_location ON place (latitude, longitude);
CREATE INDEX idx_place_market_type ON place (market_id, place_type);

CREATE TABLE local_event (
  event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(200) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  venue VARCHAR(255),
  road_address VARCHAR(255),
  latitude NUMERIC(10,7),
  longitude NUMERIC(10,7),
  description TEXT,
  homepage_url TEXT,
  source_name VARCHAR(100) NOT NULL,
  source_record_id VARCHAR(150),
  fetched_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (source_name, source_record_id)
);

CREATE TABLE trip_plan (
  plan_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES app_user(user_id) ON DELETE CASCADE,
  title VARCHAR(200) NOT NULL,
  travel_date DATE NOT NULL,
  start_address VARCHAR(255),
  start_latitude NUMERIC(10,7),
  start_longitude NUMERIC(10,7),
  conditions JSONB NOT NULL,
  total_distance_m INTEGER,
  total_duration_min INTEGER,
  status plan_status NOT NULL DEFAULT 'DRAFT',
  recommendation_version VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE trip_plan_item (
  item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID NOT NULL REFERENCES trip_plan(plan_id) ON DELETE CASCADE,
  market_id UUID REFERENCES market(market_id) ON DELETE SET NULL,
  place_id UUID REFERENCES place(place_id) ON DELETE SET NULL,
  event_id UUID REFERENCES local_event(event_id) ON DELETE SET NULL,
  visit_order SMALLINT NOT NULL,
  arrival_at TIMESTAMPTZ,
  stay_minutes SMALLINT,
  distance_from_previous_m INTEGER,
  duration_from_previous_min INTEGER,
  recommendation_reason TEXT,
  UNIQUE (plan_id, visit_order),
  CHECK (num_nonnulls(market_id, place_id, event_id) = 1)
);

CREATE TABLE favorite (
  favorite_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
  target_type VARCHAR(20) NOT NULL CHECK (target_type IN ('MARKET', 'PLACE', 'PLAN')),
  target_id UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, target_type, target_id)
);

CREATE TABLE qr_code (
  qr_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  market_id UUID REFERENCES market(market_id) ON DELETE CASCADE,
  place_id UUID REFERENCES place(place_id) ON DELETE CASCADE,
  token_hash VARCHAR(255) NOT NULL UNIQUE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  issued_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK ((market_id IS NOT NULL) <> (place_id IS NOT NULL))
);

CREATE TABLE visit (
  visit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
  qr_id UUID REFERENCES qr_code(qr_id) ON DELETE SET NULL,
  market_id UUID REFERENCES market(market_id) ON DELETE SET NULL,
  place_id UUID REFERENCES place(place_id) ON DELETE SET NULL,
  verification_method VARCHAR(20) NOT NULL CHECK (verification_method IN ('QR', 'MANUAL')),
  visited_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (market_id IS NOT NULL OR place_id IS NOT NULL)
);

CREATE TABLE review (
  review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
  visit_id UUID REFERENCES visit(visit_id) ON DELETE SET NULL,
  market_id UUID REFERENCES market(market_id) ON DELETE SET NULL,
  place_id UUID REFERENCES place(place_id) ON DELETE SET NULL,
  rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  content VARCHAR(1000),
  is_reported BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (market_id IS NOT NULL OR place_id IS NOT NULL)
);

