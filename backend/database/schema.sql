CREATE TABLE feature_flags (
  id TEXT PRIMARY KEY,       
  value TEXT NOT NULL,       
  enabled BOOLEAN DEFAULT 1,
  rollout_percentage INT DEFAULT 100,
  beta_users TEXT,           
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);