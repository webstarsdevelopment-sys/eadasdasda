-- Drop all tables with CASCADE to handle dependencies
DROP TABLE IF EXISTS settings CASCADE;
DROP TABLE IF EXISTS call_statuses CASCADE;
DROP TABLE IF EXISTS notes CASCADE;
DROP TABLE IF EXISTS sheets CASCADE;

-- Create sheets table
CREATE TABLE sheets (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create settings table
CREATE TABLE settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  active_sheet_id TEXT,
  filter_duplicates BOOLEAN DEFAULT true,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create call_statuses table
CREATE TABLE call_statuses (
  lead_id TEXT PRIMARY KEY,
  status TEXT NOT NULL DEFAULT 'not_called',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create notes table
CREATE TABLE notes (
  lead_id TEXT PRIMARY KEY,
  note TEXT DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on all tables
ALTER TABLE sheets ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE call_statuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

-- Create policies for anonymous access (shared data for all users)
CREATE POLICY "Allow all on sheets" ON sheets FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on settings" ON settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on call_statuses" ON call_statuses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on notes" ON notes FOR ALL USING (true) WITH CHECK (true);

-- Insert default settings row
INSERT INTO settings (id, active_sheet_id, filter_duplicates) VALUES (1, NULL, true);
