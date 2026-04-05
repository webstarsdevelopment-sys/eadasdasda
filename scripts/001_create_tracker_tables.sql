-- Create sheets table to store Google Sheets configurations
CREATE TABLE IF NOT EXISTS sheets (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create call_statuses table to store call status for each lead
CREATE TABLE IF NOT EXISTS call_statuses (
  id SERIAL PRIMARY KEY,
  lead_id TEXT NOT NULL,
  sheet_id TEXT NOT NULL REFERENCES sheets(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'not_called',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lead_id, sheet_id)
);

-- Create notes table to store notes for each lead
CREATE TABLE IF NOT EXISTS notes (
  id SERIAL PRIMARY KEY,
  lead_id TEXT NOT NULL,
  sheet_id TEXT NOT NULL REFERENCES sheets(id) ON DELETE CASCADE,
  note TEXT DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lead_id, sheet_id)
);

-- Create settings table for app-wide settings
CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Disable RLS since this is a shared app without user authentication
-- All users should be able to read and write data
ALTER TABLE sheets ENABLE ROW LEVEL SECURITY;
ALTER TABLE call_statuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Create policies to allow all operations for anonymous users
CREATE POLICY "Allow all operations on sheets" ON sheets FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on call_statuses" ON call_statuses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on notes" ON notes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on settings" ON settings FOR ALL USING (true) WITH CHECK (true);
